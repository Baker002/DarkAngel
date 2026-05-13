


--[====[


                                           oOOOOOOOOOOOOOOoo.. 
                                            """""""""""OOOOOOOOo. 
                                          ..oooooooo..    `""OOOOO. 
                                      .oOOOOOOOOOOOOOOOOo     OOOOO 
                    ..ooOOOOOOo..oooOOOOOOOOOOOOOOOOOOOOOOoooOOOOO' 
           .Oo...ooOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"' 
       .oooOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO""'
         \oOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO' 
          OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOoOOOOOOOOOOOOOOO' 
         __\OO/"    "OOOOOOOOOOOOOOOOOOOO`OOOOOOOOOOOOO" 
           /|\   .oOOooo- `OOOOOOOO""   .O`OOOOOOOOOO' 
 oO--.        .oOOOO"~    .OOOOO'      QQOOO`OOOOOOOOOo 
 +o--o`----QQOOO"~       .OOOOO'                 `OOOOO 
                        .OOOO'                  QQQQO" 
                      QQQQO" 
					  
					  
					  
					  


  © 2026 Vitalii I. (Baker#7727)
  Licensed under Apache 2.0 — http://www.apache.org/licenses/LICENSE-2.0
  Use at your own risk. No warranty. Just vibes.
  See LICENSE file for full details.
  
  
Official addon Discord channel: https://discord.gg/bpPzRk3bnk


					  
--- https://www.youtube.com/watch?v=ZXsQAXx_ao0

--- https://www.youtube.com/watch?v=boTKLuI7nzM

--- https://www.youtube.com/watch?v=k-5YFwXyAjc

--- https://www.youtube.com/watch?v=fliHTvM9ut4

--- https://www.youtube.com/watch?v=ZGjkh5VeIxs

--- https://www.youtube.com/watch?v=ROj3a6kZjaI

]====]


local _, DA = ...
---@class DarkAngelAddon
DA = LibStub("AceAddon-3.0"):NewAddon('DarkAngel')
DarkAngel = DA
-- local L = LibStub("AceLocale-3.0"):GetLocale("DarkAngel")


local fuckingOptions_local={
	FFGScale=1.12,
		GCScale=1.1,
	SRScale=0.967,
	FFFLScale=0.96,
	Awarderscale=1.107,
	BidTrackerScale=1.1,
	Decaydays=2,
	decaygroup=1,
	prntleav=1,
	TXTartOpacity=0.5,
	TXTBgOpacity=0.3,
	TXTArtTransp=false,
	TXTBgTransp=false,
	TXTArtOnFront=true,
	
	auc_bidBtnsTutorial=true,
	auc_OnlyInGuild=false,
	auc_OnlyInFullGuild=true,

	Inviter_shareDiscordOnlyInGuild=true,
	Inviter_shareDiscordOnlyInFullGuild=true,
	Inviter_manualTimerSpeed=4,
	Inviter_TimerMode=1,

	guildcopyauto=true,
	logcopyauto=true,
	
	firsttimeloaded=1,
	
	storedpatterns={},
	
	
	gcopyfrsep="  ",
	gcopyfrnumlines=2000,
	lcopyfrsep="  ",
	lcopyfrnumlines=3000,
	
	dispenser_speed=0.15,
	
	showonl=1,
	showoffl=1,
	grefr=false,

	pricols=1,

	gwinbtn=1,
	ctrlobind=1,
	epgpofficer=1,
	epgpmultiple=1,
	epgptwinksandloot=false,
	rrtwinks=1,

	localized_items_data={},

	darkenoffline=1,

	precisematchsearch=1,
	showlocals=false,
	gsort="-no sort-",
	onlineFirst=1,
	reverseSort=false,
	mmenuqcopy=1,
	mmenuleavefocus=1,
	mmenucloserank=1,

	AW_raid68=1,
	AW_skada68=false,
	AW_saved68=false,
	AW_roles68=false,

	EnableZamena=false,
	ZamenaClearAfterAward=1,
	sixeight=1,

	saved_guiPositions={
		DarkAngelGUI={'TOP', 'TOP', -129.966, -68.400},
		DA_Inviter={'CENTER', 'CENTER', -64.575, -104.083},
		DA_Flasker={'LEFT', 'LEFT', 328.320, -34.937},
		DA_Awarder={'TOPRIGHT', 'TOPRIGHT', -206.319, -68.470},
		DA_BidTracker={'LEFT', 'LEFT', 148.686, 119.044},
	},

	
}
local fucking2Options_char_local={
autobackups=false,
	autonote=1,
	autoofnote=1,
	autorank=1,
	autolocals=false,
	autogannounce=false,
	autoginfo=false,
	autogmrank=false,
	
	storeautoG=false,
	storemanG=1,
	storeautoNum=3,
	
	doautohours=false,
	autohours=2,
}
local fuckingOptions_g_local={
	epgpepauc=false,
	bidtracker=false,
	bidtracker_onlymine=true,
	evaluateoffnote=false,
	aw_send_whispers=1,

	
	--Inviter opt
	initRaidLootMethod='m',
	inviter_stop_message=false,
	inviter_repeat_message=false,
	inviter_autostop_msg=false,
	inviter_inv_pattern=false,
	Inviter_RepeatAnons=1,
	Inviter_shareDiscord=false,
	Inviter_AcceptFromGuild=1,
	Inviter_AcceptFromPM=1,
	Inviter_AcceptFromLFG=false,
	Inviter_AutoJoinRT=false,
	Inviter_AutoAcceptOnJoinRT=1,
	Inviter_AutoStop=false,
	Inviter_TimeAutoStop="5",
	Inviter_RepeatMsgOnTime=60,
	Inviter_RTMessage="Raid Time +++++++++++",
	Inviter_RTDiscord="https://discord.gg/discord_link",
	Inviter_LFGPhrases='',
	
	
	guildInviterEnabled=false,
	guildInviterPhrase='123121211211331311121311',
	
	aw_auto_locals=true,
	aw_auto_Ch_locals=false,
	aw_auto_silent_locals=false,
	
	aw_scada_bossfights=true,
	aw_scada_long=true,
	
	minlog=3,
	storeleavers=30,
	cleanlogonceper=1209600,
	Log_note=1,
	Log_offnote=2,
	Log_rank=1,
	Log_ginfo=false,
	Log_gmotd=false,
	Log_GM=false,
	
	LCB_new=1,
	LCB_leaver=1,
	LCB_rejoin=1,
	
	LCB_offnote=1,
	LCB_tvink=false,
	LCB_tvink_susp=false,
	LCB_decay=1,
	LCB_frozen=false,
	
	LCB_note=false,
	LCB_rank=false,
	LCB_ginfo=false,
	LCB_gmotd=false,
	LCB_GM=false,
	
	DCB_note=false,
	DCB_rank=false,
	DCB_offnote=1,
		
	do_decay_checks=1,
	
	InvTimerSpeed='fast',
	
	standby_method='epgp',
	procepzamene=false,
	procepzam_usemanual=false,
	manual_procent=100,
	
	trustedMode=2,
	trustedRankID=false,
	trustedList="",
	
	aucoptsets={
		{100,5},
		['lastincr']=10
	},
	auc_minimal=1,
	auc_allow_lower=1,
	auc_thousands=false,
	auc_bidTime=25,
	auc_thousands_step=false,
	auc_RR_collab=true,
	auc_allin=1,
	auc_bidconfirmed=1,
	
	printOldDeleted=true,
	warnsuspic=false,
	warn_improv_suspic=true,
	dkpcomm=false,
	-- dkpcomm_inraid=true,
	commWhispersPerm=3,
	dkpcomm_sendLocals=true,
	dispenser_announce=1,
	dispenser_markself=1,
	dispenser_markself_n=2,
	dispenser_gmembers=false,
	dispenser_print=1,
	dispenser_rsay=false,
	dispenser_gsay=false,
	dispenser_items_grp=1,
	dispenser_print_results=false,
	dispenser_rsay_results=1,
	dispenser_gsay_results=false,
	dispenser_hide_on_set_selection=true,
}
do --variables
	fuckingOptions=fuckingOptions or fuckingOptions_local
	
	fuckingOptions_g=fuckingOptions_g or {}
	fucking2Options_char=fucking2Options_char or fucking2Options_char_local
	DA_Standby=DA_Standby or {}
	DA_Guild_Info=DA_Guild_Info or {}
	FEP_gMain={}
	FFG_gMain={}
	FRG_gMain={}
	UNP_gMain={}
	FEP_L_gMain=FEP_L_gMain or {}
	
	DA_CurrentGuild='n0-guild'
	DA_Addon_Pending_Load=true
	DA_BackupsDB={}
	DA_Backups_charDB={}

	DA_Tooltip = CreateFrame("GameTooltip","DA_Tooltip",UIParent,"DAGameTooltipTemplate")
	DA_TooltipMM = CreateFrame("GameTooltip","DA_TooltipMM",UIParent,"DAGameTooltipTemplateMinimap")
	DACItemCacheTooltip = CreateFrame("GameTooltip", "DACItemCacheTooltip", nil, "GameTooltipTemplate")
    
    DA.IsModuleLoaded = {}
    DA.guild_info_found=false
    DA.GuildInfoFetched=false
    DA.OnInit_completed = false
    DA.LinkStorage = {}
    DA.LinkIndex = 0
	DA.RunOnGuildUpdate={}
	DA.ResetValueOnGuildUpdate={}
	DA.modOptCreate={}
	DA.loaded_Modules={}
	DA.DrawnFrames={}
end
local ModsAndGuildDataReady
local IfModsAndGuildDataReady
local OnGuildDataAvailable
local TryInitGuildData
local Run_OnGuildUpdate

-- Initialization
local gInfoFetcher=CreateFrame("Frame")
local gInfo_countFetcher=0
gInfoFetcher:SetScript("OnUpdate",function(s)
	if not GetGuildInfoText then return end
	
	local ginfo = GetGuildInfoText()
	if not ginfo or (ginfo=="" and gInfo_countFetcher <= 199) then
		-- print('ginfo nil or empty')
		
	elseif not DA.GuildInfoFetched or gInfo_countFetcher > 199 then
		s:SetScript("OnUpdate",nil)
		DA.GuildInfoFetched=true
		-- print('loaded')
		TryInitGuildData()
	end
	
	gInfo_countFetcher = gInfo_countFetcher + 1
		
end)

local GuildSysTracker=CreateFrame('frame')
GuildSysTracker:RegisterEvent("CHAT_MSG_SYSTEM")
GuildSysTracker:SetScript("OnEvent", function (_,_,msg) 
	local DA_PL_ONLINE 	= ".*%[(.+)%]%S*"..string.sub(ERR_FRIEND_ONLINE_SS, 20)
	local DA_PL_OFFLINE	= string.format(ERR_FRIEND_OFFLINE_S, "(.+)")
	local DA_PL_JOINED	= string.format(ERR_GUILD_JOIN_S, "(.+)")
	local DA_PL_PROMO	= string.format(ERR_GUILD_PROMOTE_SSS, "(.+)", "(.+)", "(.+)")
	local DA_DEMOTE	= string.format(ERR_GUILD_DEMOTE_SSS, ".+", "(.+)", "(.+)")

	local DA_GUILD_Q	= string.format(ERR_GUILD_QUIT_S, "(.+)")
	local DA_GUILD_L	= string.format(ERR_GUILD_LEAVE_S, "(.+)")
	local DA_GUILD_R    = string.format(ERR_GUILD_REMOVE_SS, "(.+)", "(.+)")

	local player
	local _, _, player_online = string.find(msg, DA_PL_ONLINE)
    local _, _, player_offline = string.find(msg, DA_PL_OFFLINE)
    local _, _, player_joined = string.find(msg, DA_PL_JOINED)
    local _, _, _, player_promoted = string.find(msg, DA_PL_PROMO)
    local _, _, player_demoted = string.find(msg, DA_DEMOTE)
	
    local _, _, gname_self_left = string.find(msg, DA_GUILD_Q)
    local _, _, player_left = string.find(msg, DA_GUILD_L)
    local _, _, _, player_kicked = string.find(msg, DA_GUILD_R)
	

    if player_online then
        player = player_online
    elseif player_offline then
        player = player_offline
    elseif player_joined then
        player = player_joined
		if player==UnitName('player') then
			DA.ResumeTimer("greset")
			DarkAngel_minimapBtn:Disable()
			DarkAngel_minimapBtn:Hide()
		end
    elseif player_demoted then
        player = player_demoted:gsub("%)",""):gsub("%-3%(","")
    elseif player_promoted then
        player = player_promoted:gsub("%)",""):gsub("%-3%(","")
		
    elseif gname_self_left then
        player = gname_self_left
			DA.ResumeTimer("greset")
			DarkAngel_minimapBtn:Disable()
			DarkAngel_minimapBtn:Hide()
    elseif player_left then
        player = player_left
		if player==UnitName('player') then
			DA.ResumeTimer("greset")
			DarkAngel_minimapBtn:Disable()
			DarkAngel_minimapBtn:Hide()
		end
    elseif player_kicked then
        player = player_kicked:gsub("%)",""):gsub("%-3%(","")
		if player==UnitName('player') then
			DA.ResumeTimer("greset")
			DarkAngel_minimapBtn:Disable()
			DarkAngel_minimapBtn:Hide()
		end
    end
	
	if player and DarkAngelGUI.Guild and DarkAngelGUI.Guild:IsShown() and fuckingOptions.grefr then
		DA.SetTimerTime('grefresher',2)
		return
	end
end)

function DA:OnInitialize()
	-- DA.Print('core init')
	DA.OptionsUpd()

	--fep processor
	DA_Fep_bulk={}
	DA.CreateTimer(nil,"fep",0,0.15,true,function(self)
		local guildName,_,_= GetGuildInfo('player')
		if guildName and guildName==DA_CurrentGuild then
		elseif not guildName and DA_CurrentGuild=="n0-guild" then
		else
			table.wipe(DA_Fep_bulk)
			DA.ResumeTimer("greset")
			DarkAngel_minimapBtn:Disable()
			DarkAngel_minimapBtn:Hide()
			self:SetScript("OnUpdate",nil)
			return
		end
		
		if not DA_Fep_bulk[1] then
			self:SetScript("OnUpdate",nil)
			return
		end

		DA_Fep_bulk[1]()
		table.remove(DA_Fep_bulk,1)
	end) 
	
	--minimap options hide
	DA.CreateTimer(nil,"mmap_hider",0,0.2,function() if DarkAngel_minimapBtn.menu:IsShown() then return true end end,function(self)
		if DarkAngel_minimapBtn:IsMouseOver() or DarkAngel_minimapBtn.menu:IsMouseOver() then 
			DarkAngel_minimapBtn.menu.timerticked=0 
		elseif not DarkAngel_minimapBtn:IsVisible() then
			DarkAngel_minimapBtn.menu.timerticked=0
			DarkAngel_minimapBtn.menu:Hide()
			return
		else
			DarkAngel_minimapBtn.menu.timerticked=DarkAngel_minimapBtn.menu.timerticked+1
		end
		
		if DarkAngel_minimapBtn.menu.timerticked>=6 then
			DarkAngel_minimapBtn.menu.timerticked=0
			DarkAngel_minimapBtn.menu:Hide()
		end
		
		
	end)		
	
	--guild refresher
	DA.CreateTimer(nil,"grefresher",0,5,function() if DarkAngelGUI.Guild:IsVisible() and fuckingOptions.grefr then return true end end,function(self)
		if not DarkAngelGUI.ismoving and not DarkAngelGuild.custom_mode then
			DA.GetGuildData()
			DA.GuildSetAllLines()
		end
	end)

	--rightclick optmenu hide
	DA.CreateTimer(nil,"OptHider",0,0.2,function() if DA_RightClickMenu and DA_RightClickMenu:IsShown() then return true end end,function(self)
		if (DA_RightClickMenu.parentbtn:IsMouseOver() or DA_RightClickMenu:IsMouseOver() or DA_RightClickMenu.epgpawardFrame:IsMouseOver() or DA_RightClickMenu.epgpawardFrame.Dropdown:IsMouseOver()) then 
			DA_RightClickMenu.timerticked=0 
		elseif not _G[DA_RightClickMenu.calledfrom]:IsVisible() then
			DA_RightClickMenu.timerticked=0
			DA_RightClickMenu:Hide()
			return
		else
			DA_RightClickMenu.timerticked=DA_RightClickMenu.timerticked+1
		end
		
		if DA_RightClickMenu.timerticked>=6 then
			DA_RightClickMenu.timerticked=0
			DA_RightClickMenu:Hide()
		end
		
	end) 

	--bulk processor
	DA_Bulk_list={}
	DA.CreateTimer(nil,"bulkprocessor",0,0.2,true,function(self)
		if not DA_Bulk_list[1] then self:SetScript("OnUpdate",nil) return end
		DA_Bulk_list[1]() 
		table.remove(DA_Bulk_list,1)

		return
	end)

	--guild reset timer
	DA.CreateTimer(nil,"greset",9,10,true,function(self)
		-- print('greset run')
		DA.Rewrite_Gopt()
		Run_OnGuildUpdate()
		DarkAngel_minimapBtn:Enable()
		DarkAngel_minimapBtn:Show()
		self:SetScript("OnUpdate",nil)
	end)


end
function DA:OnEnable()
-- DA.Print('core OnEnable')
	QueryGuildEventLog()
	self.loadFrame=CreateFrame("Frame")
	self.loadFrame:SetScript("OnEvent", function() TryInitGuildData() end)
	self.loadFrame:RegisterEvent("PLAYER_GUILD_UPDATE")
    self.loadFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
	TryInitGuildData()

	DA.CreateTimer(1,"init_noguild",0,0.2,true,function(self)
		if not self.tick then self.tick=0 end
		
		self.tick=self.tick+1
		local guildName,_,_= GetGuildInfo('player')
		if self.tick>=15 and not guildName then
			-- DA.Print('init_noguild triggered')
			OnGuildDataAvailable(guildName,'delayednoguild')
			self:SetScript("OnUpdate",nil)
			return
		elseif guildName then
			-- DA.Print('init_noguild cancelled')
			self:SetScript("OnUpdate",nil)
			return
		end
		
	end) 
	
end


TryInitGuildData = function()
-- DA.Print('core TryInit')
    if DA.guildDataInitialized then 
		DA.loadFrame:UnregisterEvent("PLAYER_GUILD_UPDATE")
		DA.loadFrame:UnregisterEvent("GUILD_ROSTER_UPDATE")
		-- print('early exit')
		return 
	end

    local guildName,_,_ = GetGuildInfo("player")
	local n,_=GetGuildRosterInfo(1)
	local ginfoloaded = GetGuildInfoText()~=""
	
	if not IsInGuild() then
        DA.guildDataInitialized = true
		DA.loadFrame:UnregisterEvent("PLAYER_GUILD_UPDATE")
		DA.loadFrame:UnregisterEvent("GUILD_ROSTER_UPDATE")
		QueryGuildEventLog()
        OnGuildDataAvailable(guildName, 'delayednoguild')
		-- print('quick no guild')
		DA.StopTimer('init_noguild')
		return 
	end

    if guildName and n and (ginfoloaded or DA.GuildInfoFetched) then
		-- print('exit on finish')
		-- DA.Print('core Init passed')
        DA.guildDataInitialized = true
		DA.loadFrame:UnregisterEvent("PLAYER_GUILD_UPDATE")
		DA.loadFrame:UnregisterEvent("GUILD_ROSTER_UPDATE")
		QueryGuildEventLog()
        OnGuildDataAvailable(guildName)
    end
end
OnGuildDataAvailable = function(guildName,delayednoguild)
	
	-- DA.Print('core gdata init')
	if not guildName and not delayednoguild then
		-- DA.Print('core gdata init failed')
		return
	end
	
	DA_CurrentGuild = guildName or 'n0-guild'
	if DA.OnInit_completed then
		-- DA.Print('core gdata greset')
		DA.ResumeTimer("greset")
		return
	else
		-- DA.Print('core gdata init GUI')
		Dark_Angel_OnInit(guildName)
	end
		
	if not next(DA.modules) then
		-- DA.Print('core gdata init nomod')
		ModsAndGuildDataReady("nomods")
	else
		-- DA.Print('core gdata init mods')
		DA.GuildDataReady=true
		IfModsAndGuildDataReady()
	end
	
	
	
end
function DA:ModuleLoaded(name)
-- print('[|cffed94edDarkAngel|cffffffff]: mod loaded',name)
    DA.IsModuleLoaded[name] = true

    for modName,_  in pairs(self.modules) do 
        if not DA.IsModuleLoaded[modName] then
            return
        end
    end
	-- DA.Print('all mods loaded')
	self.AllModulesLoaded=true
    IfModsAndGuildDataReady()
end
IfModsAndGuildDataReady = function()
	if DA.GuildDataReady and DA.AllModulesLoaded then
	
		DA.GuildDataReady=nil
		DA.AllModulesLoaded=nil
		
		ModsAndGuildDataReady()
	end
	
end

local function SetAllFrameCoords()
	for frameName,pos in pairs(fuckingOptions.saved_guiPositions) do
		if _G[frameName] then
			_G[frameName]:ClearAllPoints()
			if pos then
				_G[frameName]:SetPoint(pos[1] or "TOPLEFT",_G["UIParent"],pos[2] or "CENTER",pos[3] or 0,pos[4] or 0)
			else
				_G[frameName]:SetPoint("TOPLEFT",_G["UIParent"],"CENTER",0,0)
			end
			_G[frameName]:GetScript("OnDragStop")(_G[frameName])
		end
	end
	
end


function DA.AddModOptions(modName, func)
	table.insert(DA.modOptCreate, {modName, func})
end
ModsAndGuildDataReady = function(nomods)
	DA.RegatherGuildNotes()
	
	if nomods then
		-- DA.Print('mod opt: no mods')
	else
		for modName,mod in pairs(DA.modules) do
			-- print('[|cffed94edDarkAngel|cffffffff]: init mod',modName)
			if mod.OnGuildLoad then
				-- print('[|cffed94edDarkAngel|cffffffff]: OnGuildLoad')
				mod:OnGuildLoad()
			end
			-- if mod.AddModOptions then
			-- 	-- print('[|cffed94edDarkAngel|cffffffff]: '.. modName,"options")
			-- 	mod:AddModOptions(modOptTable)
			-- end
			DA.loaded_Modules[modName]=true
		end
		
	end
	if not DA.loaded_Modules['Logger'] then
		DA_RightClickMenu.detailsbtn:Disable()
	end
	
	SetAllFrameCoords()
	DA:MimimapMenu_Create()
	
	-- DA.CreateTweakGUIs(modOptTable,DA.loaded_Modules)

	

	
	tinsert(DA_Fep_bulk,function()  end)
	tinsert(DA_Fep_bulk,function()  end)
	tinsert(DA_Fep_bulk,function()  end)
	tinsert(DA_Fep_bulk,function()  end)
	tinsert(DA_Fep_bulk,function() 
		for _,j in pairs({'epgpofficer','epgpmultiple','epgptwinksandloot','rrtwinks'}) do
			DA.RunTweaks(j,1)
		end
	end)
	DA.ResumeTimer('fep')
end

Run_OnGuildUpdate = function()
	for _,func in ipairs(DA.RunOnGuildUpdate) do
		func()
	end
end


-- Variables
local function removeEmptySubtables(tbl)
    local k = next(tbl)
    while k do
        local v = tbl[k]
        if type(v) == "table" then
            if next(v) == nil or #v == 0 then
                tbl[k] = nil
            end
        end
        k = next(tbl, k)
    end
end
function DA.OptionsUpd()
	fuckingOptions=fuckingOptions or fuckingOptions_local
	fucking2Options_char=fucking2Options_char or fucking2Options_char_local
	--remove junk
	for i,_ in pairs(fuckingOptions) do
		if fuckingOptions_local[i]~=nil then
		else
			fuckingOptions[i]=nil
		end
	end

	for i,_ in pairs(fucking2Options_char) do
		if fucking2Options_char_local[i]~=nil then
		else
			fucking2Options_char[i]=nil
		end
	end

	--add new options
	for i,g in pairs(fuckingOptions_local) do
		if fuckingOptions[i]~=nil then
		-- if fuckingOptions[i]~=nil and ( (type(g)=='table' and type(fuckingOptions[i])==type(g) and #fuckingOptions[i]==#g) or (type(g)~='function' and type(fuckingOptions[i])==type(g)) ) then
		else
			fuckingOptions[i]=g
		end
	end

	for i,g in pairs(fucking2Options_char_local) do
		if fucking2Options_char[i]~=nil then
		-- if fuckingOptions[i]~=nil and ( (type(g)=='table' and type(fuckingOptions[i])==type(g) and #fuckingOptions[i]==#g) or (type(g)~='function' and type(fuckingOptions[i])==type(g)) ) then
		else
			fucking2Options_char[i]=g
		end
	end


	--clear backups
	removeEmptySubtables(DA_BackupsDB)
	removeEmptySubtables(DA_Backups_charDB)

end
function DA.OptionsUpd_g()
	--remove junk
	for i,_ in pairs(fuckingOptions_g[DA_CurrentGuild]) do
		if fuckingOptions_g_local[i]~=nil then
		else
			fuckingOptions_g[DA_CurrentGuild][i]=nil
		end
	end
	--add new options
	for i,g in pairs(fuckingOptions_g_local) do
		if fuckingOptions_g[DA_CurrentGuild][i]~=nil then
		-- if fuckingOptions[i]~=nil and ( (type(g)=='table' and type(fuckingOptions[i])==type(g) and #fuckingOptions[i]==#g) or (type(g)~='function' and type(fuckingOptions[i])==type(g)) ) then
		else
			fuckingOptions_g[DA_CurrentGuild][i]=g
		end
	end


end
function DA.Rewrite_Gopt()
local guildName,_,_= GetGuildInfo('player')
	DA_CurrentGuild=guildName or "n0-guild"
	
	if DA.modules.Logger then DA.Logger_rewrite_Gopt() end
	FEP_L_gMain[DA_CurrentGuild]=FEP_L_gMain[DA_CurrentGuild] or {}
	fuckingOptions_g[DA_CurrentGuild]=fuckingOptions_g[DA_CurrentGuild] or {}
	DA.OptionsUpd_g()
	if DA_CurrentGuild~='n0-guild' then
		if DA.CheckEPGPGuildInfo then DA.CheckEPGPGuildInfo() end
		local guildType=DA.DetermineDKPorEPGPguild()
			DA_Guild_Info[DA_CurrentGuild].GuildType=guildType
		if DA.modules.Logger then DA.ResumeTimer('scaner') end
	end
	
end



-- Init Main
local function Create_Slash_Functions()
	SLASH_FRAMESTK1 = SLASH_FRAMESTK1 or "/fs"
	SlashCmdList.FRAMESTK = SlashCmdList.FRAMESTK or function() LoadAddOn("Blizzard_DebugTools");FrameStackTooltip_Toggle() end
	
	StaticPopupDialogs["DA_COPY_TEXT_POPUP"] = {
		text = "",                -- must be non‑nil
		button1 = "Close",
		hasEditBox = true,
		hasWideEditBox = true,
		maxLetters = 2048,
		editBoxWidth = 320,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = STATICPOPUP_NUMDIALOGS,

		OnShow = function(self)
			local text = self.data or ""
			-- pick the real edit‐box
			local eb 
			if self.editBox and self.editBox:IsShown() then
				eb = self.editBox 
			elseif self.wideEditBox and self.wideEditBox:IsShown() then
				eb = self.wideEditBox
			end
			eb:SetText(text)
			eb:SetCursorPosition(0)      -- force a layout refresh
			eb:HighlightText()           -- visually select it
			eb:SetFocus()
		end,

		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,

		EditBoxOnEnterPressed = function(self)
			self:GetParent():Hide()
		end,

		EditBoxOnEditFocusGained = function(self)
			self:HighlightText()
		end,
	}


	function DA_targetep(reason,ammount,optionaltarg)
		
		local target=UnitName('target')
		if optionaltarg then target=optionaltarg end
		
		if not reason then
			DA.Print("specify any reason in quotes \"reason\"")
			DA.Print([[  Usage:  DA_targetep(reason,ammount) ]])
			return
		elseif not ammount then
			DA.Print("specify any ammount")
			DA.Print([[  Usage:  DA_targetep(reason,ammount) ]])
			return
		elseif not target then
			DA.Print("select target")
			DA.Print([[  Usage:  DA_targetep(reason,ammount) ]])
			return
		elseif not type(reason)=="string" and not tonumber(reason) then
			DA.Print("reason should be specified in quotes: \"reason\"")
			DA.Print([[  Usage:  DA_targetep(reason,ammount) ]])
			return
		elseif not tonumber(ammount) then
			DA.Print("ammount should be specified as number: 500")
			DA.Print([[  Usage:  DA_targetep(reason,ammount) ]])
			return
		end
		reason=tostring(reason) or ""
		ammount=tonumber(ammount) or 0
		
		DA.RegatherGuildNotes()
		
		if FEP_gMain[target] and DA.DecodeNote(FEP_gMain[target])=='m' then
			if ammount<0 then
				local _,ep,gp=DA.DecodeNote(FEP_gMain[target])
				if ep>=math.abs(ammount) then
					DA.EPawardfunc(target,ammount,reason)
				else
					DA.Print('not enough EP. '..target..' has '..ep..','..gp)
					return
				end
			else
				DA.EPawardfunc(target,ammount,reason)
			end
			
		elseif FEP_gMain[target] and DA.DecodeNote(FEP_gMain[target])=='f' then
			DA.Print('target has frozen EPGP')
			return
			
		elseif FEP_gMain[target] and DA.DecodeNote(FEP_gMain[target])=='t' then
			if FEP_gMain[FEP_gMain[target]] then
				if DA.DecodeNote(FEP_gMain[FEP_gMain[target]])=='m' then
					if ammount<0 then
						local _,ep,gp=DA.DecodeNote(FEP_gMain[FEP_gMain[target]])
						if ep>=math.abs(ammount) then
							DA.EPawardfunc(FEP_gMain[target],ammount,reason,{target, false})
						else
							DA.Print('not enough EP. '..target..'['..FEP_gMain[target]..']'..' has '..ep..','..gp)
							return
						end
					else
						DA.EPawardfunc(FEP_gMain[target],ammount,reason,{target, false})
					end
				elseif DA.DecodeNote(FEP_gMain[FEP_gMain[target]])=='f' then
					DA.Print('target\'s main has frozen EPGP')
					return
				elseif DA.DecodeNote(FEP_gMain[FEP_gMain[target]])=='t' then
					DA.Print('target has incorrect main (double tvin)')
					return
				end
			else
				DA.Print('target has incorrect main / main left guild')
				return
			end
			
		elseif FEP_L_gMain[DA_CurrentGuild][target] then
			
			if ammount<0 then
				local _,ep,gp=DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][target]])
				if ep>=math.abs(ammount) then
					DA.EPawardfunc(FEP_L_gMain[DA_CurrentGuild][target],ammount,reason,{target,true})
				else
					DA.Print('not enough EP. '..target..'['..FEP_L_gMain[DA_CurrentGuild][target]..']'..' has '..ep..','..gp)
					return
				end
			else
				DA.EPawardfunc(FEP_L_gMain[DA_CurrentGuild][target],ammount,reason,{target,true})
			end
		end
		
	end
	
	function DA_targetgp(reason,ammount,optionaltarg)
		local target=UnitName('target')
		if optionaltarg then target=optionaltarg end
		
		if not reason then
			DA.Print("specify any reason in quotes \"reason\"")
			DA.Print([[  Usage:  DA_targetgp(reason,ammount) ]])
			return
		elseif not ammount then
			DA.Print("specify any ammount")
			DA.Print([[  Usage:  DA_targetgp(reason,ammount) ]])
			return
		elseif not target then
			DA.Print("select target")
			DA.Print([[  Usage:  DA_targetgp(reason,ammount) ]])
			return
		elseif not type(reason)=="string" and not tonumber(reason) then
			DA.Print("reason should be specified in quotes: \"reason\"")
			DA.Print([[  Usage:  DA_targetgp(reason,ammount) ]])
			return
		elseif not tonumber(ammount) then
			DA.Print("ammount should be specified as number: 500")
			DA.Print([[  Usage:  DA_targetgp(reason,ammount) ]])
			return
		end
		reason=tostring(reason) or ""
		ammount=tonumber(ammount) or 0
		
		DA.RegatherGuildNotes()
		
		if FEP_gMain[target] and DA.DecodeNote(FEP_gMain[target])=='m' then
			if ammount<0 then
				local _,ep,gp=DA.DecodeNote(FEP_gMain[target])
				if gp>=math.abs(ammount) then
					DA.GPawardfunc(target,ammount,reason)
				else
					DA.Print('not enough GP. '..target..' has '..ep..','..gp)
					return
				end
			else
				DA.GPawardfunc(target,ammount,reason)
			end
			
		elseif FEP_gMain[target] and DA.DecodeNote(FEP_gMain[target])=='f' then
			DA.Print('target has frozen EPGP')
			return
			
		elseif FEP_gMain[target] and DA.DecodeNote(FEP_gMain[target])=='t' then
			if FEP_gMain[FEP_gMain[target]] then
				if DA.DecodeNote(FEP_gMain[FEP_gMain[target]])=='m' then
					if ammount<0 then
						local _,ep,gp=DA.DecodeNote(FEP_gMain[FEP_gMain[target]])
						if gp>=math.abs(ammount) then
							DA.GPawardfunc(FEP_gMain[target],ammount,reason,{target,false})
						else
							DA.Print('not enough GP. '..target..'['..FEP_gMain[target]..']'..' has '..ep..','..gp)
							return
						end
					else
						DA.GPawardfunc(FEP_gMain[target],ammount,reason,{target,false})
					end
				elseif DA.DecodeNote(FEP_gMain[FEP_gMain[target]])=='f' then
					DA.Print('target\'s main has frozen EPGP')
					return
				elseif DA.DecodeNote(FEP_gMain[FEP_gMain[target]])=='t' then
					DA.Print('target has incorrect main (double tvin)')
					return
				end
			else
				DA.Print('target has incorrect main / main left guild')
				return
			end
			
		elseif FEP_L_gMain[DA_CurrentGuild][target] then
			
			if ammount<0 then
				local _,ep,gp=DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][target]])
				if gp>=math.abs(ammount) then
					DA.GPawardfunc(FEP_L_gMain[DA_CurrentGuild][target],ammount,reason,{target,true})
				else
					DA.Print('not enough GP. '..target..'['..FEP_L_gMain[DA_CurrentGuild][target]..']'..' has '..ep..','..gp)
					return
				end
			else
				DA.GPawardfunc(FEP_L_gMain[DA_CurrentGuild][target],ammount,reason,{target,true})
			end
		end
		
	end
	SLASH_RELOADUI1 = "/rl"
	SlashCmdList.RELOADUI = function() ReloadUI() end
	
	SLASH_FSRversion1 = "/daversion"
	SlashCmdList["FSRversion"] = function() SendAddonMessage("DA_vrq",GetUnitName("player"), "guild") end
	SLASH_FSRversionr1 = "/daversionr"
	SlashCmdList["FSRversionr"] = function() SendAddonMessage("DA_vrq",GetUnitName("player"), "raid") end
end
function Dark_Angel_OnInit(guildinit)
	DA.OnInit_completed=true
	if DA.modules.Logger then DA.Logger_rewrite_Gopt() end
	
	DA_Guild_Info[DA_CurrentGuild]=DA_Guild_Info[DA_CurrentGuild] or {}
	DA_Guild_Info[DA_CurrentGuild].RecentAwards = DA_Guild_Info[DA_CurrentGuild].RecentAwards or {}
	DA_Guild_Info[DA_CurrentGuild].LogINFO = DA_Guild_Info[DA_CurrentGuild].LogINFO or {info={}, motd={}, gm={}, lastupdate1=time()/60}
	FEP_L_gMain[DA_CurrentGuild]=FEP_L_gMain[DA_CurrentGuild] or {}
	fuckingOptions_g[DA_CurrentGuild]=fuckingOptions_g[DA_CurrentGuild] or {}
	
	DA_Standby[DA_CurrentGuild]=DA_Standby[DA_CurrentGuild] or ""

	DA.OptionsUpd_g()
	local guildType=DA.DetermineDKPorEPGPguild()
		DA_Guild_Info[DA_CurrentGuild].GuildType=guildType
	
	DA.CreateGUIs()
	
	
	DarkAngelGUI:SetScale(fuckingOptions.FFGScale)
	DarkAngelGUI.Guild.GC:SetScale(fuckingOptions.GCScale)
	

	Create_Slash_Functions()
	
	
	DA.ResetScrollBoxes()
	if IsInGuild() and DA.CheckEPGPGuildInfo then
		DA.CheckEPGPGuildInfo()
	end
	
	

	
	DA.Print(GetAddOnMetadata("DarkAngel",'version').." |cff00ffffloaded|r");DarkAngel_minimapBtn:Show();fuckingOptions.firsttimeloaded=false;DarkAngel_minimapBtn.fullyloaded=1
	
	DA.ResumeTimer('fep')
	
	DA.RePaintFrames()
	
	
	local SetHyperlink = ItemRefTooltip.SetHyperlink
	ItemRefTooltip.SetHyperlink = function(self, link, text, button, frame)
		if (string.sub(link, 1, 9) == "dalogsrch") then
			local name = string.sub(link, 11)
			if name then
				DA.OpenLogSearch(name)

			end
			
		elseif (string.sub(link, 1, 6) == "dalink") then
			local id = string.sub(link, 8)
			local data = DA.LinkStorage[id]
			if data then
				StaticPopup_Show("DA_COPY_TEXT_POPUP", nil, nil, data)

			end
		else
			SetHyperlink(self, link, text, button, frame)
		end
	end

	
	SendAddonMessage("DA_RTq",'1', "guild")
	

end
function DA.RunTweaks(param,firstrun)

	local enabled=fuckingOptions[param]
	if firstrun and not enabled then return end


	if param=='epgpofficer' then
		if EPGP then 
			if select(1, EPGP:GetModule('warnings'):IsHooked(GuildMemberOfficerNoteBackground,"OnMouseUp",officer_note_warning))==true and enabled then
				EPGP:GetModule('warnings'):Unhook(GuildMemberOfficerNoteBackground,"OnMouseUp",officer_note_warning)
			elseif select(1, EPGP:GetModule('warnings'):IsHooked(GuildMemberOfficerNoteBackground,"OnMouseUp",officer_note_warning))~=true and not enabled then
				local function officer_note_warning()
					StaticPopup_Show("EPGP_OFFICER_NOTE_WARNING")
				end
				EPGP:GetModule('warnings'):RawHookScript(GuildMemberOfficerNoteBackground, "OnMouseUp",officer_note_warning)
			end
		end
		
	elseif param=='epgpmultiple' then
		if EPGP then 
			if StaticPopupDialogs["EPGP_MULTIPLE_MASTERS_WARNING"].timeout>0.5 and enabled then
				StaticPopupDialogs["EPGP_MULTIPLE_MASTERS_WARNING"].timeout=0.1
			elseif StaticPopupDialogs["EPGP_MULTIPLE_MASTERS_WARNING"].timeout==0.1 and not enabled then
				StaticPopupDialogs["EPGP_MULTIPLE_MASTERS_WARNING"].timeout=15
			end
		end

	elseif param=='epgptwinksandloot' then
		if LibStub and EPGP then
				
			if LibStub("LibLootNotify-1.0").callbacks.events['LootReceived'] and enabled then
				LibStub("LibLootNotify-1.0").callbacks.events.LootReceived=nil
				LibStub("LibLootNotify-1.0").RegisterCallback(EPGP:GetModule('loot'), "LootReceived", 
				function(event_name, Gplayer, GitemLink, Gquantity)

					local Coroutine = LibStub("LibCoroutine-1.0")
					local ignored_items = {
						[20725] = true, -- Nexus Crystal
						[22450] = true, -- Void Crystal
						[34057] = true, -- Abyss Crystal
						[29434] = true, -- Badge of Justice
						[40752] = true, -- Emblem of Heroism
						[40753] = true, -- Emblem of Valor
						[45624] = true, -- Emblem of Conquest
						[47241] = true, -- Emblem of Triumph
						[49426] = true, -- Emblem of Frost
						[30311] = true, -- Warp Slicer
						[30312] = true, -- Infinity Blade
						[30313] = true, -- Staff of Disintegration
						[30314] = true, -- Phaseshift Bulwark
						[30316] = true, -- Devastation
						[30317] = true, -- Cosmic Infuser
						[30318] = true, -- Netherstrand Longbow
						[30319] = true, -- Nether Spikes
						[30320] = true, -- Bundle of Nether Spikes

						[50274] = true, -- Осколок Льда Тьмы
						[45038] = true, -- щепка валанира
						[52025] = true, -- токен об рог дк маг друид
						[52027] = true, -- токен об пал прист лох (лок)
						[52026] = true, -- токен об вар хант шам
						[50231] = true, -- кровь тухлопуза
						[50226] = true, -- кровь гниломорда
						[52006] = true, --Мешок ледяных сокровищ
						[49967] = true, --Хладное око Ребрада
						[49994] = true, --Легкие дамские наручи
						[50001] = true, --Чудесный мешок Икфирия
						[50015] = true, --Пояс кольца крови
						[50020] = true, --Латные наплечники яростного чудища
						[50038] = true, --Панцирь забытых королей
						[50069] = true, --Окровавленная хламида профессора
						[50175] = true, --Наручи хранителя тайны
						[50182] = true, --Багровое колье Кровавой королевы
						[50444] = true, --Винтовка Ровэна с серебряными пулями
						[50447] = true, --Костяное кольцо провозвестника
						[50449] = true, --Наплечные пластины окоченевшего трупа
						[50450] = true, --Поножи неявных чар
						[50451] = true, --Пояс одинокого благородства
						[50452] = true, --Счастливое ожерелье Водина
						[50453] = true, --Кольцо из гниющих сухожилий
						[50472] = true, --Избавление от кошмаров
						[36919] = true, --Багровый рубин
						[36922] = true, --Царский янтарь
						[36925] = true, --Величественный циркон
						[36928] = true, --Страхолит
						[36931] = true, --Аметрин
						[36934] = true, --Око Зула
					}
					local function IsRLorML()
					  if UnitInRaid("player") then
						local loot_method, ml_party_id, ml_raid_id = GetLootMethod()
						if loot_method == "master" and ml_party_id == 0 then return true end
						if loot_method ~= "master" and IsRaidLeader() then return true end
					  end
					  return false
					end
					_G['RR_guild_data5']=_G['RR_guild_data5'] or {}
					_G['RR_gather_guild_data']=_G['RR_gather_guild_data'] or function ()	
					RR_guild_data5=nil
					RR_guild_data5={}
					for i=1,DA.GetNumGMembers() do
						local character, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i);
						-- character = string.lower(character)
						RR_guild_data5[character]=officernote or ""
						
					end

					end
					_G['FEz_isinthesameguild']=_G['FEz_isinthesameguild'] or function(character)
					RR_gather_guild_data()
					if RR_guild_data5[character] then 
						return true
					else 
						return false
					end
					end	
					function FDShowPopup(player, item, quantity)
						local popupname='EPGP_CONFIRM_GP_CREDIT'
						if fuckingOptions_g[DA_CurrentGuild].epgpepauc then
							popupname='EPGP_CONFIRM_MINUS_EP_CREDIT'
						end
						while InCombatLockdown() or StaticPopup_Visible(popupname) do
							Coroutine:Sleep(0.1)
						end

						local itemName, itemLink, itemRarity, _, _, _, _, _, _, itemTexture = GetItemInfo(item)
						local r, g, b = GetItemQualityColor(tonumber(itemRarity) or 1)

						if EPGP:GetEPGP(player) then

							local dialog = StaticPopup_Show(popupname, player, "", {
								texture = itemTexture,
								name = itemName,
								color = {r, g, b, 1},
								link = itemLink,
							})
							if dialog then
								dialog.name = player
							end
							
						elseif FEP_L_gMain[DA_CurrentGuild][player] and DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][player]])=='m' and (not FEz_isinthesameguild(player)) then
							player=FEP_L_gMain[DA_CurrentGuild][player]
							local dialog = StaticPopup_Show(popupname, player, "", {
								texture = itemTexture,
								name = itemName,
								color = {r, g, b, 1},
								link = itemLink,
							})
							if dialog then
								dialog.name = player
							end

						end
					end

				if IsRLorML() and CanEditOfficerNote() then
					local itemID = tonumber(GitemLink:match("item:(%d+)") or 0)
					if not itemID then return end

					local itemRarity = select(3, GetItemInfo(itemID))
					if itemRarity < EPGP:GetModule('loot').db.profile.threshold then return end

					if ignored_items[itemID] then return end

					Coroutine:RunAsync(FDShowPopup,Gplayer, GitemLink, Gquantity)
				  end
				end)
				
				
			elseif LibStub("LibLootNotify-1.0").callbacks.events['LootReceived'] and not enabled then
				DA.Print('|cffff2020this feature will be disabled upon interface reload')
				DA.Print('use /rl command')
			end
		end
		
		
	elseif param=='rrtwinks' then
		
			if enabled then
				_G['RR_EPGPHasLoaded']=true
					 
				_G['RR_ReallyGetEPGPGuildData']=function ()
					if IsInGuild() then
						RR_GuildInfo = GetGuildInfoText();
						local string_start,string_end = string.find(RR_GuildInfo, "%-EPGP%-");
						if string_start ~= nil and string_end ~= nil then
							RR_GuildInfo = string.sub(GetGuildInfoText(), string_end+2)
							string_start,string_end = string.find(RR_GuildInfo, "%-EPGP%-");
							if string_start ~= nil and string_end ~= nil then
								RR_GuildInfo = string.sub(RR_GuildInfo, 1, string_start-2);
							end
							for i=1,10 do
								if RR_GuildInfo ~= nil then
									string_start,string_end=string.find(RR_GuildInfo, "%@+%a+%_%a+%:%d+");
									if string_start ~= nil then
										local Substring = string.sub(RR_GuildInfo, string_start, string_end);
										RR_GuildInfo = string.sub(RR_GuildInfo, string_end+2);
										
										string_start,string_end=string.find(Substring, "%@+%a+%_%a+%:");
										local Type = string.upper(string.sub(Substring, string_start+1, string_end-1))
										
										string_start,string_end=string.find(Substring, "%:%d+");
										local Value = tonumber(string.sub(Substring, string_start+1, string_end));
										
										RaidRoll_DB[Type] = Value ;
									end
								end
							end
						end
					end
				end
			
				_G['RR_guild_data5']=_G['RR_guild_data5'] or {}
				_G['RR_gather_guild_data']=_G['RR_gather_guild_data'] or function()	
					RR_guild_data5=nil
					RR_guild_data5={}
					for i=1,DA.GetNumGMembers() do
						local character, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i);
						-- character = string.lower(character)
						RR_guild_data5[character]=officernote or ""
						
					end
				end
				
				_G['RR_isinthesameguild']=_G['RR_isinthesameguild'] or function (character)
					if RR_guild_data5[character] then 
						return true
					else 
						return false
					end
				end	
				
				_G['RR_ReallyGetEPGPCharacterData']=function(character)
					RR_gather_guild_data()
					local PR = 0
					local AboveThreshold = false
					local EP = 0
					local GP = 0
					
					if IsInGuild() then
						RR_GetEPGPGuildData()
						if character ~= nil then 
								if UnitName('player')~=character and (not RR_isinthesameguild(character)) and FEP_L_gMain[DA_CurrentGuild][character] and DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][character]])=='m' then
									character=FEP_L_gMain[DA_CurrentGuild][character]
								end
								if RR_guild_data5[character] then
									local officernote = strtrim(RR_guild_data5[character])
									
									EP,GP = strsplit("," ,officernote)
									
									EP = tonumber(EP)
									GP = tonumber(GP)
									
									
									if tonumber(EP) == nil and tonumber(GP) == nil then
										if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Enable_Alt_Mode"] == true then
											
											character = officernote
											
												if RR_guild_data5[character] then
													officernote = strtrim(RR_guild_data5[character])
													
													EP,GP = strsplit("," ,officernote)
													
													EP = tonumber(EP)
													GP = tonumber(GP)
												end
										end
									end
									
									if tonumber(EP) == nil then EP = 0 end
									if tonumber(GP) == nil then GP = 0 end
									
									GP = GP + RaidRoll_DB["BASE_GP"]
									PR = (ceil(EP/(GP+1)*100) / 100)
									if EP >= RaidRoll_DB["MIN_EP"] then AboveThreshold = true end
									if RaidRoll_DB["debug"] == true then RR_Test(character .. ": EP=" .. EP .. " GP=" .. GP .. " PR=" .. PR) end
								end
						end
					end
					
					return PR,AboveThreshold,EP,GP
				end
			elseif not enabled then
				if _G['RR_ReallyGetEPGPCharacterData'] then
					_G['RR_ReallyGetEPGPCharacterData']=function(character)
						local PR = 0
						local AboveThreshold = false
						local EP = 0
						local GP = 0
						
						if IsInGuild() then
							RR_GetEPGPGuildData()
							if character ~= nil then 
								character = string.lower(character)
								
								for i=1,GetNumGuildMembers() do
									local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(i);
									
									name = string.lower(name)
									
									
									if character == name then
										
										
										officernote = strtrim(officernote)	-- cut out [space][tab][return][newline]
										
										EP,GP = strsplit("," ,officernote)
										
										EP = tonumber(EP)
										GP = tonumber(GP)
										
										
									-- Search for the Main character
										if tonumber(EP) == nil and tonumber(GP) == nil then
											if RaidRoll_DBPC[UnitName("player")]["RR_RollCheckBox_Enable_Alt_Mode"] == true then
												
												character = officernote
												
												for j=1,GetNumGuildMembers(true) do
													name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(j);
													
													if strlower(character) == strlower(name) then
														officernote = strtrim(officernote)	-- cut out [space][tab][return][newline]
														
														EP,GP = strsplit("," ,officernote)
														
														EP = tonumber(EP)
														GP = tonumber(GP)
													end								
												end
											end
										end
										
										if tonumber(EP) == nil then EP = 0 end
										if tonumber(GP) == nil then GP = 0 end
										
										GP = GP + RaidRoll_DB["BASE_GP"]
										
										
										PR = (ceil(EP/(GP+1)*100) / 100)
										
										if EP >= RaidRoll_DB["MIN_EP"] then AboveThreshold = true end
										
										if RaidRoll_DB["debug"] == true then RR_Test(name .. ": EP=" .. EP .. " GP=" .. GP .. " PR=" .. PR) end
										
									end
								end
							end
						end
						
						return PR,AboveThreshold,EP,GP
					end

					
				end
			end
		
	end

end

local comm_registered={}
local function comm_ticker(_,_,prefix,msg,destrib_channel,sender)
	if comm_registered[prefix] then
		comm_registered[prefix](msg, destrib_channel, sender)
	end
end
local xb=CreateFrame("Frame");
xb:SetScript("OnEvent",comm_ticker);
xb:RegisterEvent("CHAT_MSG_ADDON")
function DA:RegisterComm(pref, func)
	if comm_registered[pref] then
		print('error 2544',pref)
	else
		comm_registered[pref]=func
	end
end
DA:RegisterComm("DA_vrq", function(message, dtype, sender)
		if DA.IsInSameGuild(sender) or UnitInRaid(sender) then
			SendAddonMessage("DA_vans", GetAddOnMetadata("DarkAngel",'version').."_Sp_Rr(_c7f"..dtype.."_Rr)", "WHISPER", sender)
		end 
end)
DA:RegisterComm("DA_vans", function(message, dtype, sender)
		if DA.IsInSameGuild(sender) or UnitInRaid(sender) then
			DA.Print("   v|cff00ffff"..message:gsub("_Sp"," "):gsub("_Rr","|r"):gsub("_c7f","|cff77aaff").." |cffffffff"..sender)
		end 
end)