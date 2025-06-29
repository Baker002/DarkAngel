
local DA=LibStub("AceAddon-3.0"):GetAddon("DarkAngel")
local L = LibStub("AceLocale-3.0"):GetLocale("DarkAngel")
local LGT=LibStub:GetLibrary('LibGroupTalents-1.0')

local working=false
local targetn=nil
local countererrors=0
DA.TR_Names={}
DA.flasker_bulk={}
DA.TR_SelSet=1
local TR_allprestack

local function getFlaskNames()
	local listflasks={}
	if DarkAngel_FlaskDB[DA.TR_SelSet] then
		local f=DarkAngel_FlaskDB[DA.TR_SelSet]
		for _,i in pairs({'Flask','Potion','Dops'}) do
			for _,j in pairs({'tank','heal','meel','rdd'}) do
				if f[i] and f[i][j] and f[i][j][1] and f[i][j][2] and f[i][j][2]>0 then 
					listflasks[f[i][j][1]]=true
				end 
			end
		end
	else
		print('error 36')
		return
	end
	
	return listflasks
end

local function canmakenewstack(flask,count)
	for b=0,4 do 
		for s=1,GetContainerNumSlots(b) do 
			local l=GetContainerItemLink(b,s)
			if l and l:find(flask) then
				if select(2,GetContainerItemInfo(b,s))>count and not select(3,GetContainerItemInfo(b,s)) then
					return true
				end
			end
			
			if (b==4 and s==GetContainerNumSlots(b)) then 
				if countererrors>10 then
				else
					countererrors=countererrors+1
					DA.Print(L["|cffa82222we're running out of"].." \"|cffddffff"..flask.."\"")
					if countererrors>10 then 
						DA.Print(L['these notifications are muted now']) 
					end
				end
				return false
			end
		end 
	end 
end

local function obtainbigstack(inputTable,flask)
	local result
	for _, item in ipairs(inputTable) do
		if not result then
			result={item[1],item[2],item[3]}
		elseif item[1]>result[1] then
			result={item[1],item[2],item[3]}
		end
	end
	
	if result and result[2] then
		return result[2],result[3]
	elseif countererrors>10 then
	else
		countererrors=countererrors+1
		DA.Print(L["|cffa82222we're running out of"].." \"|cffddffff"..flask.."\"")
		if countererrors>10 then DA.Print(L['these notifications are muted now']) end

	end

end

local function removeExactDuplicates(inputTable)
	local seen = {}
	local outputTable = {}

	for _, item in ipairs(inputTable) do
		local itemStr = table.concat(item, ",")
		if not seen[itemStr] then
			table.insert(outputTable, item)
			seen[itemStr] = true
		end
	end

	return outputTable
end

local function TR_reset(closeonstacked)
	targetn=nil
	TR_allprestack(closeonstacked)
end

local function TR_groupup()
	
	for flaskname in pairs(getFlaskNames()) do
		
		local putbag,putslot
		
		for m=0,4 do 
			for n=1,GetContainerNumSlots(m) do 
				local l=GetContainerItemLink(m,n)
				if l and l:find(flaskname) then
					if not putbag and not putslot then
						putbag=m; putslot=n
					else
						local count=select(2,GetContainerItemInfo(m,n))
						tinsert(DA.flasker_bulk,function() 
							SplitContainerItem(m,n,count)
							PickupContainerItem(putbag,putslot)
						end)
						DA.ResumeTimer('flask_disp')
					end
				end
			end 
		end 
		
	end
end

local function TR_giveflask(flask,count)
	if TradeFrame:IsShown() then
		for b=0,4 do 
			for s=1,GetContainerNumSlots(b) do 
				local l=GetContainerItemLink(b,s)
				if l and l:find(flask) then
					if select(2,GetContainerItemInfo(b,s))==count and not select(3,GetContainerItemInfo(b,s)) then
					UseContainerItem(b, s)
					return "transmitted "..flask.."x"..count
					end
				end
				if (b==4 and s==GetContainerNumSlots(b)) then 
					return "nofound"..flask
				end
			end 
		end 
	end
end

local function TR_lookforspace()
	local freeslots={}
	for b=0,4 do 
		if GetContainerFreeSlots(b)[1] then 
			for x=1,#GetContainerFreeSlots(b) do 
				table.insert(freeslots, {b,GetContainerFreeSlots(b)[x] } )
			end 
		end
	end
	
	if #freeslots>0 then 
		return freeslots
	else
		return false
	end
end

local function TR_makestack(flask,count,putinbag,putinslot,beforetrade)
	local bigstacks={}
	for m=0,4 do 
		for n=1,GetContainerNumSlots(m) do 
			local l=GetContainerItemLink(m,n)
			if l and l:find(flask) then
				if select(2,GetContainerItemInfo(m,n))==count and (beforetrade or not select(3,GetContainerItemInfo(m,n))) then
					return
				elseif select(2,GetContainerItemInfo(m,n))>count then
					tinsert(bigstacks,{select(2,GetContainerItemInfo(m,n)),m,n})
				end
			end
		end 
	end 

	local takefrombag,takefromslot=obtainbigstack(bigstacks,flask)
	if takefrombag and takefromslot then
		SplitContainerItem(takefrombag,takefromslot,count)
		PickupContainerItem(putinbag,putinslot)
		return
	end

end

local function TR_inspect(flask,count,beforetrade)
	for b=0,4 do 
		for s=1,GetContainerNumSlots(b) do 
			local l=GetContainerItemLink(b,s)
			if l and l:find(flask) then
				if select(2,GetContainerItemInfo(b,s))==count then
					if beforetrade or not select(3,GetContainerItemInfo(b,s)) then 	
						return true
					end
				end
			elseif (b==4 and s==GetContainerNumSlots(b)) then 
				return false
			end
		end 
	end 
end

TR_allprestack = function (beforetrade)

	local freespace=TR_lookforspace()
	local queryflasks={}
	if DarkAngel_FlaskDB[DA.TR_SelSet] then
		local f=DarkAngel_FlaskDB[DA.TR_SelSet]
		for _,i in pairs({'Flask','Potion','Dops'}) do
			for _,j in pairs({'tank','heal','meel','rdd'}) do
				if f[i] and f[i][j] and f[i][j][1] and f[i][j][2] and f[i][j][2]>0 and not TR_inspect(f[i][j][1],f[i][j][2],beforetrade) and canmakenewstack(f[i][j][1],f[i][j][2]) then 
					tinsert(queryflasks,{f[i][j][1],f[i][j][2]})
				end 
			end
		end
	else
		print('error 225')
		return
	end



	queryflasks=removeExactDuplicates(queryflasks)
	if #freespace>=#queryflasks then
		for i=1,#queryflasks do
			tinsert(DA.flasker_bulk,function() TR_makestack(queryflasks[i][1],queryflasks[i][2],freespace[i][1],freespace[i][2],beforetrade) end)
		end
		DA.ResumeTimer('flask_disp')
	else
		DA.Print(L["DISPnotenoughtslots"]:gsub('$1',#queryflasks))
		return false
	end

	if #queryflasks==0 then
		return 'set'
	else
		return 'q'
	end
end

local function TR_giveall(role)
	if DarkAngel_FlaskDB[DA.TR_SelSet] then
		for _,i in pairs({'Flask','Potion','Dops'}) do
			if DarkAngel_FlaskDB[DA.TR_SelSet][i][role][1] and DarkAngel_FlaskDB[DA.TR_SelSet][i][role][2] and DarkAngel_FlaskDB[DA.TR_SelSet][i][role][2]>0 then
				TR_giveflask(DarkAngel_FlaskDB[DA.TR_SelSet][i][role][1],DarkAngel_FlaskDB[DA.TR_SelSet][i][role][2])
			end
		end
	else
		print('error 277')
		return
	end
	
end

function DA.TR_routine(_,event,ac1,ac2,...)
	TradePlayerItem6:Show()
	
	if not working then
		return
	end

	if event=="TRADE_CLOSED" then
		targetn=nil
		return
	end

	if event=="TRADE_SHOW" then
		local unitrg=nil
		local clas


		
		targetn=TradeFrameRecipientNameText:GetText()
		if UnitInRaid(targetn) then 
		else 
			DA.Print("  Flask Dispenser:   this gentleman is not in raid") 
			TR_reset('closed') 
			return 
		end
		
		for i=1,40 do
			local ax={GetRaidRosterInfo(i)}
			if ax[1]==targetn then
				local index={}
				for k,v in pairs(DA.TR_Names) do
					index[v]=k
				end
				if index[targetn] then 
					DA.Print("  Flask Dispenser:   "..targetn.."|cffFF0000 already have flask")
					DA.Print("  Flask Dispenser:   "..targetn.."|cffFFaaaa already have flask")
					TradePlayerItem6:Hide()
					TR_reset()
					return 
				else
					clas=ax[6]
					unitrg="raid"..i
					break
				end
			end
		end
		
		if not fuckingOptions_g[DA_CurrentGuild].dispenser_gmembers or (FEP_gMain[targetn] or FEP_L_gMain[DA_CurrentGuild][targetn]) then
			local role=nil
			local microrole=LGT:GetUnitRole(unitrg)
			
			if microrole=='tank' then
				role="tank"
				if (clas=="DEATHKNIGHT" and not UnitAura(unitrg, L['Frost Presence'] )) then
					SendChatMessage(L["DAdonotforgetbuff"]:gsub('$1',GetSpellLink(48263)), "WHISPER",nil,targetn)
				elseif (clas=="PALADIN" and not UnitAura(unitrg, L['Righteous Fury'] )) then
					SendChatMessage(L["DAdonotforgetbuff"]:gsub('$1',GetSpellLink(25780)), "WHISPER",nil,targetn)
				end
			elseif microrole=='healer' then
				role="heal"
			elseif microrole=='melee' then
				role="meel"
			elseif microrole=='caster' then
				role="rdd"
			else
				DA.Print(microrole)
				DA.Print(L['failed to detect specialization'])
				return
			end
			
			local quickgive=TR_allprestack('show')
		
			if quickgive=='set' then
				if TradeFrame:IsShown() then TR_giveall(role) end
			elseif quickgive=='q' then
				tinsert(DA.flasker_bulk,function()  end)
				tinsert(DA.flasker_bulk,function()  end)
				tinsert(DA.flasker_bulk,function()
					TR_allprestack()
					tinsert(DA.flasker_bulk,function()  end)
					tinsert(DA.flasker_bulk,function()  end)
					tinsert(DA.flasker_bulk,function() if TradeFrame:IsShown() then TR_giveall(role) end end)
				end)
				DA.ResumeTimer('flask_disp')
			elseif not quickgive then
				TR_reset('closed')
				return
			end
		else
			DA.Print(targetn.." -"..L["is not in guild"])
		end

	end

	if (event=="TRADE_ACCEPT_UPDATE" and ac1==1 and ac2==1 and targetn) then
		local index={}
		for k,v in pairs(DA.TR_Names) do
			index[v]=k
		end
			if index[targetn] then TR_reset() return end
		table.insert(DA.TR_Names,targetn)
		
		if fuckingOptions_g[DA_CurrentGuild].dispenser_print then DA.Print(L["dispensed "]..targetn) end
		if fuckingOptions_g[DA_CurrentGuild].dispenser_rsay then SendChatMessage("# "..L["dispensed "]..targetn,'RAID') end
		if fuckingOptions_g[DA_CurrentGuild].dispenser_gsay then SendChatMessage("# "..L["dispensed "]..targetn,'GUILD') end
		
		TR_reset()
		return
	end

	if event=="TRADE_REQUEST_CANCEL" then
		TR_reset('closed')
		return
	end

end
local gt = CreateFrame("Frame")
gt:SetScript("OnEvent", DA.TR_routine)

function DA.TR_start(mod)

if DarkAngel_FlaskDB[mod] then else DA.Print("error 364") end

	
if working and DA.TR_SelSet==mod then 
	DA.Print(L["already working"])
	return
elseif not working or (working and DA.TR_SelSet~=mod) then 

	if working and DA.TR_SelSet~=mod then
		DA.TR_Names=nil
		DA.TR_Names={}
		DA.Print(L["starting distribution from another set..."])
	end
	DA.TR_SelSet=mod
	
	
	local quickgive=TR_allprestack('show')
	if quickgive then
		gt:RegisterEvent("TRADE_ACCEPT_UPDATE")
		gt:RegisterEvent("TRADE_SHOW")
		gt:RegisterEvent("TRADE_CLOSED")
		gt:RegisterEvent("TRADE_REQUEST_CANCEL")
		DA.TR_Names={}
		if quickgive=='set' then
			working=true
			if fuckingOptions_g[DA_CurrentGuild].dispenser_announce then SendChatMessage(L['You can trade me for flasks!'],'raid') else DA.Print("|cff00ffff    Ready.")  end
			if fuckingOptions_g[DA_CurrentGuild].dispenser_markself then 
				if UnitIsRaidOfficer('player') then
					SetRaidTarget('player',fuckingOptions_g[DA_CurrentGuild].dispenser_markself_n)
				else
					DA.Print(L["cant mark myself, not a raid officer"])
				end
			end
			
			if TradeFrame:IsShown() then 
				DA.TR_routine(nil,'TRADE_SHOW') 
			end
		elseif quickgive=='q' then
			tinsert(DA.flasker_bulk,function()  end)
			tinsert(DA.flasker_bulk,function()  end)
			tinsert(DA.flasker_bulk,function()  
				TR_allprestack()
				tinsert(DA.flasker_bulk,function()  end)
				tinsert(DA.flasker_bulk,function()  end)
				tinsert(DA.flasker_bulk,function() 
					working=true
					
					if fuckingOptions_g[DA_CurrentGuild].dispenser_announce then SendChatMessage(L['You can trade me for flasks!'],'RAID') else DA.Print("|cff00ffff    Ready.") end
					if fuckingOptions_g[DA_CurrentGuild].dispenser_markself then 
						if UnitIsRaidOfficer('player') then
							SetRaidTarget('player',fuckingOptions_g[DA_CurrentGuild].dispenser_markself_n)
						else
							DA.Print(L["cant mark myself, not a raid officer"])
						end
					end
					if TradeFrame:IsShown() then DA.TR_routine(nil,'TRADE_SHOW') end 
				end)
			end)
			DA.ResumeTimer('flask_disp')
		end
		
		DA.ResumeTimer('flask_disp')
		
	end
	

end


 

end

function DA.TR_stop()
	if working==true then

		working=false
		countererrors=0
		gt:UnregisterEvent("TRADE_ACCEPT_UPDATE")
		gt:UnregisterEvent("TRADE_SHOW")
		gt:UnregisterEvent("TRADE_CLOSED")
		gt:UnregisterEvent("TRADE_REQUEST_CANCEL")
		if fuckingOptions_g[DA_CurrentGuild].dispenser_print_results and #DA.TR_Names>0 then 
			DA.Print(L["Distribution of flasks is completed! Got flasks"].." ["..#DA.TR_Names.."] :")
			DA.Print(table.concat(DA.TR_Names," "))
		end
		
		if fuckingOptions_g[DA_CurrentGuild].dispenser_rsay_results and #DA.TR_Names>0 then 
			SendChatMessage(L["Distribution of flasks is completed! Got flasks"].." ["..#DA.TR_Names.."] :","RAID")
			local result = DA.ConcatStr(DA.TR_Names,255," ")
			for _, str in ipairs(result) do
				SendChatMessage(str,'RAID')
			end
		end
		
		if fuckingOptions_g[DA_CurrentGuild].dispenser_gsay_results and #DA.TR_Names>0 then 
			SendChatMessage(L["Distribution of flasks is completed! Got flasks"].." ["..#DA.TR_Names.."] :","GUILD")
			local result = DA.ConcatStr(DA.TR_Names,255," ")
			for _, str in ipairs(result) do
				SendChatMessage(str,'GUILD')
			end
		end
		
		DA.TR_Names={}
		if fuckingOptions_g[DA_CurrentGuild].dispenser_items_grp then
			DA.Print(L["Grouping-up items"])
			TR_groupup()
			tinsert(DA.flasker_bulk,function()
				tinsert(DA.flasker_bulk,function() TR_groupup() end) 
				tinsert(DA.flasker_bulk,function() tinsert(DA.flasker_bulk,function() DA.StopTimer('flask_disp') end) end)
				
			end)
			DA.ResumeTimer('flask_disp')
		
			
		end
	end
end
