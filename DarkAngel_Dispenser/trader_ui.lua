
---@class DarkAngelAddon
local DA = DarkAngel
local L = LibStub("AceLocale-3.0"):GetLocale("DarkAngel")
local Mod = DA:NewModule("Dispenser")


DA_Flasker = DA.FrameCreater(nil,UIParent,100,180,{"TOPLEFT", UIParent, "CENTER", 0, 0},[[Interface\AddOns\DarkAngel\template\pict\art_trader]])
local F = DA_Flasker
F.cont={}
DA.CloseButtonCreater(nil,F,{"CENTER",F,"TOPRIGHT",-5,-5},8,8,'x',F:GetFrameLevel()+3)
DA.HelpCreater(F,{"CENTER",F,"TOPRIGHT",-15,-5},'dispenser_guide',8,8)

function Mod:OnInitialize()

	DA_Flasker:SetScale(fuckingOptions.FFFLScale)
	
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

local function IconGrabCreater(itemID,rel,point,heig,wid)
	local f = CreateFrame("Button", nil, rel, "UIDarkAngelIconicButton")
	local _, itemLink, _, _, _, _, _, _, _, itemTexture, _ = GetItemInfo(itemID)

	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	f:SetBackdropColor(1, 1, 1, 1)
	f:RegisterForClicks("LeftButtonUp","RightButtonUp")
	f:SetNormalTexture(itemTexture or GetItemIcon(itemID))
	f:SetMovable(false)
	f:RegisterForDrag("LeftButton")
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
local function Flasker_Load()
	for i,id in pairs({46377,46376,46379,40211,40212,40093,22828,9036,44939,44329,44328,40097,46378,40079,40076,42994,43523}) do
		IconGrabCreater(id,  F.optionsFrame,  {"BOTTOMLEFT",F.optionsFrame,"BOTTOMLEFT", -17+i*20, 5},  20,  20)
	end

end
function Mod:OnEnable()
	DarkAngel_FlaskerDB = DarkAngel_FlaskerDB or {}

	if #DarkAngel_FlaskerDB==0 then
		DarkAngel_FlaskerDB = {
			{
				{
					{id=46379,count=1,texture="Interface\\Icons\\INV_Alchemy_EndlessFlask_05",itemlink="|cffffffff|Hitem:46379:0:0:0:0:0:0:0:80|h[Flask of Stoneblood]|h|r"},
					{id=40093,count=6,texture="Interface\\Icons\\INV_Alchemy_Elixir_Empty",itemlink="|cffffffff|Hitem:40093:0:0:0:0:0:0:0:80|h[Indestructible Potion]|h|r"},
					{id=44939,count=1,texture="Interface\\Icons\\INV_Potion_118",itemlink="|cffffffff|Hitem:44939:0:0:0:0:0:0:0:80|h[Lesser Flask of Resistance]|h|r"},
				},
				{
					{id=46376,count=1,texture="Interface\\Icons\\INV_Alchemy_EndlessFlask_04",itemlink="|cffffffff|Hitem:46376:0:0:0:0:0:0:0:80|h[Flask of the Frost Wyrm]|h|r"},
				},
				{
					{id=46377,count=1,texture="Interface\\Icons\\INV_Alchemy_EndlessFlask_06",itemlink="|cffffffff|Hitem:46377:0:0:0:0:0:0:0:80|h[Flask of Endless Rage]|h|r"},
					{id=40211,count=3,texture="Interface\\Icons\\INV_Alchemy_Elixir_04",itemlink="|cffffffff|Hitem:40211:0:0:0:0:0:0:0:80|h[Potion of Speed]|h|r"},
				},
				{
					{id=46376,count=1,texture="Interface\\Icons\\INV_Alchemy_EndlessFlask_04",itemlink="|cffffffff|Hitem:46376:0:0:0:0:0:0:0:80|h[Flask of the Frost Wyrm]|h|r"},
					{id=40212,count=3,texture="Interface\\Icons\\INV_Alchemy_Elixir_01",itemlink="|cffffffff|Hitem:40212:0:0:0:0:0:0:0:80|h[Potion of Wild Magic]|h|r"},
				},
				setname = "default",


			}
		}
	else
		for _, set in ipairs(DarkAngel_FlaskerDB) do
			for _,roleset in ipairs(set) do
				for n=1,5 do
					local itemtbl = roleset[n]
					if itemtbl and itemtbl.id then
						local id = itemtbl.id
						local name = itemtbl.nameLocalized
						local link = itemtbl.itemlink
						local texture = itemtbl.texture

						local itemName, itemLink, _, _, _, _, _, _, _, itemTexture = GetItemInfo(id)
						if not name or (itemName and itemName~=name) then
							itemtbl.nameLocalized = itemName
						end
						if not link or (itemLink and itemLink~=link) then
							itemtbl.itemlink = itemLink
						end
						if not texture or (itemTexture and itemTexture~=texture) then
							itemtbl.texture = itemTexture
						end
					end
				end
			end
		end
		
		local function isEmptyTable(t)
			return next(t) == nil
		end

		local function removeEmptySecondLevelTables(tbl)
			if #tbl<2 then return end
			
			for i = #tbl, 2, -1 do
				local sub = tbl[i]
				local allEmpty = true

				for _, child in ipairs(sub) do
					if not isEmptyTable(child) then
						allEmpty = false
						break
					end
				end

				if allEmpty then
					table.remove(tbl, i)
				end
			end
		end
		removeEmptySecondLevelTables(DarkAngel_FlaskerDB)
	end
    Flasker_Load()
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


-- F.add:SetFrameLevel(0)
F:RegisterForDrag("LeftButton")
F:SetScript("OnDragStart", function(self) self:StartMoving() end)
F:SetScript("OnDragStop", function(self)

	self:StopMovingOrSizing(self)

	local point={DA_Flasker:GetPoint(1)}
	fuckingOptions.saved_guiPositions.DA_Flasker={point[1] or "TOPLEFT",point[3] or "CENTER",point[4] or 0,point[5] or 0}

end)
DA.CreateScaler('DA_Flasker',0.8,2,{'fuckingOptions','FFFLScale'})

local TR_SelectedSet_UI=1

local function check_reRenderFlasker45()
	local unlock4
	local unlock5

	for _,roleset in ipairs(DarkAngel_FlaskerDB[TR_SelectedSet_UI]) do
		for n=3,5 do
			local itemtbl = roleset[n]
			if itemtbl then
				local id = itemtbl.id
				if id and n>=4 then
					unlock4=true
					unlock5=true
				end
				if id and n==3 then
					unlock4=true
				end
			end
			if unlock5 then break end
		end
		if unlock5 then break end
	end

	for role=1,4 do
		if unlock5 then
			F.cont[role][5]:Show()
			F.cont[role][4]:Show()
			F:SetSize(160,180)
		elseif unlock4 then
			F.cont[role][5]:Hide()
			F.cont[role][4]:Show()
			F:SetSize(130,180)

		else
			F.cont[role][5]:Hide()
			F.cont[role][4]:Hide()
			F:SetSize(100,180)

		end
	end
end
local function create_flask_buttons()
	for role=1,4 do
		F.cont[role] = F.cont[role] or {}
		local pointy = -10 + (((-role)+1)*40)
		for dispenseID=1,5 do
			local pointx = 5 + ((dispenseID-1 ) * 30)

			F.cont[role][dispenseID] = DA.ButtonCreater(nil,F,{"TOPLEFT", F, "TOPLEFT", pointx, pointy},30,30,"")
			local f = F.cont[role][dispenseID]

			f:SetNormalTexture('Interface\\PaperDoll\\UI-Backpack-EmptySlot')
				f:GetNormalTexture():SetTexCoord(0,1,0,1)
			f:SetPushedTexture('Interface\\PaperDoll\\UI-Backpack-EmptySlot')
				f:GetPushedTexture():SetTexCoord(-0.1,1.1,-0.1,1.1)

			f.pm_Frame = DA.FrameCreater(nil,f,30,12,{"TOP", f, "BOTTOM", 0, -0.5})
			f.pm_Frame:EnableMouse(false)
			f.pm_Frame:Hide()

			f.c = DA.FontCreater(nil,"1",{"CENTER", f.pm_Frame, "CENTER", 0, 0},f.pm_Frame,70,70,{UIDarkAngelFontConsolas:GetFont(), 13, "OUTLINE"},'center')

			f.pm_Frame:SetScript("OnMouseWheel",function(_,dir)
				if dir>0 then
					if tonumber(f.c:GetText())< (select(8,GetItemInfo(DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].id)) or 20 )then
						f.c:SetText(tostring(tonumber(f.c:GetText())+1 ))
						DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].count=tonumber(f.c:GetText())
					end
				else
					if tonumber(f.c:GetText())>1 then
						f.c:SetText(tostring(tonumber(f.c:GetText())-1 ))
						DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].count=tonumber(f.c:GetText())
					end
				end
			end)
			f.m = DA.ButtonCreater(nil,f.pm_Frame,{"LEFT", f.pm_Frame, "LEFT", 1, 0},8,8,"-",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],function(self)
				if tonumber(f.c:GetText())>1 then
					f.c:SetText(tostring(tonumber(f.c:GetText())-1 ))
					DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].count=tonumber(f.c:GetText())
				end
			end)
			f.p = DA.ButtonCreater(nil,f.pm_Frame,{"RIGHT", f.pm_Frame, "RIGHT", -1, 0},8,8,"+",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],function(self)
				if tonumber(f.c:GetText())< (select(8,GetItemInfo(DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].id)) or 20 )then
					f.c:SetText(tostring(tonumber(f.c:GetText())+1 ))
					DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].count=tonumber(f.c:GetText())
				end
			end)


			f:SetScript("OnClick", function(self,mouse)
				if mouse=="RightButton" then
					self:SetPushedTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
					self:SetNormalTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
					self:GetNormalTexture():SetBlendMode('add')
					self:GetPushedTexture():SetBlendMode('add')
					DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID]=nil
					
					self.pm_Frame:Hide()
					GameTooltip:Hide()
				else
					if (CursorHasItem() or (({GetCursorInfo()})[1] and ({GetCursorInfo()})[1]=='item')) and mouse=="LeftButton" then
						self.pm_Frame:Show()
						self.c:SetText("1")
						local _,_,z=GetCursorInfo()
						local itemName,itemLink,_,_,_,_,_,_,_,texture=GetItemInfo(z);
						local itemID = tonumber(itemLink:match("item:(%d+)") or 0)

						self:SetPushedTexture(texture)
						self:SetNormalTexture(texture)
						self:GetNormalTexture():SetBlendMode('blend')
						self:GetPushedTexture():SetBlendMode('blend')
						if not DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID] then
							DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID] = {
								id = itemID,
								count = 1,
								texture = texture,
								itemlink = itemLink,
								nameLocalized = itemName
							}
						else
							DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].id=itemID
							DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].count=1
							DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].texture=texture
							DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].itemlink=itemLink
							DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].nameLocalized=itemName
						end
					else
						local entry = DarkAngel_FlaskerDB and DarkAngel_FlaskerDB[TR_SelectedSet_UI]
							and DarkAngel_FlaskerDB[TR_SelectedSet_UI][role]
							and DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID]
						if entry and entry.id then
							PickupItem(entry.id)
						end
					end
				end

				if dispenseID>2 then
					check_reRenderFlasker45()
				end
			end)
			f:SetScript("OnEnter", function(self)
				if DarkAngel_FlaskerDB[TR_SelectedSet_UI] and DarkAngel_FlaskerDB[TR_SelectedSet_UI][role] and DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID] and DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].id then
					local itemLink=DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID].itemlink
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
			f:RegisterForDrag("LeftButton")
			f:SetScript("OnDragStart", function() 
				local entry = DarkAngel_FlaskerDB and DarkAngel_FlaskerDB[TR_SelectedSet_UI]
					and DarkAngel_FlaskerDB[TR_SelectedSet_UI][role]
					and DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID]
				if entry and entry.id then
					PickupItem(entry.id)
				end
			end)
		end
	end
end

local function Dispenser_ReRender()
	for role=1,4 do
		for dispenseID=1,5 do
			local f = F.cont[role][dispenseID]
			local itemSet = DarkAngel_FlaskerDB[TR_SelectedSet_UI] and DarkAngel_FlaskerDB[TR_SelectedSet_UI][role] and DarkAngel_FlaskerDB[TR_SelectedSet_UI][role][dispenseID]
			if itemSet and itemSet.id and itemSet.texture then
				f.c:SetText(itemSet.count or "1")
				f:SetNormalTexture(itemSet.texture)
				f:SetPushedTexture(itemSet.texture)
				f:GetNormalTexture():SetBlendMode('blend')
				f:GetPushedTexture():SetBlendMode('blend')
				f.pm_Frame:Show()
			else
				f:SetNormalTexture('Interface\\PaperDoll\\UI-Backpack-EmptySlot')
				f:SetPushedTexture('Interface\\PaperDoll\\UI-Backpack-EmptySlot')
				f:GetNormalTexture():SetBlendMode('add')
				f:GetPushedTexture():SetBlendMode('add')
				f.pm_Frame:Hide()
				f.c:SetText("1")
			end
		end
	end
	F.Controls.naboredit:SetText(DarkAngel_FlaskerDB[TR_SelectedSet_UI].setname)
	check_reRenderFlasker45()
	for i=1,10 do
		if DarkAngel_FlaskerDB[i] then
			F.Controls.naborFrame.frcont[i]:SetText(DarkAngel_FlaskerDB[i].setname)
			if i==TR_SelectedSet_UI then
				F.Controls.naborFrame.frcont[i]:GetFontString():SetTextColor(0.3, 1, 1, 1)
			else
				F.Controls.naborFrame.frcont[i]:GetFontString():SetTextColor(0.85, 1, 1, 1)
			end
			F.Controls.naborFrame.frcont[i]:Show()
		else
			F.Controls.naborFrame.frcont[i]:Hide()
		end
	end
	F.Controls.naborFrame:SetSize(F.Controls.naborFrame.width, #DarkAngel_FlaskerDB*11 +17)
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

		
	do --SETS

		_,F.Controls.naborFrame=DA.CreateFFGDropFrame(F.Controls,"<"..L['profile']..">",12,(F.Controls.width)-6,{"CENTER", F.Controls, "TOP", 0, -12},70,110 +17,"BOTTOM",nil,function() end)
		F.Controls.naborFrame:ClearAllPoints()
		F.Controls.naborFrame:SetPoint("TOPLEFT", F.Controls, "TOPRIGHT", 2, 0)
		F.Controls.naborFrame:RegisterForDrag("LeftButton")
		F.Controls.naborFrame:SetScript("OnDragStart", function(self) self:GetParent():GetParent():StartMoving() end)
		F.Controls.naborFrame:SetScript("OnDragStop", function(self) self:GetParent():GetParent():StopMovingOrSizing() end)
		F.Controls.naborFrame.frcont = {}
		for i=1,10 do
			F.Controls.naborFrame.frcont[i] = DA.CreateFFGButton2(nil,F.Controls.naborFrame, {"TOPLEFT", F.Controls.naborFrame, "TOPLEFT", 2,10-11*i},10,F.Controls.naborFrame.width-4,"",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self)
				if DarkAngel_FlaskerDB[i] and TR_SelectedSet_UI~=i then
					TR_SelectedSet_UI = i
					Dispenser_ReRender()
					if DA.TR_SelSet == TR_SelectedSet_UI then
						F.Controls.startflBtn:Disable()
					else
						F.Controls.startflBtn:Enable()
					end
					if fuckingOptions_g[DA_CurrentGuild].dispenser_hide_on_set_selection then F.Controls.naborFrame:Hide() end
				end
			end)
			F.Controls.naborFrame.frcont[i]:Hide()
		end
		
		DA.CreateFFGButton2(nil,F.Controls.naborFrame,{"CENTER", F.Controls.naborFrame, "BOTTOM", -19,9},12,28,'+++',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self) 
			local naborscount=#DarkAngel_FlaskerDB
			if naborscount>9 then DA.Print('there is too much') return end
			
			DarkAngel_FlaskerDB[naborscount+1]={
				{},
				{},
				{},
				{},
				setname = "new set"
			}
			Dispenser_ReRender()
		end)
		DA.CheckBtnCreater(nil,F.Controls.naborFrame,{"CENTER",F.Controls.naborFrame,"BOTTOMRIGHT",-30,9},12,12,"hide",
			function(self) fuckingOptions_g[DA_CurrentGuild].dispenser_hide_on_set_selection=(self:GetChecked() or false) end,
			{'fuckingOptions_g','dispenser_hide_on_set_selection','DA_CurrentGuild'}, 'dispenser_hide_on_set_selection')

		local function rename_set(eb)
			local text=eb:GetText()
			if text then
				DarkAngel_FlaskerDB[TR_SelectedSet_UI].setname = text
				Dispenser_ReRender()
			end
		end
		
		F.Controls.naboredit=DA.EditBoxCreater(nil,F.Controls,{"CENTER", F.Controls, "TOP", 0,-26},{(F.Controls.width)-6,12},"",false,false,{UIDarkAngelFontConsolas:GetFont(), 9},
			function(self) 		if self.focusgained then self.t:SetBlendMode("ADD") self:ClearFocus(); self.focusgained=nil; self:HighlightText(0,0); rename_set(self) end end,
			function(self) 		if self.focusgained then self.t:SetBlendMode("ADD") self:ClearFocus(); self.focusgained=nil; self:HighlightText(0,0); rename_set(self) end end, --enter here
			function(self) 		if self.focusgained then self.t:SetBlendMode("ADD") self:ClearFocus(); self.focusgained=nil; self:HighlightText(0,0); rename_set(self) end end,
			function(self)
				if self:GetParent():IsShown() then
					self.t:SetBlendMode('blend');
					self.focusgained=1
					self:HighlightText()
				end
			end
		)
		F.Controls.naboredit:HookScript("OnEnter",function(self)
			DA.myShowTooltip(self,L["rename set"])
		end)
		F.Controls.naboredit:HookScript("OnLeave",function(self)
			DA.myHideTooltip()
		end)
		
		
	end

	Dispenser_ReRender()

	
end

F.Controls=DA.FrameCreater(nil,F,70,90,{"TOPLEFT", F,"TOPRIGHT",2,0})
F.optionsFrame=DA.FrameCreater(nil,F,360,100,{'BOTTOMLEFT',F,'TOPLEFT',0,2})
F.optionsFrame:RegisterForDrag("LeftButton")
F.optionsFrame:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
F.optionsFrame:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
-- F.optionsFrame.add:SetFrameLevel(0)
	DA.CloseButtonCreater(nil,F.optionsFrame,{"TOPRIGHT", F.optionsFrame, "TOPRIGHT", -3,-3},10,10,'x')
do --contents
	F.Controls:EnableMouse(true)
	F.Controls:SetMovable(true)
	F.Controls:SetResizable(false)
	F.Controls:SetMinResize(100, 100)
	F.Controls:RegisterForDrag("LeftButton")
	F.Controls:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
	F.Controls:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)

	F.Controls:Show()


	for _, t in ipairs({
		{"T\nA\nN\nK",2},
		{"H\nE\nA\nL",-38},
		{"M\nE\nL\nE",-78},
		{"C\nA\nS\nT",-118}
	}) do
		DA.FontCreater(nil,t[1],{"TOPLEFT", F, "TOPLEFT", -5, t[2]},F,60,17,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"})
	end
	create_flask_buttons()


	F.Controls.startflBtn = DA.CreateFFGButton2(nil,F.Controls,{"CENTER", F.Controls, "TOP", -(F.Controls.width/4), -50}, 12, (F.Controls.width/2)-6,L['start'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]], {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
		if not IsInRaid() then
			DA.Print(L['You are not in raid'])
			return
		end
		local set_has_contents
		for _,roleset in ipairs(DarkAngel_FlaskerDB[TR_SelectedSet_UI]) do
			for n=1,5 do
				local itemtbl = roleset[n]
				if itemtbl and itemtbl.id then
					set_has_contents = true
				end
				if set_has_contents then break end
			end
			if set_has_contents then break end
		end
		if not set_has_contents then
			DA.Print(L['empty set'])
			return
		end

		F.Controls.stopflBtn:Enable()
		self:Disable()
		DA.TR_start(TR_SelectedSet_UI)

	end)

	F.Controls.stopflBtn=DA.CreateFFGButton2(nil,  F.Controls,  {"CENTER", F.Controls, "TOP", (F.Controls.width/4), -50}, 12, (F.Controls.width/2)-6,  L["stop"],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]], {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
		DA.TR_stop()
		self:Disable()
		F.Controls.startflBtn:Enable()
	end)
	F.Controls.stopflBtn:Disable()


	DA.CreateFFGButton2(nil,  F.Controls,  {"CENTER", F.Controls, "TOP", 0, -65},  12,  F.Controls.width-6,  L['clear'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]], {UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
		table.wipe(DA.TR_Names)
		if TradeFrame:IsShown() then
			DA.TR_routine(nil,'TRADE_SHOW')
		end
	end,'disp_clear')

	DA.CreateFFGButton2(nil,F.Controls,{"CENTER", F.Controls, "TOP", 0, -80}, 12, F.Controls.width-6 , L['options'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
		if F.optionsFrame:IsShown() then
			F.optionsFrame:Hide()
		else
			F.optionsFrame:Show()
		end
	end)




end

function Mod:CreateAwarderFlasksChecker()
	local btn = DA.CreateFFGButton2(nil,DA_Awarder,{"CENTER", DA_Awarder, "TOPRIGHT", -10,-102},13,13,'',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
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
	btn:GetNormalTexture():SetTexCoord(0.02, 0.98, 0.02, 0.98)
	btn:GetNormalTexture():SetBlendMode('blend')

	btn:SetPushedTexture("Interface\\Icons\\Trade_Alchemy")
	btn:GetPushedTexture():SetTexCoord(0,1,0,1)
	btn:GetPushedTexture():SetBlendMode('blend')

end