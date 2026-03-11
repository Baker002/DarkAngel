
---@class DarkAngelAddon
local DA = DarkAngel
local L = LibStub("AceLocale-3.0"):GetLocale("DarkAngel")
local Mod = DA:NewModule("Inviter")



DA.Inviter_response_idle={}
DA.Inviter_responseFrame=CreateFrame("Frame")
DA.Inviter_responsepatterns = {
	ERR_INVITE_PLAYER_S,
	ERR_DECLINE_GROUP_S,
	ERR_IGNORING_YOU_S,
	ERR_ALREADY_IN_GROUP_S,
	ERR_BAD_PLAYER_NAME_S
}
local function removeFromList(name)
    for i, j in ipairs(DA.listinvite_bulk) do
        if j == name then
            table.remove(DA.listinvite_bulk, i)
            return
        end
    end
end

local convertedToRaid=false
local Inviter_Started=false
local InviterMsgFrame=CreateFrame("FRAME");
DA.listinvite_bulk={}
local SRwant2invite="no"
DA.Inviter_responseFrame:SetScript("OnEvent",function(_,event,msg)
	if not Inviter_Started then return end
	
	if event=="UI_ERROR_MESSAGE" then
		if msg:find(ERR_INVITE_NO_PARTY_SERVER) then
			UIErrorsFrame:Clear()
			DA.Inviter_responsetimer=DA.Inviter_responsetimer+0.1
			DA.SetTimerSpeed('proc_invite_fast',DA.Inviter_responsetimer)
			table.wipe(DA.Inviter_response_idle)
		end
	elseif event=="CHAT_MSG_SYSTEM" then
		for _, fmt in ipairs(DA.Inviter_responsepatterns) do
			local _, _, name = string.find(msg, string.format(fmt, "(.+)"))
			if name then
				removeFromList(name)
				return
			end
		end
	end
end)



DA_Inviter=DA.FrameCreater("DA_Inviter",UIParent,400,200,{"CENTER", UIParent, "CENTER", 0, 0},[[Interface\AddOns\DarkAngel\template\pict\art_inviter]],1,1)
DA_Inviter:RegisterForDrag("LeftButton")
DA_Inviter:SetScript("OnDragStart", DA_Inviter.StartMoving)
DA_Inviter:SetScript("OnDragStop", function(self)

	self:StopMovingOrSizing(self)

	local point={DA_Inviter:GetPoint(1)}
	fuckingOptions.saved_guiPositions.DA_Inviter={point[1] or "TOPLEFT",point[3] or "CENTER",point[4] or 0,point[5] or 0}

end)
DA_Inviter.OpenClose=function()
	SendAddonMessage("DA_RTq",'DA_RTq', "guild")
	if DA_Inviter:IsShown() then
		DA_Inviter:Hide()
	else
		DA_Inviter:Show()
	end
end
DA.CloseButtonCreater(nil,DA_Inviter,{"TOPRIGHT", DA_Inviter, "TOPRIGHT", -5,-5},12,12,'x')

local PhrasesFrame=DA.FrameCreater(nil,DA_Inviter,DA_Inviter.width,150,{"BOTTOMLEFT", DA_Inviter, "TOPLEFT", 0, 2})
PhrasesFrame:RegisterForDrag("LeftButton")
PhrasesFrame:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
PhrasesFrame:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end) 

DA_Inviter.OptionsFr=DA.FrameCreater(nil,DA_Inviter,250,125,{"TOPLEFT", DA_Inviter, "TOPRIGHT", 3, 0})
DA.CloseButtonCreater(nil,DA_Inviter.OptionsFr,{"TOPRIGHT", DA_Inviter.OptionsFr, "TOPRIGHT", -2,-1},10,10,'x')

DA.OptionsButtonCreater(nil,DA_Inviter,{"TOPRIGHT", DA_Inviter, "TOPRIGHT", -20,-5},12,12,function(self)
	if DA_Inviter.OptionsFr:IsShown() then
		DA_Inviter.OptionsFr:Hide()
	else
		DA_Inviter.OptionsFr:Show()
	end
end)



local function AddInQueue(_, event, message, author, _,addit2, _)

	if not Inviter_Started then
		if event=="CHAT_MSG_GUILD" or event=="CHAT_MSG_ADDON" then
			if (GetNumRaidMembers()==0 and GetNumPartyMembers()==0) then 
				if (string.sub(message,0,3)=="RT+" or string.sub(message,0,5)=="РТ+" or message=="SRranons") then	
					if fuckingOptions.SR_autojoin then
						if event=="CHAT_MSG_GUILD" and SRwant2invite=="no" then 
							SendChatMessage("+","guild") 
							SRwant2invite=author
						elseif event=="CHAT_MSG_ADDON" then
							DA.Print(L["joining raid..."])
							SendAddonMessage("DA_join","join", "guild")
							SRwant2invite=addit2
						end
					end
				end
				if (string.sub(message,0,1)=="+" and GetUnitName("player")==author) then
					SRwant2invite="any22"
				end
			end
		end
		if (event=="PARTY_INVITE_REQUEST" and (message==SRwant2invite or SRwant2invite=="any22") and fuckingOptions.SR_autoaccept) then
			SRwant2invite="no"
			AcceptGroup()
			InviterMsgFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
		end
		if event=="PARTY_MEMBERS_CHANGED" then
		  StaticPopup_Hide("PARTY_INVITE")
		  InviterMsgFrame:UnregisterEvent("PARTY_MEMBERS_CHANGED")
		end
		
		return
	end
	
	if event=="CHAT_MSG_CHANNEL" then
		if fuckingOptions.SR_lfg then
			if fuckingOptions.RTlfgphrases=="" then
				fuckingOptions.SR_lfg=false
				DA.Print(L['LFG samples are nil, LFG inviter disabled'])
				return
			end
			if ( string.find("\n"..fuckingOptions.RTlfgphrases.."\n","\n"..message.."\n") ) and
			message~="Секретная фраза123" and
			message~="можно создать ещё с новой строки" and
			message~="Secret phrase123" and
			message~="you can create more each from new line" 
			then
				if UnitInRaid(author) then 
				else
					local index={}
					for k,v in pairs(DA.listinvite_bulk) do
					   index[v]=k
					end
					if index[author] then return else table.insert(DA.listinvite_bulk,author) end
				end
			end
		end
	end
	if event=="CHAT_MSG_GUILD" then
		if fuckingOptions.SR_gc and author~=UnitName('player') and string.sub(message,0,#fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern)==fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern then
			if UnitInRaid(author) then else
				local index={}
				for k,v in pairs(DA.listinvite_bulk) do
				   index[v]=k
				end
				if index[author] then return else table.insert(DA.listinvite_bulk,author) end
			end
		end
	end
	
	
	if event=="CHAT_MSG_WHISPER" then
		if fuckingOptions.SR_pm and string.sub(message,0,#fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern)==fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern then
			if UnitInRaid(author) then 
			else
				local index={}
				for k,v in pairs(DA.listinvite_bulk) do
				   index[v]=k
				end
				
				if index[author] then 
					return 
				else
					table.insert(DA.listinvite_bulk,tostring(author)) 
				end
			end
		end
	end
	
	if (GetNumRaidMembers()==0 and GetNumPartyMembers()>0) then
		if not convertedToRaid then
			convertedToRaid=true
			ConvertToRaid()
			if fuckingOptions_g[DA_CurrentGuild].initRaidLootMethod=='m' then
				SetLootMethod("master","player")
			elseif fuckingOptions_g[DA_CurrentGuild].initRaidLootMethod=='g' then
				SetLootMethod("group")
			elseif fuckingOptions_g[DA_CurrentGuild].initRaidLootMethod=='f' then
				SetLootMethod("freeforall")
			end
			SetRaidDifficulty(DA_Inviter.initRaidDifficulty)
		end
	end
	

end

InviterMsgFrame:SetScript("OnEvent", AddInQueue);

local discordphrases={
	['send discord'] = true,
	['give discord'] = true,
	['send disc'] = true,
	['give disc'] = true,
	['give link'] = true,
	['send link'] = true,
	['send me discord'] = true,
	['send me discord link'] = true,
	['what is discord'] = true,
	['what discord'] = true,
	['дайте дис'] = true,
	['дайтедис'] = true,
	['дайдс'] = true,
	['дай дс'] = true,
	['дайте диск'] = true,
	['дайтедиск'] = true,
	['дайте дискорд'] = true,
	['дайтедискорд'] = true,
	['дайте discord'] = true,
	['дайтеdiscord'] = true,
	['дайтеdisc'] = true,
	['дайте disc'] = true,
	['дайте рк'] = true,
	['дайте РК'] = true,
	['дайтерк'] = true,
	['дайтеРК'] = true,
	['дай дис'] = true,
	['дайдис'] = true,
	['дай диск'] = true,
	['дайдиск'] = true,
	['дай дискорд'] = true,
	['дайдискорд'] = true,
	['дай дискйор'] = true,
	['дай рк'] = true,
	['дай РК'] = true,
	['дайрк'] = true,
	['дайРК'] = true,
	['дайте связь'] = true,
	['дайтесвязь'] = true,
	['дай связь'] = true,
	['дайсвязь'] = true,
	['lfqnt lbc'] = true,
	['lfqntlbc'] = true,
	['lfqnt lbcr'] = true,
	['lfqntlbcr'] = true,
	['lfqnt lbcrjhl'] = true,
	['lfqntlbcrjhl'] = true,
	['lfqnt lbcrйор'] = true,
	['lfqnt hr'] = true,
	['lfqnt HR'] = true,
	['lfqnthr'] = true,
	['lfqntHR'] = true,
	['lfq lbc'] = true,
	['lfqlbc'] = true,
	['lfq lbcr'] = true,
	['lfqlbcr'] = true,
	['lfq lbcrjhl'] = true,
	['lfqlbcrjhl'] = true,
	['lfq lbcrйор'] = true,
	['lfq hr'] = true,
	['lfq HR'] = true,
	['lfqhr'] = true,
	['lfqHR'] = true,
	['lfqnt cdzpm'] = true,
	['lfqntcdzpm'] = true,
	['lfq cdzpm'] = true,
	['lfqcdzpm'] = true,
	['lfqlc '] = true,
	['lfq lc'] = true,
}
local AskDiscordFrame = CreateFrame("FRAME");
local function GiveDiscordLink(self, event, message, author, ...)
	if (Inviter_Started==true and fuckingOptions.SR_discenab and fuckingOptions.RTdiscordlink~="https://discord.gg/discord_link_here") then
		if discordphrases[message] then
			SendChatMessage(fuckingOptions.RTdiscordlink,"raid")
		end
	end
end
AskDiscordFrame:SetScript("OnEvent", GiveDiscordLink);
AskDiscordFrame:RegisterEvent("CHAT_MSG_RAID");


function Mod:OnInitialize()
	DA_Inviter:SetScale(fuckingOptions.SRScale)
	
		
	if fuckingOptions.SR_autojoin then 
		InviterMsgFrame:RegisterEvent("CHAT_MSG_GUILD")
		InviterMsgFrame:RegisterEvent("CHAT_MSG_CHANNEL")
	end
	if fuckingOptions.SR_autoaccept then InviterMsgFrame:RegisterEvent("PARTY_INVITE_REQUEST");end
	
	--inviter timer
	DA.CreateTimer(nil,"inviter",0,0.1,true,function(self)
		self.mytime=self.mytime or time()
		self.mytime2=self.mytime2 or time()
		if DA.listinvite_bulk[1] and UnitInRaid(DA.listinvite_bulk[1]) then
			repeat 
				if DA.listinvite_bulk[1] and UnitInRaid(DA.listinvite_bulk[1]) then table.remove(DA.listinvite_bulk,1) end
			until ((not DA.listinvite_bulk[1]) or (not UnitInRaid(DA.listinvite_bulk[1])))
		end
		if DA.listinvite_bulk[1] then
			if fuckingOptions_g[DA_CurrentGuild].InvTimerSpeed=='timer' then
				DA.ResumeTimer("proc_invite_timer")
			elseif fuckingOptions_g[DA_CurrentGuild].InvTimerSpeed=='fast' then
				DA.Inviter_responseFrame:RegisterEvent("CHAT_MSG_SYSTEM")
				DA.Inviter_responseFrame:RegisterEvent("UI_ERROR_MESSAGE")
				
				DA.ResumeTimer("proc_invite_fast")
			elseif fuckingOptions_g[DA_CurrentGuild].InvTimerSpeed=='instant' then
				for _,name in ipairs(DA.listinvite_bulk) do
					if name and not UnitInRaid(name) then
						InviteUnit(name)
					end
				end
				table.wipe(DA.listinvite_bulk)
			end
			
			
		end
		
		--autostop
		if fuckingOptions.SR_autostop and time()-self.mytime2>=fuckingOptions.RTstoper*60 then
			self:SetScript("OnUpdate",nil)
			self.mytime=nil
			self.mytime2=nil
			convertedToRaid=false
			DA_Inviter.stopbtn:Disable()
			DA_Inviter.startbtn:SetText(L['start'])
			Inviter_Started=false
			DEFAULT_CHAT_FRAME:AddMessage("      -->>"..L['Invite auto-stopped'],1,0.5,0.5)
			SendChatMessage("# "..fuckingOptions_g[DA_CurrentGuild].inviter_autostop.." ("..fuckingOptions.RTstoper.." "..L['minutes_short']..")","guild")
			if fuckingOptions.SR_autojoin then else InviterMsgFrame:UnregisterEvent("CHAT_MSG_CHANNEL");end
			if fuckingOptions.SR_autoaccept then else InviterMsgFrame:UnregisterEvent("PARTY_INVITE_REQUEST");end
			if fuckingOptions.SR_pm then else InviterMsgFrame:UnregisterEvent("CHAT_MSG_WHISPER");end
			return
		end
		
		--send guild msg
		if fuckingOptions.SR_enab and Inviter_Started==true then
			if time()-self.mytime>=60*fuckingOptions.SR_minutecount then
				self.mytime=time()
				SendAddonMessage("SRranons",GetUnitName("player"), "guild")
				SendChatMessage(fuckingOptions.RTmessage,"guild")
			end
		end
	end) 
	
	--inviter processor
	DA.Inviter_responsetimer=0.2
	DA.CreateTimer(nil,"proc_invite_fast",0,DA.Inviter_responsetimer,true,function(self)
		if #DA.listinvite_bulk>0 then
			local invsent
			local smthdeleted
			for i,name in ipairs(DA.listinvite_bulk) do
				if name and DA.Inviter_response_idle[name] and DA.Inviter_response_idle[name]>3 then
					DA.listinvite_bulk[i]=nil
					smthdeleted=true
				elseif name and DA.Inviter_response_idle[name] then
					DA.Inviter_response_idle[name]=DA.Inviter_response_idle[name]+1
				elseif name and not invsent then
					InviteUnit(name)
					DA.Inviter_response_idle[name]=0
					invsent=true
				end
			end
			
			if smthdeleted then
				local new_list = {}
				for i, name in ipairs(DA.listinvite_bulk) do
					if name then
						table.insert(new_list, name)
					end
				end
				DA.listinvite_bulk = new_list
			end
		
		else
			self:SetScript("OnUpdate",nil)
			table.wipe(DA.Inviter_response_idle)
			DA.Inviter_responseFrame:UnregisterEvent("CHAT_MSG_SYSTEM")
			self.time=0
		end
	end) 


end

function Mod:OnEnable()
	if UISpecialFrames then 
		tinsert(UISpecialFrames, "DA_Inviter")
	end
	DA:ModuleLoaded("Inviter")
end

function Mod:OnGuildLoad()
	self:Inviter_Load()
end

function Mod:Inviter_Load()
-- START button
DA_Inviter.startMenuBtn,DA_Inviter.startMenuFrame=DA.CreateFFGDropFrame(DA_Inviter,L['start'],12,50,{"TOPLEFT", DA_Inviter, "TOPLEFT", 35, -120},170,108,"BOTTOM")
DA_Inviter.startMenuFrame.t:SetTexture(0.03, 0.04, 0.07, 0.75)
do
	local function re_render_startMenuFrame_Diff()
		for i,j in ipairs({"10","25","10H","25H"}) do
			if DA_Inviter.initRaidDifficulty==i then
				DA_Inviter.startMenuFrame[i].fs:SetTextColor(0.2,1,1,1)
			else
				DA_Inviter.startMenuFrame[i].fs:SetTextColor(0.85,1,1,1)
			end
		end
	end
	
	for i,j in ipairs({"10","25","10H","25H"}) do
		DA_Inviter.startMenuFrame[i]=DA.CreateFFGButton2(nil,DA_Inviter.startMenuFrame,{"TOPLEFT", DA_Inviter.startMenuFrame, "TOPLEFT", -25+26*i,-1},10,25,j,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
			DA_Inviter.initRaidDifficulty=i
			re_render_startMenuFrame_Diff()
		end,nil,nil,'center')
	end
	DA_Inviter.initRaidDifficulty=4
	re_render_startMenuFrame_Diff()
	
	local speedSelectTbl={
		{"Fastest",'fast',"inv_fast_tt"},
		{"Instant",'instant',"inv_instant_tt"},
		{"By Timer",'timer',"inv_timer_tt"},
	}
	local rerender_speedSelectFrame
	
	DA_Inviter.startMenuFrame.speedSelectBtn,DA_Inviter.startMenuFrame.speedSelectFrame=DA.CreateFFGDropFrame(DA_Inviter.startMenuFrame,"",12,70,{"CENTER",DA_Inviter.startMenuFrame,"TOPLEFT",40,-20},72,34,"BOTTOM",nil,nil,nil,'speedSelect')
	DA_Inviter.startMenuFrame.speedSelectFrame:SetFrameLevel(200)
	for id,ss in ipairs(speedSelectTbl) do
		DA_Inviter.startMenuFrame.speedSelectFrame[id]=DA.CreateFFGButton2(nil,DA_Inviter.startMenuFrame.speedSelectFrame,{"TOPLEFT",DA_Inviter.startMenuFrame.speedSelectFrame, "TOPLEFT",1, 10-11*id},10,70,ss[1],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
			fuckingOptions_g[DA_CurrentGuild].InvTimerSpeed=ss[2]
			rerender_speedSelectFrame()
			DA_Inviter.startMenuFrame.speedSelectFrame:Hide()
		end,ss[3],nil,'left')
		DA_Inviter.startMenuFrame.speedSelectFrame[id]:SetFrameLevel(201)
	
	end
	
	DA_Inviter.startMenuFrame.speedSelectTimerEB=DA.EditBoxCreater2(nil,DA_Inviter.startMenuFrame,{"LEFT", DA_Inviter.startMenuFrame.speedSelectBtn, "RIGHT",2,0},{20,12},fuckingOptions_g[DA_CurrentGuild].InvTimerSpeedTimer,false,false,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},{"fuckingOptions_g","InvTimerSpeedTimer",'DA_CurrentGuild'},0.1,10,'textnum')
	DA_Inviter.startMenuFrame.speedSelectTimerEB:HookScript("OnEscapePressed", function() DA.SetTimerSpeed('proc_invite_timer',fuckingOptions_g[DA_CurrentGuild].InvTimerSpeedTimer) end)
	DA_Inviter.startMenuFrame.speedSelectTimerEB:HookScript("OnEnterPressed", function() DA.SetTimerSpeed('proc_invite_timer',fuckingOptions_g[DA_CurrentGuild].InvTimerSpeedTimer) end)
	DA_Inviter.startMenuFrame.speedSelectTimerEB:HookScript("OnEditFocusLost", function() DA.SetTimerSpeed('proc_invite_timer',fuckingOptions_g[DA_CurrentGuild].InvTimerSpeedTimer) end)
	
	rerender_speedSelectFrame=function()
		DA_Inviter.startMenuFrame.speedSelectTimerEB:Hide()
		for i,j in ipairs(speedSelectTbl) do
			if fuckingOptions_g[DA_CurrentGuild].InvTimerSpeed==j[2] then
				DA_Inviter.startMenuFrame.speedSelectFrame[i].fs:SetTextColor(0.2,1,1,1)
				DA_Inviter.startMenuFrame.speedSelectBtn:SetText(j[1])
				if i==3 then
					DA_Inviter.startMenuFrame.speedSelectTimerEB:Show()
				end
			else
				DA_Inviter.startMenuFrame.speedSelectFrame[i].fs:SetTextColor(0.85,1,1,1)
			end
		end
	end
	rerender_speedSelectFrame()
	table.insert(DA.RunOnGuildUpdate, rerender_speedSelectFrame)
	
	DA_Inviter.startMenuFrame.silentstart=DA.CheckBtnCreater(nil,DA_Inviter.startMenuFrame,{"CENTER",DA_Inviter.startMenuFrame,"TOPLEFT",10,-35},15,15,L['start silently'],nil,nil,'silentlstart')
	
	local lootSelectTbl={
		{"Master",'m'},
		{"Group",'g'},
		{"Free",'f'},
	}
	local rerender_lootSelectFrame
	DA_Inviter.startMenuFrame.lootBtn,DA_Inviter.startMenuFrame.lootFrame=DA.CreateFFGDropFrame(DA_Inviter.startMenuFrame,"",12,45,{"CENTER",DA_Inviter.startMenuFrame,"TOPLEFT",135,-20},47,34,"BOTTOM",nil,nil,nil,'lootBtnSelect')
	DA_Inviter.startMenuFrame.lootFrame:SetFrameLevel(200)
	for id,ss in ipairs(lootSelectTbl) do
		DA_Inviter.startMenuFrame.lootFrame[id]=DA.CreateFFGButton2(nil,DA_Inviter.startMenuFrame.lootFrame,{"TOPLEFT",DA_Inviter.startMenuFrame.lootFrame, "TOPLEFT",1, 10-11*id},10,45,ss[1],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
			fuckingOptions_g[DA_CurrentGuild].initRaidLootMethod=ss[2]
			rerender_lootSelectFrame()
			DA_Inviter.startMenuFrame.lootFrame:Hide()
		end,nil,nil,'center')
		DA_Inviter.startMenuFrame.lootFrame[id]:SetFrameLevel(201)
	
	end
	rerender_lootSelectFrame=function()
		DA_Inviter.startMenuFrame.speedSelectTimerEB:Hide()
		for i,j in ipairs(lootSelectTbl) do
			if fuckingOptions_g[DA_CurrentGuild].initRaidLootMethod==j[2] then
				DA_Inviter.startMenuFrame.lootFrame[i].fs:SetTextColor(0.2,1,1,1)
				DA_Inviter.startMenuFrame.lootBtn:SetText(j[1])
			else
				DA_Inviter.startMenuFrame.lootFrame[i].fs:SetTextColor(0.85,1,1,1)
			end
		end
	end
	rerender_lootSelectFrame()
	table.insert(DA.RunOnGuildUpdate, rerender_lootSelectFrame)
	
	DA.FontCreater(nil,L['Also invite:'],{"TOPLEFT", DA_Inviter.startMenuFrame, "TOPLEFT", 15, -45},DA_Inviter.startMenuFrame.silentstart,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
	
	DA_Inviter.startMenuFrame.lvl80=DA.CheckBtnCreater(nil,DA_Inviter.startMenuFrame,{"CENTER",DA_Inviter.startMenuFrame,"TOPLEFT",10,-65},15,15,L['guild: all 80 lvl online'])
	DA_Inviter.startMenuFrame.fromsnapshot=DA.CheckBtnCreater(nil,DA_Inviter.startMenuFrame,{"CENTER",DA_Inviter.startMenuFrame,"TOPLEFT",10,-77},15,15,'Awarder tool: raid snapshot',function(self) 
		if self:GetChecked() then 
			if DA_Awarder then 
				DA_Awarder:Show()
				FEP_GatherRaid()
				FEP_ReNameRePushThings()
			else
				DA.Print("This module is not loaded")
			end 
		end 
	end)
	DA_Inviter.startMenuFrame.gselected=DA.CheckBtnCreater(nil,DA_Inviter.startMenuFrame,{"CENTER",DA_Inviter.startMenuFrame,"TOPLEFT",10,-89},15,15,L['Guild tool: selected'],function(self) 
		if self:GetChecked() then 
			
			DarkAngelGUI:Show()
			_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',true)
			_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',false)
			DA.ResetScrollBoxes()
		else
			DarkAngelGUI:Hide()
		end 
	end)
	DA_Inviter.startMenuFrame.gfound=DA.CheckBtnCreater(nil,DA_Inviter.startMenuFrame,{"CENTER",DA_Inviter.startMenuFrame,"TOPLEFT",10,-101},15,15,L['Guild tool: all found online'],function(self) 
		if self:GetChecked() then 
			
			DarkAngelGUI:Show()
			_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',true)
			_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',false)
			DA.ResetScrollBoxes()
		else
			DarkAngelGUI:Hide()
		end 
	end)
	
	
	local function add_additional_invites()
		local index={}
		local myname=UnitName('player')
		
		if DA_Inviter.startMenuFrame.lvl80:GetChecked() then
			table.wipe(index)
			for k,v in pairs(DA.listinvite_bulk) do
			   index[v]=k
			end
			
			for k=1,DA.GetNumGMembers() do
				local name, _, _, level, _, _, note, _, online, _, _, _, _, _, _, _ = GetGuildRosterInfo(k)
				if name and name~=myname and online and level==80 and not UnitInRaid(name) and not index[name] then 
					table.insert(DA.listinvite_bulk,name)
				end
			end
			
		end
		if DA_Inviter.startMenuFrame.fromsnapshot:GetChecked() then
			table.wipe(index)
			for k,v in pairs(DA.listinvite_bulk) do
			   index[v]=k
			end
			
			for group=1,8 do
				for i=1,5 do
					
					local frame=_G["DA_AwarderGroup"..group.."frame"..i]
					
					if _G["DA_AwarderGroup"..group.."frame"..i]:IsShown() 
					and _G["DA_AwarderGroup"..group.."frame"..i].c 
					and _G["DA_AwarderGroup"..group.."frame"..i].c.name 
					and _G["DA_AwarderGroup"..group.."frame"..i].c.name~=myname
					and not UnitInRaid(_G["DA_AwarderGroup"..group.."frame"..i].c.name) 
					and not index[_G["DA_AwarderGroup"..group.."frame"..i].c.name] then 
						table.insert(DA.listinvite_bulk,_G["DA_AwarderGroup"..group.."frame"..i].c.name)
					end
				end
			end
			
		end
		if DA_Inviter.startMenuFrame.gselected:GetChecked() then
			table.wipe(index)
			for k,v in pairs(DA.listinvite_bulk) do
			   index[v]=k
			end
			
			local roster=DA.GetGfoundList('sel')
			
			for _,r in ipairs(roster) do
				if 
				-- (r[4] or r[1]=='local') and 
				r[2] and r[2]~=myname and not UnitInRaid(r[2]) and not index[r[2]] then 
					table.insert(DA.listinvite_bulk,r[2])
				end
			end
			
		end
		if DA_Inviter.startMenuFrame.gfound:GetChecked() then
			
			table.wipe(index)
			for k,v in pairs(DA.listinvite_bulk) do
			   index[v]=k
			end
			
			local roster=DA.GetGfoundList('all')
			
			for _,r in ipairs(roster) do
				if (r[4] or r[1]=='local') and r[2] and r[2]~=myname and not UnitInRaid(r[2]) and not index[r[2]] then 
					table.insert(DA.listinvite_bulk,r[2])
				end
			end
			
		end
		
		AddInQueue()
				
	end
	local function getGuildChatPermissions()
		
		if not IsInGuild() then
			return nil, nil, true
		end
		local _, _, rankIndex = GetGuildInfo("player")
		GuildControlSetRank(rankIndex)
		local guildchat_listen, guildchat_speak = GuildControlGetRankFlags()

		return guildchat_listen, guildchat_speak
	end

	DA_Inviter.startbtn=DA.CreateFFGButton2(nil,  DA_Inviter.startMenuFrame,  {"TOPLEFT", DA_Inviter.startMenuFrame, "TOPLEFT", 115, -1},  12,  50,  L['start'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',  {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
		function()
			if not(fuckingOptions.SR_gc or fuckingOptions.SR_pm or fuckingOptions.SR_lfg) then
				DA.Print(L["Please select at least one option for accepting players into the raid"])
				return
			end
			local guildchat_listen, guildchat_speak, not_in_guild = getGuildChatPermissions()
			  
			if not_in_guild then
				DA.Print(L["is not in guild"])
				return
			end
			if not guildchat_listen then
				DA.Print(L["It looks like your guild rank doesn't allow you to read guild chat"])
				return
			end
			if not guildchat_speak then
				DA.Print(L["It looks like your guild rank doesn't allow you to use guild chat"])
				return
			end
			DA_Inviter.startMenuFrame.speedSelectTimerEB:ClearFocus()
			if Inviter_Started==true then
				DA_Inviter.stopbtn:Enable()
				SendChatMessage(fuckingOptions_g[DA_CurrentGuild].inviter_repeat,"guild")
				SendAddonMessage("SRranons",GetUnitName("player"), "guild")
			else
				DA_Inviter.startbtn:SetText(L["guild ping"])
				DA_Inviter.stopbtn:Enable()
				convertedToRaid=false
				Inviter_Started=true
				DA.XTimers["inviter"].mytime=nil;DA.XTimers["inviter"].mytime2=nil;
				DA.ResumeTimer('inviter')
				
				DEFAULT_CHAT_FRAME:AddMessage("      -->>"..L['Raid inviter started'],0,1,1)
				if not DA_Inviter.startMenuFrame.silentstart:GetChecked() then SendChatMessage(fuckingOptions.RTmessage,"guild") end
				InviterMsgFrame:RegisterEvent("CHAT_MSG_GUILD")
				InviterMsgFrame:RegisterEvent("CHAT_MSG_ADDON")
				InviterMsgFrame:RegisterEvent("CHAT_MSG_CHANNEL")
				if not DA_Inviter.startMenuFrame.silentstart:GetChecked() then SendAddonMessage("SRranons",GetUnitName("player"), "guild") end
				
				if fuckingOptions.SR_pm then InviterMsgFrame:RegisterEvent("CHAT_MSG_WHISPER") end
				
				add_additional_invites()
				
			end
		end
	)
	
	
end


-- STOP button
DA_Inviter.stopbtn=DA.CreateFFGButton2(nil,  DA_Inviter,  {"TOPLEFT", DA_Inviter, "TOPLEFT", 90, -120},  12,  50,  L["stop"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',  {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
	function(self)
		if Inviter_Started==false then
			DA_Inviter.stopbtn:Disable()
			convertedToRaid=false
			DEFAULT_CHAT_FRAME:AddMessage("      -->>"..L['Raid inviter is already disabled'],1,0.2,0.2)
			DA.listinvite_bulk=nil
			DA.listinvite_bulk={}
			DA.StopTimer("inviter");DA.XTimers["inviter"].mytime=nil;DA.XTimers["inviter"].mytime2=nil
		else
			DA.listinvite_bulk=nil
			DA.listinvite_bulk={}
			DA.StopTimer("inviter");DA.XTimers["inviter"].mytime=nil;DA.XTimers["inviter"].mytime2=nil
			convertedToRaid=false
			DA_Inviter.stopbtn:Disable()
			DA_Inviter.startbtn:SetText(L['start'])
			Inviter_Started=false
			DEFAULT_CHAT_FRAME:AddMessage("      -->>"..L['Raid inviter is disabled now'],1,0.5,0.5)
			if not DA_Inviter.startMenuFrame.silentstart:GetChecked() then SendChatMessage(fuckingOptions_g[DA_CurrentGuild].inviter_stop,"guild") end
			if fuckingOptions.SR_autojoin then else InviterMsgFrame:UnregisterEvent("CHAT_MSG_CHANNEL");end
			if fuckingOptions.SR_autoaccept then else InviterMsgFrame:UnregisterEvent("PARTY_INVITE_REQUEST");end
			if fuckingOptions.SR_pm then else InviterMsgFrame:UnregisterEvent("CHAT_MSG_WHISPER");end
		end
	end
)
DA_Inviter.stopbtn:Disable()

-- auto-stop
DA.CheckBtnCreater(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 145, -118},20,20,L['auto-stop'],function(self) fuckingOptions.SR_autostop=(self:GetChecked() or false) end,{'fuckingOptions','SR_autostop'},nil)
DA.EditBoxCreater2(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 215, -123},{20,30},fuckingOptions.RTstoper,true,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions","RTstoper"},nil,nil,'text')

-- ask join RT button
DA_Inviter.askbtn=DA.CreateFFGButton2(nil,  DA_Inviter,  {"TOPLEFT", DA_Inviter, "TOPLEFT", 160, -160},  12,  70,  L['join raid'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black', {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
	function(self)
		if (GetNumRaidMembers()==0 and GetNumPartyMembers()==0) then 
			SendAddonMessage("DA_join","join", "guild")
			SRwant2invite="any22"
		else
			DA.Print("|cffffaa99     >>"..L['You are already in raid!'])
		end
	end
)
DA_Inviter.askbtn:Disable()
DA_Inviter.askfont1=DA.FontCreater(nil,L['Cant find any raids'],{"TOPLEFT", DA_Inviter, "TOPLEFT", 250, -102},DA_Inviter.startMenuBtn,15,130,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"})
DA_Inviter.askfont2=DA.FontCreater(nil,"",{"TOPLEFT", DA_Inviter, "TOPLEFT", 250, -132},DA_Inviter.startMenuBtn,30,130,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"})

-- announce RT
DA.CheckBtnCreater(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 20, -20},20,20,L['auto-anons RT each'],function(self) fuckingOptions.SR_enab=(self:GetChecked() or false) end,{'fuckingOptions','SR_enab'},nil)
-- сбщ о сборе
local function mincou(znak)
	if znak=="+" then
		fuckingOptions.SR_minutecount=fuckingOptions.SR_minutecount+1
		DA_Inviter.anonsfont:SetText(fuckingOptions.SR_minutecount.." "..L['minutes_short'])
	elseif znak=="-" then
		if fuckingOptions.SR_minutecount>1 then
			fuckingOptions.SR_minutecount=fuckingOptions.SR_minutecount-1
			DA_Inviter.anonsfont:SetText(fuckingOptions.SR_minutecount.." "..L['minutes_short'])
		end
	end
end
DA.CreateFFGButton2(nil,  DA_Inviter,  {"TOPLEFT", DA_Inviter, "TOPLEFT", 160, -23},  12,  12,  "+",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',   {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
	function(self)
		mincou("+")		
	end
)
DA.CreateFFGButton2(nil,  DA_Inviter,  {"TOPLEFT", DA_Inviter, "TOPLEFT", 175, -23},  12,  12,  "-",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',  {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
	function(self)
		mincou("-")	
	end
)
DA_Inviter.anonsfont=DA.FontCreater(nil,fuckingOptions.SR_minutecount.." "..L['minutes_short'],{"TOPLEFT", DA_Inviter, "TOPLEFT", 180, -23},DA_Inviter.startMenuBtn,15,55,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"})
DA.EditBoxCreater2(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 245, -20},{150,30},fuckingOptions.RTmessage,true,nil,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},{"fuckingOptions","RTmessage"},nil,nil,'text')
----------ДИСКОРД
DA.CheckBtnCreater(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 20, -50},20,20,L['provide discord if asked'],function(self) fuckingOptions.SR_discenab=(self:GetChecked() or false) end,{'fuckingOptions','SR_discenab'},nil)
DA.CreateFFGButton2(nil,  DA_Inviter,  {"TOPLEFT", DA_Inviter, "TOPLEFT", 170, -53},  12,  50,  L['send'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',  {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
	function(self)
		if fuckingOptions.RTdiscordlink~="https://discord.gg/discord_link_here" then
			SendChatMessage(fuckingOptions.RTdiscordlink,"RAID")
			SendChatMessage(fuckingOptions.RTdiscordlink,"RAID_WARNING")
		else
			DA.Print("")
		end
	end
)
-- для линки дс
DA.EditBoxCreater2(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 245, -50},{150,30},fuckingOptions.RTdiscordlink,true,nil,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},{"fuckingOptions","RTdiscordlink"},nil,nil,'text')
-- авто участие в рт
if fuckingOptions.SR_autojoin then InviterMsgFrame:RegisterEvent("CHAT_MSG_ADDON") else InviterMsgFrame:UnregisterEvent("CHAT_MSG_ADDON") end
DA.CheckBtnCreater(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 20, -140},20,20,L['auto-join RT'],function(self) fuckingOptions.SR_autojoin=(self:GetChecked() or false) if self:GetChecked() then InviterMsgFrame:RegisterEvent("CHAT_MSG_ADDON") else InviterMsgFrame:UnregisterEvent("CHAT_MSG_ADDON") end end,{'fuckingOptions','SR_autojoin'},nil)
-- авто принятие пати
DA.CheckBtnCreater(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 130, -140},20,20,L['auto-accept party'],function(self) fuckingOptions.SR_autoaccept=(self:GetChecked() or false) if not self:GetChecked() then InviterMsgFrame:UnregisterEvent("PARTY_INVITE_REQUEST") end end,{'fuckingOptions','SR_autoaccept'},nil)
--приём в ги
DA.CheckBtnCreater(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 20, -70},20,20,L['accept from guild chat'],function(self) fuckingOptions.SR_gc=(self:GetChecked() or false) end,{'fuckingOptions','SR_gc'},nil)
--приём через лс
DA.CheckBtnCreater(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 20, -85},20,20,L['accept from pm'],function(self) fuckingOptions.SR_pm=(self:GetChecked() or false) end,{'fuckingOptions','SR_pm'},nil)
--приём из лфг
DA.CheckBtnCreater(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 20, -100},20,20,L['accept from global'],function(self) fuckingOptions.SR_lfg=(self:GetChecked() or false) end,{'fuckingOptions','SR_lfg'},nil)
DA.CreateFFGButton2(nil,  DA_Inviter,  {"TOPLEFT", DA_Inviter, "TOPLEFT", 130, -103},  12,  30,  "@",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',  {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
	function(self)
		if PhrasesFrame:IsShown() then
			PhrasesFrame:Hide()
		else
			PhrasesFrame:Show()
		end
	end,'SR_lfg_messages'
)

if fuckingOptions.RTlfgphrases=="" then
	fuckingOptions.RTlfgphrases=L['DA_Default_LFG_samples']
end
DA.EditBoxCreater(nil,PhrasesFrame,{"TOPLEFT", PhrasesFrame, "TOPLEFT", 5, -5},{PhrasesFrame.width-10,PhrasesFrame.height-10},fuckingOptions.RTlfgphrases,true,false,{"Fonts\\FRIZQT__.TTF", 10},
function(self) self.t:SetBlendMode("ADD"); self:ClearFocus();fuckingOptions.RTlfgphrases=self:GetText() end,
false,
function(self) self.t:SetBlendMode("ADD"); self:ClearFocus();fuckingOptions.RTlfgphrases=self:GetText() end,
function(self) self.t:SetBlendMode("BLEND") end
)

--opt

if not fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern then
	fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern="+"
end
local eb_inviter_pattern = DA.EditBoxCreater2(nil,DA_Inviter.OptionsFr,{"LEFT",DA_Inviter.OptionsFr,"TOPLEFT",5,-20},{220,12},fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","inviter_inv_pattern",'DA_CurrentGuild'},1,255,'text')
DA.FontCreater(nil,"Invite pattern",{"BOTTOMLEFT",eb_inviter_pattern,"TOPLEFT",5,-2},eb_inviter_pattern,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')


if not fuckingOptions_g[DA_CurrentGuild].inviter_stop then
	fuckingOptions_g[DA_CurrentGuild].inviter_stop=L['raidinv_stop_msg']
end
local eb_inviter_stop = DA.EditBoxCreater2(nil,DA_Inviter.OptionsFr,{"LEFT",DA_Inviter.OptionsFr,"TOPLEFT",5,-50},{220,12},fuckingOptions_g[DA_CurrentGuild].inviter_stop,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","inviter_stop",'DA_CurrentGuild'},1,255,'text')
DA.FontCreater(nil,"Stop message",{"BOTTOMLEFT",eb_inviter_stop,"TOPLEFT",5,-2},eb_inviter_stop,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')


if not fuckingOptions_g[DA_CurrentGuild].inviter_repeat then
	fuckingOptions_g[DA_CurrentGuild].inviter_repeat=L['Type + in guild chat if you are still not in raid']
end
local eb_inviter_repeat = DA.EditBoxCreater2(nil,DA_Inviter.OptionsFr,{"LEFT",DA_Inviter.OptionsFr,"TOPLEFT",5,-80},{220,12},fuckingOptions_g[DA_CurrentGuild].inviter_repeat,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","inviter_repeat",'DA_CurrentGuild'},1,255,'text')
DA.FontCreater(nil,"Repeat message",{"BOTTOMLEFT",eb_inviter_repeat,"TOPLEFT",5,-2},eb_inviter_repeat,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')


if not fuckingOptions_g[DA_CurrentGuild].inviter_autostop then
	fuckingOptions_g[DA_CurrentGuild].inviter_autostop=L['Invite auto-stopped']
end
local eb_inviter_autostop = DA.EditBoxCreater2(nil,DA_Inviter.OptionsFr,{"LEFT",DA_Inviter.OptionsFr,"TOPLEFT",5,-110},{220,12},fuckingOptions_g[DA_CurrentGuild].inviter_autostop,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","inviter_autostop",'DA_CurrentGuild'},1,255,'text')
DA.FontCreater(nil,"Auto-stop message",{"BOTTOMLEFT",eb_inviter_autostop,"TOPLEFT",5,-2},eb_inviter_autostop,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')



-----------
-----------
-----------
DA.CreateScaler('DA_Inviter',0.6,2,{'fuckingOptions','SRScale'})


end

local function zdatasend()
	if IsRaidLeader() then 
		local leader=GetUnitName("player")
		local leader_loc=GetRealZoneText()
		return leader,leader_loc
	else
		local leader
		local leader_loc
		for i=1,40 do
			if select(2,GetRaidRosterInfo(i))==2  then
			leader=select(1,GetRaidRosterInfo(i))
			leader_loc=select(7,GetRaidRosterInfo(i))
			break
			end
		end
		return leader,leader_loc
	end
end
local function dungnamesrch(lok)
	for i=1,320 do
		if GetLFGDungeonInfo(i) then
			local nam,typ=GetLFGDungeonInfo(i)
			if typ==2 and nam==lok then 
				return true
			end
		end 
	end
end
DA:RegisterComm("DA_join", 
	function(_, _, sender)
		if sender~=GetUnitName("player") and DA.IsInSameGuild(sender) and Inviter_Started and not UnitInRaid(sender) then
			local index={}
			for k,v in pairs(DA.listinvite_bulk) do
			  index[v]=k
			end
			if index[sender] then return else 
			table.insert(DA.listinvite_bulk,sender)
			end
		end 
	end
)
DA:RegisterComm("DA_RTq", 
	function(_, _, sender)
		if sender~=GetUnitName("player") and DA.IsInSameGuild(sender) and IsRaidOfficer() and Inviter_Started then
			local lead,loc=zdatasend()
			local leadlock=nil
			if lead and loc then leadlock=lead..","..loc end
			SendAddonMessage("DA_RTa", (leadlock or "text"), "WHISPER", sender)
		end 
	end
)
DA:RegisterComm("DA_RTa", 
	function(message, _, sender)
		if DA.IsInSameGuild(sender) then
			if message=="text" then
				DA_Inviter.askbtn:Enable()
				DA_Inviter.askfont1:SetText(L['Ongoing raid'])
				DA_Inviter.askfont2:SetText(L['RL/assist']..": "..sender)
			else
				local rl,lok=string.match(message, "[^,]+"),string.match(message, "[^,]+",message:find(","))
				DA_Inviter.askbtn:Enable()
				DA_Inviter.askfont1:SetText(L['Ongoing raid'])
				
				if dungnamesrch(lok) then else lok=nil end
				if rl==sender then 
					DA_Inviter.askfont2:SetText((lok or "")..L['inv_RL']..rl)
				else
					DA_Inviter.askfont2:SetText((lok or "")..L['inv_RL']..rl..L['inv_inv']..sender)
				end
			end
		end
	end
)
