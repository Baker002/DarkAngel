

--[====[


                                           oOOOOOOOOOOOOOOoo.. 
                                            """""""""""OOOOOOOOo. 
                                          ..oooooooo..    `""OOOOO. 
                                      .oOOOOOOOOOOOOOOOOo     OOOOO 
                    ..ooOOOOOOo..oooOOOOOOOOOOOOOOOOOOOOOOoooOOOOO' 
           .Oo...ooOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"' 
       .oooOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"~~ 
         \oOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO' 
          OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOoOOOOOOOOOOOOOOO' 
         __\OO/"    "OOOOOOOOOOOOOOOOOOOO`OOOOOOOOOOOOO" 
           /|\   .oOOooo- `OOOOOOOO""   .O`OOOOOOOOOO' 
 oO--.        .oOOOO"~    .OOOOO'      QQOOO`OOOOOOOOOo 
 +o--o`----QQOOO"~       .OOOOO'                 `OOOOO 
                        .OOOO'                  QQQQO" 
                      QQQQO" 
					  
					  
					  
					  


  © 2025 Vitalii I. (Baker#7727)
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


DarkAngel = LibStub("AceAddon-3.0"):NewAddon("DarkAngel")

local DA=LibStub("AceAddon-3.0"):GetAddon("DarkAngel")
local L = LibStub("AceLocale-3.0"):GetLocale("DarkAngel")


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
	txt1op=0.2,
	txt2op=0.5,
	txt1extra=false,
	txt2extra=false,
	
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
	mmenucloserank=false,
	
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



	
	--SR opt
	SR_enab=1,
	SR_discenab=false,
	SR_gc=1,
	SR_pm=1,
	SR_lfg=1,
	SR_autojoin=false,
	SR_autoaccept=1,
	SR_autostop=false,
	SR_minutecount=1,
	RTmessage="РТ+++++++++++",
	RTdiscordlink="https://discord.gg/discord_link_here",
	RTstoper=50,
	RTlfgphrases='',
	
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
	
	doginviter=false,
	doginviterphrase='123121211211331311121311',
}
local fuckingOptions_g_local={
	epgpepauc=false,
	bidtracker=false,
	bidtracker_onlymine=true,
	evaluateoffnote=false,
	aw_send_whispers=1,
	initRaidLootMethod='m',
	inviter_stop=false,
	inviter_repeat=false,
	inviter_autostop=false,
	
	aw_auto_locals=true,
	aw_auto_Ch_locals=false,
	aw_auto_silent_locals=false,
	
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
	InvTimerSpeedTimer=4,
	
	standby_method='epgp',
	procepzamene=false,
	manual_procent=100,
	
	assistperm="Guild Rank",
	assistperm_rank=false,
	assistperm_manual="",
	
	aucoptsets={
		{20,1},
		{100,5},
		{200,10},
		['lastincr']=20,
	},
	auc_minimal=1,
	auc_allow_lower=1,
	auc_thousands=false,
	auc_thousands_step=false,
	auc_RR_hide=false,
	auc_allin=1,
	auc_bidconfirmed=1,
	
	warnsuspic=false,
	warn_improv_suspic=true,
	dkpcomm=false,
	dkpcomm_inraid=true,
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
	FEP_TT_savedfont1={"Fonts\\FRIZQT__.TTF", 14, ""}
	FEP_TT_savedfont2={"Fonts\\FRIZQT__.TTF", 12, ""}
	DA_BackupsDB={}
	DA_Backups_charDB={}
end


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

-- Initialization
function DA:OnInitialize()

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
	DA.CreateTimer(nil,"OptHider",0,0.2,function() if DAOptMenuFrame and DAOptMenuFrame:IsShown() then return true end end,function(self)
		if (DAOptMenuFrame.parentbtn:IsMouseOver() or DAOptMenuFrame:IsMouseOver() or DAOptMenuFrame.epgpawardFrame:IsMouseOver() or DAOptMenuFrame.epgpawardFrame.Dropdown:IsMouseOver()) then 
			DAOptMenuFrame.timerticked=0 
		elseif not _G[DAOptMenuFrame.calledfrom]:IsVisible() then
			DAOptMenuFrame.timerticked=0
			DAOptMenuFrame:Hide()
			return
		else
			DAOptMenuFrame.timerticked=DAOptMenuFrame.timerticked+1
		end
		
		if DAOptMenuFrame.timerticked>=6 then
			DAOptMenuFrame.timerticked=0
			DAOptMenuFrame:Hide()
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
		DarkAngel_minimapBtn:Enable()
		DarkAngel_minimapBtn:Show()
		self:SetScript("OnUpdate",nil)
	end) 


end
function DA:OnEnable()
	QueryGuildEventLog()
	self.loadFrame=CreateFrame("Frame")
	self.loadFrame:SetScript("OnEvent", function() self:OnGuildUpdate() end)
	self.loadFrame:RegisterEvent("PLAYER_GUILD_UPDATE")
	self:TryInitGuildData()	
	
	DA.CreateTimer(1,"init_noguild",0,0.2,true,function(self)
		if not self.tick then self.tick=0 end
		self.tick=self.tick+1
		local guildName,_,_= GetGuildInfo('player')
		if self.tick>=15 and not guildName then
			DA:OnGuildDataAvailable(guildName,'delayednoguild')
			self:SetScript("OnUpdate",nil)
			return
		end
		
	end) 
	
end
local Dark_Angel_OnInit_completed
function DA:OnGuildUpdate()
    self:TryInitGuildData()
end
function DA:TryInitGuildData()
    if self.guildDataInitialized then return end

    local guildName = GetGuildInfo("player")
	local n,_=GetGuildRosterInfo(1)
    if guildName and n then
        self.guildDataInitialized = true
		self.loadFrame:UnregisterEvent("PLAYER_GUILD_UPDATE")
		QueryGuildEventLog()
        self:OnGuildDataAvailable(guildName)
    end
end
function DA:OnGuildDataAvailable(guildName,delayednoguild)
	
	if not guildName and not delayednoguild then
		return
	end
	
	DA_CurrentGuild = guildName or 'n0-guild'
		if Dark_Angel_OnInit_completed then
			DA.ResumeTimer("greset")
			return
		else
			Dark_Angel_OnInit(guildName)
		end
		
	if not next(self.modules) then
		DA:ModsAndGuildDataReady(nomods)
	else
		self.GuildDataReady=true
		DA:IfModsAndGuildDataReady()
	end
	
	
	
end
local DA_loadedModules = {}
function DA:ModuleLoaded(name)

    DA_loadedModules[name] = true

    for modName,_  in pairs(self.modules) do 
        if not DA_loadedModules[modName] then
            return
        end
    end
	
	self.AllModulesLoaded=true
    self:IfModsAndGuildDataReady()
end
function DA:IfModsAndGuildDataReady()
	if self.GuildDataReady and self.AllModulesLoaded then
		self.GuildDataReady=nil
		self.AllModulesLoaded=nil
		
		DA:ModsAndGuildDataReady()
	end
	
end
function DA:ModsAndGuildDataReady(nomods)
	DA.RegatherGuildNotes()
	
	
	local modOptTable={}
	DA.loaded_Modules={}
	
	if nomods then
	
	else
		for modName,mod in pairs(self.modules) do
			if mod.OnGuildLoad then
				mod:OnGuildLoad()
			end
			if mod.AddModOptions then
				mod:AddModOptions(modOptTable)
			end
			DA.loaded_Modules[modName]=true
		end
		
	end
	if not DA.loaded_Modules['Logger'] then
		DAOptMenuFrame.detailsbtn:Disable()
	end
	DA.CreateTweakGUIs(modOptTable,DA.loaded_Modules)
	
	DA:SetAllFrameCoords()
	DA:MimimapMenu_Create()
	
	local priority = {
		["Logger"] = 1,
		["BidTracker"] = 2,
		["Awarder"] = 3,
		["Tweaks"] = 4
	}

	table.sort(modOptTable, function(a, b)
		local aVal = a and a[1] and priority[a[1]] or 99
		local bVal = b and b[1] and priority[b[1]] or 99
		return aVal < bVal
	end)
	
	local xOffset = 0
	local yOffset = -70
	local spacing = 5

	local anchors = {}

	for i, tbl in ipairs(modOptTable) do
	
		local modName = tbl[1]
		local modOptFrame = tbl[2]

		if DA.loaded_Modules[modName] then
			if modName == "Tweaks" then
				-- Position Tweaks frame based on existing loaded modules
				if anchors["BidTracker"] then
					modOptFrame:SetPoint("TOPLEFT", anchors["BidTracker"], "BOTTOMLEFT", 0, -spacing)
				elseif anchors["Awarder"] then
					modOptFrame:SetPoint("TOPLEFT", anchors["Awarder"], "BOTTOMLEFT", 0, -spacing)
				elseif anchors["Logger"] then
					modOptFrame:SetPoint("TOPLEFT", anchors["Logger"], "TOPRIGHT", spacing, 0)
				else
					modOptFrame:SetPoint("TOPLEFT", DarkAngelopt.scrollchild, "TOPLEFT", xOffset, yOffset)
				end
			else
				modOptFrame:SetPoint("TOPLEFT", DarkAngelopt.scrollchild, "TOPLEFT", xOffset, yOffset)
				xOffset = xOffset + modOptFrame:GetWidth() + spacing

				anchors[modName] = modOptFrame
			end
		end
	end
		
	
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
function DA:SetAllFrameCoords()
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

DA.guild_info_found=false
function DA.CheckEPGPGuildInfo()
	if IsInGuild() and GetGuildInfoText() and #GetGuildInfoText() and #GetGuildInfoText()>0 and GetGuildInfoText()~='' then
		if string.find(GetGuildInfoText(),"@BASE_GP:") and string.match(GetGuildInfoText(),"@BASE_GP:(%d+)") and tonumber(string.match(GetGuildInfoText(),"@BASE_GP:(%d+)")) then
			DA_Guild_Info[DA_CurrentGuild].base1=tonumber(string.match(GetGuildInfoText(),"@BASE_GP:(%d+)"))
		else 
			DA_Guild_Info[DA_CurrentGuild].base1=0
		end
		if string.find(GetGuildInfoText(),"@DECAY_P:") and string.match(GetGuildInfoText(),"@DECAY_P:(%d+)") and tonumber(string.match(GetGuildInfoText(),"@DECAY_P:(%d+)")) then
			DA_Guild_Info[DA_CurrentGuild].decay1=tonumber(string.match(GetGuildInfoText(),"@DECAY_P:(%d+)"))/100
		else 
			DA_Guild_Info[DA_CurrentGuild].decay1=false
		end
		if string.find(GetGuildInfoText(),"@EXTRAS_P:") and string.match(GetGuildInfoText(),"@EXTRAS_P:(%d+)") and tonumber(string.match(GetGuildInfoText(),"@EXTRAS_P:(%d+)")) then 
			DA_Guild_Info[DA_CurrentGuild].extra1=tonumber(string.match(GetGuildInfoText(),"@EXTRAS_P:(%d+)"))/100
		else
			DA_Guild_Info[DA_CurrentGuild].extra1=1
		end
		if string.find(GetGuildInfoText(),"@MIN_EP:") and string.match(GetGuildInfoText(),"@MIN_EP:(%d+)") and tonumber(string.match(GetGuildInfoText(),"@MIN_EP:(%d+)")) then 
			DA_Guild_Info[DA_CurrentGuild].minep1=tonumber(string.match(GetGuildInfoText(),"@MIN_EP:(%d+)"))
		else
			DA_Guild_Info[DA_CurrentGuild].minep1=0
		end
		
		DA.guild_info_found=true
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

local garbage_collector=CreateFrame("Frame")
function DA.Garbage_Collect()
	
	if not garbage_collector.r then
		garbage_collector.r=true
		garbage_collector:SetScript("OnUpdate", function(self,_)
			if collectgarbage("step",128) then 
				self:SetScript("OnUpdate", nil)
				self.r=nil
				return
			end
		end)
	end
end

DA.colorlighten_amount = 1.2
local function colorlighten(color)
    return {
        math.min(color[1] * DA.colorlighten_amount, 1),
        math.min(color[2] * DA.colorlighten_amount, 1),
        math.min(color[3] * DA.colorlighten_amount, 1),
        color[4]
    }
end
function DA.GetClassColor(clas)
	if clas == "DEATHKNIGHT" then
		return colorlighten({ 0.64, 0.10, 0.19, 1 })
	elseif clas == "PALADIN" then
		return colorlighten({ 0.80, 0.46, 0.61, 1 })
	elseif clas == "WARRIOR" then
		return colorlighten({ 0.69, 0.55, 0.39, 1 })
	elseif clas == "HUNTER" then
		return colorlighten({ 0.54, 0.67, 0.37, 1 })
	elseif clas == "ROGUE" then
		return colorlighten({ 0.83, 0.80, 0.34, 1 })
	elseif clas == "MAGE" then
		return colorlighten({ 0.34, 0.67, 0.79, 1 })
	elseif clas == "WARLOCK" then
		return colorlighten({ 0.48, 0.42, 0.64, 1 })
	elseif clas == "PRIEST" then
		return colorlighten({ 0.84, 0.84, 0.84, 1 })
	elseif clas == "DRUID" then
		return colorlighten({ 0.83, 0.41, 0.03, 1 })
	elseif clas == "SHAMAN" then
		return colorlighten({ 0.01, 0.37, 0.75, 1 })
	else
		return { 0.40, 0.40, 0.40, 1 }
	end
end
local function gethexcolor(color)
	local bzbz=""
	for bz=1,3 do
		local endcol=string.format("%x", tostring(color[bz]*255))
		if #endcol==1 then
			endcol="0"..endcol
		end
		bzbz=bzbz..endcol
	end
	return bzbz
end
function DA.GetClassColorCode(clas)
	return clas and "|cff"..gethexcolor(DA.GetClassColor(clas)) or ""
end

function DA.GetEPGPTimestamp()
local timearray = {}
  timearray.month = select(2, CalendarGetDate())
  timearray.day = select(3, CalendarGetDate())
  timearray.year = select(4, CalendarGetDate())
  timearray.hour = select(1, GetGameTime())
  timearray.min = select(2, GetGameTime())
  return time(timearray)
end
local function Create_Slash_Functions()
	SLASH_FRAMESTK1 = SLASH_FRAMESTK1 or "/fs"
	SlashCmdList.FRAMESTK = SlashCmdList.FRAMESTK or function() LoadAddOn("Blizzard_DebugTools");FrameStackTooltip_Toggle() end
	SLASH_DAtargetsearch1="/dasearch"
	SlashCmdList.DAtargetsearch = function(...) 
		DarkAngelGUI:Show()
		_G['DarkAngelGUI']['Detailsbtn']:Click('LeftButton',true)
		_G['DarkAngelGUI']['Detailsbtn']:Click('LeftButton',false)
		FFuckingSearch:SetText(...)
		DA.RunLogSearch(FFuckingSearch:GetText())
	 end
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





	-- SLASH_DALinkCopy1="/dalinkcopy"
	-- SlashCmdList.DALinkCopy = function(...) 
		-- print(...)
		-- StaticPopup_Show("DA_COPY_TEXT_POPUP", nil, nil, ...)
	-- end
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
		reason=tostring(reason)
		ammount=tonumber(ammount)
		
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
							DA.EPawardfunc(FEP_gMain[target],ammount,reason)
						else
							DA.Print('not enough EP. '..target..'['..FEP_gMain[target]..']'..' has '..ep..','..gp)
							return
						end
					else
						DA.EPawardfunc(FEP_gMain[target],ammount,reason)
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
					DA.EPawardfunc(FEP_L_gMain[DA_CurrentGuild][target],ammount,reason,nil,target,1)
				else
					DA.Print('not enough EP. '..target..'['..FEP_L_gMain[DA_CurrentGuild][target]..']'..' has '..ep..','..gp)
					return
				end
			else
				DA.EPawardfunc(FEP_L_gMain[DA_CurrentGuild][target],ammount,reason,nil,target,1)
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
		reason=tostring(reason)
		ammount=tonumber(ammount)
		
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
							DA.GPawardfunc(FEP_gMain[target],ammount,reason)
						else
							DA.Print('not enough GP. '..target..'['..FEP_gMain[target]..']'..' has '..ep..','..gp)
							return
						end
					else
						DA.GPawardfunc(FEP_gMain[target],ammount,reason)
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
					DA.GPawardfunc(FEP_L_gMain[DA_CurrentGuild][target],ammount,reason,nil,target,1)
				else
					DA.Print('not enough GP. '..target..'['..FEP_L_gMain[DA_CurrentGuild][target]..']'..' has '..ep..','..gp)
					return
				end
			else
				DA.GPawardfunc(FEP_L_gMain[DA_CurrentGuild][target],ammount,reason,nil,target,1)
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
	Dark_Angel_OnInit_completed=true
	if DA.modules.Logger then DA.Logger_rewrite_Gopt() end
	
	DA_Guild_Info[DA_CurrentGuild]=DA_Guild_Info[DA_CurrentGuild] or {}
	DA_Guild_Info[DA_CurrentGuild].RecentAwards = DA_Guild_Info[DA_CurrentGuild].RecentAwards or {}
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
		if (string.sub(link, 1, 9) == "dacommand") then
			local Box = ChatEdit_ChooseBoxForSend()

			Box:SetText("")

			if (not Box:IsShown()) then
				ChatEdit_ActivateChat(Box)
			else
				ChatEdit_UpdateHeader(Box)
			end

			Box:Insert(string.sub(link, 11))
			ChatEdit_ParseText(Box, 1)
		elseif (string.sub(link, 1, 6) == "dalink") then
			local id = string.sub(link, 8)
			local data = DA_LinkStorage[id]
			if data then
				StaticPopup_Show("DA_COPY_TEXT_POPUP", nil, nil, data)

			end
		else
			SetHyperlink(self, link, text, button, frame)
		end
	end

	
	SendAddonMessage("DA_RTq",'DA_RTq', "guild")
	

end

function DA.RegatherGuildNotes(scanning)
table.wipe(FEP_gMain)
table.wipe(FFG_gMain)
	if scanning then 
		local rr={}
		for k=1,DA.GetNumGMembers() do
			local name, rankName, rank, _, _, _, note, officernote, _, _, _, _, _, _, _, _ = GetGuildRosterInfo(k);
			if name then
				-- print(name,k)
				rr[name]={}
				if note then
					FFG_gMain[name]=note
					rr[name].n=note
					-- print("N=",note)
				end
				if officernote then
					FEP_gMain[name]=officernote
					rr[name].o=officernote
					-- print("N=",officernote)
				end
				if rank then
					FRG_gMain[name]=rank
					rr[name].r={rank,rankName}
					-- print("R=",rank,rankName)
				end
			end
		end
		return rr
	else
		for k=1,DA.GetNumGMembers() do
			local name, _, _, _, _, _, note, officernote, _, _, _, _, _, _, _, _ = GetGuildRosterInfo(k);
			if name then
				if note then
					FFG_gMain[name]=note
				end
				if officernote then
					FEP_gMain[name]=officernote
				end
			end
		end
	end
end

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


	--inviter processor
	DA.CreateTimer(nil,"proc_invite_timer",0,fuckingOptions_g[DA_CurrentGuild].InvTimerSpeedTimer,true,function(self)
		if DA.listinvite_bulk[1] then
			InviteUnit(DA.listinvite_bulk[1])
			table.remove(DA.listinvite_bulk,1)
		else
			self:SetScript("OnUpdate",nil)
			self.time=0
		end
	end) 
end


function DA.ConcatStr(inputTable,maxl,separator)
	local outputTable = {}
	local currentString = ""

	for _, str in ipairs(inputTable) do
		if #currentString + #str + 1 <= maxl then
			if currentString ~= "" then
				currentString = currentString .. separator
			end
			currentString = currentString .. str
		else
			table.insert(outputTable, currentString)
			currentString = str
		end
	end

	if currentString ~= "" then
		table.insert(outputTable, currentString)
	end

	return outputTable
end


function DA.ResetPositions()
DarkAngelGUI:SetSize(DarkAngelGUI.width, DarkAngelGUI.height)
DarkAngelGUI.Log.width  = DarkAngelGUI.width
DarkAngelGUI.Log.height = DarkAngelGUI.height
DarkAngelGUI.Details.width  = DarkAngelGUI.width
DarkAngelGUI.Details.height = DarkAngelGUI.height
DarkAngelGUI.Log:SetSize(DarkAngelGUI.width, DarkAngelGUI.height)
DarkAngelGUI.Details:SetSize(DarkAngelGUI.width, DarkAngelGUI.height)
	
	DarkAngelGUI:ClearAllPoints()
	DarkAngelGUI.Log:ClearAllPoints()
	DarkAngelGUI.Details:ClearAllPoints()
	
	if fuckingOptions.fguiposition and fuckingOptions.fguiposition[1] then
		DarkAngelGUI:SetPoint(fuckingOptions.fguiposition[1],fuckingOptions.fguiposition[2] or "UIParent",fuckingOptions.fguiposition[3] or "CENTER",fuckingOptions.fguiposition[4] or 0, fuckingOptions.fguiposition[5] or 0)
	else
		DarkAngelGUI:SetPoint("TOPLEFT",_G["UIParent"],"CENTER",0,0)
	end
	DarkAngelGUI.Log:SetAllPoints(_G["DarkAngelGUI"])
	DarkAngelGUI.Details:SetAllPoints(_G["DarkAngelGUI"]) 
	
	
end
function DA.ResetScrollBoxes()
	for _,j in pairs(DarkAngelGUI.scrollbexes) do
		_G[j]:ClearAllPoints()
		-- _G[j]:SetPoint("TOPLEFT", _G[j]:GetParent(),"TOPLEFT",5, -62)
		-- _G[j]:SetSize(DarkAngelGUI.width-10, DarkAngelGUI.height-70)
		_G[j]:SetPoint(unpack(_G[j].storedpoint))
		_G[j]:SetSize(unpack(_G[j].storedsize))
		_G[j].scrollchild:ClearAllPoints()
		_G[j].scrollchild:SetPoint("TOPLEFT", _G[j..'ScrollFrame'],"TOPLEFT")
		-- _G[j].scrollchild:SetSize(496, (30+((_G[j].getsomething or 10) * 15)) )
		
		_G[j].scrollbar:GetThumbTexture():SetAlpha(0.3)
		_G[j].scrollupbutton:SetAlpha(0.3)
		_G[j].scrolldownbutton:SetAlpha(0.3)
		local a=_G[j].scrollbar.storedval
			_G[j].scrollbar:SetValue(-1)
			_G[j].scrollbar:SetValue(a or 0)
		if _G[j]:IsVisible() then
			if _G[j].scrollbar:GetThumbTexture():IsVisible() then
				
				_G[j].scrollupbutton:Show()
				_G[j].scrolldownbutton:Show()
			else
				_G[j].scrollupbutton:Hide()
				_G[j].scrolldownbutton:Hide()
			end
		end
	end
	-- DarkAngelGUI:GetScript("OnDragStop")(DarkAngelGUI)
	-- DarkAngelGUI:StopMovingOrSizing()
end

function DA.IsInSameGuild(character)
	if FEP_gMain[character] then return true else return false end
end

function DA.Print(msg)
	print("[|cffed94edDarkAngel|cffffffff]: "..msg)
end


function DA.DeepCopy(source)
    local copy = {}
    for key, value in pairs(source) do
        if type(value) == "table" then
            copy[key] = DA.DeepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

function DA.GetPlayerGuildIndex(name)
	for k=1,DA.GetNumGMembers() do
		local m={GetGuildRosterInfo(k)}
		if m[1]==name then return k end
	end
end


function DA.stringToTable(str)
	return loadstring("return " .. str)()
end
function DA.serialize(tbl, indent)
	local str = ""
	local t = type(tbl)
	if t == "table" then
		str = str .. "{\n"
		for k, v in pairs(tbl) do
			str = str .. string.rep(" ", indent + 4) .. "[" .. DA.serialize(k, 0) .. "] = " .. DA.serialize(v, indent + 4) .. ",\n"
		end
		str = str .. string.rep(" ", indent) .. "}"
	elseif t == "number" or t == "boolean" then
		str = str .. tostring(tbl)
	elseif t == "string" then
		str = str .. string.format("%q", tbl)
	end
	return str
end
function DA.tableToString(tbl)
	return DA.serialize(tbl, 0)
end

local lastGuildUpdate = 0
function DA.GetNumGMembers()
    if (time() - lastGuildUpdate > 10) then
        GuildRoster()
        lastGuildUpdate = time()
    end

    local wasOfflineHidden = not GetGuildRosterShowOffline()
    if wasOfflineHidden then
        SetGuildRosterShowOffline(true)
    end
	
	local count = GetNumGuildMembers()
	
    if wasOfflineHidden then
        SetGuildRosterShowOffline(false)
    end

    return count
end


function DA.GetPlayerScanLink(text)
	return string.gsub(string.lower(text), string.lower(text), string.format("|cffFFEB3B|Hdacommand:%s %s|h[%s]|h|r", SLASH_DAtargetsearch1, text, text))
end
DA_LinkStorage = {}
DA_LinkIndex = 0
function DA.GetChatCopyLink(longString)
	DA_LinkIndex = DA_LinkIndex + 1
	local id = tostring(DA_LinkIndex)
	DA_LinkStorage[id] = longString
	return "|cffffff00|Hdalink:" .. id .. "|h<click to copy>|h|r"
end

local function Guild_determine(frombackup)
	local dkp=0
	local epgp=0
	
	if frombackup then
		table.wipe(UNP_gMain)
		for name,dat in pairs(DA_Unpacked.pl_data) do
			UNP_gMain[name]=dat.ofnote
			
			if string.match(dat.ofnote, "^%.?(%d+),(%d+)$") then
				epgp=epgp+1
			elseif string.match(dat.ofnote, "Ne?t?:(%d+)%sTo?t?:(%d+)") then
				dkp=dkp+1
			end
		end
	
	
	else
		for i=1,DA.GetNumGMembers() do
			local name, _, _, _, _, _, note, officernote, _, _, _ = GetGuildRosterInfo(i);
			if name and officernote then
				if string.match(officernote, "^%.?(%d+),(%d+)$") then
					epgp=epgp+1
				elseif string.match(officernote, "Ne?t?:(%d+)%sTo?t?:(%d+)") then
					dkp=dkp+1
				end
			end
		end
	end

	if (dkp==0 and epgp==0) then
		return 'no-type'
	elseif epgp>dkp then	
		return 'epgp'
	elseif dkp>epgp then
		return 'dkp'
	end
	
	
		
end
function DA.DetermineDKPorEPGPguild(frombackup)

	if DA_CurrentGuild=='n0-guild' then
		return 'epgp'
	end
	
	local gtype=Guild_determine(frombackup)
	
	if gtype=='no-type' then
		if not DA_Guild_Info[DA_CurrentGuild].GuildType then
			if not frombackup then DA.Print(L['addon_failed_recognize_gtype_set']) end
			return 'epgp'
		end
	elseif gtype=='epgp' then
		if not DA_Guild_Info[DA_CurrentGuild].GuildType then
			if not frombackup then DA.Print("|cff00ffffEPGP|r mode") end
		elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
			if not frombackup then DA.Print(L['addon_registered_gtype_change']) end
			if not frombackup then DA.Print("new: |cff00ffffEPGP|r mode") end
		end
		return 'epgp'
	elseif gtype=='dkp' then
		if not DA_Guild_Info[DA_CurrentGuild].GuildType then
			if not frombackup then DA.Print("|cffeb4bfaDKP|r mode") end
		elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
			if not frombackup then DA.Print(L['addon_registered_gtype_change']) end
			if not frombackup then DA.Print("new: |cffeb4bfaDKP|r mode") end
		end
		return 'dkp'
	end
	

end

function DA.DecodeNote(note, custom_gtype)
	if not note or note == "" or ({string.gsub(note,"%s","")})[1]=="" or note=="0,0" then
		return "m",0, 0
	else
		if custom_gtype and custom_gtype=='dkp' or DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
			local net, tot, hrs = string.match(note, "Ne?t?:(%-?%d+)%sTo?t?:(%-?%d+)%s?H?r?s?:?(%-?%d*)")
			if tonumber(net) and tonumber(tot) then
				return "m",tonumber(net), tonumber(tot), tonumber(hrs)
			else
				return "t", note
			end
		elseif custom_gtype and custom_gtype=='epgp' or DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
			local ep, gp = string.match(note, "^(%d+),(%d+)$")
			if tonumber(ep) and tonumber(gp) then
				return "m",tonumber(ep), tonumber(gp)
			else
				local ep, gp = string.match(note, "^[.](%d+),(%d+)$")
				if tonumber(ep) and tonumber(gp) then
					return 'f',tonumber(ep), tonumber(gp)
				else
					return "t", note
				end
			end
		end
	end
end




function DA.capitalizeFirstCharacter(inputString)
    if inputString and inputString ~= "" then
        local firstChar, restOfString = inputString:match("([%z\1-\127\194-\244][\128-\191]*)(.*)")
        if firstChar then
            if string.byte(firstChar) == 207 or string.byte(firstChar) == 208 then
                -- Cyrillic character range
                firstChar = firstChar:gsub("^%l", string.upper)
            else
                firstChar = firstChar:upper()
            end
            return firstChar .. restOfString
        else
            return ""
        end
    else
        return ""
    end
end


local GC_flag_IDs={
	guildchat_listen=1,
	guildchat_speak=2,
	officerchat_listen=3,
	officerchat_speak=4,
	promote=5,
	demote=6,
	invite_member=7,
	remove_member=8,
	set_motd=9,
	edit_public_note=10,
	view_officer_note=11,
	edit_officer_note=12,
	modify_guild_info=13,
	notexists=999,
	withdraw_repair=15,
	withdraw_gold=16,
	create_guild_event=17,
}
local GC_bank_flag_IDs={
	canView=1,
	canDeposit=2,
	canEditInfo=3,
}
function DA.Process_GMranking(db,selectedrank,bankslots,lock,anons)


	
	GuildControlSetRank(selectedrank)
	
	if selectedrank>1 then
		for rank,val in pairs(db[selectedrank]) do
			if rank~='name' and rank~='bankpermissions' and rank~='gwithraw' then
				GuildControlSetRankFlag(GC_flag_IDs[tostring(rank)],(not lock and val) or false)
			elseif rank=='gwithraw' then
				SetGuildBankWithdrawLimit((not lock and tonumber(db[selectedrank].gwithraw)) or 0)
			end
		end
		
		if bankslots and db[selectedrank].bankpermissions then
			for banktab=1,bankslots do
				for rank,val in pairs(db[selectedrank].bankpermissions[banktab]) do
					if rank=='stacksPerDay'then
						SetGuildBankTabWithdraw(banktab,((not lock and tonumber(val)) or 0))
					else
						SetGuildBankTabPermissions(banktab,GC_bank_flag_IDs[tostring(rank)],(not lock and val) or false)
					end
				end
			end
		end
	end
	
	GuildControlSaveRank(db[selectedrank].name)
	
	if anons then
		DA.Print('processing rank_ID['..selectedrank.."] \""..db[selectedrank].name.."\" guild+guildbank")
	end
	
end


local function ColorName(name2,clas)
	local clas=string.upper(clas)
	local color=DA.GetClassColor(clas)
	
	return "|cff"..gethexcolor(color)..name2.."|r"
end
local function spacesraidID(name,addonline,iszam)
	if not iszam then
		for i=1,GetNumRaidMembers() do
			local character, _, subgroup, _, _, _, _, online, _, _, _ = GetRaidRosterInfo(i)
			if character and string.lower(string.gsub(character,"\"",""))==string.lower(string.gsub(name,"\"",""))  then
				if online or addonline then
					return "["..subgroup.."]|cff00ffaa+|r"
				else
					return "["..subgroup.."] "
				end
			end
		end
	elseif string.find(DA_Standby[DA_CurrentGuild],name.."\n") then
		if addonline then
			return "[z]|cff00ffaa+|r"
		else
			return "[z] "
		end
	end
	
	if addonline then
		return "   |cff00ffaa+|r"
	else
		return "    "
	end
	
end

function DA.GetTwinsInfo(name,ofnote,iszamena)
	local main

	if DA.DecodeNote(ofnote)=='m' or DA.DecodeNote(ofnote)=='f' then
		main=name

	elseif DA.DecodeNote(ofnote)=='t' then
		main=ofnote

	else
		return
	end
	
	local found={}
	for i=1,DA.GetNumGMembers() do
		local character, rank, rankIndex, level, _, _, note, officernote, online, _, class, _, _, _, _, _ = GetGuildRosterInfo(i)
		
		if character==main or ( DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' and string.lower(main)==main and DA.capitalizeFirstCharacter(main)==character ) then
			if IsControlKeyDown() and not iszamena then
				if online then
					found.main={ColorName(character,class),note,online,ofn=officernote,onl='|cff1acc4donline',rank="|r[|cff0df2ff"..rankIndex.."|r]"..rank}
				else
					local y, m, d, h = GetGuildRosterLastOnline(i);
					if y==0 and m==0 and d==0 and h==0 then
						found.main={ColorName(character,class),note,online,ofn=officernote,onl='|cffffafaf<h',rank="|r[|cff0df2ff"..rankIndex.."|r]"..rank}
					else
						if y==0 then y=nil else h=nil end
						if m==0 then m=nil else h=nil end
						if d==0 then d=nil end
						if h==0 then h=nil end
						found.main={ColorName(character,class),note,online,ofn=officernote,onl=(((y and '|cffff0000'..y..'y') or "")..((m and '|cffff5555'..m..'m') or "")..((d and '|cffff8f8f'..d..'d') or "")..((h and '|cffffafaf'..h..'h') or "")),rank="|r[|cff0df2ff"..rankIndex.."|r]"..rank}
						
					
					end
				end
			else
				found.main={ColorName(character,class),note,online,ofn=officernote}
			end
		elseif officernote==main or ( DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' and ((string.lower(main)==main and DA.capitalizeFirstCharacter(main)==officernote ) or (string.lower(officernote)==officernote and DA.capitalizeFirstCharacter(officernote)==main ))) then
			
			if IsControlKeyDown() and not iszamena then
				if online then
					tinsert(found,{ColorName(character,class),note,online,onl='|cff1acc4donline',rank="|r[|cff0df2ff"..rankIndex.."|r]"..rank})
				else
					local y, m, d, h = GetGuildRosterLastOnline(i);
					if y==0 and m==0 and d==0 and h==0 then
						tinsert(found,{ColorName(character,class),note,online,onl='|cffffafaf<h',rank="|r[|cff0df2ff"..rankIndex.."|r]"..rank})
					else
						if y==0 then y=nil else h=nil end
						if m==0 then m=nil else h=nil end
						if d==0 then d=nil end
						if h==0 then h=nil end
						tinsert(found,{ColorName(character,class),note,online,onl=(((y and '|cffff0000'..y..'y') or "")..((m and '|cffff5555'..m..'m') or "")..((d and '|cffff8f8f'..d..'d') or "")..((h and '|cffffafaf'..h..'h') or "")),rank="|r[|cff0df2ff"..rankIndex.."|r]"..rank})
						
					end
				end
			else
				tinsert(found,{ColorName(character,class),note,online})
			end
		end
	end
	
	if (iszamena and fuckingOptions.assisterlocals) or not iszamena then
		for chelik,gmain in pairs(FEP_L_gMain[DA_CurrentGuild]) do
			if gmain==main then
				tinsert(found,{"|cff00ffff"..chelik.."|r","|cff00ffff_local|r",islocal=true})
			end
		end
	end
	

	local result=""
	if found.main then 
		local epgpdkpvalues=DA.GetOfficerNoteColored(found.main.ofn)
		
		if IsControlKeyDown() and not iszamena then
			result=(spacesraidID(string.sub(found.main[1],11,-3),found.main[3])..found.main[1].. string.rep(" ",16-#(string.sub(found.main[1],11,-3)):gsub('[\128-\191]', ''))..found.main[2]..
			string.rep(" ",30-#(found.main[2]:gsub('[\128-\191]', ''))).." "..found.main.onl..
			string.rep(" ",8-#(found.main.onl:gsub('|cff%w%w%w%w%w%w','')))..found.main.rank.."\n"..((epgpdkpvalues and ("       "..epgpdkpvalues.."\n") ) or "")) 
			
		else
			result=(spacesraidID(string.sub(found.main[1],11,-3),found.main[3])..found.main[1].. string.rep(" ",16-#(string.sub(found.main[1],11,-3)):gsub('[\128-\191]', ''))..found.main[2].."\n"..((epgpdkpvalues and ("       "..epgpdkpvalues.."\n") ) or "")) 
		end
	end
	
	if IsControlKeyDown() and not iszamena then
		for i=1,#found do
			if found[i].islocal then
				result=result..(spacesraidID(string.sub(found[i][1],11,-3),found[i][3])..found[i][1]..string.rep(" ",16-#(string.sub(found[i][1],11,-3)):gsub('[\128-\191]', ''))..found[i][2].."\n")
				
			else
				result=result..(spacesraidID(string.sub(found[i][1],11,-3),found[i][3])..found[i][1]..string.rep(" ",16-#(string.sub(found[i][1],11,-3)):gsub('[\128-\191]', ''))..found[i][2]..
				string.rep(" ",30-#(found[i][2]:gsub('[\128-\191]', ''))).." "..found[i].onl..
				string.rep(" ",8-#(found[i].onl:gsub('|cff%w%w%w%w%w%w','')))..found[i].rank.."\n")
			end
		end
	else
		for i=1,#found do
			result=result..(spacesraidID(string.sub(found[i][1],11,-3),found[i][3])..found[i][1].. string.rep(" ",16-#(string.sub(found[i][1],11,-3)):gsub('[\128-\191]', ''))..found[i][2].."\n")
		end
		if not iszamena then
			result=result.."|cff507375<"..L["Hold Ctrl to see more details"]..">"
		end
	end
	
	return result
end

function DA.GetColorName(name,numeric)
if not name then return 'nil' end
if name=="" or name:gsub("%s","")=="" then return "" end

if select(1,DA.DecodeNote(name))=='t' or numeric then else return name end
	
	local na2me=nil
	if DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' and string.lower(name)==name then
		na2me=DA.capitalizeFirstCharacter(name)
	end
	
	if FEP_gMain[na2me or name] then
		if DA.modules.Logger and DA_Leavers[DA_CurrentGuild][na2me or name] then
			return '|cffb27373'..name..'|r' --assigned to stored leavers
		else
			local typ=select(1,DA.DecodeNote(FEP_gMain[na2me or name]))
			
			if typ=='f' then
				return '|cff8888ff'..name..'|r'
			elseif typ=='t' then	
				return '|cffff88ff'..name..'|r'
			else	
				return '|cffffffff'..name..'|r'
			end
		end
	else
		local typ=select(1,DA.DecodeNote(name))
			
		if typ=='f' then
			return '|cff7366ee'..name..'|r' --frozen
		elseif typ=='m' then	
			return name
		else	
			return '|cff736666'..name..'|r' --not assigned +assigned to old leavers
		end
	end

end
function DA.GetColorUnpackedName(name,numeric, gtype)
if not name then return 'nil' end
if name=="" or name:gsub("%s","")=="" then return "" end

if select(1,DA.DecodeNote(name, gtype))=='t' or numeric then else return name end
	
	local na2me=nil
	if gtype=='dkp' and string.lower(name)==name then
		na2me=DA.capitalizeFirstCharacter(name)
	end
	
	if UNP_gMain[na2me or name] then
		local typ=select(1,DA.DecodeNote(UNP_gMain[na2me or name], gtype))
		
		if typ=='f' then
			return '|cff8888ff'..name..'|r'
		elseif typ=='t' then	
			return '|cffff88ff'..name..'|r'
		else	
			return '|cffffffff'..name..'|r'
		end
	else
		local typ=select(1,DA.DecodeNote(name, gtype))
			
		if typ=='f' then
			return '|cff7366ee'..name..'|r' --frozen
		elseif typ=='m' then	
			return name
		else	
			return '|cff736666'..name..'|r' --not assigned +assigned to old leavers
		end
	end

end




function DA.CreateFFGButton2(name,rel,point,heig,wid,settext,ntxt,fonttype,onclickscr,desrtag,Vjust,Hjust)
local f=nil
if _G[name] then f=_G[name] else 
	f = CreateFrame("Button", name, rel, "UIDarkAngelButtonTemplate4")
end
	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	f:SetText(settext)
	f:SetBackdropColor(1, 1, 1, 1)
	f:RegisterForClicks("LeftButtonUp","RightButtonUp")
	f:SetFrameLevel(rel:GetFrameLevel() + 1)
	f:SetNormalTexture(ntxt)
	-- f:SetPushedTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Blue")
	-- f:SetHighlightTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Down")
	if onclickscr then f:SetScript("OnClick", onclickscr) end
	f.fs=f:GetFontString()
	if fonttype then f.fs:SetFont(unpack(fonttype)) end
	if Vjust then f.fs:SetJustifyV(Vjust) end
	if Hjust then f.fs:SetJustifyH(Hjust) end
	if Vjust or Hjust then f.fs:SetAllPoints() end
	
	if desrtag and L['DESCr-'..desrtag] then
		f:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,L['DESCr-'..desrtag])
		end)
		
		f:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
		end)
	end
	
	f:Show()
return f
end
function DA.CreateFFGFont(name,rel,point,heig,wid,fonttype,text,textcol,Vjust,Hjust,not_show)
local f
	if _G[name] then 
		f=_G[name] 
	else 
		f = rel:CreateFontString(name, point, rel)
	end
	
	f:SetFont(unpack(fonttype))
	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	f:SetText(text)
	if textcol then f:SetTextColor(unpack(textcol)) end
	if Vjust then f:SetJustifyV(Vjust) end
	if Hjust then f:SetJustifyH(Hjust) end
	f:SetShadowOffset(0.8,0.5)
	-- _G[rel][name]=f
	if not not_show then f:Show() end
	return f
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
						local r, g, b = GetItemQualityColor(itemRarity)

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
							
						elseif DarkAngel and FEP_L_gMain[DA_CurrentGuild][player] and DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][player]])=='m' and (not FEz_isinthesameguild(player)) then
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
								if DarkAngel and UnitName('player')~=character and (not RR_isinthesameguild(character)) and FEP_L_gMain[DA_CurrentGuild][character] and DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][character]])=='m' then
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
									PR = (ceil(EP/GP*100) / 100)
									if EP >= RaidRoll_DB["MIN_EP"] then AboveThreshold = true end
									if RaidRoll_DB["debug"] == true then RR_Test(name .. ": EP=" .. EP .. " GP=" .. GP .. " PR=" .. PR) end
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
												SetGuildRosterShowOffline(true);
												
												character = officernote
												
												for j=1,GetNumGuildMembers() do
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
										
										
										PR = (ceil(EP/GP*100) / 100)
										
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


local blizzardPopupAnchors = {}
local function SaveAnchors(t, ...)
  for n=1,select('#', ...) do
    local frame = select(n, ...)
    for i=1,frame:GetNumPoints() do
      local point, relativeTo, relativePoint, x, y = frame:GetPoint(i)
      if point then
        table.insert(t, {frame, point, relativeTo, relativePoint, x, y })
      end
    end
  end
end
local function RestoreAnchors(t)
  for i=1,#t do
    local frame, point, relativeTo, relativePoint, x, y = unpack(t[i])
    frame:SetPoint(point, relativeTo, relativePoint, x, y)
  end
end
StaticPopupDialogs["EPGP_CONFIRM_MINUS_EP_CREDIT"] = {
 text = "Award -EP for player %s",
  button1 = ACCEPT,
  button2 = CANCEL,
  timeout = 0,
  whileDead = 1,
  maxLetters = 16,
  hideOnEscape = 1,
  hasEditBox = 1,
  hasItemFrame = 1,


  OnAccept = function(self)
               local link = self.itemFrame.link
               local ep = tonumber(self.editBox:GetText())
               -- EPGP:IncGPBy(self.name, link, gp)
			   DA_targetep(link,-ep,self.name)
             end,


  OnShow = function(self, data)
             if not blizzardPopupAnchors[self] then
               blizzardPopupAnchors[self] = {}
               SaveAnchors(blizzardPopupAnchors[self],
                           self.itemFrame, self.editBox, self.button1)
             end
				self.itemFrame:ClearAllPoints()
             self.itemFrame:SetPoint("RIGHT", -180, 30)
             self.editBox:SetPoint("RIGHT", -55, 0)

             self.editBox:SetText("")
             self.editBox:HighlightText()
           end,

  OnHide = function(self)
             -- Clear anchor points of frames that we modified, and revert them.
             self.itemFrame:ClearAllPoints()
             self.editBox:ClearAllPoints()
             self.button1:ClearAllPoints()

             RestoreAnchors(blizzardPopupAnchors[self])

             if ChatEdit_GetActiveWindow() then
               ChatEdit_FocusActiveWindow()
             end
             self.editBox:SetText("100")
           end,

  EditBoxOnEnterPressed = function(self)
                            self:GetParent().button1:Click()
                          end,

  EditBoxOnEscapePressed = function(self)
                             self:GetParent():Hide()
                           end
}



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

DA:RegisterComm("DA_vrq", 
	function(message, dtype, sender)
		if DA.IsInSameGuild(sender) or UnitInRaid(sender) then
			SendAddonMessage("DA_vans", GetAddOnMetadata("DarkAngel",'version').."_Sp_Rr(_c7f"..dtype.."_Rr)", "WHISPER", sender)
		end 
	end
)
DA:RegisterComm("DA_vans", 
	function(message, dtype, sender)
		if DA.IsInSameGuild(sender) or UnitInRaid(sender) then
			DA.Print("   v|cff00ffff"..message:gsub("_Sp"," "):gsub("_Rr","|r"):gsub("_c7f","|cff77aaff").." |cffffffff"..sender)
		end 
	end
)




---- Fun functions ----
---- Fun functions ----
---- Fun functions ----
	--49623      -- Shadowmourne
	-- 50182 --blood pendant of Lana'Tel
	-- 2675
	-- 19019 громовая ярость
	-- /run DA_fakeloot(49623,'Король-Лич','НикРЛа')
function DA_fakeloot(ItemId,target,looter)

if not ItemId then 
	DA.Print("Usage:")
	DA.Print("DA_fakeloot(ItemId,'looted from','looter') --looter is optional, by default, your name") 
	DA.Print("type 't' as ^looted from^ to grep your /target. You may also skip it as well, so mob name will be printed as \"Unknown\"")
	return
end

if not target then
	target="Unknown"
elseif target=='t' or target=="t" or target=='T' or target=="T" then
	target=UnitName("target")
end

if not looter then
	looter=UnitName("player")
end

local a="\a"
local lootName, _, _, ItemLvl = GetItemInfo(ItemId)

SendAddonMessage("RRL","Beta_2"..a..looter..a..target..a..ItemId..a..lootName..a..ItemLvl,"RAID")
end

--/run DA_CheckQuestsCompleted(12915,12956)
function DA_CheckQuestsCompleted(...)
	local a={...}
	local b={} 
	local x=CreateFrame("FRAME") 
		x:RegisterEvent("QUEST_QUERY_COMPLETE") 
		x:SetScript("OnEvent",function() 
	GetQuestsCompleted(b)
	for k=1,#a do if not b[a[k]] then DA.Print(a[k]..' - not completed') else DA.Print(a[k]..' - completed') end end
	x:UnregisterEvent("QUEST_QUERY_COMPLETE") 
	end) 
	QueryQuestsCompleted() 
end

local function GetHighestRankSpellID(spellName)
    local i = 1
    local spellID = nil
    while true do
        local name, _ = GetSpellName(i, BOOKTYPE_SPELL)
        if not name then break end
        if name == spellName then
            spellID = i
        end
        i = i + 1
    end
    return spellID
end
function DA_CheckActionBars()
    for bar = 1, 6 do
        for slot = 1, 12 do
            local actionType, id, _ = GetActionInfo((bar - 1) * 12 + slot)
            if actionType == "spell" and id then
                local spellName = GetSpellName(id, BOOKTYPE_SPELL)
                local highestRankSpellID = GetHighestRankSpellID(spellName)
                if id ~= highestRankSpellID then
                    DA.Print((GetSpellLink(spellName) or spellName).. " in slot " .. slot .. " on bar " .. bar .. " is not the highest rank.")
                end
            end
        end
    end
end

function DA_GetTvins_N(morethan,onlyprint)
local mains={}
	for i=1,DA.GetNumGMembers() do
		local name, _, _, _, _, _, _, officernote, _ = GetGuildRosterInfo(i);
		local typ=DA.DecodeNote(officernote)
		if typ=="m" or typ=="f" then
			if mains[name] then
				mains[name]=mains[name]+1
			else
				mains[name]=1
			end
		elseif typ=="t" then
			if mains[officernote] then
				mains[officernote]=mains[officernote]+1
			else
				mains[officernote]=1
			end
		end
	end
local sorted={}
for pl,numtvins in pairs(mains) do
	if morethan and numtvins>=morethan then
		if onlyprint then
			print(pl,numtvins)
		else
			sorted[pl]=numtvins
		end
	elseif not morethan and numtvins>=3 then
		if onlyprint then
			print(pl,numtvins)
		else
			sorted[pl]=numtvins
		end
	end
end
	if onlyprint then
	else
		FFTestFF=nil
		FFTestFF=sorted
	end
end

