
local DA=LibStub("AceAddon-3.0"):GetAddon("DarkAngel")
local L = LibStub("AceLocale-3.0"):GetLocale("DarkAngel")
local LGT=LibStub:GetLibrary('LibGroupTalents-1.0')

local Mod = DA:NewModule("Awarder")


local localsToShare={}
local locals_Bulk={}
function Mod:OnInitialize()

	DA_Awarder:SetScale(fuckingOptions.Awarderscale)
	
    DA_Snapshots=DA_Snapshots or {}
		
	--ready check
	DA.CreateTimer(nil,"ready_check",0,0.1,true,function(self)
		if DA_Awarder.readycheckfont and DA_Awarder.readycheckfont:IsShown() and tostring(DA_Awarder.readycheckfont.timer)~="0" then else return end
		
		DA_Awarder.readycheckfont:SetText(30+DA_Awarder.readycheckfont.timer-time())
		if DA_Awarder.readycheckfont.timer+30<=time() then
			DA_Awarder.readycheckfont.timer="0"
		end
	end)  
	
	--ready check decay
	DA.CreateTimer(nil,"ready_ch_decay",0,0.2,true,function(self)
		if DA_Awarder.readycheckfont and not DA_Awarder.readycheckfont:IsShown() and DA_Awarder.readycheckfont.decay<25 then else return end
		DA_Awarder.readycheckfont.decay=DA_Awarder.readycheckfont.decay+1
		
		if DA_Awarder.readycheckfont.decay>=25 then
			FFGSetRCState(nil,nil,1)
			self:SetScript("OnUpdate",nil)
		end
	end)  
	
	--autolocals share
	DA.CreateTimer(nil,"localsShare",0,0.2,true,function(self)
		if not locals_Bulk[1] then self:SetScript("OnUpdate",nil) return end
		
		for _,message in ipairs(locals_Bulk) do
			SendAddonMessage("DA_flcans", message , "guild")
		end
		table.wipe(locals_Bulk)
		self:SetScript("OnUpdate",nil)
	end) 
	
	--raid mover
	DA_PlayerMoverList={}
	local function alreadymoved(tbl)
		local name2=tbl[1]
		local grp2=tbl[2]
		for i=1,40 do
			local name,_,subgr= GetRaidRosterInfo(i)
			if name==name2 then
				if subgr==grp2 then
					return true
				else
					return false
				end
			end
		end
		return true
	end
	local function mover(tbl)
		local name2=tbl[1]
		local grp2=tbl[2]
		for i=1,40 do
			local name,_,_= GetRaidRosterInfo(i)
			if name==name2 then
				SetRaidSubgroup(i,grp2)
			end
		end
	end

	DA.CreateTimer(nil,"raid_mover",0,0.1,true,function(self)
		if UnitInRaid('player') and UnitIsRaidOfficer('player') then 
		else 
			table.wipe(DA_PlayerMoverList)
			self:SetScript("OnUpdate",nil)
			return 
		end
		
		while true do
			if DA_PlayerMoverList[1] and (not UnitInRaid(DA_PlayerMoverList[1][1]) or DA_PlayerMoverList[1].done or alreadymoved(DA_PlayerMoverList[1])) then
				table.remove(DA_PlayerMoverList,1)
			else
				break
			end
		end
		
		if DA_PlayerMoverList[1] then
			mover(DA_PlayerMoverList[1])
		else
			self:SetScript("OnUpdate",nil)
			return
		end
		
	end) 
	
	DA_StoredCheckboxes_remembered=DA_StoredCheckboxes_remembered or {
		default={
			bis={}
		},	
		icc={
			bis={}
		},
		ruby={
			bis={}
		},
	}
	
	for setname,settbl in pairs(DA_StoredCheckboxes) do
		if not DA_StoredCheckboxes_remembered[setname] then
			DA_StoredCheckboxes_remembered[setname]={}
		end
		for _,subset in pairs(settbl) do
			if subset.rl and subset.rl.saved and not DA_StoredCheckboxes_remembered[setname][subset[1]] then
				DA_StoredCheckboxes_remembered[setname][subset[1]]={}
			end
		end
	end
	
end

local fepgrupdframe=CreateFrame("Frame")
function Mod:OnEnable()
    -- self.Flasker_Load()
	if UISpecialFrames then 
		tinsert(UISpecialFrames, "DA_Awarder")
	end
	
	DA:ModuleLoaded("Awarder")
end

function Mod:OnGuildLoad()
		fepgrupdframe:RegisterEvent("RAID_ROSTER_UPDATE") 
		fepgrupdframe:RegisterEvent("PARTY_CONVERTED_TO_RAID")
		fepgrupdframe:RegisterEvent("PARTY_LEADER_CHANGED");
		fepgrupdframe:RegisterEvent("PARTY_MEMBERS_CHANGED");
		fepgrupdframe:SetScript("OnEvent", FEP_eventupd)
		
	if UnitInRaid('player') then 
		tinsert(DA_Fep_bulk,function()  end)
		tinsert(DA_Fep_bulk,function()  end)
		tinsert(DA_Fep_bulk,function()  end)
		tinsert(DA_Fep_bulk,function()  end)
		tinsert(DA_Fep_bulk,function()  end)
		tinsert(DA_Fep_bulk,function()  end)
		tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
		tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
	end
	
	
 
end

function Mod:PublishLocal(name)
	table.wipe(locals_Bulk)
	localsToShare[name] = true
	
	local chunk={}
	local FN = FEP_L_gMain[DA_CurrentGuild]
	
	for player,_ in pairs(localsToShare) do
		local main = FN[player]
		if main and FEP_gMain[main] and (DA.DecodeNote(FEP_gMain[main])=='m' or DA.DecodeNote(FEP_gMain[main])=='f') then
			tinsert(chunk,player.."@"..main)
		end
	end
	for _,message in ipairs(DA.ConcatStr(chunk,254,"_")) do
		tinsert(locals_Bulk, message)
	end
	DA.SetTimerTime('localsShare',30)
	DA.ResumeTimer('localsShare')
	
end


DA_Awarder=DA.FrameCreater(nil,UIParent,350,495,{"CENTER", UIParent, "CENTER", 0, 0},"Interface\\AddOns\\DarkAngel\\template\\fon_port2",1)
DA_Awarder:RegisterForDrag("LeftButton")
DA_Awarder:SetScript("OnDragStart", DA_Awarder.StartMoving)
DA_Awarder:SetScript("OnDragStop", function(self)

	self:StopMovingOrSizing(self)

	local point={DA_Awarder:GetPoint(1)}
	fuckingOptions.saved_guiPositions.DA_Awarder={point[1] or "TOPLEFT",point[3] or "CENTER",point[4] or 0,point[5] or 0}

end)

DA_Awarder.locker=DA.CreateFFGButton2(nil,DA_Awarder,{"CENTER",DA_Awarder,"TOPLEFT",40,-10},10,74,L["Lock raid"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "outline"},function(self)
	if self.fs:GetText()==L["Unlock raid"] then
		self.fs:SetText(L["Lock raid"])
		self:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp')
	elseif self.fs:GetText()==L["Lock raid"] then
		self.fs:SetText(L["Unlock raid"])
		self:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red.blp')
	end
end,"awardlocker")
DA_Awarder.locker.getstate=function()
	if DA_Awarder.locker.fs:GetText()==L["Unlock raid"] then
		return true
	elseif DA_Awarder.locker.fs:GetText()==L["Lock raid"] then
		return false
	end
end
DA_Awarder.locker.setstate=function(state)
	if state then
		DA_Awarder.locker.fs:SetText(L["Unlock raid"])
		DA_Awarder.locker:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red.blp')
	else
		DA_Awarder.locker.fs:SetText(L["Lock raid"])
		DA_Awarder.locker:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp')
	end
end
		
function DA_Awarder.OpenClose()
	if DA_Awarder:IsShown() then
		DA_Awarder:Hide()
		DA.Garbage_Collect()
	else
		DA_Awarder:Show()
		FEP_GatherRaid()
		FEP_ReNameRePushThings()
	end
end

DA_Awarder.autoopt=DA.FrameCreater(nil,DA_Awarder,250,160,{"BOTTOMLEFT", DA_Awarder, "BOTTOMRIGHT", 2, 0})
DA_Awarder.autoopt:RegisterForDrag("LeftButton")
DA_Awarder.autoopt:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
DA_Awarder.autoopt:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end) 

-- DA_Awarder.autoopt:SetFrameLevel(180)

DA.CloseButtonCreater(nil,DA_Awarder.autoopt,{"TOPRIGHT", DA_Awarder.autoopt, "TOPRIGHT", -2,-2},10,10,'x')
-- :SetFrameLevel(181)


DA_Awarder.autoopt.officerassign=DA.FrameCreater(nil,DA_Awarder.autoopt,70,(GuildControlGetNumRanks()+1)*11,{"BOTTOMLEFT", DA_Awarder.autoopt, "TOPLEFT", 0, 0},nil,nil,1)
DA.CloseButtonCreater(nil,DA_Awarder.autoopt.officerassign,{"TOPLEFT", DA_Awarder.autoopt.officerassign, "TOPRIGHT", 1,5},8,8,'x')
-- :SetFrameLevel(192)
DA_Awarder.autoopt.officerassign:SetScript("OnHide",function() DA.AWAutoOptions() end)
DA_Awarder.autoopt.officerassign.andhigher=DA.CheckBtnCreater(nil,DA_Awarder.autoopt.officerassign,{"CENTER", DA_Awarder.autoopt.officerassign, "BOTTOMLEFT", 5,5},12,12,L['and higher'],function(self) end)
DA_Awarder.autoopt.officerassign.andhigher.font:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
-- DA_Awarder.autoopt.officerassign.andhigher:SetFrameLevel(191)


for i=1,GuildControlGetNumRanks() do 
	DA_Awarder.autoopt.officerassign['rankbtn'..i]=DA.CreateFFGButton2(nil,DA_Awarder.autoopt.officerassign,{"TOPLEFT", DA_Awarder.autoopt.officerassign, "TOPLEFT", 1,10-11*i},10,68,GuildControlGetRankName(i),'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function() end,nil,nil,'left')
	-- DA_Awarder.autoopt.officerassign['rankbtn'..i]:SetFrameLevel(191)
end
		
-- DA_Awarder.autoopt.officerassign:SetFrameLevel(190)	
local DA_SelSet=false
local function OpenOfficerCriteriaAssignment(ID)

	for i=1,GuildControlGetNumRanks() do 
		if DA_Awarder.autoopt.officerassign['rankbtn'..i] then
			DA_Awarder.autoopt.officerassign['rankbtn'..i].fs:SetText(GuildControlGetRankName(i))
			DA_Awarder.autoopt.officerassign['rankbtn'..i]:SetScript("OnClick",function(self) 
				DA_StoredCheckboxes[DA_SelSet][ID].rl['officer']={i-1, (DA_Awarder.autoopt.officerassign.andhigher:GetChecked() or false)}
				DA_Awarder.autoopt.officerassign:Hide()
				DA.AWAutoOptions()		
				DA_Awarder.autoopt.skadaassign:Hide()				
			end)
			DA_Awarder.autoopt.officerassign['rankbtn'..i]:SetPoint("TOPLEFT", DA_Awarder.autoopt.officerassign, "TOPLEFT", 1,10-11*i)
		else
			DA_Awarder.autoopt.officerassign['rankbtn'..i]=DA.CreateFFGButton2(nil,DA_Awarder.autoopt.officerassign,{"TOPLEFT", DA_Awarder.autoopt.officerassign, "TOPLEFT", 1,10-11*i},10,68,GuildControlGetRankName(i),'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function(self) 
				DA_StoredCheckboxes[DA_SelSet][ID].rl['officer']={i-1, (DA_Awarder.autoopt.officerassign.andhigher:GetChecked() or false)}
				DA_Awarder.autoopt.officerassign:Hide()
				DA.AWAutoOptions()
			end,nil,nil,'left')
	
		end
		DA_Awarder.autoopt.officerassign['rankbtn'..i]:Show()
		DA_Awarder.autoopt.officerassign['rankbtn'..i].fs:SetTextColor(0.5,0.9,1,1)
		-- DA_Awarder.autoopt.officerassign['rankbtn'..i]:SetFrameLevel(191)	
		
	end
	local gcnr=GuildControlGetNumRanks()
	for i=1,20 do
		if i<=gcnr then
		else
			if DA_Awarder.autoopt.officerassign['rankbtn'..i] then
				DA_Awarder.autoopt.officerassign['rankbtn'..i]:Hide()
			end
		end
	end
	DA_Awarder.autoopt.officerassign:SetSize(70,(GuildControlGetNumRanks()+1)*11)
					

DA_Awarder.autoopt.officerassign:SetPoint("BOTTOMLEFT", DA_Awarder.autoopt['fr'..ID].group3['gr33'], "TOPRIGHT", 0, 0)
			DA_Awarder.autoopt.officerassign:Show()
end


DA_Awarder.autoopt.skadaassign=DA.FrameCreater(nil,DA_Awarder.autoopt,180,200,{"BOTTOMLEFT", DA_Awarder.autoopt, "TOPLEFT", 0, 0},nil,nil,1)
-- DA_Awarder.autoopt.skadaassign:SetFrameLevel(190)
DA_Awarder.autoopt.skadaassign.t:SetTexture(0.1, 0.1, 0.12, 0.75)
DA.CloseButtonCreater(nil,DA_Awarder.autoopt.skadaassign,{"TOPLEFT", DA_Awarder.autoopt.skadaassign, "TOPRIGHT", 1,5},10,10,'x')
-- :SetFrameLevel(200)
DA_Awarder.autoopt.skadaassign:SetScript("OnHide",function() DA.AWAutoOptions() end)


local skada_list_modes_total={
	dmg=true,
	dmg_dps=true,
	dmg_taken=true,
	healing=true,
	healing_hps=true,
	death=true,
	fails=true,
	dispells=true,
	cc_done=true,
	sunders=true
}
local skada_list_modes={
	{"damage done","dmg"},
	{"damage done (DPS)","dmg_dps"},
	{"damage done to enemy","dmg_specif"},
	{"damage taken","dmg_taken"},
	{"damage taken from mob","dmg_taken_mob"},
	{"damage taken from spell","dmg_taken_attack"},
	{"healing","healing"},
	{"healing (HPS)","healing_hps"},
	{"death","death"},
	{"fails","fails"},
	{"fails (specific)","fails_specif"},
	{"dispells","dispells"},
	{"dispells (specific)","dispells_specif"},
	{"crowd control","cc_done"},
	{"crowd control (specific)","cc_done_specif"},
	{"sunders","sunders"},
}
local skada_list_matematics={
	{"exists (any value)","any"},
	{"  in top X","intop"},
	{"  not in top X","notintop"},
	{"  >= X",">="},
	{"  > X",">"},
	{"  <= X","<="},
	{"  <= X or n/a","mx_or_na"},
	{"  < X","<"},
	{"  A < X < B","between"},
	{"  = X","equal"},
	{"  not = X","notequal"},
	{"0 or not exists","0_or_na"},
	{"not exists","na"},
}


local function getSkadadatabasenames()

	if SkadaCharDB and SkadaCharDB.sets and SkadaStorageDB and SkadaStorageDB.sets then
		return {'SkadaCharDB','SkadaStorageDB'}
	elseif SkadaCharDB and SkadaCharDB.sets and SkadaCharDB.sets then
		return {'SkadaCharDB'}
	elseif SkadaStorageDB and SkadaStorageDB.sets then
		return {'SkadaStorageDB'}
	elseif not SkadaCharDB then
		return {'Skada not found'}
	else
		return {'no Skada logs found'}
	end
end
local function skada_db_check_if_one()
	local scdbnames=getSkadadatabasenames()
	if #scdbnames==1 and scdbnames[1]=='SkadaCharDB' then
		DA_StoredCheckboxes[DA_SelSet].skadamode='SkadaCharDB'
	elseif	#scdbnames==1 and scdbnames[1]=='SkadaStorageDB' then
		DA_StoredCheckboxes[DA_SelSet].skadamode='SkadaStorageDB'
	end
end
local function skada_db_set()
	if DA_StoredCheckboxes[DA_SelSet].skadamode then
		DA_Awarder.autoopt.selectdb_BTN:SetText(DA_StoredCheckboxes[DA_SelSet].skadamode)
	else
		DA_Awarder.autoopt.selectdb_BTN:SetText("")
	end
end
local function resetAddboxes()
	DA_Awarder.boxesbtn:SetText(#DA_StoredCheckboxes[DA_SelSet])
	for _,bab in pairs({'3','4','5','6','7','8'}) do
		if DA_Awarder.boxesFrame[bab]:GetText()==tostring(#DA_StoredCheckboxes[DA_SelSet]) then
			DA_Awarder.boxesFrame[bab]:GetFontString():SetTextColor(0.2,1,1,1)
		else
			DA_Awarder.boxesFrame[bab]:GetFontString():SetTextColor(0.85,1,1,1)
		end
	end
end
local function getstorednames(x)
	local counter=0
	local pplslst=""
	if DA_StoredCheckboxes_remembered[DA_SelSet][DA_StoredCheckboxes[DA_SelSet][x][1]] and type(DA_StoredCheckboxes_remembered[DA_SelSet][DA_StoredCheckboxes[DA_SelSet][x][1]])=='table' then
		for ppl in pairs(DA_StoredCheckboxes_remembered[DA_SelSet][DA_StoredCheckboxes[DA_SelSet][x][1]]) do
			counter=counter+1
			if pplslst=="" then
				pplslst=ppl
			else
				pplslst=pplslst.."\n"..ppl
			end
		end
	end
	return counter,pplslst
end
local function readdRemCh()
	for setname,settbl in pairs(DA_StoredCheckboxes) do
		if not DA_StoredCheckboxes_remembered[setname] then
			DA_StoredCheckboxes_remembered[setname]={}
		end
		for _,subset in pairs(settbl) do
			if subset.rl and subset.rl.saved and not DA_StoredCheckboxes_remembered[setname][subset[1]] then
				DA_StoredCheckboxes_remembered[setname][subset[1]]={}
			end
		end
	end
end
local function customSort(a, b)
	if a == 'default' then
		return true
	elseif b == 'default' then
		return false
	else
		return a < b
	end
end
local function ReRenderNaborsList()
	local a = {}
	for n in pairs(DA_StoredCheckboxes) do table.insert(a, n) end
	table.sort(a,customSort)
	
	
	for naborplace=1,15 do
		local naborname=a[naborplace]
		if naborname then
			if DA_Awarder.naborFrame[naborplace] then
				DA_Awarder.naborFrame[naborplace]:SetText(naborname)
				DA_Awarder.naborFrame[naborplace]:SetScript("OnClick",function(self) 
					DA_Awarder.naborFrame:Hide()
					DA_SelSet=self:GetText()
					DA_Awarder.naborbtn:SetText(self:GetText())
					DA_Awarder.naboredit:SetText(self:GetText())
						if naborname=='default' then
							DA_Awarder.naboredit:Hide()
						else
							DA_Awarder.naboredit:Show()
						end
							FEP_RecalculateAllBtnEP();FEP_ResetAllChecks()
							resetAddboxes()
							readdRemCh()
					for i=1,9 do
						if DA_Awarder.naborFrame[i] and DA_Awarder.naborFrame[i]:IsShown() then
							if DA_Awarder.naborFrame[i]:GetText()==DA_SelSet then
								DA_Awarder.naborFrame[i]:GetFontString():SetTextColor(0.2,1,1,1)
							else
								DA_Awarder.naborFrame[i]:GetFontString():SetTextColor(0.85,1,1,1)
							end
						end
					end
					self:GetFontString():SetTextColor(0.2,1,1,1)
					FEP_ReNameRePushThings();FEP_ReNameRePushThings()			
				end)
				DA_Awarder.naborFrame[naborplace]:SetPoint("TOPLEFT", DA_Awarder.naborFrame, "TOPLEFT", 1,10-11*naborplace)
				DA_Awarder.naborFrame[naborplace]:Show()
				
				
				if naborname=='default' then
				else
					DA_Awarder.naborFrame[naborplace].deletebtn:SetScript("OnClick",function(self) 
						if DA_SelSet==naborname then
							DA_SelSet='default'
							DA_Awarder.naboredit:Hide()
						end
						DA_Awarder.naborFrame[naborplace].deletebtn:Hide()
						DA_Awarder.naborFrame[naborplace]:Hide()
						DA_StoredCheckboxes[naborname]=nil
						DA_StoredCheckboxes_remembered[naborname]=nil
						
						DA_Awarder.naborbtn:SetText(DA_SelSet)
						DA_Awarder.naboredit:SetText(DA_SelSet)
							FEP_RecalculateAllBtnEP();FEP_ResetAllChecks()
							resetAddboxes()
							readdRemCh()
						FEP_ReNameRePushThings()
						FEP_ReNameRePushThings()		
					end)
					DA_Awarder.naborFrame[naborplace].deletebtn:SetPoint("CENTER", DA_Awarder.naborFrame[naborplace], "CENTER", 44,0)
					DA_Awarder.naborFrame[naborplace].deletebtn:Show()
				end
			else
				DA_Awarder.naborFrame[naborplace]=DA.CreateFFGButton2(nil,DA_Awarder.naborFrame,{"TOPLEFT", DA_Awarder.naborFrame, "TOPLEFT", 1,10-11*naborplace},10,75,naborname,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self) 
					DA_Awarder.naborFrame:Hide()
					DA_SelSet=self:GetText()
					DA_Awarder.naborbtn:SetText(self:GetText())
					DA_Awarder.naboredit:SetText(self:GetText())
						if naborname=='default' then
							DA_Awarder.naboredit:Hide()
						else
							DA_Awarder.naboredit:Show()
						end
							FEP_RecalculateAllBtnEP();FEP_ResetAllChecks()
							resetAddboxes()
					
					for i=1,9 do
						if DA_Awarder.naborFrame[i] and DA_Awarder.naborFrame[i]:IsShown() then
							if DA_Awarder.naborFrame[i]:GetText()==DA_SelSet then
								DA_Awarder.naborFrame[i]:GetFontString():SetTextColor(0.2,1,1,1)
							else
								DA_Awarder.naborFrame[i]:GetFontString():SetTextColor(0.85,1,1,1)
							end
						end
					end
					self:GetFontString():SetTextColor(0.2,1,1,1)
					FEP_ReNameRePushThings();FEP_ReNameRePushThings()	
				end)
				
				if naborname=='default' then
				else
					DA_Awarder.naborFrame[naborplace].deletebtn=DA.ButtonCreater(nil,DA_Awarder.naborFrame,{"CENTER", DA_Awarder.naborFrame[naborplace], "CENTER", 44,0},10,10,'x','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',function(self) 
						if DA_SelSet==naborname then
							DA_SelSet='default'
							DA_Awarder.naboredit:Hide()
						end
						DA_Awarder.naborFrame[naborplace].deletebtn:Hide()
						DA_Awarder.naborFrame[naborplace]:Hide()
						DA_StoredCheckboxes[naborname]=nil
						DA_StoredCheckboxes_remembered[naborname]=nil
						
						DA_Awarder.naborbtn:SetText(DA_SelSet)
						DA_Awarder.naboredit:SetText(DA_SelSet)
							FEP_RecalculateAllBtnEP();FEP_ResetAllChecks()
							resetAddboxes()
								
						FEP_ReNameRePushThings()
						FEP_ReNameRePushThings()	
					end) 
					DA_Awarder.naborFrame[naborplace].deletebtn:GetFontString():SetTextColor(1,0.6,0.6,1)
				end
				
			end
			if naborname==DA_SelSet then
				DA_Awarder.naborFrame[naborplace]:GetFontString():SetTextColor(0.2,1,1,1)
			else
				DA_Awarder.naborFrame[naborplace]:GetFontString():SetTextColor(0.85,1,1,1)
			end
			DA_Awarder.naborFrame:SetSize(90,20+11*naborplace)
		elseif DA_Awarder.naborFrame[naborplace] then
			DA_Awarder.naborFrame[naborplace]:Hide()
			if DA_Awarder.naborFrame[naborplace].deletebtn then
				DA_Awarder.naborFrame[naborplace].deletebtn:Hide()
			end
		end
	end
	
	FEP_RecalculateAllBtnEP();FEP_ResetAllChecks()
	
	
end
local function countCHsets()
	local nc=0; 
	for _ in pairs(DA_StoredCheckboxes) do nc=nc+1 end
	return nc
end
local function alpha_on_CBs(hig)
	for group=1,8 do
		for player=1,5 do
			local frame=_G["DA_AwarderGroup"..group.."frame"..player]
			for r=1,8 do
				local cb=_G["DA_AwarderGroup"..group.."frame"..player.."CB"..r]
			
				if frame and frame.c and cb and cb:IsShown() then
					if hig and hig==r then
						cb:SetAlpha(1)
					elseif hig then
						cb:SetAlpha(0.4)
					else
						cb:SetAlpha(1)
					end
				end
			end
			
		end
	end
end
local function Trasher(cb)
	if cb:GetText()==cb.last then else
		for i,j in pairs(DA_StoredCheckboxes[DA_SelSet]) do
			if not cb:GetText() then
				DA.Print(L['cannot set nil criteria for #']..cb.internal)
				cb:SetText(cb.last or "cb"..tostring(math.random(500)))
				return 
			elseif j[1]==cb:GetText() then
				DA.Print(L["cannotset2"]:gsub('$1',cb:GetText()):gsub('$2',cb.internal):gsub('$3',i) , false)
				cb:SetText(cb.last or "cb"..tostring(math.random(500)))
				return 
			end
		end
		for pl,dat in pairs(DA_raid_marks) do
			if dat then
				for criteria,_ in pairs(dat) do
					if cb.last==criteria then
						DA_raid_marks[pl][cb:GetText()]=DA_raid_marks[pl][criteria]
						DA_raid_marks[pl][criteria]=nil
					end
				end
			end
		end
		DA_StoredCheckboxes[DA_SelSet][cb.internal][1]=(cb:GetText() or 'cb'..cb.internal)
		DA_StoredCheckboxes[DA_SelSet][cb.internal][2]=(_G["FEP_Awardfor"..cb.internal]:GetText() or 0 )
		cb.last=cb:GetText()
		FEP_ReNameRePushThings();FEP_ReNameRePushThings()
		return 
	end
		
end


local function skada_opt_refresh_bosses()
	
	if DA_StoredCheckboxes[DA_SelSet].skadamode and _G[DA_StoredCheckboxes[DA_SelSet].skadamode] then
		DA_Awarder.autoopt.skadaassign.bosses.nobosses:Hide()
	else
		DA_Awarder.autoopt.skadaassign.bosses.nobosses:Show()
		return
	end
	
	local foundSkada={}
	tinsert(foundSkada,{name='total',mobname='total'})
	for setID,DB in ipairs(_G[DA_StoredCheckboxes[DA_SelSet].skadamode].sets) do
		if DB.type=='raid' and DB.time>120 then
			tinsert(foundSkada,DB)
		end
	end
	
	local skadaframe_Scrolled=DA_Skada_bosses_scr.scrollchild
	
	
	for i=1,50 do 
		if foundSkada[i] and skadaframe_Scrolled[i] then
			skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE")
			
			skadaframe_Scrolled[i]:SetPoint("TOPLEFT", skadaframe_Scrolled, "TOPLEFT", 1,10-11*i)
			skadaframe_Scrolled[i].fs:SetText(foundSkada[i].name)
			skadaframe_Scrolled[i]:SetScript("OnClick",function(self)
				DA_Awarder.autoopt.skadaassign.main.selectedboss:SetText(foundSkada[i].mobname)
				DA_Awarder.autoopt.skadaassign.SKDTBL=foundSkada[i]
				if foundSkada[i].mobname=='total' and DA_Awarder.autoopt.skadaassign.selmode and not skada_list_modes_total[DA_Awarder.autoopt.skadaassign.selmode] then
					DA_Awarder.autoopt.skadaassign.selmode=nil
					DA_Awarder.autoopt.skadaassign.main.selectedmode:SetText('')
					DA_Awarder.autoopt.skadaassign.main.additbtn:Hide()
				end
				DA_Awarder.autoopt.skadaassign.bosses:Hide()
				DA_Awarder.autoopt.skadaassign.main:Show()
			
			end)
			
			if skadaframe_Scrolled[i].fs:GetStringWidth()>220 then
				skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 6.5, "OUTLINE")
			elseif skadaframe_Scrolled[i].fs:GetStringWidth()>200 then
				skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE")
			elseif skadaframe_Scrolled[i].fs:GetStringWidth()>180 then
				skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 7.5, "OUTLINE")
			elseif skadaframe_Scrolled[i].fs:GetStringWidth()>160 then
				skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE")
			elseif skadaframe_Scrolled[i].fs:GetStringWidth()>155 then
				skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 9.5, "OUTLINE")
			else
				skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE")
			end
			skadaframe_Scrolled[i]:Show()
		elseif foundSkada[i] then
			skadaframe_Scrolled[i]=DA.CreateFFGButton2(nil,skadaframe_Scrolled,{"TOPLEFT", skadaframe_Scrolled, "TOPLEFT", 1,10-11*i},10,150,foundSkada[i].name,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self) 
				DA_Awarder.autoopt.skadaassign.main.selectedboss:SetText(foundSkada[i].mobname)
				DA_Awarder.autoopt.skadaassign.SKDTBL=foundSkada[i]
				if foundSkada[i].mobname=='total' and DA_Awarder.autoopt.skadaassign.selmode and not skada_list_modes_total[DA_Awarder.autoopt.skadaassign.selmode] then
					DA_Awarder.autoopt.skadaassign.selmode=nil
					DA_Awarder.autoopt.skadaassign.main.selectedmode:SetText('')
					DA_Awarder.autoopt.skadaassign.main.additbtn:Hide()
				end
				DA_Awarder.autoopt.skadaassign.bosses:Hide()
				DA_Awarder.autoopt.skadaassign.main:Show()
			end,nil,nil,'left')
			if skadaframe_Scrolled[i].fs:GetStringWidth()>220 then
				skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 6.5, "OUTLINE")
			elseif skadaframe_Scrolled[i].fs:GetStringWidth()>200 then
				skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE")
			elseif skadaframe_Scrolled[i].fs:GetStringWidth()>180 then
				skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 7.5, "OUTLINE")
			elseif skadaframe_Scrolled[i].fs:GetStringWidth()>160 then
				skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE")
			elseif skadaframe_Scrolled[i].fs:GetStringWidth()>155 then
				skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 9.5, "OUTLINE")
			else
				skadaframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE")
			end
			
			skadaframe_Scrolled[i].fs:SetSize(230,15)
			-- skadaframe_Scrolled[i]:SetFrameLevel(195)
		elseif skadaframe_Scrolled[i] then
			skadaframe_Scrolled[i]:Hide()
		end
	end
end
local function skada_modes_preshow()
	local modesframe_Scrolled=DA_Skada_modes_scr.scrollchild
	
	if DA_Awarder.autoopt.skadaassign.main.selectedboss:GetText()=='total' then
		for i,j in pairs(skada_list_modes) do
			if skada_list_modes_total[j[2]] then
				modesframe_Scrolled[i]:Enable()
			else
				modesframe_Scrolled[i]:Disable()
			end
		end
	else
		for i,j in pairs(skada_list_modes) do
			modesframe_Scrolled[i]:Enable()
		end
	end
end
local function skada_opt_reset_modes()
	local mode=DA_Awarder.autoopt.skadaassign.selmode
	if mode and (mode=='dmg_specif' or 
	mode=='dmg_taken_mob' or 
	mode=='dmg_taken_attack' or 
	mode=='fails_specif' or 
	mode=='dispells_specif' or 
	mode=='cc_done_specif') then
		DA_Awarder.autoopt.skadaassign.main.additbtn:Show()
	else
		DA_Awarder.autoopt.skadaassign.main.additbtn:Hide()
	end
end
local function skada_db_version_check()
skada_db_check_if_one()
skada_db_set()
	if DA_StoredCheckboxes[DA_SelSet].skadamode and _G[DA_StoredCheckboxes[DA_SelSet].skadamode] then
		--_G[DA_StoredCheckboxes[DA_SelSet].skadamode] is Skada DB
		if next(_G[DA_StoredCheckboxes[DA_SelSet].skadamode].sets) then
			for i,j in ipairs(_G[DA_StoredCheckboxes[DA_SelSet].skadamode].sets) do
				if j then
					if j.enemies then
						DA_Awarder.autoopt.skadaassign.skada_version=1
					elseif j.power and j.players then
						for g,h in pairs(j.players) do
							if h.damagedone and h.damagedone.overkill and h.damagedone.spells and h.damagedone.targets then
								DA_Awarder.autoopt.skadaassign.skada_version=2
							end
						end
					end
					
				end
			end
		end
	else
		DA.Print('Skada DB not selected/not found')
	end
end
local function skada_addit_gather()
	if not DA_Awarder.autoopt.skadaassign.selmode then
		return {}
	elseif DA_Awarder.autoopt.skadaassign.main.selectedmode=="--" or DA_Awarder.autoopt.skadaassign.selmode=="--" then
		DA.Print('select checking mode')
		return nil
	elseif not DA_Awarder.autoopt.skadaassign.SKDTBL or not DA_Awarder.autoopt.skadaassign.main.selectedboss or DA_Awarder.autoopt.skadaassign.main.selectedboss=="--" then
		DA.Print('select boss first')
		return nil
	else
		skada_db_version_check()
		
		if DA_Awarder.autoopt.skadaassign.skada_version then
			if DA_Awarder.autoopt.skadaassign.skada_version==1 then
				if DA_Awarder.autoopt.skadaassign.selmode=='dmg_specif' or DA_Awarder.autoopt.skadaassign.selmode=='dmg_taken_mob' then
					local output={}
					for i,j in pairs(DA_Awarder.autoopt.skadaassign.SKDTBL.enemies) do
						if j and j.name then
							tinsert(output,j.name)
						end
					end
					return output
				elseif DA_Awarder.autoopt.skadaassign.selmode=='dmg_taken_attack' then
					local output={}
					for i,j in pairs(DA_Awarder.autoopt.skadaassign.SKDTBL.players) do
						if j.damagetakenspells then
							for spellname,_ in pairs(j.damagetakenspells) do
								if spellname and not output[spellname] then
									output[spellname]=true
								end
							end
						end
					end
					local secondoutput={}
					for name in pairs(output) do
						tinsert(secondoutput,name)
					end
					return secondoutput
				elseif DA_Awarder.autoopt.skadaassign.selmode=='fails_specif' then
					local output={}
					for i,j in pairs(DA_Awarder.autoopt.skadaassign.SKDTBL.players) do
						if j.failspells then
							for spellID,_ in pairs(j.failspells) do
								if spellID and not output[spellID] then
									output[spellID]=true
								end
							end
						end
					end
					local secondoutput={}
					for name in pairs(output) do
						tinsert(secondoutput,name)
					end
					return secondoutput
				elseif DA_Awarder.autoopt.skadaassign.selmode=='dispells_specif' then
					local output={}
					for i,j in pairs(DA_Awarder.autoopt.skadaassign.SKDTBL.players) do
						if j.dispelspells then
							for r,t in pairs(j.dispelspells) do
								if t and type(t)=='table' and t.spells then
									for spellID,_ in pairs(t.spells) do
										if spellID and not output[spellID] then
											output[spellID]=true
										end
									end
								end
							end
						end
					end
					local secondoutput={}
					for name in pairs(output) do
						tinsert(secondoutput,name)
					end
					return secondoutput
				
				elseif DA_Awarder.autoopt.skadaassign.selmode=='cc_done_specif' then
					local output={}
					for i,j in pairs(DA_Awarder.autoopt.skadaassign.SKDTBL.players) do
						if j.ccdonespells then
							for spellID,t in pairs(j.ccdonespells) do
								if spellID and t and type(t)=='table' and t.count and not output[spellID] then
									output[spellID]=true
								end
							end
						end
					end
					local secondoutput={}
					for name in pairs(output) do
						tinsert(secondoutput,name)
					end
					return secondoutput
				
					
				end
				
				
			elseif DA_Awarder.autoopt.skadaassign.skada_version==2 then
				
				print('Skada version ##: failed to determine Skada version. Report this bug')
				return {}
				
			end
		else
			DA.Print(L['failed to determine Skada version. Report this bug'])
		end
	end

end
local function skada_addit_render()
	local db=skada_addit_gather()
	local f_Scrolled=DA_Skada_addit_scr.scrollchild
	if db then
	
		for i=1,60 do
			if db[i] and f_Scrolled[i] then
				f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE")
				
				f_Scrolled[i]:SetPoint("TOPLEFT", f_Scrolled, "TOPLEFT", 1,10-11*i)
				if (DA_Awarder.autoopt.skadaassign.selmode=='fails_specif' or DA_Awarder.autoopt.skadaassign.selmode=='dispells_specif' or DA_Awarder.autoopt.skadaassign.selmode=='cc_done_specif') and tonumber(db[i]) and GetSpellLink(tonumber(db[i])) then
					local name, _, _, _, _, _ = GetSpellInfo(db[i])
					f_Scrolled[i].fs:SetText(name.." [ID:"..db[i].."]")
					f_Scrolled[i]:SetScript("OnEnter",function(self)
						GameTooltip:SetOwner(self,'ANCHOR_CURSOR')
						GameTooltip:SetHyperlink(GetSpellLink(tonumber(db[i])))
						GameTooltip:Show()
					end)
					f_Scrolled[i]:SetScript("OnLeave",function()
						GameTooltip:Hide()
					end)
				else
					f_Scrolled[i].fs:SetText(db[i])
					f_Scrolled[i]:SetScript("OnEnter",nil)
					f_Scrolled[i]:SetScript("OnLeave",nil)
				end
				
				f_Scrolled[i]:SetScript("OnClick",function(self)
					DA_Awarder.autoopt.skadaassign.main.addit_eb:SetText(db[i])
					DA_Awarder.autoopt.skadaassign.addit:Hide()
					DA_Awarder.autoopt.skadaassign.main:Show()
				end)

				if f_Scrolled[i].fs:GetStringWidth()>220 then
					f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 6.5, "OUTLINE")
				elseif f_Scrolled[i].fs:GetStringWidth()>200 then
					f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE")
				elseif f_Scrolled[i].fs:GetStringWidth()>180 then
					f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 7.5, "OUTLINE")
				elseif f_Scrolled[i].fs:GetStringWidth()>160 then
					f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE")
				elseif f_Scrolled[i].fs:GetStringWidth()>155 then
					f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 9.5, "OUTLINE")
				else
					f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE")
				end
				f_Scrolled[i]:Show()
			elseif db[i] then
				
				if (DA_Awarder.autoopt.skadaassign.selmode=='fails_specif' or DA_Awarder.autoopt.skadaassign.selmode=='dispells_specif' or DA_Awarder.autoopt.skadaassign.selmode=='cc_done_specif') and tonumber(db[i]) and GetSpellLink(tonumber(db[i])) then
					local name, _, _, _, _, _ = GetSpellInfo(db[i])
					f_Scrolled[i]=DA.CreateFFGButton2(nil,f_Scrolled,{"TOPLEFT", f_Scrolled, "TOPLEFT", 1,10-11*i},10,150,name.." [ID:"..db[i].."]",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self) 
						DA_Awarder.autoopt.skadaassign.main.addit_eb:SetText(db[i])
						DA_Awarder.autoopt.skadaassign.addit:Hide()
						DA_Awarder.autoopt.skadaassign.main:Show()
					end,nil,nil,'left')
					f_Scrolled[i]:SetScript("OnEnter",function(self)
						GameTooltip:SetOwner(self,'ANCHOR_CURSOR')
						GameTooltip:SetHyperlink(GetSpellLink(tonumber(db[i])))
						GameTooltip:Show()
					end)
					f_Scrolled[i]:SetScript("OnLeave",function()
						GameTooltip:Hide()
					end)
				else
					f_Scrolled[i]=DA.CreateFFGButton2(nil,f_Scrolled,{"TOPLEFT", f_Scrolled, "TOPLEFT", 1,10-11*i},10,150,db[i],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self) 
						DA_Awarder.autoopt.skadaassign.main.addit_eb:SetText(db[i])
						DA_Awarder.autoopt.skadaassign.addit:Hide()
						DA_Awarder.autoopt.skadaassign.main:Show()
					end,nil,nil,'left')
				end
				if f_Scrolled[i].fs:GetStringWidth()>220 then
					f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 6.5, "OUTLINE")
				elseif f_Scrolled[i].fs:GetStringWidth()>200 then
					f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE")
				elseif f_Scrolled[i].fs:GetStringWidth()>180 then
					f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 7.5, "OUTLINE")
				elseif f_Scrolled[i].fs:GetStringWidth()>160 then
					f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE")
				elseif f_Scrolled[i].fs:GetStringWidth()>155 then
					f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 9.5, "OUTLINE")
				else
					f_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE")
				end
				
				f_Scrolled[i].fs:SetSize(230,15)
				-- f_Scrolled[i]:SetFrameLevel(195)
			elseif f_Scrolled[i] then
				f_Scrolled[i]:Hide()
			end
		
		end
	
		DA_Awarder.autoopt.skadaassign.main:Hide()
		DA_Awarder.autoopt.skadaassign.addit:Show()
	
	else
		DA_Awarder.autoopt.skadaassign.addit:Hide()
		DA_Awarder.autoopt.skadaassign.main:Show()
	
	end

end

local function skada_isemptytbl(tbl)

	for a,tb in pairs(tbl) do
		if a and type(tb)=='boolean' and tb and (a=='tank' or a=='healer' or a=='melee' or a=='caster' or a=='WARRIOR' or a=='DEATHKNIGHT' or a=='PALADIN' or a=='PRIEST' or a=='SHAMAN' or a=='DRUID' or a=='ROGUE' or a=='MAGE' or a=='WARLOCK' or a=='HUNTER') then return false end
	end
	return true
end
local function skada_checkRole(tbl,spec,q,role,inputrole)
	for _, q in ipairs(inputrole) do
		if tbl.rl[q] and (spec and spec == q or (not spec and q == 'tank' and role)) then
			return true
		end
	end
	return false
end
local function skada_checkClass(tbl,CLASS,q,inputclass)
	for _, q in ipairs(inputclass) do
		if tbl.cl[q] and CLASS == q then
			return true
		end
	end
	return false
end
local function skada_resort_table(boss, input, criteria, addit)
	local ranking = {}

	for player, data in pairs(input) do
		if (addit and data[criteria] and data[criteria][addit]) then 
			table.insert(ranking, {[player]=true, data=data[criteria][addit]})
		elseif (not addit and data[criteria]) then
			table.insert(ranking, {[player]=true, data=data[criteria]})
		end
	end

	table.sort(ranking, function(a, b)
		return a.data > b.data
	end)
	
	local transformedTable = {}

	for position, entry in ipairs(ranking) do
		for key, value in pairs(entry) do
			if key ~= 'data' then
				transformedTable[key] = value and entry['data'] and position or nil
			end
		end
	end
	return transformedTable
end
local function skada_check_if_player_passed(input_tbl,input_tbl_sorted,name,boss,criteria,addit,matem)

	if matem.typ=='intop' or matem.typ=='notintop' then
		local place
		if addit then
			if input_tbl_sorted[boss] and input_tbl_sorted[boss][criteria] and input_tbl_sorted[boss][criteria][tostring(addit)] and input_tbl_sorted[boss][criteria][tostring(addit)][name] then
				place=input_tbl_sorted[boss][criteria][tostring(addit)][name]
			end
		elseif input_tbl_sorted[boss] and input_tbl_sorted[boss][criteria] and input_tbl_sorted[boss][criteria][name] then
			place=input_tbl_sorted[boss][criteria][name]
		end
		
		if place then
			if matem.typ=='intop' then 
				if place<=matem[1] then
					return true
				else
					return false
				end
			elseif matem.typ=='notintop' then
				if place>matem[1] then
					return true
				else
					return false
				end
			end
		else
			return false
		end
				
		
	else
		local value
		if addit and input_tbl[boss] and input_tbl[boss][name] and input_tbl[boss][name][criteria] and input_tbl[boss][name][criteria][tostring(addit)] then
			value=tonumber(input_tbl[boss][name][criteria][tostring(addit)])
		elseif not addit and input_tbl[boss] and input_tbl[boss][name] and input_tbl[boss][name][criteria] and input_tbl[boss][name][criteria] then
			value=tonumber(input_tbl[boss][name][criteria])
		end
		if matem.typ=='any' and value then
			return true
		elseif matem.typ=='>=' and value and value>=matem[1] then
			return true
		elseif matem.typ=='>' and value and value>matem[1] then
			return true
		elseif matem.typ=='<=' and value and value<=matem[1] then
			return true
		elseif matem.typ=='<' and value and value<matem[1] then
			return true
		elseif matem.typ=='between' and value and matem[1]<=value and value<=matem[2] then
			return true
		elseif matem.typ=='equal' and value and value==matem[1] then
			return true
		elseif matem.typ=='notequal' and value and value~=matem[1] then
			return true
		elseif matem.typ=='mx_or_na' and (not value or value<=matem[1]) then
			return true
		elseif matem.typ=='0_or_na' and (not value or value==0) then
			return true
		elseif matem.typ=='na' and not value then
			return true
		
		end
	end
end

local function getPricols()
	local str=''
	for i=1,#DA_StandbyFunList do
		if str=="" then 
			str=DA_StandbyFunList[i]
		else
			str=str..'\n'..DA_StandbyFunList[i]
		end
	end
	return str
end
local function packPricols(text)
	local rows = {}
	for row in text:gmatch("[^\r\n]+") do
		table.insert(rows, row)
	end
	return rows
end

local function re_render_saves()

local saves_Frame=DA_Awarder.getsavesFrame
local saves_Frame_Scrolled=DA_Saved_Raids.scrollchild

local saves_sorted=DA_Snapshots

local counter=0
for i=100,1,-1 do
	if saves_sorted[i] then
	counter=counter+1
		local f=DA.CreateFFGButton2("DA_RS_"..counter..'but',saves_Frame_Scrolled,{"TOPLEFT",saves_Frame_Scrolled,"TOPLEFT",0,10-(11*counter)},13,145,saves_sorted[i].stamp..((saves_sorted[i].isauto and "|cffaaffa0 A |r") or "|cffc490fc M |r")..saves_sorted[i].members.." |cff99aaaapl.|r",nil,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},
			function(self)
				saves_Frame:Hide()
				if not IsAltKeyDown() and not IsShiftKeyDown() and not IsControlKeyDown() then
					DA.LoadSnapshot(self.stored,'all')
				elseif not IsAltKeyDown() and IsShiftKeyDown() and not IsControlKeyDown() then
					DA.LoadSnapshot(self.stored,'raid')
				elseif not IsAltKeyDown() and not IsShiftKeyDown() and IsControlKeyDown() then
					DA.LoadSnapshot(self.stored,'marks')
				elseif IsAltKeyDown() and not IsShiftKeyDown() and not IsControlKeyDown() then
					if not saves_sorted[i].compLink then
						DA.Print("Raid composition is not stored for this old snapshot. Try to load and re-save it")
						return
					end
					DA.Print("Raid Comp Link: "..DA.GetChatCopyLink(saves_sorted[i].compLink))
					StaticPopup_Show("DA_COPY_TEXT_POPUP", nil, nil, saves_sorted[i].compLink)
				end
			end,
		nil,nil,'left')
		f.stored=i
		
		local cls=DA.CreateFFGButton2("DA_RS_"..counter..'cls',saves_Frame_Scrolled,{"LEFT",f,"RIGHT",-0.5,0},13,13,'x',nil,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},
			function(self)
				self:Hide()
				f:Hide()
				table.remove(DA_Snapshots,f.stored)
				re_render_saves()
				re_render_saves()
			end,
		nil,nil,'left')
		
		f:SetScript("OnEnter", function(self) cls:Show() end)
		f:SetScript("OnLeave", function(self) if not cls:IsMouseOver() then cls:Hide() end end)
		
		_G["DA_RS_"..counter..'cls']:SetHighlightTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red")
		_G["DA_RS_"..counter..'cls']:GetFontString():SetTextColor(1,0.65,0.65,0.65,1)
		_G["DA_RS_"..counter..'cls']:Hide()
		_G["DA_RS_"..counter..'cls']:SetScript("OnLeave", function(self) self:Hide() end)
		
		
	else
		if _G["DA_RS_"..i..'but'] then
			_G["DA_RS_"..i..'but']:Hide()
			_G["DA_RS_"..i..'cls']:Hide()
		end
	end
end

	DA_Saved_Raids:ClearAllPoints()
	DA_Saved_Raids:SetPoint("TOPLEFT", saves_Frame, "TOPLEFT", 0, -1)
		DA_Saved_Raids.scrollchild:ClearAllPoints()
		DA_Saved_Raids.scrollchild:SetPoint("TOPLEFT", DA_Saved_Raids, "TOPLEFT")
		
		if not DA_Saved_Raids.scrollbar:GetThumbTexture():IsShown() then
			DA_Saved_Raids.scrollbar:Hide()
		end
	
end


local re_highlight_difficulty


do 
---MAIN
---MAIN
	DA_Awarder.autoopt.skadaassign.main=CreateFrame('frame')
	DA_Awarder.autoopt.skadaassign.main:SetParent(DA_Awarder.autoopt.skadaassign)
	DA_Awarder.autoopt.skadaassign.main:SetFrameStrata('FULLSCREEN_DIALOG')
	DA_Awarder.autoopt.skadaassign.main:SetSize(DA_Awarder.autoopt.skadaassign.width,DA_Awarder.autoopt.skadaassign.height)
	DA_Awarder.autoopt.skadaassign.main:SetPoint('topleft',DA_Awarder.autoopt.skadaassign,'topleft')
	-- DA_Awarder.autoopt.skadaassign.main:SetFrameLevel(191)

	
	DA_Awarder.autoopt.skadaassign.main.bossesbtn=DA.ButtonCreater(nil,DA_Awarder.autoopt.skadaassign.main,{"CENTER",DA_Awarder.autoopt.skadaassign.main,"TOPLEFT",30,-30},12,40,'boss','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',
	function(self)
		DA_Awarder.autoopt.skadaassign.main:Hide()
		skada_opt_refresh_bosses()
		DA_Awarder.autoopt.skadaassign.bosses:Show()
	end,'center')
	-- DA_Awarder.autoopt.skadaassign.main.bossesbtn:SetFrameLevel(192)
	DA_Awarder.autoopt.skadaassign.main.selectedboss=DA.FontCreater(nil,'--',{"LEFT",DA_Awarder.autoopt.skadaassign.main.bossesbtn,"RIGHT",2,0},DA_Awarder.autoopt.skadaassign.main.bossesbtn,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})


	DA_Awarder.autoopt.skadaassign.main.modebtn=DA.ButtonCreater(nil,DA_Awarder.autoopt.skadaassign.main,{"CENTER",DA_Awarder.autoopt.skadaassign.main,"TOPLEFT",30,-50},12,40,'mode','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',
	function(self)
		DA_Awarder.autoopt.skadaassign.main:Hide()
		skada_modes_preshow()
		DA_Awarder.autoopt.skadaassign.modes:Show()
	end,'center')
	-- DA_Awarder.autoopt.skadaassign.main.modebtn:SetFrameLevel(192)
	DA_Awarder.autoopt.skadaassign.main.selectedmode=DA.FontCreater(nil,'--',{"LEFT",DA_Awarder.autoopt.skadaassign.main.modebtn,"RIGHT",2,0},DA_Awarder.autoopt.skadaassign.main.modebtn,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})

	DA_Awarder.autoopt.skadaassign.main.additbtn=DA.ButtonCreater(nil,DA_Awarder.autoopt.skadaassign.main,{"CENTER",DA_Awarder.autoopt.skadaassign.main,"TOPLEFT",30,-70},12,40,'select','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',
	function(self)
		skada_addit_render()
	end,'center')
	-- DA_Awarder.autoopt.skadaassign.main.additbtn:SetFrameLevel(192)
	DA_Awarder.autoopt.skadaassign.main.additbtn:Hide()
	
	DA_Awarder.autoopt.skadaassign.main.addit_eb=DA.EditBoxCreater(nil,DA_Awarder.autoopt.skadaassign.main.additbtn,{"LEFT",DA_Awarder.autoopt.skadaassign.main.additbtn,"RIGHT",2,0},{120,15},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 8},
		function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end,
		function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end, --enter here
		function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end,
		function(self) 	
			if self:GetParent():IsShown() then
				self.t:SetBlendMode('blend');
				self.focusgained=1
			end
		end
	)
	-- DA_Awarder.autoopt.skadaassign.main.addit_eb:SetFrameLevel(193)
	
	-- SAVE
	DA_Awarder.autoopt.skadaassign.main.savebtn=DA.ButtonCreater(nil,DA_Awarder.autoopt.skadaassign.main,{"CENTER",DA_Awarder.autoopt.skadaassign.main,"TOPLEFT",30,-180},12,45,'Save','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Green.blp',
	function(self)
		DA_Awarder.autoopt.skadaassign.main.addit_eb.focusgained=nil
		DA_Awarder.autoopt.skadaassign.main.addit_eb:ClearFocus()
		DA_Awarder.autoopt.skadaassign.main.operand_eb1.focusgained=nil
		DA_Awarder.autoopt.skadaassign.main.operand_eb1:ClearFocus()
		DA_Awarder.autoopt.skadaassign.main.operand_eb2.focusgained=nil
		DA_Awarder.autoopt.skadaassign.main.operand_eb2:ClearFocus()
		
		if DA_Awarder.autoopt.skadaassign.main.selectedboss:GetText()=='' or DA_Awarder.autoopt.skadaassign.main.selectedboss:GetText()=='--' then
			DA.Print('select boss first')
			return
		end
		if DA_Awarder.autoopt.skadaassign.selmode then
		else
			DA.Print('select checking mode')
			return
		end
		if not DA_Awarder.autoopt.skadaassign.main.additbtn:IsShown() or (DA_Awarder.autoopt.skadaassign.main.addit_eb:GetText() and DA_Awarder.autoopt.skadaassign.main.addit_eb:GetText()~="") then
		else
			DA.Print('select checking mode specifics')
			return
		end
		if DA_Awarder.autoopt.skadaassign.main.operand then
		else
			DA.Print('select math checking type')
			return
		end
		if DA_Awarder.autoopt.skadaassign.main.operand=='any' or DA_Awarder.autoopt.skadaassign.main.operand=='0_or_na' or DA_Awarder.autoopt.skadaassign.main.operand=='na' then
		
		elseif DA_Awarder.autoopt.skadaassign.main.operand_eb1:GetText() and DA_Awarder.autoopt.skadaassign.main.operand_eb1:GetText()~='' then
			if not tonumber(DA_Awarder.autoopt.skadaassign.main.operand_eb1:GetText()) then
				DA.Print('checking value is not a number')
				return
			end
		else
			DA.Print('specify checking value')
			return
		end
		if DA_Awarder.autoopt.skadaassign.main.operand~='between' or (DA_Awarder.autoopt.skadaassign.main.operand_eb2:GetText() and DA_Awarder.autoopt.skadaassign.main.operand_eb2:GetText()~='') then
			if DA_Awarder.autoopt.skadaassign.main.operand=='between' and not tonumber(DA_Awarder.autoopt.skadaassign.main.operand_eb2:GetText()) then
				DA.Print('checking value is not a number')
				return
			end
			if DA_Awarder.autoopt.skadaassign.main.operand=='between' and tonumber(DA_Awarder.autoopt.skadaassign.main.operand_eb1:GetText())==tonumber(DA_Awarder.autoopt.skadaassign.main.operand_eb2:GetText()) then
				DA.Print('values #1 and #2 are equal')
				return
			end
		else
			DA.Print('specify checking value #2')
			return
		end
		if DA_Awarder.autoopt.skadaassign.opened_criteriaID and DA_StoredCheckboxes[DA_SelSet][DA_Awarder.autoopt.skadaassign.opened_criteriaID] then
		else
			print('error 710')
		end
		
		local boss=DA_Awarder.autoopt.skadaassign.main.selectedboss:GetText()
		local mode=DA_Awarder.autoopt.skadaassign.selmode
		local addit
			if mode=='dmg' or 
			mode=='dmg_dps' or 
			mode=='dmg_taken' or 
			mode=='healing' or 
			mode=='healing_hps' or 
			mode=='death' or 
			mode=='fails' or 
			mode=='dispells' or 
			mode=='cc_done' or 
			mode=='sunders' then
			else
				addit=DA_Awarder.autoopt.skadaassign.main.addit_eb:GetText()
			end
		local matem
			if DA_Awarder.autoopt.skadaassign.main.operand=='between' then
				if tonumber(DA_Awarder.autoopt.skadaassign.main.operand_eb1:GetText())>tonumber(DA_Awarder.autoopt.skadaassign.main.operand_eb2:GetText()) then
					matem={typ='between',tonumber(DA_Awarder.autoopt.skadaassign.main.operand_eb2:GetText()),tonumber(DA_Awarder.autoopt.skadaassign.main.operand_eb1:GetText())}
				else
					matem={typ='between',tonumber(DA_Awarder.autoopt.skadaassign.main.operand_eb1:GetText()),tonumber(DA_Awarder.autoopt.skadaassign.main.operand_eb2:GetText())}
				end
			elseif DA_Awarder.autoopt.skadaassign.main.operand=='any' or
			DA_Awarder.autoopt.skadaassign.main.operand=='0_or_na' or
			DA_Awarder.autoopt.skadaassign.main.operand=='na' then
				matem={typ=DA_Awarder.autoopt.skadaassign.main.operand}
			else
				matem={typ=DA_Awarder.autoopt.skadaassign.main.operand,tonumber(DA_Awarder.autoopt.skadaassign.main.operand_eb1:GetText())}
			end
			if not matem then
				print('error 770')
				return
			end
		
		DA_StoredCheckboxes[DA_SelSet][DA_Awarder.autoopt.skadaassign.opened_criteriaID].rl['skada']=nil
		DA_StoredCheckboxes[DA_SelSet][DA_Awarder.autoopt.skadaassign.opened_criteriaID].rl['skada']={boss=boss,mode=mode,addit=addit or nil,matem=matem}
		DA_Awarder.autoopt.skadaassign.main.deletebtn:Enable()
		DA_Awarder.autoopt.skadaassign.main.deletebtn.fs:SetAlpha(1)
		DA.AWAutoOptions()
		
	end,'center')
	-- DA_Awarder.autoopt.skadaassign.main.savebtn:SetFrameLevel(192)
	
	--DELETE
	DA_Awarder.autoopt.skadaassign.main.deletebtn=DA.ButtonCreater(nil,DA_Awarder.autoopt.skadaassign.main,{"CENTER",DA_Awarder.autoopt.skadaassign.main,"TOPLEFT",80,-180},12,45,'Delete','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red.blp',
	function(self)
		if DA_Awarder.autoopt.skadaassign.opened_criteriaID and DA_StoredCheckboxes[DA_SelSet][DA_Awarder.autoopt.skadaassign.opened_criteriaID] then
			DA_Awarder.autoopt.skadaassign:Hide()
			DA_Awarder.autoopt.skadaassign.main.deletebtn:Disable()
			DA_Awarder.autoopt.skadaassign.main.deletebtn.fs:SetAlpha(0.5)
			DA_StoredCheckboxes[DA_SelSet][DA_Awarder.autoopt.skadaassign.opened_criteriaID].rl['skada']=nil
			DA_Awarder.autoopt.skadaassign.opened_criteriaID=nil
			DA.AWAutoOptions()
		end
	end,'center')
	-- DA_Awarder.autoopt.skadaassign.main.deletebtn:SetFrameLevel(192)
	DA_Awarder.autoopt.skadaassign.main.deletebtn:Disable()
	DA_Awarder.autoopt.skadaassign.main.deletebtn.fs:SetAlpha(0.5)
	
	--RESET
	DA_Awarder.autoopt.skadaassign.main.resetbtn=DA.ButtonCreater(nil,DA_Awarder.autoopt.skadaassign.main,{"CENTER",DA_Awarder.autoopt.skadaassign.main,"TOPLEFT",30,-160},12,45,'reset','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up.blp',
	function(self)
		DA_Awarder.autoopt.skadaassign.main.selectedboss:SetText('--')
		DA_Awarder.autoopt.skadaassign.selmode=nil
		DA_Awarder.autoopt.skadaassign.main.selectedmode:SetText('--')
		DA_Awarder.autoopt.skadaassign.main.additbtn:Hide()
		DA_Awarder.autoopt.skadaassign.main.addit_eb:SetText('')
		DA_Awarder.autoopt.skadaassign.main.operand_eb1:Hide()
		DA_Awarder.autoopt.skadaassign.main.operand_eb1:SetText('')
		DA_Awarder.autoopt.skadaassign.main.operand_eb2:Hide()
		DA_Awarder.autoopt.skadaassign.main.operand_eb2:SetText('')
		DA_Awarder.autoopt.skadaassign.main.operand=nil
		DA_Awarder.autoopt.skadaassign.main.operand_btn:SetText('')
		DA_Awarder.autoopt.skadaassign.SKDTBL=nil
	end,'center')
	-- DA_Awarder.autoopt.skadaassign.main.resetbtn:SetFrameLevel(192)
	
	do -- operand
		DA_Awarder.autoopt.skadaassign.main.operand_btn,DA_Awarder.autoopt.skadaassign.main.operand_FRM=DA.CreateFFGDropFrame(DA_Awarder.autoopt.skadaassign.main,skada_list_matematics[1][2],12,45,{"CENTER",DA_Awarder.autoopt.skadaassign.main,"TOPLEFT",30,-95},120,#skada_list_matematics*11 +1,"BOTTOMRIGHT")
		DA_Awarder.autoopt.skadaassign.main.operand=skada_list_matematics[1][2]
		
			for i,j in ipairs(skada_list_matematics) do
				
				DA_Awarder.autoopt.skadaassign.main.operand_FRM['scdb'..i]=DA.CreateFFGButton2(nil,DA_Awarder.autoopt.skadaassign.main.operand_FRM,{"TOPLEFT", DA_Awarder.autoopt.skadaassign.main.operand_FRM, "TOPLEFT", 1,10-11*i},10,118,j[1],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self) 
					
					DA_Awarder.autoopt.skadaassign.main.operand_FRM:Hide()
					DA_Awarder.autoopt.skadaassign.main.operand_btn:SetText(j[2])
					if j[2]=='any' or j[2]=='0_or_na' or j[2]=='na' then
						DA_Awarder.autoopt.skadaassign.main.operand_eb1:Hide()
						DA_Awarder.autoopt.skadaassign.main.operand_eb2:Hide()
					elseif j[2]=='between' then
						DA_Awarder.autoopt.skadaassign.main.operand_eb1:Show()
						DA_Awarder.autoopt.skadaassign.main.operand_eb2:Show()
					else
						DA_Awarder.autoopt.skadaassign.main.operand_eb1:Show()
						DA_Awarder.autoopt.skadaassign.main.operand_eb2:Hide()
					end
					DA_Awarder.autoopt.skadaassign.main.operand=j[2]
				end,nil,nil,'left')
				
			end
			
		-- DA_Awarder.autoopt.skadaassign.main.operand_btn:SetFrameLevel(192)
		-- DA_Awarder.autoopt.skadaassign.main.operand_FRM:SetFrameLevel(193)
		-- DA.FontCreater(nil,L['value'],{"RIGHT",DA_Awarder.autoopt.skadaassign.main.operand_btn,"LEFT",-4,0},DA_Awarder.autoopt.skadaassign.main.operand_btn,15,80,{UIDarkAngelFontConsolas:GetFont(), 8,'outline'},'right',{0.85,1,1,0.8})
	
		
		DA_Awarder.autoopt.skadaassign.main.operand_eb1=DA.EditBoxCreater(nil,DA_Awarder.autoopt.skadaassign.main,{"LEFT",DA_Awarder.autoopt.skadaassign.main,"TOPLEFT",60,-95},{40,15},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 9.5},
			function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end,
			function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end, --enter here
			function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end,
			function(self) 	
				if self:GetParent():IsShown() then
					self.t:SetBlendMode('blend');
					self.focusgained=1
				end
			end,
			nil,true
		)
		-- DA_Awarder.autoopt.skadaassign.main.operand_eb1:SetFrameLevel(193)
		DA_Awarder.autoopt.skadaassign.main.operand_eb1:Hide()
		
		DA_Awarder.autoopt.skadaassign.main.operand_eb2=DA.EditBoxCreater(nil,DA_Awarder.autoopt.skadaassign.main,{"LEFT",DA_Awarder.autoopt.skadaassign.main,"TOPLEFT",105,-95},{40,15},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 9.5},
			function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end,
			function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end, --enter here
			function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end,
			function(self) 	
				if self:GetParent():IsShown() then
					self.t:SetBlendMode('blend');
					self.focusgained=1
				end
			end,
			nil,true
		)
		-- DA_Awarder.autoopt.skadaassign.main.operand_eb2:SetFrameLevel(193)
		DA_Awarder.autoopt.skadaassign.main.operand_eb2:Hide()
		
		
	end
	
	

---ADDIT
---ADDIT
do
	DA_Awarder.autoopt.skadaassign.addit=CreateFrame('frame')
	DA_Awarder.autoopt.skadaassign.addit:SetParent(DA_Awarder.autoopt.skadaassign)
	DA_Awarder.autoopt.skadaassign.addit:SetFrameStrata('FULLSCREEN_DIALOG')
	DA_Awarder.autoopt.skadaassign.addit:SetSize(DA_Awarder.autoopt.skadaassign.width,DA_Awarder.autoopt.skadaassign.height)
	DA_Awarder.autoopt.skadaassign.addit:SetPoint('topleft',DA_Awarder.autoopt.skadaassign,'topleft')
	-- DA_Awarder.autoopt.skadaassign.addit:SetFrameLevel(191)
	DA_Awarder.autoopt.skadaassign.addit:Hide()
	
	DA_Awarder.autoopt.skadaassign.addit.back=DA.ButtonCreater(nil,DA_Awarder.autoopt.skadaassign.addit,{"CENTER",DA_Awarder.autoopt.skadaassign.addit,"TOPLEFT",30,-8},15,40,'back','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up.blp',
	function(self)
		DA_Awarder.autoopt.skadaassign.addit:Hide()
		DA_Awarder.autoopt.skadaassign.main:Show()
	end,'center')
	-- DA_Awarder.autoopt.skadaassign.addit.back:SetFrameLevel(192)
	
	DA.ScrollBarCreater("DA_Skada_addit_scr",DA_Awarder.autoopt.skadaassign.addit,{DA_Awarder.autoopt.skadaassign.width-5, DA_Awarder.autoopt.skadaassign.height-30},{"TOPLEFT", 5, -20},1)
	-- DA_Skada_addit_scr:SetFrameLevel(194)
end
---BOSSES
---BOSSES
do
	DA_Awarder.autoopt.skadaassign.bosses=CreateFrame('frame')
	DA_Awarder.autoopt.skadaassign.bosses:SetParent(DA_Awarder.autoopt.skadaassign)
	DA_Awarder.autoopt.skadaassign.bosses:SetFrameStrata('FULLSCREEN_DIALOG')
	DA_Awarder.autoopt.skadaassign.bosses:SetSize(DA_Awarder.autoopt.skadaassign.width,DA_Awarder.autoopt.skadaassign.height)
	DA_Awarder.autoopt.skadaassign.bosses:SetPoint('topleft',DA_Awarder.autoopt.skadaassign,'topleft')
	-- DA_Awarder.autoopt.skadaassign.bosses:SetFrameLevel(191)
	DA_Awarder.autoopt.skadaassign.bosses:Hide()

	DA_Awarder.autoopt.skadaassign.bosses.back=DA.ButtonCreater(nil,DA_Awarder.autoopt.skadaassign.bosses,{"CENTER",DA_Awarder.autoopt.skadaassign.bosses,"TOPLEFT",30,-8},15,40,'back','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up.blp',
	function(self)
		DA_Awarder.autoopt.skadaassign.bosses:Hide()
		DA_Awarder.autoopt.skadaassign.main:Show()
	end,'center')
	-- DA_Awarder.autoopt.skadaassign.bosses.back:SetFrameLevel(192)
	
	DA_Awarder.autoopt.skadaassign.bosses.refresh=DA.ButtonCreater(nil,DA_Awarder.autoopt.skadaassign.bosses,{"CENTER",DA_Awarder.autoopt.skadaassign.bosses,"TOPLEFT",80,-8},15,50,L['refresh'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up.blp',
	function(self)
		skada_opt_refresh_bosses()
	end,'center')
	-- DA_Awarder.autoopt.skadaassign.bosses.refresh:SetFrameLevel(192)

	

	DA_Awarder.autoopt.skadaassign.bosses.nobosses=DA.FontCreater(nil,L['Skada logs not found'],{"LEFT",DA_Awarder.autoopt.skadaassign.bosses,"TOPLEFT",10,-30},DA_Awarder.autoopt.skadaassign.bosses.back,15,110,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
	
	DA.ScrollBarCreater("DA_Skada_bosses_scr",DA_Awarder.autoopt.skadaassign.bosses,{DA_Awarder.autoopt.skadaassign.width-5, DA_Awarder.autoopt.skadaassign.height-30},{"TOPLEFT", 5, -20},1)
	-- DA_Skada_bosses_scr:SetFrameLevel(194)
end
---Modes
---Modes
do
	DA_Awarder.autoopt.skadaassign.modes=CreateFrame('frame')
	DA_Awarder.autoopt.skadaassign.modes:SetParent(DA_Awarder.autoopt.skadaassign)
	DA_Awarder.autoopt.skadaassign.modes:SetFrameStrata('FULLSCREEN_DIALOG')
	DA_Awarder.autoopt.skadaassign.modes:SetSize(DA_Awarder.autoopt.skadaassign.width,DA_Awarder.autoopt.skadaassign.height)
	DA_Awarder.autoopt.skadaassign.modes:SetPoint('topleft',DA_Awarder.autoopt.skadaassign,'topleft')
	-- DA_Awarder.autoopt.skadaassign.modes:SetFrameLevel(191)
	DA_Awarder.autoopt.skadaassign.modes:Hide()
	
	DA_Awarder.autoopt.skadaassign.modes.back=DA.CreateFFGButton2(nil,DA_Awarder.autoopt.skadaassign.modes,{"CENTER",DA_Awarder.autoopt.skadaassign.modes,"TOPLEFT",30,-8},15,40,'back','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self) 
		DA_Awarder.autoopt.skadaassign.modes:Hide()
		DA_Awarder.autoopt.skadaassign.main:Show()
	end,nil,nil,'center')
	-- DA_Awarder.autoopt.skadaassign.modes.back:SetFrameLevel(192)
	
	DA.ScrollBarCreater("DA_Skada_modes_scr",DA_Awarder.autoopt.skadaassign.modes,{DA_Awarder.autoopt.skadaassign.width-5, DA_Awarder.autoopt.skadaassign.height-30},{"TOPLEFT", 5, -20},1)
	-- DA_Skada_modes_scr:SetFrameLevel(194)
	
	local modesframe_Scrolled=DA_Skada_modes_scr.scrollchild
	
	for i,j in pairs(skada_list_modes) do
		modesframe_Scrolled[i]=DA.CreateFFGButton2(nil,modesframe_Scrolled,{"TOPLEFT", modesframe_Scrolled, "TOPLEFT", 1,10-11*i},10,150,j[1],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self) 
			DA_Awarder.autoopt.skadaassign.main.selectedmode:SetText(j[1])
			DA_Awarder.autoopt.skadaassign.selmode=j[2]
			DA_Awarder.autoopt.skadaassign.modes:Hide()
			DA_Awarder.autoopt.skadaassign.main:Show()
			
			skada_opt_reset_modes()
		end,nil,nil,'left')
		if modesframe_Scrolled[i].fs:GetStringWidth()>220 then
			modesframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 6.5, "OUTLINE")
		elseif modesframe_Scrolled[i].fs:GetStringWidth()>200 then
			modesframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE")
		elseif modesframe_Scrolled[i].fs:GetStringWidth()>180 then
			modesframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 7.5, "OUTLINE")
		elseif modesframe_Scrolled[i].fs:GetStringWidth()>160 then
			modesframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE")
		elseif modesframe_Scrolled[i].fs:GetStringWidth()>155 then
			modesframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 9.5, "OUTLINE")
		else
			modesframe_Scrolled[i].fs:SetFont(UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE")
		end
		
		modesframe_Scrolled[i].fs:SetSize(230,15)
		-- modesframe_Scrolled[i]:SetFrameLevel(195)
	
	end

	
	
end


end
local function OpenSkadaCriteriaAssignment(ID)
DA.AWAutoOptions()
DA_Awarder.autoopt.skadaassign:SetPoint("BOTTOMLEFT", DA_Awarder.autoopt['fr'..ID].group3['gr31'], "TOPRIGHT", 0, 0)
DA_Awarder.autoopt.skadaassign.opened_criteriaID=ID
	DA_Awarder.autoopt.skadaassign.bosses:Hide()
	DA_Awarder.autoopt.skadaassign.modes:Hide()
	DA_Awarder.autoopt.skadaassign.addit:Hide()
	DA_Awarder.autoopt.skadaassign.main.operand_FRM:Hide()
		DA_Awarder.autoopt.skadaassign:Show()
		DA_Awarder.autoopt.skadaassign.main:Show()
		
		skada_db_version_check()
		
		if DA_Awarder.autoopt.skadaassign.skada_version then
		else
			if _G[DA_StoredCheckboxes[DA_SelSet].skadamode].sets and not next(_G[DA_StoredCheckboxes[DA_SelSet].skadamode].sets) then
				DA.Print(L["no Scada logs were found. It would be not possible to set checking mode for specific bosses, only for total"])
			else
				DA.Print(L['failed to determine Skada version. Report this bug'])
			end
		end
		
		if DA_Awarder.autoopt.skadaassign.opened_criteriaID and DA_StoredCheckboxes[DA_SelSet][DA_Awarder.autoopt.skadaassign.opened_criteriaID] and DA_StoredCheckboxes[DA_SelSet][DA_Awarder.autoopt.skadaassign.opened_criteriaID].rl.skada and type(DA_StoredCheckboxes[DA_SelSet][DA_Awarder.autoopt.skadaassign.opened_criteriaID].rl.skada)=='table' then
			DA_Awarder.autoopt.skadaassign.main.deletebtn:Enable()
			DA_Awarder.autoopt.skadaassign.main.deletebtn.fs:SetAlpha(1)
		else
			DA_Awarder.autoopt.skadaassign.main.deletebtn:Disable()
			DA_Awarder.autoopt.skadaassign.main.deletebtn.fs:SetAlpha(0.5)
		end

	
end
local function LoadSkadaCriteriaAssignment(ID)
	local db=DA_StoredCheckboxes[DA_SelSet][ID].rl['skada']
	DA_Awarder.autoopt.skadaassign.main.selectedboss:SetText(db.boss)
	DA_Awarder.autoopt.skadaassign.selmode=db.mode
	for _,l in pairs(skada_list_modes) do
		if db.mode==l[2] then
			DA_Awarder.autoopt.skadaassign.main.selectedmode:SetText(l[1])
			break
		end
	end
	if db.addit then
		DA_Awarder.autoopt.skadaassign.main.additbtn:Show()
		DA_Awarder.autoopt.skadaassign.main.addit_eb:SetText(db.addit)
	else
		DA_Awarder.autoopt.skadaassign.main.additbtn:Hide()
		DA_Awarder.autoopt.skadaassign.main.addit_eb:SetText("")
	end
	
	for _,l in pairs(skada_list_matematics) do
		if db.matem.typ==l[2] then
			DA_Awarder.autoopt.skadaassign.main.operand=l[2]
			DA_Awarder.autoopt.skadaassign.main.operand_btn:SetText(l[2])
			if db.matem.typ=='any' or  db.matem.typ=='0_or_na' or  db.matem.typ=='na' then
				DA_Awarder.autoopt.skadaassign.main.operand_eb1:Hide()
				DA_Awarder.autoopt.skadaassign.main.operand_eb2:Hide()
			elseif db.matem.typ=='intop' or db.matem.typ=='notintop' or db.matem.typ=='>=' or db.matem.typ=='>' or db.matem.typ=='<=' or db.matem.typ=='mx_or_na' or db.matem.typ=='<' or db.matem.typ=='equal' or db.matem.typ=='notequal' then  
				DA_Awarder.autoopt.skadaassign.main.operand_eb2:Hide()
			end
			break
		end
	end
	if db.matem[1] then
		DA_Awarder.autoopt.skadaassign.main.operand_eb1:Show()
		DA_Awarder.autoopt.skadaassign.main.operand_eb1:SetText(db.matem[1])
	end
	if db.matem[2] then
		DA_Awarder.autoopt.skadaassign.main.operand_eb2:Show()
		DA_Awarder.autoopt.skadaassign.main.operand_eb2:SetText(db.matem[2])
	end

end

for i=1,8 do
	DA_Awarder.autoopt['fr'..i]=DA.FrameCreater(nil,DA_Awarder.autoopt,DA_Awarder.autoopt.width-5,12,{"LEFT", DA_Awarder.autoopt, "BOTTOMLEFT", 2.5, 111-13*i})
	-- DA_Awarder.autoopt['fr'..i]:SetFrameLevel(181)
	DA_Awarder.autoopt['fr'..i].t:SetTexture(0.69, 0.84, 0.87, 0.45)
		-- DA_Awarder.autoopt['fr'..i].setfont=DA.FontCreater(nil,'set_name',{"LEFT", DA_Awarder.autoopt['fr'..i], "LEFT", 0, 0},DA_Awarder.autoopt['fr'..i],15,80,{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},"left",{0.85,1,1,0.9})
		

		
		if i==1 then
			DA_Awarder.autoopt['fr'..i]['raid']=DA.IconicButtonCreater(nil,DA_Awarder.autoopt['fr'..i],{"CENTER", DA_Awarder.autoopt['fr'..i], "LEFT", 7, 0},12,"Interface\\Icons\\Spell_Magic_PolymorphRabbit",function(self)
				DA_StoredCheckboxes[DA_SelSet][i].rl['raid']=self.isenabled
			end,L['award for raid'])
			-- DA_Awarder.autoopt['fr'..i]['raid']:SetFrameLevel(182)
			DA_Awarder.autoopt['fr'..i]['raid'].switch(false)
		end
		
		DA_Awarder.autoopt['fr'..i].fonts=CreateFrame("Frame",nil,DA_Awarder.autoopt['fr'..i])
		-- DA_Awarder.autoopt['fr'..i].fonts:SetFrameLevel(190)
		
	do --grp 1
		DA_Awarder.autoopt['fr'..i].group1=DA.HideBarCreater('DA_Aw_AO'..i..'grp1',DA_Awarder.autoopt['fr'..i],{55,11},{"LEFT", DA_Awarder.autoopt['fr'..i], "LEFT", 16, 0})
		-- DA_Awarder.autoopt['fr'..i].group1:SetFrameLevel(182)
		
		
		DA_Awarder.autoopt['fr'..i].group1.rolefont=DA.FontCreater(nil,L['mark on role'],{'bottomleft',DA_Awarder.autoopt['fr'..i].group1,'topleft',5,-3},DA_Awarder.autoopt['fr'..i].fonts,15,150,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},"left",{0.75,0.85,0.85,0.8})
		
		for n,txt in ipairs({
		{"Interface\\Icons\\Spell_Holy_AvengersShield",L['tanking award'],'tank'},
		{"Interface\\Icons\\Spell_Holy_GuardianSpirit",L['healer award'],'healer'},
		{"Interface\\Icons\\Ability_Warrior_PunishingBlow",L['meelee dps award'],'melee'},
		{"Interface\\Icons\\Spell_Fire_FlameBolt",L['ranged dps award'],'caster'},
		{"Interface\\Icons\\Spell_Shadow_SoulGem",L['remmarkpl'],'saved'}
		}) do
			if n~=5 then
				DA_Awarder.autoopt['fr'..i].group1['gr1'..n]=DA.IconicButtonCreater(nil,DA_Awarder.autoopt['fr'..i].group1.scrollchild,{"CENTER", DA_Awarder.autoopt['fr'..i].group1.scrollchild, "LEFT", -6.5+11*n, 0},11,txt[1],function(self)
					DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]]=self.isenabled
				end,txt[2])
			else
				DA_Awarder.autoopt['fr'..i].group1['gr1'..n]=DA.IconicButtonCreater(nil,DA_Awarder.autoopt['fr'..i].group1.scrollchild,{"CENTER", DA_Awarder.autoopt['fr'..i].group1.scrollchild, "LEFT", -6.5+11*n, 0},11,txt[1],function(self)
					DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]]=self.isenabled
					for setname,settbl in pairs(DA_StoredCheckboxes) do
						if not DA_StoredCheckboxes_remembered[setname] then
							DA_StoredCheckboxes_remembered[setname]={}
						end
						for _,subset in pairs(settbl) do
							if subset.rl and subset.rl.saved and not DA_StoredCheckboxes_remembered[setname][subset[1]] then
								DA_StoredCheckboxes_remembered[setname][subset[1]]={}
							end
						end
					end
				end,nil,function() if not IsShiftKeyDown() and IsAltKeyDown() then DA_StoredCheckboxes_remembered[DA_SelSet][DA_StoredCheckboxes[DA_SelSet][i][1]]=nil;DA_StoredCheckboxes_remembered[DA_SelSet][DA_StoredCheckboxes[DA_SelSet][i][1]]={} return true end end)
				DA_Awarder.autoopt['fr'..i].group1['gr1'..n]:SetScript("OnEnter", function(self)
					self:RegisterEvent('MODIFIER_STATE_CHANGED')
					local ppls,list=getstorednames(i)
					if IsAltKeyDown() and not IsShiftKeyDown() and GetMouseFocus():GetName()==self:GetName() and ppls>0 then
						-- self.pressed=true
						DA.myShowTooltip(self,txt[2].."\n\n|cff6df7bb"..L['players saved'].." |cff6ee3fa"..ppls.."\n|cff447882"..L['hold Shift to see names'].."\n|cfffc3562"..L['alt-click to DELETE all saved characters'],1,{UIDarkAngelFontConsolas:GetFont(), 10})
					elseif IsShiftKeyDown() and GetMouseFocus():GetName()==self:GetName() and ppls>0 then
						-- self.pressed=true
						DA.myShowTooltip(self,txt[2].."\n\n|cff6df7bb".."|cff6df7bb"..L['players saved'].." |cff6ee3fa"..ppls.." |cff6df7bb:\n|cff62ddf5"..list,1,{UIDarkAngelFontConsolas:GetFont(), 10})
					elseif not IsShiftKeyDown() and GetMouseFocus():GetName()==self:GetName() and ppls>0 then
						-- self.pressed=true
						DA.myShowTooltip(self,txt[2].."\n\n|cff6df7bb"..L['players saved'].." |cff6ee3fa"..ppls.."\n|cff447882"..L['hold Shift to see names'].."\n|cff824452"..L['alt-click to DELETE all saved characters'],1,{UIDarkAngelFontConsolas:GetFont(), 10})
					elseif GetMouseFocus():GetName()==self:GetName() and ppls==0 then
						-- self.pressed=true
						DA.myShowTooltip(self,txt[2].."\n\n|cffeef564 "..L['no people saved'],1,{UIDarkAngelFontConsolas:GetFont(), 10})
					end
				end)
				
				DA_Awarder.autoopt['fr'..i].group1['gr1'..n]:SetScript("OnEvent", function(self)
					if self:IsVisible() and self:IsMouseOver() and GetMouseFocus():GetName()==self:GetName() then
						self:GetScript('OnEnter')(GetMouseFocus())
					end
				end)
				DA_Awarder.autoopt['fr'..i].group1['gr1'..n]:SetScript("OnLeave", function(self)
					self:UnregisterEvent('MODIFIER_STATE_CHANGED')
					-- DA_Awarder.autoopt['fr'..i].group1['gr1'..n].pressed=false
					DA.myHideTooltip()
				end)
			end
			
			
			-- DA_Awarder.autoopt['fr'..i].group1['gr1'..n]:SetFrameLevel(183)
			DA_Awarder.autoopt['fr'..i].group1['gr1'..n].switch(false)
			DA_Awarder.autoopt['fr'..i].group1['gr1'..n]:HookScript("OnEnter",function()
				DA_Awarder.autoopt['fr'..i].group1.onenter()
			end)
			DA_Awarder.autoopt['fr'..i].group1['gr1'..n]:HookScript("OnLeave",function()
				DA_Awarder.autoopt['fr'..i].group1.onleave()
			end)
		end
		DA_Awarder.autoopt['fr'..i].group1:SetScript("OnEnter",function()
			DA_Awarder.autoopt['fr'..i].group1.onenter()
		end)
		DA_Awarder.autoopt['fr'..i].group1:SetScript("OnLeave",function()
			DA_Awarder.autoopt['fr'..i].group1.onleave()
		end)
		DA_Awarder.autoopt['fr'..i].group1.onenter=function()
			for b=1,5 do
				DA_Awarder.autoopt['fr'..i].group1['gr1'..b]:SetPoint("CENTER", DA_Awarder.autoopt['fr'..i].group1.scrollchild, "LEFT", -6.5+11*b, 0)
				DA_Awarder.autoopt['fr'..i].group1['gr1'..b]:Show()
			end
			DA_Awarder.autoopt['fr'..i].group1.rolefont:Show()
			DA_Awarder.autoopt['fr'..i].group1:SetSize(55,11)
		end
		DA_Awarder.autoopt['fr'..i].group1.onleave=function()
			if not DA_Awarder.autoopt['fr'..i].group1:IsMouseOver() then
				local countbunnies=0
				for k=1,5 do
					if DA_Awarder.autoopt['fr'..i].group1['gr1'..k].isenabled then
						countbunnies=countbunnies+1
						DA_Awarder.autoopt['fr'..i].group1['gr1'..k]:SetPoint("CENTER", DA_Awarder.autoopt['fr'..i].group1.scrollchild, "LEFT", -6.5+11*countbunnies, 0)
						DA_Awarder.autoopt['fr'..i].group1['gr1'..k]:Show()
					else
						DA_Awarder.autoopt['fr'..i].group1['gr1'..k]:Hide()
					end
				end
				if countbunnies==0 then
					DA_Awarder.autoopt['fr'..i].group1:SetSize(11,11)
					DA_Awarder.autoopt['fr'..i].group1['gr11']:SetPoint("CENTER", DA_Awarder.autoopt['fr'..i].group1.scrollchild, "LEFT", -6.5+11, 0)
					DA_Awarder.autoopt['fr'..i].group1['gr11']:Show()
				else
					DA_Awarder.autoopt['fr'..i].group1:SetSize(11*countbunnies,11)
				end
				DA_Awarder.autoopt['fr'..i].group1.rolefont:Hide()
			end
		end
	
	end
	
	do --grp 2
		DA_Awarder.autoopt['fr'..i].group2=DA.HideBarCreater('DA_Aw_AO'..i..'grp2',DA_Awarder.autoopt['fr'..i],{150,11},{"LEFT", DA_Awarder.autoopt['fr'..i].group1, "RIGHT", 5, 0})
		-- DA_Awarder.autoopt['fr'..i].group2:SetFrameLevel(182)
		
		DA_Awarder.autoopt['fr'..i].group2.classfont=DA.FontCreater(nil,L['mark on class'],{'bottomleft',DA_Awarder.autoopt['fr'..i].group2,'topleft',5,-3},DA_Awarder.autoopt['fr'..i].fonts,15,150,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},"left",{0.75,0.85,0.85,0.8})

		local ut="Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES"
		for n,txt in ipairs({
		{"Interface\\Icons\\Spell_ChargePositive",L['remmandcl'],'andcl'},
		{ut,"WARRIOR"},
		{ut,"DEATHKNIGHT"},
		{ut,"PALADIN"},
		{ut,"PRIEST"},
		{ut,"SHAMAN"},
		{ut,"DRUID"},
		{ut,"ROGUE"},
		{ut,"MAGE"},
		{ut,"WARLOCK"},
		{ut,"HUNTER"}
		}) do
			if n==1 then
				DA_Awarder.autoopt['fr'..i].group2['gr2'..n]=DA.IconicButtonCreater(nil,DA_Awarder.autoopt['fr'..i].group2.scrollchild,{"CENTER", DA_Awarder.autoopt['fr'..i].group2.scrollchild, "LEFT", -6.5+11*n, 0},9,"Interface\\Icons\\Spell_ChargePositive",function(self)
					DA_StoredCheckboxes[DA_SelSet][i][txt[3]]=self.isenabled
				end,txt[2])
			else
				DA_Awarder.autoopt['fr'..i].group2['gr2'..n]=DA.IconicButtonCreater(nil,DA_Awarder.autoopt['fr'..i].group2.scrollchild,{"CENTER", DA_Awarder.autoopt['fr'..i].group2.scrollchild, "LEFT", -6.5+11*n, 0},11,txt[1],function(self)
					DA_StoredCheckboxes[DA_SelSet][i].cl[txt[2]]=self.isenabled
				end,LOCALIZED_CLASS_NAMES_MALE[txt[2]])
				DA_Awarder.autoopt['fr'..i].group2['gr2'..n]:GetNormalTexture():SetTexCoord(unpack(CLASS_ICON_TCOORDS[txt[2]]))
			end
			-- DA_Awarder.autoopt['fr'..i].group2['gr2'..n]:SetFrameLevel(183)
			DA_Awarder.autoopt['fr'..i].group2['gr2'..n].switch(false)
			DA_Awarder.autoopt['fr'..i].group2['gr2'..n]:HookScript("OnEnter",function()
				DA_Awarder.autoopt['fr'..i].group2.onenter()
			end)
			DA_Awarder.autoopt['fr'..i].group2['gr2'..n]:HookScript("OnLeave",function()
				DA_Awarder.autoopt['fr'..i].group2.onleave()
			end)
			
		end
		DA_Awarder.autoopt['fr'..i].group2:SetScript("OnEnter",function()
			DA_Awarder.autoopt['fr'..i].group2.onenter()
		end)
		DA_Awarder.autoopt['fr'..i].group2:SetScript("OnLeave",function()
			DA_Awarder.autoopt['fr'..i].group2.onleave()
		end)
		DA_Awarder.autoopt['fr'..i].group2.onenter=function()
			for b=1,11 do
				DA_Awarder.autoopt['fr'..i].group2['gr2'..b]:SetPoint("CENTER", DA_Awarder.autoopt['fr'..i].group2.scrollchild, "LEFT", -6.5+11*b, 0)
				DA_Awarder.autoopt['fr'..i].group2['gr2'..b]:Show()
			end
			DA_Awarder.autoopt['fr'..i].group2.classfont:Show()
			DA_Awarder.autoopt['fr'..i].group2:SetSize(122,11)
		end
		DA_Awarder.autoopt['fr'..i].group2.onleave=function()
			if not DA_Awarder.autoopt['fr'..i].group2:IsMouseOver() then
				local countbunnies=0
				for k=1,11 do
					if DA_Awarder.autoopt['fr'..i].group2['gr2'..k].isenabled then
						countbunnies=countbunnies+1
						DA_Awarder.autoopt['fr'..i].group2['gr2'..k]:SetPoint("CENTER", DA_Awarder.autoopt['fr'..i].group2.scrollchild, "LEFT", -6.5+11*countbunnies, 0)
						DA_Awarder.autoopt['fr'..i].group2['gr2'..k]:Show()
					else
						DA_Awarder.autoopt['fr'..i].group2['gr2'..k]:Hide()
					end
				end
				if countbunnies==0 then
					DA_Awarder.autoopt['fr'..i].group2:SetSize(11,11)
					DA_Awarder.autoopt['fr'..i].group2['gr21']:SetPoint("CENTER", DA_Awarder.autoopt['fr'..i].group2.scrollchild, "LEFT", -6.5+11, 0)
					DA_Awarder.autoopt['fr'..i].group2['gr21']:Show()
				else
					DA_Awarder.autoopt['fr'..i].group2:SetSize(11*countbunnies,11)
				end
				DA_Awarder.autoopt['fr'..i].group2.classfont:Hide()
			end
		end
		
	end
	
	do --grp 3
		DA_Awarder.autoopt['fr'..i].group3=DA.HideBarCreater('DA_Aw_AO'..i..'grp3',DA_Awarder.autoopt['fr'..i],{34,11},{"LEFT", DA_Awarder.autoopt['fr'..i].group2, "RIGHT", 5, 0})
		-- DA_Awarder.autoopt['fr'..i].group3:SetFrameLevel(182)
		
		DA_Awarder.autoopt['fr'..i].group3.miscfont=DA.FontCreater(nil,L['misc'],{'bottomleft',DA_Awarder.autoopt['fr'..i].group3,'topleft',5,-3},DA_Awarder.autoopt['fr'..i].fonts,15,150,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},"left",{0.75,0.85,0.85,0.8})
		
		for n,txt in ipairs({
		{"Interface\\Icons\\Spell_Lightning_LightningBolt01",L['Skada-based award'],'skada'},
		{"Interface\\Icons\\Ability_Mage_TormentOfTheWeak",L['award for leader'],'leader'},
		{"Interface\\Icons\\Spell_Holy_SealOfProtection",L['guild rank award'],'officer'},
		}) do
			if n==1 then --SKADA
				DA_Awarder.autoopt['fr'..i].group3['gr3'..n]=DA.IconicButtonCreater(nil,DA_Awarder.autoopt['fr'..i].group3.scrollchild,{"CENTER", DA_Awarder.autoopt['fr'..i].group3.scrollchild, "LEFT", -6.5+11*n, 0},11,txt[1],function(self)
					
					if not _G[DA_StoredCheckboxes[DA_SelSet].skadamode] then
						DA.Print('Skada DB not selected/not found')
						DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]]=false
							DA_Awarder.autoopt.skadaassign:Hide()
							DA_StoredCheckboxes[DA_SelSet][i].rl['skada']=nil
							DA.AWAutoOptions()
						DA_Awarder.autoopt.officerassign:Hide()
						return
					end
					if DA_StoredCheckboxes[DA_SelSet][i].rl.skada and type(DA_StoredCheckboxes[DA_SelSet][i].rl.skada)=='table' then
						OpenSkadaCriteriaAssignment(i)
						LoadSkadaCriteriaAssignment(i)
						DA.AWAutoOptions()
						return
					end
						DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]]=self.isenabled
						if not self.isenabled then
							DA_Awarder.autoopt.skadaassign:Hide()
							DA_StoredCheckboxes[DA_SelSet][i].rl['skada']=nil
							DA.AWAutoOptions()
						else
							OpenSkadaCriteriaAssignment(i)
						end
				end,
				function(self) 
					if DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]] then
						if type(DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]])=='boolean' then
							return txt[2]
						elseif type(DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]])=='table' then
						
							local db=DA_StoredCheckboxes[DA_SelSet][i].rl['skada']
							local boss=db.boss
							local mode
							for _,l in pairs(skada_list_modes) do
								if db.mode==l[2] then
									mode=l[1]
									break
								end
							end
							local addit=db.addit or nil
							local matem=db.matem.typ..((db.matem[1] and (" |cffeef564"..db.matem[1])) or "")..((db.matem[2] and (" |cff6df7bband |cffeef564"..db.matem[2])) or "")
							return txt[2].."\n\nBoss: |cff6df7bb"..boss.."\n|rMode: |cff6df7bb"..mode..((addit and ("\n      |cffeef564"..addit)) or "").."\n|rIf: |cff6df7bb"..matem
						end
					else
						return txt[2]
					end
				end
				)
			elseif n==2 then --LEADER
				DA_Awarder.autoopt['fr'..i].group3['gr3'..n]=DA.IconicButtonCreater(nil,DA_Awarder.autoopt['fr'..i].group3.scrollchild,{"CENTER", DA_Awarder.autoopt['fr'..i].group3.scrollchild, "LEFT", -6.5+11*n, 0},11,txt[1],function(self)
					DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]]=self.isenabled
				end,txt[2])
			elseif n==3 then --OFFICER
				DA_Awarder.autoopt['fr'..i].group3['gr3'..n]=DA.IconicButtonCreater(nil,DA_Awarder.autoopt['fr'..i].group3.scrollchild,{"CENTER", DA_Awarder.autoopt['fr'..i].group3.scrollchild, "LEFT", -6.5+11*n, 0},11,txt[1],function(self)
					DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]]=self.isenabled
					if not self.isenabled then
						DA_Awarder.autoopt.officerassign:Hide()
						DA_StoredCheckboxes[DA_SelSet][i].rl['officer']=nil
						DA.AWAutoOptions()
					else
						OpenOfficerCriteriaAssignment(i)
					end
				end,function(self) 
						if DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]] then
							if type(DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]])=='boolean' then
								return txt[2].."\n\n|cffeef564 "..L['no rank selected']
							elseif type(DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]])=='table' then
								if DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]][2] then
									return txt[2].."\n\n|cff6df7bb"..L['rank'].." ["..DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]][1].."]"..GuildControlGetRankName(DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]][1] +1).." "..L['and higher']
								else
									return txt[2].."\n\n|cff6df7bb"..L['rank'].." ["..DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]][1].."]"..GuildControlGetRankName(DA_StoredCheckboxes[DA_SelSet][i].rl[txt[3]][1] +1)
								end
							end
						else
							return txt[2]
						end
					end
					)
				
				
				
			end
			-- DA_Awarder.autoopt['fr'..i].group3['gr3'..n]:SetFrameLevel(183)
			DA_Awarder.autoopt['fr'..i].group3['gr3'..n].switch(false)
			DA_Awarder.autoopt['fr'..i].group3['gr3'..n]:HookScript("OnEnter",function()
				DA_Awarder.autoopt['fr'..i].group3.onenter()
			end)
			DA_Awarder.autoopt['fr'..i].group3['gr3'..n]:HookScript("OnLeave",function()
				DA_Awarder.autoopt['fr'..i].group3.onleave()
			end)
		end
		DA_Awarder.autoopt['fr'..i].group3:SetScript("OnEnter",function()
			DA_Awarder.autoopt['fr'..i].group3.onenter()
		end)
		DA_Awarder.autoopt['fr'..i].group3:SetScript("OnLeave",function()
			DA_Awarder.autoopt['fr'..i].group3.onleave()
		end)
		DA_Awarder.autoopt['fr'..i].group3.onenter=function()
			for b=1,3 do
				DA_Awarder.autoopt['fr'..i].group3['gr3'..b]:SetPoint("CENTER", DA_Awarder.autoopt['fr'..i].group3.scrollchild, "LEFT", -6.5+11*b, 0)
				DA_Awarder.autoopt['fr'..i].group3['gr3'..b]:Show()
			end
			DA_Awarder.autoopt['fr'..i].group3:SetSize(34,11)
			DA_Awarder.autoopt['fr'..i].group3.miscfont:Show()
		end
		DA_Awarder.autoopt['fr'..i].group3.onleave=function()
			if not DA_Awarder.autoopt['fr'..i].group3:IsMouseOver() then
				local countbunnies=0
				for k=1,3 do
					if DA_Awarder.autoopt['fr'..i].group3['gr3'..k].isenabled then
						countbunnies=countbunnies+1
						DA_Awarder.autoopt['fr'..i].group3['gr3'..k]:SetPoint("CENTER", DA_Awarder.autoopt['fr'..i].group3.scrollchild, "LEFT", -6.5+11*countbunnies, 0)
						DA_Awarder.autoopt['fr'..i].group3['gr3'..k]:Show()
					else
						DA_Awarder.autoopt['fr'..i].group3['gr3'..k]:Hide()
					end
				end
				if countbunnies==0 then
					DA_Awarder.autoopt['fr'..i].group3:SetSize(11,11)
					DA_Awarder.autoopt['fr'..i].group3['gr31']:SetPoint("CENTER", DA_Awarder.autoopt['fr'..i].group3.scrollchild, "LEFT", -6.5+11, 0)
					DA_Awarder.autoopt['fr'..i].group3['gr31']:Show()
				else
					DA_Awarder.autoopt['fr'..i].group3:SetSize(11*countbunnies,11)
				end
				DA_Awarder.autoopt['fr'..i].group3.miscfont:Hide()
			end
		end
	end
		
	DA_Awarder.autoopt['fr'..i]:Show()
end

DA_Awarder.righside=DA.FrameCreater(nil,DA_Awarder,350,333,{"TOPLEFT", _G['DA_Awarder'], "TOPRIGHT", 2, 0})
DA_Awarder.righside:RegisterForDrag("LeftButton")
DA_Awarder.righside:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
DA_Awarder.righside:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end) 

DA_Awarder.AssignFrame=DA.FrameCreater(nil,DA_Awarder,180,130,{"TOPRIGHT",_G["DA_Awarder"],"TOPLEFT",-2,0})
DA_Awarder.AssignFrame:RegisterForDrag("LeftButton")
DA_Awarder.AssignFrame:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
DA_Awarder.AssignFrame:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end) 


FEP_ZamFrame=DA.FrameCreater(nil,DA_Awarder,180,334,{"BOTTOMRIGHT",_G["DA_Awarder"],"BOTTOMLEFT",-2,0})
FEP_ZamFrame:RegisterForDrag("LeftButton")
FEP_ZamFrame:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
FEP_ZamFrame:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end) 

DA_Awarder.array={
	g1=0,
	g2=0,
	g3=0,
	g4=0,
	g5=0,
	g6=0,
	g7=0,
	g8=0,
}

function DA.AWAutoOptions()
	for i=1,8 do
		if DA_StoredCheckboxes[DA_SelSet][i] then
			DA_Awarder.autoopt['fr'..i]:SetPoint("LEFT", DA_Awarder.autoopt, "BOTTOMLEFT", 2.5, 111-(8-#DA_StoredCheckboxes[DA_SelSet])*13-13*i)
			DA_Awarder.autoopt:SetSize(250,160-(8-#DA_StoredCheckboxes[DA_SelSet])*13)
			DA_Awarder.autoopt['fr'..i]:Show()
			
			if i==1 then
				if DA_StoredCheckboxes[DA_SelSet][i].rl['raid'] then
					DA_Awarder.autoopt['fr'..i]['raid'].switch(true)
				else
					DA_Awarder.autoopt['fr'..i]['raid'].switch(false)
				end
			end
			
			
			for n,q in ipairs({'tank','healer','melee','caster','saved'}) do
				if DA_StoredCheckboxes[DA_SelSet][i].rl[q] then
					DA_Awarder.autoopt['fr'..i].group1['gr1'..n].switch(true)
				else
					DA_Awarder.autoopt['fr'..i].group1['gr1'..n].switch(false)
				end
			end
					
			for n,q in ipairs({'andcl','WARRIOR','DEATHKNIGHT','PALADIN','PRIEST','SHAMAN','DRUID','ROGUE','MAGE','WARLOCK','HUNTER'}) do
				if (n==1 and DA_StoredCheckboxes[DA_SelSet][i].andcl) or (n>1 and DA_StoredCheckboxes[DA_SelSet][i].cl[q]) then
					DA_Awarder.autoopt['fr'..i].group2['gr2'..n].switch(true)
				else
					DA_Awarder.autoopt['fr'..i].group2['gr2'..n].switch(false)
				end
			end
		
			for n,q in ipairs({'skada','leader','officer'}) do
				if DA_StoredCheckboxes[DA_SelSet][i].rl[q] then
					if q=='skada' or q=='officer' then
						if DA_StoredCheckboxes[DA_SelSet][i].rl[q]==true then
							DA_StoredCheckboxes[DA_SelSet][i].rl[q]=nil
							DA_Awarder.autoopt['fr'..i].group3['gr3'..n].switch(false)
						else
							DA_Awarder.autoopt['fr'..i].group3['gr3'..n].switch(true)
						end
					elseif q=='leader' then
						DA_Awarder.autoopt['fr'..i].group3['gr3'..n].switch(true)
					end
				else
					DA_Awarder.autoopt['fr'..i].group3['gr3'..n].switch(false)
				end
			end
		
			DA_Awarder.autoopt['fr'..i].group1.onleave()
			DA_Awarder.autoopt['fr'..i].group2.onleave()
			DA_Awarder.autoopt['fr'..i].group3.onleave()
			
		elseif DA_Awarder.autoopt['fr'..i]:IsShown() then
			DA_Awarder.autoopt['fr'..i]:Hide()
		end
	end
	
	skada_db_check_if_one()
	skada_db_set()
end
---- variables

local DA_locals_UpdList={}
DA_standby_mainslist=DA_standby_mainslist or "@"

DA_StoredCheckboxes=DA_StoredCheckboxes or {
	default={
		{'raid',12000,
			rl={
				raid=true
			},
			cl={},
		}, 
		{'tank_heal',1000,
			rl={
				tank=true,
				healer=true,
			},
			cl={},
		},
		{'bis',1000,
			rl={},
			cl={},
		},
		{'dps',1000,
			rl={},
			cl={},
		},
		{'trash',1000,
			rl={},
			cl={},
		},
		
	},	
	icc={
		{'raid',12000,
			rl={
				raid=true
			},
			cl={},
		},
		{'tank_heal',1000,
			rl={
				tank=true,
				healer=true,
			},
			cl={},
		},
		{'bis',1000,
			rl={},
			cl={},
		},
	},
	ruby={
		{'raid',4500,
			rl={
				raid=true
			},
			cl={},
		},
		{'tank_heal',500,
			rl={
				tank=true,
				healer=true,
			},
			cl={},
		},
		{'bis',500,
			rl={},
			cl={},
		},
	},
}

local raidCompClasses = {
	["DEATHKNIGHT"] = { letter = "L", role = "melee" },
	["DEATHKNIGHT1"] = { letter = "K", role = "tank" , only=true},
	["DEATHKNIGHT2"] = { letter = "L", role = "melee" },
	["DEATHKNIGHT3"] = { letter = "M", role = "melee" },

	["PRIEST"] = { letter = "q", role = "caster" , only=true},
	["PRIEST1"] = { letter = "n", role = "healer" },
	["PRIEST2"] = { letter = "p", role = "healer" },
	["PRIEST3"] = { letter = "q", role = "caster" , only=true},

	["DRUID"] = { letter = "x", role = "caster" , only=true},
	["DRUID1"] = { letter = "x", role = "caster" , only=true},
	["DRUID2"] = { letter = "v", role = "melee" , only=true},
	["DRUID3"] = { letter = "w", role = "healer" , only=true},

	["ROGUE"] = { letter = "j", role = "melee" },
	["ROGUE1"] = { letter = "k", role = "melee" },
	["ROGUE2"] = { letter = "j", role = "melee" },
	["ROGUE3"] = { letter = "m", role = "melee" },

	["HUNTER"] = { letter = "F", role = "melee" },
	["HUNTER1"] = { letter = "C", role = "melee" },
	["HUNTER2"] = { letter = "F", role = "melee" },
	["HUNTER3"] = { letter = "D", role = "melee" },

	["SHAMAN"] = { letter = "r", role = "caster" , only=true},
	["SHAMAN1"] = { letter = "r", role = "caster" , only=true},
	["SHAMAN2"] = { letter = "t", role = "melee" , only=true},
	["SHAMAN3"] = { letter = "s", role = "healer" , only=true},

	["MAGE"] = { letter = "b", role = "caster" },
	["MAGE1"] = { letter = "d", role = "caster" },
	["MAGE2"] = { letter = "b", role = "caster" },
	["MAGE3"] = { letter = "c", role = "caster" },

	["WARLOCK"] = { letter = "z", role = "caster" },
	["WARLOCK1"] = { letter = "z", role = "caster" },
	["WARLOCK2"] = { letter = "B", role = "caster" },
	["WARLOCK3"] = { letter = "y", role = "caster" },

	["PALADIN"] = { letter = "G", role = "melee" , only=true },
	["PALADIN1"] = { letter = "H", role = "healer" , only=true},
	["PALADIN2"] = { letter = "J", role = "tank" , only=true},
	["PALADIN3"] = { letter = "G", role = "melee" , only=true},

	["WARRIOR"] = { letter = "h", role = "melee" },
	["WARRIOR1"] = { letter = "f", role = "melee" },
	["WARRIOR2"] = { letter = "h", role = "melee" },
	["WARRIOR3"] = { letter = "g", role = "tank" , only=true},
}

local function raidCompGetClassShort(class, spec, role)
	if not class then return "0" end

	-- if specID is provided (number)
	if spec then
		local entry = raidCompClasses[class .. spec]
		return entry and entry.letter or "0", true
	end

	if role then
		if class=="DRUID" and (role=='melee' or role=='tank') then
			return "v" , true --yes, we are tolerant to bear tanks
		end
		
		local entry1 = raidCompClasses[class]
		if entry1 and entry1.role == role then
			return entry1.letter , entry1.only
		end
		
		
		for i = 1, 3 do
			local entry = raidCompClasses[class .. i]
			if entry and entry.role == role then
				return entry.letter , entry.only
			end
		end
		
		return "0"
	end
end

local function raidCompCleanup(t,rem)
	while true do
		local s = #t 
		
		if s==0 then
			return
		elseif t[s] == rem then
			table.remove(t, s)
		else
			return
		end
	end
end
function DA.CreateSnapshot(isauto)


local stamp
	local datX,timX=string.match(date(), "(.+)%s(.+)")
	stamp=datX..' |cff85aaaa'..timX

if (GetNumRaidMembers() and GetNumRaidMembers()>0) or DA_Awarder.locker.getstate() then
	local raidCompSpec={}
	local raidCompNames={}
	local specFailed=0
	local counterplayers=0
	
	for grp=1,8 do
		for id=1,5 do
			local frame = _G["DA_AwarderGroup"..grp.."frame"..id]
			if frame then
				if frame:IsShown() and frame.c then
					counterplayers=counterplayers+1
					local name = frame.c.name
					local class = frame.c.clas
					local storedRole = frame.c.checkedSpec
					local role = LGT:GetUnitRole(name)
						local spec_a,spec_b,spec_c = LGT:GetTreeNames(class)
						local specname = select(1,LGT:GetUnitTalentSpec(name),1)
					local spec_ID = specname and ((spec_a and spec_a == specname and 1) or (spec_b and spec_b == specname and 2) or (spec_c and spec_c == specname and 3)) or nil
					local specShort, specCorrect = raidCompGetClassShort(class, spec_ID, storedRole or role)
					
					if specCorrect or (spec_ID and specShort) then
						tinsert(raidCompSpec, specShort)
						tinsert(raidCompNames, name)
					elseif specShort then	
						specFailed = specFailed + 1
						tinsert(raidCompSpec, specShort)
						tinsert(raidCompNames, "@@+"..name)
							
					else
						tinsert(raidCompSpec, "0")
						tinsert(raidCompNames, ";")
						specFailed = specFailed + 1
					end
						
				else
					tinsert(raidCompSpec, "0")
					tinsert(raidCompNames, ";")
				end
					
			end
		end
	end
	
	if counterplayers==0 then
		DA.Print(L["raid is empty"])
		return
	end
	
	raidCompCleanup(raidCompSpec, "0")
	raidCompCleanup(raidCompNames, ";")
	
	if specFailed ~= 0 then
		DA.Print(L["failed to detect specialization"]..": "..specFailed.." players")
	end
	
	local RaidCompLink = "https://www.wowhead.com/wotlk/raid-composition#0"..table.concat(raidCompSpec)..";"..table.concat(raidCompNames,";")
	DA.Print("Raid Comp Link: "..DA.GetChatCopyLink(RaidCompLink))
	
	tinsert(DA_Snapshots,{isauto=isauto,members=counterplayers,stamp=stamp,raid=DA.DeepCopy(DA_Awarder.raidtable),currentset=DA_SelSet,marks=DA.DeepCopy(DA_raid_marks) , compLink = RaidCompLink})
	
else
	DA.Print(L["raid is empty"])
	return
end

if #DA_Snapshots>30 then
	table.remove(DA_Snapshots,1)
end

if DA_Awarder.getsavesFrame:IsShown() then
	re_render_saves()
	re_render_saves()
end


end
function DA.LoadSnapshot(id,whatload)
DA_Awarder.locker.setstate(true)
for grp=1,8 do
	for player=1,5 do
		if _G["DA_AwarderGroup"..grp.."frame"..player] then
			_G["DA_AwarderGroup"..grp.."frame"..player]:Hide()
			_G["DA_AwarderGroup"..grp.."frame"..player].c=nil
		end
	end
end
if whatload=="all" then
	DA_Awarder.raidtable=DA.DeepCopy(DA_Snapshots[id].raid)
	DA_raid_marks=nil
	DA_raid_marks=DA.DeepCopy(DA_Snapshots[id].marks)
	DA_Awarder.isinraidfont:SetText("S N A P S H O T")
elseif whatload=="raid" then
	DA_Awarder.raidtable=DA.DeepCopy(DA_Snapshots[id].raid)
	DA_Awarder.isinraidfont:SetText("S N A P S H O T")
elseif whatload=="marks" then
	DA_raid_marks=nil
	DA_raid_marks=DA.DeepCopy(DA_Snapshots[id].marks)
end

if (whatload=="all" or whatload=="marks") and (not DA_SelSet or DA_SelSet~=DA_Snapshots[id].currentset) then
	DA_SelSet=DA_Snapshots[id].currentset
	ReRenderNaborsList();FEP_RecalculateAllBtnEP();FEP_ResetAllChecks();resetAddboxes();readdRemCh();FEP_ReNameRePushThings();FEP_GatherRaid()
	ReRenderNaborsList();FEP_RecalculateAllBtnEP();FEP_ResetAllChecks();resetAddboxes();readdRemCh();FEP_ReNameRePushThings();FEP_GatherRaid()
else
	FEP_GatherRaid()
	FEP_GatherRaid()
end

end

local function FEP_ClearArray()
DA_Awarder.array={
	g1=0,
	g2=0,
	g3=0,
	g4=0,
	g5=0,
	g6=0,
	g7=0,
	g8=0,
}
end
local function FEP_CheckNoteType(note)
	if not note or note == "" or ({string.gsub(note,"%s","")})[1]=="" then
		return "pb"
	end
	local first,sec,th=DA.DecodeNote(note)
	if first=='m' and sec==0 and th==0 then
		return "m"
	elseif first=='f' then
		return "f"
	elseif first=='m' then
		return 'm',note
	elseif first=='t' then

		if not FEP_gMain[note] then
			return "n"
		end
		
		local second=DA.DecodeNote(FEP_gMain[note])
		if second==0 then
			return "pb"
		elseif second=='f' then
			return 't',"f"
		elseif second=='m' then
			return 't',note
		elseif second=='t' then
			return 'n'
		end
	end
end 

local function OptMenuUpdate()
if DAOptMenuFrame and DAOptMenuFrame:IsShown() then else return end

-- not InCombatLockdown()


	if UnitInRaid(DAOptMenuFrame.player) then else DAOptMenuFrame:Hide() return end
	
	if DAOptMenuFrame.player and GetPartyAssignment('MAINTANK',DAOptMenuFrame.player, 1) then
		DAOptMenuFrame.MT:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Green.blp")
		DAOptMenuFrame.OT:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight")
		
		local ottxt="/run ClearPartyAssignment('MAINTANK','"..DAOptMenuFrame.player.."', 1);DAOptMenuFrame.ismt=false \n"
		DAOptMenuFrame.MT:SetAttribute("macrotext", ottxt)
		local ottxt2="/run if GetPartyAssignment('MAINTANK','"..DAOptMenuFrame.player.."', 1) then ClearPartyAssignment('MAINTANK','"..DAOptMenuFrame.player.."', 1) end;DAOptMenuFrame.ismt=false \n"; ottxt2=ottxt2.."/mainassist "..DAOptMenuFrame.player
		DAOptMenuFrame.OT:SetAttribute("macrotext", ottxt2)
	elseif DAOptMenuFrame.player and GetPartyAssignment('MAINASSIST',DAOptMenuFrame.player, 1) then
		DAOptMenuFrame.MT:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight")
		DAOptMenuFrame.OT:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Green.blp")
		
		local ottxt="/run DAOptMenuFrame.ismt=true \n"; ottxt=ottxt.."/maintank "..DAOptMenuFrame.player
		DAOptMenuFrame.MT:SetAttribute("macrotext", ottxt)
		local ottxt2="/run ClearPartyAssignment('MAINASSIST','"..DAOptMenuFrame.player.."', 1) ;DAOptMenuFrame.ismt=false \n"
		DAOptMenuFrame.OT:SetAttribute("macrotext", ottxt2)
	elseif DAOptMenuFrame.player then
		DAOptMenuFrame.MT:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight")
		DAOptMenuFrame.OT:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight")
		
		local ottxt="/run DAOptMenuFrame.ismt=true \n"; ottxt=ottxt.."/maintank "..DAOptMenuFrame.player
		DAOptMenuFrame.MT:SetAttribute("macrotext", ottxt)
		local ottxt2="/run if GetPartyAssignment('MAINTANK','"..DAOptMenuFrame.player.."', 1) then ClearPartyAssignment('MAINTANK','"..DAOptMenuFrame.player.."', 1) end;DAOptMenuFrame.ismt=false \n"; ottxt2=ottxt2.."/mainassist "..DAOptMenuFrame.player
		DAOptMenuFrame.OT:SetAttribute("macrotext", ottxt2)
	end
	
	if UnitIsPartyLeader('player') then
		if GetLootMethod()=='master' then
			DAOptMenuFrame.lootername=false
			if GetNumRaidMembers()==0 then 
			else
				for i=1,GetNumRaidMembers() do
					
					local nam, _, _, _, _, _, _, _, _, _, isML = GetRaidRosterInfo(i)
					if isML then
						DAOptMenuFrame.lootername=nam
						break
					end
				end
			end
		end
		
		DAOptMenuFrame.assist:SetAlpha(1)
		DAOptMenuFrame.assist:Enable()
		DAOptMenuFrame.looter:SetAlpha(1)
		DAOptMenuFrame.looter:Enable()
		if UnitIsPartyLeader(DAOptMenuFrame.player) then
			DAOptMenuFrame.assist:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Red.blp")
		elseif UnitIsRaidOfficer(DAOptMenuFrame.player) then
			DAOptMenuFrame.assist:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Green.blp")
		else
			DAOptMenuFrame.assist:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight")
		end
		
		if GetLootMethod()=='master' and DAOptMenuFrame.lootername==DAOptMenuFrame.player then
			if UnitIsPartyLeader(DAOptMenuFrame.player) then
				DAOptMenuFrame.looter:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Red.blp")
			else
				DAOptMenuFrame.looter:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Green.blp")
			end
		else
			DAOptMenuFrame.looter:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight.blp")
		end
	else
		DAOptMenuFrame.assist:SetAlpha(0.5)
		DAOptMenuFrame.assist:Disable()
		DAOptMenuFrame.looter:SetAlpha(0.5)
		DAOptMenuFrame.looter:Disable()
	end
	
	
	
end
local function FEP_UpdateFrames()
DA_standby_mainslist="@"
local flag=0
local flag2=0
local main=0

DA.RegatherGuildNotes()

	for i=1,8 do
		for p=1,5 do
			local frame=_G['DA_AwarderGroup'..i..'frame'..p] or nil
			if frame then 
			
			
				if not frame.c or not frame.c.name then
					if not InCombatLockdown() then frame:Hide() end
					frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp')
					frame:SetText("")
				else
					if not InCombatLockdown() then frame:Show() end
					if EPGP then 
						if EPGP:IsMemberInAwardList(frame.c.name) then
							EPGP:DeSelectMember(frame.c.name)
						end
						if FEP_L_gMain[DA_CurrentGuild] and FEP_L_gMain[DA_CurrentGuild][frame.c.name] and EPGP:IsMemberInAwardList(FEP_L_gMain[DA_CurrentGuild][frame.c.name]) then
							EPGP:DeSelectMember(FEP_L_gMain[DA_CurrentGuild][frame.c.name])
						end
						
						if EPGP:IsMemberInAwardList(FEP_gMain[frame.c.name]) then
							EPGP:DeSelectMember(FEP_L_gMain[DA_CurrentGuild][frame.c.name])
						end
					end
					local ng=nil
					if FEP_gMain[frame.c.name] then
						flag,flag2=FEP_CheckNoteType(FEP_gMain[frame.c.name])
						ng=nil
						if FEP_L_gMain[DA_CurrentGuild][frame.c.name] then
							FEP_L_gMain[DA_CurrentGuild][frame.c.name]=nil
						end
					elseif FEP_L_gMain[DA_CurrentGuild][frame.c.name] then
						flag,flag2=FEP_CheckNoteType(FEP_L_gMain[DA_CurrentGuild][frame.c.name])
						ng=1
					else
						flag="n"
					end
					
					
					if flag=="n" then
						if ng then
							frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red.blp')
							frame.state="n"
							frame.main=FEP_L_gMain[DA_CurrentGuild][frame.c.name] or "not in guild"
							frame.mainmain=FEP_gMain[FEP_L_gMain[DA_CurrentGuild][frame.c.name] or "_abs"] or ""
						else
							frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red.blp')
							frame.state="n"
							frame.main=FEP_gMain[frame.c.name] or "not in guild"
							frame.mainmain=FEP_gMain[FEP_gMain[frame.c.name] or "_abs"] or ""
						end
						
					elseif flag=="f" or (flag=='t' and flag2=='f') then
						frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Blue.blp')
						if ng then
							if flag2=='f' then 
								frame.state="tf" 
								frame.main=FEP_L_gMain[DA_CurrentGuild][frame.c.name]
								frame.mainmain=FEP_gMain[FEP_L_gMain[DA_CurrentGuild][frame.c.name]]
							else 
								frame.state="f" 
								frame.main=FEP_L_gMain[DA_CurrentGuild][frame.c.name]
								frame.mainmain=nil
							end
						else
							if flag2=='f' then 
								frame.state="tf" 
								frame.main=FEP_gMain[frame.c.name]
								frame.mainmain=FEP_gMain[FEP_gMain[frame.c.name]]
							else 
								frame.state="f" 
								frame.main=FEP_gMain[frame.c.name]
								frame.mainmain=nil
							end
						end
						
					elseif flag=="t" then
						if ng then
							if string.find(DA_standby_mainslist,"@"..FEP_L_gMain[DA_CurrentGuild][frame.c.name].."@") then
								frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Purple.blp')
								frame.state="put"
								frame.main=FEP_L_gMain[DA_CurrentGuild][frame.c.name]
								frame.mainmain=nil
							else
								frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Green.blp')
								if EPGP then
									if not EPGP:IsMemberInAwardList(FEP_L_gMain[DA_CurrentGuild][frame.c.name]) then
										EPGP:SelectMember(FEP_L_gMain[DA_CurrentGuild][frame.c.name])
									end
								end
								DA_standby_mainslist=DA_standby_mainslist..FEP_L_gMain[DA_CurrentGuild][frame.c.name].."@"
								frame.state="tnormal" 
								frame.main=FEP_L_gMain[DA_CurrentGuild][frame.c.name]
								frame.mainmain=L['local tvin']
								if string.find(DA_Standby[DA_CurrentGuild],frame.main.."\n") then
									DA_Standby[DA_CurrentGuild]=({string.gsub("\n"..DA_Standby[DA_CurrentGuild], frame.main.."\n", "")})[1]
									DA.Print(frame.c.name.." "..L['removed from standby, present in raid'])
									FEP_ZamField:SetText(DA_Standby[DA_CurrentGuild])
									
								end
							end
						else
							if string.find(DA_standby_mainslist,"@"..FEP_gMain[frame.c.name].."@") then
								frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Purple.blp')
								frame.state="put"
								frame.main=FEP_gMain[frame.c.name]
								frame.mainmain=nil
							else
								frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight.blp')
								DA_standby_mainslist=DA_standby_mainslist..FEP_gMain[frame.c.name].."@"
								frame.state="tnormal" 
								frame.main=FEP_gMain[frame.c.name]
								frame.mainmain=nil
								if string.find(DA_Standby[DA_CurrentGuild],frame.main.."\n") then
									DA_Standby[DA_CurrentGuild]=({string.gsub("\n"..DA_Standby[DA_CurrentGuild], frame.main.."\n", "")})[1]
									DA.Print(frame.c.name.." "..L['removed from standby, present in raid'])
									FEP_ZamField:SetText(DA_Standby[DA_CurrentGuild])
								end
							end
						
						end
						
						
					elseif flag=="m" then
						if ng then
							if string.find(DA_standby_mainslist,"@"..frame.c.name.."@") then
								frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Purple.blp')
								frame.state="pum"
								frame.main=FEP_L_gMain[DA_CurrentGuild][frame.c.name]
								frame.mainmain=nil
							else
								frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_White.blp')
								DA_standby_mainslist=DA_standby_mainslist..frame.c.name.."@"
								frame.state="mnormal" 
								frame.main=FEP_L_gMain[DA_CurrentGuild][frame.c.name]
								frame.mainmain=nil
								if string.find(DA_Standby[DA_CurrentGuild],frame.main.."\n") then
									DA_Standby[DA_CurrentGuild]=({string.gsub("\n"..DA_Standby[DA_CurrentGuild], frame.main.."\n", "")})[1]
									DA.Print(frame.c.name.." "..L['removed from standby, present in raid'])
									FEP_ZamField:SetText(DA_Standby[DA_CurrentGuild])
								end
							end
						else
							if string.find(DA_standby_mainslist,"@"..frame.c.name.."@") then
								frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Purple.blp')
								frame.state="pum"
								frame.main=FEP_gMain[frame.c.name]
								frame.mainmain=nil
							else
								frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight.blp')
								DA_standby_mainslist=DA_standby_mainslist..frame.c.name.."@"
								frame.state="mnormal" 
								frame.main=FEP_gMain[frame.c.name]
								frame.mainmain=nil
								if string.find(DA_Standby[DA_CurrentGuild],frame.c.name.."\n") then
									DA_Standby[DA_CurrentGuild]=({string.gsub("\n"..DA_Standby[DA_CurrentGuild], frame.c.name.."\n", "")})[1]
									DA.Print(frame.c.name.." "..L['removed from standby, present in raid'])
									FEP_ZamField:SetText(DA_Standby[DA_CurrentGuild])
								end
							end
						
						end
						
						
					elseif flag=="pb" then
						if ng then
							frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Yellow.blp')
							frame.state="pb"
							frame.main=FEP_L_gMain[DA_CurrentGuild][frame.c.name]
							frame.mainmain=nil
						else
							frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Yellow.blp')
							frame.state="pb"
							frame.main=FEP_gMain[frame.c.name]
							frame.mainmain=nil						
						end
						
						
						
						
					-- elseif flag=="n" then 
						-- frame:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight.blp')
						
						
					end
				end
			end
			
		end
	end
	
	if not FEP_ZamField.focusgained then FEP_ZamField:SetText(DA_Standby[DA_CurrentGuild]) end
	if DA_Awarder.AssignFrame:IsShown() and (not DA_Awarder.AssignFrame.EB.focusgained) then _G[DA_Awarder.AssignFrame.GetCalledby]:Click() end
	FEP_ResetAllChecks()
	FEP_RecalculateAllBtnEP()
	DA.AWAutoOptions()
	for z=1,#DA_StoredCheckboxes[DA_SelSet] do
		if _G["FEP_Awardfor"..z].focusgained then
		else
			_G["FEP_Awardfor"..z]:SetText(DA_StoredCheckboxes[DA_SelSet][z][2])
			_G["FEP_Awardfor"..z]:SetCursorPosition(0)
		end
	end
	OptMenuUpdate()
end
local function FEP_Fill()
	local a=DA_Awarder.raidtable
	if a[1] then 
		FEP_ClearArray()
	else
		FEP_RePackZamena()
		FEP_UpdateFrames()
		if DA_Awarder.righside:IsShown() then
			FEP_OpenSupportFrame()
		end
	end
	for i=1,#a do 
		local name=a[i].name
		local group=a[i].group
		local clas=a[i].clas
		local tankrole=a[i].tankrole or nil
		local isLA=a[i].isLA or nil
		local masterl=a[i].masterl or nil
		local player=DA_Awarder.array["g"..group]+1
		local color={}
		local isonline=a[i].isonl
		
		
		
		
		if _G['DA_AwarderGroup'.. group .. 'frame' .. player] then 
			_G['DA_AwarderGroup'.. group .. 'frame' .. player]:SetText(name)
			
			color=DA.GetClassColor(clas)
			
			_G['DA_AwarderGroup'.. group .. 'frame' .. player].fs:SetJustifyH('LEFT')
			_G['DA_AwarderGroup'.. group .. 'frame' .. player].fs:SetTextColor(unpack(color))
			-- _G['DA_AwarderGroup'.. group .. 'frame' .. player ]:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight.blp')
			_G['DA_AwarderGroup'.. group .. 'frame' .. player ].c=a[i]
			DA_Awarder.array["g"..group]=DA_Awarder.array["g"..group]+1
			for cbox=1,#DA_StoredCheckboxes[DA_SelSet] do
				_G["DA_AwarderGroup"..group.."frame"..player.."CB"..cbox]:Show()
			end
			  
			--is leader or assist
			if isLA==2 then
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist.txt:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist.txt:Show()
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist:SetNormalTexture(_G["DA_AwarderGroup"..group.."frame"..player].rlassist.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist:SetPushedTexture(_G["DA_AwarderGroup"..group.."frame"..player].rlassist.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist:Show()
			elseif isLA==1 then
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist.txt:SetTexture("Interface\\GroupFrame\\UI-Group-AssistantIcon")
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist.txt:Show()
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist:SetNormalTexture(_G["DA_AwarderGroup"..group.."frame"..player].rlassist.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist:SetPushedTexture(_G["DA_AwarderGroup"..group.."frame"..player].rlassist.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist:Show()
			else
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist.txt:SetTexture("")
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist.txt:Hide()
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist:SetNormalTexture(_G["DA_AwarderGroup"..group.."frame"..player].rlassist.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist:SetPushedTexture(_G["DA_AwarderGroup"..group.."frame"..player].rlassist.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].rlassist:Hide()
			end
				
			--is tank or offtank
			if tankrole=="MAINTANK" then
				_G["DA_AwarderGroup"..group.."frame"..player].MTot.txt:SetTexture("Interface\\GroupFrame\\UI-Group-MainTankIcon")
				_G["DA_AwarderGroup"..group.."frame"..player].MTot.txt:Show()
				_G["DA_AwarderGroup"..group.."frame"..player].ismtot=2
				_G["DA_AwarderGroup"..group.."frame"..player].MTot:SetNormalTexture(_G["DA_AwarderGroup"..group.."frame"..player].MTot.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].MTot:SetPushedTexture(_G["DA_AwarderGroup"..group.."frame"..player].MTot.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].MTot:Show()
			elseif tankrole=="MAINASSIST" then
				_G["DA_AwarderGroup"..group.."frame"..player].MTot.txt:SetTexture("Interface\\GroupFrame\\UI-Group-MainAssistIcon")
				_G["DA_AwarderGroup"..group.."frame"..player].MTot.txt:Show()
				_G["DA_AwarderGroup"..group.."frame"..player].ismtot=1
				_G["DA_AwarderGroup"..group.."frame"..player].MTot:SetNormalTexture(_G["DA_AwarderGroup"..group.."frame"..player].MTot.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].MTot:SetPushedTexture(_G["DA_AwarderGroup"..group.."frame"..player].MTot.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].MTot:Show()
			else
				_G["DA_AwarderGroup"..group.."frame"..player].MTot.txt:SetTexture("")
				_G["DA_AwarderGroup"..group.."frame"..player].MTot.txt:Hide()
				_G["DA_AwarderGroup"..group.."frame"..player].ismtot=0
				_G["DA_AwarderGroup"..group.."frame"..player].MTot:SetNormalTexture(_G["DA_AwarderGroup"..group.."frame"..player].MTot.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].MTot:SetPushedTexture(_G["DA_AwarderGroup"..group.."frame"..player].MTot.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].MTot:Hide()
			end
			
			--is master looter
			if masterl==1 then
				_G["DA_AwarderGroup"..group.."frame"..player].masterlooter.txt:SetTexture("Interface\\GroupFrame\\UI-Group-MasterLooter")
				_G["DA_AwarderGroup"..group.."frame"..player].masterlooter.txt:Show()
				_G["DA_AwarderGroup"..group.."frame"..player].masterlooter:SetNormalTexture(_G["DA_AwarderGroup"..group.."frame"..player].masterlooter.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].masterlooter:SetPushedTexture(_G["DA_AwarderGroup"..group.."frame"..player].masterlooter.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].masterlooter:Show()
			else
				_G["DA_AwarderGroup"..group.."frame"..player].masterlooter.txt:SetTexture("")
				_G["DA_AwarderGroup"..group.."frame"..player].masterlooter.txt:Hide()
				_G["DA_AwarderGroup"..group.."frame"..player].masterlooter:SetNormalTexture(_G["DA_AwarderGroup"..group.."frame"..player].masterlooter.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].masterlooter:SetPushedTexture(_G["DA_AwarderGroup"..group.."frame"..player].masterlooter.txt)
				_G["DA_AwarderGroup"..group.."frame"..player].masterlooter:Hide()
			end
			
			-- is online
			if not fuckingOptions.darkenoffline or isonline then
				_G['DA_AwarderGroup'.. group .. 'frame' .. player ]:SetAlpha(1)
			else
				_G['DA_AwarderGroup'.. group .. 'frame' .. player ]:SetAlpha(0.45)
			end
		end
	end
	FEP_RePackZamena()
	FEP_UpdateFrames()
	
	
	if DA_Awarder.righside:IsShown() then
		FEP_OpenSupportFrame()
	end
end

local function enableMovingGrps()
	local isofficer=false
	if UnitInRaid('player') and UnitIsRaidOfficer('player') then
		isofficer=true
	end
	for i=1,8 do
		DA_Awarder['moverBtn'..i]:EnableMouse(isofficer)
	end
end
function FEP_GatherRaid()
	if not DA_SelSet then DA_SelSet='default' end
	if not DA_AwarderGroup1 then FEP_CreateGroups() end
	re_highlight_difficulty()
	if GetNumRaidMembers()==0 then 
		DA_Awarder.DisbandBtn:Hide()
		DA_Awarder.GiveAssistBtn:Hide()
			if GetNumPartyMembers()>0 and IsPartyLeader() then
				DA_Awarder.CreateRaidBtn:Show()
			else
				DA_Awarder.CreateRaidBtn:Hide()
			end
		if DA_Awarder.isinraidfont then
			DA_Awarder.isinraidfont:Show()
		else
			DA_Awarder.isinraidfont=DA.FontCreater(nil,'NOT IN RAID',{"TOPLEFT",DA_Awarder,"TOPLEFT",195,0},DA_Awarder,15,170,{UIDarkAngelFontConsolas:GetFont(), 11},'left',{1,0.7,0.7,0.8})
		end
		if DA_Awarder.locker.getstate() then FEP_Fill() return end
	else
		if IsRaidLeader() then
			DA_Awarder.GiveAssistBtn:Hide()
		else
			DA_Awarder.GiveAssistBtn:Enable()
			DA_Awarder.GiveAssistBtn:Show()
		end
		
		if IsRaidLeader() or IsRaidOfficer() then DA_Awarder.DisbandBtn:Show() else DA_Awarder.DisbandBtn:Hide() end
		DA_Awarder.CreateRaidBtn:Hide()
		if DA_Awarder.locker.getstate() then FEP_Fill() return end
		
		if DA_Awarder.isinraidfont then
			DA_Awarder.isinraidfont:Hide()
		else
			DA_Awarder.isinraidfont=DA.FontCreater(nil,'NOT IN RAID',{"TOPLEFT",DA_Awarder,"TOPLEFT",195,0},DA_Awarder,15,170,{UIDarkAngelFontConsolas:GetFont(), 11},'left',{1,0.7,0.7,0.8})
			DA_Awarder.isinraidfont:Hide()
		end
	end


	FEP_ClearArray()
	if DA_Awarder.raidtable then
		table.wipe(DA_Awarder.raidtable)
	else
		DA_Awarder.raidtable={}
	end


	for group=1,8 do
		for player=1,5 do
		if _G['DA_AwarderGroup'.. group .. 'frame' .. player ] then
			_G['DA_AwarderGroup'.. group .. 'frame' .. player ].c=nil
			_G['DA_AwarderGroup'.. group .. 'frame' .. player ].state=nil
			_G['DA_AwarderGroup'.. group .. 'frame' .. player ].main=nil
			_G['DA_AwarderGroup'.. group .. 'frame' .. player ].epvalue=nil
			_G['DA_AwarderGroup'.. group .. 'frame' .. player ].mainmain=nil
			_G['DA_AwarderGroup'.. group .. 'frame' .. player ]:SetText('')
			_G['DA_AwarderGroup'.. group .. 'frame' .. player ]:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp')
			
			for cbox=1,#DA_StoredCheckboxes[DA_SelSet] do
				_G["DA_AwarderGroup"..group.."frame"..player.."CB"..cbox]:Hide()
			end

		end
		end
	end
	
	if GetNumRaidMembers()==0 then 
	else
		for i=1,GetNumRaidMembers() do
			local nam, rank, subgroup, _, _, fileName, _, online, _, role, isML = GetRaidRosterInfo(i)
			if nam then
				table.insert(DA_Awarder.raidtable,{name=nam,group=subgroup,clas=fileName,tankrole=(role or nil),isLA=rank,masterl=isML ,isonl=online , checkedSpec=(LGT:GetUnitRole("raid"..i) or LGT:GetUnitRole(tostring(name))) })
				if DA_raid_marks[nam] then
				else
					DA_raid_marks[nam]={}
				end
			end
		end
	end
	FEP_Fill()
	enableMovingGrps()
end

function FEP_EditBoxCreater(name,rel,point,size,allowMultiLine,allowAutoFocus,fonttype,scOnEscapePressed,scOnEnterPressed,scOnEditFocusLost,scOnEditFocusGained,scOnTextChanged,customtxt)
local f = CreateFrame("EditBox", name, rel)
	f:SetPoint(unpack(point))
	f:SetSize(unpack(size))
	f:SetMultiLine(allowMultiLine)
	f:SetAutoFocus(allowAutoFocus)
	f:SetFont(unpack(fonttype))
    if scOnEscapePressed then f:SetScript("OnEscapePressed", scOnEscapePressed) end
    if scOnEnterPressed then f:SetScript("OnEnterPressed", scOnEnterPressed) end
    if scOnEditFocusLost then f:SetScript("OnEditFocusLost", scOnEditFocusLost) end
    if scOnEditFocusGained then f:SetScript("OnEditFocusGained", scOnEditFocusGained) end
	if scOnTextChanged then f:SetScript("OnTextChanged", scOnTextChanged) end
	if customtxt then
		f.t = f:CreateTexture(nil, "BACKGROUND")
		f.t:SetAllPoints()
		f.t:SetTexture(unpack(customtxt));
		f.t:SetBlendMode("add")
	else
		f.t = f:CreateTexture(nil, "BACKGROUND")
		f.t:SetAllPoints()
		f.t:SetTexture(8/255, 42/255, 50/255, 1);
		f.t:SetBlendMode("add")
	end
	return f
end



function FEP_CreateGroups()


do --close btns
	
	DA.CloseButtonCreater(nil,DA_Awarder.AssignFrame,{"TOPRIGHT", DA_Awarder.AssignFrame, "TOPRIGHT", -5,-5},10,10,'x')
	DA.CloseButtonCreater(nil,DA_Awarder,{"TOPRIGHT", DA_Awarder, "TOPRIGHT", -5,-5},10,10,'x')
		DA_Awarder.AssignFrame.myclosebtn:HookScript("OnClick",function() DA.Garbage_Collect() end)
	DA.CloseButtonCreater(nil,FEP_ZamFrame,{"TOPRIGHT", FEP_ZamFrame, "TOPRIGHT", -5,-5},10,10,'x')
	DA.CloseButtonCreater(nil,DA_Awarder.righside,{"TOPRIGHT", DA_Awarder.righside, "TOPRIGHT", -5,-5},10,10,'x')
	
	
end

do --raid difficulty

	
	DA_Awarder.raiddifficultyBtn,DA_Awarder.raiddifficultyFrame=DA.CreateFFGDropFrame(DA_Awarder,"",10,25,{"CENTER",DA_Awarder,"TOPLEFT",170,-10},105,12,"TOP",nil,nil,nil,'Raid difficulty')

	for i,j in ipairs({"10","25","10H","25H"}) do
		DA_Awarder.raiddifficultyFrame[i]=DA.CreateFFGButton2(nil,DA_Awarder.raiddifficultyFrame,{"TOPLEFT", DA_Awarder.raiddifficultyFrame, "TOPLEFT", -25+26*i,-1},10,25,j,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
		
			DA_Awarder.raiddifficultyFrame:Hide()
			SetRaidDifficulty(i)
		end,nil,nil,'center')
	end
	
	function re_highlight_difficulty()
		local difficulty,_=GetRaidDifficulty()
		for i,j in ipairs({"10","25","10H","25H"}) do
			if difficulty==i then
				DA_Awarder.raiddifficultyFrame[i].fs:SetTextColor(0.2,1,1,1)
				DA_Awarder.raiddifficultyBtn:SetText(j)
			else
				DA_Awarder.raiddifficultyFrame[i].fs:SetTextColor(0.85,1,1,1)
			end
		end
	end
	local f=CreateFrame('Frame')
	f:RegisterEvent("CHAT_MSG_SYSTEM")
	f:SetScript("OnEvent", function(_,_,msg)
		if msg:find(ERR_RAID_DIFFICULTY_CHANGED_S:gsub("%:%s%%s%.","")) then
			re_highlight_difficulty()
		end
	end)
end
	
	DA_Awarder.readycheck=DA.CreateFFGButton2(nil,DA_Awarder,{"CENTER", DA_Awarder, "TOPLEFT", 110,-10},10,40,'ready','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
		if GetNumRaidMembers()>0 then
			if IsRaidOfficer() then
				self:Disable()
				-- timer
				DA_Awarder.readycheckfont.timer=time()
				DA_Awarder.readycheckfont:Show()
				DA_Awarder.readycheckfont:SetText('30')
				FFGSetRCState()
				DA.ResumeTimer('ready_check')
				DoReadyCheck()
			else
				DA.Print(L['I am not RL/assist'])
			end
		else
			DA.Print(L['You are not in raid'])
		end
	end)
	DA_Awarder.readycheckfont=DA.FontCreater(nil,"",{"LEFT", DA_Awarder.readycheck, "RIGHT", 2,0},DA_Awarder.readycheck,15,180,{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},'left')
	DA_Awarder.readycheckfont:Hide()
	
	local readychecker=CreateFrame('Frame')
	readychecker:SetScript("OnEvent",function (self,event,param1,param2)
		if event=='READY_CHECK' and IsRaidOfficer() then
			DA_Awarder.readycheck:Disable()
			FFGSetRCState()
			FFGSetRCState(param1,true)
			-- timer
			DA_Awarder.readycheckfont.timer=time()
			DA_Awarder.readycheckfont:Show()
			DA_Awarder.readycheckfont:SetText('30')
			DA.ResumeTimer('ready_check')
		elseif event=='READY_CHECK_CONFIRM' then
			local memberID, _ = string.match(param1, "[raid](%d+)$")
			if tonumber(memberID) then
				FFGSetRCState(tonumber(memberID),param2)
			end
		elseif event=='READY_CHECK_FINISHED' then
			DA_Awarder.readycheck:Enable()
			-- timer stop
			DA_Awarder.readycheckfont:Hide()
			DA.StopTimer('ready_check')
			-- start decay timer
			DA_Awarder.readycheckfont.decay=0
			DA.ResumeTimer('ready_ch_decay')
		end
		
	end)
	readychecker:RegisterEvent("READY_CHECK")
	readychecker:RegisterEvent("READY_CHECK_CONFIRM")
	readychecker:RegisterEvent("READY_CHECK_FINISHED")

do --zamena frame

	DA_Awarder.zamenaopen_btn=DA.CreateFFGButton2(nil,DA_Awarder,{"center", DA_Awarder, "BOTTOMLEFT", 30,12},15,40,L['standby'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
		if FEP_ZamFrame:IsShown() then 
			FEP_ZamFrame:Hide()
		else
			FEP_ZamFrame:Show()
		end
	end,"ZamenaFrBtn")
	
	FEP_EditBoxCreater("FEP_ZamField",FEP_ZamFrame,{"TOPLEFT", FEP_ZamFrame, "TOPLEFT", 20, -20},{120,10},true,false,{"Fonts\\FRIZQT__.TTF", 10},
	function(self) self.t:SetBlendMode("ADD"); self.focusgained=nil;self:ClearFocus();DA_Standby[DA_CurrentGuild]=FEP_ZamField:GetText();FEP_GatherRaid() end,
	nil,
	function(self) self.t:SetBlendMode("ADD"); self.focusgained=nil;self:ClearFocus();DA_Standby[DA_CurrentGuild]=FEP_ZamField:GetText();FEP_GatherRaid() end,
	function(self) self.t:SetBlendMode("BLEND");self.focusgained=1;FEP_ZamField:SetText(DA_Standby[DA_CurrentGuild]) end,
	function(self) 
		if self:GetParent():IsShown() and self.focusgained then 
			DA_Standby[DA_CurrentGuild]=self:GetText() 
		end
	end
	)

	FEP_ZamField:SetPoint("bottomright",FEP_ZamFrame,"bottomright",-25,50)
	
	DA.CreateFFGButton2(nil,FEP_ZamFrame,{"CENTER", FEP_ZamFrame, "TOPRIGHT", -13,-40},  13,  22,  'ok','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
		FEP_ZamField.t:SetBlendMode("ADD"); FEP_ZamField:ClearFocus();DA_Standby[DA_CurrentGuild]=FEP_ZamField:GetText();FEP_GatherRaid()
	end)
	DA.CreateFFGButton2(nil,FEP_ZamFrame,{"BOTTOMRIGHT", FEP_ZamFrame, "BOTTOMRIGHT", -8,60},70,12,L['zamclear'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
		DA_Standby[DA_CurrentGuild]=""
		FEP_ZamField:SetText(DA_Standby[DA_CurrentGuild])
	end)
	FEP_ZamFrame.EnabledCB=DA.CheckBtnCreater(nil,FEP_ZamFrame,{"CENTER", FEP_ZamFrame, "TOPLEFT", 10,-11},25,25,L['enable'],function(self) 
		fuckingOptions.EnableZamena=(self:GetChecked() or false) 
		if self:GetChecked() then
			if EPGP then
				EPGP:GetModule('whisper'):Disable() 
			end
			FEP_ZamWHframe:RegisterEvent("CHAT_MSG_WHISPER")			
		else
			FEP_ZamWHframe:UnregisterEvent("CHAT_MSG_WHISPER")
		end
		GuildRoster()
		FEP_GatherRaid()
		tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
		DA.ResumeTimer('fep')
	end,{'fuckingOptions','EnableZamena'},nil)
		
	
	DA.CreateFFGButton2(nil,FEP_ZamFrame,{"CENTER", FEP_ZamFrame, "BOTTOMLEFT", 140,41},  13,  30,  L['anonszam'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
		SendChatMessage(L['zamenagudok'],'guild')
	end)
	FEP_ZamFrame.AwardCB=DA.CheckBtnCreater(nil,FEP_ZamFrame,{"CENTER", FEP_ZamFrame, "TOPLEFT", 80,-11},25,25,L['raid award'],function(self) 
		GuildRoster()
			
		FEP_GatherRaid()
		tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
		DA.ResumeTimer('fep')
	end)
	FEP_ZamFrame.ClearafterCB=DA.CheckBtnCreater(nil,FEP_ZamFrame,{"TOPLEFT", FEP_ZamFrame, "BOTTOMLEFT", 90, 20},15,15,L['zamclearafteraward'],function(self) 
		fuckingOptions.ZamenaClearAfterAward=(self:GetChecked() or false) 
		GuildRoster()
		FEP_GatherRaid()
		tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
		DA.ResumeTimer('fep')
	end,{'fuckingOptions','ZamenaClearAfterAward'},nil)
	FEP_ZamFrame.ClearafterCB.font:SetSize(190,30)
	
	-- pricols editor
		do
			
			local pricols=DA.CheckBtnCreater(nil,FEP_ZamFrame,{"TOPLEFT", FEP_ZamFrame, "BOTTOMLEFT", 18, 20},15,15,L['jokes'],function(self) fuckingOptions.pricols=(self:GetChecked() or false) end,{'fuckingOptions','pricols'},nil)
		
			FEP_ZamFrame.pricolsbtn,FEP_ZamFrame.pricolsFrame=DA.CreateFFGDropFrame(FEP_ZamFrame,"<>",15,15,{"CENTER", pricols, "CENTER", -16, 0},280,314,"TOPLEFT",nil,function() FEP_PrkField:SetText(getPricols()) end,function() DA_StandbyFunList=packPricols(FEP_PrkField:GetText()) end,'pricolsedit')
			
			DA.ScrollBarCreater("FEP_PrkSB",FEP_ZamFrame.pricolsFrame,{FEP_ZamFrame.pricolsFrame.width-10, FEP_ZamFrame.pricolsFrame.height-30},{"TOPLEFT", 5, -20},1)
			
			
			FEP_EditBoxCreater("FEP_PrkField",FEP_PrkSB.scrollchild,{"TOPLEFT", FEP_PrkSB.scrollchild, "TOPLEFT", 10, -10},{FEP_ZamFrame.pricolsFrame:GetWidth()-40,FEP_ZamFrame.pricolsFrame:GetHeight()-20},true,false,{"Fonts\\FRIZQT__.TTF", 10},
			function(self) self.t:SetBlendMode("ADD"); self.focusgained=nil;self:ClearFocus();DA_StandbyFunList=packPricols(self:GetText()) end,
			nil,
			function(self) self.t:SetBlendMode("ADD"); self.focusgained=nil;self:ClearFocus();DA_StandbyFunList=packPricols(self:GetText()) end,
			function(self) self.t:SetBlendMode("BLEND");self.focusgained=1;self:SetText(getPricols()) end
			)
			
		end
	
end

do --main frame buttons
	
	
	
	do --Award Frame
		DA_Awarder.Awardbn,DA_Awarder.AwardFrame=DA.CreateFFGDropFrame(DA_Awarder,L['award'],15,50,{"CENTER", DA_Awarder, "BOTTOMLEFT", 87,12},100,112,"BOTTOM",nil,function() DA_Awarder.ZamOptFrm:Hide();DA_Awarder.getlocalsFrame:Hide() end)
		
		DA.FontCreater(nil,L['awarder_warn'],{"LEFT",DA_Awarder.AwardFrame,"TOPLEFT",5,-12},DA_Awarder.AwardFrame,50,250,{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"},"left",{1,0.4,0.4,0.9})
		
		
		DA_Awarder.LockOnAward=DA.CheckBtnCreater(nil,DA_Awarder.AwardFrame,{"CENTER",DA_Awarder.AwardFrame,"TOPLEFT",17,-50},15,15,L['lock raid'])
		DA_Awarder.LockOnAward.font:SetSize(190,32)
		DA_Awarder.LockOnAward:SetChecked(false)
		
		DA_Awarder.SaveOnAward=DA.CheckBtnCreater(nil,DA_Awarder.AwardFrame,{"CENTER",DA_Awarder.AwardFrame,"TOPLEFT",17,-62},15,15,L['save raid'],nil,nil,'saveraid')
		DA_Awarder.SaveOnAward.font:SetSize(190,32)
		DA_Awarder.SaveOnAward:SetChecked(true)
		
		DA_Awarder.DisbandOnAward=DA.CheckBtnCreater(nil,DA_Awarder.AwardFrame,{"CENTER",DA_Awarder.AwardFrame,"TOPLEFT",17,-74},15,15,L['disband raid'],function(self) if self:GetChecked() then DA_Awarder.LockOnAward:SetChecked(true);DA_Awarder.SaveOnAward:SetChecked(true) end end)
		DA_Awarder.DisbandOnAward.font:SetSize(190,32)
		DA_Awarder.DisbandOnAward.font:SetTextColor(0.8,0.4,0.5,1)
		DA_Awarder.DisbandOnAward:SetChecked(false)
		
		DA_Awarder.dkpWhispers=DA.CheckBtnCreater(nil,DA_Awarder.AwardFrame,{"CENTER",DA_Awarder.AwardFrame,"TOPLEFT",17,-86},15,15,L["dkpWhispers"],function(self) fuckingOptions_g[DA_CurrentGuild].aw_send_whispers=(self:GetChecked() or false) end,{'fuckingOptions_g','aw_send_whispers','DA_CurrentGuild'},'dkpWhispers')
		DA_Awarder.dkpWhispers.font:SetSize(190,32)
		
		DA.CreateFFGButton2(nil,DA_Awarder.AwardFrame, {"CENTER", DA_Awarder.AwardFrame, "TOPLEFT", 25,-100},  12,  35,  L['test'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
			FEP_Printtest()
		end)

		DA_Awarder.AwardFrame.AwardStartBtn=DA.CreateFFGButton2(nil,DA_Awarder.AwardFrame, {"CENTER", DA_Awarder.AwardFrame, "TOPLEFT", 65,-100},  12,  35,  "",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
		function(self)
			self:Disable()
			FEP_AwardEP()
		end)
		
		
		local gtypestr
		if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
			DA_Awarder.dkpWhispers:Hide()
			DA_Awarder.AwardFrame.AwardStartBtn:SetText("+EP")
			DA_Awarder.AwardFrame.Awardmodebtn,DA_Awarder.AwardFrame.AwardmodeFrame=DA.CreateFFGDropFrame(DA_Awarder.AwardFrame,"mode: +EP",15,80,{"CENTER",DA_Awarder.AwardFrame,"TOPLEFT",42,-35},50,60,"LEFT")
			gtypestr={"+EP","-EP","+GP","-GP"}
			
		elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
			DA_Awarder.AwardFrame.AwardStartBtn:SetText("+DKP")
			DA_Awarder.AwardFrame.Awardmodebtn,DA_Awarder.AwardFrame.AwardmodeFrame=DA.CreateFFGDropFrame(DA_Awarder.AwardFrame,"mode: +DKP",15,70,{"CENTER",DA_Awarder.AwardFrame,"TOPLEFT",42,-35},50,33,"LEFT")
			gtypestr={"+DKP","-DKP"}
		end
		if gtypestr then
			for i,criteria in pairs(gtypestr) do
				local btn=DA.CreateFFGButton2(nil,DA_Awarder.AwardFrame.AwardmodeFrame,{"CENTER", DA_Awarder.AwardFrame.AwardmodeFrame, "TOP", 0,0-12*i},10,40,criteria,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
					DA_Awarder.AwardFrame.Awardmodebtn:SetText('mode: '..self:GetText())
					DA_Awarder.AwardFrame.AwardStartBtn:SetText(self:GetText())
					
					for kfk=1,4 do
						if ({DA_Awarder.AwardFrame.AwardmodeFrame:GetChildren()})[kfk] then
						(({DA_Awarder.AwardFrame.AwardmodeFrame:GetChildren()})[kfk]):GetFontString():SetTextColor(0.85,1,1,1)
						end
					end
					self:GetFontString():SetTextColor(0.2,1,1,1)
					DA_Awarder.AwardFrame.AwardmodeFrame:Hide()
				end)
				if i==1 then
					btn:GetFontString():SetTextColor(0.2,1,1,1)
				end
			end
		end
		
	end
	
	DA.CreateFFGButton2(nil,DA_Awarder,{"CENTER", DA_Awarder, "BOTTOMRIGHT", -126,12},15,35,L['auto'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
		FEP_AutoCBs()
	end,'auto_cbs')
	
	DA.OptionsButtonCreater(nil,DA_Awarder,{"center", DA_Awarder, "BOTTOMRIGHT", -100,13},13,13,function(self)
		if DA_Awarder.autoopt:IsShown() then
			DA_Awarder.autoopt:Hide()
		else
			DA_Awarder.autoopt:Show()
		end
	end)
	
	DA.CheckBtnCreater(nil,DA_Awarder,{"CENTER",DA_Awarder,"BOTTOMLEFT",17,75},15,15,L['darken\noffline'],function(self) fuckingOptions.darkenoffline=(self:GetChecked() or false);FEP_GatherRaid() end,{'fuckingOptions','darkenoffline'},'darkenoffline').font:SetSize(190,32)
	
	DA_Awarder.standby_inMain=DA.CheckBtnCreater(nil,DA_Awarder,{"CENTER",DA_Awarder,"BOTTOMLEFT",17,60},15,15,L['6-8 standby'],function(self) fuckingOptions.sixeight=(self:GetChecked() or false) ;DA_Awarder.standby_inAssister:SetChecked(self:GetChecked());GuildRoster();FEP_GatherRaid()	end,{'fuckingOptions','sixeight'},'sixeightdet')
	
	DA.CheckBtnCreater(nil,DA_Awarder,{"CENTER",DA_Awarder,"BOTTOMLEFT",17,45},15,15,L['zamprocep'],function(self) fuckingOptions_g[DA_CurrentGuild].procepzamene=(self:GetChecked() or false) end,{'fuckingOptions_g','procepzamene','DA_CurrentGuild'},'procepzamene')
	DA.CreateFFGButton2(nil,DA_Awarder,{"LEFT", DA_Awarder, "BOTTOMLEFT", 15,33},13,50,L['options'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
		if DA_Awarder.ZamOptFrm:IsShown() then
			DA_Awarder.ZamOptFrm:Hide()
		else
			DA_Awarder.ZamOptFrm:Show()
			DA_Awarder.AwardFrame:Hide();DA_Awarder.getlocalsFrame:Hide()
		end
	end)
	do --zam opt
		DA_Awarder.ZamOptFrm=DA.FrameCreater(nil,DA_Awarder,160,60,{"TOPLEFT",DA_Awarder,"BOTTOMLEFT",0,-2})
		
		
		DA.FontCreater(nil,L["Get standby %"],{"LEFT",DA_Awarder.ZamOptFrm,"TOPLEFT",5,-12},DA_Awarder.ZamOptFrm,50,110,{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"},"left",{0.85,1,1,0.9})
		
		DA_Awarder.ZamOptFrm.modebtn,DA_Awarder.ZamOptFrm.modeFrame=DA.CreateFFGDropFrame(DA_Awarder.ZamOptFrm,"",12,DA_Awarder.ZamOptFrm.width-8,{"TOPLEFT",DA_Awarder.ZamOptFrm,"TOPLEFT",5,-21},DA_Awarder.ZamOptFrm.width-8,23,"TOPLEFT-right",'left')
		
		for i,j in ipairs({
		{L['From EPGP settings'],'epgp'},
		{L['Use custom'],'manual'}
		}) do 
			DA_Awarder.ZamOptFrm.modeFrame['rankbtn'..i]=DA.CreateFFGButton2(nil,DA_Awarder.ZamOptFrm.modeFrame,{"TOPLEFT", DA_Awarder.ZamOptFrm.modeFrame, "TOPLEFT", 1,10-11*i},10,DA_Awarder.ZamOptFrm.width-10,j[1],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self) 
				DA_Awarder.ZamOptFrm.modebtn:SetText(j[1])
				fuckingOptions_g[DA_CurrentGuild].standby_method=j[2]
				DA_Awarder.ZamOptFrm.modeFrame:Hide()
				if fuckingOptions_g[DA_CurrentGuild].standby_method=='epgp' then
					DA_Awarder.ZamOptFrm.manualEB:Hide()
				else
					DA_Awarder.ZamOptFrm.manualEB:Show()
				end
			end,nil,nil,'left')
			if fuckingOptions_g[DA_CurrentGuild].standby_method==j[2] then
				DA_Awarder.ZamOptFrm.modebtn:SetText(j[1])
			end
		end
		
		DA_Awarder.ZamOptFrm.manualEB=DA.EditBoxCreater2(nil,DA_Awarder.ZamOptFrm,{"TOPLEFT",DA_Awarder.ZamOptFrm,"TOPLEFT",5,-35},{30,12},fuckingOptions_g[DA_CurrentGuild].manual_procent,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","manual_procent",'DA_CurrentGuild'},1,100,true)
		if fuckingOptions_g[DA_CurrentGuild].standby_method=='epgp' then
			DA_Awarder.ZamOptFrm.manualEB:Hide()
		else
			DA_Awarder.ZamOptFrm.manualEB:Show()
		end
		
	end
	
	do --locals
		_,DA_Awarder.getlocalsFrame=DA.CreateFFGDropFrame(DA_Awarder,L['getlocals'],15,45,{"LEFT", DA_Awarder, "BOTTOMLEFT", 120,12},285,160,"BOTTOM",nil,function() DA_Awarder.ZamOptFrm:Hide();DA_Awarder.AwardFrame:Hide() end)
		
		DA_Awarder.askupdbutton=DA.CreateFFGButton2(nil,DA_Awarder.getlocalsFrame,{"CENTER",DA_Awarder.getlocalsFrame,"TOPLEFT",40,-13},12,60,L['ask guild'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
		function(self)
			self:Disable()
			DA_Awarder.appllocalsbutton:Disable()
			DA_Awarder.exportbutton:Disable()
			DA_Awarder.qdkpexportbutton:Disable()
			DA_Awarder.qdkpsyncbutton:Disable()
			FEP_AskUpd()
		end,'awlocalstt_ask')
		
		DA_Awarder.appllocalsbutton=DA.CreateFFGButton2(nil,DA_Awarder.getlocalsFrame,{"CENTER",DA_Awarder.getlocalsFrame,"TOPLEFT",100,-13},12,45,L['import'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
		function(self)
			local text=DA_Awarder.getlocalsFrame.EB:GetText()
			if text and text~="" then
				local done
				local skipped_counter
				for line in text:gmatch("[^\r\n]+") do
					if not line:find("#") then
						done=true
						local key, value = line:match("^(.-)=(.-) @")
						if key and value then
							local pers=key:match("^%s*(.-)%s*$")
							local main=value:match("^%s*(.-)%s*$")
							if pers and main and FEP_gMain[main] and not FEP_gMain[pers] and (DA.DecodeNote(FEP_gMain[main])=='m' or DA.DecodeNote(FEP_gMain[main])=='f') and ( not FEP_L_gMain[DA_CurrentGuild][pers] or FEP_L_gMain[DA_CurrentGuild][pers]~=main ) then
								FEP_L_gMain[DA_CurrentGuild][pers]=main
							else
								skipped_counter=skipped_counter and skipped_counter + 1 or 1
							end
						else
							skipped_counter=skipped_counter and skipped_counter + 1 or 1
						end
					else
						skipped_counter=skipped_counter and skipped_counter + 1 or 1
					end
				end
				if done then
					DA.Print(L['fepupdating'])
					table.wipe(DA_locals_UpdList)
					FEP_GatherRaid()
					tinsert(DA_Fep_bulk,function()  end)
					tinsert(DA_Fep_bulk,function()  if GetNumRaidMembers()==0 then else FEP_GatherRaid() end end)
					tinsert(DA_Fep_bulk,function()  end)
					tinsert(DA_Fep_bulk,function() FEP_GatherRaid() DA.Print(L['fepupddone'].." "..((skipped_counter and '|rskipped: |cffff9999'..skipped_counter) or ""));DA_Awarder.getlocalsFrame.EB:SetText('');DA_Awarder.getlocalsFrame:Hide() end)
					DA.ResumeTimer('fep')
				else
					DA_Awarder.getlocalsFrame.EB:SetText('')
				end
			end
		end,'awlocalstt_import')
		
		DA_Awarder.exportbutton=DA.CreateFFGButton2(nil,DA_Awarder.getlocalsFrame,{"CENTER",DA_Awarder.getlocalsFrame,"TOPLEFT",155,-13},12,50,L['export'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
		function(self)
			DA_Awarder.getlocalsFrame.EB:SetText('')
			
			for player,main in pairs(FEP_L_gMain[DA_CurrentGuild]) do
				if main and not FEP_gMain[player] and (DA.DecodeNote(FEP_gMain[main])=='m' or DA.DecodeNote(FEP_gMain[main])=='f') then
					if DA_Awarder.getlocalsFrame.EB:GetText()=="" then
					else
						DA_Awarder.getlocalsFrame.EB:Insert("\n")
					end
					DA_Awarder.getlocalsFrame.EB:Insert(player.."="..main.." @")
				end
			end
		end,'awlocalstt_export')
		
		
		DA_Awarder.qdkpexportbutton=DA.CreateFFGButton2(nil,DA_Awarder.getlocalsFrame,{"CENTER",DA_Awarder.getlocalsFrame,"TOPLEFT",210,-13},12,35,'qDKP','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
		function(self)
			if not GetRealmName() then
				print('error 2630: GetRealmName api not loaded yet')
				return
			end
			if QDKP2_Data then
				local p=QDKP2_Data[GetRealmName()..'-'..DA_CurrentGuild]
				if p then
					DA_Awarder.getlocalsFrame.EB:SetText('')
					tinsert(DA_Fep_bulk,
						function() 
							for player,d in pairs(p.externals) do 
								local main = d.datafield
								
								if DA_locals_UpdList[player] then
									local skip
									for _,tbx in ipairs(DA_locals_UpdList[player]) do
										if tbx[1]==main then
											skip=true
											break
										end
									end
									
									if skip then
									else
										tinsert(DA_locals_UpdList[player],{main,sender='qDKP'})
									end
								else
									DA_locals_UpdList[player]={{main,sender='qDKP'}}
								end
							end 
							FEP_UpdatePrint() 
						end)
					DarkAngel.ResumeTimer('fep')
				else
					DA.Print("guild's qDKP DB not found")
				end
			else
				DA.Print(L['qDKP addon not found'])
			end
		end,'awlocalstt_qdkp')
		
		DA_Awarder.qdkpsyncbutton=DA.CreateFFGButton2(nil,DA_Awarder.getlocalsFrame,{"CENTER",DA_Awarder.getlocalsFrame,"TOPLEFT",247,-13},12,35,'sync','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
		function(self)
			if not GetRealmName() then
				print('error 3119: GetRealmName api not loaded yet')
				return
			end
			if QDKP2_Data then
				local p=QDKP2_Data[GetRealmName()..'-'..DA_CurrentGuild]
				if p then
					if not p.externals then
						p.externals={}
					end
					local counter_new=0
					local counter_ch=0
					local counter_same=0
					
					for player,main in pairs(FEP_L_gMain[DA_CurrentGuild]) do
						if p.externals[player] then
							if p.externals[player].datafield==main then
								counter_same=counter_same+1
							else
								counter_ch=counter_ch+1
								p.externals[player].datafield=main
							end	
						else
							counter_new=counter_new+1
							p.externals[player]={}
							p.externals[player].datafield=main
						end
					
					end
					if counter_new==0 and counter_ch==0 then
						DA.Print(" |cff00ffffdone|r: no changes")
					else
						DA.Print(" |cff00ffffdone|r: "..(counter_new>0 and "|cff00ffff"..counter_new.."|r new locals " or "")..(counter_same>0 and "|cffaba9a9"..counter_same.." |cff757575same " or "")..(counter_ch>0 and "|cfffff200"..counter_ch.."|r changes " or ""))
					end
				else
					DA.Print("guild's qDKP DB not found")
				end
			else
				DA.Print(L['qDKP addon not found'])
			end
		end,'awlocalstt_qdkp_sync')
		
		if not QDKP2_Data then
			DA_Awarder.qdkpexportbutton:Hide()
			DA_Awarder.qdkpsyncbutton:Hide()
		end
		DA.ScrollBarCreater("DA_Locals_Frm",DA_Awarder.getlocalsFrame,{DA_Awarder.getlocalsFrame.width-5, DA_Awarder.getlocalsFrame.height-30},{"TOPLEFT", 5, -20},1)
		local copyfr_Scrolled=DA_Locals_Frm.scrollchild

		DA_Awarder.getlocalsFrame.EB=DA.EditBoxCreater(nil,copyfr_Scrolled,{"TOPLEFT", copyfr_Scrolled, "TOPLEFT", 5, -2},{DA_Awarder.getlocalsFrame.width-30,160},nil,true,false,{UIDarkAngelFontConsolas:GetFont(), 8},
			function(self) 		 self:ClearFocus(); self.focusgained=nil  end,
			function(self) 		 self:ClearFocus(); self.focusgained=nil  end, --enter here
			function(self) 		 self:ClearFocus(); self.focusgained=nil  end,
			function(self) 	
				self.t:SetBlendMode("BLEND")
				self.focusgained=1
			end,
			nil,nil,nil,1
		)
		
	
	end

	DA.CreateFFGButton2(nil,DA_Awarder,{"center", DA_Awarder, "BOTTOMLEFT", 40,95},13,52,L['refresh'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
		if DA_Awarder.locker.getstate() then 
			DA.Print(L['raid frames locked!'])
		end
		DA_Awarder.isinraidfont:SetText("NOT IN RAID")
		FEP_GatherRaid()
	end,nil,nil,'center')
	
	
	DA_Awarder.GiveAssistBtn=DA.CreateFFGButton2(nil,DA_Awarder,{"CENTER", DA_Awarder, "TOPLEFT", 295,-10},10,13,'A','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
		
			if GetNumRaidMembers()==0 then return end
			
			if IsRaidLeader() then
				self:Hide()
				return
			end
			
			if IsRaidOfficer() then
				self:Disable()
				SendAddonMessage("DA_assRm", 'assist_rm', "raid")
			else
				self:Disable()
				SendAddonMessage("DA_ass", 'assist', "raid")
			end
	end,'take_assistant')
	DA_Awarder.DisbandBtn=DA.CreateFFGButton2(nil,DA_Awarder,{"CENTER", DA_Awarder, "TOPLEFT", 310,-10},10,13,'R','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function() 
		
		if IsShiftKeyDown() and IsAltKeyDown() and IsControlKeyDown() then
			local myname=GetUnitName('player')
			if GetNumRaidMembers()==0 then return end
			
			if not (IsRaidLeader() or IsRaidOfficer()) then DA.Print("I am not raid leader/officer") end
			DA_Awarder.locker.setstate(1)
			SendChatMessage('raid disbanded','raid')
			for i = 1, 40 do
				
				
				local name, rank, _, _, _, _ = GetRaidRosterInfo(i)
					if name and name~=myname and (not rank or tonumber(rank)==0) then
						UninviteUnit(name)
					end
				
			end
			LeaveParty()
			
		end
	end,'disband_raid')
	
	DA_Awarder.CreateRaidBtn=DA.CreateFFGButton2(nil,DA_Awarder,{"CENTER", DA_Awarder, "TOPLEFT", 270,-18},12,60,CONVERT_TO_RAID,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function() 
		if (GetNumRaidMembers()==0 and GetNumPartyMembers()>0) then
			-- convertedToRaid=true
			ConvertToRaid()
			SetLootMethod("master","player")
			-- if not DA_Inviter or DA_Inviter.initRaidLootMethod=='m' then
				-- SetLootMethod("master","player")
			-- elseif DA_Inviter.initRaidLootMethod=='g' then
				-- SetLootMethod("group")
			-- elseif DA_Inviter.initRaidLootMethod=='f' then
				-- SetLootMethod("freeforall")
			-- end
			SetRaidDifficulty(DA_Inviter.initRaidDifficulty)
		end
	end)
	DA_Awarder.CreateRaidBtn:Show()
	
	DA.CreateFFGButton2(nil,DA_Awarder,{"CENTER", DA_Awarder, "BOTTOMRIGHT", -10,255},53,13,'c\nh\ne\nc\nk','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function() 
		
		local countplayer=0
		local countfineplayer=0
		
		local na=0
			local na_txt={}
		local newna=0
			local newna_txt={}
		local frozen=0
			local frozen_txt={}
		
		for group=1,8 do
			for i=1,5 do
			
				local frame=_G["DA_AwarderGroup"..group.."frame"..i]
				
				if frame:IsShown() 
				and frame.c 
				and frame.c.name 
				then
					local txtname=frame:GetNormalTexture():GetTexture()
					
					if txtname:find("_Yellow") then
						newna=newna+1
						countplayer=countplayer+1
						tinsert(newna_txt,frame.c.name)
					elseif txtname:find("_Blue") then
						frozen=frozen+1
						countplayer=countplayer+1
						tinsert(frozen_txt,frame.c.name)
					elseif txtname:find("_Red") then
						na=na+1
						countplayer=countplayer+1
						tinsert(na_txt,frame.c.name)
					else
						countfineplayer=countfineplayer+1
					end
				end


			end
			
		end
				

		if frozen+newna+na > 0 then
			SendChatMessage("# "..L["Do not forget to do the guild assignments:"],'raid')
			if frozen>0 then
				SendChatMessage(L["Your current values are frozen. You need to un-freeze it?"].." : ",'raid')
				for _, str in ipairs(DA.ConcatStr(frozen_txt,255," ")) do
					SendChatMessage(str,'raid')
				end
			end
			
			if newna>0 then
				SendChatMessage(L["New player in guild or not assigned tvin?"].." : ",'raid')
				for _, str in ipairs(DA.ConcatStr(newna_txt,255," ")) do
					SendChatMessage(str,'raid')
				end
			end
			
			if na>0 then
				SendChatMessage(L["Not in guild , not assigned or assigned incorrectly?"].." : ",'raid')
				for _, str in ipairs(DA.ConcatStr(na_txt,255," ")) do
					SendChatMessage(str,'raid')
				end
			end
			
			if fuckingOptions_g[DA_CurrentGuild].dkpcomm then
				SendChatMessage("# "..L["You can set your main via '?main <name>' command. You need to PM me this"],'raid')
			end
		else
		
			if countfineplayer==0 then DA.Print(L['You are not in raid']) return end
			
			DA.Print(L["Relax, nothing's broken, ease off the clicking!"])
		end
		
	end,'fep_check')
	
	
	do --roles help
		
		DA_Awarder.EPGPValues=DA.FrameCreater(nil,DA_Awarder,345,490,{"TOPLEFT", DA_Awarder, "TOPLEFT", 2.5, -2.5},nil,nil,1)
		DA_Awarder.EPGPValues:RegisterForDrag("LeftButton")
		DA_Awarder.EPGPValues:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
		DA_Awarder.EPGPValues:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end) 
		-- DA_Awarder.EPGPValues:SetFrameLevel(150)
		DA_Awarder.EPGPValues.t:SetTexture(0.03, 0.04, 0.07, 0.9)
		
		DA.CloseButtonCreater(nil,DA_Awarder.EPGPValues,{"TOPRIGHT", DA_Awarder.EPGPValues, "TOPRIGHT", -5,-5},10,10,'x')
		
		local startingpointX=10
		local diffpointPR=70
		local diffrole=110
		local diffrow=9.35
		
		local startingpointY=-10
		local startingpointY_tankheal=-470
		
		for i=1,40 do
			DA_Awarder.EPGPValues['all'..i]=DA.FontCreater(nil,'all'..i,{"LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX,startingpointY-diffrow*i},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
			DA_Awarder.EPGPValues['allPR'..i]=DA.FontCreater(nil,'allPR'..i,{"LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffpointPR,startingpointY-diffrow*i},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
			
			
			DA_Awarder.EPGPValues['meel'..i]=DA.FontCreater(nil,'meel'..i,{"LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole,startingpointY-diffrow*i},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
			DA_Awarder.EPGPValues['meelPR'..i]=DA.FontCreater(nil,'meelPR'..i,{"LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole+diffpointPR,startingpointY-diffrow*i},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
			
			DA_Awarder.EPGPValues['ranged'..i]=DA.FontCreater(nil,'ranged'..i,{"LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole*2,startingpointY-diffrow*i},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
			DA_Awarder.EPGPValues['rangedPR'..i]=DA.FontCreater(nil,'rangedPR'..i,{"LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole*2+diffpointPR,startingpointY-diffrow*i},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
		end
		DA_Awarder.EPGPValues.all=DA.FontCreater(nil,"",{"LEFT",DA_Awarder.EPGPValues.all1,"LEFT",6,9.35},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
		DA_Awarder.EPGPValues.meel=DA.FontCreater(nil,"",{"LEFT",DA_Awarder.EPGPValues.meel1,"LEFT",6,9.35},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
		DA_Awarder.EPGPValues.ranged=DA.FontCreater(nil,"",{"LEFT",DA_Awarder.EPGPValues.ranged1,"LEFT",6,9.35},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
		
		for i=1,10 do
			
			DA_Awarder.EPGPValues['tank'..i]=DA.FontCreater(nil,'tank'..i,{"LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX,450-diffrow*i},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
			DA_Awarder.EPGPValues['tankPR'..i]=DA.FontCreater(nil,'tankPR'..i,{"LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffpointPR,450-diffrow*i},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
			
			
			DA_Awarder.EPGPValues['heal'..i]=DA.FontCreater(nil,'heal'..i,{"LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole,450-diffrow*i},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
			DA_Awarder.EPGPValues['healPR'..i]=DA.FontCreater(nil,'healPR'..i,{"LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole+diffpointPR,450-diffrow*i},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
		end
		DA_Awarder.EPGPValues.tank=DA.FontCreater(nil,"",{"LEFT",DA_Awarder.EPGPValues.tank1,"LEFT",6,9.35},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
		DA_Awarder.EPGPValues.heal=DA.FontCreater(nil,"",{"LEFT",DA_Awarder.EPGPValues.heal1,"LEFT",6,9.35},DA_Awarder.EPGPValues,15,120,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})

		local function getRoleFromSH(name)
			if #DA_Awarder.raidtable>0 then
				for _,j in pairs(DA_Awarder.raidtable) do
					if j.name==name then
						return j.checkedSpec or false
					end
				end
			end
		end
		local function sort_roles(a,b)
			if not a[2] and not b[2] then
				return nil
			elseif not a[2] then
				return true
			elseif not b[2] then
				return false
			elseif a[3] and a[3]=='d' then
				return true
			elseif b[3] and b[3]=='d' then
				return false
			else
				return a[2] > b[2]
			end
		end
		local function re_render_EPGPValues()
			FEP_GatherRaid()
			
			local all_roster={}
			local melee_roster={}
			local ranged_roster={}
			local tanks_roster={}
			local healers_roster={}
			
			local meel_ranged_end
			
			local active_RR={}
			for i=1,40 do
				local name, _, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
				if name then
					active_RR[name]=i
				end
			end
			
			for i,rtE in ipairs(DA_Awarder.raidtable) do
				local name=rtE.name
				local group=rtE.group
				local class=rtE.clas
				local online=rtE.isonl
				if name then
					local value
					local special
					
					if FEP_gMain[name] then
						local typ,ep,gp,_=DA.DecodeNote(FEP_gMain[name])
						if typ=='m' then
							value=ep
						elseif typ=='f' then
							value=ep
							special='f'
						elseif typ=='t' then
							if FEP_gMain[FEP_gMain[name]] then
								local typ_t,ep_t,gp_t,_=DA.DecodeNote(FEP_gMain[FEP_gMain[name]])
								if typ_t=='m' then
									value=ep_t
								elseif typ_t=='f' then
									value=ep_t
									special='f'
								elseif typ_t=='t' then
									value=ep_t
									special='d'
								end
							end
						end
					elseif FEP_L_gMain[DA_CurrentGuild][name] and FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]] then
						local typ,ep,gp,_=DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]])
						if typ=='m' then
							value=ep
						elseif typ=='f' then
							value=ep
							special='f'
						elseif typ=='t' then
							value=ep_t
							special='d'
						end
					end
					
					local role=(LGT:GetUnitRole(name) or 
					( active_RR[name] and LGT:GetUnitRole("raid"..i) ) or 
					( getRoleFromSH(name) ) )
					
					if role and (role=='tank' or role=='healer' or role=='melee' or role=='caster') then
						if role=='tank' then
							tinsert(tanks_roster, {name,value,special,group,class,online})
						elseif role=='healer' then
							tinsert(healers_roster, {name,value,special,group,class,online})
						elseif role=='melee' then
							tinsert(melee_roster, {name,value,special,group,class,online})
						elseif role=='caster' then
							tinsert(ranged_roster, {name,value,special,group,class,online})
						end
						tinsert(all_roster, {name,true,value,special,group,class,online})
					else
						if role then
							DA.Print(L['failed to detect specialization']..":")
							DA.Print("::: "..name, role)
						end
						tinsert(all_roster, {name,false,value,special,group,class,online})
					end
				end  
			end
			
			meel_ranged_end=math.max(#melee_roster,#ranged_roster,1)
			--sorting
			table.sort(all_roster,function(a,b)
				if not a[3] and not b[3] then
					return nil
				elseif not a[3] then
					return true
				elseif not b[3] then
					return false
				elseif a[4] and a[4]=='d' then
					return true
				elseif b[4] and b[4]=='d' then
					return false
				else
					return a[3] > b[3]
				end
			end)
			
			table.sort(tanks_roster,sort_roles)
			table.sort(healers_roster,sort_roles)
			table.sort(melee_roster,sort_roles)
			table.sort(ranged_roster,sort_roles)
			
			--All
			for i=1,40 do
				if i<=#all_roster then
					local name=all_roster[i][1]
					local value=all_roster[i][3]
					local special=all_roster[i][4]
					local group=(all_roster[i][2] and 	"[".."|cff00ffff"..all_roster[i][5].."|r]" or 
														"|cfff27373["..all_roster[i][5].."]|r")
					local classcolor=DA.GetClassColorCode(all_roster[i][6])
					local online=all_roster[i][7]
					DA_Awarder.EPGPValues['all'..i]:SetText(group..classcolor..name)
					DA_Awarder.EPGPValues['all'..i]:Show()
					
					if not value then
						DA_Awarder.EPGPValues['allPR'..i]:SetText("|cffb27373N/A")
					elseif special=='d' then
						DA_Awarder.EPGPValues['allPR'..i]:SetText("|cffff88ff"..value)
					elseif special=='f' then
						DA_Awarder.EPGPValues['allPR'..i]:SetText("|cff8888ff"..value)
					else
						DA_Awarder.EPGPValues['allPR'..i]:SetText(value)
					end
					DA_Awarder.EPGPValues['allPR'..i]:Show()
				else
					DA_Awarder.EPGPValues['all'..i]:Hide()
					DA_Awarder.EPGPValues['allPR'..i]:Hide()
				end
			end
			if #all_roster==0 then
				DA_Awarder.EPGPValues['all1']:SetText("--")
				DA_Awarder.EPGPValues['all1']:Show()
				DA_Awarder.EPGPValues['allPR1']:SetText("--")
				DA_Awarder.EPGPValues['allPR1']:Show()
			end
			--Melee
			for i=1,40 do
				if i<=#melee_roster then
					local name=melee_roster[i][1]
					local value=melee_roster[i][2]
					local special=melee_roster[i][3]
					local group=melee_roster[i][4]
					local classcolor=DA.GetClassColorCode(melee_roster[i][5])
					local online=melee_roster[i][6]
					DA_Awarder.EPGPValues['meel'..i]:SetText("[|cff00ffff"..group.."|r]"..classcolor..name)
					DA_Awarder.EPGPValues['meel'..i]:Show()
					
					if not value then
						DA_Awarder.EPGPValues['meelPR'..i]:SetText("|cffb27373N/A")
					elseif special=='d' then
						DA_Awarder.EPGPValues['meelPR'..i]:SetText("|cffff88ff"..value)
					elseif special=='f' then
						DA_Awarder.EPGPValues['meelPR'..i]:SetText("|cff8888ff"..value)
					else
						DA_Awarder.EPGPValues['meelPR'..i]:SetText(value)
					end
					DA_Awarder.EPGPValues['meelPR'..i]:Show()
				else
					DA_Awarder.EPGPValues['meel'..i]:Hide()
					DA_Awarder.EPGPValues['meelPR'..i]:Hide()
				end
			end
			if #melee_roster==0 then
				DA_Awarder.EPGPValues['meel1']:SetText("--")
				DA_Awarder.EPGPValues['meel1']:Show()
				DA_Awarder.EPGPValues['meelPR1']:SetText("--")
				DA_Awarder.EPGPValues['meelPR1']:Show()
			end
			--Ranged
			for i=1,40 do
				if i<=#ranged_roster then
					local name=ranged_roster[i][1]
					local value=ranged_roster[i][2]
					local special=ranged_roster[i][3]
					local group=ranged_roster[i][4]
					local classcolor=DA.GetClassColorCode(ranged_roster[i][5])
					local online=ranged_roster[i][6]
					DA_Awarder.EPGPValues['ranged'..i]:SetText("[|cff00ffff"..group.."|r]"..classcolor..name)
					DA_Awarder.EPGPValues['ranged'..i]:Show()
					
					if not value then
						DA_Awarder.EPGPValues['rangedPR'..i]:SetText("|cffb27373N/A")
					elseif special=='d' then
						DA_Awarder.EPGPValues['rangedPR'..i]:SetText("|cffff88ff"..value)
					elseif special=='f' then
						DA_Awarder.EPGPValues['rangedPR'..i]:SetText("|cff8888ff"..value)
					else
						DA_Awarder.EPGPValues['rangedPR'..i]:SetText(value)
					end
					DA_Awarder.EPGPValues['rangedPR'..i]:Show()
				else
					DA_Awarder.EPGPValues['ranged'..i]:Hide()
					DA_Awarder.EPGPValues['rangedPR'..i]:Hide()
				end
			end
			if #ranged_roster==0 then
				DA_Awarder.EPGPValues['ranged1']:SetText("--")
				DA_Awarder.EPGPValues['ranged1']:Show()
				DA_Awarder.EPGPValues['rangedPR1']:SetText("--")
				DA_Awarder.EPGPValues['rangedPR1']:Show()
			end
			--Tank
			for i=1,10 do
				if i<=#tanks_roster then
					local name=tanks_roster[i][1]
					local value=tanks_roster[i][2]
					local special=tanks_roster[i][3]
					local group=tanks_roster[i][4]
					local classcolor=DA.GetClassColorCode(tanks_roster[i][5])
					local online=tanks_roster[i][6]
					DA_Awarder.EPGPValues['tank'..i]:SetText("[|cff00ffff"..group.."|r]"..classcolor..name)
					DA_Awarder.EPGPValues['tank'..i]:SetPoint("LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole,-diffrow*(meel_ranged_end+2.5)-diffrow*i)
					DA_Awarder.EPGPValues['tank'..i]:Show()
					
					if not value then
						DA_Awarder.EPGPValues['tankPR'..i]:SetText("|cffb27373N/A")
					elseif special=='d' then
						DA_Awarder.EPGPValues['tankPR'..i]:SetText("|cffff88ff"..value)
					elseif special=='f' then
						DA_Awarder.EPGPValues['tankPR'..i]:SetText("|cff8888ff"..value)
					else
						DA_Awarder.EPGPValues['tankPR'..i]:SetText(value)
					end
					
					
					DA_Awarder.EPGPValues['tankPR'..i]:SetPoint("LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole+diffpointPR,-diffrow*(meel_ranged_end+2.5)-diffrow*i)
					DA_Awarder.EPGPValues['tankPR'..i]:Show()
				else
					DA_Awarder.EPGPValues['tank'..i]:Hide()
					DA_Awarder.EPGPValues['tankPR'..i]:Hide()
				end
			end	
			if #tanks_roster==0 then
				DA_Awarder.EPGPValues['tank1']:SetText("--")
				DA_Awarder.EPGPValues['tank1']:SetPoint("LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole,-diffrow*(meel_ranged_end+2.5)-diffrow)
				DA_Awarder.EPGPValues['tank1']:Show()
				DA_Awarder.EPGPValues['tankPR1']:SetText("--")
				DA_Awarder.EPGPValues['tankPR1']:SetPoint("LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole+diffpointPR,-diffrow*(meel_ranged_end+2.5)-diffrow)
				DA_Awarder.EPGPValues['tankPR1']:Show()
			end
			--Healer
			for i=1,10 do	
				if i<=#healers_roster then
					local name=healers_roster[i][1]
					local value=healers_roster[i][2]
					local special=healers_roster[i][3]
					local group=healers_roster[i][4]
					local classcolor=DA.GetClassColorCode(healers_roster[i][5])
					local online=healers_roster[i][6]
					DA_Awarder.EPGPValues['heal'..i]:SetText("[|cff00ffff"..group.."|r]"..classcolor..name)
					DA_Awarder.EPGPValues['heal'..i]:SetPoint("LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole*2,-diffrow*(meel_ranged_end+2.5)-diffrow*i)
					DA_Awarder.EPGPValues['heal'..i]:Show()
					
					if not value then
						DA_Awarder.EPGPValues['healPR'..i]:SetText("|cffb27373N/A")
					elseif special=='d' then
						DA_Awarder.EPGPValues['healPR'..i]:SetText("|cffff88ff"..value)
					elseif special=='f' then
						DA_Awarder.EPGPValues['healPR'..i]:SetText("|cff8888ff"..value)
					else
						DA_Awarder.EPGPValues['healPR'..i]:SetText(value)
					end
					
					
					DA_Awarder.EPGPValues['healPR'..i]:SetPoint("LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole*2+diffpointPR,-diffrow*(meel_ranged_end+2.5)-diffrow*i)
					DA_Awarder.EPGPValues['healPR'..i]:Show()
				else
					DA_Awarder.EPGPValues['heal'..i]:Hide()
					DA_Awarder.EPGPValues['healPR'..i]:Hide()
				end
			end
			if #healers_roster==0 then
				DA_Awarder.EPGPValues['heal1']:SetText("--")
				DA_Awarder.EPGPValues['heal1']:SetPoint("LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole*2,-diffrow*(meel_ranged_end+2.5)-diffrow)
				DA_Awarder.EPGPValues['heal1']:Show()
				DA_Awarder.EPGPValues['healPR1']:SetText("--")
				DA_Awarder.EPGPValues['healPR1']:SetPoint("LEFT",DA_Awarder.EPGPValues,"TOPLEFT",startingpointX+diffrole*2+diffpointPR,-diffrow*(meel_ranged_end+2.5)-diffrow)
				DA_Awarder.EPGPValues['healPR1']:Show()
			end
			
			DA_Awarder.EPGPValues.all:SetText( (#all_roster==0 and "(|cffff88ff0|r)" or "(|cff00ffff"..#all_roster.."|r)") .. (ALL or 'All') )
			DA_Awarder.EPGPValues.meel:SetText( (#melee_roster==0 and "(|cffff88ff0|r)" or "(|cff00ffff"..#melee_roster.."|r)") .. (MELEE or 'Melees') )
			DA_Awarder.EPGPValues.ranged:SetText( (#ranged_roster==0 and "(|cffff88ff0|r)" or "(|cff00ffff"..#ranged_roster.."|r)") .. (RANGED or 'Ranged') )
			DA_Awarder.EPGPValues.tank:SetText( (#tanks_roster==0 and "(|cffff88ff0|r)" or "(|cff00ffff"..#tanks_roster.."|r)") .. (TANK or 'Tanks') )
			DA_Awarder.EPGPValues.heal:SetText( (#healers_roster==0 and "(|cffff88ff0|r)" or "(|cff00ffff"..#healers_roster.."|r)") .. (HEALER or 'Healers') )
		
			DA_Awarder.EPGPValues:Show()
		end
		local function GetRolesHelpFrame()
			local tankCount = 0
			local meleeCount = 0
			local rangedCount = 0
			local healerCount = 0
			local naCount = 0
			local zamCount = 0
			
			if GetNumRaidMembers()==0 then return L['You are not in raid'] end
			
			for i = 1, 40 do
				
				
				local name, _, subgroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
				
				if name then
					if not fuckingOptions.sixeight or subgroup<=5  then
						local role = LGT:GetUnitRole("raid"..i)
						if role == "tank" then
							tankCount = tankCount + 1
						elseif role == "melee" then
							meleeCount = meleeCount + 1
						elseif role == "caster" then
							rangedCount = rangedCount + 1
						elseif role == "healer" then
							healerCount = healerCount + 1
						else
							naCount=naCount+1
						end
					else
						zamCount=zamCount+1
					end
				end
			end
			
			-- Construct HTML content
			local htmlContent = L["Raid Role Summary"]..":\n"
			if naCount>0 then
				htmlContent=htmlContent..L["N/A spec"]..": |cffff9999"..naCount.."|r\n\n"
			end
			
			if tankCount==0 then
				htmlContent=htmlContent..TANK..": |cffff9999"..tankCount.."|r\n"
			else
				htmlContent=htmlContent..TANK..": |cffaaccff"..tankCount.."|r\n"
			end
			if meleeCount==0 then
				htmlContent=htmlContent..MELEE..": |cffff9999"..meleeCount.."|r\n"
			else
				htmlContent=htmlContent..MELEE..": |cffaaccff"..meleeCount.."|r\n"
			end
			if rangedCount==0 then
				htmlContent=htmlContent..RANGED..": |cffff9999"..rangedCount.."|r\n"
			else
				htmlContent=htmlContent..RANGED..": |cffaaccff"..rangedCount.."|r\n"
			end
			if healerCount==0 then
				htmlContent=htmlContent..HEALER..": |cffff9999"..healerCount.."|r\n"
			else
				htmlContent=htmlContent..HEALER..": |cffaaccff"..healerCount.."|r\n"
			end
			
			if zamCount>0 then
				htmlContent=htmlContent.."\n"..L["Standby"]..": |cffffa022"..zamCount.."|r\n"
			end

			htmlContent=htmlContent.."\n|cff507375<"..L["roleshelp_details"]:gsub("$1", ((DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' and 'EPGP') or (DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' and 'DKP')) ) .. ">"
			
			return htmlContent
			
			
		end

		DA_Awarder.RolesHelp=DA.CreateFFGButton2(nil,DA_Awarder,{"CENTER", DA_Awarder, "BOTTOMRIGHT", -10,195},53,13,'r\no\nl\ne\ns','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function() 
			re_render_EPGPValues()
		end)
		DA_Awarder.RolesHelp:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,GetRolesHelpFrame())
		end)
		
		DA_Awarder.RolesHelp:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
		end)
		
		
	end
		
	DA.CreateFFGButton2(nil,DA_Awarder,{"CENTER", DA_Awarder, "BOTTOMRIGHT", -10,135},53,13,'s\nt\no\nc\nk','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function() 
		if DA_Awarder.righside:IsShown() then
			DA_Awarder.righside:Hide()
		else
			FEP_GatherRaid()
			FEP_OpenSupportFrame()
			
			
			FEP_Assist.scrollbar:GetThumbTexture():Hide()
			FEP_Assist.scrollupbutton:Hide()
			FEP_Assist.scrolldownbutton:Hide()
			
		end
	end)
	
	do --saved raid
		DA_Awarder.saveraidbtn=DA.CreateFFGButton2(nil,DA_Awarder,{"CENTER", DA_Awarder, "BOTTOMLEFT", 193,85},13,35,L['save'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
			FEP_GatherRaid()
			DA.CreateSnapshot()
		end,'saveraid',nil,'center')
		
		DA.FontCreater(nil,"Snapshots",{"LEFT", DA_Awarder.saveraidbtn, "TOPLEFT", 5,7},DA_Awarder.saveraidbtn,15,80,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.85,1,1,0.9})
		
		DA_Awarder.getsavesBtn,DA_Awarder.getsavesFrame=DA.CreateFFGDropFrame(DA_Awarder,L["load"],13,35,{"CENTER", DA_Awarder, "BOTTOMLEFT", 233,85},169,90,"TOP",nil,function() re_render_saves();re_render_saves() end,nil,'loadsave')
		
		DA.ScrollBarCreater("DA_Saved_Raids",DA_Awarder.getsavesFrame,{DA_Awarder.getsavesFrame.width+5, DA_Awarder.getsavesFrame.height-3},{"TOPLEFT", DA_Awarder.getsavesFrame, "TOPLEFT", 0, -1},1)
			
	end

	DA.CreateFFGButton2(nil,DA_Awarder,{"LEFT", DA_Awarder, "BOTTOMLEFT", 175.5,68},13,75,L['clear all marks'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"},function(_,mouse)
		if mouse=="RightButton" then
			table.wipe(DA_raid_marks)
			FEP_GatherRaid()
		end
	end,'confirm_rightclick')

	DA.CreateFFGButton2(nil,DA_Awarder,{"LEFT", DA_Awarder, "BOTTOMLEFT", 175.5,51},13,75,L['reset all'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"},function(_,mouse)
		if mouse=="RightButton" then
			table.wipe(DA_raid_marks)
			DA_Awarder.locker.setstate(false)
			FEP_GatherRaid()
			FEP_GatherRaid()
		end
	end,'confirm_rightclick')
end

do --create groups
	FEP_CreateGroup(1,10,-25)
	FEP_CreateGroup(2,175,-25)
	FEP_CreateGroup(3,10,-120)
	FEP_CreateGroup(4,175,-120)
	FEP_CreateGroup(5,10,-215)
	FEP_CreateGroup(6,175,-215)
	FEP_CreateGroup(7,10,-310)
	FEP_CreateGroup(8,175,-310)
end

do --Assign frame
	DA_Awarder.AssignFrame.Pname1=DA.FontCreater(nil,"player",{"TOPLEFT", DA_Awarder.AssignFrame, "TOPLEFT", 20, -10},DA_Awarder.AssignFrame,15,180,{UIDarkAngelFontConsolas:GetFont(), 12, "OUTLINE"},'left')
	DA_Awarder.AssignFrame.Pname2=DA.FontCreater(nil,"player",{"TOPLEFT", DA_Awarder.AssignFrame, "TOPLEFT", 20, -20},DA_Awarder.AssignFrame,15,180,{UIDarkAngelFontConsolas:GetFont(), 12, "OUTLINE"},'left')
	DA_Awarder.AssignFrame.Pname3=DA.FontCreater(nil,"player",{"TOPLEFT", DA_Awarder.AssignFrame, "TOPLEFT", 20, -30},DA_Awarder.AssignFrame,15,180,{UIDarkAngelFontConsolas:GetFont(), 12, "OUTLINE"},'left')
	DA_Awarder.AssignFrame.Pname4=DA.FontCreater(nil,"player",{"TOPLEFT", DA_Awarder.AssignFrame, "TOPLEFT", 20, -40},DA_Awarder.AssignFrame,15,180,{UIDarkAngelFontConsolas:GetFont(), 12, "OUTLINE"},'left')
	DA_Awarder.AssignFrame.cmd=DA.FontCreater(nil,"player",{"CENTER", DA_Awarder.AssignFrame, "BOTTOM", 0, 30},DA_Awarder.AssignFrame,15,180,{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},'center')
	DA_Awarder.AssignFrame.EB=DA.EditBoxCreater(nil,DA_Awarder.AssignFrame,{"CENTER", DA_Awarder.AssignFrame, "BOTTOM", -20, 20},{120,10},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 10},
			function(self) 		self.t:SetBlendMode('add');self:ClearFocus();self.focusgained=nil;DA_Awarder.AssignFrame.Dropdown:Hide() end,
			function(self) 		self.t:SetBlendMode('add');self:ClearFocus(); DA.RunLogSearch(self:GetText());self.focusgained=nil;DA_Awarder.AssignFrame.Dropdown:Hide() end,
			function(self) 		self.t:SetBlendMode('add');self:ClearFocus(); self.focusgained=nil;DA_Awarder.AssignFrame.Dropdown:Hide() end,
			function(self) 	
				if self:GetParent():IsShown() then
					if FEP_gMain and ( GetNumRaidMembers()==0 or #FEP_gMain<1 ) then 
						DA.RegatherGuildNotes()
					end
					self.t:SetBlendMode("BLEND")
					self.focusgained=1; 
					if FEP_gMain then 
					DA.DropdownHint(self:GetText(),self,DA_Awarder.AssignFrame.Dropdown,"awa","FEP_gMain","officernote",DA_Awarder.AssignFrame.Dropdown,20)
					end
					if self:GetText()=="not in guild" then
						self:SetText("")
					end
				end
			end,
			function(self) 
				if self:GetParent():IsShown() and self.focusgained then 
				DA.DropdownHint(self:GetText(),self,DA_Awarder.AssignFrame.Dropdown,"awa","FEP_gMain","officernote",DA_Awarder.AssignFrame.Dropdown,20)
				end 
			end,nil,nil,1
		)
	

	DA_Awarder.AssignFrame.Dropdown=DA.FrameCreater(nil,DA_Awarder.AssignFrame.EB,160,20,{"TOPLEFT",DA_Awarder.AssignFrame.EB,"BOTTOMLEFT"})	
	
	DA_Awarder.AssignFrame.easybtn=DA.CreateFFGButton2(nil,DA_Awarder.AssignFrame,{"CENTER", DA_Awarder.AssignFrame, "BOTTOM", -30,8},  10,  55,  "",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',{"Fonts\\FRIZQT__.TTF", 7, "OUTLINE"})
	
	DA.CreateFFGButton2(nil,DA_Awarder.AssignFrame,{"CENTER", DA_Awarder.AssignFrame, "BOTTOM", 65,20},  12,  50,  L['fepassign'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',{"Fonts\\FRIZQT__.TTF", 8, "OUTLINE"},
	function(self)
		DA_Awarder.AssignFrame.EB:ClearFocus()
		local name=DA_Awarder.AssignFrame.Pname1:GetText()
		local main=DA_Awarder.AssignFrame.Pname2:GetText()
		local newmain=DA_Awarder.AssignFrame.EB:GetText()
	
		if not FEP_gMain[name] then
			
			if FEP_L_gMain[DA_CurrentGuild][name] and FEP_L_gMain[DA_CurrentGuild][name]==newmain then
			else
				
				
				if FEP_gMain[newmain] then
					local notetype=DA.DecodeNote(FEP_gMain[newmain])
					if notetype=='t' then
						if FEP_gMain[FEP_gMain[newmain]] then
							local ntt2=DA.DecodeNote(FEP_gMain[FEP_gMain[newmain]])
							if ntt2=='m' then
								FEP_L_gMain[DA_CurrentGuild][name]=FEP_gMain[newmain]
								Mod:PublishLocal(name)
							elseif ntt2=='f' then
								DA.Print(L['[OK] local created, however, main is frozen'])
								FEP_L_gMain[DA_CurrentGuild][name]=FEP_gMain[newmain]
								Mod:PublishLocal(name)
							elseif ntt2=='t' then
								DA.Print(L['this is a dublicated tvin!'].." -"..newmain.."-"..FEP_gMain[newmain].."-"..FEP_gMain[FEP_gMain[newmain]])
								if FEP_gMain[FEP_gMain[FEP_gMain[newmain]]] then
								else
									DA.Print(FEP_gMain[FEP_gMain[newmain]].." - "..L['no such player in guild'])
								end
							end
						else
							DA.Print("[OK] "..newmain.." [error] "..FEP_gMain[newmain].." "..L['no such player in guild'])
						end
						
					elseif notetype=='f' then
						DA.Print(L['[OK] local created, however, main is frozen'])
						FEP_L_gMain[DA_CurrentGuild][name]=newmain
						Mod:PublishLocal(name)
						
					elseif notetype=='m' then
						FEP_L_gMain[DA_CurrentGuild][name]=newmain
						Mod:PublishLocal(name)
					end
				else
					DA.Print(L['no such player in guild'])
					if FEP_L_gMain[DA_CurrentGuild][name] then
						DA.Print(L['local de-assigned, was assigned to'].." "..FEP_L_gMain[DA_CurrentGuild][name])
						FEP_L_gMain[DA_CurrentGuild][name]=nil
					end
				end
			end
		else
			if FEP_gMain[name] then
				if CanEditOfficerNote() then
					GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), newmain)
				else
					DA_Awarder.AssignFrame.cmd:SetText(L["I am not a guild officer"])
					DA.Print(L["I am not a guild officer"])
				end
			else
				if FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]] then
					if FEP_gMain[newmain] then
						FEP_L_gMain[DA_CurrentGuild][name]=newmain
						Mod:PublishLocal(name)
					else
						FEP_L_gMain[DA_CurrentGuild][name]=nil
					end
				else
					FEP_L_gMain[DA_CurrentGuild][name]=nil
				end
			end
		end
		GuildRoster()
		
		FEP_GatherRaid()
		tinsert(DA_Fep_bulk,function() end)
		tinsert(DA_Fep_bulk,function() end)
		tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
		DA.ResumeTimer('fep')
	end)


end


--ALL btns + Editbox

for z=1,8 do
	DA.CreateFFGButton2("FEP_SetAll"..z,DA_Awarder,{"CENTER",DA_Awarder,"TOPLEFT",71+z*11, -411},40,10,"",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
	function(self,clicktype)
		if clicktype=='LeftButton' then
			if not IsShiftKeyDown() and not IsControlKeyDown() then
				for group=1,8 do
					for player=1,5 do
						local frame=_G["DA_AwarderGroup"..group.."frame"..player]
						local cb=_G["DA_AwarderGroup"..group.."frame"..player.."CB"..z]
						
						if frame and frame.c then
							if cb then
								if self.en then
									FEP_mark_PL(frame.c.name,DA_StoredCheckboxes[DA_SelSet][z][1],false)
									cb:SetChecked(false)
								else
									FEP_mark_PL(frame.c.name,DA_StoredCheckboxes[DA_SelSet][z][1],1)
									cb:SetChecked(true)
								end
								
							end
						end
						
					end
				end
				if z==1 and FEP_ZamFrame.AwardCB then
					if self.en then
						FEP_ZamFrame.AwardCB:SetChecked(false)
					else
						FEP_ZamFrame.AwardCB:SetChecked(true)
						if #DA_Standby[DA_CurrentGuild]>0 then
							FEP_ZamFrame:Show()
						end
					end
				end
				if self.en then
					self.en=nil
				else
					self.en=1
				end
			elseif IsControlKeyDown() then
				FEP_AutoCBs(z)
				return
			end
			
		elseif clicktype=='RightButton' then
			for group=1,8 do
				for player=1,5 do
					local frame=_G["DA_AwarderGroup"..group.."frame"..player]
					local cb=_G["DA_AwarderGroup"..group.."frame"..player.."CB"..z]
					
					if frame and frame.c then
						if cb then
							if cb:GetChecked() then
								FEP_mark_PL(frame.c.name,DA_StoredCheckboxes[DA_SelSet][z][1],false)
								cb:SetChecked(false)
							else
								FEP_mark_PL(frame.c.name,DA_StoredCheckboxes[DA_SelSet][z][1],1)
								cb:SetChecked(true)
							end
							
						end
					end
					
				end
			end
			if z==1 and FEP_ZamFrame.AwardCB then
				if FEP_ZamFrame.AwardCB:GetChecked() then
					FEP_ZamFrame.AwardCB:SetChecked(false)
				else
					FEP_ZamFrame.AwardCB:SetChecked(true)
					if #DA_Standby[DA_CurrentGuild]>0 then
						FEP_ZamFrame:Show()
					end
				end
			end
		end
		
		GuildRoster()
		
		FEP_GatherRaid()
		tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
		DA.ResumeTimer('fep')
	end)
	
	_G["FEP_SetAll"..z].setnameFont=DA.FontCreater(nil,"",{"TOP", "FEP_SetAll"..z, "TOP", 0,0},_G["FEP_SetAll"..z],180,30,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'center',nil,'top')
	_G["FEP_SetAll"..z]:SetScript("OnEnter",function(self)
		alpha_on_CBs(z)
		DA.myShowTooltip(self,tostring(L['setalldescr']))
	end)
	_G["FEP_SetAll"..z]:SetScript("OnLeave",function()
		alpha_on_CBs()
		DA.myHideTooltip()
	end)
	_G["FEP_SetAll"..z].en=nil
	_G["FEP_SetAll"..z].z=z
	
	local EB=FEP_EditBoxCreater("FEP_Awardfor"..z,DA_Awarder,{"CENTER", DA_Awarder, "TOPLEFT", 275, -332-z*13},{30,12},false,false,{"Fonts\\FRIZQT__.TTF", 5.5},
		function(self) self.t:SetBlendMode("ADD"); self:ClearFocus();self:SetCursorPosition(0);self.focusgained=nil; if not tonumber(self:GetText()) then self:SetText(0) end DA_StoredCheckboxes[DA_SelSet][z][2]=self:GetText() end,
		function(self) self.t:SetBlendMode("ADD"); self:ClearFocus();self:SetCursorPosition(0);self.focusgained=nil; if not tonumber(self:GetText()) then self:SetText(0) end DA_StoredCheckboxes[DA_SelSet][z][2]=self:GetText()  end,
		function(self) self.t:SetBlendMode("ADD"); self:ClearFocus();self:SetCursorPosition(0);self.focusgained=nil; if not tonumber(self:GetText()) then self:SetText(0) end DA_StoredCheckboxes[DA_SelSet][z][2]=self:GetText()  end,
		function(self) if not tonumber(self:GetText()) then self:SetText(0) end self.t:SetBlendMode("BLEND");self.focusgained=1; end
	)
	EB:SetNumeric(true)
	
	EB.str=FEP_EditBoxCreater(nil,EB,{"LEFT",EB, "RIGHT",1,0},{50,12},false,false,{UIDarkAngelFontConsolas:GetFont(), 8},
		function(self) self.t:SetBlendMode("ADD"); self:ClearFocus();self:SetCursorPosition(0);self.focusgained=nil; Trasher(self) end,
		function(self) self.t:SetBlendMode("ADD"); self:ClearFocus();self:SetCursorPosition(0);self.focusgained=nil; Trasher(self) end,
		function(self) self.t:SetBlendMode("ADD"); self:ClearFocus();self:SetCursorPosition(0);self.focusgained=nil; Trasher(self) end,
		function(self) self.t:SetBlendMode("BLEND"); self.focusgained=1; end,
		nil,{28/255, 32/255, 50/255, 1})
	EB.str.internal=z
end

if fuckingOptions.EnableZamena then
	if EPGP then EPGP:GetModule('whisper'):Disable() end
	FEP_ZamWHframe:RegisterEvent("CHAT_MSG_WHISPER");
end

do --SETS

	-- DA.FontCreater(nil,L['criterias'],{'top',DA_Awarder.autoopt,'topleft',40,-15},DA_Awarder.autoopt,15,150,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},"center",{0.75,0.85,0.85,0.8})
	
	if not DA_SelSet then DA_SelSet='default' end
	local naborscount=countCHsets()
	
	
	DA_Awarder.naborbtn,DA_Awarder.naborFrame=DA.CreateFFGDropFrame(DA_Awarder.autoopt,DA_SelSet,13,40,{"CENTER", DA_Awarder.autoopt, "TOPLEFT", 55,-10},90,20+11*naborscount,"TOP",nil,function() DA_Awarder.boxesFrame:Hide() end)
	-- DA_Awarder.naborbtn:SetFrameLevel(182)
	DA.FontCreater(nil,L['profile'],{"RIGHT",DA_Awarder.naborbtn,"LEFT",-2,0},DA_Awarder.naborbtn,15,60,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'right',{0.75,0.85,0.85,0.8})
	
	--nabors exp
	do
		
		DA_Awarder.naborFrame.exportBtn=DA.CreateFFGButton2(nil,DA_Awarder.naborFrame,{"CENTER", DA_Awarder.naborFrame, "BOTTOM", 17,10},13,43,L['import'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self) 
			if DA_Awarder.naborFrame.exportFrame:IsShown() then
				DA_Awarder.naborFrame.exportFrame:Hide()
			else
				DA_Awarder.naborFrame.exportFrame:Show()
			end
			DA_Awarder.boxesFrame:Hide()
		end)
		
		DA_Awarder.naborFrame.exportFrame=DA.FrameCreater(nil,DA_Awarder.naborFrame,130,38,{"BOTTOMLEFT", DA_Awarder.naborFrame, "BOTTOMRIGHT", 2, 0})
		
		DA_Awarder.naborFrame.exportFrame.apply=DA.CreateFFGButton2(nil,DA_Awarder.naborFrame.exportFrame,{"CENTER",DA_Awarder.naborFrame.exportFrame,"TOPLEFT",30,-26},12,35,L['import'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
		function(self)
			if DA_Awarder.naborFrame.exportFrame.EB:GetText() and DA_Awarder.naborFrame.exportFrame.EB:GetText()~="" then
				DA_StoredCheckboxes=nil
				DA_StoredCheckboxes=DA.stringToTable(DA_Awarder.naborFrame.exportFrame.EB:GetText())
				DA_SelSet='default'
				
				resetAddboxes()
				FEP_ReNameRePushThings();FEP_ReNameRePushThings()	
				FEP_ResetAllChecks()
				FEP_RecalculateAllBtnEP()
			end
		end)
		
		DA_Awarder.naborFrame.exportFrame.exp=DA.CreateFFGButton2(nil,DA_Awarder.naborFrame.exportFrame,{"CENTER",DA_Awarder.naborFrame.exportFrame,"TOPLEFT",90,-26},12,45,L['export'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
		function(self)
			DA_Awarder.naborFrame.exportFrame.EB:SetText('')
			DA_Awarder.naborFrame.exportFrame.EB:SetText(DA.tableToString(DA_StoredCheckboxes))
			DA_Awarder.naborFrame.exportFrame.EB:SetCursorPosition(5)
		end)
		
		DA_Awarder.naborFrame.exportFrame.EB=DA.EditBoxCreater(nil,DA_Awarder.naborFrame.exportFrame,{"TOPLEFT", DA_Awarder.naborFrame.exportFrame, "TOPLEFT", 5, -2},{120,15},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 8},
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
		

	end
	
	ReRenderNaborsList()
	
	local function createnaborname()
		local cnt=1
		while DA_StoredCheckboxes['New'..cnt] do
			cnt=cnt+1
		end
		return 'New'..cnt
	end
	
	local addnabor=DA.CreateFFGButton2(nil,DA_Awarder.naborFrame,{"CENTER", DA_Awarder.naborFrame, "BOTTOM", -25,10},13,30,'+++','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self) 
		local naborscount=countCHsets()
			if naborscount>9 then DA.Print('there is too much') return end
			
			local newnaborname=createnaborname()
			
			DA_StoredCheckboxes[newnaborname]={
				{'raid',4500,
					rl={
						raid=true
					},
					cl={},
				},
				{'tank_heal',500,
					rl={
						tank=true,
						healer=true, 
					},
					cl={},
				},
				{'bis',500,
					rl={},
					cl={},
				},
			}
			DA_StoredCheckboxes_remembered[newnaborname]={
				raid={},
				tank_heal={},
				bis={},
			}
			
			ReRenderNaborsList()
	end)

	local function setnaborname(cb)
		local text=cb:GetText()
		if not text then
			DA_Awarder.naboredit:SetText(DA_SelSet)
		elseif DA_SelSet=='default' then
			DA.Print('error: cannot edit name for default set')
			DA_Awarder.naboredit:SetText(DA_SelSet)
		elseif text==DA_SelSet then
		
		elseif DA_StoredCheckboxes[text] then
			DA.Print('error: name '..text..' is already in use for another set')
			DA_Awarder.naboredit:SetText(DA_SelSet)
		elseif text:gsub('%!', ''):gsub('%@', ''):gsub('%#', ''):gsub('%$', ''):gsub('%%', ''):gsub('%^', ''):gsub('%&', ''):gsub('%*', ''):gsub('%(', ''):gsub('%)', ''):gsub('%_', ''):gsub('%=', ''):gsub('%+', ''):gsub('%-', ''):gsub('% ', '')~=text then
			DA.Print('error: !@#$%... characters and spaces are not allowed')
			DA_Awarder.naboredit:SetText(DA_SelSet)
		elseif tonumber(text:sub(1,1)) then
			DA.Print('error: first character of name cannot be number')
			DA_Awarder.naboredit:SetText(DA_SelSet)
		else
			DA_StoredCheckboxes[text]=DA_StoredCheckboxes[DA_SelSet]
			DA_StoredCheckboxes_remembered[text]=DA_StoredCheckboxes_remembered[DA_SelSet]
			DA_StoredCheckboxes[DA_SelSet]=nil
			DA_StoredCheckboxes_remembered[DA_SelSet]=nil
			DA_SelSet=text
			
			
			DA_Awarder.naborbtn:SetText(text)
			FEP_ReNameRePushThings()
			FEP_ReNameRePushThings()
		end
	end
	
	DA_Awarder.naboredit=FEP_EditBoxCreater(nil,DA_Awarder.autoopt,{"CENTER", DA_Awarder.autoopt, "TOPLEFT", 203,-10},{50,10},false,false,{UIDarkAngelFontConsolas:GetFont(), 8},
		function(self) self.t:SetBlendMode("ADD"); self:ClearFocus();self:SetCursorPosition(0); if self.focusgained then self.focusgained=nil setnaborname(self) end end,
		function(self) self.t:SetBlendMode("ADD"); self:ClearFocus();self:SetCursorPosition(0); if self.focusgained then self.focusgained=nil setnaborname(self) end end,
		function(self) self.t:SetBlendMode("ADD"); self:ClearFocus();self:SetCursorPosition(0); if self.focusgained then self.focusgained=nil setnaborname(self) end end,
		function(self) self.t:SetBlendMode("BLEND"); self.focusgained=1; end,
		nil,{28/255, 32/255, 50/255, 1})
	DA_Awarder.naboredit:Hide()
	-- DA_Awarder.naboredit:SetFrameLevel(182)
	DA_Awarder.naboredit:SetText(DA_SelSet)
	DA.FontCreater(nil,L['setname'],{"RIGHT",DA_Awarder.naboredit,"LEFT",-2,0},DA_Awarder.naboredit,15,50,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'right',{0.75,0.85,0.85,0.8})
	
	local function FEP_DopDop(n)
		if n<3 then print('error 2039') return end
		
		if n<#DA_StoredCheckboxes[DA_SelSet] then
			for i=1,8 do
				if i>n and DA_StoredCheckboxes[DA_SelSet][i] then 
					DA_StoredCheckboxes_remembered[DA_SelSet][DA_StoredCheckboxes[DA_SelSet][i][1]]=nil
					DA_StoredCheckboxes[DA_SelSet][i]=nil
				end
			end
		elseif n==#DA_StoredCheckboxes[DA_SelSet] then
		
		elseif n>#DA_StoredCheckboxes[DA_SelSet] then
			for i=1,n do
				if not DA_StoredCheckboxes[DA_SelSet][i] then 
					DA_StoredCheckboxes[DA_SelSet][i]={'cb'..i,0,rl={},cl={}}
				end
				if not DA_StoredCheckboxes_remembered[DA_SelSet][DA_StoredCheckboxes[DA_SelSet][i][1]] and DA_StoredCheckboxes[DA_SelSet][i].rl.saved then 
					DA_StoredCheckboxes_remembered[DA_SelSet][DA_StoredCheckboxes[DA_SelSet][i][1]]={}
				end
			end
		
		end
	end
	
	DA_Awarder.boxesbtn,DA_Awarder.boxesFrame=DA.CreateFFGDropFrame(DA_Awarder.autoopt,DA_SelSet,13,15,{"CENTER", DA_Awarder.autoopt, "TOPLEFT", 140,-10},85,18,"TOP",nil,function() DA_Awarder.naborFrame:Hide() end)
	
	-- DA_Awarder.boxesbtn:SetFrameLevel(182)
	DA.FontCreater(nil,L['criterias'],{"RIGHT",DA_Awarder.boxesbtn,"LEFT",-2,0},DA_Awarder.boxesbtn,15,65,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'right',{0.75,0.85,0.85,0.8})
	for h,naborname in ipairs({'3','4','5','6','7','8'}) do
			DA_Awarder.boxesFrame[naborname]=DA.CreateFFGButton2(nil,DA_Awarder.boxesFrame,{"CENTER", DA_Awarder.boxesFrame, "TOPLEFT", -7+14*h,-7},12,12,naborname,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
			function(self)
				DA_Awarder.boxesFrame:Hide()
				FEP_DopDop(tonumber(self:GetText()))
				DA_Awarder.boxesbtn:SetText(self:GetText())
				
				FEP_RecalculateAllBtnEP();FEP_ResetAllChecks()
				
				for _,bab in pairs({'3','4','5','6','7','8'}) do
					
					if DA_Awarder.boxesFrame[bab]:GetText()==tostring(#DA_StoredCheckboxes[DA_SelSet]) then
						DA_Awarder.boxesFrame[bab]:GetFontString():SetTextColor(0.2,1,1,1)
					else
						DA_Awarder.boxesFrame[bab]:GetFontString():SetTextColor(0.85,1,1,1)
					end
				end
				self:GetFontString():SetTextColor(0.2,1,1,1)
				FEP_ReNameRePushThings();FEP_ReNameRePushThings()
			end)
			if tostring(naborname)==tostring(#DA_StoredCheckboxes[DA_SelSet]) then
				DA_Awarder.boxesFrame[naborname]:GetFontString():SetTextColor(0.2,1,1,1)
			else
				DA_Awarder.boxesFrame[naborname]:GetFontString():SetTextColor(0.85,1,1,1)
			end
	end
	DA_Awarder.boxesbtn:SetText(#DA_StoredCheckboxes[DA_SelSet])
	
	DA.CheckBtnCreater(nil,DA_Awarder.autoopt,{"CENTER", DA_Awarder.autoopt, "TOPLEFT", 20,-25},15,15,L['AW_raid68'],function(self) fuckingOptions.AW_raid68=(self:GetChecked() or false) end,{'fuckingOptions','AW_raid68'},'AW_raid68')
	-- :SetFrameLevel(182)
	DA.CheckBtnCreater(nil,DA_Awarder.autoopt,{"CENTER", DA_Awarder.autoopt, "TOPLEFT", 20,-35},15,15,L['AW_roles68'],function(self) fuckingOptions.AW_roles68=(self:GetChecked() or false) end,{'fuckingOptions','AW_roles68'},'AW_roles68')
	-- :SetFrameLevel(182)
	DA.CheckBtnCreater(nil,DA_Awarder.autoopt,{"CENTER", DA_Awarder.autoopt, "TOPLEFT", 20,-45},15,15,L['AW_saved68'],function(self) fuckingOptions.AW_saved68=(self:GetChecked() or false) end,{'fuckingOptions','AW_saved68'},'AW_saved68')
	-- :SetFrameLevel(182)
	
	DA.CheckBtnCreater(nil,DA_Awarder.autoopt,{"CENTER", DA_Awarder.autoopt, "TOPLEFT", 110,-30},15,15,L['AW_skada68'],function(self) fuckingOptions.AW_skada68=(self:GetChecked() or false) end,{'fuckingOptions','AW_skada68'},'AW_skada68')
	-- :SetFrameLevel(182)
	DA_Awarder.autoopt.selectdb_BTN,DA_Awarder.autoopt.selectdb_FRM=DA.CreateFFGDropFrame(DA_Awarder.autoopt,"",13,78,{"CENTER",DA_Awarder.autoopt,"TOPLEFT",170,-45},10,80,"TOP",nil,
		function()
			for i,name in ipairs(getSkadadatabasenames()) do
				if DA_Awarder.autoopt.selectdb_FRM['scdb'..i] then
					DA_Awarder.autoopt.selectdb_FRM['scdb'..i].fs:SetText(name)
					DA_Awarder.autoopt.selectdb_FRM['scdb'..i]:SetScript("OnClick",function(self) 
						DA_Awarder.autoopt.selectdb_FRM:Hide()
						if self.fs:GetText()=='SkadaCharDB' or self.fs:GetText()=='SkadaStorageDB' then
							DA_StoredCheckboxes[DA_SelSet].skadamode=self.fs:GetText()
							DA_Awarder.autoopt.selectdb_BTN:SetText(DA_StoredCheckboxes[DA_SelSet].skadamode)
						end
					end)
					DA_Awarder.autoopt.selectdb_FRM['scdb'..i]:SetPoint("TOPLEFT", DA_Awarder.autoopt.selectdb_FRM, "TOPLEFT", 1,10-11*i)
				else
					DA_Awarder.autoopt.selectdb_FRM['scdb'..i]=DA.CreateFFGButton2(nil,DA_Awarder.autoopt.selectdb_FRM,{"TOPLEFT", DA_Awarder.autoopt.selectdb_FRM, "TOPLEFT", 1,10-11*i},10,78,name,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self) 
						DA_Awarder.autoopt.selectdb_FRM:Hide()
						if self.fs:GetText()=='SkadaCharDB' or self.fs:GetText()=='SkadaStorageDB' then
							DA_StoredCheckboxes[DA_SelSet].skadamode=self.fs:GetText()
							DA_Awarder.autoopt.selectdb_BTN:SetText(DA_StoredCheckboxes[DA_SelSet].skadamode)
						end
					end,nil,nil,'left')
				end
				DA_Awarder.autoopt.selectdb_FRM:SetSize(80,i*10)
				-- DA_Awarder.autoopt.selectdb_BTN:SetFrameLevel(140)
				-- DA_Awarder.autoopt.selectdb_FRM:SetFrameLevel(141)
				-- DA_Awarder.autoopt.selectdb_FRM['scdb'..i]:SetFrameLevel(185)
			end
		end
	)
	
	skada_db_check_if_one()
	skada_db_set()
	
	DA.FontCreater(nil,L["Skada db"],{"RIGHT",DA_Awarder.autoopt.selectdb_BTN,"LEFT",-3,0},DA_Awarder.autoopt.selectdb_BTN,15,80,{UIDarkAngelFontConsolas:GetFont(), 8,'outline'},'right',{0.85,1,1,0.8})
	
	DA.ButtonCreater(nil,DA_Awarder.autoopt,{"LEFT",DA_Awarder.autoopt.selectdb_BTN,"RIGHT",6,0},16,16,"?",'',function()
		if _G['SkadaCharDB'] then
			if _G['SkadaCharDB'].sets then
				DA.Print('SkadaCharDB |cff88ffff'..#SkadaCharDB.sets..' |rlogs stored')
			end
		else
			DA.Print('SkadaCharDB - |cffaf8888not found')
		end
		if _G['SkadaStorageDB'] then
			if _G['SkadaStorageDB'].sets then
				DA.Print('SkadaStorageDB |cff88ffff'..#SkadaStorageDB.sets..' |rlogs stored')
			end
		else
			DA.Print('SkadaStorageDB - |cffaf8888not found')
		end
	end)
	-- :SetFrameLevel(140)
				
	-- DA_Awarder.autoopt.selectdb_BTN:SetFrameLevel(140)
	-- DA_Awarder.autoopt.selectdb_FRM:SetFrameLevel(141)
	
end

do --Assister module
	DA.ScrollBarCreater("FEP_Assist",DA_Awarder.righside,{DA_Awarder.righside.width-5, DA_Awarder.righside.height-30},{"TOPLEFT", 5, -20},1)

	local assister=DA_Awarder.righside
	local assister_Scrolled=FEP_Assist.scrollchild

	DA.CheckBtnCreater(nil,assister,{"CENTER",assister,"TOPLEFT",10,-10},15,15,L['show locals'],function(self) fuckingOptions.assisterlocals=(self:GetChecked() or false) ;FEP_GatherRaid() end,{'fuckingOptions','assisterlocals'})
	DA_Awarder.standby_inAssister=DA.CheckBtnCreater(nil,assister,{"CENTER",assister,"TOPLEFT",140,-10},15,15,L['6-8 standby'],function(self) fuckingOptions.sixeight=(self:GetChecked() or false) ;DA_Awarder.standby_inMain:SetChecked(self:GetChecked());GuildRoster();FEP_GatherRaid()	end,{'fuckingOptions','sixeight'},nil)
	


	assister.EB1=DA.EditBoxCreater(nil,assister_Scrolled,{"TOPLEFT", assister_Scrolled, "TOPLEFT", 5, -10},{DA_Awarder.righside.width-30,60},nil,true,false,{UIDarkAngelFontConsolas:GetFont(), 10},
				function(self) 		self.t:SetBlendMode('add');self:ClearFocus(); self.focusgained=nil  end,
				function(self) 		self.t:SetBlendMode('add');self:ClearFocus(); self.focusgained=nil   end, --enter here
				function(self) 		self.t:SetBlendMode('add');self:ClearFocus(); self.focusgained=nil  end,
				function(self) 	
					if self:GetParent():IsShown() then
						
						self.t:SetBlendMode("BLEND")
						self.focusgained=1
					end
				end,
				nil,nil,nil,1
			)

end

DA.CreateScaler('DA_Awarder',0.8,2,{'fuckingOptions','Awarderscale'})
end


function FFGSetRCState(memberID,param2,allhide)
if memberID then
	for group=1,8 do
		for i=1,5 do
			local frame=_G["DA_AwarderGroup"..group.."frame"..i]
			if frame and frame:IsShown() and frame.c and frame.c.name and ((type(memberID)=="number" and frame.c.name==({UnitName('raid'..memberID)})[1]) or (type(memberID)=="string" and frame.c.name==memberID))then
				frame.rcicon:Show()
				if param2 then
					frame.rcicon.txt:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
					frame.rcicon:SetNormalTexture(frame.rcicon.txt)
					frame.rcicon:SetPushedTexture(frame.rcicon.txt)
					return
				else
					frame.rcicon.txt:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
					frame.rcicon:SetNormalTexture(frame.rcicon.txt)
					frame.rcicon:SetPushedTexture(frame.rcicon.txt)
					return
				end
			end
		end
	end

elseif not allhide then
	for group=1,8 do
		for i=1,5 do
			local frame=_G["DA_AwarderGroup"..group.."frame"..i]
			if frame then
				if frame:IsShown() then
					frame.rcicon:Show()
					frame.rcicon.txt:Show()
					frame.rcicon.txt:SetTexture("Interface\\RaidFrame\\ReadyCheck-Waiting")
					frame.rcicon:SetNormalTexture(frame.rcicon.txt)
					frame.rcicon:SetPushedTexture(frame.rcicon.txt)
				end
			end
		end
	end
	FFG_ShowHideLittleBttns()
	
elseif allhide then
	for group=1,8 do
		for i=1,5 do
			local frame=_G["DA_AwarderGroup"..group.."frame"..i]
			if frame then
				if frame:IsShown() then 
					frame.rcicon:Hide() 
					frame.rcicon.txt:Hide()
				end
				frame.rcicon.txt:SetTexture("Interface\\RaidFrame\\ReadyCheck-Waiting")
				frame.rcicon:SetNormalTexture(frame.rcicon.txt)
				frame.rcicon:SetPushedTexture(frame.rcicon.txt)
			end
		end
	end
	FFG_ShowHideLittleBttns(1)
end
end
function FEP_ReNameRePushThings()

	
--reset CBs positions
	for group=1,8 do
		for i=1,5 do
			for z=1,8 do
				if DA_StoredCheckboxes[DA_SelSet][z] and DA_StoredCheckboxes[DA_SelSet][z][1] then
					if _G["DA_AwarderGroup"..group.."frame"..i..'CB'..z] then
						if _G["DA_AwarderGroup"..group.."frame"..i].c and _G["DA_AwarderGroup"..group.."frame"..i].c.name then 
							_G["DA_AwarderGroup"..group.."frame"..i..'CB'..z]:Show()
						else 
							_G["DA_AwarderGroup"..group.."frame"..i..'CB'..z]:Hide() 
						end
						_G["DA_AwarderGroup"..group.."frame"..i..'CB'..z]:SetPoint("CENTER", _G["DA_AwarderGroup"..group.."frame"..i], "CENTER", -16+(8-#DA_StoredCheckboxes[DA_SelSet])*11+z*11, 0)
					else
						local chbtn=DA.CheckBtnCreater("DA_AwarderGroup"..group.."frame"..i..'CB'..z,_G["DA_AwarderGroup"..group.."frame"..i],{"CENTER", _G["DA_AwarderGroup"..group.."frame"..i], "CENTER", -16+(8-#DA_StoredCheckboxes[DA_SelSet])*11+z*11, 0},15,15,nil,function(self)
								if DA_StoredCheckboxes[DA_SelSet][z].rl.saved then
									DA_StoredCheckboxes_remembered[DA_SelSet][DA_StoredCheckboxes[DA_SelSet][z][1]][_G["DA_AwarderGroup"..group.."frame"..i].c.name]=self:GetChecked()
								end
								FEP_mark_PL(_G["DA_AwarderGroup"..group.."frame"..i].c.name,DA_StoredCheckboxes[DA_SelSet][z][1],self:GetChecked())
						end)
						chbtn:SetScript("OnEnter", function(self)
							if not _G["DA_AwarderGroup"..group.."frame"..i].ismoving then
								DA.myShowTooltip(self,DA_StoredCheckboxes[DA_SelSet][z][1])
							end
						end)
						chbtn:SetScript("OnLeave", function()
							DA.myHideTooltip()
						end)
						if _G["DA_AwarderGroup"..group.."frame"..i..'CB'..z].c and _G["DA_AwarderGroup"..group.."frame"..i..'CB'..z].c.name then else _G["DA_AwarderGroup"..group.."frame"..i..'CB'..z]:Hide() end
						
					end
				else
					if _G["DA_AwarderGroup"..group.."frame"..i..'CB'..z] then
						_G["DA_AwarderGroup"..group.."frame"..i..'CB'..z]:Hide()
					end
				end
			end
		end
	end
	
	
--reset SetAll btns
	for z=1,8 do
		
		
		if DA_StoredCheckboxes[DA_SelSet][z] then
			local comb='';DA_StoredCheckboxes[DA_SelSet][z][1]:gsub(".", function(c) if ({c:gsub('[\208-\209]', '')})[2]>0 then comb=comb..c else comb=comb..c..'\n' end end)
			
			_G["FEP_SetAll"..z]:SetPoint("CENTER",DA_Awarder,"TOPLEFT",71+(8-#DA_StoredCheckboxes[DA_SelSet])*11+z*11, -411)
			_G["FEP_SetAll"..z].setnameFont:SetText(comb)
			_G["FEP_SetAll"..z]:Show()
			
			_G['FEP_Awardfor'..z]:SetPoint("CENTER", DA_Awarder, "TOPLEFT", 275, -358-(10-#DA_StoredCheckboxes[DA_SelSet])*13-z*13)
			_G['FEP_Awardfor'..z]:SetText(DA_StoredCheckboxes[DA_SelSet][z][2] or "0")
				_G['FEP_Awardfor'..z].str:SetText(DA_StoredCheckboxes[DA_SelSet][z][1] or 'cb'..z)
				_G['FEP_Awardfor'..z].str.last=DA_StoredCheckboxes[DA_SelSet][z][1] or 'cb'..z
			_G['FEP_Awardfor'..z]:Show()
		else
			_G['FEP_SetAll'..z]:Hide()
			_G['FEP_Awardfor'..z]:Hide()
		end
	
	
	end
ReRenderNaborsList()
DA.AWAutoOptions()
end

local function catch_show_frames(except)
	for i=1,8 do
		if i~=except then DA_Awarder['moverFrame'..i]:Show() end
	end
end
local function catch_hide_frames()
	for i=1,8 do DA_Awarder['moverFrame'..i]:Hide() end
end
local function catch_moving_to_Grp()
	for i=1,8 do
		if DA_Awarder['moverFrame'..i]:IsMouseOver() then
			return i
		end
	end
end
local function FEP_QeuePlayerGroupTransfer(name,group)
-- print(name,group)
tinsert(DA_PlayerMoverList,{name,group})
	DA.ResumeTimer('raid_mover')
end
local function catch_decide_Move(source_gr)
	-- print("[DEBUG] Entered catch_decide_Move with source_gr:", source_gr)

	local destination_gr = catch_moving_to_Grp()
	-- print("[DEBUG] destination_gr determined as:", destination_gr)

	catch_hide_frames()

	if not destination_gr or destination_gr == source_gr then
		-- print("[DEBUG] Invalid move: destination_gr is nil or same as source_gr")
		return
	end

	local source_members = DA_Awarder.array['g' .. source_gr]
	local destination_members = DA_Awarder.array['g' .. destination_gr]

	-- print("[DEBUG] source_members:", source_members, "destination_members:", destination_members)

	if source_members == 0 then
		-- print("[DEBUG] No members in source group")
		return
	end

	if IsShiftKeyDown() then
		-- print("[DEBUG] Shift key held: entering replacement mode")

		if destination_members > 3 or source_members > 3 then
			-- print("[DEBUG] Using transit group strategy")
			local transitslots = 0
			local freeslots = {}
			local slotstaken_inGrp = {}

			for gr = 8, 1, -1 do
				local count = DA_Awarder.array['g' .. gr]
				if count < 5 then
					transitslots = transitslots + math.max(0, 5 - count)
					freeslots[gr] = math.max(0, 5 - count)
					slotstaken_inGrp[gr] = 0
				else
					freeslots[gr] = false
				end
			end

			-- print("[DEBUG] Total transitslots:", transitslots)

			if transitslots == 0 then
				-- print("[DEBUG] No available transit slots")
				return
			end

			local q_from_source = {}
			local q_from_dest = {}

			for i = 1, 40 do
				local name, _, subgroup = GetRaidRosterInfo(i)
				if name then
					if subgroup == destination_gr then
						tinsert(q_from_dest, { name, source_gr })
					elseif subgroup == source_gr then
						tinsert(q_from_source, { name, destination_gr })
					end
				end
			end

			local c_from_source = #q_from_source
			local c_from_dest = #q_from_dest
			local extra_from_source = math.max(0, c_from_source - 3)
			local extra_from_dest = math.max(0, c_from_dest - 3)

			-- print("[DEBUG] q_from_source:", c_from_source, "extra:", extra_from_source)
			-- print("[DEBUG] q_from_dest:", c_from_dest, "extra:", extra_from_dest)

			if transitslots < extra_from_source + extra_from_dest then
				-- print("[DEBUG] Not enough transit slots for extras")
				return
			end

			if extra_from_source > 0 then
				for n = 1, extra_from_source do
					for i = 8, 1, -1 do
						if freeslots[i] and slotstaken_inGrp[i] < freeslots[i] then
							-- print("[DEBUG] Transit source:", q_from_source[n][1], "to group", i)
							FEP_QeuePlayerGroupTransfer(q_from_source[n][1], i)
							slotstaken_inGrp[i] = slotstaken_inGrp[i] + 1
							break
						end
					end
				end
			end

			if extra_from_dest > 0 then
				for n = 1, extra_from_dest do
					for i = 8, 1, -1 do
						if freeslots[i] and slotstaken_inGrp[i] < freeslots[i] then
							-- print("[DEBUG] Transit dest:", q_from_dest[n][1], "to group", i)
							FEP_QeuePlayerGroupTransfer(q_from_dest[n][1], i)
							slotstaken_inGrp[i] = slotstaken_inGrp[i] + 1
							break
						end
					end
				end
			end

			for i = math.max(#q_from_source, #q_from_dest), 1, -1  do
				if q_from_source[i] then
					-- print("[DEBUG] Final move:", q_from_source[i][1], "to", q_from_source[i][2])
					FEP_QeuePlayerGroupTransfer(q_from_source[i][1], q_from_source[i][2])
				end
				if q_from_dest[i] then
					-- print("[DEBUG] Final move:", q_from_dest[i][1], "to", q_from_dest[i][2])
					FEP_QeuePlayerGroupTransfer(q_from_dest[i][1], q_from_dest[i][2])
				end
			end

		else
			-- print("[DEBUG] Using direct swap strategy")

			local q_from_source = {}
			local q_from_dest = {}

			for i = 1, 40 do
				local name, _, subgroup = GetRaidRosterInfo(i)
				if subgroup == destination_gr then
					tinsert(q_from_dest, { name, source_gr })
				elseif subgroup == source_gr then
					tinsert(q_from_source, { name, destination_gr })
				end
			end

			for i = 1, math.max(#q_from_source, #q_from_dest) do
				if q_from_source[i] then
					-- print("[DEBUG] Swap source:", q_from_source[i][1], "to", q_from_source[i][2])
					FEP_QeuePlayerGroupTransfer(q_from_source[i][1], q_from_source[i][2])
				end
				if q_from_dest[i] then
					-- print("[DEBUG] Swap dest:", q_from_dest[i][1], "to", q_from_dest[i][2])
					FEP_QeuePlayerGroupTransfer(q_from_dest[i][1], q_from_dest[i][2])
				end
			end
		end
	else
		-- move mode
		-- print("[DEBUG] Normal move mode")
		if destination_members == 5 then
			-- print("[DEBUG] Destination group is full")
			return
		end

		local moving_members = 5 - destination_members
		-- print("[DEBUG] Members to move:", moving_members)

		local queued = 0

		for i = 1, 40 do
			local name, _, subgroup = GetRaidRosterInfo(i)
			if subgroup == source_gr then
				-- print("[DEBUG] Moving:", name, "to", destination_gr)
				FEP_QeuePlayerGroupTransfer(name, destination_gr)
				queued = queued + 1
				if queued == moving_members then
					break
				end
			end
		end
	end
end

function FEP_CreateGroup(number,posx,posy)
local gr  = CreateFrame("Frame", "DA_AwarderGroup"..number, DA_Awarder)
gr:SetFrameStrata("FULLSCREEN_DIALOG")
gr:SetSize(156, 80)
gr:SetPoint("TOPLEFT", DA_Awarder, "TOPLEFT", posx, posy)
gr:SetBackdropColor(1, 1, 1, 1)
local grtxt = gr:CreateTexture(nil, "BACKGROUND")
grtxt:SetAllPoints()
grtxt:SetTexture(8/255, 12/255, 20/255, 0.4);
grtxt:SetBlendMode("blend")
gr:EnableMouse(true)
gr:EnableMouseWheel(true)
gr:SetMovable(true)
gr:RegisterForDrag("LeftButton")
gr:SetScript("OnDragStart", function() DA_Awarder:StartMoving() end)
gr:SetScript("OnDragStop", function() DA_Awarder:StopMovingOrSizing() end) 

FEP_CreateGroupFrames(number)

DA_Awarder['moverFrame'..number] = DA.FrameCreater(nil,gr,156, 80,{"TOPLEFT", gr, "TOPLEFT", 0, 0})
	DA_Awarder['moverFrame'..number].t:SetTexture(0.7, 1, 1, 0.6)
	DA_Awarder['moverFrame'..number]:Hide()

DA_Awarder['moverBtn'..number] = DA.CreateFFGButton2(nil,gr,{"LEFT", gr, "TOPLEFT", 6, 5},8,50,L['party']..' '..number,'',{"Fonts\\FRIZQT__.TTF", 9, "OUTLINE"},nil,'awgrpmover','left')
DA_Awarder['moverBtn'..number]:SetMovable(true)
DA_Awarder['moverBtn'..number]:RegisterForDrag("LeftButton")
DA_Awarder['moverBtn'..number]:SetScript("OnDragStart", function(self) catch_show_frames(number); self:StartMoving(); DA.myHideTooltip() end)
DA_Awarder['moverBtn'..number]:SetScript("OnDragStop", function(self) catch_decide_Move(number);self:StopMovingOrSizing();self:ClearAllPoints();self:SetPoint("LEFT", gr, "TOPLEFT", 6, 7.5) end) 
DA_Awarder['moverBtn'..number]:SetFrameLevel(DA_Awarder['moverFrame'..number]:GetFrameLevel() +1)
DA_Awarder['moverBtn'..number]:EnableMouse(false)
end
function FEP_CreateGroupFrames(number)

for i=1,5 do
local group=_G["DA_AwarderGroup"..number]
local groupname="DA_AwarderGroup"..number
local frame=_G["DA_AwarderGroup"..number.."frame"..i]
local framename="DA_AwarderGroup"..number.."frame"..i

	DA.CreateFFGButton2((framename),group,{"TOPLEFT", group, "TOPLEFT", 1, 15-i*16},14,153,'','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 11, 'outline'},
	function(self,btntype)
			if self.c then
				if btntype=='LeftButton' then
					FEP_OpenAssignment(self.c, self.state, self.main, self.mainmain,self:GetName())
					
				elseif btntype=='RightButton' and IsShiftKeyDown() and self.state=='n' and CanGuildInvite() then
					GuildInvite(self.c.name)
				elseif btntype=='RightButton' and IsShiftKeyDown() and self.state=='f' and CanEditOfficerNote() then
					GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(self.c.name), string.sub(FEP_gMain[self.c.name],2) )
					GuildRoster()
					
					FEP_GatherRaid()
					tinsert(DA_Fep_bulk,function() end)
					tinsert(DA_Fep_bulk,function() end)
					tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
					DA.ResumeTimer('fep')
				elseif btntype=='RightButton' and IsShiftKeyDown() and self.state=='tf' and CanEditOfficerNote() then
					GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(self.main), string.sub(FEP_gMain[self.main],2) )
					GuildRoster()
					
					FEP_GatherRaid()
					tinsert(DA_Fep_bulk,function() end)
					tinsert(DA_Fep_bulk,function() end)
					tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
					DA.ResumeTimer('fep')
						
						
						
					-- GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(main), string.sub(mainmain,2))
			
			
				elseif btntype=='RightButton' and IsShiftKeyDown() and self.state=='pb' and CanEditOfficerNote() then
					if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
						GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(self.c.name), "0,0" )
					elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
						GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(self.c.name), "Net:0 Tot:0 Hrs:0" )
					end
					GuildRoster()
					
					FEP_GatherRaid()
					tinsert(DA_Fep_bulk,function() end)
					tinsert(DA_Fep_bulk,function() end)
					tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
					DA.ResumeTimer('fep')
						
				elseif btntype=='RightButton' then
					local ofnot=self.main
					if ofnot=='not in guild' then ofnot=nil end
					DAOptMenuFrame.calledfrom="DA_Awarder"
					DA.OpenOptMenu(self,self.c.name)
					
				end
				   
			end
		end
	,nil,nil,'left')
	_G[framename].storedpoint={"TOPLEFT", group, "TOPLEFT", 1, 15-i*16}
	_G[framename].storedgrp=number
	_G[framename]:EnableMouse(true)
	_G[framename]:EnableMouseWheel(true)
	_G[framename]:SetMovable(true)
	_G[framename]:SetResizable(enable)
	_G[framename]:SetMinResize(100, 100)
	_G[framename]:RegisterForDrag("LeftButton")
	_G[framename]:RegisterForClicks("AnyUp")
	-- _G[framename]:EnableKeyboard()
	-- _G[framename]:SetPropagateKeyboardInput(false)
	-- _G[framename]:SetScript("OnKeyDown", function(self,key) if key=='SHIFT' then self:GetScript("OnEnter")(self) end end)
	-- _G[framename]:SetScript("OnKeyUp", function(self,key) if key=='SHIFT' then self:GetScript("OnLeave")(self) end end)
	_G[framename]:SetScript("OnDragStart", function(...) if UnitIsRaidOfficer('player') and not DA_Awarder.locker.getstate() then _G[framename].StartMoving(...);_G[framename].ismoving=true;GameTooltip:Hide() end end)
	_G[framename]:SetScript("OnDragStop", function(self) 
			self:StopMovingOrSizing(); 
			self.ismoving=false;
		if UnitIsRaidOfficer('player') and not DA_Awarder.locker.getstate() then 
			if self:IsShown() and self.c and self.c.name then 
				for grp=1,8 do
					if _G["DA_AwarderGroup"..grp]:IsMouseOver() and grp~=self.storedgrp then
						FEP_QeuePlayerGroupTransfer(self.c.name,grp) 
						break
					end
				end
			end 
		end
			self:ClearAllPoints()
			self:SetPoint(unpack(self.storedpoint)) 
	end) 
	_G[framename]:SetScript("OnEnter", function(self)
		self:RegisterEvent('MODIFIER_STATE_CHANGED')
			if IsShiftKeyDown() and self.main and self.state and self.c and self.c.name then
				if self.state=='mnormal' or self.state=='pum' or self.state=='tnormal' or self.state=='put' then
					GameTooltip:SetOwner(self,'ANCHOR_NONE')
					GameTooltip:SetPoint('topleft',self,'bottomleft',0,-5)
					GameTooltipTextLeft1:SetFont(UIDarkAngelFontConsolas:GetFont(), 10)
					GameTooltip:SetText(DA.GetTwinsInfo(self.c.name,self.main),0.45,0.65,0.65,1)
					-- DA.myShowTooltip(self,DA.GetTwinsInfo(self.c.name,self.main))
					
					GameTooltip:Show()
				elseif self.state=='f' then
					GameTooltip:SetOwner(self,'ANCHOR_NONE')
					GameTooltip:SetPoint('topleft',self,'bottomleft',0,-5)
					GameTooltipTextLeft1:SetFont(UIDarkAngelFontConsolas:GetFont(), 10)
					GameTooltip:SetText(L['AW_frozen']..DA.GetTwinsInfo(self.c.name,self.main),0.45,0.65,0.65,1)
					GameTooltip:Show()
					-- DA.myShowTooltip(self,L['AW_frozen']..DA.GetTwinsInfo(self.c.name,self.main))
				
				elseif self.state=='tf' then
					GameTooltip:SetOwner(self,'ANCHOR_NONE')
					GameTooltip:SetPoint('topleft',self,'bottomleft',0,-5)
					GameTooltipTextLeft1:SetFont(UIDarkAngelFontConsolas:GetFont(), 10)
					GameTooltip:SetText(L['AW_frozen_main']..DA.GetTwinsInfo(self.c.name,self.main),0.45,0.65,0.65,1)
					GameTooltip:Show()
					-- DA.myShowTooltip(self,L['AW_frozen_main']..DA.GetTwinsInfo(self.c.name,self.main))
					
				elseif self.state=='pb' then
					GameTooltip:SetOwner(self,'ANCHOR_NONE')
					GameTooltip:SetPoint('topleft',self,'bottomleft',0,-5)
					GameTooltipTextLeft1:SetFont(UIDarkAngelFontConsolas:GetFont(), 10)
					if CanEditOfficerNote() then
						GameTooltip:SetText(L['AW_empty_note']..FFG_gMain[self.c.name]..L['AW_empty_note_1'],0.45,0.65,0.65,1)
						-- DA.myShowTooltip(self,L['AW_empty_note']..FFG_gMain[self.c.name]..L['AW_empty_note_1'])
					else
						GameTooltip:SetText(L['AW_empty_note']..FFG_gMain[self.c.name]..L['AW_empty_note_2'],0.45,0.65,0.65,1)
						-- DA.myShowTooltip(self,L['AW_empty_note']..FFG_gMain[self.c.name]..L['AW_empty_note_2'])
					end
					GameTooltip:Show()
					
				elseif self.state=='n' then
					GameTooltip:SetOwner(self,'ANCHOR_NONE')
					GameTooltip:SetPoint('topleft',self,'bottomleft',0,-5)
					GameTooltipTextLeft1:SetFont(UIDarkAngelFontConsolas:GetFont(), 10)
					local adtxt="lol"
					if CanGuildInvite() then
						adtxt=L['AW_not_in_guild1']
					else
						adtxt=L['AW_not_in_guild2']
					end
					
					local origmessg="something went wrong..."
					
					if self.main and FEP_L_gMain[DA_CurrentGuild][self.c.name] then
						if not FEP_gMain[self.main] then
							origmessg=L['AW_local_ex1']..adtxt
						elseif DA.DecodeNote(FEP_gMain[self.main])=='t' then
							--is tvink
							local ep, gp = string.match(FEP_gMain[self.main], "^(%d+).(%d+)$")
							if tonumber(ep) and tonumber(gp) then
								---tvink+ tochka v epgp
								origmessg=L['AW_local_ex2']..adtxt
							else
								local ep, gp = string.match(FEP_gMain[self.main], "^[.](%d+).(%d+)$")
								if tonumber(ep) and tonumber(gp) then
									---tvink+ tochka v epgp +main is frozen
									origmessg=L['AW_local_ex3']..adtxt
								else
									origmessg=L['AW_local_ex4']..adtxt
								end
							end
						else
							origmessg=L['AW_local_ex5']..adtxt
						end
					elseif self.main and FEP_gMain[self.c.name] then
						if DA.DecodeNote(self.main)=='t' then
							local ep, gp = string.match(self.main, "^(%d+).(%d+)$")
							if tonumber(ep) and tonumber(gp) then
								---tochka v epgp
								origmessg=L['AW_local_ex6']
							else
								local ep, gp = string.match(self.main, "^[.](%d+).(%d+)$")
								if tonumber(ep) and tonumber(gp) then
									---tochka v epgp +frozen
									origmessg=L['AW_local_ex7']
								else
									if not FEP_gMain[self.main] then
										--priv9zka k player not in guild
										origmessg=L['AW_local_ex8']
									else --is tvink
										local ep, gp = string.match(FEP_gMain[self.main], "^(%d+).(%d+)$")
										if tonumber(ep) and tonumber(gp) then
											---tvink+ tochka v epgp
											origmessg=L['AW_local_ex9']
										else
											local ep, gp = string.match(FEP_gMain[self.main], "^[.](%d+).(%d+)$")
											if tonumber(ep) and tonumber(gp) then
												---tvink+ tochka v epgp +main is frozen
												origmessg=L['AW_local_ex10']
											else
												origmessg=L['AW_local_ex11']
											end
										end
									end
								end
							end
						else
							origmessg=L['AW_local_ex12']
						end
					
					elseif self.main and (self.main=='not in guild' or not FEP_gMain[self.main]) then
						origmessg=adtxt
						
					end
					GameTooltip:SetText(origmessg,0.45,0.65,0.65,1)
					-- DA.myShowTooltip(self,origmessg)
					GameTooltip:Show()
				end
			
			elseif not IsShiftKeyDown() and GameTooltip:IsShown() then
				DA.myHideTooltip()
			end
		end)
	_G[framename]:SetScript("OnLeave", function(self)
		self:UnregisterEvent('MODIFIER_STATE_CHANGED')
		-- GameTooltip:Hide()
		-- if self.c and self.c.name then
			-- GameTooltipTextLeft1:SetFont(unpack(FEP_TT_savedfont1))
		-- end
		DA.myHideTooltip()
	end)
	_G[framename]:SetScript("OnEvent", function(self)
		if self:IsVisible() and self:IsMouseOver() and GetMouseFocus():GetName()==self:GetName() then
			self:GetScript('OnEnter')(GetMouseFocus())
		end
	end)
	
	--rcicon 
	do
		_G[framename].rcicon=DA.CreateFFGButton2(nil,_G[framename],  {"RIGHT", _G[framename], "LEFT", 4, 0},  15,  15,  "",'')
		_G[framename].rcicon.txt=DA_Awarder:CreateTexture(nil, "BACKGROUND")
		_G[framename].rcicon.txt:SetAllPoints(_G[framename].rcicon)
		_G[framename].rcicon.txt:SetTexture("Interface\\RaidFrame\\ReadyCheck-Waiting")
		_G[framename].rcicon:SetNormalTexture(_G[framename].rcicon.txt)
		_G[framename].rcicon:SetPushedTexture(_G[framename].rcicon.txt)
		_G[framename].rcicon:SetHighlightTexture('')
		-- _G[framename].rcicon:SetFrameLevel(109)
		_G[framename].rcicon:Hide()
		_G[framename].rcicon.txt:Show()
	end
	
	--RLassist 
	do
		_G[framename].rlassist=DA.CreateFFGButton2(nil,_G[framename],  {"RIGHT", _G[framename], "LEFT", 4, 3},  10,  10,  "",'')
		_G[framename].rlassist.txt=DA_Awarder:CreateTexture(nil, "BACKGROUND")
		_G[framename].rlassist.txt:SetAllPoints(_G[framename].rlassist)
		_G[framename].rlassist.txt:SetTexture("")
		_G[framename].rlassist:SetNormalTexture(_G[framename].rlassist.txt)
		_G[framename].rlassist:SetPushedTexture(_G[framename].rlassist.txt)
		_G[framename].rlassist:SetHighlightTexture('')
		-- _G[framename].rlassist:SetFrameLevel(108)
		_G[framename].rlassist:Hide()
		_G[framename].rlassist.txt:Show()
	end
	
	--MTot
	do
		_G[framename].MTot=DA.CreateFFGButton2(nil,_G[framename],  {"RIGHT", _G[framename], "LEFT", 4, -3},  10,  10,  "",'')
		_G[framename].MTot.txt=DA_Awarder:CreateTexture(nil, "BACKGROUND")
		_G[framename].MTot.txt:SetAllPoints(_G[framename].MTot)
		_G[framename].MTot.txt:SetTexture("")
		_G[framename].ismtot=0
		_G[framename].MTot:SetNormalTexture(_G[framename].MTot.txt)
		_G[framename].MTot:SetPushedTexture(_G[framename].MTot.txt)
		_G[framename].MTot:SetHighlightTexture('')
		-- _G[framename].MTot:SetFrameLevel(107)
		_G[framename].MTot:Hide()
		_G[framename].MTot.txt:Show()
	end
	
	--masterlooter
	do
		_G[framename].masterlooter=DA.CreateFFGButton2(nil,_G[framename],  {"RIGHT", _G[framename], "LEFT", -4, 0},  7,  7,  "",'')
		_G[framename].masterlooter.txt=DA_Awarder:CreateTexture(nil, "BACKGROUND")
		_G[framename].masterlooter.txt:SetAllPoints(_G[framename].masterlooter)
		_G[framename].masterlooter.txt:SetTexture("")
		_G[framename].masterlooter:SetNormalTexture(_G[framename].masterlooter.txt)
		_G[framename].masterlooter:SetPushedTexture(_G[framename].masterlooter.txt)
		_G[framename].masterlooter:SetHighlightTexture('')
		-- _G[framename].masterlooter:SetFrameLevel(106)
		_G[framename].masterlooter:Hide()
		_G[framename].masterlooter.txt:Show()
	end
	
	
	FEP_CreateCBs(framename)
end

end

function FFG_ShowHideLittleBttns(show)

if show then
	for group=1,8 do
		for i=1,5 do
			if _G["DA_AwarderGroup"..group.."frame"..i] and _G["DA_AwarderGroup"..group.."frame"..i]:IsShown() then
				_G["DA_AwarderGroup"..group.."frame"..i].rlassist:Show()
				_G["DA_AwarderGroup"..group.."frame"..i].rlassist.txt:Show()
				_G["DA_AwarderGroup"..group.."frame"..i].MTot:Show()
				_G["DA_AwarderGroup"..group.."frame"..i].MTot.txt:Show()
				_G["DA_AwarderGroup"..group.."frame"..i].masterlooter:Show()
				_G["DA_AwarderGroup"..group.."frame"..i].masterlooter.txt:Show()
			end
		end
	end
else
	for group=1,8 do
		for i=1,5 do
			if _G["DA_AwarderGroup"..group.."frame"..i] and _G["DA_AwarderGroup"..group.."frame"..i]:IsShown() then
				_G["DA_AwarderGroup"..group.."frame"..i].rlassist:Hide()
				_G["DA_AwarderGroup"..group.."frame"..i].rlassist.txt:Hide()
				_G["DA_AwarderGroup"..group.."frame"..i].MTot:Hide()
				_G["DA_AwarderGroup"..group.."frame"..i].MTot.txt:Hide()
				_G["DA_AwarderGroup"..group.."frame"..i].masterlooter:Hide()
				_G["DA_AwarderGroup"..group.."frame"..i].masterlooter.txt:Hide()
			end
		end
	end
end

end




function FEP_OpenAssignment(data, state, main, mainmain,callb)
local font1=DA_Awarder.AssignFrame.Pname1
local font2=DA_Awarder.AssignFrame.Pname2
local font3=DA_Awarder.AssignFrame.Pname3
local font4=DA_Awarder.AssignFrame.Pname4
DA_Awarder.AssignFrame.GetCalledby=callb
-- local descr=DA_Awarder.AssignFrame.Pnametitle
local eb=DA_Awarder.AssignFrame.EB
local easy=DA_Awarder.AssignFrame.easybtn
easy:SetText("")
DA_Awarder.AssignFrame.cmd:SetText('')
easy:Hide()

local name=data.name

	if state=='n' then
		easy:Hide()
		eb:SetText(main)
		font1:SetText(name)
		font2:SetText(main)
		font3:SetText(mainmain)
		font4:SetText(L['invalid note'])
		font4:SetJustifyH('left')

	elseif state=='f' then
		easy:Show()
		easy:SetText(L['un-freeze'])
		easy:SetScript("OnClick", function(self)
			if CanEditOfficerNote() then
				GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), string.sub(main,2))
				GuildRoster()
				-- self:GetParent():Hide()
				
				FEP_GatherRaid()
				tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
				DA.ResumeTimer('fep')
			else
				DA_Awarder.AssignFrame.cmd:SetText(L["I am not a guild officer"])
			end
		
		end) 
		eb:SetText(main)
		font1:SetText(name)
		font2:SetText(main)
		font3:SetText(L['frozen'])
		font3:SetJustifyH('left')
		font4:SetText("")
			
	elseif state=='tf' then
		easy:Show()
		easy:SetText(L['un-frozeeze main'])
		easy:SetScript("OnClick", function(self)
			if CanEditOfficerNote() then
				GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(main), string.sub(mainmain,2))
				GuildRoster()
				-- self:GetParent():Hide()
				
				FEP_GatherRaid()
				tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
				DA.ResumeTimer('fep')
			else
				DA_Awarder.AssignFrame.cmd:SetText(L["I am not a guild officer"])
			end
		
		end) 
		eb:SetText(main)
		font1:SetText(name)
		font2:SetText(main)
		font3:SetText(mainmain)
		font4:SetText(L['main is frozen'])
		font4:SetJustifyH('left')
		
	elseif state=='pum' then
		easy:Hide()
		eb:SetText(main)
		font1:SetText(name)
		font2:SetText(main)
		font3:SetText(L['in raid on 2+ chars'])
		font3:SetJustifyH('left')
		font4:SetText(L['this one is main'])
		font4:SetJustifyH('left')
			
	elseif state=='put' then
		easy:Hide()
		eb:SetText(main)
		font1:SetText(name)
		font2:SetText(main)
		font3:SetText(L['in raid on Main'])
		font3:SetJustifyH('left')
		font4:SetText(mainmain)
		
	elseif state=='mnormal' then
		easy:Hide()
		eb:SetText(main)
		font1:SetText(name)
		font2:SetText(main)
		font3:SetText("")
		font4:SetText("")
			
		
	elseif state=='tnormal' then
		easy:Hide()
		eb:SetText(main)
		font1:SetText(name)
		font2:SetText(main)
		font3:SetText(mainmain)
		font4:SetText("")
		
	elseif state=='pb' then
		eb:SetText(main)
		font1:SetText(name)
		font2:SetText(main)
		font3:SetText(L['empty note'])
		font3:SetJustifyH('left')
		font4:SetText(L['new player or not tvined?'])
		font4:SetJustifyH('left')
		
	end

DA_Awarder.AssignFrame:Show()
end



function FEP_RePackZamena()
local pplock
for chel,main in pairs(FEP_gMain) do 
	if chel and main then
		pplock=true
		break
	end
end
if not pplock then return end

local Zamena=({string.gsub("\n"..DA_Standby[DA_CurrentGuild], "\n\n", "\n")})[1]
Zamena=({string.gsub("\n"..Zamena, " ", "")})[1]
local listzam={}
local listnice={}

	for chelik in string.gmatch(Zamena, '([^\n]+)') do
		if UnitInRaid(chelik) or string.find(DA_standby_mainslist,"@"..chelik.."@") then 
			DA.Print(chelik..' '..L['removed from standby (doubled)'])
		elseif FEP_L_gMain[DA_CurrentGuild][chelik] and string.find(DA_standby_mainslist,"@"..FEP_L_gMain[DA_CurrentGuild][chelik].."@") then 
			DA.Print(chelik..' Local['..FEP_L_gMain[DA_CurrentGuild][chelik]..'] '..L['removed from standby (doubled)'])
		else
			if FEP_gMain[chelik] then
				if DA.DecodeNote(FEP_gMain[chelik])=='m' then
					if not listzam[chelik] then
						listzam[chelik]=true
						tinsert(listnice,chelik)
					else 
						DA.Print(chelik..' '..L['removed from standby (doubled)'])
					end
				elseif DA.DecodeNote(FEP_gMain[chelik])=='f' then
					DA.Print(chelik..' '..L['removed from standby (frozen)'])
					
				elseif DA.DecodeNote(FEP_gMain[chelik])=='t' then
					if FEP_gMain[FEP_gMain[chelik]] and DA.DecodeNote(FEP_gMain[FEP_gMain[chelik]])=='m' then
						if not listzam[FEP_gMain[chelik]] then
							listzam[FEP_gMain[chelik]]=true
							tinsert(listnice,FEP_gMain[chelik])
						else
							DA.Print(chelik..' Main['..FEP_gMain[chelik]..'] '..L['removed from standby (doubled)'])
						end
					elseif FEP_gMain[FEP_gMain[chelik]] and DA.DecodeNote(FEP_gMain[FEP_gMain[chelik]])=='f' then
						DA.Print(chelik..' Main['..FEP_gMain[chelik]..'] '..L['removed from standby (frozen main)'])
					else
						DA.Print(chelik..' '..L['removed from standby (bad note)'])
					end
				end
			else
				if FEP_L_gMain[DA_CurrentGuild][chelik] then
					if DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][chelik]])=='m' then
						if not listzam[FEP_L_gMain[DA_CurrentGuild][chelik]] then
							listzam[FEP_L_gMain[DA_CurrentGuild][chelik]]=true
							tinsert(listnice,FEP_L_gMain[DA_CurrentGuild][chelik])
						else
							DA.Print(chelik..' Local['..FEP_L_gMain[DA_CurrentGuild][chelik]..'] '..L['removed from standby (doubled)'])
						end
					else
						DA.Print(chelik..' Local['..FEP_L_gMain[DA_CurrentGuild][chelik]..'] '..L['removed from standby (bad note)'])
					end
				else
					DA.Print(chelik..' '..L['removed from standby (not in guild)'])
				end
			end
		end
	end
local nicezam=""
for i=1,#listnice do
nicezam=nicezam..listnice[i].."\n"
end
FEP_ZamField:SetText(nicezam)
DA_Standby[DA_CurrentGuild]=nicezam

end

function DA.GetProcAwardStandby()
	if fuckingOptions_g[DA_CurrentGuild].standby_method=='epgp' then
		return DA_Guild_Info[DA_CurrentGuild].extra1 or 1
	elseif fuckingOptions_g[DA_CurrentGuild].standby_method=='manual' then
		return fuckingOptions_g[DA_CurrentGuild].manual_procent/100 or 1
	end
end

function FEP_OpenSupportFrame()

local assister=DA_Awarder.righside
local assister_Scrolled=FEP_Assist.scrollchild
local eb1=DA_Awarder.righside.EB1

eb1:SetText('')

---6-8 party = zamena
if fuckingOptions.sixeight then
eb1:Insert('###### 6-8 '..L['group']..' ######\n')
	for group=6,8 do
		for i=1,5 do
			local btn=_G["DA_AwarderGroup"..group.."frame"..i]
			if btn.c and btn.c.name then
				local state=btn.state
				local name=btn.c.name
				local main=btn.main
				
				if state=='tnormal' or state=='mnormal' or state=='pb' then
					eb1:Insert(DA.GetTwinsInfo(name,main,1).."------------------------------------\n")
				end
			end
		end
	end
	eb1:Insert('\n\n###### '..L['Standby']..' ######\n')
else 
	eb1:Insert('###### '..L['Standby']..' ######\n')
end
--ZAMENA
for chelik in string.gmatch(DA_Standby[DA_CurrentGuild], '([^\n]+)') do
	if FEP_gMain[chelik] then
		eb1:Insert(DA.GetTwinsInfo(chelik,FEP_gMain[chelik],1).."------------------------------------\n")
	end
end



assister:Show()

end
function FEP_CreateCBs(button)
	for g=1,#DA_StoredCheckboxes[DA_SelSet] do
		local chbtn=DA.CheckBtnCreater(button.."CB"..g,_G[button],{"CENTER", _G[button], "CENTER", -16+(8-#DA_StoredCheckboxes[DA_SelSet])*11+g*11, 0},15,15,nil,function(self)
			if DA_StoredCheckboxes[DA_SelSet][g].rl['saved'] then
				DA_StoredCheckboxes_remembered[DA_SelSet][DA_StoredCheckboxes[DA_SelSet][g][1]][_G[button].c.name]=self:GetChecked()
			end
			FEP_mark_PL(_G[button].c.name,DA_StoredCheckboxes[DA_SelSet][g][1],self:GetChecked())
		end)
		chbtn:SetScript("OnEnter", function(self)
			if not _G[button].ismoving then
				DA.myShowTooltip(self,DA_StoredCheckboxes[DA_SelSet][g][1])
			end
		end)
		chbtn:SetScript("OnLeave", function()
			DA.myHideTooltip()
		end)
	end
end
function FEP_RecalculateBtnEP(rbutton,grzxcp)
if rbutton then else print("error 690");return end
local sixeight=fuckingOptions.sixeight
_G[rbutton:GetName()]['epvalue']=0
for i=1,#DA_StoredCheckboxes[DA_SelSet] do 
	if not DA_StoredCheckboxes[DA_SelSet][i][2] then
		DA_StoredCheckboxes[DA_SelSet][i][2]=0
	end
end


for i=1,#DA_StoredCheckboxes[DA_SelSet] do
	local cb=_G[rbutton:GetName().."CB"..i]
	if cb then
		if i==1 and grzxcp>5 and sixeight and fuckingOptions_g[DA_CurrentGuild].procepzamene then
			_G[rbutton:GetName()]['epvalue']=(cb:GetChecked() or 0)* math.ceil(DA_StoredCheckboxes[DA_SelSet][i][2]*(DA.GetProcAwardStandby()))
		elseif i==1 and grzxcp>5 and sixeight then
			_G[rbutton:GetName()]['epvalue']=(cb:GetChecked() or 0)* math.ceil(DA_StoredCheckboxes[DA_SelSet][i][2])
		else
			_G[rbutton:GetName()]['epvalue']=(_G[rbutton:GetName()]['epvalue'] + (cb:GetChecked() or 0)* DA_StoredCheckboxes[DA_SelSet][i][2])
		end
	end



end
end
function FEP_RecalculateAllBtnEP()
	for group=1,8 do
		for i=1,5 do
			FEP_RecalculateBtnEP(_G["DA_AwarderGroup"..group.."frame"..i],group)
		end
	end

end

function DA_fakeep(name,epgp,value,comment,nochat,inr)
	if not name or not epgp or not value or not comment then
	DA.Print("incorrect command. Here is an example: ")
	DA.Print("/run DA_fakeep('"..GetUnitName("player").."','ep',1000,'test')")
	DA.Print("/run DA_fakeep('"..GetUnitName("player").."','ep',1000,'test',1) --write epgp log only, no chat msg")
	return
	end

	local value1="+1"
	if value>0 then 
		value1="+"..value
	elseif value<0 then
		value1=value
	else
		DA.Print("incorrect value")
		return
	end
	
	if inr then
		if epgp=="ep" or epgp=="EP" or epgp=="e" or epgp=="E" then
			SendAddonMessage("EPGP","LOG:"..DA.GetEPGPTimestamp().."\031EP\031"..name.."\031"..comment.."\031"..value, "raid")
			if not nochat then SendChatMessage("EPGP: "..value1.." EP ("..comment..") "..L['fepfor'].." "..name,"raid") end
		elseif epgp=="gp" or epgp=="GP" or epgp=="g" or epgp=="G" then
			SendAddonMessage("EPGP","LOG:"..DA.GetEPGPTimestamp().."\031GP\031"..name.."\031"..comment.."\031"..value, "raid")
			if not nochat then SendChatMessage("EPGP: "..value1.." GP ("..comment..") "..L['fepfor'].." "..name,"raid") end
			
		else
			DA.Print("incorrect command. Here is an example: ")
			DA.Print("/run DA_fakeep('"..GetUnitName("player").."','ep',1000,'test')")
			DA.Print("/run DA_fakeep('"..GetUnitName("player").."','ep',1000,'test',1) --write epgp log only, no chat msg")
			return
		end
	else
		if epgp=="ep" or epgp=="EP" or epgp=="e" or epgp=="E" then
			SendAddonMessage("EPGP","LOG:"..DA.GetEPGPTimestamp().."\031EP\031"..name.."\031"..comment.."\031"..value, "guild")
			if not nochat then SendChatMessage("EPGP: "..value1.." EP ("..comment..") "..L['fepfor'].." "..name,"guild") end
		elseif epgp=="gp" or epgp=="GP" or epgp=="g" or epgp=="G" then
			SendAddonMessage("EPGP","LOG:"..DA.GetEPGPTimestamp().."\031GP\031"..name.."\031"..comment.."\031"..value, "guild")
			if not nochat then SendChatMessage("EPGP: "..value1.." GP ("..comment..") "..L['fepfor'].." "..name,"guild") end
			
		else
			DA.Print("incorrect command. Here is an example: ")
			DA.Print("/run DA_fakeep('"..GetUnitName("player").."','ep',1000,'test')")
			DA.Print("/run DA_fakeep('"..GetUnitName("player").."','ep',1000,'test',1) --write epgp log only, no chat msg")
			return
		end
	end
end


function FEP_Gather()
local results={}
local ignored={}
local sixeight=fuckingOptions.sixeight

DA.RegatherGuildNotes()

for group=1,8 do
	for i=1,5 do
		
		local frame=_G["DA_AwarderGroup"..group.."frame"..i]
		local framen=frame:GetName()
		
		if frame:IsShown() and frame.epvalue and frame.c and frame.epvalue>0 then
			if frame.state=="tnormal" or frame.state=="mnormal" or frame.state=="pb" then
			
				local reason=""
				
				for cb=1,#DA_StoredCheckboxes[DA_SelSet] do
					if _G[framen.."CB"..cb]:GetChecked() then
						if cb==1 and group>5 and sixeight then
							reason=L['standby']
						elseif cb==1 then
							reason=DA_StoredCheckboxes[DA_SelSet][cb][1]
						elseif reason=="" then
							reason=DA_StoredCheckboxes[DA_SelSet][cb][1]
						else
							reason=reason.."+"..DA_StoredCheckboxes[DA_SelSet][cb][1]
						end
					end
					
				end
				
				if frame.state=="tnormal" then
					if FEP_L_gMain[DA_CurrentGuild][frame.c.name] then
						tinsert(results,{frame.main,frame.epvalue,reason,frame.c.name,'l'})
					else
						tinsert(results,{frame.main,frame.epvalue,reason,frame.c.name})
					end
				elseif frame.state=="mnormal" then
					tinsert(results,{frame.c.name,frame.epvalue,reason})
				elseif frame.state=="pb" then
					if DA.DecodeNote(frame.main)=='t' then
						if FEP_L_gMain[DA_CurrentGuild][frame.c.name] then
							tinsert(results,{frame.main,frame.epvalue,reason,frame.c.name,'l'})
						else
							tinsert(results,{frame.main,frame.epvalue,reason,frame.c.name})
						end
					elseif DA.DecodeNote(frame.main)=='m' then
						tinsert(results,{frame.c.name,frame.epvalue,reason})
					else
						tinsert(ignored,frame.c.name)
					end
				end
				
			else 
				tinsert(ignored,frame.c.name)
			end
		end
	end
end

if FEP_ZamFrame.AwardCB:GetChecked() then
local listzam={}
	for chelik in string.gmatch(DA_Standby[DA_CurrentGuild], '([^\n]+)') do
		if FEP_gMain[chelik] and DA.DecodeNote(FEP_gMain[chelik])=='m' and not listzam[chelik] and fuckingOptions_g[DA_CurrentGuild].procepzamene then
			tinsert(results,{chelik,DA_StoredCheckboxes[DA_SelSet][1][2]*(DA.GetProcAwardStandby()),L['standby']})
			listzam[chelik]=true
		elseif FEP_gMain[chelik] and DA.DecodeNote(FEP_gMain[chelik])=='m' and not listzam[chelik] then
			tinsert(results,{chelik,DA_StoredCheckboxes[DA_SelSet][1][2],L['standby']})
			listzam[chelik]=true
		else
			tinsert(ignored,chelik)
			DA.Print(chelik.." - "..L['removed from standby (doubled)'])
		end
	end
end


return results,ignored
end
function FEP_Printtest()
for z=1,#DA_StoredCheckboxes[DA_SelSet] do
	if _G["FEP_Awardfor"..z] and _G["FEP_Awardfor"..z]:IsShown() and _G["FEP_Awardfor"..z].str and _G["FEP_Awardfor"..z].str:IsShown() then
		if _G["FEP_Awardfor"..z].focusgained then _G["FEP_Awardfor"..z]:GetScript("OnEscapePressed")(_G["FEP_Awardfor"..z]) end
		if _G["FEP_Awardfor"..z].str.focusgained then _G["FEP_Awardfor"..z].str:GetScript("OnEscapePressed")(_G["FEP_Awardfor"..z].str) end
	end
end
ReRenderNaborsList()
GuildRoster()
FEP_GatherRaid()
FEP_GatherRaid()
if UnitInRaid('player') then else
	FEP_RecalculateAllBtnEP()
end
local results,ignored=FEP_Gather()
if #results>0 then else
	DA.Print(L['seems you forgot to enable some checks'])
	return
end
DA.Print(':::test results:::')
if DA_Awarder.AwardFrame.AwardStartBtn:GetText()=='+EP' then
	for i=1,#results do
		DA.Print("EPGP: +"..results[i][2].." EP ("..results[i][3]..") "..L['fepfor'].." "..results[i][1])
	end
elseif DA_Awarder.AwardFrame.AwardStartBtn:GetText()=='-EP' then
	for i=1,#results do
		DA.Print("EPGP: -"..results[i][2].." EP ("..results[i][3]..") "..L['fepfor'].." "..results[i][1])
	end
	
elseif DA_Awarder.AwardFrame.AwardStartBtn:GetText()=='+DKP' then
	for i=1,#results do
		DA.Print("QDKP2> "..results[i][1].." Gains "..results[i][2].." DKP ("..results[i][3]..")")
	end
elseif DA_Awarder.AwardFrame.AwardStartBtn:GetText()=='-DKP' then
	for i=1,#results do
		DA.Print("QDKP2> "..results[i][1].." Spends "..results[i][2].." DKP ("..results[i][3]..")")
	end

elseif DA_Awarder.AwardFrame.AwardStartBtn:GetText()=='+GP' then
	for i=1,#results do
		DA.Print("EPGP: +"..results[i][2].." GP ("..results[i][3]..") "..L['fepfor'].." "..results[i][1])
	end
elseif DA_Awarder.AwardFrame.AwardStartBtn:GetText()=='-GP' then
	for i=1,#results do
		DA.Print("EPGP: -"..results[i][2].." GP ("..results[i][3]..") "..L['fepfor'].." "..results[i][1])
	end
end


for i=1,#ignored do
DA.Print(ignored[i].." --"..L["ignored"])
end

if CanEditOfficerNote() then else
DA.Print(L["I am not a guild officer"]) return end


end
function FEP_AwardEP()
for z=1,#DA_StoredCheckboxes[DA_SelSet] do
	if _G["FEP_Awardfor"..z] and _G["FEP_Awardfor"..z]:IsShown() and _G["FEP_Awardfor"..z].str and _G["FEP_Awardfor"..z].str:IsShown() then
		if _G["FEP_Awardfor"..z].focusgained then _G["FEP_Awardfor"..z]:GetScript("OnEscapePressed")(_G["FEP_Awardfor"..z]) end
		if _G["FEP_Awardfor"..z].str.focusgained then _G["FEP_Awardfor"..z].str:GetScript("OnEscapePressed")(_G["FEP_Awardfor"..z].str) end
	end
end
ReRenderNaborsList()
if GetNumRaidMembers()==0 then FEP_RecalculateAllBtnEP();DA.Print('off-raid award'); end
if CanEditOfficerNote() then else
DA.Print(L["I am not a guild officer"]);DA_Awarder.AwardFrame.AwardStartBtn:Enable() return end

GuildRoster()
FEP_GatherRaid()
FEP_GatherRaid()

local results,ignored=FEP_Gather()
if #results>0 then else
	DA.Print(L['seems you forgot to enable some checks'])
	DA_Awarder.AwardFrame.AwardStartBtn:Enable()
	return
end

local mode=DA_Awarder.AwardFrame.AwardStartBtn:GetText()
if mode=="+EP" or mode=="+DKP" or mode=="+GP" or mode=="-EP" or mode=="-DKP" or mode=="-GP" then
else
	DA.Print('Unknown award mode')
	DA_Awarder.AwardFrame.AwardStartBtn:Enable()
	return
end

if DA_Awarder.LockOnAward:GetChecked() then
	DA_Awarder.locker.setstate(true)
end

if DA_Awarder.SaveOnAward:GetChecked() then
	DA.CreateSnapshot(1)
end



DA.Print(L['Awarder_start'])


			
	tinsert(DA_Fep_bulk,function()  end)
	
	tinsert(DA_Fep_bulk,function() FEP_BulkAward(DA_Awarder.AwardFrame.AwardStartBtn:GetText(), results) end)


tinsert(DA_Fep_bulk,function() 
	tinsert(DA_Fep_bulk,function() end)
end)
tinsert(DA_Fep_bulk,function() 
	tinsert(DA_Fep_bulk,function() end)
end)

if DA_Awarder.DisbandOnAward:GetChecked() then

	tinsert(DA_Fep_bulk,function()
		tinsert(DA_Fep_bulk,function() 
			local myname=GetUnitName('player')
			if GetNumRaidMembers()==0 then return end
			
			for i = 1, 40 do
				local name, rank, _, _, _, _ = GetRaidRosterInfo(i)
				if name and name~=myname and (not rank or tonumber(rank)==0) then
					UninviteUnit(name)
				end
			end
			LeaveParty()
		end) 
	end)
	tinsert(DA_Fep_bulk,function()
		tinsert(DA_Fep_bulk,function() end)
	end)
else

	tinsert(DA_Fep_bulk,function()
		tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end) 
	end)
	tinsert(DA_Fep_bulk,function()
		tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
	end)
	
end

tinsert(DA_Fep_bulk,function() 
	tinsert(DA_Fep_bulk,function() DA.Print('|cff00ffffAward complete!');DA_Awarder.AwardFrame.AwardStartBtn:Enable() end) 
end)

DA.ResumeTimer('fep')


for i=1,#ignored do
	DA.Print(DA.GetColorName(ignored[i]).." --"..L["ignored"])
end
DA_standby_mainslist="@"
if fuckingOptions.ZamenaClearAfterAward and FEP_ZamFrame.AwardCB:GetChecked() then
DA_Standby[DA_CurrentGuild]=""
end


end

function FEP_BulkAward(mode,players)
local pl_dat={}
local minus=1
if mode=="-EP" or mode=="-DKP" or mode=="-GP" then
	minus=-1
end
	
	for k=1,DA.GetNumGMembers() do
		local name, _, _, _, _, _, _, officernote = GetGuildRosterInfo(k)
		if name then
			pl_dat[name]={k,officernote}
		end
	end
	
	if (mode=="+EP" or mode=="-EP") and DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
		for i=1,#players do 
			local name=players[i][1]
			local value=players[i][2]; if mode=="-EP" then value=-value end
			local reason=players[i][3]
			local alt=players[i][4]
			local Localalt=players[i][4]
			
			if name and value and reason then
				if pl_dat[name] then
					local typ,ep,gp,hrs=DA.DecodeNote(pl_dat[name][2])
					
					if typ=='m' then
						if EPGP and EPGP_DB then
							tinsert(EPGP_DB.namespaces.log.profiles[DA_CurrentGuild].log , {DA.GetEPGPTimestamp(),'EP',name,reason,tonumber(value)})
						end

						
						
						tinsert(DA_Fep_bulk,function() 
							DA_fakeep(name,'EP',value,reason)
						end)
						
						if tonumber(ep)+tonumber(value)>=0 then
							GuildRosterSetOfficerNote(pl_dat[name][1], tostring(tonumber(ep)+tonumber(value))..","..tostring(gp) )
						else
							GuildRosterSetOfficerNote(pl_dat[name][1], "0,"..tostring(gp) )
							DA.Print((L["settingep0"]:gsub("$1",name)):gsub("$2",tonumber(ep).."/"..tonumber(value)))
							
						end

						if Localalt and UnitInRaid('player') then
							if value>0 then
								tinsert(DA_Fep_bulk,function() 
									SendChatMessage("EPGP: +"..value.." EP ("..reason..") "..alt.."["..name.."]",'raid')
								end)
							else
								tinsert(DA_Fep_bulk,function() 
									SendChatMessage("EPGP: "..value.." EP ("..reason..") "..alt.."["..name.."]",'raid')
								end)
							end
						end
					elseif typ=='f' then
						DA.Print('skipped '..name..' - frozen EPGP')
					else
						DA.Print('skipped '..name..' - bad note ('..pl_dat[name][2]..')')
					end
				end
			end
		end
		
	elseif (mode=="+GP" or mode=="-GP") and DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
		for i=1,#players do 
			local name=players[i][1]
			local value=players[i][2]; if mode=="-GP" then value=-value end
			local reason=players[i][3]
			local alt=players[i][4]
			local Localalt=players[i][4]
			
			if name and value and reason then
				if pl_dat[name] then
					local typ,ep,gp,hrs=DA.DecodeNote(pl_dat[name][2])
					
					if typ=='m' then
						if EPGP and EPGP_DB then
							tinsert(EPGP_DB.namespaces.log.profiles[DA_CurrentGuild].log , {DA.GetEPGPTimestamp(),'GP',name,reason,tonumber(value)})
						end

						
						tinsert(DA_Fep_bulk,function() 
							DA_fakeep(name,'GP',value,reason)
						end)
						
						if tonumber(gp)+tonumber(value)>=0 then
							GuildRosterSetOfficerNote(pl_dat[name][1], (tostring(ep)..","..tostring(tonumber(gp)+tonumber(value))) )
						else
							GuildRosterSetOfficerNote(pl_dat[name][1], (tostring(ep)..",0") )
							DA.Print((L["settinggp0"]:gsub("$1",name)):gsub("$2",tonumber(gp).."/"..tonumber(value)))
						end

						if Localalt and UnitInRaid('player') then
							if value>0 then
								tinsert(DA_Fep_bulk,function() 
									SendChatMessage("EPGP: +"..value.." GP ("..reason..") "..alt.."["..name.."]",'raid')
								end)
							else
								tinsert(DA_Fep_bulk,function() 
									SendChatMessage("EPGP: "..value.." GP ("..reason..") "..alt.."["..name.."]",'raid')
								end)
							end
						end
					elseif typ=='f' then
						DA.Print('skipped '..name..' - frozen EPGP')
					else
						DA.Print('skipped '..name..' - bad note ('..pl_dat[name][2]..')')
					end
				end
			end
		end
		
	elseif (mode=="+DKP" or mode=="-DKP") and DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
		for i=1,#players do 
			local name=players[i][1]
			local value=players[i][2]
			local reason=players[i][3]
			local alt=players[i][4]
			local Localalt=players[i][4]
			if name and value and reason then
				if pl_dat[name] then
					local typ,ep,gp,hrs=DA.DecodeNote(pl_dat[name][2])
					
					if typ=='m' then

						if tonumber(value*minus)>0 then
							local newnet=tostring(tonumber(ep)+tonumber(value))
							GuildRosterSetOfficerNote(pl_dat[name][1], "Net:"..newnet.." Tot:"..tostring(tonumber(gp)+tonumber(value))..((hrs and " Hrs:"..hrs) or "") )
							if fuckingOptions_g[DA_CurrentGuild].aw_send_whispers then
								tinsert(DA_Fep_bulk,function() 
									SendChatMessage("QDKP2> "..name.." Gains "..value.." DKP ("..reason..") Your new net DKP amount is "..newnet,'whisper',nil,alt or name)
								end)
							else
								tinsert(DA_Fep_bulk,function() 
									SendChatMessage("QDKP2> "..name.." Gains "..value.." DKP ("..reason..")",'guild')
								end)
							end
						else
							local newnet=tostring(tonumber(ep)-tonumber(value))
							GuildRosterSetOfficerNote(pl_dat[name][1], "Net:"..newnet.." Tot:"..tostring(tonumber(gp))..((hrs and " Hrs:"..hrs) or "") )
							if fuckingOptions_g[DA_CurrentGuild].aw_send_whispers then
								tinsert(DA_Fep_bulk,function() 
									SendChatMessage("QDKP2> "..name.." Spends "..math.abs(value).." DKP ("..reason..") Your new net DKP amount is "..newnet,'whisper',nil,alt or name)
								end)
							else
								tinsert(DA_Fep_bulk,function() 
									SendChatMessage("QDKP2> "..name.." Spends "..math.abs(value).." DKP ("..reason..")",'guild')
								end)
							end
						end
						SendAddonMessage("DA_log",name.."\031"..value.."\031"..reason, "guild")
						
						-- messages for local alts
						if not fuckingOptions_g[DA_CurrentGuild].aw_send_whispers and Localalt and UnitInRaid('player') then
							if tonumber(value*minus)>0 then
								tinsert(DA_Fep_bulk,function() 
									SendChatMessage("QDKP2> "..alt.." Gains "..value.." DKP ("..reason..")".."["..name.."]",'raid')
								end)
							else
								tinsert(DA_Fep_bulk,function() 
									SendChatMessage("QDKP2> "..alt.." Spends "..math.abs(value).." DKP ("..reason..")".."["..name.."]",'raid')
								end)
							end
						end
					else
						DA.Print('skipped '..name..' - bad note ('..pl_dat[name][2]..')')
					end
				end
			end
		end
	end
	
end


function FEP_AutoCBs(specific)

if DA_Awarder.locker.getstate() and not DA_Awarder.raidtable[1] then 
	return
end

local skadabossnames
local ranksTable
do--group skada boss names +officer
	for IDcrit,crittable in ipairs(DA_StoredCheckboxes[DA_SelSet]) do
		if crittable.rl.skada and type(crittable.rl.skada)=='table' and crittable.rl.skada.boss then
			if not skadabossnames then
				skadabossnames={}
				skadabossnames.a_counter=0
			end
			if not skadabossnames[crittable.rl.skada.boss] then
				skadabossnames[crittable.rl.skada.boss]={}
			end
			if not skadabossnames[crittable.rl.skada.boss][crittable.rl.skada.mode] then
				skadabossnames[crittable.rl.skada.boss][crittable.rl.skada.mode]={}
			end
			if crittable.rl.skada.addit then
				skadabossnames[crittable.rl.skada.boss][crittable.rl.skada.mode][crittable.rl.skada.addit]=crittable.rl.skada.addit
			end
			skadabossnames.a_counter=skadabossnames.a_counter+1
			
		end
		if not ranksTable and crittable.rl.officer and type(crittable.rl.officer)=='table' then
			if not ranksTable then
				ranksTable={}
			end
		end
	end
	ISAUHGSGASDAS=skadabossnames
end

if ranksTable then
	for k=1,DA.GetNumGMembers() do
		local name, _, rankIndex, _ = GetGuildRosterInfo(k);
		ranksTable[name]=rankIndex
	end
end

local skadaDB
do--gather skada boss DB
	if skadabossnames then
	
		skada_db_version_check()
		
		if DA_Awarder.autoopt.skadaassign.skada_version then
			skadaDB={}
			local b_counter=0
			
			local idcrt = specific or 1
			local endValue = specific and idcrt or #DA_StoredCheckboxes[DA_SelSet]
			for IDcrit = idcrt, endValue do
				local crittable=DA_StoredCheckboxes[DA_SelSet][IDcrit]
				if crittable.rl.skada and type(crittable.rl.skada)=='table' and crittable.rl.skada.boss=='total' then
					if _G[DA_StoredCheckboxes[DA_SelSet].skadamode].total then
						skadaDB['total']=_G[DA_StoredCheckboxes[DA_SelSet].skadamode].total
					end
					break
				end
			end
			
			for setID,DB in ipairs(_G[DA_StoredCheckboxes[DA_SelSet].skadamode].sets) do
				if DB.type=='raid' and DB.time>120 and skadabossnames[DB.mobname] and (not skadaDB or not skadaDB[DB.mobname]) then
					skadaDB[DB.mobname]=DB
					b_counter=b_counter+1
					if b_counter==skadabossnames.a_counter then
						break
					end
				end
			end
			
		else
			DA.Print(L['failed to determine Skada version. Report this bug'])
		end
	end
end

local Skada_Result
local Skada_Result_sorted
if skadabossnames and skadaDB then
	Skada_Result={}
	Skada_Result_sorted={}
	OKASGALSKG=skadaDB
	
	for boss,modetable in pairs(skadabossnames) do
	if boss~='a_counter' then
		if skadaDB[boss] then
			Skada_Result[boss]={}
			local combattime=skadaDB[boss].time
			
			if modetable["dmg"] 
				or modetable["dmg_dps"] 
				or modetable["dmg_specif"]
				or modetable["dmg_taken"]
				or modetable["dmg_taken_attack"]
				or modetable["healing"]
				or modetable["healing_hps"]
				or modetable["death"]
				or modetable["fails"]
				or modetable["fails_specif"]
				or modetable["dispells"]
				or modetable["dispells_specif"]
				or modetable["cc_done"]
				or modetable["cc_done_specif"]
				or modetable["sunders"] 
			then
				for _,entable in ipairs(skadaDB[boss].players) do
					if not Skada_Result[boss][entable.name] then
						Skada_Result[boss][entable.name]={}
					end
					
					if modetable["dmg"] then
						Skada_Result[boss][entable.name].dmg=entable.damage
					end
					
					if modetable["dmg_dps"] then
						Skada_Result[boss][entable.name].dmg_dps=(entable.damage and (entable.damage/combattime)) or nil
					end
					if modetable["dmg_specif"] then
						if entable.damagespells then
							if not Skada_Result[boss][entable.name].dmg_specif then
								Skada_Result[boss][entable.name].dmg_specif={}
							end
							
							for _,spelltable in pairs(entable.damagespells) do
								if spelltable and spelltable.targets then
									for target,targetdata in pairs(spelltable.targets) do
										if modetable["dmg_specif"][target] and (targetdata.total or targetdata.amount) then
											if not Skada_Result[boss][entable.name].dmg_specif[modetable["dmg_specif"][target]] then
												Skada_Result[boss][entable.name].dmg_specif[modetable["dmg_specif"][target]]=0
											end
											Skada_Result[boss][entable.name].dmg_specif[modetable["dmg_specif"][target]]=Skada_Result[boss][entable.name].dmg_specif[modetable["dmg_specif"][target]] + (targetdata.total or targetdata.amount)
										end
									end
								end
							end
						end
					end
					if modetable["dmg_taken"] then
						Skada_Result[boss][entable.name].dmg_taken=entable.damagetaken
					end
					if modetable["dmg_taken_attack"] then
						if entable.damagetakenspells then
							if not Skada_Result[boss][entable.name].dmg_taken_attack then
								Skada_Result[boss][entable.name].dmg_taken_attack={}
							end
							
							
							for spellname,spelltable in pairs(entable.damagetakenspells) do
								if modetable["dmg_taken_attack"][spellname] and (spelltable.amount or spelltable.hitamount) then
									if not Skada_Result[boss][entable.name].dmg_taken_attack[modetable["dmg_taken_attack"][spellname]] then
										Skada_Result[boss][entable.name].dmg_taken_attack[modetable["dmg_taken_attack"][spellname]]=0
									end
									Skada_Result[boss][entable.name].dmg_taken_attack[modetable["dmg_taken_attack"][spellname]]=Skada_Result[boss][entable.name].dmg_taken_attack[modetable["dmg_taken_attack"][spellname]] + (spelltable.amount or spelltable.hitamount)
								end
							end
						end
					end
					if modetable["healing"] then
						Skada_Result[boss][entable.name].healing=(entable.heal and entable.heal+(entable.absorb or 0)) or nil
					end
					if modetable["healing_hps"] then
						Skada_Result[boss][entable.name].healing_hps=(entable.heal and ((entable.heal+(entable.absorb or 0))/combattime)) or nil
					end
					if modetable["death"] then
						Skada_Result[boss][entable.name].death=entable.death
					end
					if modetable["fails"] then
						Skada_Result[boss][entable.name].fails=entable.fail
					end
					if modetable["fails_specif"] then
						if entable.failspells then
							if not Skada_Result[boss][entable.name].fails_specif then
								Skada_Result[boss][entable.name].fails_specif={}
							end
							
							for spellID,fails_numb in pairs(entable.failspells) do
								if modetable["fails_specif"][tostring(spellID)] and fails_numb then
									if not Skada_Result[boss][entable.name].fails_specif[modetable["fails_specif"][tostring(spellID)]] then
										Skada_Result[boss][entable.name].fails_specif[modetable["fails_specif"][tostring(spellID)]]=0
									end
									Skada_Result[boss][entable.name].fails_specif[modetable["fails_specif"][tostring(spellID)]]=Skada_Result[boss][entable.name].fails_specif[modetable["fails_specif"][tostring(spellID)]] + fails_numb
								end
							end
						end
					end
					if modetable["dispells"] then
						Skada_Result[boss][entable.name].dispells=entable.dispel
					end
					if modetable["dispells_specif"] then
						if entable.dispelspells then
							if not Skada_Result[boss][entable.name].dispells_specif then
								Skada_Result[boss][entable.name].dispells_specif={}
							end
							
							
							for _,cleansespelltbl in pairs(entable.dispelspells) do
								for spellID,dispelled_numb in pairs(cleansespelltbl.spells) do
									if modetable["dispells_specif"][tostring(spellID)] and dispelled_numb then
										if not Skada_Result[boss][entable.name].dispells_specif[modetable["dispells_specif"][tostring(spellID)]] then
											Skada_Result[boss][entable.name].dispells_specif[modetable["dispells_specif"][tostring(spellID)]]=0
										end
										Skada_Result[boss][entable.name].dispells_specif[modetable["dispells_specif"][tostring(spellID)]]=Skada_Result[boss][entable.name].dispells_specif[modetable["dispells_specif"][tostring(spellID)]] + dispelled_numb
									end
								end
							end
						end
					end
					if modetable["cc_done"] then
						Skada_Result[boss][entable.name].cc_done=entable.ccdone
					end
					if modetable["cc_done_specif"] then
						if entable.ccdonespells then
							if not Skada_Result[boss][entable.name].cc_done_specif then
								Skada_Result[boss][entable.name].cc_done_specif={}
							end
							
							for used_cc_id,cc_tbl in pairs(entable.ccdonespells) do
								if modetable["cc_done_specif"][tostring(used_cc_id)] and cc_tbl and cc_tbl.count then
									Skada_Result[boss][entable.name].cc_done_specif[modetable["cc_done_specif"][tostring(used_cc_id)]]=cc_tbl.count
								end
							end
						end
					end
					if modetable["sunders"]  then
						Skada_Result[boss][entable.name].sunders=entable.sunder
					end
					
				
				
				end
			end
			if modetable["dmg_taken_mob"] then
				for _,entable in ipairs(skadaDB[boss].enemies) do
					if entable.damagespells and type(entable.damagespells)=='table' and modetable["dmg_taken_mob"][entable.name] then
						for _,spellTBL in pairs(entable.damagespells) do
							if spellTBL.targets and type(spellTBL.targets)=='table' then
								for name,amounts in pairs(spellTBL.targets) do
									if name and amounts.amount then
										if not Skada_Result[boss][name] then
											Skada_Result[boss][name]={}
										end
										if not Skada_Result[boss][name].dmg_taken_mob then
											Skada_Result[boss][name].dmg_taken_mob={}
										end
										if not Skada_Result[boss][name].dmg_taken_mob[modetable["dmg_taken_mob"][entable.name]] then
											Skada_Result[boss][name].dmg_taken_mob[modetable["dmg_taken_mob"][entable.name]]=0
										end
										Skada_Result[boss][name].dmg_taken_mob[modetable["dmg_taken_mob"][entable.name]]=Skada_Result[boss][name].dmg_taken_mob[modetable["dmg_taken_mob"][entable.name]] + amounts.amount
									end
								end
							end
						end
					end
				end
			end
			
			
				
		end
	end
	end

	OKASGALSKH=Skada_Result
	
	for _,crittable in ipairs(DA_StoredCheckboxes[DA_SelSet]) do
		if crittable.rl.skada and type(crittable.rl.skada)=='table' and crittable.rl.skada.boss and crittable.rl.skada.matem and (crittable.rl.skada.matem.typ=='intop' or crittable.rl.skada.matem.typ=='notintop') and Skada_Result[crittable.rl.skada.boss] then
			local boss=crittable.rl.skada.boss
			local criteria=crittable.rl.skada.mode
			local addit=crittable.rl.skada.addit
			if not Skada_Result_sorted[boss] then
				Skada_Result_sorted[boss]={}
			end
			if not Skada_Result_sorted[boss][criteria] then
				Skada_Result_sorted[boss][criteria]={}
			end
			if addit then
				Skada_Result_sorted[boss][criteria][addit]=skada_resort_table(boss,Skada_Result[boss],criteria,addit)
			else
				Skada_Result_sorted[boss][criteria]=skada_resort_table(boss,Skada_Result[boss],criteria)
			end
			
			
		end
	end
	OKASGALSKMx=Skada_Result_sorted
		
end

if #DA_Standby[DA_CurrentGuild]>0 then
	FEP_ZamFrame:Show()
end

	for pl=1,40 do
		
		local name,subgroup,CLASS,role,isML,checkedSpec
		
		if DA_Awarder.locker.getstate() then
			if DA_Awarder.raidtable[pl] then
				name=DA_Awarder.raidtable[pl].name
				subgroup=DA_Awarder.raidtable[pl].group
				CLASS=DA_Awarder.raidtable[pl].clas
				role=DA_Awarder.raidtable[pl].tankrole or nil
				isML=DA_Awarder.raidtable[pl].masterl or nil
				checkedSpec=DA_Awarder.raidtable[pl].checkedSpec or nil
			end
				
		else
			name, _, subgroup, _, _, CLASS, _, _, _, role, isML = GetRaidRosterInfo(pl);
		end
		

		if name then
			local spec=checkedSpec or LGT:GetUnitRole(tostring(name))
			
			local idcrt = specific or 1
			local endValue = specific and idcrt or #DA_StoredCheckboxes[DA_SelSet]
			for IDcrit = idcrt, endValue do
				local crittable=DA_StoredCheckboxes[DA_SelSet][IDcrit]
				
				local passed
				
				-- raid
				if IDcrit==1 then
					if crittable.rl.raid and (subgroup<=5 or fuckingOptions.AW_raid68) then
						FEP_mark_PL(name,DA_StoredCheckboxes[DA_SelSet][IDcrit][1],1)
						passed=true
					end
				end
				
				-- leader
				if not passed and crittable.rl.leader and UnitIsPartyLeader(name) then
					FEP_mark_PL(name,DA_StoredCheckboxes[DA_SelSet][IDcrit][1],1)
					passed=true
				end
				
				-- saved
				if not passed and crittable.rl.saved and DA_StoredCheckboxes_remembered[DA_SelSet][crittable[1]][name] and (subgroup<=5 or fuckingOptions.AW_saved68) then
					FEP_mark_PL(name,DA_StoredCheckboxes[DA_SelSet][IDcrit][1],1)
					passed=true
				end
				
				-- guild rank
				if not passed and crittable.rl.officer and type(crittable.rl.officer)=='table' and (crittable.rl.officer[2] and ranksTable[name]<=crittable.rl.officer[1] or ranksTable[name]==crittable.rl.officer[1]) then
					FEP_mark_PL(name,DA_StoredCheckboxes[DA_SelSet][IDcrit][1],1)
					passed=true
				end
				
				-- role class
				if not passed and (subgroup<=5 or fuckingOptions.AW_roles68) then
					
					local roleempty = skada_isemptytbl(crittable.rl)
					local clasempty = skada_isemptytbl(crittable.cl)

					

					if roleempty and clasempty then
					else
						if roleempty then
							passed = skada_checkClass(crittable,CLASS,q,{'WARRIOR', 'DEATHKNIGHT', 'PALADIN', 'PRIEST', 'SHAMAN', 'DRUID', 'ROGUE', 'MAGE', 'WARLOCK', 'HUNTER'})
						elseif clasempty then
							passed = skada_checkRole(crittable,spec,q,role,{'tank', 'healer', 'melee', 'caster'})
						else
							local rolePassed = skada_checkRole(crittable,spec,q,role,{'tank', 'healer', 'melee', 'caster'})
							local classPassed = skada_checkClass(crittable,CLASS,q,{'WARRIOR', 'DEATHKNIGHT', 'PALADIN', 'PRIEST', 'SHAMAN', 'DRUID', 'ROGUE', 'MAGE', 'WARLOCK', 'HUNTER'})
							
							if crittable.andcl and rolePassed and classPassed or
							   (not crittable.andcl and (rolePassed or classPassed)) then
								passed = true
							end
						end
					end

					if passed then
						FEP_mark_PL(name,DA_StoredCheckboxes[DA_SelSet][IDcrit][1],1)
					end
				end
				
				
				-- Skada
				if not passed and (subgroup<=5 or fuckingOptions.AW_skada68) and crittable.rl.skada and type(crittable.rl.skada)=='table' then
				
					local boss=crittable.rl.skada.boss
					local criteria=crittable.rl.skada.mode
					local addit=crittable.rl.skada.addit
					local matem=crittable.rl.skada.matem
					
					if skada_check_if_player_passed(Skada_Result,Skada_Result_sorted,name,boss,criteria,addit,matem) then
						FEP_mark_PL(name,DA_StoredCheckboxes[DA_SelSet][IDcrit][1],1)
						passed = true
					end
				end
				
				if not passed and IsShiftKeyDown() then
					FEP_mark_PL(name,DA_StoredCheckboxes[DA_SelSet][IDcrit][1],false)
				end
				
			end
		end
	end
	
	
	
	
GuildRoster()
FEP_GatherRaid()
tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
DA.ResumeTimer('fep')
end


function FEP_Standby(self,event_name, msg, sender)
if fuckingOptions.EnableZamena then
else
FEP_ZamWHframe:UnregisterEvent("CHAT_MSG_WHISPER");
end
if GetNumRaidMembers()==0 then return end

  if not UnitInRaid("player") then return end
  
  

  if msg:sub(1, 12):lower() ~= 'epgp standby' then return end
FEP_GatherRaid()

  local member = msg:sub(13):match("([^ ]+)")
  if member then
    -- http://lua-users.org/wiki/LuaUnicode
    local firstChar, offset = member:match("([%z\1-\127\194-\244][\128-\191]*)()")
    member = firstChar:upper()..member:sub(offset):lower()
  else
    member = sender
  end
	
  -- print('member='..member)
  -- print('sender='..sender)
  if strlower(member)=='player' or strlower(sender)=='player' or 
  strlower(member)=='target' or strlower(sender)=='target' or
  strlower(member)=='targettarget' or strlower(sender)=='targettarget' or
  strlower(member)=='targettargettarget' or strlower(sender)=='targettargettarget' or
  strlower(member)=='targettargettargettarget' or strlower(sender)=='targettargettargettarget' or
  strlower(member)=='focus' or strlower(sender)=='focus' or
  strlower(member)=='focustarget' or strlower(sender)=='focustarget' or
  strlower(member)=='focustargettarget' or strlower(sender)=='focustargettarget' or
  strlower(member)=='mouseover' or strlower(sender)=='mouseover' or
  strlower(member)=='mouseovertarget' or strlower(sender)=='mouseovertarget' or
  strlower(member)=='mouseovertargettarget' or strlower(sender)=='mouseovertargettarget'
  then 
	SendChatMessage("nice one", "whisper",nil,sender)
  return end
  
	if UnitInRaid(sender) or UnitInRaid(member) then
		if FEP_gMain[sender] or FEP_gMain[member] or DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][sender]])=='m' then
			SendChatMessage(L['character already in raid'], "whisper",nil,sender) 
			return
		else
			SendChatMessage(L['character already in raid'], "whisper",nil,sender)
			return
		end
	end
	if member==sender then
		if FEP_gMain[sender] then
			if DA.DecodeNote(FEP_gMain[sender])=='m' then
				if string.find(DA_standby_mainslist,"@"..member.."@") then
					SendChatMessage(member.." "..L['is already in raid'], "whisper",nil,sender) 
				elseif string.find(DA_Standby[DA_CurrentGuild],member.."\n") then
					SendChatMessage(member.." "..L['is already on standby'], "whisper",nil,sender) 
				else
					DA_Standby[DA_CurrentGuild]=DA_Standby[DA_CurrentGuild]..sender.."\n"
					FEP_ZamField:SetText(DA_Standby[DA_CurrentGuild])
						if fuckingOptions.pricols then
							SendChatMessage(member.." "..L['added to Death Note'].." ("..FEP_GetRandomFun()..")","guild")
						else
							SendChatMessage(member.." "..L['added on standby'],"guild")
						end
					FEP_GatherRaid()
					-- DA_standby_mainslist=DA_standby_mainslist..sender.."@"
				end
				
			elseif DA.DecodeNote(FEP_gMain[sender])=='t' then
				if DA.DecodeNote(FEP_gMain[FEP_gMain[sender]])=='t' then
					SendChatMessage(L["seems you got incorrect officer note in guild (double tvin). Contact officer to fix it"], "whisper",nil,sender)
				elseif DA.DecodeNote(FEP_gMain[FEP_gMain[sender]])=='m' then
				
					if string.find(DA_standby_mainslist,"@"..FEP_gMain[sender].."@") then
						SendChatMessage(FEP_gMain[sender].." "..L['is already in raid'], "whisper",nil,sender)
					elseif string.find(DA_Standby[DA_CurrentGuild],FEP_gMain[sender].."\n") then
						SendChatMessage(FEP_gMain[sender].." "..L['is already on standby'], "whisper",nil,sender)
					else
						DA_Standby[DA_CurrentGuild]=DA_Standby[DA_CurrentGuild]..FEP_gMain[sender].."\n"
						FEP_ZamField:SetText(DA_Standby[DA_CurrentGuild])
						
							if fuckingOptions.pricols then
								SendChatMessage(member.." "..L['added to Death Note'].." ("..FEP_GetRandomFun()..")","guild")
							else
								SendChatMessage(member.." "..L['added on standby'],"guild")
							end
						
						FEP_GatherRaid()
						-- DA_standby_mainslist=DA_standby_mainslist..FEP_gMain[sender].."@"
					end
					
				elseif DA.DecodeNote(FEP_gMain[FEP_gMain[sender]])=='f' then
					SendChatMessage(L['seems your main got frozen epgp. Contact officer to fix it'], "whisper",nil,sender)
				end
				
			elseif DA.DecodeNote(FEP_gMain[sender])=='f' then
				SendChatMessage(L['seems you got frozen epgp. Contact officer to fix it'], "whisper",nil,sender)
			end
		
		elseif FEP_L_gMain[DA_CurrentGuild][sender] and FEP_gMain[FEP_L_gMain[DA_CurrentGuild][sender]] then
		
			if DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][sender]])=='m' then
			
				if string.find(DA_standby_mainslist,"@"..FEP_L_gMain[DA_CurrentGuild][sender].."@") then
					SendChatMessage(FEP_L_gMain[DA_CurrentGuild][sender].." "..L['is already in raid'], "whisper",nil,sender)
				elseif string.find(DA_Standby[DA_CurrentGuild],FEP_L_gMain[DA_CurrentGuild][sender].."\n") then
					SendChatMessage(FEP_L_gMain[DA_CurrentGuild][sender].." "..L['is already on standby'], "whisper",nil,sender)
				else
					DA_Standby[DA_CurrentGuild]=DA_Standby[DA_CurrentGuild]..FEP_L_gMain[DA_CurrentGuild][sender].."\n"
					FEP_ZamField:SetText(DA_Standby[DA_CurrentGuild])
						if fuckingOptions.pricols then
							SendChatMessage(FEP_L_gMain[DA_CurrentGuild][sender].." "..L['added to Death Note'].." ("..FEP_GetRandomFun()..")","whisper",nil,sender)
						else
							SendChatMessage(FEP_L_gMain[DA_CurrentGuild][sender].." "..L['added on standby'],"whisper",nil,sender)
						end
					FEP_GatherRaid()
					-- DA_standby_mainslist=DA_standby_mainslist..FEP_L_gMain[DA_CurrentGuild][sender].."@"
				end
				
			elseif DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][sender]])=='t' then
				SendChatMessage(L["corrupted local assign. The Old Buddy is back?"], "whisper",nil,sender)
				
				
			elseif DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][sender]])=='f' then
				SendChatMessage(L['seems you got frozen epgp. Contact officer to fix it'], "whisper",nil,sender)
			end
			
			
			
		else
			SendChatMessage(L["You are not in guild. Try adding your main nickname: epgp standby Player"], "whisper",nil,sender)
		end
		
	elseif FEP_L_gMain[DA_CurrentGuild][sender] then
		SendChatMessage(L['you are locally assigned, try to use standby without main nickname'], "whisper",nil,sender)

	elseif not FEP_gMain[member] then
		SendChatMessage(member.." - "..L["there is no such main in guild"], "whisper",nil,sender)
			
	elseif FEP_gMain[member] then
		if DA.DecodeNote(FEP_gMain[member])=='m' then
		
			if string.find(DA_standby_mainslist,"@"..member.."@") then
				SendChatMessage(member.." "..L['is already in raid'], "whisper",nil,sender)
			elseif string.find(DA_Standby[DA_CurrentGuild],member.."\n") then
				SendChatMessage(member.." "..L['is already on standby'], "whisper",nil,sender)
			else
				DA_Standby[DA_CurrentGuild]=DA_Standby[DA_CurrentGuild]..member.."\n"
				FEP_ZamField:SetText(DA_Standby[DA_CurrentGuild])
				
					if fuckingOptions.pricols then
						SendChatMessage(member.." "..L['added to Death Note'].." ("..FEP_GetRandomFun()..")","whisper",nil,sender)
					else
						SendChatMessage(member.." "..L['added on standby'],"whisper",nil,sender)
					end
				FEP_GatherRaid()
				-- DA_standby_mainslist=DA_standby_mainslist..member.."@"
			end
			
		elseif DA.DecodeNote(FEP_gMain[member])=='t' then
			SendChatMessage(member.." - "..L["there is no such main in guild"], "whisper",nil,sender)
			
		elseif DA.DecodeNote(FEP_gMain[member])=='f' then
			SendChatMessage(L['seems you got frozen epgp. Contact officer to fix it'], "whisper",nil,sender)
		end	
	  
  end
  
  
end
local f = CreateFrame("Frame","FEP_ZamWHframe")
FEP_ZamWHframe:SetScript("OnEvent", FEP_Standby)
function FEP_ResetAllChecks()
for group=1,8 do
	for b=1,5 do
		local frame=_G["DA_AwarderGroup"..group.."frame"..b]
		if frame and frame.c and frame.c.name then 
		local name=frame.c.name
			for cb,r in pairs(DA_StoredCheckboxes[DA_SelSet]) do
				local checkbox=_G["DA_AwarderGroup"..group.."frame"..b.."CB"..cb]
				if checkbox then
					checkbox:SetChecked(FEP_mark_State(name,r[1]))
					
					
				end		
			end
		end
	end
end
end
DA_raid_marks={}
function FEP_mark_PL(player,mark,state)
	if DA_raid_marks[player] then
		DA_raid_marks[player][mark]=(state or false)
	else
		return 
	end
end
function FEP_mark_State(player,mark)
	if DA_raid_marks[player] then
		if DA_raid_marks[player][mark] then
			return true
		else
			return false
		end
	else
		return false
	end
end
function FEP_eventupd(self,event,arg1,...)

if InCombatLockdown() then return end

if event=="GUILD_ROSTER_UPDATE" then
	if arg1==1 then 
	else return end
end

GuildRoster()

fepgrupdframe:RegisterEvent("GUILD_ROSTER_UPDATE");
FEP_GatherRaid()
tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
DA.ResumeTimer('fep')

end

DA_StandbyFunList=DA_StandbyFunList or L["DA_Funlist"]
function FEP_GetRandomFun()
if #DA_StandbyFunList==0 then
	DA.Print(L['funny phrases not found. Using backup'])
	return L['heart attack']
end
local a=random(#DA_StandbyFunList)
a=random(#DA_StandbyFunList)
a=random(#DA_StandbyFunList)
return DA_StandbyFunList[a]
end
local mt={
[[#####..............................................]],
[[##########.........................................]],
[[###############....................................]],
[[####################...............................]],
[[#########################..........................]],
[[##############################.....................]],
[[###################################................]],
[[########################################...........]],
[[##############################################.....]],
[[###################################################]]}
function FEP_AskUpd()

	table.wipe(DA_locals_UpdList)
	DA_Awarder.getlocalsFrame.EB:SetText("")
	
	tinsert(DA_Fep_bulk,function()  if GetNumRaidMembers()==0 then DA.RegatherGuildNotes() else FEP_GatherRaid() end DA_Awarder.getlocalsFrame.EB:SetText(mt[1]) end)
	tinsert(DA_Fep_bulk,function()  DA_Awarder.getlocalsFrame.EB:SetText(mt[2]) end)
	tinsert(DA_Fep_bulk,function()  DA_Awarder.getlocalsFrame.EB:SetText(mt[3]) end)
	tinsert(DA_Fep_bulk,function()  DA_Awarder.getlocalsFrame.EB:SetText(mt[4]) end)
	tinsert(DA_Fep_bulk,function()  DA_Awarder.getlocalsFrame.EB:SetText(mt[5]) SendAddonMessage("DA_fask",GetUnitName("player"), "guild") end)
	tinsert(DA_Fep_bulk,function()  DA_Awarder.getlocalsFrame.EB:SetText(mt[6]) end)
	tinsert(DA_Fep_bulk,function()  DA_Awarder.getlocalsFrame.EB:SetText(mt[7]) end)
	tinsert(DA_Fep_bulk,function()  DA_Awarder.getlocalsFrame.EB:SetText(mt[8]) end)
	tinsert(DA_Fep_bulk,function()  DA_Awarder.getlocalsFrame.EB:SetText(mt[9]) end)
	tinsert(DA_Fep_bulk,function()  DA_Awarder.getlocalsFrame.EB:SetText(mt[10]) end)
	tinsert(DA_Fep_bulk,function() DA_Awarder.getlocalsFrame.EB:SetText("");FEP_UpdatePrint();DA_Awarder.askupdbutton:Enable();DA_Awarder.appllocalsbutton:Enable();DA_Awarder.exportbutton:Enable();DA_Awarder.qdkpexportbutton:Enable();DA_Awarder.qdkpsyncbutton:Enable() end)
DA.ResumeTimer('fep')
end

function FEP_UpdatePrint()

	local output={}
	local senders={}
	
	local coinc={}
	
	local counter=0
	for player,mains_tbl in pairs(DA_locals_UpdList) do
		if not FEP_gMain[player] then
			if not coinc[player] then
				coinc[player]=false
			end
			for _,main_t in ipairs(mains_tbl) do
				local main=FEP_gMain[main_t[1]] and main_t[1]
				local sender=main_t.sender
				
				if main and (DA.DecodeNote(FEP_gMain[main])=='m' or DA.DecodeNote(FEP_gMain[main])=='f') 
				and ( not FEP_L_gMain[DA_CurrentGuild][player] or FEP_L_gMain[DA_CurrentGuild][player]~=main ) then
					if DA_Awarder.getlocalsFrame.EB:GetText()=="" then
					else
						DA_Awarder.getlocalsFrame.EB:Insert("\n")
					end
					
					if coinc[player] and coinc[player]==main then
						if not senders[sender] then
							senders[sender]={}
							senders[sender].ch=0
							senders[sender].new=0
							senders[sender].same=0
						end
						senders[sender].same=senders[sender].same+1
						
					elseif coinc[player] or (FEP_L_gMain[DA_CurrentGuild][player] and FEP_L_gMain[DA_CurrentGuild][player]~=main) then
						DA_Awarder.getlocalsFrame.EB:Insert("   #CHANGE "..player.."="..main.." @"..sender)
						counter=counter+1
						if not senders[sender] then
							senders[sender]={}
							senders[sender].ch=0
							senders[sender].new=0
							senders[sender].same=0
						end
						senders[sender].ch=senders[sender].ch+1
						
					else
						DA_Awarder.getlocalsFrame.EB:Insert(player.."="..main.." @"..sender)
						coinc[player]=main
						counter=counter+1
						if not senders[sender] then
							senders[sender]={}
							senders[sender].ch=0
							senders[sender].new=0
							senders[sender].same=0
						end
						senders[sender].new=senders[sender].new+1
						
					end						
				end
			end
		end
	end
	if counter==0 then
		DA_Awarder.getlocalsFrame.EB:SetText("# "..L["No new locals found"])
	else
		for sender,sender_t in pairs(senders) do
			DA.Print(" [|cff00ffff"..sender.."|r]: "..(sender_t.new>0 and "+|cff00ffff"..sender_t.new.."|r new locals " or "")..(sender_t.same>0 and "|cff757575(|cffaba9a9"..sender_t.same.." |cff757575same)|r " or "")..(sender_t.ch>0 and "+|cfffff200"..sender_t.ch.."|r changes " or ""))
		end
	end
end


local lastGuildGet = 0
local AW_allowed_players={}
local function gatherAllowedPlayers()
	table.wipe(AW_allowed_players)
	if fuckingOptions_g[DA_CurrentGuild].assistperm=="Manual" then
		local allowedlist=fuckingOptions_g[DA_CurrentGuild].assistperm_manual:gsub("%s","")
		if allowedlist~="" then
			for allowed in string.gmatch(allowedlist,"([^%,]+)") do
				if DA.IsInSameGuild(allowed) then
					AW_allowed_players[allowed]=true
				end
			end
			return
		else
			return
		end
	elseif fuckingOptions_g[DA_CurrentGuild].assistperm=="Guild Rank" then
		local permitted_rank=fuckingOptions_g[DA_CurrentGuild].assistperm_rank
		for i=1, DA.GetNumGMembers() do
			local nam, _, rankIndex, _, _, _, _, _, _, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
			if nam and rankIndex and rankIndex+1<=permitted_rank then
				AW_allowed_players[nam]=true
			end
		end
	end
end
local function IsAllowedPlayer(name,mode)
    if (time() - lastGuildGet > 5) then
        lastGuildGet = time()
		gatherAllowedPlayers()
    end
	local perm_type = fuckingOptions_g[DA_CurrentGuild].assistperm
	
	if perm_type == "None" then return end
	
	if mode=="locals" and (perm_type == "Any" or perm_type == "Guild Any") and DA.IsInSameGuild(name) then return true end
	
	if mode=="assist" and (perm_type == "Any" or (perm_type == "Guild Any" and DA.IsInSameGuild(name)))  then return true end
	
	if AW_allowed_players[name] then return true end
end

DA:RegisterComm("DA_ass", 
	function(message, dtype, sender)
		if sender~=GetUnitName("player") and UnitInRaid(sender) and IsRaidLeader() and dtype=='raid' then
			local name,class,raidID
			for i=1,40 do
				local na, _, _, _, _, cl, _, _, _, _, _ = GetRaidRosterInfo(i)
				if na==sender then
					name=na
					class=cl
					break
				end
			end
			if not name or not class then return end
			
			if IsAllowedPlayer(sender,'assist') then
				PromoteToAssistant(name)
				DA.Print(L["Promoted to Raid Assistant: "]..DA.GetClassColorCode(class)..name)
			end
			
		end
	end
)
DA:RegisterComm("DA_assRm", 
	function(message, dtype, sender)
		if sender~=GetUnitName("player") and UnitInRaid(sender) and IsRaidLeader() then
			DemoteAssistant(sender)
		end
	end
)
DA:RegisterComm("DA_fask", 
	function(message, dtype, sender)
		if sender~=GetUnitName("player") and DA.IsInSameGuild(sender) then

			DA.RegatherGuildNotes()
			
			local sendlist_low={}
			for i,p in pairs(FEP_L_gMain[DA_CurrentGuild]) do
				if FEP_gMain[p] and (DA.DecodeNote(FEP_gMain[p])=='m' or DA.DecodeNote(FEP_gMain[p])=='f') then
					tinsert(sendlist_low,i.."@"..p)
				end
			end
			for _,j in ipairs(DA.ConcatStr(sendlist_low,254,"_")) do
				SendAddonMessage("DA_fans", j , "WHISPER", sender)
			end
		end
	end
)
DA:RegisterComm("DA_fans", 
	function(message, dtype, sender)
		if sender~=GetUnitName("player") and IsAllowedPlayer(sender,'locals') then
			for str in string.gmatch(message, "[^_]+") do 
				local atIndex = str:find("@")

				if atIndex then
					local main = str:sub(1, atIndex - 1)
					local assign = str:sub(atIndex + 1)
					
					if DA_locals_UpdList[main] then
						local skip
						for _,tbx in ipairs(DA_locals_UpdList[main]) do
							if tbx[1]==assign then
								skip=true
								break
							end
						end
						
						if skip then
						else
							tinsert(DA_locals_UpdList[main],{assign,sender=sender})
						end
					else
						DA_locals_UpdList[main]={{assign,sender=sender}}
					end
				end
			end
		end
	end
)
DA:RegisterComm("DA_flcans", 
	function(message, dtype, sender)
		if fuckingOptions_g[DA_CurrentGuild].aw_auto_locals and sender~=GetUnitName("player") and IsAllowedPlayer(sender,'locals') then
			local dochange = fuckingOptions_g[DA_CurrentGuild].aw_auto_Ch_locals
			local quietmode = fuckingOptions_g[DA_CurrentGuild].aw_auto_silent_locals
			
			local FL = FEP_L_gMain[DA_CurrentGuild]
			
			local received=0
			local received_ignored=0
			
			for str in string.gmatch(message, "[^_]+") do 
				local atIndex = str:find("@")

				if atIndex then
					local player = str:sub(1, atIndex - 1)
					local main = str:sub(atIndex + 1)
					
					if FL[player] and FL[player]==main then
						--do nothing
					elseif FL[player] and FL[player]~=main then
						if dochange then
							FL[player]=main
							received=received+1
						else
							received=received+1
							received_ignored=received_ignored+1
						end
					elseif not FL[player] then
						FL[player]=main
						received=received+1
					end
					
				end
			end
			
			if received>0 then 
				if DA_Awarder:IsShown() then
					FEP_GatherRaid()
					tinsert(DA_Fep_bulk,function()  end)
					tinsert(DA_Fep_bulk,function()  end)
					tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
				end
				if not quietmode then 
					DA.Print(" [|cff00ffff"..sender.."|r]: +|cff00ffff"..received.."|r new locals "..(received_ignored>0 and "(|cfffff200"..received_ignored.."|r changing locals ignored)" or "") )
				end
			end
			
		end
	end
)

function Mod:AddModOptions(modOptTable)
	local f = DA.FrameCreater(nil,DarkAngelopt.scrollchild,154,130)
	f:Show()
	tinsert(modOptTable, {'Awarder',f})	
	
	DA.FontCreater(nil,"Awarder",{"LEFT",f,"TOPLEFT",5,-6},f,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
	
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-20},15,15,L['commands on whisper'],function(self) fuckingOptions_g[DA_CurrentGuild].dkpcomm=(self:GetChecked() or false);DA.DKP_commUpdate() end,{'fuckingOptions_g','dkpcomm','DA_CurrentGuild'},'dkpcomm')
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",25,-32},15,15,L['only in raid'],function(self) fuckingOptions_g[DA_CurrentGuild].dkpcomm_inraid=(self:GetChecked() or false) end,{'fuckingOptions_g','dkpcomm_inraid','DA_CurrentGuild'},nil)
	
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-93},15,15,L['subscribe to auto locals'],function(self) fuckingOptions_g[DA_CurrentGuild].aw_auto_locals=(self:GetChecked() or false) end,{'fuckingOptions_g','aw_auto_locals','DA_CurrentGuild'},'aw_auto_locals')
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",25,-105},15,15,L['apply changes'],function(self) fuckingOptions_g[DA_CurrentGuild].aw_auto_Ch_locals=(self:GetChecked() or false) end,{'fuckingOptions_g','aw_auto_Ch_locals','DA_CurrentGuild'},'aw_auto_Ch_locals')
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",25,-117},15,15,L['silent mode'],function(self) fuckingOptions_g[DA_CurrentGuild].aw_auto_silent_locals=(self:GetChecked() or false) end,{'fuckingOptions_g','aw_auto_silent_locals','DA_CurrentGuild'})
	
	
	do --assister ranks permit
		if not fuckingOptions_g[DA_CurrentGuild].assistperm_rank or GuildControlGetNumRanks()<=fuckingOptions_g[DA_CurrentGuild].assistperm_rank then
			for i=GuildControlGetNumRanks(),1,-1 do
				GuildControlSetRank(i)
				local _, _, _, _, _, _, _, _, _, _, view_officer_note, edit_officer_note, _, _, _, _, _ = GuildControlGetRankFlags()
				if view_officer_note and edit_officer_note then
					fuckingOptions_g[DA_CurrentGuild].assistperm_rank=i
					break
				end
			end
		end
		local re_render_byrankbtn_highlight 
		local re_render_byrankbtn 
		local additassist={
			{"Manual"},
			{"Guild Rank"},
			{"Guild Any"},
			{"Any"},
			{"None"},
		}
		local re_highlight_assist 
		
		
		DarkAngelGUI.opt.assistperm_byrankbtn,DarkAngelGUI.opt.assistperm_byrankFrame=DA.CreateFFGDropFrame(f,"",12,68,{"CENTER",f,"TOPLEFT",45,-75},70,GuildControlGetNumRanks()*11,"BOTTOM",'center', function() DarkAngelGUI.opt.assistpermFrame:Hide();re_render_byrankbtn();re_render_byrankbtn_highlight() end)
		for i=1,10 do 
			DarkAngelGUI.opt.assistperm_byrankFrame['rankbtn'..i]=DA.CreateFFGButton2(nil,DarkAngelGUI.opt.assistperm_byrankFrame,{"TOPLEFT", DarkAngelGUI.opt.assistperm_byrankFrame, "TOPLEFT", 1,10-11*i},10,68,"",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
			end,nil,nil,'left')
		end
		
		
		
		DarkAngelGUI.opt.assistpermbtn,DarkAngelGUI.opt.assistpermFrame=DA.CreateFFGDropFrame(f,"",12,68,{"CENTER",f,"TOPLEFT",45,-60},70,56,"BOTTOM",nil,function() DarkAngelGUI.opt.assistperm_byrankFrame:Hide() end,nil,'aw_trusted_players')
		DA.FontCreater(nil,L["Trusted players"],{"LEFT",DarkAngelGUI.opt.assistpermbtn,"LEFT",-5,13},DarkAngelGUI.opt.assistpermbtn,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
		
		DarkAngelGUI.opt.assistperm_manual=DA.EditBoxCreater2(nil,DarkAngelGUI.opt.assistpermbtn,{"TOPLEFT",DarkAngelGUI.opt.assistpermbtn,"BOTTOMLEFT",0,-4},{90,12},fuckingOptions_g[DA_CurrentGuild].assistperm_manual,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","assistperm_manual",'DA_CurrentGuild'},nil,nil,'text')
		DarkAngelGUI.opt.assistperm_manual:SetScript("OnTextChanged",function(self)
			if self:GetText():find("[0-9]") or self:GetText():find("%.") then
				self.t:SetTexture(70/255, 12/255, 20/255, 1)
			else
				self.t:SetTexture(0.176, 0.286, 0.356, 1)
			end
		end)
		DarkAngelGUI.opt.assistperm_manual:Hide()
		
		
		for i,criteria in pairs(additassist) do
			DarkAngelGUI.opt.assistpermFrame[i]=DA.CreateFFGButton2(nil,DarkAngelGUI.opt.assistpermFrame,{"TOPLEFT", DarkAngelGUI.opt.assistpermFrame, "TOPLEFT", 1,10-11*i},10,68,criteria[1],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), criteria[2] or 9, "OUTLINE"},function(self) 
				fuckingOptions_g[DA_CurrentGuild].assistperm=self.fs:GetText()
				re_highlight_assist()
				DarkAngelGUI.opt.assistpermFrame:Hide()
			end,criteria[3] or nil,nil,'center')
		end
		
		
		
		
		re_render_byrankbtn_highlight=function()
			for i=1,10 do
				if DarkAngelGUI.opt.assistperm_byrankFrame['rankbtn'..i].rankID==fuckingOptions_g[DA_CurrentGuild].assistperm_rank then
					DarkAngelGUI.opt.assistperm_byrankFrame['rankbtn'..i].fs:SetTextColor(0.2,1,1,1)
					DarkAngelGUI.opt.assistperm_byrankbtn:SetText(GuildControlGetRankName(fuckingOptions_g[DA_CurrentGuild].assistperm_rank))
				else
					DarkAngelGUI.opt.assistperm_byrankFrame['rankbtn'..i].fs:SetTextColor(0.85,1,1,1)
				end
			end
		end
		re_render_byrankbtn=function()
			local gcnr=GuildControlGetNumRanks()
			for i=1,10 do
				if i<=gcnr then
					DarkAngelGUI.opt.assistperm_byrankFrame['rankbtn'..i].fs:SetText(GuildControlGetRankName(i))
					DarkAngelGUI.opt.assistperm_byrankFrame['rankbtn'..i].rankID=i
					DarkAngelGUI.opt.assistperm_byrankFrame['rankbtn'..i]:SetScript("OnClick",function(self) 
						DarkAngelGUI.opt.assistperm_byrankbtn.fs:SetText(self.fs:GetText())
						fuckingOptions_g[DA_CurrentGuild].assistperm_rank=i
						re_render_byrankbtn_highlight()
						DarkAngelGUI.opt.assistperm_byrankFrame:Hide()
					end)
					DarkAngelGUI.opt.assistperm_byrankFrame['rankbtn'..i]:SetPoint("TOPLEFT", DarkAngelGUI.opt.assistperm_byrankFrame, "TOPLEFT", 1,10-11*i)
				else
					DarkAngelGUI.opt.assistperm_byrankFrame['rankbtn'..i]:Hide()
				end
			end
			DarkAngelGUI.opt.assistperm_byrankFrame:SetSize(70,gcnr*11)
		end
		re_highlight_assist=function()
			for i=1,#additassist do
				if DarkAngelGUI.opt.assistpermFrame[i].fs:GetText()==fuckingOptions_g[DA_CurrentGuild].assistperm then
					DarkAngelGUI.opt.assistpermFrame[i].fs:SetTextColor(0.2,1,1,1)
					if fuckingOptions_g[DA_CurrentGuild].assistperm=="Manual" then
						DarkAngelGUI.opt.assistperm_manual:Show()
						DarkAngelGUI.opt.assistperm_byrankbtn:Hide()
					elseif fuckingOptions_g[DA_CurrentGuild].assistperm=="Guild Rank" then
						DarkAngelGUI.opt.assistperm_manual:Hide()
						DarkAngelGUI.opt.assistperm_byrankbtn:Show()
					else
						DarkAngelGUI.opt.assistperm_manual:Hide()
						DarkAngelGUI.opt.assistperm_byrankbtn:Hide()
					end
					DarkAngelGUI.opt.assistpermbtn:SetText(fuckingOptions_g[DA_CurrentGuild].assistperm)
				else
					DarkAngelGUI.opt.assistpermFrame[i].fs:SetTextColor(0.85,1,1,1)
				end
			end
		end
		
		re_render_byrankbtn()
		re_render_byrankbtn_highlight()
		DarkAngelGUI.opt.assistperm_byrankbtn:Hide()
		re_highlight_assist()
		
	end

	
	
end