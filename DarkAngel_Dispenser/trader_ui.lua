
local DA=LibStub("AceAddon-3.0"):GetAddon("DarkAngel")
local L = LibStub("AceLocale-3.0"):GetLocale("DarkAngel")
local Mod = DA:NewModule("Dispenser")



function Mod:OnInitialize()

	DA_Flasker:SetScale(fuckingOptions.FFFLScale)
	
    DarkAngel_FlaskDB = DarkAngel_FlaskDB or {}
	
	if #DarkAngel_FlaskDB==0 then 
		DarkAngel_FlaskDB = {
			{
				Flask={
					meel={46377,1,"Interface\\Icons\\INV_Alchemy_EndlessFlask_06","|cffffffff|Hitem:46377:0:0:0:0:0:0:0:80|h[Flask of Endless Rage]|h|r"},
					rdd={46376,1,"Interface\\Icons\\INV_Alchemy_EndlessFlask_04","|cffffffff|Hitem:46376:0:0:0:0:0:0:0:80|h[Flask of the Frost Wyrm]|h|r"},
					heal={46376,1,"Interface\\Icons\\INV_Alchemy_EndlessFlask_04","|cffffffff|Hitem:46376:0:0:0:0:0:0:0:80|h[Flask of the Frost Wyrm]|h|r"},
					tank={46379,1,"Interface\\Icons\\INV_Alchemy_EndlessFlask_05","|cffffffff|Hitem:46379:0:0:0:0:0:0:0:80|h[Flask of Stoneblood]|h|r"},
				},
				Potion={
					meel={40211,3,"Interface\\Icons\\INV_Alchemy_Elixir_04","|cffffffff|Hitem:40211:0:0:0:0:0:0:0:80|h[Potion of Speed]|h|r"},
					rdd={40212,3,"Interface\\Icons\\INV_Alchemy_Elixir_01","|cffffffff|Hitem:40212:0:0:0:0:0:0:0:80|h[Potion of Wild Magic]|h|r"},
					heal={},
					tank={40093,6,"Interface\\Icons\\INV_Alchemy_Elixir_Empty","|cffffffff|Hitem:40093:0:0:0:0:0:0:0:80|h[Indestructible Potion]|h|r"},
				},
				Dops={
					meel={},
					rdd={},
					heal={},
					tank={44939,1,"Interface\\Icons\\INV_Potion_118","|cffffffff|Hitem:44939:0:0:0:0:0:0:0:80|h[Lesser Flask of Resistance]|h|r"},
				}
			}
		} 
	
		for _, set in ipairs(DarkAngel_FlaskDB) do
			for _,roleset in pairs(set) do
				for _,itemtbl in pairs(roleset) do
					if tonumber(itemtbl[1]) and ({GetItemInfo(itemtbl[1])})[1] then
						itemtbl[1]=({GetItemInfo(itemtbl[1])})[1]
					
					end
				end
			end
		end
	end
	
	
	--flask dispenser
	DA.CreateTimer(nil,"flask_disp",0,fuckingOptions.dispenser_speed,true,function(self)
		if not DA.flasker_bulk[1] then
			self:SetScript("OnUpdate",nil)
			return
		end
		DA.flasker_bulk[1]() 
		table.remove(DA.flasker_bulk,1)
	end) 		
	
end

function Mod:OnEnable()
    self.Flasker_Load()
	if UISpecialFrames then 
		tinsert(UISpecialFrames, "DA_Flasker")
	end
	DA:ModuleLoaded("Dispenser")
end


function Mod:OnGuildLoad()
	self:Flasker_OptLoad()
	if DA.IsModuleLoaded['Awarder'] then
		self:CreateAwarderFlasksChecker()
	end
end

DA_Flasker = DA.FrameCreater(nil,UIParent,60,60,{"TOPLEFT", UIParent, "CENTER", 0, 0})
local F = DA_Flasker
F:RegisterForDrag("LeftButton")
F:SetScript("OnDragStart", function(self) self:StartMoving() end)
F:SetScript("OnDragStop", function(self)

	self:StopMovingOrSizing(self)

	local point={DA_Flasker:GetPoint(1)}
	fuckingOptions.saved_guiPositions.DA_Flasker={point[1] or "TOPLEFT",point[3] or "CENTER",point[4] or 0,point[5] or 0}

end)
DA.CreateScaler('DA_Flasker',0.8,2,{'fuckingOptions','FFFLScale'})

local last_set_visible=0
local function IconGrabCreater(itemID,rel,point,heig,wid)
local f = CreateFrame("Button", nil, rel, "UIDarkAngelIconicButton")
local _, itemLink, _, _, _, _, _, _, _, itemTexture, _ = GetItemInfo(itemID)

	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	f:SetBackdropColor(1, 1, 1, 1)
	f:RegisterForClicks("LeftButtonUp","RightButtonUp")
	f:SetNormalTexture(itemTexture or GetItemIcon(itemID))
	f:SetMovable(true)
	f:SetScript("OnClick", function() PickupItem(itemID) end)
	f:SetScript("OnDragStart", function() PickupItem(itemID) end)
	
	f:SetText('')
	
	f:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self,'ANCHOR_CURSOR')
		GameTooltip:SetHyperlink(itemLink or "\124cffffffff\124Hitem:"..itemID.."::::::::70:::::\124h[loading data]\124h\124r")
		GameTooltip:Show()
	end)
	
	f:SetScript("OnLeave", function(self)
		DA.myHideTooltip()
	end)
	
	return f
end
local function create_flask_button(roleFDS,slotFDS,setFrame)
local pointx;
local pointy;
-- local index;
-- local role;
if slotFDS=="Flask" then 
	pointx=5
elseif slotFDS=="Potion" then
	pointx=35
elseif slotFDS=="Dops" then
	pointx=65
end

if roleFDS=="tank" then 
	pointy=-10
elseif roleFDS=="heal" then
	pointy=-50
elseif roleFDS=="meel" then
	pointy=-90
elseif roleFDS=="rdd" then
	pointy=-130
end


local f = DA.ButtonCreater(nil,setFrame,{"TOPLEFT", setFrame, "TOPLEFT", pointx, pointy},30,30,"")

	local txt = setFrame:CreateTexture(nil, "BACKGROUND")
	txt:SetAllPoints(f)
	if DarkAngel_FlaskDB[setFrame.n] and DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][3] then
		txt:SetTexture(DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][3])
	else 
		txt:SetTexture('Interface\\PaperDoll\\UI-Backpack-EmptySlot')
	end
	txt:Hide()
	f:SetPushedTexture(txt)
	f:SetNormalTexture(txt)
	
f.pm_Frame = DA.FrameCreater(nil,f,30,12,{"TOP", f, "BOTTOM", 0, -0.5})
	local fctext
		if DarkAngel_FlaskDB[setFrame.n] and DarkAngel_FlaskDB[setFrame.n][slotFDS] and DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS] and DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][2] then
			fctext=DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][2]
			f.pm_Frame:Show()
		else
			f.pm_Frame:Hide()
		end
	f.c = DA.FontCreater(nil,fctext or "1",{"CENTER", f.pm_Frame, "CENTER", 0, 0},f.pm_Frame,70,70,{UIDarkAngelFontConsolas:GetFont(), 13, "OUTLINE"},'center')
	
	
	f.pm_Frame:SetScript("OnMouseWheel",function(_,dir)
		if dir>0 then
			if tonumber(f.c:GetText())< (select(8,GetItemInfo(DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][1])) or 20 )then 
				f.c:SetText(tostring(tonumber(f.c:GetText())+1 ))
				DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][2]=tonumber(f.c:GetText())
				DA.TR_SelSet=setFrame.n
			end
		else
			if tonumber(f.c:GetText())>1 then 
				f.c:SetText(tostring(tonumber(f.c:GetText())-1 ))
				DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][2]=tonumber(f.c:GetText())
				DA.TR_SelSet=setFrame.n
			end
		end
	end)
	f.m = DA.ButtonCreater(nil,f.pm_Frame,{"LEFT", f.pm_Frame, "LEFT", 1, 0},8,8,"-",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',function(self)
		if tonumber(f.c:GetText())>1 then 
			f.c:SetText(tostring(tonumber(f.c:GetText())-1 ))
			DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][2]=tonumber(f.c:GetText())
			DA.TR_SelSet=setFrame.n
		end
	end)
	f.p = DA.ButtonCreater(nil,f.pm_Frame,{"RIGHT", f.pm_Frame, "RIGHT", -1, 0},8,8,"+",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',function(self)
		if tonumber(f.c:GetText())< (select(8,GetItemInfo(DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][1])) or 20 )then 
			f.c:SetText(tostring(tonumber(f.c:GetText())+1 ))
			DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][2]=tonumber(f.c:GetText())
			DA.TR_SelSet=setFrame.n
		end
	end)
	

	f:SetScript("OnClick", function(self,mouse)
		if mouse=="RightButton" then
			self:SetPushedTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
			self:SetNormalTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
			DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS]={}
			self.pm_Frame:Hide()
			GameTooltip:Hide()
		else
			if (CursorHasItem() or (({GetCursorInfo()})[1] and ({GetCursorInfo()})[1]=='item')) and mouse=="LeftButton" then
				self.pm_Frame:Show()
				self.c:SetText("1")
				local _,_,z=GetCursorInfo()
				local itemName,itemLink,_,_,_,_,_,_,_,texture=GetItemInfo(z);
				local txtnew = setFrame:CreateTexture(nil, "BACKGROUND")
				txtnew:SetAllPoints(self)
				txtnew:SetTexture(texture)
				txtnew:Hide()
				self:SetPushedTexture(txtnew)
				self:SetNormalTexture(txtnew)
				if DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS] and #DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS]>=4 then
					DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][1]=itemName
					DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][2]=1
					DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][3]=texture
					DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][4]=itemLink
				else
					DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS]={itemName,1,texture,itemLink}
				end
			end
		end
		DA.TR_SelSet=setFrame.n
	end)
	f:SetScript("OnEnter", function(self)
		if DarkAngel_FlaskDB[setFrame.n] and DarkAngel_FlaskDB[setFrame.n][slotFDS] and DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS] and DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][1] then
			local itemLink=DarkAngel_FlaskDB[setFrame.n][slotFDS][roleFDS][4]
			if itemLink and not CursorHasItem() then
			GameTooltip:SetOwner(self,'ANCHOR_CURSOR')
			GameTooltip:SetHyperlink(itemLink)
			GameTooltip:Show()
			end
		end
	end)
	f:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

end
local function IsInRaid()
	if (GetNumRaidMembers()==0) then
		return nil
	else
		return 1
	end
end
local function Dispenser_CreateSet(n)
	local setFrame = DA.FrameCreater(nil,F.FlaskDispenser,100,200,{"TOPLEFT", F.FlaskDispenser, "TOPLEFT", 100*last_set_visible, 0},'no')
		setFrame:EnableMouse(false)
		setFrame.n=n
		setFrame:Show()
	F.FlaskDispenser.sets[setFrame.n] = setFrame
	
	for _, t in ipairs({
		{"T\nA\nN\nK",2,"tank"},
		{"H\nE\nA\nL",-38,"heal"},
		{"M\nE\nL\nE",-78,"meel"},
		{"C\nA\nS\nT",-118,"rdd"}
	}) do
		DA.FontCreater(nil,t[1],{"TOPLEFT", setFrame, "TOPLEFT", -5, t[2]},setFrame,60,17,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"})
		
		for _,h in ipairs({
			{"Flask"},
			{"Potion"},
			{"Dops"}
		}) do	
			create_flask_button(t[3],h[1],setFrame)
		end
	
	end
	DA.ButtonCreater(nil,setFrame,{"BOTTOM", setFrame, "BOTTOM", 0, 2},12,60,L['start'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',function(self)
		local set_contents=0
		for z in pairs(DarkAngel_FlaskDB[setFrame.n]) do
			for x in pairs(DarkAngel_FlaskDB[setFrame.n][z]) do
				for c in pairs(DarkAngel_FlaskDB[setFrame.n][z][x]) do
					set_contents=set_contents+1
				end
			end
		end
		if set_contents==0 then 
			DA.Print(L['empty set'])
			return
			else
			if IsInRaid() then 
				F.stopflBtn:Enable()
				DA.TR_start(setFrame.n)
				return
			else
				DA.Print(L['You are not in raid'])
				return
			end
		end
	end)
	
	last_set_visible=last_set_visible+1
end

function Mod.Flasker_Load()
	for i,id in pairs({46377,46376,46379,40211,40212,40093,22828,9036,44939,44329,44328,40097,46378,40079,40076,42994,43523}) do
		IconGrabCreater(id,  F.optionsFrame,  {"BOTTOMLEFT",F.optionsFrame,"BOTTOMLEFT", -17+i*20, 5},  20,  20)
	end
	
end

function Mod:Flasker_OptLoad()
	local onstart=DA.CheckBtnCreater(nil,F.optionsFrame,{"CENTER",F.optionsFrame,"TOPLEFT", 10, -20},15,15,L['announce dispense'],function(self) fuckingOptions_g[DA_CurrentGuild].dispenser_announce=(self:GetChecked() or false) end,{'fuckingOptions_g','dispenser_announce','DA_CurrentGuild'},nil)
			DA.FontCreater(nil,L['On Dispense Start'],{"LEFT",onstart,"CENTER",6,12},onstart,15,170,{"Fonts\\FRIZQT__.TTF", 8, "OUTLINE"},'left')
		DA.CheckBtnCreater(nil,F.optionsFrame,{"CENTER",onstart,"CENTER",0,-15},15,15,L['mark self'],function(self) fuckingOptions_g[DA_CurrentGuild].dispenser_markself=(self:GetChecked() or false) end,{'fuckingOptions_g','dispenser_markself','DA_CurrentGuild'},nil)
			DA.EditBoxCreater2(nil,F.optionsFrame,{"CENTER",onstart,"CENTER",80,-15},{20,12},fuckingOptions_g[DA_CurrentGuild].dispenser_markself_n,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","dispenser_markself_n",'DA_CurrentGuild'},1,8,true,nil,nil,'dispenser_marktypes')
		DA.SliderCreater('DA_disp_speed',onstart,{"LEFT",onstart,"CENTER",-8,-50},15,100, 0.1,0.4,0.05, {'fuckingOptions','dispenser_speed'},L['fast'],L['slow'],L['d_speed'],'disp_speed',function() DA.SetTimerSpeed('flask_disp',fuckingOptions.dispenser_speed) end)
		
	local ondispense=DA.CheckBtnCreater(nil,F.optionsFrame,{"CENTER",F.optionsFrame,"TOPLEFT", 120, -20},15,15,L['only guild members'],function(self) fuckingOptions_g[DA_CurrentGuild].dispenser_gmembers=(self:GetChecked() or false) end,{'fuckingOptions_g','dispenser_gmembers','DA_CurrentGuild'},'dispenser_gmembers')
			DA.FontCreater(nil,L['Dispense'],{"LEFT",ondispense,"CENTER",6,12},ondispense,15,170,{"Fonts\\FRIZQT__.TTF", 8, "OUTLINE"},'left')
		DA.CheckBtnCreater(nil,F.optionsFrame,{"CENTER",ondispense,"CENTER",0,-15},15,15,L['print dispensed'],function(self) fuckingOptions_g[DA_CurrentGuild].dispenser_print=(self:GetChecked() or false) end,{'fuckingOptions_g','dispenser_print','DA_CurrentGuild'},nil)
		DA.CheckBtnCreater(nil,F.optionsFrame,{"CENTER",ondispense,"CENTER",0,-30},15,15,L['say in raid'],function(self) fuckingOptions_g[DA_CurrentGuild].dispenser_rsay=(self:GetChecked() or false) end,{'fuckingOptions_g','dispenser_rsay','DA_CurrentGuild'},nil)
		DA.CheckBtnCreater(nil,F.optionsFrame,{"CENTER",ondispense,"CENTER",0,-45},15,15,L['say in guild'],function(self) fuckingOptions_g[DA_CurrentGuild].dispenser_gsay=(self:GetChecked() or false) end,{'fuckingOptions_g','dispenser_gsay','DA_CurrentGuild'},nil)
		
		
	local oncomplete=DA.CheckBtnCreater(nil,F.optionsFrame,{"CENTER",F.optionsFrame,"TOPLEFT", 240, -20},15,15,L['group up items'],function(self) fuckingOptions_g[DA_CurrentGuild].dispenser_items_grp=(self:GetChecked() or false) end,{'fuckingOptions_g','dispenser_items_grp','DA_CurrentGuild'},nil)
			DA.FontCreater(nil,L['On Stop'],{"LEFT",oncomplete,"CENTER",6,12},oncomplete,15,170,{"Fonts\\FRIZQT__.TTF", 8, "OUTLINE"},'left')
		DA.CheckBtnCreater(nil,F.optionsFrame,{"CENTER",oncomplete,"CENTER",0,-15},15,15,L['print results'],function(self) fuckingOptions_g[DA_CurrentGuild].dispenser_print_results=(self:GetChecked() or false) end,{'fuckingOptions_g','dispenser_print_results','DA_CurrentGuild'},nil)
		DA.CheckBtnCreater(nil,F.optionsFrame,{"CENTER",oncomplete,"CENTER",0,-30},15,15,L['results in raid'],function(self) fuckingOptions_g[DA_CurrentGuild].dispenser_rsay_results=(self:GetChecked() or false) end,{'fuckingOptions_g','dispenser_rsay_results','DA_CurrentGuild'},nil)
		DA.CheckBtnCreater(nil,F.optionsFrame,{"CENTER",oncomplete,"CENTER",0,-45},15,15,L['results in guild'],function(self) fuckingOptions_g[DA_CurrentGuild].dispenser_gsay_results=(self:GetChecked() or false) end,{'fuckingOptions_g','dispenser_gsay_results','DA_CurrentGuild'},nil)
		
	Dispenser_CreateSet(1)
	
end


F.FlaskDispenser=DA.FrameCreater(nil,F,100,200,{"TOPLEFT", F,"TOPRIGHT",2,0},"Interface\\AddOns\\DarkAngel\\template\\pict\\box1",1)
DA.CloseButtonCreater(nil,F,{"TOPRIGHT", F.FlaskDispenser, "TOPRIGHT", 0,0},8,8,'x',F.FlaskDispenser:GetFrameLevel()+3)
F.FlaskDispenser.add:SetFrameLevel(0)

F.FlaskDispenser.sets={}

F.FlaskDispenser:EnableMouse(true)
F.FlaskDispenser:SetMovable(true)
F.FlaskDispenser:SetResizable(enable)
F.FlaskDispenser:SetMinResize(100, 100)
F.FlaskDispenser:RegisterForDrag("LeftButton")
F.FlaskDispenser:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
F.FlaskDispenser:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end) 
	F.FlaskDispenser:Show()
	
F.optionsFrame=DA.FrameCreater(nil,F.FlaskDispenser,360,100,{'BOTTOMLEFT',F.FlaskDispenser,'TOPLEFT',0,-2},nil,1)
F.optionsFrame.add:SetFrameLevel(0)
DA.CloseButtonCreater(nil,F.optionsFrame,{"TOPRIGHT", F.optionsFrame, "TOPRIGHT", -3,-3},10,10,'x')

F.stopflBtn=DA.CreateFFGButton2(nil,  F,  {"CENTER", F, "TOPLEFT", 30, -12},  12,  50,  L["stop"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black', {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
	function(self)
		DA.TR_stop()
		self:Disable()
	end
)
F.stopflBtn:Disable()
DA.CreateFFGButton2(nil,F,{"CENTER", F, "TOPLEFT", 30, -27},12,50,L['options'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
function() 
	if F.optionsFrame:IsShown() then
		F.optionsFrame:Hide()
	else
		F.optionsFrame:Show()
	end
end)
DA.CreateFFGButton2(nil,  F,  {"CENTER", F, "TOPLEFT", 30, -42},  12,  50,  L['clear'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black', {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
	function(self)
		table.wipe(DA.TR_Names)
		if TradeFrame:IsShown() then 
			DA.TR_routine(nil,'TRADE_SHOW') 
		end
	end,'disp_clear'
)
local minusFlBtn
local addFlBtn
addFlBtn=DA.CreateFFGButton2(nil,  F.FlaskDispenser,  {"TOPRIGHT", F.FlaskDispenser, "TOPRIGHT", 30, -20},  15,  15,  "+",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',  {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
	function(self)
	
		
		if #F.FlaskDispenser.sets > last_set_visible then
			--un-hiding pre-created set
			last_set_visible=last_set_visible+1
			F.FlaskDispenser.sets[last_set_visible]:Show()
		else
			--creating new set
			if DarkAngel_FlaskDB[last_set_visible+1] then 
			else
				table.insert(DarkAngel_FlaskDB,{Flask={meel={},rdd={},heal={},tank={}},Potion={meel={},rdd={},heal={},tank={},},Dops={meel={},rdd={},heal={},tank={},}})
			end
			Dispenser_CreateSet(last_set_visible+1)
		end
		
		F.FlaskDispenser:SetWidth(100 * last_set_visible)
		self:SetPoint("TOPRIGHT", F.FlaskDispenser, "TOPRIGHT", 30, -20)
		minusFlBtn:SetPoint("TOPRIGHT", F.FlaskDispenser, "TOPRIGHT", 30, -40)
	end
)
minusFlBtn=DA.CreateFFGButton2(nil,  F.FlaskDispenser,  {"TOPRIGHT", F.FlaskDispenser, "TOPRIGHT", 30, -40},  15,  15,  "-",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',  {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
	function(self)
		if last_set_visible>1 then
			F.FlaskDispenser.sets[last_set_visible]:Hide()
			last_set_visible=last_set_visible-1
			F.FlaskDispenser:SetWidth(100*(last_set_visible))
			addFlBtn:SetPoint("TOPRIGHT", F.FlaskDispenser, "TOPRIGHT", 30, -20)
			self:SetPoint("TOPRIGHT", F.FlaskDispenser, "TOPRIGHT", 30, -40)
		end
	end
)



function Mod:CreateAwarderFlasksChecker()
	local btn = DA.CreateFFGButton2(nil,DA_Awarder,{"CENTER", DA_Awarder, "TOPRIGHT", -10,-102},13,13,'','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
		if IsShiftKeyDown() then
			if DA_Flasker:IsShown() then
				DA_Flasker:Hide()
			else
				DA_Flasker:Show()
				self.enabled = true
				DA:Awarer_Highligt_Flasks() 
				return
			end
		end
		
		if not self.enabled then
			self.enabled = true
			DA:Awarer_Highligt_Flasks() 
		else
			self.enabled = false
			DA:Awarer_Hide_Flasks() 
		end
			
	end,'aw_flaskdisp_manual')
	
	btn:HookScript("OnEnter",function(self)
		self.enabled=false
		DA:Awarer_Highligt_Flasks() 
	end)
	
	btn:HookScript("OnLeave",function(self)
		if not self.enabled then
			DA:Awarer_Hide_Flasks()
		end
	end)
	
	btn:SetNormalTexture("Interface\\Icons\\Trade_Alchemy")
	btn:GetNormalTexture():SetTexCoord(0,1,0,1)
	btn:GetNormalTexture():SetBlendMode('blend')
	
	btn:SetPushedTexture("Interface\\Icons\\Trade_Alchemy")
	btn:GetPushedTexture():SetTexCoord(0,1,0,1)
	btn:GetPushedTexture():SetBlendMode('blend')
	
end