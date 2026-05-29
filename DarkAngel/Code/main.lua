
---@class DarkAngelAddon
local DA = DarkAngel
local L = DA.L


-- main Frame
DarkAngelGUI = CreateFrame("Frame", "DarkAngelGUI", UIParent)
DarkAngelGUI.width  = 496
DarkAngelGUI.height = 300
DarkAngelGUI:SetBackdropColor(1, 1, 1, 1)
DarkAngelGUI:SetFrameStrata("HIGH")
DarkAngelGUI:SetSize(DarkAngelGUI.width, DarkAngelGUI.height)

DarkAngelGUI:EnableMouse(true)
DarkAngelGUI:EnableMouseWheel(true)
DarkAngelGUI:SetMovable(true)
DarkAngelGUI:SetResizable(true)
DarkAngelGUI:SetMinResize(496, 300)
DarkAngelGUI:Hide()
DarkAngelGUI:SetScript("OnDragStart", function(self)
	self.ismoving=1
	self:StartMoving(self)
end )
DarkAngelGUI:SetScript("OnDragStop", 	function(self)
	if self.ismoving then
		self.ismoving=nil

		self:StopMovingOrSizing(self)
		local point={DarkAngelGUI:GetPoint(1)}
		fuckingOptions.saved_guiPositions.DarkAngelGUI={point[1] or "TOPLEFT",point[3] or "CENTER",point[4] or 0,point[5] or 0}

	end
end)
DA.CloseButtonCreater(nil,DarkAngelGUI,{"center", DarkAngelGUI, "TOPRIGHT", -8.5,-8.5},12,12,'x',222)
DarkAngelGUI.myclosebtn:HookScript("OnClick",function() DA.Garbage_Collect() end)

-- bind btns
DA.CreateFFGButton2("DarkAngel_bind2",UIParent,{"TOPLEFT",UIParent,"TOPLEFT",-334,110},1,1,nil,"",nil,function()
	if not (DarkAngelGUI and _G['DarkAngelGUI']['Guildbtn']) then return end
	if DA.loaded_Modules['Inviter'] and DarkAngel_minimapBtn and DarkAngel_minimapBtn.fullyloaded then
		DA_Inviter.OpenClose()
	end
end):RegisterForClicks('anydown')
DA.CreateFFGButton2("DarkAngel_bind3",UIParent,{"TOPLEFT",UIParent,"TOPLEFT",-334,110},1,1,nil,"",nil,function()
	if not (DarkAngelGUI and _G['DarkAngelGUI']['Guildbtn']) then return end
	if DA.loaded_Modules['Awarder'] and DarkAngel_minimapBtn and DarkAngel_minimapBtn.fullyloaded then
		DA_Awarder.OpenClose()
	end
end):RegisterForClicks('anydown')
DA.CreateFFGButton2("DarkAngel_bind4",UIParent,{"TOPLEFT",UIParent,"TOPLEFT",-334,110},1,1,nil,"",nil,function()
	if not (DarkAngelGUI and _G['DarkAngelGUI']['Guildbtn']) then return end
	if DA.loaded_Modules['BidTracker'] and DarkAngel_minimapBtn and DarkAngel_minimapBtn.fullyloaded then
		if DA_BidTracker:IsShown() then
			DA_BidTracker:Hide()
		else
			DA_BidTracker:Show()
		end
	end
end):RegisterForClicks('anydown')
DA.CreateFFGButton2("DarkAngel_bind5",UIParent,{"TOPLEFT",UIParent,"TOPLEFT",-334,110},1,1,nil,"",nil,function()
	if not (DarkAngelGUI and _G['DarkAngelGUI']['Guildbtn']) then return end
	if DA.loaded_Modules['Dispenser'] and DarkAngel_minimapBtn and DarkAngel_minimapBtn.fullyloaded then
		if DA_Flasker:IsShown() then
			DA_Flasker:Hide()
		else
			DA_Flasker:Show()
		end
	end
end):RegisterForClicks('anydown')

-- minimap
DarkAngel_minimapBtn = CreateFrame("Button", "DarkAngel_minimapBtn", Minimap)
local minibtn = DarkAngel_minimapBtn
minibtn:SetFrameLevel(99)
minibtn:SetSize(28,28)
minibtn:SetMovable(true)
minibtn:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\MinimapIcon.blp")
minibtn:SetPushedTexture("Interface\\AddOns\\DarkAngel\\template\\MinimapIcon2.blp")
minibtn:SetHighlightTexture("Interface\\AddOns\\DarkAngel\\template\\MinimapIcon.blp")
local myIconPos = 0
local function UpdateMapBtn()
    local Xpoa, Ypoa = GetCursorPosition()
    local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
    Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
    Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70
    myIconPos = math.deg(math.atan2(Ypoa, Xpoa))
    minibtn:ClearAllPoints()
    minibtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(myIconPos)), (80 * sin(myIconPos)) - 52)
end
minibtn:RegisterForDrag("LeftButton")
minibtn:RegisterForClicks("LeftButtonUp","RightButtonUp")
minibtn:ClearAllPoints();
minibtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(myIconPos)),(80 * sin(myIconPos)) - 52)
minibtn:SetScript("OnClick", function(self,clicktype)

	if clicktype=='LeftButton' then
		if not (DarkAngelGUI and _G['DarkAngelGUI']['Guildbtn']) then return end

		DA.myHideTooltip()
		DarkAngel_minimapBtn.menu:Hide()
		if (not IsShiftKeyDown()) and (not IsControlKeyDown()) and (not IsAltKeyDown()) then

			if DarkAngelGUI:IsShown() then
				DarkAngelGUI:Hide()
				DA.Garbage_Collect()
			else
				DarkAngelGUI:Show()
				_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',true)
				_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',false)
				DA.ResetScrollBoxes()
			end

		elseif (IsShiftKeyDown()) and (not IsControlKeyDown()) and (not IsAltKeyDown()) then
			if DA.loaded_Modules['Inviter'] then DA_Inviter.OpenClose() end

		elseif (not IsShiftKeyDown()) and (IsControlKeyDown()) and (not IsAltKeyDown()) then
			if not DA.loaded_Modules['Logger'] then return end

			if DarkAngelGUI.Details:IsShown() and DarkAngelGUI:IsShown() then
				DarkAngelGUI:Hide()
				DA.Garbage_Collect()
			else
				DarkAngelGUI:Show()
				_G['DarkAngelGUI']['Detailsbtn']:Click('LeftButton',true)
				_G['DarkAngelGUI']['Detailsbtn']:Click('LeftButton',false)
				DarkAngelGUI.Details.SearchEB:SetText(UnitName('target') or UnitName('player'))
				DA.RunLogSearch(DarkAngelGUI.Details.SearchEB:GetText())
			end

		elseif (not IsShiftKeyDown()) and (not IsControlKeyDown()) and  (IsAltKeyDown()) then
			if DA.loaded_Modules['Awarder'] then DA_Awarder.OpenClose()	end

		end
	elseif clicktype=='RightButton' then
		DA.myHideTooltip()
		DarkAngel_minimapBtn.menu:Show()
		DA.ResumeTimer('mmap_hider')
		DarkAngel_minimapBtn.menu.timerticked=0
	end
end)
minibtn:SetScript("OnDragStart", function()
    minibtn:StartMoving()
    minibtn:SetScript("OnUpdate", UpdateMapBtn)
end)
minibtn:SetScript("OnDragStop", function()
    minibtn:StopMovingOrSizing();
    minibtn:SetScript("OnUpdate", nil)
    UpdateMapBtn();
end)
minibtn:SetScript("OnEnter",function(self)
	DarkAngel_minimapBtn.menu.timerticked=0
	local tt = DA_TooltipMM
	tt:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile="true",tileSize="16",edgeSize="16",insets={bottom="5",left="5",right="5",top="5"}})
	
	
	tt:SetBackdropColor(0.09, 0.09, 0.19, 0.9)
	-- tt:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)

	DA_TooltipMMTextLeft1:SetFont(UIDarkAngelFontConsolas:GetFont(), 15,'outline')
	DA_TooltipMMTextRight1:SetFont(UIDarkAngelFontConsolas:GetFont(), 15,'outline') 
	DA_TooltipMMTextLeft2:SetFont("Fonts\\FRIZQT__.TTF", 11,'outline') 
	
	tt:SetOwner(self,'ANCHOR_NONE')
	tt:SetPoint('bottomright',self,'topleft',0,5)
	for _,j in pairs({tt:GetRegions()}) do 
		if j:GetObjectType()=='Texture' then
			---@diagnostic disable-next-line: undefined-field
			j:SetBlendMode('add')
		end
	end
	tt:ClearLines()

	tt:AddDoubleLine("|cff03fcf4DarkAngel|r","v"..GetAddOnMetadata("DarkAngel",'version'),0.25,0.85,0.85,0.35,0.85,0.45)
	tt:AddLine(L["minimaptooltip"],0.45,0.65,0.65,1)
	
	tt:Show()
end)
minibtn:SetScript("OnLeave",function(self)
	DA.myHideMMTooltip()
end)

DarkAngel_minimapBtn:Hide()
DarkAngel_minimapBtn.menu=CreateFrame("Button", nil,UIParent)
DarkAngel_minimapBtn.menu.timerticked=0
DarkAngel_minimapBtn.menu.width  = 87
DarkAngel_minimapBtn.menu.height = 80
DarkAngel_minimapBtn.menu:SetBackdropColor(1, 1, 1, 1)
DarkAngel_minimapBtn.menu:SetSize(DarkAngel_minimapBtn.menu.width, DarkAngel_minimapBtn.menu.height)
DarkAngel_minimapBtn.menu:SetPoint("TOPRIGHT", DarkAngel_minimapBtn, "CENTER",-15,-15)
DarkAngel_minimapBtn.menu:EnableMouse(true)
DarkAngel_minimapBtn.menu:EnableMouseWheel(true)
DarkAngel_minimapBtn.menu.t=DarkAngel_minimapBtn.menu:CreateTexture(nil, "BACKGROUND"); DarkAngel_minimapBtn.menu.t:SetAllPoints(); DarkAngel_minimapBtn.menu.t:SetTexture(0.4,0.9,0.9, 0.6); DarkAngel_minimapBtn.menu.t:SetBlendMode('blend')
DarkAngel_minimapBtn.menu:SetMovable(true)
DarkAngel_minimapBtn.menu:SetResizable(true)
DarkAngel_minimapBtn.menu:Hide()
DarkAngel_minimapBtn.menu:SetScript("OnEnter",function() DarkAngel_minimapBtn.menu.timerticked=0 end)
function DA:MimimapMenu_Create()
	local listbtns={
		{'Guild',10,
		function()
			DarkAngel_minimapBtn.menu:Hide();

			DarkAngelGUI:Show()
			_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',true)
			_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',false)
		end}
	}

	for _,j in ipairs({
		{'Inviter',10,function()
			DarkAngel_minimapBtn.menu:Hide();
			DA_Inviter.OpenClose()
		end},
		{'Dispenser',10,function()
			DarkAngel_minimapBtn.menu:Hide();
			DA_Flasker:Show()
		end},
		{'Awarder',10,function()
			DarkAngel_minimapBtn.menu:Hide();
			DA_Awarder.OpenClose()
		end},
		{'Log',10,function()
			DarkAngel_minimapBtn.menu:Hide();

			DarkAngelGUI:Show()
			_G['DarkAngelGUI']['Logbtn']:Click('LeftButton',true)
			_G['DarkAngelGUI']['Logbtn']:Click('LeftButton',false)
		end},
	}) do
		if self.modules[j[1]] and self.modules[j[1]]:IsEnabled() then
			tinsert(listbtns, j)
		end
	end

	if DA.loaded_Modules['BidTracker'] then
		tinsert(listbtns, {'Bid tool',10,
			function()
				if DA_BidTracker:IsShown() then
					DA_BidTracker:Hide()
				else
					DarkAngel_minimapBtn.menu:Hide()
					DA_BidTracker:Show()
				end
			end}
		)
	end

if IsGuildLeader() then
	tinsert(listbtns,
		{'Guild control',10,
		function()
			DarkAngel_minimapBtn.menu:Hide();

			DarkAngelGUI:Show()
			_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',true)
			_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',false)

			DarkAngelGUI.Guild.OpenGC_Btn:Click()
			DarkAngelGUI.Guild.GC:Show()
		end}
	)
end


	for i,j in pairs(listbtns) do
		DA.CreateFFGButton2(nil,DarkAngel_minimapBtn.menu,{"LEFT",DarkAngel_minimapBtn.menu,"TOPLEFT",2,5-15*i},14,83,j[1],
		'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), j[2]},j[3],nil,'middle','left').fs:SetTextColor(0.1,0.1,0.1,0.8)
	end

	DarkAngel_minimapBtn.menu:SetSize(87,#listbtns*15+3)

end