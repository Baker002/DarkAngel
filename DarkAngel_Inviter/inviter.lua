
---@class DarkAngelAddon
local DA = DarkAngel
local L = DA.L
local Mod = DA:NewModule("Inviter")

local Inviter_response_idle={}
local Inviter_responseFrame=CreateFrame("Frame")
local Inviter_responsepatterns = {
	ERR_INVITE_PLAYER_S,
	ERR_DECLINE_GROUP_S,
	ERR_IGNORING_YOU_S,
	ERR_ALREADY_IN_GROUP_S,
	ERR_BAD_PLAYER_NAME_S
}
local listinvite_bulk={}
local function removeFromList(name)
    for i, j in ipairs(listinvite_bulk) do
        if j == name then
            table.remove(listinvite_bulk, i)
            return
        end
    end
end

local convertedToRaid=false
local Inviter_Started=false
local InviterMsgFrame=CreateFrame("FRAME");
-- local SRwant2invite="no"
Inviter_responseFrame:SetScript("OnEvent",function(_,event,msg)
	if not Inviter_Started then return end

	if event=="UI_ERROR_MESSAGE" then
		if msg:find(ERR_INVITE_NO_PARTY_SERVER) then
			UIErrorsFrame:Clear()
			DA.Inviter_responsetimer=DA.Inviter_responsetimer+0.1
			DA.SetTimerSpeed('proc_invite_fast',DA.Inviter_responsetimer)
			table.wipe(Inviter_response_idle)
		end
	elseif event=="CHAT_MSG_SYSTEM" then
		for _, fmt in ipairs(Inviter_responsepatterns) do
			local _, _, name = string.find(msg, string.format(fmt, "(.+)"))
			if name then
				removeFromList(name)
				return
			end
		end
	end
end)
local Raids_Create_ScrollBar
local Inviter_UpdateRaidBrowser


DA_Inviter=DA.FrameCreater("DA_Inviter",UIParent,272,163,{"CENTER", UIParent, "CENTER", 0, 0},[[Interface\AddOns\DarkAngel\template\pict\art_inviter]],nil,1)
DA_Inviter:RegisterForDrag("LeftButton")
DA_Inviter:SetScript("OnDragStart", DA_Inviter.StartMoving)
DA_Inviter:SetScript("OnDragStop", function(self)

	self:StopMovingOrSizing(self)

	local point={DA_Inviter:GetPoint(1)}
	fuckingOptions.saved_guiPositions.DA_Inviter={point[1] or "TOPLEFT",point[3] or "CENTER",point[4] or 0,point[5] or 0}

end)
DA_Inviter.OpenClose=function()
	SendAddonMessage("DA_RTq",'1', "guild")
	if DA_Inviter:IsShown() then
		DA_Inviter:Hide()
	else
		DA_Inviter:Show()
	end
end
DA.CloseButtonCreater(nil,DA_Inviter,{"TOPRIGHT", DA_Inviter, "TOPRIGHT", -5,-5},12,12,'x')



DA_Inviter.OptionsFr=DA.FrameCreater(nil,DA_Inviter,250,163,{"TOPLEFT", DA_Inviter, "TOPRIGHT", 3, 0})
	DA_Inviter.OptionsFr:RegisterForDrag("LeftButton")
	DA_Inviter.OptionsFr:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
	DA_Inviter.OptionsFr:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
DA.CloseButtonCreater(nil,DA_Inviter.OptionsFr,{"TOPRIGHT", DA_Inviter.OptionsFr, "TOPRIGHT", -2,-1},10,10,'x')

DA.OptionsButtonCreater(nil,DA_Inviter,{"TOPRIGHT", DA_Inviter, "TOPRIGHT", -20,-5},12,12,function(self)
	if DA_Inviter.OptionsFr:IsShown() then
		DA_Inviter.OptionsFr:Hide()
	else
		DA_Inviter.OptionsFr:Show()
	end
end)


DA_Inviter.addInvFr=DA.FrameCreater(nil,DA_Inviter,272,80,{"TOPLEFT", DA_Inviter, "BOTTOMLEFT", 0, -3})
	DA_Inviter.addInvFr:RegisterForDrag("LeftButton")
	DA_Inviter.addInvFr:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
	DA_Inviter.addInvFr:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
DA.CloseButtonCreater(nil,DA_Inviter.addInvFr,{"TOPRIGHT", DA_Inviter.addInvFr, "TOPRIGHT", -2,-1},10,10,'x')

DA_Inviter.ongoingRaidsFrame=DA.FrameCreater(nil,DA_Inviter,200,230,{"TOPRIGHT", DA_Inviter, "TOPLEFT", -3, 0})
DA_Inviter.ongoingRaidsBtn=DA.CreateFFGButton2(nil,  DA_Inviter,  {"TOPRIGHT", DA_Inviter, "TOPRIGHT", -35,-5},  12,  12,  "r",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],  {UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},function()
	if DA_Inviter.ongoingRaidsFrame:IsShown() then
		DA_Inviter.ongoingRaidsFrame:Hide()
	else
		Inviter_UpdateRaidBrowser()
		DA_Inviter.ongoingRaidsFrame:Show()
	end
end)
	DA_Inviter.ongoingRaidsFrame:RegisterForDrag("LeftButton")
	DA_Inviter.ongoingRaidsFrame:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
	DA_Inviter.ongoingRaidsFrame:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
DA.CloseButtonCreater(nil,DA_Inviter.ongoingRaidsFrame,{"TOPRIGHT", DA_Inviter.ongoingRaidsFrame, "TOPRIGHT", -2,-1},10,10,'x')

local expectingInvite={}
local function addToExpectingInvite(name)
	expectingInvite[name] = time()
end
local function InviteRemoveFromExpected(name)
	expectingInvite[name] = nil
end
local function isInviteExpected(name)
	if expectingInvite[name] then
		if time() - expectingInvite[name] <= 20 then
			return true
		else
			InviteRemoveFromExpected(name)
		end
	end
end
local function check_lfg_samples_for_msg(message)
	for _,sampl in ipairs(fuckingOptions_g[DA_CurrentGuild].Inviter_LFGPhrases) do
		if sampl == message then
			return true
		end
	end
end
local function getRaidLeaderAndZoneName()
	local leader=GetUnitName("player")
	local leader_loc=GetRealZoneText()
	if not IsRaidLeader() then
		for i=1,40 do
			if select(2,GetRaidRosterInfo(i))==2  then
				leader=select(1,GetRaidRosterInfo(i))
				leader_loc=select(7,GetRaidRosterInfo(i))
				break
			end
		end
	end

	return leader..","..leader_loc
end
local function AddInQueue(_, event, message, author, dtype,EV_author, _)
	if not Inviter_Started then
		if fuckingOptions_g[DA_CurrentGuild].Inviter_AutoJoinRT and (event=="CHAT_MSG_GUILD" or event=="CHAT_MSG_ADDON") and (GetNumRaidMembers()==0 and GetNumPartyMembers()==0) then
			if (string.sub(message,0,3)=="RT+" or string.sub(message,0,5)=="РТ+" or (message=="DA_RTbeacon" and dtype=="GUILD") ) then
				if event=="CHAT_MSG_GUILD" and not isInviteExpected(author) then
					addToExpectingInvite(author)
					SendChatMessage("+","guild")
				elseif event=="CHAT_MSG_ADDON" and not isInviteExpected(EV_author) then
					DA.Print(L["joining raid..."])
					addToExpectingInvite(EV_author)
					SendAddonMessage("DA_join",EV_author, "guild")
				end
			end
		end
		if not fuckingOptions_g[DA_CurrentGuild].Inviter_AutoAcceptOnJoinRT then return end

		if event=="PARTY_INVITE_REQUEST" and isInviteExpected(message) then
			InviteRemoveFromExpected(message)
			InviterMsgFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
			AcceptGroup()
		end
		if event=="PARTY_MEMBERS_CHANGED" then
		  StaticPopup_Hide("PARTY_INVITE")
		  InviterMsgFrame:UnregisterEvent("PARTY_MEMBERS_CHANGED")
		end

		return
	end


	if event=="CHAT_MSG_CHANNEL" then
		if fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromLFG then
			if #fuckingOptions_g[DA_CurrentGuild].Inviter_LFGPhrases==0 then
				fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromLFG=false
				DA.Print(L['LFG samples are nil, LFG inviter disabled'])
				return
			end
			if check_lfg_samples_for_msg(message) then
				if UnitInRaid(author) then
				else
					local index={}
					for k,v in pairs(listinvite_bulk) do
					   index[v]=k
					end
					if index[author] then return else table.insert(listinvite_bulk,author) end
				end
			end
		end
	end

	if event=="CHAT_MSG_GUILD" then
		if fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromGuild and author~=UnitName('player') and string.sub(message,0,#fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern)==fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern then
			if UnitInRaid(author) then else
				local index={}
				for k,v in pairs(listinvite_bulk) do
				   index[v]=k
				end
				if index[author] then return else table.insert(listinvite_bulk,author) end
			end
		end
	end

	if event=="CHAT_MSG_WHISPER" then
		if fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromPM and string.sub(message,0,#fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern)==fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern then
			if UnitInRaid(author) then
			else
				local index={}
				for k,v in pairs(listinvite_bulk) do
				   index[v]=k
				end

				if index[author] then
					return
				else
					table.insert(listinvite_bulk,tostring(author))
				end
			end
		end
	end

	--convert to raid
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
local function checkOnlyGuildPerm()
	if GetNumRaidMembers()==0 then return false end
	if not fuckingOptions.Inviter_shareDiscordOnlyInGuild then return true end
	return DA.IsFullGuildRaid(fuckingOptions.Inviter_shareDiscordOnlyInFullGuild)
end
local function GiveDiscordLink(_, _, message, _)
	if (Inviter_Started==true and fuckingOptions_g[DA_CurrentGuild].Inviter_shareDiscord and fuckingOptions_g[DA_CurrentGuild].Inviter_RTDiscord~="https://discord.gg/discord_link" and not checkOnlyGuildPerm()) then
		if discordphrases[message] then
			SendChatMessage(fuckingOptions_g[DA_CurrentGuild].Inviter_RTDiscord,"raid")
		end
	end
end
AskDiscordFrame:SetScript("OnEvent", GiveDiscordLink);
AskDiscordFrame:RegisterEvent("CHAT_MSG_RAID");



function Mod:OnInitialize()
	DA_Inviter:SetScale(fuckingOptions.SRScale)

end

function Mod:OnEnable()
	if UISpecialFrames then
		tinsert(UISpecialFrames, "DA_Inviter")
	end

	DA:ModuleLoaded("Inviter")
end
local autoStopTime={}
local writeNewTiming
local function IsAutoStopTimeReached()

	local endTime, stopH, stopM = autoStopTime.endTime, autoStopTime.stopH, autoStopTime.stopM
	if endTime then
		return time()-endTime >= 0
	elseif stopH and stopM then
		local h,m = tonumber(date("%H")),tonumber(date("%M"))
		if stopH>h then
			return false
		elseif stopH<h or (stopH==h and stopM<=m) then
			return true
		end
	
	end
	return false
end


local function getInviterAutostopTmstText()
	local msg = fuckingOptions_g[DA_CurrentGuild].inviter_autostop_msg
	local stopTime = fuckingOptions_g[DA_CurrentGuild].Inviter_TimeAutoStop
	if msg:find("$1") then 
		if stopTime:find(":") then
			return (msg:gsub("$1", "("..stopTime..")"))
		end
		return (msg:gsub("$1", "("..stopTime.." "..L['minutes_short']..")"))
	end
	return msg
end
function Mod:OnGuildLoad()
	--inviter processor
	DA.CreateTimer(nil,"proc_invite_timer",0,fuckingOptions.Inviter_manualTimerSpeed,true,function(self)
		if listinvite_bulk[1] then
			InviteUnit(listinvite_bulk[1])
			table.remove(listinvite_bulk,1)
		else
			self:SetScript("OnUpdate",nil)
			self.time=0
		end
	end)

	--inviter timer
	DA.CreateTimer(nil,"inviter",0,0.1,true,function(self)
		self.mytime=self.mytime or time()
		if listinvite_bulk[1] and UnitInRaid(listinvite_bulk[1]) then
			repeat
				if listinvite_bulk[1] and UnitInRaid(listinvite_bulk[1]) then table.remove(listinvite_bulk,1) end
			until ((not listinvite_bulk[1]) or (not UnitInRaid(listinvite_bulk[1])))
		end
		if listinvite_bulk[1] then
			if fuckingOptions.Inviter_TimerMode==3 then
				DA.ResumeTimer("proc_invite_timer")
			elseif fuckingOptions.Inviter_TimerMode==1 then
				Inviter_responseFrame:RegisterEvent("CHAT_MSG_SYSTEM")
				Inviter_responseFrame:RegisterEvent("UI_ERROR_MESSAGE")

				DA.ResumeTimer("proc_invite_fast")
			elseif fuckingOptions.Inviter_TimerMode==2 then
				for _,name in ipairs(listinvite_bulk) do
					if name and not UnitInRaid(name) then
						InviteUnit(name)
					end
				end
				table.wipe(listinvite_bulk)
			end


		end

		--autostop
		if fuckingOptions_g[DA_CurrentGuild].Inviter_AutoStop and IsAutoStopTimeReached() then
			self:SetScript("OnUpdate",nil)
			listinvite_bulk=nil
			listinvite_bulk={}
			self.mytime=nil
			convertedToRaid=false
			DA_Inviter.stopbtn:Disable()
			DA_Inviter.startbtn:Enable()
			Inviter_Started=false
			DA.Print("  -->>"..getInviterAutostopTmstText())
			if fuckingOptions_g[DA_CurrentGuild].inviter_autostop_msg:gsub("%s+","")~="" then
				SendChatMessage(getInviterAutostopTmstText(),"guild")
			end
			
			if fuckingOptions_g[DA_CurrentGuild].Inviter_AutoJoinRT then else InviterMsgFrame:UnregisterEvent("CHAT_MSG_CHANNEL");end
			if fuckingOptions_g[DA_CurrentGuild].Inviter_AutoAcceptOnJoinRT then else InviterMsgFrame:UnregisterEvent("PARTY_INVITE_REQUEST");end
			if fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromPM then else InviterMsgFrame:UnregisterEvent("CHAT_MSG_WHISPER");end
			return
		end

		--send guild msg
		if fuckingOptions_g[DA_CurrentGuild].Inviter_RepeatAnons and Inviter_Started==true then
			if time()-self.mytime>=fuckingOptions_g[DA_CurrentGuild].Inviter_RepeatMsgOnTime then
				self.mytime=time()
				SendAddonMessage("DA_RTbeacon",getRaidLeaderAndZoneName(), "guild")
				SendChatMessage(fuckingOptions_g[DA_CurrentGuild].Inviter_RTMessage,"guild")
			end
		end
	end)

	--inviter processor
	DA.Inviter_responsetimer=0.2
	DA.CreateTimer(nil,"proc_invite_fast",0,DA.Inviter_responsetimer,true,function(self)
		if #listinvite_bulk>0 then
			local invsent
			local smthdeleted
			for i,name in ipairs(listinvite_bulk) do
				if name and Inviter_response_idle[name] and Inviter_response_idle[name]>3 then
					listinvite_bulk[i]=nil
					smthdeleted=true
				elseif name and Inviter_response_idle[name] then
					Inviter_response_idle[name]=Inviter_response_idle[name]+1
				elseif name and not invsent then
					InviteUnit(name)
					Inviter_response_idle[name]=0
					invsent=true
				end
			end

			if smthdeleted then
				local new_list = {}
				for i, name in ipairs(listinvite_bulk) do
					if name then
						table.insert(new_list, name)
					end
				end
				listinvite_bulk = new_list
			end

		else
			self:SetScript("OnUpdate",nil)
			table.wipe(Inviter_response_idle)
			Inviter_responseFrame:UnregisterEvent("CHAT_MSG_SYSTEM")
			self.time=0
		end
	end)

	if fuckingOptions_g[DA_CurrentGuild].Inviter_AutoJoinRT then
		InviterMsgFrame:RegisterEvent("CHAT_MSG_GUILD")
		InviterMsgFrame:RegisterEvent("CHAT_MSG_CHANNEL")
	end
	if fuckingOptions_g[DA_CurrentGuild].Inviter_AutoAcceptOnJoinRT then InviterMsgFrame:RegisterEvent("PARTY_INVITE_REQUEST");end

	self:Inviter_Load()
end

function Mod:Inviter_Load()
	local function ebAlpha(value, eb)
		if value then
			eb:SetAlpha(1)
			eb:EnableMouse(true)
		else
			eb:SetAlpha(0.6)
			eb:EnableMouse(false)
			eb:ClearFocus()
		end
	end
	do -- announce RT
		local anonsRTEB
		local anonsRTChbx = DA.CheckBtnCreater(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 20, -20},20,20,L['repeating announce'],function(self) fuckingOptions_g[DA_CurrentGuild].Inviter_RepeatAnons=(self:GetChecked() or false);ebAlpha(fuckingOptions_g[DA_CurrentGuild].Inviter_RepeatAnons, anonsRTEB) end,{'fuckingOptions_g','Inviter_RepeatAnons','DA_CurrentGuild'},'invRepMsgdsc')
		DA.FontCreater(nil,"Raid Time Inviter",{"BOTTOMLEFT",anonsRTChbx,"TOPLEFT",-15,1},anonsRTChbx,14,180,{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},'left')
		DA_Inviter.silentstart=DA.CheckBtnCreater(nil,anonsRTChbx,{"CENTER",anonsRTChbx,"CENTER",13,-11},15,15,L['start silently'],nil,nil,'silentlstart')

		local AnonsEBFLVL
		local function anonsescfunc(self)
			if self.focusgained then self.t:SetBlendMode("ADD");self:ClearFocus();self.focusgained=nil;
				fuckingOptions_g[DA_CurrentGuild].Inviter_RTMessage = self:GetText();
				self:SetMultiLine(false);self:SetSize(190,9.08);self:SetFrameLevel(AnonsEBFLVL)
				self:SetCursorPosition(0)
			end
		end
		local function anonsonfocusfunc(self)
			if self:GetParent():IsShown() then
				AnonsEBFLVL = self:GetFrameLevel()

				self.t:SetBlendMode('blend');
				self.focusgained=1
				local text=self:GetText();
				self:SetText("");self:SetMultiLine(true);self:SetText(text);
				self:SetFrameLevel(AnonsEBFLVL+20)
			end
		end
		anonsRTEB = DA.EditBoxCreater(nil,anonsRTChbx,{"TOPLEFT", anonsRTChbx, "BOTTOMLEFT", 18, -8},{190,9.08},fuckingOptions_g[DA_CurrentGuild].Inviter_RTMessage,false,false,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},anonsescfunc,anonsescfunc,anonsescfunc,anonsonfocusfunc)
		anonsRTEB:HookScript("OnEnter",function(self)
			if self:GetParent():IsShown() and not self.focusgained then
				AnonsEBFLVL = self:GetFrameLevel()
				local text=self:GetText();
				self:SetText("");self:SetMultiLine(true);self:SetText(text);
				self:SetFrameLevel(AnonsEBFLVL+20)
			end
		end)
		anonsRTEB:HookScript("OnLeave",function(self)
			if not self.focusgained then
				DA.TimerAfter(0, function()
					self:SetMultiLine(false);
					self:SetSize(190,9.08);
					self:SetFrameLevel(AnonsEBFLVL)
					self:SetCursorPosition(0)
				end)
			end
		end)
		anonsRTEB:SetCursorPosition(0)
		AnonsEBFLVL = anonsRTEB:GetFrameLevel()
		DA.CreateFFGButton2(nil,  anonsRTEB,  {"LEFT", anonsRTEB, "RIGHT", 3, 0},  12,  30,  L['send'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],  {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
			SendChatMessage(fuckingOptions_g[DA_CurrentGuild].Inviter_RTMessage,"GUILD")
		end)

		ebAlpha(fuckingOptions_g[DA_CurrentGuild].Inviter_RepeatAnons, anonsRTEB)
		table.insert(DA.RunOnGuildUpdate, function() ebAlpha(fuckingOptions_g[DA_CurrentGuild].Inviter_RepeatAnons, anonsRTEB) end)

		local InviterGearBox ={
			{5, "5 sec. Crazy??"},
			{10, "10 sec"},
			{20, "20 sec"},
			{30, "30 sec"},
			{40, "40 sec"},
			{50, "50 sec"},
			{60, "1 min"},
			{120, "2 min"},
			{180, "3 min"},
			{240, "4 min"},
			{300, "5 min"},
			{360, "6 min"},
			{420, "7 min"},
			{480, "8 min"},
			{540, "9 min"},
			{600, "10 min"},
			{900, "15 min"},
			{1200, "20 min"},
			{1500, "25 min"},
			{1800, "30 min"}
		}
		DA.SliderCreater2('DA_Inviter_AnnounceTimeSelect',anonsRTChbx,{"LEFT",anonsRTChbx,"RIGHT",140,0},15,120, InviterGearBox, {UIDarkAngelFontConsolas:GetFont(), 12, "OUTLINE"}, {'fuckingOptions_g','Inviter_RepeatMsgOnTime','DA_CurrentGuild'},'','',nil,nil,function() end)

	end

	-- Accept From
	DA.CheckBtnCreater(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 20, -60},20,20,L['accept from guild chat'],function(self) fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromGuild=(self:GetChecked() or false) end,{'fuckingOptions_g','Inviter_AcceptFromGuild','DA_CurrentGuild'},nil)
	--приём через лс
	DA.CheckBtnCreater(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 20, -75},20,20,L['accept from pm'],function(self) fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromPM=(self:GetChecked() or false) end,{'fuckingOptions_g','Inviter_AcceptFromPM','DA_CurrentGuild'},nil)
	

	do -- auto-stop
		do -- prevent errors in saved var
			if type(fuckingOptions_g[DA_CurrentGuild].Inviter_TimeAutoStop)=='number' then
				fuckingOptions_g[DA_CurrentGuild].Inviter_TimeAutoStop = tostring(fuckingOptions_g[DA_CurrentGuild].Inviter_TimeAutoStop)
			end
			local setting = fuckingOptions_g[DA_CurrentGuild].Inviter_TimeAutoStop
			
			local stopH,stopM = setting:match("^(%d?%d):(%d?%d)$")
			local simpleNumber = setting:match("^(%d+)$")
			if stopH and stopM or simpleNumber then
			else
				fuckingOptions_g[DA_CurrentGuild].Inviter_TimeAutoStop = "5"
			end
		end
		DA_Inviter.autostopChb = DA.CheckBtnCreater(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 25, -94},20,20,L['auto-stop'],function(self) fuckingOptions_g[DA_CurrentGuild].Inviter_AutoStop=(self:GetChecked() or false);writeNewTiming() end,{'fuckingOptions_g','Inviter_AutoStop','DA_CurrentGuild'},'invAutostpdsc')
		DA_Inviter.autostopEb = DA.EditBoxCreater2(nil,DA_Inviter,{"LEFT", DA_Inviter.autostopChb, "RIGHT", 60, 0},{40,30},fuckingOptions_g[DA_CurrentGuild].Inviter_TimeAutoStop,true,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","Inviter_TimeAutoStop",'DA_CurrentGuild'},nil,nil,'text')
		writeNewTiming = function()
			local Eb = DA_Inviter.autostopEb
			local Cb = DA_Inviter.autostopChb
			local text = Eb:GetText():gsub("%s+","")
			if text=="" or text:find("[^%d%s:]") then
				table.wipe(autoStopTime)
				fuckingOptions_g[DA_CurrentGuild].Inviter_AutoStop = false
				Cb:SetChecked(false)
				Eb:SetBadColor()
				return
			end
			local stopH,stopM = text:match("^(%d?%d):(%d?%d)$")
			if ((tonumber(stopH) or 99) <25) and ((tonumber(stopH) or 99) >=0) and ((tonumber(stopM) or 25) <60) and ((tonumber(stopM) or 25) >=0) then
				autoStopTime.stopH, autoStopTime.stopM = tonumber(stopH), tonumber(stopM)
				Eb:SetGoodColor()
				return
			end
			local simpleNumber = text:match("^(%d+)$")
			if simpleNumber then
				autoStopTime.endTime = time() + (tonumber(simpleNumber)*60)
				Eb:SetGoodColor()
				return
			end

			table.wipe(autoStopTime)
			fuckingOptions_g[DA_CurrentGuild].Inviter_AutoStop = false
			Cb:SetChecked(false)
			Eb:SetBadColor()
		end
		
		DA_Inviter.autostopEb:HookScript("OnEscapePressed", writeNewTiming)
		DA_Inviter.autostopEb:HookScript("OnEnterPressed", writeNewTiming)
		DA_Inviter.autostopEb:HookScript("OnEditFocusLost", writeNewTiming)
		
	end

	do -- auto-join
		
		DA.HelpCreater(DA_Inviter.ongoingRaidsFrame,{"TOPLEFT", DA_Inviter.ongoingRaidsFrame, "TOPLEFT", 2, -2},'ongRaidstt',10,10)

		if fuckingOptions_g[DA_CurrentGuild].Inviter_AutoJoinRT then InviterMsgFrame:RegisterEvent("CHAT_MSG_ADDON") else InviterMsgFrame:UnregisterEvent("CHAT_MSG_ADDON") end

		DA.CheckBtnCreater(nil,DA_Inviter.ongoingRaidsFrame,{"TOPLEFT", DA_Inviter.ongoingRaidsFrame, "TOPLEFT", 10, -10},20,20,L['auto-join'],function(self) fuckingOptions_g[DA_CurrentGuild].Inviter_AutoJoinRT=(self:GetChecked() or false) if self:GetChecked() then InviterMsgFrame:RegisterEvent("CHAT_MSG_ADDON") else InviterMsgFrame:UnregisterEvent("CHAT_MSG_ADDON") end end,{'fuckingOptions_g','Inviter_AutoJoinRT','DA_CurrentGuild'},"anyjoin")
		-- авто принятие пати
		DA.CheckBtnCreater(nil,DA_Inviter.ongoingRaidsFrame,{"TOPLEFT", DA_Inviter.ongoingRaidsFrame, "TOPLEFT", 85, -10},20,20,L['auto-accept party'],function(self) fuckingOptions_g[DA_CurrentGuild].Inviter_AutoAcceptOnJoinRT=(self:GetChecked() or false) if self:GetChecked() then InviterMsgFrame:RegisterEvent("PARTY_INVITE_REQUEST") else InviterMsgFrame:UnregisterEvent("PARTY_INVITE_REQUEST") end end,{'fuckingOptions_g','Inviter_AutoAcceptOnJoinRT','DA_CurrentGuild'},nil)

		DA_Inviter.askfont1=DA.FontCreater(nil,L['Cant find any raids'],{"TOPLEFT", DA_Inviter.ongoingRaidsFrame, "TOPLEFT", 10, -25},DA_Inviter.ongoingRaidsFrame,30,200,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},"LEFT")
		Raids_Create_ScrollBar()
	end

	do -- opt
		if not fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern then
			fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern="+"
		end
		local eb_inviter_pattern = DA.EditBoxCreater2(nil,DA_Inviter.OptionsFr,{"LEFT",DA_Inviter.OptionsFr,"TOPLEFT",5,-20},{60,12},fuckingOptions_g[DA_CurrentGuild].inviter_inv_pattern,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","inviter_inv_pattern",'DA_CurrentGuild'},1,255,'text')
		DA.FontCreater(nil,L["Invite trigger"],{"BOTTOMLEFT",eb_inviter_pattern,"TOPLEFT",0,-2},eb_inviter_pattern,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
		eb_inviter_pattern:SetCursorPosition(0)

		if not fuckingOptions_g[DA_CurrentGuild].inviter_stop_message then
			fuckingOptions_g[DA_CurrentGuild].inviter_stop_message=L['raidinv_stop_msg']
		end
		local eb_inviter_stop_message = DA.EditBoxCreater2(nil,DA_Inviter.OptionsFr,{"LEFT",DA_Inviter.OptionsFr,"TOPLEFT",5,-50},{220,12},fuckingOptions_g[DA_CurrentGuild].inviter_stop_message,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","inviter_stop_message",'DA_CurrentGuild'},1,255,'text')
		DA.FontCreater(nil,L["Stop message"],{"BOTTOMLEFT",eb_inviter_stop_message,"TOPLEFT",0,-2},eb_inviter_stop_message,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
		eb_inviter_stop_message:SetCursorPosition(0)

		if not fuckingOptions_g[DA_CurrentGuild].inviter_autostop_msg then
			fuckingOptions_g[DA_CurrentGuild].inviter_autostop_msg=L['Invite auto-stopped']
		end
		local eb_autostop_msg = DA.EditBoxCreater2(nil,DA_Inviter.OptionsFr,{"LEFT",DA_Inviter.OptionsFr,"TOPLEFT",5,-80},{220,12},fuckingOptions_g[DA_CurrentGuild].inviter_autostop_msg,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","inviter_autostop_msg",'DA_CurrentGuild'},1,255,'text')
		DA.FontCreater(nil,L["Auto-stop message"],{"BOTTOMLEFT",eb_autostop_msg,"TOPLEFT",0,-2},eb_autostop_msg,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
		eb_autostop_msg:SetCursorPosition(0)

		do -- Discord
			local discordEB
			local discordChbx = DA.CheckBtnCreater(nil,DA_Inviter.OptionsFr,{"TOPLEFT", DA_Inviter.OptionsFr, "TOPLEFT", 3, -90},20,20,L['provide discord if asked'],function(self) fuckingOptions_g[DA_CurrentGuild].Inviter_shareDiscord=(self:GetChecked() or false);ebAlpha(fuckingOptions_g[DA_CurrentGuild].Inviter_shareDiscord, discordEB) end,{'fuckingOptions_g','Inviter_shareDiscord','DA_CurrentGuild'},"invprovidediscord")

			local discordEBFLVL
			local function dsescapefunc(self)
				if self.focusgained then self.t:SetBlendMode("ADD");self:ClearFocus();self.focusgained=nil;
					fuckingOptions_g[DA_CurrentGuild].Inviter_RTDiscord = self:GetText();
					self:SetMultiLine(false);self:SetSize(190,9.08);self:SetFrameLevel(discordEBFLVL)
					self:SetCursorPosition(0)
				end
			end
			local function dsfocusgainfunc(self)
				if self:GetParent():IsShown() then
					discordEBFLVL = self:GetFrameLevel()

					self.t:SetBlendMode('blend');
					self.focusgained=1
					local text=self:GetText();
					self:SetText("");self:SetMultiLine(true);self:SetText(text);
					self:SetFrameLevel(discordEBFLVL+20)
				end
			end
			discordEB = DA.EditBoxCreater(nil,discordChbx,{"TOPLEFT", discordChbx, "BOTTOMLEFT", 18, 1},{190,9.08},fuckingOptions_g[DA_CurrentGuild].Inviter_RTDiscord,false,false,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},dsescapefunc,dsescapefunc,dsescapefunc,dsfocusgainfunc)
			discordEB:SetCursorPosition(0)
			discordEB:HookScript("OnEnter",function(self)
				if self:GetParent():IsShown() and not self.focusgained then
					discordEBFLVL = self:GetFrameLevel()
					local text=self:GetText();
					self:SetText("");self:SetMultiLine(true);self:SetText(text);
					self:SetFrameLevel(discordEBFLVL+20)
				end
			end)
			discordEB:HookScript("OnLeave",function(self)
				if not self.focusgained then
					DA.TimerAfter(0, function()
						self:SetMultiLine(false);
						self:SetSize(190,9.08);
						self:SetFrameLevel(discordEBFLVL)
						self:SetCursorPosition(0)
					end)
				end
			end)
			discordEBFLVL = discordEB:GetFrameLevel()
			DA.CreateFFGButton2(nil,  discordEB,  {"LEFT", discordEB, "RIGHT", 3, 0},  12,  30,  L['send'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]], {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
				if fuckingOptions_g[DA_CurrentGuild].Inviter_RTDiscord~="https://discord.gg/discord_link" then
					SendChatMessage(fuckingOptions_g[DA_CurrentGuild].Inviter_RTDiscord,"RAID")
					SendChatMessage(fuckingOptions_g[DA_CurrentGuild].Inviter_RTDiscord,"RAID_WARNING")
				else
					DA.Print("fill in some actual discord link in corresponding field")
				end
			end)

			ebAlpha(fuckingOptions_g[DA_CurrentGuild].Inviter_shareDiscord, discordEB)
			table.insert(DA.RunOnGuildUpdate, function() ebAlpha(fuckingOptions_g[DA_CurrentGuild].Inviter_shareDiscord, discordEB) end)

			local discordOnlyGuildChbx = DA.CheckBtnCreater(nil,DA_Inviter.OptionsFr,{"CENTER", discordChbx, "CENTER", 130, 0},20,20,L['guild raid'],function(self) fuckingOptions.Inviter_shareDiscordOnlyInGuild=(self:GetChecked() or false) end,{'fuckingOptions','Inviter_shareDiscordOnlyInGuild'},"OnlyInGuildRaid")
			DA.CheckBtnCreater(nil,DA_Inviter.OptionsFr,{"CENTER", discordOnlyGuildChbx, "CENTER", 65, 0},20,20,"100%",function(self) fuckingOptions.Inviter_shareDiscordOnlyInFullGuild=(self:GetChecked() or false) end,{'fuckingOptions','Inviter_shareDiscordOnlyInFullGuild'},"OnlyInFullGuildRaid")

		end

		do --приём из лфг
			local LFGEB
			local LFGChbx = DA.CheckBtnCreater(nil,DA_Inviter.OptionsFr,{"TOPLEFT", DA_Inviter.OptionsFr, "TOPLEFT", 3, -120},20,20,L['accept from global'],function(self) fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromLFG=(self:GetChecked() or false);ebAlpha(fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromLFG, LFGEB) end,{'fuckingOptions_g','Inviter_AcceptFromLFG','DA_CurrentGuild'},nil)
			if not fuckingOptions_g[DA_CurrentGuild].Inviter_LFGPhrases or #fuckingOptions_g[DA_CurrentGuild].Inviter_LFGPhrases==0 then fuckingOptions_g[DA_CurrentGuild].Inviter_LFGPhrases=DA.CheckAndRestoreLocalizedTable("inviter_LFG_samples", true) end

			local LFGEBFrameLevel
			local function lfgescfunc(self)
				if self.focusgained then self.t:SetBlendMode("ADD");self:ClearFocus();self.focusgained=nil;
				fuckingOptions_g[DA_CurrentGuild].Inviter_LFGPhrases = DA.PackEditBoxTextInTable(self:GetText());
				self:SetText(DA.PackTableForEditBox(fuckingOptions_g[DA_CurrentGuild].Inviter_LFGPhrases))
				self:SetMultiLine(false);self:SetSize(190,9.08);self:SetFrameLevel(LFGEBFrameLevel);self:SetCursorPosition(0) end
			end
			local function lfgonfocusfunc(self)
				if self:GetParent():IsShown() then
					LFGEBFrameLevel = self:GetFrameLevel()

					self.t:SetBlendMode('blend');
					self.focusgained=1
					local text=self:GetText();
					self:SetText("");self:SetMultiLine(true);self:SetText(text);
					self:SetFrameLevel(LFGEBFrameLevel+20)
				end
			end
			LFGEB = DA.EditBoxCreater(nil,LFGChbx,{"TOPLEFT", LFGChbx, "BOTTOMLEFT", 18, 1},{190,9.08},DA.PackTableForEditBox(fuckingOptions_g[DA_CurrentGuild].Inviter_LFGPhrases),false,false,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},lfgescfunc,function(self) self:Insert("\n") end,lfgescfunc,lfgonfocusfunc)
			LFGEB:SetCursorPosition(0)
			LFGEB:HookScript("OnEnter",function(self)
				if self:GetParent():IsShown() and not self.focusgained then
					LFGEBFrameLevel = self:GetFrameLevel()
					local text=self:GetText();
					self:SetText("");self:SetMultiLine(true);self:SetText(text);
					self:SetFrameLevel(LFGEBFrameLevel+20)
				end
			end)
			LFGEB:HookScript("OnLeave",function(self)
				if not self.focusgained then
					DA.TimerAfter(0, function()
						self:SetMultiLine(false);
						self:SetSize(190,9.08);
						self:SetFrameLevel(LFGEBFrameLevel)
						self:SetCursorPosition(0)
					end)
				end
			end)
			LFGEBFrameLevel = LFGEB:GetFrameLevel()
			DA.HelpCreater(LFGEB,{"RIGHT", LFGEB, "LEFT", -2, 0},'Inviter_AcceptFromLFG_messages',10,10)

			ebAlpha(fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromLFG, LFGEB)
			table.insert(DA.RunOnGuildUpdate, function() ebAlpha(fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromLFG, LFGEB) end)
		end

		
		do --invitations speedSelect
			DA_Inviter.OptionsFr.speedSelectTimerEB=DA.EditBoxCreater2(nil,DA_Inviter.OptionsFr,{"LEFT",DA_Inviter.OptionsFr,"TOPLEFT",157,-20},{20,12},fuckingOptions.Inviter_manualTimerSpeed,false,false,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},{"fuckingOptions","Inviter_manualTimerSpeed"},0.1,10,'textnum')
			DA_Inviter.OptionsFr.speedSelectTimerEB:HookScript("OnEscapePressed", function() DA.SetTimerSpeed('proc_invite_timer',fuckingOptions.Inviter_manualTimerSpeed) end)
			DA_Inviter.OptionsFr.speedSelectTimerEB:HookScript("OnEnterPressed", function() DA.SetTimerSpeed('proc_invite_timer',fuckingOptions.Inviter_manualTimerSpeed) end)
			DA_Inviter.OptionsFr.speedSelectTimerEB:HookScript("OnEditFocusLost", function() DA.SetTimerSpeed('proc_invite_timer',fuckingOptions.Inviter_manualTimerSpeed) end)
			-- DA.FontCreater(nil,"Invitations speed",{"BOTTOMLEFT",DA_Inviter.OptionsFr.speedSelectTimerEB,"TOPLEFT",5,-2},DA_Inviter.OptionsFr.speedSelectTimerEB,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
		
			DA.CreateDropdownSelector({
				rel = DA_Inviter.OptionsFr,
				point = {"LEFT",DA_Inviter.OptionsFr,"TOPLEFT",90,-20},
				width = 65,
				height = 12,
				frpoint = "BOTTOM",
				title = {
					L["Invitations speed"],
					{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},
					{"BOTTOMLEFT","TOPLEFT",0,-2}
				},
				valuesroster = {
					{ text = L["Auto"], value = 1 , deskr = "inv_fast_tt", funcOnSelection = function ()
						DA_Inviter.OptionsFr.speedSelectTimerEB:Hide()
					end},
					{ text = L["Instant"], value = 2 , deskr = "inv_instant_tt", funcOnSelection = function ()
						DA_Inviter.OptionsFr.speedSelectTimerEB:Hide()
					end},
					{ text = L["By Timer"], value = 3 , deskr = "inv_timer_tt", funcOnSelection = function ()
						DA_Inviter.OptionsFr.speedSelectTimerEB:Show()
					end},
				},
				justh = nil,
				get = function()
					return fuckingOptions.Inviter_TimerMode
				end,
				set = function(value)
					fuckingOptions.Inviter_TimerMode = value
				end
			})
			
			if fuckingOptions.Inviter_TimerMode == 3 then
				DA_Inviter.OptionsFr.speedSelectTimerEB:Show()
			else
				DA_Inviter.OptionsFr.speedSelectTimerEB:Hide()
			end
		end
		
	end

	do -- additional invites
		DA.HelpCreater(DA_Inviter.addInvFr,{"TOPLEFT", DA_Inviter.addInvFr, "TOPLEFT", 2, -2},'Inviter_AdditInvitHelp',10,10)
		DA_Inviter.addInvFr.lvl80=DA.CheckBtnCreater(nil,DA_Inviter.addInvFr,{"TOPLEFT", DA_Inviter.addInvFr, "TOPLEFT", 10, -12},20,20,L['guild: all 80 lvl online'])
			DA.FontCreater(nil,L['Also invite:'],{"LEFT",DA_Inviter.addInvFr.lvl80,"TOPLEFT",5,3},DA_Inviter.addInvFr,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
		DA_Inviter.addInvFr.fromsnapshot=DA.CheckBtnCreater(nil,DA_Inviter.addInvFr,{"TOPLEFT",DA_Inviter.addInvFr,"TOPLEFT",10,-27},20,20,'Awarder tool: raid snapshot',function(self)
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
		if not DA_Awarder then
			DA_Inviter.addInvFr.fromsnapshot:SetAlpha(0.6)
		end
		DA_Inviter.addInvFr.gselected=DA.CheckBtnCreater(nil,DA_Inviter.addInvFr,{"TOPLEFT",DA_Inviter.addInvFr,"TOPLEFT",10,-42},20,20,L['Guild tool: selected'],function(self)
			if self:GetChecked() then

				DarkAngelGUI:Show()
				_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',true)
				_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',false)
				DA.ResetScrollBoxes()
			else
				DarkAngelGUI:Hide()
			end
		end)
		DA_Inviter.addInvFr.gfound=DA.CheckBtnCreater(nil,DA_Inviter.addInvFr,{"TOPLEFT",DA_Inviter.addInvFr,"TOPLEFT",10,-57},20,20,L['Guild tool: all found online'],function(self)
			if self:GetChecked() then

				DarkAngelGUI:Show()
				_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',true)
				_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',false)
				DA.ResetScrollBoxes()
			else
				DarkAngelGUI:Hide()
			end
		end)
	end

	do -- start stop

		local function add_additional_invites()
			local index={}
			local myname=UnitName('player')

			if DA_Inviter.addInvFr.lvl80:GetChecked() then
				table.wipe(index)
				for k,v in pairs(listinvite_bulk) do
				index[v]=k
				end

				for k=1,DA.GetNumGMembers() do
					local name, _, _, level, _, _, note, _, online, _, _, _, _, _, _, _ = GetGuildRosterInfo(k)
					if name and name~=myname and online and level==80 and not UnitInRaid(name) and not index[name] then
						table.insert(listinvite_bulk,name)
					end
				end

			end
			if DA_Awarder and DA_Inviter.addInvFr.fromsnapshot:GetChecked() then
				table.wipe(index)
				for k,v in pairs(listinvite_bulk) do
				index[v]=k
				end

				for group=1,8 do
					for i=1,5 do

						local frame=DA_Awarder.group[group].player[i]

						if frame:IsShown()
						and frame.c
						and frame.c.name
						and frame.c.name~=myname
						and not UnitInRaid(frame.c.name)
						and not index[frame.c.name] then
							table.insert(listinvite_bulk,frame.c.name)
						end
					end
				end

			end
			if DA_Inviter.addInvFr.gselected:GetChecked() then
				table.wipe(index)
				for k,v in pairs(listinvite_bulk) do
				index[v]=k
				end

				local roster=DA.GetGfoundList('sel')

				for _,r in ipairs(roster) do
					if (r[4] or r[1]=='local') and 
					r[2] and r[2]~=myname and not UnitInRaid(r[2]) and not index[r[2]] then
						table.insert(listinvite_bulk,r[2])
					end
				end

			end
			if DA_Inviter.addInvFr.gfound:GetChecked() then

				table.wipe(index)
				for k,v in pairs(listinvite_bulk) do
				index[v]=k
				end

				local roster=DA.GetGfoundList('all')

				for _,r in ipairs(roster) do
					if (r[4] or r[1]=='local') and r[2] and r[2]~=myname and not UnitInRaid(r[2]) and not index[r[2]] then
						table.insert(listinvite_bulk,r[2])
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
			GuildControlSetRank(rankIndex+1)
			local guildchat_listen, guildchat_speak = GuildControlGetRankFlags()

			return guildchat_listen, guildchat_speak
		end
		local function startRT(self)
			DA_Inviter.OptionsFr.speedSelectTimerEB:ClearFocus()
			if not(fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromGuild or fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromPM or fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromLFG) then
				DA.Print(L["Please select at least one option for accepting players into the raid"])
				return
			end
			local guildchat_listen, guildchat_speak, not_in_guild = getGuildChatPermissions()

			if not_in_guild then
				DA.Print(L["is not in guild"])
				return
			elseif not guildchat_listen then
				DA.Print(L["It looks like your guild rank doesn't allow you to read guild chat"])
				return
			elseif not guildchat_speak then
				DA.Print(L["It looks like your guild rank doesn't allow you to use guild chat"])
				return
			end
			writeNewTiming()
			self:Disable()
			DA_Inviter.stopbtn:Enable()
			convertedToRaid=false
			Inviter_Started=true
			DA.XTimers["inviter"].mytime=nil
			DA.ResumeTimer('inviter')

			DEFAULT_CHAT_FRAME:AddMessage("      -->>"..L['Raid inviter started'],0,1,1)
			if not DA_Inviter.silentstart:GetChecked() then SendChatMessage(fuckingOptions_g[DA_CurrentGuild].Inviter_RTMessage,"guild") end
			InviterMsgFrame:RegisterEvent("CHAT_MSG_GUILD")
			InviterMsgFrame:RegisterEvent("CHAT_MSG_ADDON")
			InviterMsgFrame:RegisterEvent("CHAT_MSG_CHANNEL")
			if not DA_Inviter.silentstart:GetChecked() then SendAddonMessage("DA_RTbeacon",getRaidLeaderAndZoneName(), "guild") end

			if fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromPM then InviterMsgFrame:RegisterEvent("CHAT_MSG_WHISPER") end

			add_additional_invites()

		end
		DA_Inviter.startbtn=DA.CreateFFGButton2(nil,  DA_Inviter,  {"TOPLEFT", DA_Inviter, "TOPLEFT", 26, -143},  12,  50,  L['start'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Red]],  {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},startRT)

		local function stopRT(self)
			listinvite_bulk=nil
			listinvite_bulk={}
			DA.StopTimer("inviter");DA.XTimers["inviter"].mytime=nil
			convertedToRaid=false
			self:Disable()
			DA_Inviter.startbtn:Enable()
			Inviter_Started=false
			DEFAULT_CHAT_FRAME:AddMessage("      -->>"..L['Raid inviter is disabled now'],1,0.5,0.5)
			if not DA_Inviter.silentstart:GetChecked() then SendChatMessage(fuckingOptions_g[DA_CurrentGuild].inviter_stop_message,"guild") end
			if fuckingOptions_g[DA_CurrentGuild].Inviter_AutoJoinRT then else InviterMsgFrame:UnregisterEvent("CHAT_MSG_CHANNEL");end
			if fuckingOptions_g[DA_CurrentGuild].Inviter_AutoAcceptOnJoinRT then else InviterMsgFrame:UnregisterEvent("PARTY_INVITE_REQUEST");end
			if fuckingOptions_g[DA_CurrentGuild].Inviter_AcceptFromPM then else InviterMsgFrame:UnregisterEvent("CHAT_MSG_WHISPER");end
		end
		-- STOP button
		DA_Inviter.stopbtn=DA.CreateFFGButton2(nil,  DA_Inviter,  {"LEFT", DA_Inviter.startbtn, "RIGHT", 5, 0},  12,  48.1,  L["stop"],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Red]],  {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},stopRT)
		DA_Inviter.stopbtn:Disable()


		DA_Inviter.addInvBtn=DA.CreateFFGButton2(nil,  DA_Inviter,  {"LEFT", DA_Inviter.stopbtn, "RIGHT", 6, 0},  12,  50,  L["more..."],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],  {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
			if DA_Inviter.addInvFr:IsShown() then
				DA_Inviter.addInvFr:Hide()
			else
				DA_Inviter.addInvFr:Show()
			end
		end)
	end

	do -- pre raid settings
		local function re_render_difficultyBtns_Diff()
			for i,j in ipairs({"10","25","10H","25H"}) do
				if DA_Inviter.initRaidDifficulty==i then
					DA_Inviter.difficultyBtns[i].fs:SetTextColor(0.2,1,1,1)
				else
					DA_Inviter.difficultyBtns[i].fs:SetTextColor(0.85,1,1,1)
				end
			end
		end
		DA_Inviter.difficultyBtns={}
		for i,j in ipairs({"10","25","10H","25H"}) do
			DA_Inviter.difficultyBtns[i]=DA.CreateFFGButton2(nil,DA_Inviter,{"TOPLEFT", DA_Inviter, "TOPLEFT", 0+26*i,-125},12,25,j,[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
				DA_Inviter.initRaidDifficulty=i
				re_render_difficultyBtns_Diff()
			end,nil,nil,'center')
		end
		DA_Inviter.initRaidDifficulty=4
		re_render_difficultyBtns_Diff()
		DA.FontCreater(nil,L["Raid difficulty"],{"LEFT",DA_Inviter.difficultyBtns[1],"TOPLEFT",0,4},DA_Inviter.difficultyBtns[1],15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')


		local lootSelectTbl={
			{"Master",'m'},
			{"Group",'g'},
			{"Free",'f'},
		}
		local rerender_lootSelectFrame
		DA_Inviter.lootBtn,DA_Inviter.lootFrame=DA.CreateFFGDropFrame(DA_Inviter,"",12,45,{"TOPLEFT",DA_Inviter,"TOPLEFT",135,-125},47,34,"BOTTOM",nil,nil,nil,'lootBtnSelect',true)
		-- DA_Inviter.lootFrame:SetFrameLevel(200)
		for id,ss in ipairs(lootSelectTbl) do
			DA_Inviter.lootFrame[id]=DA.CreateFFGButton2(nil,DA_Inviter.lootFrame,{"TOPLEFT",DA_Inviter.lootFrame, "TOPLEFT",1, 10-11*id},10,45,ss[1],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
				fuckingOptions_g[DA_CurrentGuild].initRaidLootMethod=ss[2]
				rerender_lootSelectFrame()
				DA_Inviter.lootFrame:Hide()
			end,nil,nil,'center')
			-- DA_Inviter.lootFrame[id]:SetFrameLevel(201)

		end
		DA.FontCreater(nil,L["Loot Method"],{"LEFT",DA_Inviter.lootBtn,"TOPLEFT",0,4},DA_Inviter,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
		rerender_lootSelectFrame=function()
			for i,j in ipairs(lootSelectTbl) do
				if fuckingOptions_g[DA_CurrentGuild].initRaidLootMethod==j[2] then
					DA_Inviter.lootFrame[i].fs:SetTextColor(0.2,1,1,1)
					DA_Inviter.lootBtn:SetText(j[1])
				else
					DA_Inviter.lootFrame[i].fs:SetTextColor(0.85,1,1,1)
				end
			end
		end
		rerender_lootSelectFrame()
		table.insert(DA.RunOnGuildUpdate, rerender_lootSelectFrame)




	end

	DA.CreateScaler('DA_Inviter',0.6,2,{'fuckingOptions','SRScale'})

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

local DA_InviterRaidsGathered={}
local RaidsGatheredGUI={}
local function RaidEntriesUpdateTime()
	local tt = time()-80
	for sender, entry in pairs(DA_InviterRaidsGathered) do
		if entry.t <= tt then
			DA_InviterRaidsGathered[sender] = nil
		end

	end
end
local function RaidEntryAdd(sender, RLname, LocationName)
	if not dungnamesrch(LocationName) then LocationName="" end

	DA_InviterRaidsGathered[sender]={RLname, LocationName, t=time()}
	RaidEntriesUpdateTime()
end
local function GetRaidEntries()
	RaidEntriesUpdateTime()
   	table.wipe(RaidsGatheredGUI)

	for sender, entry in pairs(DA_InviterRaidsGathered) do
		table.insert(RaidsGatheredGUI, {sender, entry[1], entry[2]})

	end
	return RaidsGatheredGUI
end

local function Inviter_RaidBrowserSetLines(data1)
    for pos, data in ipairs(data1) do
        local sender, rlname, raidInfo = unpack(data)

		RaidsGatheredGUI[pos]={}
		local Dat = RaidsGatheredGUI[pos]
		Dat.sender=sender
		Dat.rlname=rlname
		Dat.raidInfo=raidInfo
    end

	DarkAngelInviterRaidBrowserCF:SetSize(5, #RaidsGatheredGUI * 28)

	DA_Inviter.ongoingRaidsFrame.UpdRows(DarkAngelInviterRaidBrowser.offset or 1)

end
Inviter_UpdateRaidBrowser = function()
	if not DA_Inviter:IsShown() then return end
	local currentRaids = GetRaidEntries()
	local countRaids = #currentRaids
	if countRaids==0 then
		DA_Inviter.askfont1:SetText(L['Cant find any raids'])
		DA_Inviter.askfont1:SetFont(UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE")
		DarkAngelInviterRaidBrowser:Hide()
		DA_Inviter.ongoingRaidsFrame:SetSize(200,55)
		return
	end
		DA_Inviter.ongoingRaidsFrame:SetSize(200,230)
		DA_Inviter.askfont1:SetFont(UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE")
	DA_Inviter.askfont1:SetText(L['inv_browser_join']:gsub("$1", countRaids))

	DarkAngelInviterRaidBrowser:Show()

	Inviter_RaidBrowserSetLines(currentRaids)
end
Raids_Create_ScrollBar = function ()
	local NUM_ROWS = 6
	local ROW_HEIGHT = 28

	DarkAngelInviterRaidBrowser = CreateFrame("ScrollFrame", "DarkAngelInviterRaidBrowser", DA_Inviter.ongoingRaidsFrame, "UIDarkAngelScrollFrame2")
	local ScrollFrame = DarkAngelInviterRaidBrowser
		DarkAngelInviterRaidBrowser:Hide()
	ScrollFrame:SetPoint("TOPLEFT",DA_Inviter.ongoingRaidsFrame,"TOPLEFT",6,-40)
	ScrollFrame:SetPoint("BOTTOMRIGHT",DA_Inviter.ongoingRaidsFrame,"BOTTOMRIGHT",-23,10)
-- local tf = ScrollFrame:CreateTexture(nil, "BACKGROUND"); tf:SetAllPoints(); tf:SetTexture(21/255, 18/255, 22/255, 0.5); tf:SetBlendMode("blend")


	DarkAngelInviterRaidBrowserCF = CreateFrame("Frame", "DarkAngelInviterRaidBrowserCF", ScrollFrame)
	local ContentFrame = DarkAngelInviterRaidBrowserCF

	ScrollFrame:SetScrollChild(ContentFrame)
-- local zxc = ContentFrame:CreateTexture(nil, "BACKGROUND"); zxc:SetAllPoints(); zxc:SetTexture(8/255, 55/255, 20/255, 0.5); zxc:SetBlendMode("blend")

	local RowButtons = {}
	local font=UIDarkAngelFontConsolas:GetFont()

	for i = 1, NUM_ROWS do
		local row = DA.CreateFFGButton2(nil, DarkAngelInviterRaidBrowser, {"TOPLEFT", DarkAngelInviterRaidBrowser, "TOPLEFT", 0, 10 - (ROW_HEIGHT * i)}, ROW_HEIGHT-1, 175, "", [[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]], {font, 9, "OUTLINE"},function(self, clickType)
            local data=self.mydata
			if (GetNumRaidMembers()==0 and GetNumPartyMembers()==0) then
				DA.Print(L["joining raid..."])
				addToExpectingInvite(data.sender)
				SendAddonMessage("DA_join",data.sender, "guild")
			else
				DA.Print("|cffffaa99     >>"..L['You are already in raid!'])
			end
		end,nil,nil,'left')
			row.selfID=i
		row:RegisterForClicks("AnyUp")
        -- row:SetNormalTexture('')

		row.buttons = {}
		row.buttons[1]=DA.FontCreater(nil,"",{"TOPLEFT", row, "TOPLEFT", 1, 2},row,20, 200,{font, 9, "OUTLINE"},"LEFT", {0.2, 0.8, 0.8, 1})
		row.buttons[2]=DA.FontCreater(nil,"",{"TOPLEFT", row, "TOPLEFT", 1, -12},row,20, 200,{font, 9, "OUTLINE"},"LEFT", {0.7, 0.8, 0.8, 1})

		RowButtons[i] = row
	end

	local function UpdateRows(offset)

		DarkAngelInviterRaidBrowser.offset=offset

		local rowIndex = math.floor(offset / ROW_HEIGHT + 0.5) + 1
		for i = 1, NUM_ROWS do
			local data = RaidsGatheredGUI[rowIndex + i - 1]
			if data then
				local row = RowButtons[i]
				row:Show()
				row.mydata=data
				local authorline
				if data.sender == data.rlname then
					authorline = L['inv_RL'].."|cfffefefe"..data.rlname
				else
					authorline = L['inv_RL'].."|cffaeeeee"..data.rlname.."|r/|cfffefefe"..data.sender
				end
				row.buttons[1]:SetText(authorline)
				row.buttons[2]:SetText(data.raidInfo or "")
			else
				RowButtons[i]:Hide()
			end
		end
	end

	DA_Inviter.ongoingRaidsFrame.UpdRows=UpdateRows

	ScrollFrame:EnableMouseWheel(true)
	local scrollbar = _G[ScrollFrame:GetName().."ScrollBar"]
	scrollbar:SetScript("OnValueChanged", function(self, value)
		local scrollBarname = self:GetName()
		local _, max= self:GetMinMaxValues();

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

DA:RegisterComm("DA_join", function(message, dtype, sender)
	if sender~=GetUnitName("player") and dtype=="GUILD" and message==GetUnitName("player") and Inviter_Started and not UnitInRaid(sender) then
		local index={}
		for k,v in pairs(listinvite_bulk) do
			index[v]=k
		end
		if index[sender] then return else
		table.insert(listinvite_bulk,sender)
		end
	end
end)
local function IsAbleToInvite()
	if IsRaidOfficer() or
	IsPartyLeader() or
	(GetNumRaidMembers()==0 and GetNumPartyMembers()==0) then
		return true
	end
end
local DA_RTqRoster={}
local function addToDA_RTq(name)
	DA_RTqRoster[name] = time()
end
local function RemoveFromDA_RTq(name)
	DA_RTqRoster[name] = nil
end
local function isDA_RTq(name)
	if DA_RTqRoster[name] then
		if time() - DA_RTqRoster[name] <= 5 then
			return true
		else
			RemoveFromDA_RTq(name)
		end
	end
end
DA:RegisterComm("DA_RTq", function(_, dtype, sender)
	if sender~=GetUnitName("player") and dtype=="GUILD" and IsAbleToInvite() and Inviter_Started and not isDA_RTq(sender) then
		addToDA_RTq(sender)
		SendAddonMessage("DA_RTbeacon", (getRaidLeaderAndZoneName()), "GUILD")
	end
end)
DA:RegisterComm("DA_RTbeacon", function(message, dtype, sender)
	if dtype=="GUILD" and sender~=GetUnitName("player") then
		if message=="text" then
			RaidEntryAdd(sender)
		else
			local rl,lok=string.match(message, "[^,]+"),string.match(message, "[^,]+",message:find(","))
			RaidEntryAdd(sender,rl,lok)
		end
		Inviter_UpdateRaidBrowser()
	end
end)

