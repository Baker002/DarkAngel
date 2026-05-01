
---@class DarkAngelAddon
local DA = DarkAngel
local L = LibStub("AceLocale-3.0"):GetLocale("DarkAngel")
local Mod = DA:NewModule("Logger")


function DA.Logger_rewrite_Gopt()

	DarkAngel_FD[DA_CurrentGuild]=DarkAngel_FD[DA_CurrentGuild] or {}
	DA_StoredGChat[DA_CurrentGuild]=DA_StoredGChat[DA_CurrentGuild] or {}
	DarkAngel_JRN[DA_CurrentGuild]=DarkAngel_JRN[DA_CurrentGuild] or {}
	DA_Leavers[DA_CurrentGuild]=DA_Leavers[DA_CurrentGuild] or {}
	
end

local FFDecayCount

local function GetTimestamp2()
	return time()/60
end
local function FDCutStoredText()
	if #DA_StoredGChat[DA_CurrentGuild]>0 then else return end
	local mytime
	if DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' and fuckingOptions_g[DA_CurrentGuild].warn_improv_suspic then
		mytime=GetTimestamp2()-150
	else
		mytime=GetTimestamp2()
	end
	
	
	for i=#DA_StoredGChat[DA_CurrentGuild],1,-1 do
		if DA_StoredGChat[DA_CurrentGuild][i] and type(DA_StoredGChat[DA_CurrentGuild][i])=='table' and mytime-DA_StoredGChat[DA_CurrentGuild][i].stamp>3.5 then
			table.remove(DA_StoredGChat[DA_CurrentGuild],i)
		end
	end
end
local function Fcheckleavers()
	
if not DA_CurrentGuild or DA_CurrentGuild==0 or DA_CurrentGuild=='0' then return end

local time_cap=time()-fuckingOptions_g[DA_CurrentGuild].storeleavers*86400

	for i,d in pairs(DA_Leavers[DA_CurrentGuild]) do
		if d and d[2] and time_cap>d[2] then
			for p,m in pairs(FEP_L_gMain[DA_CurrentGuild]) do
				if m==i and DA_Leavers[DA_CurrentGuild][m] then
					FEP_L_gMain[DA_CurrentGuild][p]=nil
					DA.Print(L['deleted local']..' |cff00ffff'..p..'|cffffffff [|cff00ffff'..m..'|cffffffff] '..L['old data'])
					
				end
			end
			DA.Print(L['deleted data']..' |cff00ffff'..i..'|cffffffff [|cff00ffff'..(DA.Log_PlayerOfficerNote(DA_CurrentGuild,i) or "n/a") ..'|cffffffff] '..L['old data'])
			
			DA_Leavers[DA_CurrentGuild][i]=nil
			DarkAngel_FD[DA_CurrentGuild][i]=nil
		end
	end
	for p,m in pairs(FEP_L_gMain[DA_CurrentGuild]) do
		if not DA_Leavers[DA_CurrentGuild][m] and not DarkAngel_FD[DA_CurrentGuild][m] then
			FEP_L_gMain[DA_CurrentGuild][p]=nil
			DA.Print(L['deleted local']..' |cff00ffff'..p..'|cffffffff [|cff00ffff'..m..'|cffffffff], '..L['detoldrecord'])
		end
		if FEP_gMain[p] then
			FEP_L_gMain[DA_CurrentGuild][p]=nil
			DA.Print(L['deleted local']..' |cff00ffff'..p..'|cffffffff [|cff00ffff'..m..'|cffffffff], '..L['detplinguild']..' ( |cff00ffff'..FEP_gMain[p]..'|cffffffff )')
		end
		
		
	end
end
local LogSetAllLines
local LogSetLine
local DetailsSetLine
local DA_LogRoster={}
local DA_DetailsRoster={}
local function CheckIfDecaying()
    local g_s = DA_Guild_Info[DA_CurrentGuild]
    if not (g_s and g_s.lastupdate1 and g_s.decay1 and g_s.base1) then return end

    local decay = g_s.decay1
    local base = g_s.base1

    if GetTimestamp2() - g_s.lastupdate1 >= (1440 * fuckingOptions.Decaydays + 2.2) then
        return
    end

    local lbase = {}
    local lbasenum = 0

	local ntype = DA.DecodeNote
	for k = 1, DA.GetNumGMembers() do
		local name, _, _, _, _, _, _, note = GetGuildRosterInfo(k)
		if name and note and note ~= "" then
			if ntype(note) == "m" or ntype(note) == "f" then
				lbase[name] = note
				lbasenum = lbasenum + 1
			end
		end
	end

    local matches = 0
    local matchLimit = math.min(30, lbasenum / 4)

    for player, note in pairs(lbase) do
        local newtype, newep, newgp = ntype(note)
        local fd = DarkAngel_FD[DA_CurrentGuild][player]

        if fd and fd.o and #fd.o > 0 then
            local oldNote = fd.o[#fd.o][1]
            if note ~= oldNote then
                local oldtype, oldep, oldgp = ntype(oldNote)

                if (oldtype == "m" or oldtype == "f") and not (oldtype == "f" and newtype == "f") then
                    local oldepDecay = oldep * decay
                    local oldgpDecay = (oldgp + base) * decay

                    if (newep < oldep or (newep == oldep and oldep == 0)) and math.abs(oldep - oldepDecay - newep) <= 2 and 
                       (newep < oldep or (newgp == oldgp and oldgp == 0)) and math.abs(oldgp - oldgpDecay - newgp) <= 2 then
                        matches = matches + 1
                        if matches >= matchLimit then
                            FFDecayCount = 0
                            return
                        end
                    end
                end
            end
        end
    end
end

local function GetColorEPGPdiff(name,fold,fnew)
	-- local old="0,0"
	-- local new="0,0"
	-- if fold then old=fold else old=DA.Log_PlayerOfficerNote(DA_CurrentGuild,name,#DarkAngel_FD[DA_CurrentGuild][name].o-1) end
	-- if fnew then new=fnew else new=DA.Log_PlayerOfficerNote(DA_CurrentGuild,name) end
	if fold=="_na1" or fold==nil or fnew=="_na1" or fnew==nil or not DarkAngel_FD[DA_CurrentGuild][name] or not DarkAngel_FD[DA_CurrentGuild][name].o or select(1,DA.DecodeNote(fold))=="t"  or select(1,DA.DecodeNote(fnew))=="t" then
		return {}
	end
	
	local otyp,oldep,oldgp=DA.DecodeNote(fold)
	local ntyp,newep,newgp=DA.DecodeNote(fnew)
	if (otyp=='m' or otyp=='f') and (ntyp=='m' or ntyp=='f') then else
		return {}
	end
	local textep=newep-oldep
	local textgp=newgp-oldgp
	local base=DA_Guild_Info[DA_CurrentGuild].base1
	local decay=DA_Guild_Info[DA_CurrentGuild].decay1
	
	if FFDecayCount then
		textep=math.ceil(newep-(oldep-oldep*decay))
		textgp=math.ceil(newgp-(oldgp-(oldgp+base)*decay))
	end
	local colorep="|r"
	local colorgp="|r"
	if not FFDecayCount and oldep==newep then
		textep="0"
		colorep=textep
	else 
		if FFDecayCount then
			if newep-(oldep-oldep*decay)>2 then
				colorep="|cffffffffd|cffaaffff"..textep.."|r"
			elseif  (oldep-oldep*decay)-newep>2 then
				colorep="|cffffffffd|cffff00ff"..textep.."|r"
			elseif math.abs(oldep-oldep*decay-newep)<=2 then
				colorep="|cffffffffcl.|r"
			end
		else
			if newep-oldep>0 then 
				colorep=" |cffaaffff"..textep.."|r"
			else 
				colorep=" |cffff00ff"..textep.."|r"
			end
		end
	end
	if not FFDecayCount and oldgp==newgp then
		textgp="0"
		colorgp=textgp
	else 
		if FFDecayCount then
			if math.abs(oldgp-(oldgp+base)*decay-newgp)<=2 or (oldgp-(oldgp+base)*decay)<=2 and oldgp-(oldgp+base)*decay-newgp<=2 then 
				colorgp="|cffffffffcl.|r"
			elseif  (oldgp-(oldgp+base)*decay)-newgp>2 then
				colorgp="|cffffffffd|cffff0000"..textgp.."|r"
			elseif newgp-(oldgp-(oldgp+base)*decay)>2 then
				colorgp="|cffffffffd|cffedf500"..textgp.."|r"
			end
		else
			if newgp-oldgp>0 then 
				colorgp="|cffedf500"..textgp.."|r"
			else 
				colorgp="|cffff0000"..textgp.."|r"
			end
		end
	end
	
	return {colorep , colorgp}
	
end

function DA.OpenLogSearch(...) 
	DarkAngelGUI:Show()
	_G['DarkAngelGUI']['Detailsbtn']:Click('LeftButton',true)
	_G['DarkAngelGUI']['Detailsbtn']:Click('LeftButton',false)
	DarkAngelGUI.Details.SearchEB:SetText(...)
	DA.RunLogSearch(DarkAngelGUI.Details.SearchEB:GetText())
end
local function getallcompsfor(key,person)

	local result={}
	
	if key=='o' then
		
		local prev_data
		for _,entry in ipairs(person) do
			if not prev_data then
				tinsert(result,false)
				prev_data=entry[1]
			else
				local new_data=entry[1]
				
				local otyp,oldep,oldgp=DA.DecodeNote(prev_data)
				local ntyp,newep,newgp=DA.DecodeNote(new_data)
				if (otyp=='m' or otyp=='f') and (ntyp=='m' or ntyp=='f') then 
					local textep=newep-oldep
					local textgp=newgp-oldgp
					
					local colorep=""
					local colorgp=""
					
					if textep==0 then
						colorep="0"
					elseif textep>0 then 
						colorep=" |cffaaffff"..textep.."|r"
					else 
						colorep=" |cffff00ff"..textep.."|r"
					end
					
					if textgp==0 then
						colorgp="0"
					elseif textgp>0 then 
						colorgp=" |cffedf500"..textgp.."|r"
					else 
						colorgp=" |cffff0000"..textgp.."|r"
					end
					
					tinsert(result,{colorep,colorgp})
					prev_data=new_data
				else
					tinsert(result,false)
					prev_data=new_data
				end
				
			end
		end

	elseif key=='r' then
	
		local prev_data
		local prev_r_name
		for _,entry in ipairs(person) do
			if not prev_data then
				tinsert(result,false)
				prev_data=entry[1][1]
				prev_r_name=entry[1][2]
			else
				local new_r_ID=entry[1][1]
				local new_r_name=entry[1][2]
				
				tinsert(result,{"|cfff0f0f0[|cff00ffff"..prev_data.."|cfff0f0f0]"..prev_r_name , "|cfff0f0f0[|cff00ffff"..new_r_ID.."|cfff0f0f0]"..new_r_name , new_r_ID>prev_data and " |cffedf500-> " or " |cff00ffff-> "})
				
				
				prev_data=new_r_ID
				prev_r_name=new_r_name
				
			end
		end
	end
	return result
end
local function getMergedEntries(guild, name)
    local result = {}
    local person = DarkAngel_FD[guild] and DarkAngel_FD[guild][name]
    if not person then return result end
	local settings=fuckingOptions_g[DA_CurrentGuild]
    
	local keys = {}
		
	if settings.DCB_rank then
		tinsert(keys, "r")
	end
	if settings.DCB_note then
		tinsert(keys, "n")
	end
	if settings.DCB_offnote then
		tinsert(keys, "o")
	end
		tinsert(keys, "s")
    local indices = {}
    local sources = {}
    local origins = {}
    local comparation = {}
    for _, key in ipairs(keys) do
		local pk=person[key]
		local l=#pk
        if pk and l > 0 then
            table.insert(sources, pk)
            table.insert(indices, l)
            table.insert(origins, key)
			if ((key=='o' and settings.Log_offnote==2) or (key=='r' and settings.Log_rank==2)) and l > 1 then
				table.insert(comparation, getallcompsfor(key, pk))
			else
				table.insert(comparation, false)
			end
        end
    end

    while true do
        local max_t = -math.huge
        local max_sources = {}

        for i, subtable in ipairs(sources) do
            local idx = indices[i]
            if idx > 0 then
                local entry = subtable[idx]
                if entry[2] and entry[2].t then
                    local t = entry[2].t
                    if t > max_t then
                        max_t = t
                        max_sources = {i}
                    elseif t == max_t then
                        table.insert(max_sources, i)
                    end
                end
            end
        end
		
        if #max_sources == 0 then break end

        for _, max_source in ipairs(max_sources) do
            local origin_entry = sources[max_source][indices[max_source]]
            table.insert(result, {
                origin_entry[1],
                origin_entry[2],
                addit = origin_entry.addit,
                typ = origins[max_source],
				comp = comparation[max_source] and comparation[max_source][indices[max_source]]
            })

            indices[max_source] = indices[max_source] - 1
        end
    end

    return result
end
function DA.RunLogSearch(name)
	if DA_CurrentGuild then else DA.Print("not in guild, baaaka") return end
	if name=="" or name==" " or name=="." then return end

	DA.RegatherGuildNotes()

	local fc, ofs = name:match("([%z\1-\127\194-\244][\128-\191]*)()");
	name = fc:upper()..name:sub(ofs):lower()


	if not DarkAngel_FD[DA_CurrentGuild] then 
		DarkAngelDetails:Hide()
		DarkAngelGUI.Details.notific:SetText("No such guild found")
		DarkAngelGUI.Details.notific:Show()
		return
	elseif not DarkAngel_FD[DA_CurrentGuild][name] then
		DarkAngelDetails:Hide()
		DarkAngelGUI.Details.notific:SetText("player not found")
		DarkAngelGUI.Details.notific:Show()
		return
	else
		DarkAngelGUI.Details.notific:SetText("")
		DarkAngelGUI.Details.notific:Hide()
		DarkAngelDetails:Show()
	end

	local Gathered=getMergedEntries(DA_CurrentGuild,name)
	DetailsSetLine(Gathered)

end

local function val_isEmpty(v)
	return not v or v == "" or v == "0" or v == " " or v == "." or v == 0
end
local function Log_PlayerStatus(guild,name)
	return DarkAngel_FD[guild][name].s[(#(DarkAngel_FD[guild][name].s))][1]
end
function DA.Log_PlayerOfficerNote(guild, name)
			
    local playerData = DarkAngel_FD[guild] and DarkAngel_FD[guild][name]
    if not playerData or not playerData.o then
        return nil
    end

    local targetIndex = #playerData.o
	
	if targetIndex==0 then
		return nil
    elseif val_isEmpty(playerData.o[targetIndex][1]) then
        return "0,0"
    else
        return playerData.o[targetIndex][1]
    end
end
local function Log_PlayerNote(guild, name)
    local playerData = DarkAngel_FD[guild] and DarkAngel_FD[guild][name]
    if not playerData or not playerData.n then
        return ""
    end

    local targetIndex = #playerData.n

    if targetIndex==0 then
		return nil
    elseif not playerData.n[targetIndex] then
        return ""
    else
        return playerData.n[targetIndex][1]
    end
end
local function Log_PlayerRank(guild, name)
    local playerData = DarkAngel_FD[guild] and DarkAngel_FD[guild][name]
    if not playerData or not playerData.r then
        return nil
    end

    local targetIndex = #playerData.r

    if targetIndex==0 then
		return nil
    elseif not playerData.r[targetIndex] then
        return nil
    else
        return playerData.r[targetIndex][1]
    end
end
local function Log_GetGuildInfo(typ)
	local t = DA_Guild_Info[DA_CurrentGuild].LogINFO[typ]
    local count = #t

    if count==0 then
		return nil
    else
        return t[count][1]
    end
end

local function GetOnlineGuildOfficerslist()
	local RanksNote={}
	local RanksOffNote={}
	for i=1,GuildControlGetNumRanks() do
		GuildControlSetRank(i)
		local _,_,_,_,_,_,_,_,_, edit_public_note,_, edit_officer_note, _ = GuildControlGetRankFlags()
		if edit_public_note then
			RanksNote[i-1]=true
		end
		if edit_officer_note then
			RanksOffNote[i-1]=true
		end
	end

	local list_note={}
	local list_offnote={}

	for i=1,DA.GetNumGMembers() do
		local name, _, rankIndex, _, _, _, _, _, online, _, _ = GetGuildRosterInfo(i);
		if online then
			if RanksNote[rankIndex] then
				tinsert(list_note, name)
			end
			if RanksOffNote[rankIndex] then
				tinsert(list_offnote, name)
			end
		end
	end
	
	local cN = #list_note
	if cN == 0 then 
		list_note=false
	elseif cN > 8 then 
		list_note = "<too many possible authors>"
	elseif cN == 1 then
		--keeping table structure
	else
		list_note = table.concat(list_note, ", ")
	end
	
	local cO = #list_offnote
	if cO == 0 then 
		list_offnote=false
	elseif cO > 8 then 
		list_offnote = "<too many possible authors>"
	else
		list_offnote = table.concat(list_offnote, ", ")
	end
	
	return list_note, list_offnote
end
local function GetRankChangeAuthor(name,finalrank)
	if GetNumGuildEvents() and GetNumGuildEvents()>0 then
		for i=GetNumGuildEvents(),1,-1 do
			local typ,author,character,rankname=GetGuildEventInfo(i)
			if (typ=='promote' or typ=='demote') and character==name and finalrank==rankname then
				return {'rank_def',author}
			end
		
		end
	end
	
	return nil
end
local function filterReasons(reasons, epdif)
	local found = false

	for i = #reasons, 1, -1 do
		local entry = reasons[i]
		if entry[2] == epdif then
			if not found then
				found = true -- keep the first one
			else
				table.remove(reasons, i)
			end
		end
	end
	return reasons
end
local function TransLegitCheck(name,epdif,gpdif)

	local author='|cffff0000unknown'
	local tvinspool={}
	if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
		for pl,main in pairs(FEP_gMain) do
			if main==name then
			tvinspool[pl]=true
			end	
		end
	elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
		
		for pl,main in pairs(FEP_gMain) do
			if main==name or (string.lower(main)==main and DA.capitalizeFirstCharacter(main)==name) then
			tvinspool[pl]=true
			end	
		end
	end
	tvinspool[name]=true
	
	if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
		local eplogcounter=0
		local epmsgcounter=0
		local gplogcounter=0
		local gpmsgcounter=0
		
		--chat
		for j=#DA_StoredGChat[DA_CurrentGuild],1,-1 do
		local jk=DA_StoredGChat[DA_CurrentGuild][j]
			if epdif and jk.typ=="EP" and tvinspool[jk.name] and jk.logtype=='chat' then
				epmsgcounter=epmsgcounter+jk.gain
				author=jk.author
			end
			if gpdif and jk.typ=="GP" and tvinspool[jk.name] and jk.logtype=='chat'  then
				gpmsgcounter=gpmsgcounter+jk.gain
				author=jk.author
			end
			
			if epmsgcounter==epdif and gpmsgcounter==gpdif then
				break
			end
		end
		
		--cmds
		local reasons={}
		for j=#DA_StoredGChat[DA_CurrentGuild],1,-1 do
		local jk=DA_StoredGChat[DA_CurrentGuild][j]
			if epdif and jk.typ=="EP" and tvinspool[jk.name] and jk.logtype=='cmd' then
				eplogcounter=eplogcounter+jk.gain
				author=jk.author
				if jk.reason then
					tinsert(reasons,{jk.reason,jk.gain,0})
				end
			end
			if gpdif and jk.typ=="GP" and tvinspool[jk.name] and jk.logtype=='cmd'  then
				gplogcounter=gplogcounter+jk.gain
				author=jk.author
				if jk.reason then
					tinsert(reasons,{jk.reason,0,jk.gain})
				end
			end
			
			if eplogcounter==epdif and gplogcounter==gpdif then
				break
			end
		end
		
		if #reasons==0 then
			reasons=nil
		end
		if (epmsgcounter==epdif and eplogcounter==epdif) and (gpmsgcounter==gpdif and gplogcounter==gpdif) then
			return 'both',author,reasons
		elseif epmsgcounter==epdif and gpmsgcounter==gpdif then
			return 'msg',author
		elseif eplogcounter==epdif and gplogcounter==gpdif then
			return 'log',author,reasons
		end
		
	elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
		local dkpwhcounter=0
		local dkppubl_allcounter=0
		local dkppublcounter=0
		local dkp_DA_counter=0
		
		--DA cmds
		local reasons={}
		for j=#DA_StoredGChat[DA_CurrentGuild],1,-1 do
			local jk=DA_StoredGChat[DA_CurrentGuild][j]
			if epdif and tvinspool[jk.name] and jk.logtype=='cmd' then
				dkp_DA_counter=dkp_DA_counter+jk.gain
				author=jk.author
				if jk.reason then
					tinsert(reasons,{jk.reason,jk.gain})
				end
			end
			if dkp_DA_counter==epdif then
				break
			end
		end
		
		--whispers
		if tvinspool[UnitName('player')] then
			for j=#DA_StoredGChat[DA_CurrentGuild],1,-1 do
				local jk=DA_StoredGChat[DA_CurrentGuild][j]
				if epdif and jk.typ=="dkp_pm" and jk.author and jk.gain then
					dkpwhcounter=dkpwhcounter+jk.gain
					author=jk.author
					if jk.reason then
						tinsert(reasons,{jk.reason,jk.gain})
					end
				end
				
				if dkpwhcounter==epdif then
					break
				end
			end
		end
		
		--guild chat
		for j=#DA_StoredGChat[DA_CurrentGuild],1,-1 do
			local jk=DA_StoredGChat[DA_CurrentGuild][j]
			if epdif and jk.typ=="dkp_all" and jk.author and jk.gain then
				dkppubl_allcounter=dkppubl_allcounter+jk.gain
				author=jk.author
				if jk.reason then
					tinsert(reasons,{jk.reason,jk.gain})
				end
			end
			if epdif and jk.typ=="dkp_all_p" and jk.author and jk.gain and jk.persona and tvinspool[jk.persona] then
				dkppublcounter=dkppublcounter+jk.gain
				author=jk.author
				if jk.reason then
					tinsert(reasons,{jk.reason,jk.gain})
				end
			end
			
			if dkppubl_allcounter==epdif or dkppublcounter==epdif then
				break
			end
		end
		
		if #reasons==0 then
			reasons=nil
		else
			reasons = filterReasons(reasons)
		end

		if dkp_DA_counter==epdif then
			return 'both',author,reasons
		elseif (dkpwhcounter==epdif or dkppubl_allcounter==epdif or dkppublcounter==epdif) 
			or (epdif==dkpwhcounter+dkppubl_allcounter) 
			or (epdif==dkpwhcounter+dkppublcounter) 
			or (epdif==dkppubl_allcounter+dkppublcounter) 
			or (epdif==dkppubl_allcounter+dkpwhcounter+dkppublcounter) 
			then
			return 'both',author,reasons
		elseif dkp_DA_counter==epdif then
			return 'log',author,reasons
		end
	end
	
	return false
end

local function GetPlayerScanLink(text)
	return "|cffffff00|Hdalogsrch:" .. text .. "|h<"..text..">|h|r"
end

local function docheck(name,oldep,oldgp,newep,newgp,officers)
	local epdif,gpdif
	if tonumber(oldep) and tonumber(newep) then
		epdif=newep-oldep
	end
	if tonumber(oldgp) and tonumber(newgp) then
		gpdif=newgp-oldgp
	end
	
	local checked,author,reasons = TransLegitCheck(name,epdif,gpdif)
	if not checked then
		if fuckingOptions_g[DA_CurrentGuild].warnsuspic then
			DA.Print(L['detmanchange'] .. GetPlayerScanLink(name)) 
		end
		return {'off_unkn',officers, reasons=reasons}
	elseif checked=='both' then
		return {'officer',author, reasons=reasons}
	elseif checked=='log' then
		return {'officer_cmd',author, reasons=reasons}
	elseif checked=='msg' or checked=='dkp' then
		return {'off_alm',author,officers, reasons=reasons}
	end
end
local function TransLegitAdditionals(name,oldtyp,oldep,oldgp,newtyp,newep,newgp,officers)

	if (oldtyp==newtyp and (oldtyp=='m' or oldtyp=='f')) or (oldtyp=='m' and newtyp=='f') or (oldtyp=='f' and newtyp=='m') then
		return docheck(name,oldep,oldgp,newep,newgp,officers)
	elseif oldtyp==newtyp and oldtyp=='t' or oldtyp~=newtyp then
		return {'off_unkn',officers}
	end
	
end
local function CheckWhoInvited(name)
	if GetNumGuildEvents() and GetNumGuildEvents()>0 then
		for i=GetNumGuildEvents(),1,-1 do
			local typ,author,character=GetGuildEventInfo(i)
			if typ=='invite' and character==name then
				return {'invite',author}
			end
		
		end
	end
	
	return nil
end
local function CheckWhoKicked(name)
	if GetNumGuildEvents() and GetNumGuildEvents()>0 then
		for i=GetNumGuildEvents(),1,-1 do
			local typ,author,character=GetGuildEventInfo(i)
			if typ=='remove' and character==name then
				return {'kick',author}
			end
		
		end
	end
	
	return nil
end

local GN_added   = "|cff69bf78"
local GN_removed = "|cffbf6969"
local GN_reset   = "|r"
local function utf8_chars(str)
    local chars = {}
    for uchar in str:gmatch("[\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    return chars
end
local function lcs_table(oldSeq, newSeq)
    local m, n = #oldSeq, #newSeq
    local lcs = {}
    for i = 0, m do lcs[i] = {} end
    for i = 0, m do for j = 0, n do lcs[i][j] = 0 end end
    for i = 1, m do
        for j = 1, n do
            if oldSeq[i] == newSeq[j] then
                lcs[i][j] = lcs[i-1][j-1] + 1
            else
                lcs[i][j] = math.max(lcs[i-1][j], lcs[i][j-1])
            end
        end
    end
    return lcs
end
local function char_diff(oldWord, newWord)
    local oldChars = utf8_chars(oldWord)
    local newChars = utf8_chars(newWord)
    local lcs = lcs_table(oldChars, newChars)

    local result = {}
    local i, j = #oldChars, #newChars

    while i > 0 or j > 0 do
        if i > 0 and j > 0 and oldChars[i] == newChars[j] then
            table.insert(result, 1, oldChars[i])
            i = i - 1
            j = j - 1
        elseif j > 0 and (i == 0 or lcs[i][j-1] >= lcs[i-1][j]) then
            table.insert(result, 1, GN_added .. newChars[j] .. GN_reset)
            j = j - 1
        elseif i > 0 then
            table.insert(result, 1, GN_removed .. oldChars[i] .. GN_reset)
            i = i - 1
        end
    end

    return table.concat(result)
end
local function count_char_differences(a, b)
    local ca = utf8_chars(a)
    local cb = utf8_chars(b)
    local diff = 0
    local len = math.max(#ca, #cb)
    for i = 1, len do
        if ca[i] ~= cb[i] then
            diff = diff + 1
        end
    end
    return diff
end
local function is_similar(a, b)
    local maxLen = math.max(#a, #b)
    if maxLen == 0 then return true end
    local diff = count_char_differences(a, b)
    return (diff / maxLen) <= 0.4  -- allow 40% difference to be considered "modification"
end
local function word_diff(oldStr, newStr)
    local oldWords = { strsplit(" ", oldStr or "") }
    local newWords = { strsplit(" ", newStr or "") }
    local lcs = lcs_table(oldWords, newWords)

    local result = {}
    local i, j = #oldWords, #newWords

    while i > 0 or j > 0 do
        if i > 0 and j > 0 and oldWords[i] == newWords[j] then
            table.insert(result, 1, oldWords[i])
            i = i - 1
            j = j - 1
        elseif i > 0 and j > 0 and is_similar(oldWords[i], newWords[j]) then
            -- close enough to be treated as a modification
            table.insert(result, 1, char_diff(oldWords[i], newWords[j]))
            i = i - 1
            j = j - 1
        elseif j > 0 and (i == 0 or lcs[i][j-1] >= lcs[i-1][j]) then
            table.insert(result, 1, GN_added .. newWords[j] .. GN_reset)
            j = j - 1
        elseif i > 0 then
            table.insert(result, 1, GN_removed .. oldWords[i] .. GN_reset)
            i = i - 1
        end
    end

    return table.concat(result, " ")
end
local function GetGuildNoteDiff(oldNote, newNote)
	if oldNote == "" then 
		return GN_added..newNote..GN_reset
	elseif newNote == "" then
		return GN_removed..oldNote..GN_reset
	end
	
	local strippedOld = oldNote:gsub("\n"," ¤")
	local strippednew = newNote:gsub("\n"," ¤")
	
	local result = word_diff(strippedOld, strippednew)
	
	
    return tostring(result:gsub("¤","\n"))
end

local function checkingSameDataOnDecay(logged,actual)
	if not FFDecayCount then
		if logged == actual then
			return true
		else
			return nil
		end
	end

	local oldtyp,oldep,oldgp=DA.DecodeNote(logged)
	local newtyp,newep,newgp=DA.DecodeNote(actual) 

	if oldtyp==newtyp and newtyp=='t' and oldep==newep then
		return true
	end

	return nil
end
local function ScanCompare(db,firstrun)
	if DA.guild_info_found==false and FFDecayCount and (not DA_Guild_Info[DA_CurrentGuild].base1 or not DA_Guild_Info[DA_CurrentGuild].decay1) then
		DA.Print("Guild Decay detected, I havent found any |cffed94edEPGP|r Decay settings in Guild Info. ")
		DA.Print("|cffff5555No Decay settings storred locally, Decay comparation disabled. |r")
		FFDecayCount=false
			
	elseif DA.guild_info_found==false and FFDecayCount and DA_Guild_Info[DA_CurrentGuild].base1 and DA_Guild_Info[DA_CurrentGuild].decay1 then
		DA.Print("Guild Decay detected, I havent found any |cffed94edEPGP|r Decay settings in Guild Info. ")
		DA.Print("|cff55ffffChecking using local stored settings.|r")
		DA.guild_info_found=true
		
	end
	
	local jr = DarkAngel_JRN[DA_CurrentGuild]
	local tmstmp
	local isonlinechange
	local curtime=time()
		local dat,tim=string.match(date(), "(.+)%s(.+)")
		if DA_Guild_Info[DA_CurrentGuild].lastupdate1 and GetTimestamp2()-DA_Guild_Info[DA_CurrentGuild].lastupdate1<2.2 then
			isonlinechange=true
		end
		if isonlinechange then
			tmstmp= {true,dat,tim, t=curtime}
		else
			tmstmp= {false,dat,tim, t=curtime}
		end
	local cn = DA.GetStoredColorName
	local cepd = GetColorEPGPdiff
	local log_offn = DA.Log_PlayerOfficerNote
		local minlog=fuckingOptions_g[DA_CurrentGuild].minlog
		local time_cap=time()-fuckingOptions_g[DA_CurrentGuild].cleanlogonceper
		local opt_offnote = fuckingOptions_g[DA_CurrentGuild].Log_offnote
		local opt_note = fuckingOptions_g[DA_CurrentGuild].Log_note
		local opt_rank = fuckingOptions_g[DA_CurrentGuild].Log_rank
		local can_see_officer=CanViewOfficerNote()
	
	if db then
		local noteofficers, listofofficers = GetOnlineGuildOfficerslist()
			if noteofficers then
				if type(noteofficers)=='table' then
					noteofficers = {'officer_cmd',noteofficers[1]}
				else
					noteofficers = {'off_unkn',noteofficers}
				end
			end
		for player,val in pairs(db) do
			-- print(player, val.o, val.n , val.r[1], val.r[2])
			if not val.o or val.o=="" or val.o==0 or val.o=="0" or val.o==" " or val.o=="." then
				val.o = "0,0"
			end
			
			local fd = DarkAngel_FD[DA_CurrentGuild][player]
			
			if fd then
				
				do --checking status
					if Log_PlayerStatus(DA_CurrentGuild,player)=="left guild" or DA_Leavers[DA_CurrentGuild][player] then 
						if DA_Leavers[DA_CurrentGuild][player] then 
							DA_Leavers[DA_CurrentGuild][player]=nil 
						end
						table.insert(jr, {'rejoin', 	player,tmstmp})
						table.insert(fd.s, {'re-joined', tmstmp ,addit=CheckWhoInvited(player)})
					end
					local tblsize=#fd.s
					if tblsize<=1 or tblsize<=minlog then
					elseif tblsize>minlog then
						if time_cap >= fd.s[1][2].t then
							table.remove(fd.s,1)
						end
					end
				end
				
				do --checking Officer_note
					if not opt_offnote then
						table.wipe(fd.o)
					elseif can_see_officer then
						local officernote=log_offn(DA_CurrentGuild,player)
							
						if not officernote then
							--new logging method started, adding value without writing journal
							table.insert(fd.o, {val.o, tmstmp})
						elseif checkingSameDataOnDecay(officernote,val.o) then
						else
							local oldtyp,oldep,oldgp=DA.DecodeNote(officernote)
							local newtyp,newep,newgp=DA.DecodeNote(val.o) 
							
							
							if opt_offnote==2 then
								table.insert(fd.o, {val.o, tmstmp, addit=isonlinechange and TransLegitAdditionals(player,oldtyp,oldep,oldgp,newtyp,newep,newgp,listofofficers)})
								
							elseif opt_offnote==1 then
								table.wipe(fd.o)
								tinsert(fd.o,{val.o, tmstmp, addit=isonlinechange and TransLegitAdditionals(player,oldtyp,oldep,oldgp,newtyp,newep,newgp,listofofficers)})
							end
							if (newtyp=='f' or oldtyp=='f') and not (oldtyp=='t' or newtyp=='t') then
								
								if newtyp=='f' or oldtyp=='f' then
									table.insert(jr, {
										(
											(newtyp=='f' and oldtyp=='f' and 'fc')
											or (newtyp=='f' and 'f')
											or (oldtyp=='f' and 'uf')
										),
										player,tmstmp,cepd(player,oldep..','..oldgp,newep..','..newgp),        total=val.o})
								end
								
							else
								if newtyp=='t' or oldtyp=='t' then
									
									if newtyp=='t' and oldtyp=='t' then --re-tvinked
										table.insert(jr, {'rt', player,tmstmp,note='Main change |cffffffff'..cn(oldep)..'|r --> |cffffffff'..cn(val.o).."|r"})
									elseif newtyp=='t' then
										if oldep==0 and oldgp==0 then --tvinked
											table.insert(jr, {'t',player,tmstmp,note='n/a --> Tvin |cffffffff' .. val.o})
										elseif oldep<501 and oldgp<100 then --junk tvinked
											table.insert(jr, {'jmt',player,tmstmp,note='Junk Main --> Tvin|r',      total=cn(val.o)})
										else --main tvinked
											table.insert(jr, {'mt',player,tmstmp,note='|cffff9999Main --> Tvin|r',      total=cn(val.o)})
										end
									elseif oldtyp=='t' then
										if newtyp=='m' then
											table.insert(jr, {'tm',player,tmstmp,note='|cffff9999Tvin --> Main|r',      total=cn(val.o)})
										elseif newtyp=='f' then
											table.insert(jr, {'tfm',player,tmstmp,note='|cffff9999Tvin --> Frozen Main|r',      total=cn(val.o)})
										end
									end
								elseif newtyp=='m' and oldtyp=='m' then
									if FFDecayCount then
										local a,b=unpack(cepd(player,officernote,val.o))
										if fuckingOptions.decaygroup and a:find('cffffffffcl') and b:find('cffffffffcl') then
											FFDecayCount=FFDecayCount+1
										else
											table.insert(jr, {'decay',player,tmstmp,cepd(player,officernote,val.o),        total=val.o})
										end
										
									else
										table.insert(jr, {'ch',player,tmstmp,cepd(player,officernote,val.o),        total=val.o})
									end
								end
							end

							
						end
						local tblsize=#fd.o
						if tblsize<=1 or tblsize<=minlog then
						elseif tblsize>minlog then
							if time_cap >= fd.o[1][2].t then
								table.remove(fd.o,1)
							end
						end
					end
				end
				
				do --checking Note
					if not opt_note then
						table.wipe(fd.n)
					else
						local note=Log_PlayerNote(DA_CurrentGuild,player)
						
						if not note then --new logging method started, adding value without writing journal
							table.insert(fd.n, {val.n, tmstmp, addit=isonlinechange and noteofficers})
						elseif note==val.n then
						else
							if opt_note==2 then
								table.insert(fd.n, {val.n, tmstmp, addit=isonlinechange and noteofficers})
							elseif opt_note==1 then
								table.wipe(fd.n)
								tinsert(fd.n, {val.n, tmstmp, addit=isonlinechange and noteofficers})
							end

							if note:gsub("%s+","")=="" then
								table.insert(jr, {'note',player,tmstmp,note=GN_added .. val.n})
							elseif not val.n or val.n:gsub("%s+","")=="" then
								table.insert(jr, {'note',player,tmstmp,note=GN_removed .. note})
							else
								table.insert(jr, {'note',player,tmstmp,note=GetGuildNoteDiff(note,val.n)})
							end
						end
						local tblsize=#fd.n
						if tblsize<=1 or tblsize<=minlog then
						elseif tblsize>minlog then
							if time_cap >= fd.n[1][2].t then
								table.remove(fd.n,1)
							end
						end
					end
				end
				 
				do --checking rank
					if not opt_rank then
						table.wipe(fd.r)
					else
						local rank=Log_PlayerRank(DA_CurrentGuild,player)
						local rankName = rank and rank[2]
						if not rank then
							--new logging method started, adding value without writing journal
							table.insert(fd.r, {val.r, tmstmp, addit=GetRankChangeAuthor(player,rankName)})
						elseif rank[1]==val.r[1] then
						else
							if opt_rank==2 then
								table.insert(fd.r, {val.r, tmstmp, addit=GetRankChangeAuthor(player,rankName)})
							elseif opt_rank==1 then
								table.wipe(fd.r)
								tinsert(fd.r,{val.r, tmstmp, addit=GetRankChangeAuthor(player,rankName)})
							end
							if rank[1]>val.r[1] then -- Promoting
								table.insert(jr, {'rank',player,tmstmp,note="|cfff0f0f0"..rank[2] .." |cff00ffff->|cfff0f0f0 " .. val.r[2]})
							else -- Demoting
								table.insert(jr, {'rank',player,tmstmp,note="|cfff0f0f0"..rank[2] .." |cffedf500->|cfff0f0f0 " .. val.r[2]})
							end
							
						end
						local tblsize=#fd.r
						if tblsize<=1 or tblsize<=minlog then
						elseif tblsize>minlog then
							if time_cap >= fd.r[1][2].t then
								table.remove(fd.r,1)
							end
						end
					end
				end
			
				
				
			else
				do--inserting new player profile
					fd={
						s={{firstrun and 'seen' or 'new', tmstmp ,addit=CheckWhoInvited(player)}},
						o={},
						n={},
						r={},
						
					}
					DarkAngel_FD[DA_CurrentGuild][player]=fd
					
						if opt_offnote then
							tinsert(fd.o,{ val.o, tmstmp })
						end
						
						if opt_note then
							tinsert(fd.n,{ val.n, tmstmp })
						end

						if opt_rank then
							tinsert(fd.r,{ val.r, tmstmp })
						end
					
					if firstrun then 
					else
						table.insert(jr, {'new', 	player,tmstmp, total=cn(val.o)})
					end
				end
			end
		end

	else
		if not firstrun then
		
			local l1, l2, l3 = GetNetStats()
			if not l1 or not l2 or not l3 or l1==0 or l2==0 or l3==0 then
				return
			end
				
			for i,_ in pairs(DarkAngel_FD[DA_CurrentGuild]) do
				if i then 
					if not FEP_gMain[i] and not DA_Leavers[DA_CurrentGuild][i] then
						local val=log_offn(DA_CurrentGuild,i)
						
						if fuckingOptions.prntleav then 
							if DA.DecodeNote(val)=='t' then
								DA.Print("F "..GetPlayerScanLink(i)..' twink '..GetPlayerScanLink(val))
							else
								DA.Print("F "..GetPlayerScanLink(i)..' ['..val..']')
							end
						end
						if val=="" or val==0 or val=="0" or val==" " or val=="." or not val then
							val="0,0"
						end 
						
						table.insert(DarkAngel_FD[DA_CurrentGuild][i].s, {"left guild",  tmstmp, addit=CheckWhoKicked(i)})
						DA_Leavers[DA_CurrentGuild][i]={date(),curtime}
						table.insert(jr, {'Leaver',i,tmstmp,       total=cn(val)})
					end
				end
			end
			if FFDecayCount and fuckingOptions.decaygroup and FFDecayCount>0 then
				local base=DA_Guild_Info[DA_CurrentGuild].base1
				local decay=DA_Guild_Info[DA_CurrentGuild].decay1
				table.insert(jr, {'decay', nil,tmstmp,note="|cffaaccff"..FFDecayCount..'|r players (clear |cffaaccff'..decay*100 ..'%|r/|cffaaccff'..base ..'|rb decay)',        total=nil})
			end
			
			--strip log
			for i=1,10 do
				if jr[1] and time_cap >= jr[1][3].t then
					table.remove(jr,1)
				else
					break
				end
			end
		end
	
		DA_Guild_Info[DA_CurrentGuild].lastupdate1=GetTimestamp2()

	end

end

local function packGMTable(t)
	local result={}
		for i,j in ipairs(t) do
			local microTable = DA.stringToTable(j)
			
			if i==1 then
				local needed = {}
					needed.name = microTable.name
				tinsert(result, needed)
			else
				-- local _,needed = next(microTable)
				tinsert(result, microTable)
			end
		end
	return result
end
local function tables_equal(t1, t2)
    if t1 == t2 then return true end
    if type(t1) ~= "table" or type(t2) ~= "table" then return false end

    -- Check if all keys and values in t1 exist and match in t2
    for k, v in pairs(t1) do
        if not tables_equal(v, t2[k]) then
            return false
        end
    end

    -- Check if t2 has any extra keys not in t1
    for k in pairs(t2) do
        if t1[k] == nil then
            return false
        end
    end

    return true
end
local function getGuildGMTblStrings(t)
	local result={}
		for i,e in ipairs(t) do
			local r = DA.tableToString(e)
			result[i] = r
		end
	return result
end
local re_schedule_CheckGuildInfosChange
local guildInfoChecksSinceLoaded = 0
local function CheckGuildInfosChange(scheduled, onlchange_PassedState)
	local optTbl = fuckingOptions_g[DA_CurrentGuild]
	local tmstmp
	local isonlinechange
	local curtime=time()
	local minlog=fuckingOptions_g[DA_CurrentGuild].minlog
	local time_cap=curtime-fuckingOptions_g[DA_CurrentGuild].cleanlogonceper

	local GMTable
	if optTbl.Log_GM then
		GMTable=DA.GetGuilGMSettings()
	end
	

	local dat,tim=string.match(date(), "(.+)%s(.+)")
	if scheduled then
		isonlinechange=onlchange_PassedState
		guildInfoChecksSinceLoaded = 9
	elseif DA_Guild_Info[DA_CurrentGuild].LogINFO.lastupdate1 and GetTimestamp2()-DA_Guild_Info[DA_CurrentGuild].LogINFO.lastupdate1<2.2 then
		isonlinechange=true
	end
	if not scheduled and guildInfoChecksSinceLoaded < 3 then
		local gInf = DA.GetGuildInfoTextCached()
		local motd = DA.GetGuildRosterMOTDCached()
		guildInfoChecksSinceLoaded = guildInfoChecksSinceLoaded + 1

		local missing = {}
		if optTbl.Log_ginfo and (not gInf or gInf == "") then
			table.insert(missing, "Guild Info")
		end
		if optTbl.Log_gmotd and (not motd or motd == "") then
			table.insert(missing, "Guild MOTD")
		end
		if optTbl.Log_GM and (not GMTable or not next(GMTable)) then
			table.insert(missing, "Guild Ranks")
		end
		if optTbl.Log_GM and (
			not GMTable
			or not GMTable[2]
			or not GMTable[2].bankpermissions
			or not next(GMTable[2].bankpermissions)
		) then
			table.insert(missing, "Guild Bank Permissions")
		end
		if #missing > 0 then
			re_schedule_CheckGuildInfosChange(isonlinechange)
			DA.Print("[Debug]: Guild data not loaded  -> " .. table.concat(missing, ", ") .. ". Check rescheduled.")
			return
		end

	end
	
	if isonlinechange then
		tmstmp= {true,dat,tim, t=curtime}
	else
		tmstmp= {false,dat,tim, t=curtime}
	end
	
	local jr = DarkAngel_JRN[DA_CurrentGuild]
	
	
	for _,t in ipairs({
		{"Log_ginfo", "info", DA.GetGuildInfoTextCached, 'ginfo',{
			L["Guild Information added"],
			L["Guild Information removed"],
			L["Guild Information changed"]}},
		{"Log_gmotd", "motd", DA.GetGuildRosterMOTDCached, 'gmotd',{
			L["Message of the day added"],
			L["Message of the day removed"],
			L["Message of the day changed"]}}
	}) do
		local opt = optTbl[t[1]]
		local short = t[2]
		local func = t[3]
		local J_short = t[4]
		local J_msg = t[5]
		
		local DB = DA_Guild_Info[DA_CurrentGuild].LogINFO[short]
		
		if not opt then
			table.wipe(DB)
		else
			local value = func()
			local note = Log_GetGuildInfo(short)
			
			if not note then --new logging method started, adding value without writing journal
				table.insert(DB, {value, tmstmp})
			elseif note==value then
			else
				local isNewOrDeletion
				if note:gsub("%s+","")=="" then
					table.insert(jr, {J_short,nil,tmstmp,note=J_msg[1]})
					isNewOrDeletion=true
				elseif not value or value:gsub("%s+","")=="" then
					table.insert(jr, {J_short,nil,tmstmp,note=J_msg[2]})
					isNewOrDeletion=true
				else
					table.insert(jr, {J_short,nil,tmstmp,note=J_msg[3]})
				end
				
				
				if opt==1 then
					table.wipe(DB)
				end
				table.insert(DB, {
					value, 
					tmstmp,
					not isNewOrDeletion and (GetGuildNoteDiff(note,value)) or nil
				})
			end
			local tblsize=#DB
			if tblsize<=1 or tblsize<=minlog then
			elseif tblsize>minlog then
				if time_cap >= DB[1][2].t then
					table.remove(DB,1)
				end
			end
		end
	
	end
	
	
	local opt = optTbl.Log_GM
	local short = "gm"
	local J_short = '_GM'
	
	local DB = DA_Guild_Info[DA_CurrentGuild].LogINFO[short]
	
	if not opt then
		table.wipe(DB)
	else
		local value = getGuildGMTblStrings(GMTable)
		local note = Log_GetGuildInfo(short)
		
		if not note then --new logging method started, adding value without writing journal
			table.insert(DB, {value, tmstmp})
		elseif tables_equal(note,value) then
		else
			
			local COMP = {"{"}
			local actions = {}
			local count_Curr = #value
			local count_Log = #note

			local ch_counter = 0
			local add_counter = 0
			local rem_counter = 0

			for x = 1, math.max(count_Curr, count_Log) do
				local e_val = value[x]
				local e_log = note[x]


				if e_val and e_log then
					if not tables_equal(e_val, e_log) then
						actions[x] = 'change'
						ch_counter = ch_counter + 1
					end
				elseif e_log then
					actions[x] = 'deletion'
					rem_counter = rem_counter + 1
				elseif e_val then
					actions[x] = 'addition'
					add_counter = add_counter + 1
				end
			end

			for x = 1, math.max(count_Curr, count_Log) do
				local act = actions[x]
				if value[x] and act == 'addition' then
					tinsert(COMP, '    ['..x..'] = "'..GN_added .. value[x] ..'|r",')
				elseif note[x] and act == 'deletion' then
					tinsert(COMP, '    ['..x..'] = "'..GN_removed .. note[x] .. '|r",')
				elseif note[x] and value[x] and act == 'change' then
					tinsert(COMP, '    ['..x..'] = "'..GetGuildNoteDiff(note[x], value[x])..'|r",')
				elseif not act and note[x] then
					tinsert(COMP, '|r    ['..x..'] = "'..note[x]..'|r",')
				end
			end
			tinsert(COMP, "|r}")

			local journal_text = {}
			if ch_counter > 0 then
				tinsert(journal_text, tostring(L["gm_changes_in"]:gsub("$1", ch_counter)))
			end
			if add_counter > 0 then
				tinsert(journal_text, tostring(L["gm_additions_in"]:gsub("$1", add_counter)))
			end
			if rem_counter > 0 then
				tinsert(journal_text, tostring(L["gm_removals_in"]:gsub("$1", rem_counter)))
			end


			table.insert(jr, {J_short, nil, tmstmp, note = table.concat(journal_text, ". ")})

			if opt == 1 then
				table.wipe(DB)
			end

			table.insert(DB, {
				value,
				tmstmp,
				table.concat(COMP, "\n")
			})


		end
		
		
		local tblsize=#DB
		if tblsize<=1 or tblsize<=minlog then
		elseif tblsize>minlog then
			if time_cap >= DB[1][2].t then
				table.remove(DB,1)
			end
		end
	end
	
	DA_Guild_Info[DA_CurrentGuild].LogINFO.lastupdate1=GetTimestamp2()
end

re_schedule_CheckGuildInfosChange = function(passedState)
	DA.TimerAfter(60, function() CheckGuildInfosChange('scheduled', passedState) end)
end
local function IsGINFOLoggingRequired()
	local optTbl = fuckingOptions_g[DA_CurrentGuild]
	for _,opt in ipairs({
	"Log_ginfo",
	"Log_gmotd",
	"Log_GM"})
	do
		if optTbl[opt] then
			return true
		end
	end
	return false
end
function Mod:StartScan()

	if DA_CurrentGuild~="n0-guild" then else return end
	if ({GetGuildInfo("player")})[1] then else return end
	if not DA.GuildInfoFetched then return end

	QueryGuildEventLog()

	local DA_gRoster=DA.RegatherGuildNotes(true)
	
	FDCutStoredText()
	
	local batch_size = 20
	local names_tbl = {}

	for key in pairs(DA_gRoster) do
		table.insert(names_tbl, key)
	end
	
	DA.guild_info_found=false
	FFDecayCount=false
	local firstrun=true
	for i,_ in pairs(DarkAngel_FD[DA_CurrentGuild]) do
		if i then firstrun=false break end
	end
	if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' and fuckingOptions_g[DA_CurrentGuild].do_decay_checks then
		tinsert(DA_Scaner_bulk,function() DA.CheckEPGPGuildInfo() end)
		tinsert(DA_Scaner_bulk,function() 
			QueryGuildEventLog()
			if not firstrun and DA_Guild_Info[DA_CurrentGuild].base1 and DA_Guild_Info[DA_CurrentGuild].decay1 then 
			CheckIfDecaying() 
			end 
		end)
	end
	
	
	while #names_tbl > 0 do
		local batch = {}

		for i = 1, batch_size do
			local key = table.remove(names_tbl)
			if not key then break end
			batch[key] = DA_gRoster[key]
		end

		if next(batch) then
			tinsert(DA_Scaner_bulk, function() ScanCompare(batch,firstrun) end)
		end
	end
	if next(DA_Scaner_bulk) then
		tinsert(DA_Scaner_bulk,function() ScanCompare(nil,firstrun);FFDecayCount=false end)
	end
	
	if firstrun then
		tinsert(DA_Scaner_bulk,function() 
			local numpl=0
			for i,_ in pairs(DarkAngel_FD[DA_CurrentGuild]) do 
				if i then numpl=numpl+1 end
			end
			DA.Print("added |cff00ffff"..numpl.."|cffffffff new players to a database") 
		end)
	else
		tinsert(DA_Scaner_bulk,function() Fcheckleavers() end)
	end
	
	
	if IsGINFOLoggingRequired() then
		tinsert(DA_Scaner_bulk,function() 
			CheckGuildInfosChange()
		end)
	end
	
	tinsert(DA_Scaner_bulk,function() 
	end)
	tinsert(DA_Scaner_bulk,function() 
		if DarkAngelLog:IsShown() then 
			LogSetAllLines()
		end
		
		if DarkAngelDetails:IsShown() then 
			DA.RunLogSearch(DarkAngelGUI.Details.SearchEB:GetText()) 
		end 
	end)
	
	DA.ResumeTimer('scaner')
end

local Log_Create_ScrollBar
local Details_Create_ScrollBar
function Mod.Logger_Load()
	
	local function SetFontColor(widget, state)
		if not widget or not widget.font then return end
		if state == 2 then
			widget.font:SetTextColor(0.45, 1, 1, 1)
		elseif state == 1 then
			widget.font:SetTextColor(0.85, 1, 1, 1)
		else
			widget.font:SetTextColor(0.6, 0.6, 0.6, 0.6)
		end
	end
	
	
	local function Try(msg, patterns)
		for _, entry in ipairs(patterns) do
			local pat = type(entry) == "table" and entry[1] or entry
			local a, b, c, d, e = msg:match(pat)
			if a then return entry, a, b, c, d, e end
		end
	end
	local function StripDKPPrefix(msg)
		return msg:gsub("^QDKP2?>%s", "")
	end
	local function StripEPGPPrefix(msg)
		return msg:gsub("^QDKP2?>%s", "")
	end
	local function stripDKPbankFromWhisper(msg)
		return msg:gsub("%.%sYour%snew%snet%sDKP%samount.+", "")
	end
	
	local DKP = {}
	do	--dkp message parser
		
		DKP.patterns = {
			raidAward = {
				-- EN
				{ "^Online%sRaid%smembers%sreceived%s(%-?%d+)%sDKP%sfor%s(.+)$", true },
				{ "^Raid%smembers%sreceiv%a*%s(%-?%d+)%sDKP$", false },

				-- RU
				{ "^Участники%sрейда%sполучили%s(%-?%d+)%sDKP%sза%s(.+)$", true },
				{ "^Участники%sрейда%sполучили%s(%-?%d+)%sDKP$", false },

				-- FR (correct)
				{ "^Les%smembres%sdu%sraid%sconnectés%sreçoivent%s(%-?%d+)%sDKP%spour%s(.+)$", true },
				{ "^Les%smembres%sdu%sraid%sconnectés%sreçoivent%s(%-?%d+)%sDKP$", false },

				-- FR (typo: menmbres)
				{ "^Les%smenmbres%sdu%sraid%sconnectés%sreçoivent%s(%-?%d+)%sDKP%spour%s(.+)$", true },
				{ "^Les%smenmbres%sdu%sraid%sconnectés%sreçoivent%s(%-?%d+)%sDKP$", false },

				-- FR (singular: membre)
				{ "^Les%smembre%sdu%sraid%sconnectés%sreçoivent%s(%-?%d+)%sDKP%spour%s(.+)$", true },
				{ "^Les%smembre%sdu%sraid%sconnectés%sreçoivent%s(%-?%d+)%sDKP$", false },

			},

			purchase = {
				-- EN
				{"^(.-)%s+%(([^()]+)%)%s+Purchases%s+(.+)%s+for%s+(%-?%d+)%s+DKP$",true},
				{"^(.-)%s+Purchases%s+(.+)%s+for%s+(%-?%d+)%s+DKP$"},

				-- RU
				{"^(.-)%s+%(([^()]+)%)%s+Покупает%s+(.+)%s+за%s+(%-?%d+)%s+DKP$",true},
				{"^(.-)%s+Покупает%s+(.+)%s+за%s+(%-?%d+)%s+DKP$"}
			},

			spends = {
				guild={
					{"^(.-)%s+%(([^()]+)%)%s+Spends%s+(%-?%d+)%s+DKP%sfor%s(.+)$", true, true},
					{"^(.-)%s+%(([^()]+)%)%s+Spends%s+(%-?%d+)%s+DKP$", true},
					{"^(.-)%s+Spends%s+(%-?%d+)%s+DKP%sfor%s(.+)$", false, true},
					{"^(.-)%s+Spends%s+(%-?%d+)%s+DKP$"},
					
					{"^(.-)%s+%(([^()]+)%)%s+Тратит%s+(%-?%d+)%s+DKP%sза%s(.+)$", true, true},
					{"^(.-)%s+%(([^()]+)%)%s+Тратит%s+(%-?%d+)%s+DKP$", true},
					{"^(.-)%s+%(([^()]+)%)%s+Тратит%s+(%-?%d+)%s+DKP%sза%s(.+)$", false, true},
					{"^(.-)%s+%(([^()]+)%)%s+Тратит%s+(%-?%d+)%s+DKP$"},
					
					{"^(.-)%s+%(([^()]+)%)%s+Dépense%s+(%-?%d+)%s+DKP%spour%s(.+)$", true, true},
					{"^(.-)%s+%(([^()]+)%)%s+Dépense%s+(%-?%d+)%s+DKP$", true},
					{"^(.-)%s+%(([^()]+)%)%s+Dépense%s+(%-?%d+)%s+DKP%spour%s(.+)$", false, true},
					{"^(.-)%s+%(([^()]+)%)%s+Dépense%s+(%-?%d+)%s+DKP$"}
				},

				whisper ={
					{"^Spends%s+(-?%d+)%s+DKP%sfor%s(.+)$", true},
					{"^Spends%s+(-?%d+)%s+DKP$"},
					
					{"^Тратит%s+(-?%d+)%s+DKP%sза%s(.+)$", true},
					{"^Тратит%s+(-?%d+)%s+DKP$"},
					
					{"^Dépense%s+(-?%d+)%s+DKP%spour%s(.+)$", true},
					{"^Dépense%s+(-?%d+)%s+DKP$"}
				}
			},
			gains = {
				guild={
					{"^(.-)%s+%(([^()]+)%)%s+Gains%s+(%-?%d+)%s+DKP%sfor%s(.+)$", true, true},
					{"^(.-)%s+%(([^()]+)%)%s+Gains%s+(%-?%d+)%s+DKP$", true},
					{"^(.-)%s+Gains%s+(%-?%d+)%s+DKP%sfor%s(.+)$", false, true},
					{"^(.-)%s+Gains%s+(%-?%d+)%s+DKP$"},
					
					{"^(.-)%s+%(([^()]+)%)%s+Получает%s+(%-?%d+)%s+DKP%sза%s(.+)$", true, true},
					{"^(.-)%s+%(([^()]+)%)%s+Получает%s+(%-?%d+)%s+DKP$", true},
					{"^(.-)%s+%(([^()]+)%)%s+Получает%s+(%-?%d+)%s+DKP%sза%s(.+)$", false, true},
					{"^(.-)%s+%(([^()]+)%)%s+Получает%s+(%-?%d+)%s+DKP$"},
					
					{"^(.-)%s+%(([^()]+)%)%s+Gagne%s+(%-?%d+)%s+DKP%spour%s(.+)$", true, true},
					{"^(.-)%s+%(([^()]+)%)%s+Gagne%s+(%-?%d+)%s+DKP$", true},
					{"^(.-)%s+%(([^()]+)%)%s+Gagne%s+(%-?%d+)%s+DKP%spour%s(.+)$", false, true},
					{"^(.-)%s+%(([^()]+)%)%s+Gagne%s+(%-?%d+)%s+DKP$"}
				},

				whisper ={
					{"^Gains%s+(-?%d+)%s+DKP%sfor%s(.+)$", true},
					{"^Gains%s+(-?%d+)%s+DKP$"},
					
					{"^Получает%s+(-?%d+)%s+DKP%sза%s(.+)$", true},
					{"^Получает%s+(-?%d+)%s+DKP$"},
					
					{"^Gagne%s+(-?%d+)%s+DKP%spour%s(.+)$", true},
					{"^Gagne%s+(-?%d+)%s+DKP$"}
				}
			}
		}
		function DKP.ParseRaidAward(msg)
			local entry, amount, reason = Try(msg, DKP.patterns.raidAward)
			if not entry then return end

			return {
				type = "raidAward",
				amount = tonumber(amount),
				reason = entry[2] and reason or nil
			}
		end
		function DKP.ParsePurchase(msg)
			local entry, a, b, c, d = Try(msg, DKP.patterns.purchase)
			if not entry then return end
			
			if a then
				return {
					type = "purchase",
					nick = entry[2] and b or a,
					reason = entry[2] and c or b,
					amount = entry[2] and tonumber(d) or tonumber(c)
				}
			end
		end
		function DKP.ParseSpends(msg, isWhisper)
			
			if isWhisper then
				local entry, amount, reason = Try(msg, DKP.patterns.spends.whisper)
				if not entry then return end

				return {
					type = "spends",
					amount = tonumber(amount),
					reason = entry[2] and stripDKPbankFromWhisper(reason) or nil
				}
			end
			local entry, a, b, c, d = Try(msg, DKP.patterns.spends.guild)
			if not entry then return end
			return {
				type = "spends", 
				nick = entry[2] and b or a, 
				amount = entry[2] and tonumber(c) or tonumber(b),
				reason = 
					(entry[3] and entry[2] and d) 
					or (entry[3] and c)
					or nil 
			}
		end
		function DKP.ParseGains(msg, isWhisper)
			if isWhisper then
				local entry, amount, reason = Try(msg, DKP.patterns.gains.whisper)
				if not entry then return end

				return {
					type = "gains",
					amount = tonumber(amount),
					reason = entry[2] and stripDKPbankFromWhisper(reason) or nil
				}
			end

			local entry, a, b, c, d = Try(msg, DKP.patterns.gains.guild)
			if not entry then return end
			return {
				type = "gains", 
				nick = entry[2] and b or a, 
				amount = entry[2] and tonumber(c) or tonumber(b),
				reason = 
					(entry[3] and entry[2] and d) 
					or (entry[3] and c)
					or nil 
			}
		end
		
		function DKP.ParseGuildMsg(msg)
			if not msg:find("^QDKP2?>%s") then
				return
			end
			msg = StripDKPPrefix(msg)

			return
				DKP.ParseRaidAward(msg) or
				DKP.ParsePurchase(msg) or
				DKP.ParseSpends(msg, false) or
				DKP.ParseGains(msg, false)
		end
		function DKP.ParseWhisper(msg)
			if not msg:find("^QDKP2?>%s") then
				return
			end
			msg = StripDKPPrefix(msg)

			return
				DKP.ParseSpends(msg, true) or
				DKP.ParseGains(msg, true)
		end
	end
	
	local EPGP = {}
	do	--epgp message parser
		EPGP.patterns={
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%sto%s(.+)%s%(([^()]+)%)$", true},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%sto%s(.+)$"},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%s\208\180\208\187\209\143%s(.+)%s%(([^()]+)%)$", true},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%s\208\180\208\187\209\143%s(.+)$"},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%sgehen an%s(.+)%s%(([^()]+)%)$", true},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%sgehen an%s(.+)$"},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%sa%s(.+)%s%(([^()]+)%)$", true},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%sa%s(.+)$"},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%s\195\160%s(.+)%s%(([^()]+)%)$", true},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%s\195\160%s(.+)$"},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%s\231\187\153%s(.+)%s%(([^()]+)%)$", true},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%s\231\187\153%s(.+)$"},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%s\231\181\166%s(.+)%s%(([^()]+)%)$", true},
			{"([-,+]?%d+)%s([E,G]P)%s%(([^()]+)%)%s\231\181\166%s(.+)$"}
		}
		function EPGP.Parse(msg)
			local entry, amount, type, reason, n1, n2 = Try(msg, EPGP.patterns)
			if not entry then return end

			return {
				amount = tonumber(amount),
				type = type,
				reason = reason,
				nick = entry[2] and n2 or n1
			}
		end
		function EPGP.ParseGuildMsg(msg)
			if not msg:find("EPGP:%s") then
				return
			end
			msg = StripEPGPPrefix(msg)
			return EPGP.Parse(msg)
		end
	end


	do --log catchers
		local my_name=GetUnitName('player')
		local function split31(str)
			local parts = {}
			for part in string.gmatch(str, "([^%z\031]+)") do
				table.insert(parts, part)
			end
			return unpack(parts)
		end
		local function cmd_catch(_, _, prefix, message, _, author)
			if prefix == "EPGP" then
				if string.sub(message, 0, 4)=="LOG:" then
					if author==my_name then
						DA.SetTimerTime("scan_schedule",3)
					else
						DA.SetTimerTime("scan_schedule",25)
					end
					local _, typ, name, reason, value = split31(message)
					if typ and name and tonumber(value) then
						tinsert(DA_StoredGChat[DA_CurrentGuild],{stamp=GetTimestamp2(),logtype="cmd",	author=author, typ=typ, name=name, gain=tonumber(value), reason=reason})
						table.wipe(DA_Scaner_bulk)
					end
				end
			elseif prefix == "DA_log" then
				if author==my_name then
					DA.SetTimerTime("scan_schedule",3)
				else
					DA.SetTimerTime("scan_schedule",25)
				end
				local name, value, reason = split31(message)
				if name and tonumber(value) then
					tinsert(DA_StoredGChat[DA_CurrentGuild],{stamp=GetTimestamp2(),logtype="cmd",	author=author, name=name, gain=tonumber(value), reason=reason})
					table.wipe(DA_Scaner_bulk)
				end
			end
		end
		local afp = CreateFrame("Frame")
		afp:SetScript("OnEvent", cmd_catch)
		afp:RegisterEvent("CHAT_MSG_ADDON");
		
		
		local function chat_catch(_, event, message, author)

			if message and author then else return end
			
			if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' and event=='CHAT_MSG_GUILD' then
				local data = EPGP.ParseGuildMsg(message)

				if not data then return end

				
				local gain = data.amount
				local typ = data.type
				local reason = data.reason
				local character = data.nick
				if tonumber(gain) and typ and character then
					tinsert(DA_StoredGChat[DA_CurrentGuild],{stamp=GetTimestamp2(),logtype="chat",	author=author, name=character,typ=typ,gain=gain, reason=reason})
					if author==my_name then
						DA.SetTimerTime("scan_schedule",3)
					else
						DA.SetTimerTime("scan_schedule",25)
					end
					table.wipe(DA_Scaner_bulk)
				end
				
			elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
			
				if event=='CHAT_MSG_WHISPER' then
					local data = DKP.ParseWhisper(message)
					
					if not data then return end

					local value = data.amount
					local reason = data.reason
					if data.type == "spends" then
						value = -value
					end
					tinsert(DA_StoredGChat[DA_CurrentGuild],{stamp=GetTimestamp2(),author=author, typ='dkp_pm', gain=value, reason=reason})
					if author==my_name then
						DA.SetTimerTime("scan_schedule",3)
					else
						DA.SetTimerTime("scan_schedule",25)
					end
					table.wipe(DA_Scaner_bulk)
					
				elseif event=='CHAT_MSG_GUILD' then
					local data = DKP.ParseGuildMsg(message)
					
					if not data then return end

					local persona = data.nick
					local value = data.amount
					local reason = data.reason
					if data.type == "purchase" or data.type == "spends" then
						value = -value
					end
					tinsert(DA_StoredGChat[DA_CurrentGuild],{stamp=GetTimestamp2(),author=author, typ=persona and 'dkp_all_p' or 'dkp_all', persona=persona, gain=value, reason=reason})
					if author==my_name then
						DA.SetTimerTime("scan_schedule",3)
					else
						DA.SetTimerTime("scan_schedule",25)
					end
					table.wipe(DA_Scaner_bulk)
					
				end
				
			end
		end
		local dfj = CreateFrame("Frame")
		dfj:SetScript("OnEvent", chat_catch)
		dfj:RegisterEvent("CHAT_MSG_GUILD");
		dfj:RegisterEvent("CHAT_MSG_WHISPER");
	end	

	---- 2 TAB ------
	---- 2 TAB ------
	---- 2 TAB ------
	DA.TabCreater({"TOP",_G["DarkAngelGUI"],"BOTTOMLEFT",90,0},15,30,10,30,"Log",{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},function(self) LogSetAllLines();DA.ResetScrollBoxes() end,function() DA.ResetScrollBoxes() end,[[Interface\AddOns\DarkAngel\template\pict\art_log]])
	do
		-- DA.ScrollBarCreater("DarkAngelLog",DarkAngelGUI.Log,{DarkAngelGUI.Log.width-5, DarkAngelGUI.Log.height-70},{"TOPLEFT", 5, -62})
		Log_Create_ScrollBar()
		DA.HelpCreater(DarkAngelGUI.Log,{"CENTER",DarkAngelGUI.Log,"TOPLEFT",9,-9},'LogHelp',15,15)
			
			DA.CreateFFGButton2(nil,DarkAngelGUI.Log,{"CENTER",DarkAngelGUI.Log,"TOPLEFT",40,-30},12,35,L['refresh'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function() Mod:StartScan() end)
			
			--info/motd details
			do
				DarkAngelGUI.Log.GinfoFrame=DA.FrameCreater(nil,DarkAngelGUI.Log,280,300,{"TOPLEFT",DarkAngelGUI.Log,"TOPRIGHT",2,0})
				DA.CloseButtonCreater(nil,DarkAngelGUI.Log.GinfoFrame,{"TOPRIGHT", DarkAngelGUI.Log.GinfoFrame, "TOPRIGHT", -5,-5},10,10,'x')
				
				DarkAngelGinfoFrame = DA.ScrollBarCreater("DarkAngelGinfoFrame",DarkAngelGUI.Log.GinfoFrame,{DarkAngelGUI.Log.GinfoFrame.width-5, DarkAngelGUI.Log.GinfoFrame.height-30},{"TOPLEFT", 5, -20},1)
				local ginf_Scrolled=DarkAngelGinfoFrame.scrollchild

				local ginf_eb = DA.EditBoxCreater(nil,ginf_Scrolled,{"TOPLEFT", ginf_Scrolled, "TOPLEFT", 5, -2},{250,270},nil,true,false,{UIDarkAngelFontConsolas:GetFont(), 8},
					function(self) 		 self:ClearFocus(); self.focusgained=nil  end,
					nil, --enter here
					function(self) 		 self:ClearFocus(); self.focusgained=nil  end,
					function(self) 	
						self.t:SetBlendMode("BLEND")
						self.focusgained=1
					end,
					nil,nil,nil,1
				)
				
				local comp=DA.CheckBtnCreater(nil,DarkAngelGUI.Log.GinfoFrame,{"CENTER",DarkAngelGUI.Log.GinfoFrame,"TOPLEFT",15,-12},15,15,"compare",function() DarkAngelGUI.Log.GinfoFrame.re_render() end)
				comp:SetChecked(true)
				
				
				local gmpreview = DA.CreateFFGButton2(nil,DarkAngelGUI.Log.GinfoFrame,{"CENTER",DarkAngelGUI.Log.GinfoFrame,"TOPLEFT",130,-12},10,105,'gm editor preview',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},function() 
					
					local entry = DarkAngelGUI.Log.GinfoFrame.tbl
					if not entry then return end
					
					local gc=DarkAngelGUI.Guild.GC
					gc.ranksroster=nil
					gc.ranksroster=packGMTable(entry[1])
					
					gc.finish_import()
					gc:Show()
				end)
				gmpreview:Hide()
				
				
				DarkAngelGUI.Log.GinfoFrame.re_render = function ()
					local entry = DarkAngelGUI.Log.GinfoFrame.tbl
					
					if not entry then return end
					
					if comp:GetChecked() and entry[3] then
						ginf_eb:SetText(entry[3])
					else
						
						if type(entry[1])=='table' then
							ginf_eb:SetText(DA.tableToString(entry[1]))
						else
							ginf_eb:SetText(entry[1])
						end
					end
					DarkAngelGUI.Log.GinfoFrame:Show()
					
					if entry.isgm then
						gmpreview:Show()
					else
						gmpreview:Hide()
					end
				end
				
				
				
			
			end
			
			local copyFrame_Update
			--copy
			do
				DarkAngelGUI.Log.copybtn,DarkAngelGUI.Log.copyFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Log,L["copy"],12,35,{"CENTER",DarkAngelGUI.Log,"TOPLEFT",40,-6},80,175,"TOP",nil,function() copyFrame_Update() end)
				
				local search_patterns={
					{"time", "TimeText"},
					{"type", "TagText"},
					{"name", "plname"},
					{"change", "note"},
					{"value1", "colorEPchange"},
					{"value2", "colorGPchange"},
					{"total", "total"},
					
				}
				
				for i,criteria in pairs(search_patterns) do
					DarkAngelGUI.Log.copyFrame[criteria[1]]=DA.CheckBtnCreater(nil,DarkAngelGUI.Log.copyFrame,{"TOPLEFT", DarkAngelGUI.Log.copyFrame, "TOPLEFT", 10,5-12*i},15,15,criteria[1],function() copyFrame_Update() end)
					if i~=7 then
						DarkAngelGUI.Log.copyFrame[criteria[1]]:SetChecked(true)
					end
				end
				--separator
				do
					DarkAngelGUI.Log.copyFrame.separator=DA.EditBoxCreater(nil,DarkAngelGUI.Log.copyFrame,{"LEFT", DarkAngelGUI.Log.copyFrame, "TOPLEFT", 10, -115},{55,15},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 10},
						function(self) 		self.t:SetBlendMode("add") self:ClearFocus(); self.focusgained=nil;self:HighlightText()  end,
						function(self) 		self.t:SetBlendMode("add") self:ClearFocus(); self.focusgained=nil;self:HighlightText()  end, --enter here
						function(self) 		self.t:SetBlendMode("add") self:ClearFocus(); self.focusgained=nil;self:HighlightText()  end,
						function(self) 	
							if self:GetParent():IsShown() then
								
								self.t:SetBlendMode("BLEND")
								self.focusgained=1
							end
						end,
						function(self)
							if self.focusgained then
								fuckingOptions.lcopyfrsep=self:GetText()
								copyFrame_Update()
							end
						end
					)
					DarkAngelGUI.Log.copyFrame.separator:HighlightText()
					DarkAngelGUI.Log.copyFrame.separator:SetText(fuckingOptions.lcopyfrsep)
					DA.FontCreater(nil,L['separator'],{"LEFT",DarkAngelGUI.Log.copyFrame.separator,"LEFT",-5,13},DarkAngelGUI.Log.copyFrame.separator,15,170,{UIDarkAngelFontConsolas:GetFont(), 8},'left',{0.85,1,1,0.4})
				end
				--numlines
				do
					DarkAngelGUI.Log.copyFrame.numlines=DA.EditBoxCreater(nil,DarkAngelGUI.Log.copyFrame,{"LEFT", DarkAngelGUI.Log.copyFrame, "TOPLEFT", 10, -155},{55,15},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 10},
						function(self) 		self.t:SetBlendMode("add") self:ClearFocus(); self.focusgained=nil; if not tonumber(self:GetText()) or tonumber(self:GetText())<=0 then self:SetText(10) end end,
						function(self) 		self.t:SetBlendMode("add") self:ClearFocus(); self.focusgained=nil; if not tonumber(self:GetText()) or tonumber(self:GetText())<=0 then self:SetText(10) end end, --enter here
						function(self) 		self.t:SetBlendMode("add") self:ClearFocus(); self.focusgained=nil; if not tonumber(self:GetText()) or tonumber(self:GetText())<=0 then self:SetText(10) end end,
						function(self) 	
							if self:GetParent():IsShown() then
								
								self.t:SetBlendMode("BLEND")
								self.focusgained=1
								if not tonumber(self:GetText()) or tonumber(self:GetText())<=0 then self:SetText(10) end 
							end
						end,
						function(self)
							if self.focusgained and tonumber(self:GetText()) and tonumber(self:GetText())>0 then 
								fuckingOptions.lcopyfrnumlines=self:GetText()
								copyFrame_Update()
							end
						end,1
					)
					DarkAngelGUI.Log.copyFrame.numlines:SetText(fuckingOptions.lcopyfrnumlines)
					
					DA.FontCreater(nil,L['lines to print'],{"LEFT",DarkAngelGUI.Log.copyFrame.numlines,"TOPLEFT",-5,5},DarkAngelGUI.Log.copyFrame.numlines,15,170,{UIDarkAngelFontConsolas:GetFont(), 8},'left',{0.85,1,1,0.4})
					
				end
				
				local CopyFrameAdditional=DA.FrameCreater(nil,DarkAngelGUI.Log.copyFrame,499,175,{"BOTTOMLEFT",DarkAngelGUI.Log.copyFrame,"BOTTOMRIGHT"})
				CopyFrameAdditional:Show()
				DA.CloseButtonCreater(nil,DarkAngelGUI.Log.copyFrame,{"TOPRIGHT", CopyFrameAdditional, "TOPRIGHT", -5,-5},10,10,'x',CopyFrameAdditional:GetFrameLevel()+3)
				
				DarkAngelLog_CopyFrame = DA.ScrollBarCreater("DarkAngelLog_CopyFrame",CopyFrameAdditional,{CopyFrameAdditional.width-5, CopyFrameAdditional.height-30},{"TOPLEFT", 5, -20},1)
				local copyfr_Scrolled=DarkAngelLog_CopyFrame.scrollchild

				CopyFrameAdditional.EB=DA.EditBoxCreater(nil,copyfr_Scrolled,{"TOPLEFT", copyfr_Scrolled, "TOPLEFT", 5, -2},{462,390},nil,true,false,{UIDarkAngelFontConsolas:GetFont(), 7},
					function(self) 		 self:ClearFocus(); self.focusgained=nil  end,
					function(self) 		 self:ClearFocus(); self.focusgained=nil  end, --enter here
					function(self) 		 self:ClearFocus(); self.focusgained=nil  end,
					function(self) 	
						self.t:SetBlendMode("BLEND")
						self.focusgained=1
						self:HighlightText()
					end,
					nil,nil,nil,1
				)
				
				
				DA.CreateFFGButton2(nil,CopyFrameAdditional,{"CENTER",CopyFrameAdditional,"TOPLEFT",40,-12},12,50,'print','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},function() 
					copyFrame_Update(1)
				end)
				
				DA.CheckBtnCreater(nil,CopyFrameAdditional,{"CENTER",CopyFrameAdditional,"TOPLEFT",75,-12},15,15,"auto",function(self) fuckingOptions.logcopyauto=(self:GetChecked() or false) end,{'fuckingOptions','logcopyauto'})
				
				
				
				copyFrame_Update = function(manual)
					if not DarkAngelGUI.Log.copyFrame:IsShown() then return end
					if not fuckingOptions.logcopyauto and not manual then return end
					
					local unlocked
					local search={}
					for i,c in pairs(search_patterns) do
						if DarkAngelGUI.Log.copyFrame[c[1]]:GetChecked() then
							unlocked=true
							search[c[2]]=true
						end
					end

					local editbox=CopyFrameAdditional.EB
					local oldtext = editbox:GetText()
					
					if not unlocked then DA.Print(L['select at least one criteria']) return end
					
					local separator=DarkAngelGUI.Log.copyFrame.separator:GetText()
					if not separator or separator == "" then 
						DA.Print("separating data with single spacing")
						separator=" "
					end
					
					

					if not tonumber(fuckingOptions.lcopyfrnumlines) or tonumber(fuckingOptions.lcopyfrnumlines)<=0 then 
						fuckingOptions.lcopyfrnumlines=1000
						DarkAngelGUI.Log.copyFrame.numlines:SetText(fuckingOptions.lcopyfrnumlines)
					end
					
					local result = {}
					
					for i=1,tonumber(fuckingOptions.lcopyfrnumlines) do
						local player = DA_LogRoster[i]
						if player then
							local line = {}
							for _,patt in ipairs(search_patterns) do
								if search[patt[2]] and player[patt[2]] then
									local ss,_ = tostring(player[patt[2]]):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
									tinsert(line, ss)
								end
							end
							if next(line) then
								tinsert(result, table.concat(line, separator))
							end
						end
					end
					
					local newtext = table.concat(result, "\n")
					if oldtext ~= newtext then
						-- editbox:Hide()
						editbox:SetText(newtext)
						-- editbox:Show()
						
					end
					
				end
			
			end
			
			do --search checkboxes
				-- for 
				local newplayerCB=DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",DarkAngelGUI.Log,"TOPLEFT",180,-10},15,15,L["new player"],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_new=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_new','DA_CurrentGuild'})
					DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",newplayerCB,"CENTER",0,-10},15,15,L['deserter'],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_leaver=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_leaver','DA_CurrentGuild'})
					DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",newplayerCB,"CENTER",0,-20},15,15,L["re-joined"],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_rejoin=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_rejoin','DA_CurrentGuild'})

				DarkAngelGUI.Log.offnoteCB=DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",newplayerCB,"CENTER",85,0},15,15,L["officer note"],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_offnote=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_offnote','DA_CurrentGuild'})
					DarkAngelGUI.Log.twinkCB=DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",DarkAngelGUI.Log.offnoteCB,"CENTER",0,-10},15,15,L['twined'],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_tvink=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_tvink','DA_CurrentGuild'})
					DarkAngelGUI.Log.twinksuspCB=DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",DarkAngelGUI.Log.offnoteCB,"CENTER",0,-20},15,15,L["suspic/twin"],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_tvink_susp=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_tvink_susp','DA_CurrentGuild'})
					DarkAngelGUI.Log.decayCB=DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",DarkAngelGUI.Log.offnoteCB,"CENTER",0,-30},15,15,L["decay"],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_decay=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_decay','DA_CurrentGuild'})
					DarkAngelGUI.Log.frozenCB=DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",DarkAngelGUI.Log.offnoteCB,"CENTER",0,-40},15,15,L['frozen'],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_frozen=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_frozen','DA_CurrentGuild'})

				DarkAngelGUI.Log.noteCB=DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",newplayerCB,"CENTER",170,0},15,15,L["note"],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_note=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_note','DA_CurrentGuild'})
					DarkAngelGUI.Log.rankCB=DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",DarkAngelGUI.Log.noteCB,"CENTER",0,-10},15,15,L["rank"],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_rank=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_rank','DA_CurrentGuild'})
					DarkAngelGUI.Log.ginfCB=DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",DarkAngelGUI.Log.noteCB,"CENTER",0,-20},15,15,L["guild info"],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_ginfo=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_ginfo','DA_CurrentGuild'})
					DarkAngelGUI.Log.motdCB=DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",DarkAngelGUI.Log.noteCB,"CENTER",0,-30},15,15,L["guild MOTD"],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_gmotd=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_gmotd','DA_CurrentGuild'})
					DarkAngelGUI.Log.gmCB=DA.CheckBtnCreater(nil,DarkAngelGUI.Log,{"CENTER",DarkAngelGUI.Log.noteCB,"CENTER",0,-40},15,15,L['Guild GM system'],function(self) fuckingOptions_g[DA_CurrentGuild].LCB_GM=(self:GetChecked() or false) LogSetAllLines();copyFrame_Update() end,{'fuckingOptions_g','LCB_GM','DA_CurrentGuild'})

					-- FilterLog()
			end

			local function logReRender()
				for _, j in ipairs({
					{"Log_offnote", "offnoteCB"},
					{"Log_note",    "noteCB"},
					{"Log_rank",    "rankCB"},
					{"Log_ginfo",   "ginfCB"},
					{"Log_gmotd",   "motdCB"},
					{"Log_GM",      "gmCB"},
				}) do
					local key, cbName = j[1], j[2]
					local state = fuckingOptions_g[DA_CurrentGuild][key]

					if key == "Log_offnote" then
						SetFontColor(DarkAngelGUI.Log.offnoteCB, state)
						SetFontColor(DarkAngelGUI.Log.twinkCB, state)
						SetFontColor(DarkAngelGUI.Log.twinksuspCB, state)

						if DA_Guild_Info[DA_CurrentGuild].GuildType == "epgp" then
							SetFontColor(DarkAngelGUI.Log.decayCB, state)
							SetFontColor(DarkAngelGUI.Log.frozenCB, state)
						else
							DarkAngelGUI.Log.decayCB:Hide()
							DarkAngelGUI.Log.frozenCB:Hide()
						end
					else
						SetFontColor(DarkAngelGUI.Log[cbName], state)
					end
				end
			end
			DarkAngelGUI.Log:HookScript("OnShow", logReRender)
			table.insert(DA.RunOnGuildUpdate, logReRender)

	end

	---- 3 TAB ------	
	---- 3 TAB ------	
	---- 3 TAB ------	
	DA.TabCreater({"TOP",_G["DarkAngelGUI"],"BOTTOMLEFT",125,0},15,40,10,55,"Details",{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},function(self) DA.ResetScrollBoxes() end,function() DA.ResetScrollBoxes() end,[[Interface\AddOns\DarkAngel\template\pict\art_log]])
	do
		-- DA.ScrollBarCreater("DarkAngelDetails",DarkAngelGUI.Details,{DarkAngelGUI.Details.width-5, DarkAngelGUI.Details.height-70},{"TOPLEFT", 5, -62})
		Details_Create_ScrollBar()


			DarkAngelGUI.Details.SearchEB = DA.EditBoxCreater(nil,DarkAngelGUI.Details,{"TOPLEFT", DarkAngelGUI.Details, "TOPLEFT", 50, -40},{190,18},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 10},
				function(self) 		 self.t:SetBlendMode("ADD") self:ClearFocus();self.focusgained=nil;DarkAngelGUI.Details.SearchTooltip:Hide() end,
				function(self) 		 self.t:SetBlendMode("ADD") self:ClearFocus(); DA.RunLogSearch(self:GetText());self.focusgained=nil;DarkAngelGUI.Details.SearchTooltip:Hide() end,
				function(self) 		 self.t:SetBlendMode("ADD") self:ClearFocus(); DA.RunLogSearch(self:GetText());self.focusgained=nil;DarkAngelGUI.Details.SearchTooltip:Hide() end,
				function(self) 	
					if self:GetParent():IsShown() then
						if FEP_gMain and ( GetNumRaidMembers()==0 or #FEP_gMain<1 ) then 
							DA.RegatherGuildNotes()
						end
						self.t:SetBlendMode("BLEND")
						self.focusgained=1; 
						if FEP_gMain then 
						DA.DropdownHint(self:GetText(),self,DarkAngelGUI.Details.SearchTooltip,"DF","FEP_gMain","officernote",DarkAngelGUI.Details.SearchTooltip,30)
						end
					end
				end,
				function(self) 
					if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end
					
					if self:GetParent():IsShown() and self.focusgained then 
						DA.DropdownHint(self:GetText(),self,DarkAngelGUI.Details.SearchTooltip,"DF","FEP_gMain","officernote",DarkAngelGUI.Details.SearchTooltip,30)
						DA.RunLogSearch(self:GetText())
					end 
				end
			)
			DarkAngelGUI.Details.SearchEB.t:SetBlendMode("blend")
			
			DarkAngelGUI.Details.notific=DA.CreateFFGFont(nil,DarkAngelGUI.Details.SearchEB,{"TOPLEFT", DarkAngelGUI.Details, "TOPLEFT", 55, -70},15,150,{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},"",{0.65,0.55,0.55,1},nil,"LEFT")
			DarkAngelGUI.Details.notific:Hide()
			
		DarkAngelGUI.Details.SearchTooltip = DA.FrameCreater(nil,DarkAngelGUI.Details.SearchEB,160,20,{"TOPLEFT",DarkAngelGUI.Details.SearchEB,"BOTTOMLEFT",-220,58})	
			
			local function run_search()
				DA.RunLogSearch(DarkAngelGUI.Details.SearchEB:GetText())
				DarkAngelGUI.Details.SearchEB.t:SetBlendMode("ADD");
				DarkAngelGUI.Details.SearchEB:ClearFocus()
				Mod:StartScan() 
			end
			DA.CreateFFGButton2(nil,DarkAngelGUI.Details,{"CENTER",DarkAngelGUI.Details.SearchEB,127,0},18,50,L['Search'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 12, "OUTLINE"},run_search)
			
			DA.CreateFFGButton2(nil,DarkAngelGUI.Details,{"CENTER",DarkAngelGUI.Details.SearchEB,182,0},18,50,L['Target'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 12, "OUTLINE"},function() 
				DarkAngelGUI.Details.SearchEB:SetText(select(1,UnitName("target")) or UnitName("player"))
				DA.RunLogSearch(DarkAngelGUI.Details.SearchEB:GetText())
				DarkAngelGUI.Details.SearchEB.t:SetBlendMode("ADD");
				DarkAngelGUI.Details.SearchEB:ClearFocus()
				Mod:StartScan()
			end)
			
			do --search checkboxes
				DarkAngelGUI.Details.CB_note=DA.CheckBtnCreater(nil,DarkAngelGUI.Details,{"CENTER",DarkAngelGUI.Details,"TOPLEFT",180,-10},15,15,L["note"],function(self) fuckingOptions_g[DA_CurrentGuild].DCB_note=(self:GetChecked() or false) run_search() end,{'fuckingOptions_g','DCB_note','DA_CurrentGuild'})
				DarkAngelGUI.Details.CB_ofnote=DA.CheckBtnCreater(nil,DarkAngelGUI.Details,{"CENTER",DarkAngelGUI.Details.CB_note,"CENTER",0,-10},15,15,L["officer note"],function(self) fuckingOptions_g[DA_CurrentGuild].DCB_offnote=(self:GetChecked() or false) run_search() end,{'fuckingOptions_g','DCB_offnote','DA_CurrentGuild'})
				DarkAngelGUI.Details.CB_rank=DA.CheckBtnCreater(nil,DarkAngelGUI.Details,{"CENTER",DarkAngelGUI.Details.CB_note,"CENTER",0,-20},15,15,L["rank"],function(self) fuckingOptions_g[DA_CurrentGuild].DCB_rank=(self:GetChecked() or false) run_search() end,{'fuckingOptions_g','DCB_rank','DA_CurrentGuild'})
					
			end
			

			DarkAngelGUI.Details:HookScript("OnShow", function()
				for _, j in ipairs({
					{"Log_note",    "CB_note"},
					{"Log_offnote", "CB_ofnote"},
					{"Log_rank",    "CB_rank"},
				}) do
					local key, cbName = j[1], j[2]
					local state = fuckingOptions_g[DA_CurrentGuild][key]
					SetFontColor(DarkAngelGUI.Details[cbName], state)
				end
			end)

	end


end



local function checklogFilter(tag)
local sortingOptions_tbl=fuckingOptions_g[DA_CurrentGuild]
    if (tag == "new" and sortingOptions_tbl.LCB_new) or
       (tag == "Leaver" and sortingOptions_tbl.LCB_leaver) or
       (tag == "rejoin" and sortingOptions_tbl.LCB_rejoin) or
       (tag == "ch" and sortingOptions_tbl.LCB_offnote) or
       ((tag == "t" or tag == "jmt") and sortingOptions_tbl.LCB_tvink) or
       ((tag == "rt" or tag == "tm" or tag == "mt") and sortingOptions_tbl.LCB_tvink_susp) or
       (tag == "decay" and sortingOptions_tbl.LCB_decay) or
       ((tag == "tfm" or tag == "fc" or tag == "f" or tag == "uf") and sortingOptions_tbl.LCB_frozen) or
       (tag == "note" and sortingOptions_tbl.LCB_note) or
       (tag == "rank" and sortingOptions_tbl.LCB_rank) or
       (tag == "ginfo" and sortingOptions_tbl.LCB_ginfo) or
       (tag == "gmotd" and sortingOptions_tbl.LCB_gmotd) or
       (tag == "_GM" and sortingOptions_tbl.LCB_GM) then
        return true
    end
    return false
end
LogSetAllLines = function()
	if DA_CurrentGuild~="n0-guild" then else return end
	DA.RegatherGuildNotes()
	local db=DarkAngel_JRN[DA_CurrentGuild]
	local filteredData={}
	
	-- filtering data by selected log type and reversing order to desc
	for i = #db, 1, -1 do
		if checklogFilter(db[i][1]) then
			table.insert(filteredData, db[i])
		end
	end

	DarkAngelLog:Show()
	LogSetLine(filteredData)
	
end

local function openAdditionalGINF(tag, timestamp)
	if not tag or not timestamp or not DA_Guild_Info[DA_CurrentGuild].LogINFO[tag] then return end

	local entry
	
	for _,e in ipairs(DA_Guild_Info[DA_CurrentGuild].LogINFO[tag]) do
		if e and e[2] and e[2].t and e[2].t==timestamp then
			entry = e
			break
		end
	end
	
	if not entry then 
		DarkAngelGUI.Log.GinfoFrame:Hide()
		DA.Print(L["No log is stored for this entry"])
		return 
	end
	
	local isgmtag = tag=='gm'
	local frame = DarkAngelGUI.Log.GinfoFrame
		frame.tbl = entry
		frame.tbl.isgm = isgmtag
		
	frame.re_render()

end
Log_Create_ScrollBar = function()
	local NUM_ROWS = 15
	local ROW_HEIGHT = 15

	DarkAngelLog = CreateFrame("ScrollFrame", "DarkAngelLog", DarkAngelGUI.Log, "UIDarkAngelScrollFrame2")
	local ScrollFrame = DarkAngelLog
		DarkAngelLog:Hide()
	ScrollFrame:SetPoint("TOPLEFT",DarkAngelGUI.Log,"TOPLEFT",6,-60)
	ScrollFrame:SetPoint("BOTTOMRIGHT",DarkAngelGUI.Log,"BOTTOMRIGHT",-25,10)
-- local tf = ScrollFrame:CreateTexture(nil, "BACKGROUND"); tf:SetAllPoints(); tf:SetTexture(21/255, 18/255, 22/255, 0.5); tf:SetBlendMode("blend")


	DarkAngelLogCF = CreateFrame("Frame", "DarkAngelLogCF", ScrollFrame)
	local ContentFrame = DarkAngelLogCF
	
	ScrollFrame:SetScrollChild(ContentFrame)
-- local zxc = ContentFrame:CreateTexture(nil, "BACKGROUND"); zxc:SetAllPoints(); zxc:SetTexture(8/255, 55/255, 20/255, 0.5); zxc:SetBlendMode("blend")

	local RowButtons = {}
	local font=UIDarkAngelFontConsolas:GetFont()
	
	for i = 1, NUM_ROWS do
		local row = DA.CreateFFGButton2(nil, DarkAngelLog, {"TOPLEFT", DarkAngelLog, "TOPLEFT", 0, 10 - (ROW_HEIGHT * i)}, ROW_HEIGHT-1, 465, "", nil, {font, 9, "OUTLINE"},function(self,btntype) 
				
				if btntype=='LeftButton' then
					if self.plname then
					
						_G['DarkAngelGUI']['Detailsbtn']:Click('LeftButton',true)
						_G['DarkAngelGUI']['Detailsbtn']:Click('LeftButton',false)
						DarkAngelGUI.Details.SearchEB:SetText(self.plname)
						DA.RunLogSearch(DarkAngelGUI.Details.SearchEB:GetText())
					elseif self.timestamp then
						if self.tag=='ginfo' then
							openAdditionalGINF("info",self.timestamp)
						elseif self.tag=='gmotd' then
							openAdditionalGINF("motd",self.timestamp)
						
						elseif self.tag=='_GM' then
							openAdditionalGINF("gm",self.timestamp)
						
						end
						
					end
				elseif btntype=='RightButton' and self.plname then
					DA_RightClickMenu.calledfrom="DarkAngelGUI"
					DA.OpenOptMenu(self,self.plname)
				end
			end)
			row.selfID=i
		row:RegisterForClicks("AnyUp")
        row:SetNormalTexture('')
			
		row:SetScript("OnEnter", function(self)
			self:RegisterEvent('MODIFIER_STATE_CHANGED')
			local shiftdown=IsShiftKeyDown()
			---@diagnostic disable-next-line: undefined-field
			if shiftdown and GetMouseFocus() and GetMouseFocus().selfID == self.selfID and self.plname then
				DA.myShowTooltip(self, DA.GetTwinsInfo(self.plname,FEP_gMain[self.plname]),{font, 10})
			elseif not shiftdown and DA_Tooltip:IsShown() then
				DA.myHideTooltip()
			end
		end)
		row:SetScript("OnEvent", function(self)
			---@diagnostic disable-next-line: undefined-field
			if self:IsVisible() and self:IsMouseOver() and GetMouseFocus() and GetMouseFocus().selfID and GetMouseFocus().selfID==self.selfID then
				self:GetScript('OnEnter')(GetMouseFocus())
			end
		end)
		row:SetScript("OnLeave", function(self)
			self:UnregisterEvent('MODIFIER_STATE_CHANGED')
			DA.myHideTooltip()
		end)
		
		
		
		row.buttons = {}
		row.buttons[1]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 1, 0}, 20, 110, {font, 9, "OUTLINE"}, "", {0.17,0.6,0.6,0.85}, nil, "LEFT")		--time
		row.buttons[2]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 100, 0}, 20, 130, {font, 8, "OUTLINE"}, "", {0.6, 0.6, 0.6, 1}, nil, "LEFT")		--type
		row.buttons[3]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 140, 0}, 20, 130, {font, 9, "OUTLINE"}, "", nil, nil, "LEFT")					--name
		row.buttons[4]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 212, 0}, 20, 180, {font, 8, "OUTLINE"}, "", {0.75,0.85,0.85,1}, nil, "LEFT")	--note
		row.buttons[5]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 232, 0}, 20, 100, {font, 10, "OUTLINE"}, "", {0.45,0.65,0.65,1}, nil, "LEFT")					--change ep
		row.buttons[6]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 317, 0}, 20, 100, {font, 10, "OUTLINE"}, "", {0.45,0.65,0.65,1}, nil, "LEFT")					--change gp
		row.buttons[7]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 382, 0}, 20, 100, {font, 8, "OUTLINE"}, "", {0.45,0.65,0.65,1}, nil, "LEFT")					--total
		
		RowButtons[i] = row
		
	end
	
	local function UpdateRows(offset)
		
		DarkAngelLog.offset=offset
		
		local rowIndex = math.floor(offset / ROW_HEIGHT + 0.5) + 1
		for i = 1, NUM_ROWS do
			local data = DA_LogRoster[rowIndex + i - 1]
			if data then
				local row = RowButtons[i]
					row:Show()
					row.plname=data.plname
					row.tag=data.tag
					row.timestamp=data.timestamp
				row.buttons[1]:SetText(data.TimeText or "")
				row.buttons[2]:SetText(data.TagText or "")
				row.buttons[3]:SetText(data.plname or "")
				row.buttons[4]:SetText(data.note or "")
				row.buttons[5]:SetText(data.colorEPchange or "")
				row.buttons[6]:SetText(data.colorGPchange or "")
				row.buttons[7]:SetText(data.total or "")
			else
				RowButtons[i]:Hide()
			end
		end
	end
		
	DarkAngelGUI.Log.UpdRows=UpdateRows
	
	ScrollFrame:EnableMouseWheel(true)
	local scrollbar = _G[ScrollFrame:GetName().."ScrollBar"]
	scrollbar:SetScript("OnValueChanged", function(self, value)
		local scrollBarname = self:GetName()
		local _, max= self:GetMinMaxValues();
		
		if DA_Tooltip:IsShown() then
			DA_Tooltip:Hide()
		end
		if ( value == 0 ) then
			_G[scrollBarname.."ScrollUpButton"]:Disable();
		else
			_G[scrollBarname.."ScrollUpButton"]:Enable();
		end
		if ((value - max) == 0) then
			_G[scrollBarname.."ScrollDownButton"]:Disable();
		else
			_G[scrollBarname.."ScrollDownButton"]:Enable();
		end
		UpdateRows(value)
	end)

end
local function log_get_change_type_colored(tag)
    if tag == "new" or tag=='rejoin' then
		return "|cff43bf5a"..tag
	elseif tag == "Leaver" then
   		return "|cffb04c51"..tag
	elseif tag == "ch" then
		if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
			return "|cff84e3ceEPGP"
		elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
			return "|cff84e3ceDKP"
		end
	elseif tag == "t" then
		return "twinked"
	elseif tag == "jmt" then
   		return tag
	elseif tag == "rt" or tag == "tm" or tag == "mt" then
   		return "|cffe3a584"..tag
	elseif tag == "decay" then
   		return "|cffc880e0"..tag
	elseif tag == "tfm" then 
  		return "|cff4942ff"..tag
	elseif tag == "fc" then 
		return "|cff4942ffEPGP"
	elseif tag == "uf" then
		return "|cff4942ffun-frozen"
	elseif tag == "f" then
		return "|cff4942fffrozen"
	elseif tag == "note" then
  		return "|cff71aad9"..tag
	elseif tag == "rank" then
 		return "|cffd96e27"..tag
	elseif tag == "ginfo" then
 		return "|cfffa99ff_Guild info"
	elseif tag == "gmotd" then
		return "|cff9c99ff_Guild motd"
	elseif tag == "_GM" then
        return "|cfffc7474_Guild Ranks System"
		
	else
		return tag
    end

end
LogSetLine = function(data1)

table.wipe(DA_LogRoster)
	
	local displaydate

    for pos, data in ipairs(data1) do
        local tag, plname, timeTbl, changeTbl = unpack(data)
		local timestamp, isOnline, dat, tim = timeTbl.t, unpack(timeTbl)
        local total, note = data.total, data.note
		local colorEPchange, colorGPchange
			if changeTbl then
				colorEPchange,colorGPchange = unpack(changeTbl)
			end
        local printdate
		
		DA_LogRoster[pos]={}
		local plDat = DA_LogRoster[pos]
        
		if not displaydate then
			displaydate=dat
			printdate=true
		elseif displaydate==dat then
		else
			printdate=true
			displaydate=dat
		end
		
		plDat.TimeText = ((printdate and dat or string.rep(" ", #dat)) .. " " .. (isOnline and "|cff85aaaa"..tim or "|cffdd9999"..tim) )
		plDat.TagText = log_get_change_type_colored(tag)
		plDat.tag = tag
		plDat.timestamp = timestamp
		plDat.plname = plname
		plDat.note = note
		plDat.total = total
		plDat.colorEPchange=colorEPchange
		plDat.colorGPchange=colorGPchange
    
	end
	
	DarkAngelLogCF:SetSize(5, #DA_LogRoster * 15)
	
	DarkAngelGUI.Log.UpdRows(DarkAngelLog.offset or 1)
	
	
end




Details_Create_ScrollBar = function()
	local NUM_ROWS = 15
	local ROW_HEIGHT = 15

	DarkAngelDetails = CreateFrame("ScrollFrame", "DarkAngelDetails", DarkAngelGUI.Details, "UIDarkAngelScrollFrame2")
	local ScrollFrame = DarkAngelDetails
		DarkAngelDetails:Hide()
	ScrollFrame:SetPoint("TOPLEFT",DarkAngelGUI.Details,"TOPLEFT",6,-60)
	ScrollFrame:SetPoint("BOTTOMRIGHT",DarkAngelGUI.Details,"BOTTOMRIGHT",-25,10)
-- local tf = ScrollFrame:CreateTexture(nil, "BACKGROUND"); tf:SetAllPoints(); tf:SetTexture(21/255, 18/255, 22/255, 0.5); tf:SetBlendMode("blend")


	DarkAngelDetailsCF = CreateFrame("Frame", "DarkAngelDetailsCF", ScrollFrame)
	local ContentFrame = DarkAngelDetailsCF
	
	ScrollFrame:SetScrollChild(ContentFrame)
-- local zxc = ContentFrame:CreateTexture(nil, "BACKGROUND"); zxc:SetAllPoints(); zxc:SetTexture(8/255, 55/255, 20/255, 0.5); zxc:SetBlendMode("blend")

	local RowButtons = {}
	local font=UIDarkAngelFontConsolas:GetFont()
	
	for i = 1, NUM_ROWS do
		local row = DA.CreateFFGButton2(nil, DarkAngelDetails, {"TOPLEFT", DarkAngelDetails, "TOPLEFT", 0, 10 - (ROW_HEIGHT * i)}, ROW_HEIGHT-1, 465, "", nil, {font, 9, "OUTLINE"},function(self,btntype) 
			if not self.onclickdata then return end
			
			if btntype=='LeftButton' then
				DarkAngelGUI.Details.SearchEB:ClearFocus()
				DarkAngelGUI.Details.SearchEB:SetText(self.onclickdata)
				DA.RunLogSearch(DarkAngelGUI.Details.SearchEB:GetText())
			end
		end)
		row:RegisterForClicks("AnyUp")
        row:SetNormalTexture('')
			
		row:SetScript("OnEnter", function(self)
			if not self.onenterdata then return end
			
			DA.myShowTooltip(self, self.onenterdata, {font, 10})
			
		end)
		row:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
		end)
		
		
		
		row.buttons = {}
		row.buttons[1]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 1, 0}, 20, 110, {font, 9, "OUTLINE"}, "", {0.17,0.6,0.6,0.85}, nil, "LEFT")		--time
		row.buttons[2]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 100, 0}, 20, 130, {font, 8, "OUTLINE"}, "", {0.6, 0.6, 0.6, 1}, nil, "LEFT")		--type
		row.buttons[3]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 137, 0}, 20, 153, {font, 9, "OUTLINE"}, "", {0.45,0.65,0.65,1}, nil, "LEFT")					--total
		row.buttons[4]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 130, 0}, 20, 180, {font, 10, "OUTLINE"}, "", {0.45,0.65,0.65,1}, nil, "RIGHT")					--EP
		row.buttons[5]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 180, 0}, 20, 180, {font, 10, "OUTLINE"}, "", {0.45,0.65,0.65,1}, nil, "RIGHT")					--GP
		row.buttons[6]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 365, 0}, 20, 125, {font, 8, "OUTLINE"}, "", nil, nil, "LEFT")					--reason
		
		RowButtons[i] = row
		
	end
	
	local function UpdateRows(offset)
		
		DarkAngelDetails.offset=offset
		
		local rowIndex = math.floor(offset / ROW_HEIGHT + 0.5) + 1
		for i = 1, NUM_ROWS do
			local data = DA_DetailsRoster[rowIndex + i - 1]
			if data then
				local row = RowButtons[i]
					row.onclickdata = data.onclickdata or nil
					row.onenterdata = data.onenterdata or nil
					row:Show()
				row.buttons[1]:SetText(data.TimeText or "")
				row.buttons[2]:SetText(data.TagText or "")
				row.buttons[3]:SetText(data.changeOrTotal or "")
				row.buttons[4]:SetText(data.colorEPchange or "")
				row.buttons[5]:SetText(data.colorGPchange or "")
				row.buttons[6]:SetText(data.reason or "")
			else
				RowButtons[i]:Hide()
			end
		end
	end
		
	DarkAngelGUI.Details.UpdRows=UpdateRows
	
	ScrollFrame:EnableMouseWheel(true)
	local scrollBar = _G[ScrollFrame:GetName().."ScrollBar"]
	scrollBar:SetScript("OnValueChanged", function(self, value)
		local scrollBarname = self:GetName()
		local _, max= self:GetMinMaxValues();
		
		if DA_Tooltip:IsShown() then
			DA_Tooltip:Hide()
		end
		if ( value == 0 ) then
			_G[scrollBarname.."ScrollUpButton"]:Disable();
		else
			_G[scrollBarname.."ScrollUpButton"]:Enable();
		end
		if ((value - max) == 0) then
			_G[scrollBarname.."ScrollDownButton"]:Disable();
		else
			_G[scrollBarname.."ScrollDownButton"]:Enable();
		end
		UpdateRows(value)
	end)

end
local function det_get_change_type_colored(tag,data)

	if tag=='s' then
		if data=='seen' then
			return "|cff43bf5aseen" , false
		elseif data=='new' or data=='re-joined' then
			return "|cff43bf5a"..data , false
		elseif data=='left guild' then
			return "|cffb04c51"..data , false
		end
	elseif tag=='n' then
		return '|cff71aad9note' , data
	elseif tag=='o' then
		return '|cfff0f0f0officer' , DA.GetStoredColorName(data,1)
	elseif tag=='r' then
		return '|cffd96e27rank' , data
	else
		return tag
	end
	
end

local function strip_itemlink(s)
    s = s:gsub("|c%x%x%x%x%x%x%x%x|H.-|h%[(.-)%]|h|r", "%1")
    s = s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    return s
end
local function utf8len(str)
    local _, count = str:gsub("[^\128-\193]", "")
    return count
end
local function pad_utf8(str, target_len)
    local stripped = strip_itemlink(str)
    local actual_len = utf8len(stripped)
		if str:find("%[") then
			actual_len=actual_len+2
		end
    local pad = target_len - actual_len
    return str .. string.rep(" ", pad)
end
DetailsSetLine = function(data1)

table.wipe(DA_DetailsRoster)
	
	local displaydate
    for pos, data in ipairs(data1) do
		local typ = data.typ
        local changeSMTH, timeTbl = unpack(data)
		local timestamp, isOnline, dat, tim = timeTbl.t, unpack(timeTbl)
		local typ_colored,changeOrTotal=det_get_change_type_colored(typ, changeSMTH)
		local comp1, comp2, comp3 
		if data.comp then
			comp1, comp2, comp3 = unpack(data.comp)
		end
		local additType,additAddit,additListOfficers,additReason
		local reasons
		local reasons_packed
			if data.addit then
				additType,additAddit,additListOfficers=unpack(data.addit)
				additReason=data.addit.reasons
			end
			if additReason then
				local countR = #additReason
				if countR==1 then
					reasons=additReason[1][1]
				elseif countR>1 then
					reasons="<...>"
					local maxNameLength = 0
					for _, entry in ipairs(additReason) do
						local name = tostring(entry[1])
						local stripped = strip_itemlink(name)
						local len = utf8len(stripped)
							if name:find("%[") then
								len=len+2
							end
						if len > maxNameLength then
							maxNameLength = len
						end
					end
					local all={}
					for _, entry in ipairs(additReason) do
						local name = tostring(entry[1])
						local value2 = tonumber(entry[2])
						local value3 = tonumber(entry[3])

						local paddedName = pad_utf8(name, maxNameLength + 2)

						local lineParts = { paddedName }

						if value2 and value2 > 0 then
							table.insert(lineParts, "|cffaaffff" .. value2 .. "|r")
						elseif value2 and value2 < 0 then
							table.insert(lineParts, "|cffff00ff" .. value2 .. "|r")
						else
							table.insert(lineParts, "     ")
						end

						table.insert(lineParts, "  ")

						if value3 and value3 > 0 then
							table.insert(lineParts, "|cffedf500" .. value3 .. "|r")
						elseif value3 and value3 < 0 then
							table.insert(lineParts, "|cffff0000" .. value3 .. "|r")
						else
							table.insert(lineParts, "")
						end

						local line = table.concat(lineParts)
						tinsert(all, line)
					end

					reasons_packed = "  " .. table.concat(all, "\n  ")


				end
			end
        local printdate
		
		DA_DetailsRoster[pos]={}
		local plDat = DA_DetailsRoster[pos]
        
		if not displaydate then
			displaydate=dat
			printdate=true
		elseif displaydate==dat then
		else
			printdate=true
			displaydate=dat
		end
		
		plDat.TimeText = ((printdate and dat or string.rep(" ", #dat)) .. " " .. (isOnline and "|cff85aaaa"..tim or "|cffdd9999"..tim) )
		plDat.TagText = typ_colored
		
		if data.typ=='r' then
			plDat.changeOrTotal = comp1 and comp2 and comp3 and comp1..comp3..comp2
			plDat.colorEPchange=nil
			plDat.colorGPchange=nil
		else
			plDat.changeOrTotal = changeOrTotal
			plDat.colorEPchange=comp1
			plDat.colorGPchange=comp2
		end
		
		
		plDat.reason=reasons
		local addits = {}
		if reasons_packed then
			if fuckingOptions_g[DA_CurrentGuild].warn_improv_suspic then
				tinsert(addits, L["simplified_dkp_tooltip"].."Reasons:\n"..reasons_packed.."\n|r")
			else
				tinsert(addits, "Reasons:\n"..reasons_packed.."\n|r")
			end
		end
		if additType then
			if additType=='officer' then
				if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
					tinsert(addits, "|cff28d445EPGP |cffaaffff"..additAddit)
				elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
					tinsert(addits, "|cffeb4bfaDKP |cffaaffff"..additAddit)
				end
			elseif additType=='officer_cmd' then
				tinsert(addits, L['detmostlikely']..additAddit)
			elseif additType=='off_unkn' then
				tinsert(addits, L['detmcstr']..additAddit)
			elseif additType=='off_alm' then
				tinsert(addits, L['detmostlikely']..additAddit.." \n\n"..L['detposby']..additListOfficers)
			elseif additType=='invite' then
				tinsert(addits, L['detinvited']..additAddit)
			elseif additType=='rank_def' then
				tinsert(addits, L['detrerankedby']..additAddit)
			elseif additType=='kick' then
				tinsert(addits, L['detkicked']..additAddit)
			end
		end
		
		if next(addits) then
			plDat.onenterdata=table.concat(addits,"\n")
		end
		
		if data.typ=='o' and select(1,DA.DecodeNote(changeOrTotal))=='t' then
			plDat.onclickdata=data[1]
		end
		
	end
	
	DarkAngelDetailsCF:SetSize(5, #DA_DetailsRoster * 15)
	
	DarkAngelGUI.Details.UpdRows(DarkAngelDetails.offset or 1)
	
	
end


function Mod:OnInitialize()
	
	DA_Scaner_bulk={}
	FFDecayCount=false
	
	DarkAngel_FD=DarkAngel_FD or {}
	DarkAngel_JRN=DarkAngel_JRN or {}
	DA_StoredGChat=DA_StoredGChat or {}
	DA_Leavers=DA_Leavers or {}
	
	
	QueryGuildEventLog()

	
	--scaner
	DA.CreateTimer(nil,"scaner",0,0.02,true,function(self)
		local guildName,_,_= GetGuildInfo('player')
		if guildName and guildName==DA_CurrentGuild then
		elseif not guildName and DA_CurrentGuild=="n0-guild" then
		else
			table.wipe(DA_Scaner_bulk)
			DA.ResumeTimer("greset")
			DarkAngel_minimapBtn:Disable()
			DarkAngel_minimapBtn:Hide()
			self:SetScript("OnUpdate",nil)
			return
		end
		if DA_Scaner_bulk[1] then 
			DA_Scaner_bulk[1]() 
			table.remove(DA_Scaner_bulk,1)
			return
		else
			self:SetScript("OnUpdate",nil)
		end
	end) 
		
		
end

function Mod:OnEnable()
	DA:ModuleLoaded("Logger")
end

local function IsLoggingRequired()
	local optTbl = fuckingOptions_g[DA_CurrentGuild]
	for _,opt in ipairs({
	"Log_offnote",
	"Log_note",
	"Log_rank",
	"Log_ginfo",
	"Log_gmotd",
	"Log_GM"})
	do
		if optTbl[opt] then
			return true
		end
	end
	return false
end
function Mod:UpdateLogging()
	if IsLoggingRequired() then
		if DA.GetTimerTime("scan_schedule")<4 then
			DA.SetTimerTime("scan_schedule",4)
		end
		DA.ResumeTimer("scan_schedule")
	else
		DA.StopTimer('scan_schedule')
	end
end

function Mod:OnGuildLoad()
	self.Logger_Load()
	DA.CreateTimer(IsLoggingRequired(),"scan_schedule",4,45,true,function(self)
		Mod:StartScan()
	end) 
	
	
	local scaner_combat_delay=CreateFrame("Frame")
	scaner_combat_delay:RegisterEvent("PLAYER_REGEN_ENABLED")
	scaner_combat_delay:RegisterEvent("PLAYER_REGEN_DISABLED")
	
	scaner_combat_delay:SetScript("OnEvent",function(self,event)
		if event=="PLAYER_REGEN_DISABLED" then --combat start
			DA.StopTimer('scan_schedule')
		elseif event=="PLAYER_REGEN_ENABLED" then --combat end
			Mod:UpdateLogging()
		end
	end)

end


function Mod:AddModOptions(modOptTable)
	local f = DA.FrameCreater(nil,DarkAngelopt.scrollchild,154,232)
	f:Show()
	tinsert(modOptTable, {'Logger',f})	
	DA.FontCreater(nil,"Logger",{"LEFT",f,"TOPLEFT",5,-6},f,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
		
	
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-20},15,15,L['Print leavers in chat'],function(self) fuckingOptions.prntleav=(self:GetChecked() or false) end,{'fuckingOptions','prntleav'},nil)
		DA.CreateFFGButton2(nil,f,{"CENTER",f,"TOPLEFT",145,-20},12,15,"?",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
			DA.Print("F "..GetPlayerScanLink(UnitName('player'))..(FEP_gMain[UnitName('player')] and GetPlayerScanLink(FEP_gMain[UnitName('player')]) or GetPlayerScanLink("example")))
		end)
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-32},15,15,L['Track suspicious changes'],function(self) fuckingOptions_g[DA_CurrentGuild].warnsuspic=(self:GetChecked() or false) end,{'fuckingOptions_g','warnsuspic','DA_CurrentGuild'},'warnsuspic')
		local suspext=DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-43},12,12,L['DKP simplified'],function(self) fuckingOptions_g[DA_CurrentGuild].warn_improv_suspic=(self:GetChecked() or false) end,{'fuckingOptions_g','warn_improv_suspic','DA_CurrentGuild'},'warn_improv_suspic')
		DA.CreateFFGButton2(nil,f,{"CENTER",f,"TOPLEFT",145,-32},12,15,"?",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
			DA.Print(L['detmanchange'].. GetPlayerScanLink(UnitName('player'))) 
		end)
		
	DA.EditBoxCreater2(nil,f,{"LEFT",f,"TOPLEFT",10,-70},{30,12},fuckingOptions_g[DA_CurrentGuild].minlog,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","minlog",'DA_CurrentGuild'},1,nil,true,L["Minimum log"],nil,'minlog')
	DA.EditBoxCreater2(nil,f,{"LEFT",f,"TOPLEFT",10,-84},{30,12},fuckingOptions_g[DA_CurrentGuild].storeleavers,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","storeleavers",'DA_CurrentGuild'},1,nil,true,L["Store leavers data"],nil,'maxleavers')
	
	
	local dodecaycheck=DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-98},15,15,nil,function(self) fuckingOptions_g[DA_CurrentGuild].do_decay_checks=(self:GetChecked() or false) end,{'fuckingOptions_g','do_decay_checks','DA_CurrentGuild'},'do_decay_checks')
	DA.EditBoxCreater2(nil,dodecaycheck,{"LEFT",dodecaycheck,"RIGHT",2,0},{30,12},fuckingOptions.Decaydays,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions","Decaydays"},0,20,true,L["EPGP decay precising"],nil,'epgpdecayprec')
	DA.CheckBtnCreater(nil,dodecaycheck,{"CENTER",dodecaycheck,"CENTER",10,-12},15,15,L['Group-up clear decay in Log'],function(self) fuckingOptions.decaygroup=(self:GetChecked() or false) end,{'fuckingOptions','decaygroup'},nil)
	
		local logF = DA.FrameCreater(nil,f,f:GetWidth()-4,105,{"TOPLEFT",f,"TOPLEFT",2,-125})
	do --logging methods
		DA.FontCreater(nil,"Logging Config",{"LEFT",logF,"TOPLEFT",5,-6},logF,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
		
		DA.HelpCreater(logF,{"CENTER",logF,"TOPLEFT",88,-7},'LogConfHelp',12,12)
		
		logF:Show()
		local microOpt={}
		local microLabels = {
			[false] = "|cff888888None",
			[1] = "Last",
			[2] = "|cff1ced93Full"
		}

		local function lockUnlockReset()
			for crit,val in pairs(microOpt) do
				if fuckingOptions_g[DA_CurrentGuild][crit]==val then
				else
					logF.resetBtn:Enable()
					logF.saveBtn:Enable()
					return
				end
			end
			logF.resetBtn:Disable()
			logF.saveBtn:Disable()
		end
		local function selector_shift(button, opt, left)
			local state = microOpt[opt]

			if state == false then
				if left then return end
				state = 1
				button.minus:Enable()
			elseif state == 1 then
				if left then
					state = false
					button.minus:Disable()
				else
					state = 2
					button.plus:Disable()
				end
			elseif state == 2 then
				if left then
					state = 1
					button.plus:Enable()
				else
					return
				end
			end

			microOpt[opt] = state
			button:SetText(microLabels[state])
			
			
			lockUnlockReset()
		end
		
		logF.buttons={}
		
		local function selectors_upd(cr)
			for i,j in ipairs({
			{'Log_note',L["note"]},
			{'Log_offnote',L["officer note"]},
			{'Log_rank',L["rank"]},
			{'Log_ginfo',L["guild info"]},
			{'Log_gmotd',L["guild MOTD"]},
			{'Log_GM',L['Guild GM system']}
			}) do
				microOpt[j[1]]=fuckingOptions_g[DA_CurrentGuild][j[1]]
				if cr then
					logF.buttons[i]=DA.CreateFFGButton2(nil,logF,{"CENTER",logF,"TOPLEFT",35,-10 - i*12},12,35,"",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"})
					local btn=logF.buttons[i]
					btn:EnableMouse(false)
					DA.FontCreater(nil,j[2],{"LEFT",btn,"RIGHT",18,0},btn,15,180,{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"},'left')
					
					btn.minus=DA.CreateFFGButton2(nil,btn,{"RIGHT",btn,"LEFT",-1,0},12,13,"<",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
						selector_shift(btn, j[1], true)
					end)
					btn.plus=DA.CreateFFGButton2(nil,btn,{"LEFT",btn,"RIGHT",1,0},12,13,">",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
						selector_shift(btn, j[1], false)
					end)
				end
				local btn=logF.buttons[i]
				btn:SetText(microLabels[microOpt[j[1]]])
				if not microOpt[j[1]] then
					btn.minus:Disable()
					btn.plus:Enable()
				elseif microOpt[j[1]]==2 then
					btn.plus:Disable()
					btn.minus:Enable()
				else
					btn.minus:Enable()
					btn.plus:Enable()
				end
			end
			
		end
		
		
		logF.resetBtn=DA.CreateFFGButton2(nil,logF,{"CENTER",logF,"TOPLEFT",40,-95},12,40,"reset",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
			selectors_upd()
			
			logF.resetBtn:Disable()
			logF.saveBtn:Disable()
		end)
		
		logF.saveBtn=DA.CreateFFGButton2(nil,logF,{"CENTER",logF,"TOPLEFT",95,-95},12,40,"save",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
			for crit,val in pairs(microOpt) do
				fuckingOptions_g[DA_CurrentGuild][crit]=val
			end
			selectors_upd()
			
			logF.resetBtn:Disable()
			logF.saveBtn:Disable()
			
			Mod:UpdateLogging()
		end)	
		
		
		logF.resetBtn:Disable()
		logF.saveBtn:Disable()
		
		selectors_upd(1)
		table.insert(DA.RunOnGuildUpdate, selectors_upd)
	end
	
	local function logmodoptReRender()
		if DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
			dodecaycheck:Hide()
			suspext:Show()
			f:SetSize(154,203)
			logF:SetPoint("TOPLEFT",f,"TOPLEFT",2,-95)
		else
			dodecaycheck:Show()
			suspext:Hide()
			f:SetSize(154,232)
			logF:SetPoint("TOPLEFT",f,"TOPLEFT",2,-125)
		end
	end
	logmodoptReRender()
	table.insert(DA.RunOnGuildUpdate, logmodoptReRender)
	
	do --log clean
		local logClean_rehighlight 
		local cleanModes={
			{L["4 days"], 345600},
			{L["1 week"], 604800},
			{L["2 weeks"], 1209600},
			{L["3 weeks"], 1814400},
			{L["1 month"], 2592000},
			{L["2 months"], 5184000},
			{L["3 months"], 7776000},

		}
		
		
		local logClean_Btn,logClean_Frame=DA.CreateFFGDropFrame(f,"",11,58,{"CENTER",f,"TOPLEFT",35,-55},60,#cleanModes*11,"BOTTOM",'center', function() logClean_rehighlight() end,nil,'logCleandesc')
		DA.FontCreater(nil,L["Store logs"],{"LEFT",logClean_Btn,"RIGHT",2,0},logClean_Btn,15,180,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'left')
					
		for i=1,#cleanModes do 
			logClean_Frame['btn'..i]=DA.CreateFFGButton2(nil,logClean_Frame,{"TOPLEFT", logClean_Frame, "TOPLEFT", 1,10-11*i},10,58,cleanModes[i][1],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
				fuckingOptions_g[DA_CurrentGuild].cleanlogonceper=cleanModes[i][2]
				logClean_rehighlight()
				logClean_Frame:Hide()
			end,nil,nil,'center')
			
			if fuckingOptions_g[DA_CurrentGuild].cleanlogonceper==cleanModes[i][2] then
				logClean_Btn:SetText(cleanModes[i][1])
			end
		end
		
		logClean_rehighlight=function()
			local s = fuckingOptions_g[DA_CurrentGuild].cleanlogonceper
			for i=1,#cleanModes do
				if cleanModes[i][2]==s then
					logClean_Frame['btn'..i].fs:SetTextColor(0.2,1,1,1)
					logClean_Btn:SetText(cleanModes[i][1])
				else
					logClean_Frame['btn'..i].fs:SetTextColor(0.85,1,1,1)
				end
			end
		end
		
		logClean_rehighlight()
		table.insert(DA.RunOnGuildUpdate, logClean_rehighlight)
		
	end
	
end