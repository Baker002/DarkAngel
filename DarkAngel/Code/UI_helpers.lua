
---@class DarkAngelAddon
local DA = DarkAngel
local L = DA.L

DA.RolesTextures = {
	tank   = [[Interface\AddOns\DarkAngel\template\tankIconTr]],
	healer = [[Interface\AddOns\DarkAngel\template\healerIconTr]],
	melee    = [[Interface\AddOns\DarkAngel\template\dpsIconTr]],
	caster	=	[[Interface\AddOns\DarkAngel\template\rangedDpsIconTr]]
}
-- GUI Builders
function DA.FrameCreater(name,rel,width,heigh,point,artTexture,customBGcolor, moreframelvl, alwaysDarkFrame)
	local f=CreateFrame("Frame", name, rel)
	f.width  = width
	f.height = heigh
	f:SetBackdropColor(1, 1, 1, 1)
	f:SetFrameStrata("HIGH")
	f:SetSize(f.width, f.height)
	if point then f:SetPoint(unpack(point)) end


	f:EnableMouse(true)
	f:EnableMouseWheel(true)
	-- local texture = f:CreateTexture(nil, "BACKGROUND"); texture:SetAllPoints(); texture:SetTexture(21/255, 18/255, 22/255, 0.45); texture:SetBlendMode("blend")
	
	
	f:SetMovable(true)
	f:Hide()

	f:SetFrameLevel(rel:GetFrameLevel() + 2 +(moreframelvl and 35 or 0) )
	local fl = f:GetFrameLevel()
	
	f.tf=CreateFrame("Frame",nil,f)
	f.tf:SetFrameLevel(fl-1)
	-- f.tf:SetFrameLevel(math.max(fl-2, 0))
	f.tf:SetSize(f.width, f.height)
	f.tf:SetAllPoints(f)
	f.tf:SetBackdropColor(1, 1, 1, 1)
	f.t =f.tf:CreateTexture(nil, "BACKGROUND",nil,-2)
		f.t:SetAllPoints(f.tf);
		if customBGcolor then
			f.t.myStoredTxt = {customBGcolor[1], customBGcolor[2], customBGcolor[3], customBGcolor[4]}
			f.t:SetTexture(customBGcolor[1], customBGcolor[2], customBGcolor[3],  (customBGcolor[4] or fuckingOptions.TXTBgOpacity or 0.5));
		else
			f.t:SetTexture(21/255, 18/255, 22/255, (alwaysDarkFrame and 0.8 or fuckingOptions.TXTBgOpacity or 0.5))
		end
		f.t:SetBlendMode(fuckingOptions.TXTBgTransp and not alwaysDarkFrame and "add" or "blend")


	if artTexture then
		f.art=CreateFrame("Frame",nil,f)
		f.art:SetFrameLevel(fl-1)
		f.art:SetSize(f.width, f.height)
		f.art:SetAllPoints(f)
		f.art:SetBackdropColor(1, 1, 1, 1)

		f.art.t = f.art:CreateTexture(nil, "BACKGROUND")
		f.art.t:SetAllPoints(f.art)
		f.art.t:SetTexture(artTexture);
		f.art.t:SetAlpha(fuckingOptions.TXTartOpacity or 0.8)
		f.art.t:SetBlendMode(fuckingOptions.TXTArtTransp and "add" or "blend")
		
		if fuckingOptions.TXTArtOnFront then
			f.art.t:SetDrawLayer('ARTWORK')
			f.t:SetDrawLayer('BACKGROUND')
		else
			f.art.t:SetDrawLayer('BACKGROUND')
			f.t:SetDrawLayer('ARTWORK')
		end
	end
	
	if not alwaysDarkFrame then
		table.insert(DA.DrawnFrames, f)
	end
	return f
end
function DA.CreateFFGButton2(name,rel,point,heig,wid,settext,ntxt,fonttype,onclickscr,desrtag,Vjust,Hjust)
	local f
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
	if onclickscr then f:SetScript("OnClick", onclickscr) end
	f.fs=f:GetFontString()
	if fonttype then f.fs:SetFont(unpack(fonttype)) end
	if Vjust then f.fs:SetJustifyV(Vjust) end
	if Hjust then f.fs:SetJustifyH(Hjust) end
	if Vjust or Hjust then f.fs:SetAllPoints() end
	
	if desrtag then
		local description
		local cond
		if type(desrtag)=='table' then
			if type(desrtag[1])~='function' then
				DA.Print('error 123')
			else
				description = L['DESCr-'..desrtag[2]]
				cond = desrtag[1]
			end

		else
			description = L['DESCr-'..desrtag]
		end

		if description then
			f:SetScript("OnEnter", function(self)
				if not cond or cond() then
					DA.myShowTooltip(self,description)
				end
			end)
			
			f:SetScript("OnLeave", function(self)
				DA.myHideTooltip()
			end)
		end
	end
	
	f:Show()
	return f
end
function DA.CreateFFGDropFrame(rel,text,heigh,width,point,frw,frh,frorient,justh,addfunctiononshow,addfunctiononhide,desrtag,alwaysDarkFrame)
	local button=DA.CreateFFGButton2(nil,rel,point,heigh,width,text,[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function() end,nil,nil,justh)
	local frpoint
	if not frorient then
		frorient="BOTTOMLEFT"
	end
	
	if type(frorient)=='table' then
		local p1, p2, dX, dY = unpack(frorient)
		frpoint = {p1, button, p2, dX, dY}
	elseif frorient=="TOPLEFT-right" then
		frpoint={'BOTTOMLEFT',button,'TOPLEFT'}
	elseif frorient=="BOTTOMLEFT" then
		frpoint={'TOPRIGHT',button,'BOTTOMLEFT'}
	elseif frorient=="BOTTOMRIGHT" then
		frpoint={'TOPLEFT',button,'BOTTOMRIGHT'}
	elseif frorient=="TOPRIGHT" then
		frpoint={'BOTTOMLEFT',button,'TOPRIGHT'}
	elseif frorient=="TOPLEFT" then
		frpoint={'BOTTOMRIGHT',button,'TOPLEFT'}
	elseif frorient=="TOP" then
		frpoint={'BOTTOM',button,'TOP'}
	elseif frorient=="BOTTOM" then
		frpoint={'TOP',button,'BOTTOM'}
	elseif frorient=="LEFT" then
		frpoint={'RIGHT',button,'LEFT'}
	elseif frorient=="RIGHT" then
		frpoint={'LEFT',button,'RIGHT'}
	end
	local frame=DA.FrameCreater(nil,rel,frw,frh,frpoint,nil,{0.03, 0.04, 0.07, 0.75},nil,alwaysDarkFrame)
	button:SetScript("OnClick",
		function()
			if frame:IsShown() then
				frame:Hide()
				if addfunctiononhide then
					addfunctiononhide(frame)
				end
			else
				frame:Show()
				if addfunctiononshow then
					addfunctiononshow(frame)
				end
			end
		end
	)
	-- frame:SetFrameLevel(99)
	frame:HookScript("OnHide",function() button:UnlockHighlight() end)
	frame:HookScript("OnShow",function() button:LockHighlight() end)
	if desrtag and L['DESCr-'..desrtag] then
		button:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,L['DESCr-'..desrtag])
		end)

		button:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
		end)
	end

	return button,frame
end
function DA.CreateDropdownSelector(d)
	local 	rel, 	point, 		height, 	width, 		title, frpoint, valuesroster, valuesrosterDynamic, justh, optjusth, isGuildDynamicValue, getValue, setValue, funcOnShow, funcOnHide, desrtag =
			d.rel, 	d.point, 	d.height,	d.width, 	d.title, d.frpoint, d.valuesroster, d.valuesrosterDynamic, d.justh, d.optjusth, d.isGuildDynamicValue, d.get, d.set, d.funcOnShow, d.funcOnHide, d.desrtag
	
	local function getRoster()
		if valuesrosterDynamic then
			local ok, result = DA.Safecall("[other]", valuesrosterDynamic)
			return result or {}
		else
			return valuesroster
		end
	end
	local btnwidth = width-2

	local button, frame = DA.CreateFFGDropFrame(rel,"",height,btnwidth,point,width,1,frpoint, justh, funcOnShow, funcOnHide, desrtag, true)
		frame:SetFrameLevel(rel:GetFrameLevel() + 15)
	local fontTitle

	function frame:reRender()
		local savedValue = getValue()
		local newrosterCount = 0
		for id,ss in ipairs(getRoster()) do
			local data = ss
			local text,value,isHidden,funcOnSelection,deskr,frameHideOnSelection,DrawLocked = data.text, data.value, data.isHidden, data.funcOnSelection, data.deskr, data.funcframeHideOnSelection, data.funcDrawLocked
			if not frame[id] then
				frame[id]=DA.CreateFFGButton2(nil,frame,{"TOPLEFT",frame, "TOPLEFT",1, (height-((height+1)*id))},height,btnwidth,text or "",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_White]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
					--func is set later anyways
				end,deskr,nil,optjusth or 'center')
			end
			if DrawLocked then
				local isLocked = DrawLocked() 
				if isLocked then
					frame[id]:Disable()
				else
					frame[id]:Enable()
				end
			end
			if savedValue == value then
				frame[id].fs:SetTextColor(0.2,1,1,1)
				button:SetText(text)
				
			else
				frame[id].fs:SetTextColor(0.85,1,1,1)
			end
			if isHidden then
				frame[id]:Hide()
			else
				frame[id]:SetText(text)
				frame[id]:SetScript("OnClick", function()
					setValue(value)
					if not frameHideOnSelection or frameHideOnSelection() then
						frame:Hide()
					end
					if funcOnSelection then DA.Safecall("[other]", funcOnSelection) end
					frame:reRender()
				end)
				newrosterCount = newrosterCount + 1
				frame[id]:Show()
			end
		end
		frame:SetSize(
			width ,
			(newrosterCount * (height+1)) + 1
		)
	end

	if title then
		local titleText, titleFontTable, titleRelPointTable = unpack(title)
		local titlePoint = titleRelPointTable and {
			titleRelPointTable[1],
			button,
			titleRelPointTable[2],
			titleRelPointTable[3] or 0,
			titleRelPointTable[4] or 10
		} or {"LEFT", button, "LEFT", 0, 10}

		fontTitle = DA.FontCreater(nil,titleText,titlePoint,button,15,180,titleFontTable,'left')
	end

	frame:reRender()
	if isGuildDynamicValue then
		table.insert(DA.RunOnGuildUpdate, frame.reRender)
		table.insert(DA.RunOnSettingsImport, frame.reRender)
	end

	return button, frame, fontTitle
end
function DA.CreateDropdownNoValueSelector(d)
	local 	rel, 	point, 		height, 	width, 		title, frpoint, valuesroster, valuesrosterDynamic, justh, optjusth, funcOnShow, funcOnHide, desrtag =
			d.rel, 	d.point, 	d.height,	d.width, 	d.title, d.frpoint, d.valuesroster, d.valuesrosterDynamic, d.justh, d.optjusth, d.funcOnShow, d.funcOnHide, d.desrtag
	local function getRoster()
		if valuesrosterDynamic then
			local ok, result = DA.Safecall("[other]", valuesrosterDynamic)
			return result or {}
		else
			return valuesroster
		end
	end
	local btnwidth = width-2

	
	local button, frame = DA.CreateFFGDropFrame(rel,"",height,btnwidth,point,width,1,frpoint, justh, funcOnShow, funcOnHide, desrtag, true)
		frame:SetFrameLevel(rel:GetFrameLevel() + 15)
	local fontTitle

	frame.storedvalue = false
	function frame:reRender()
		local roster = getRoster()
		if not frame.storedvalue then
			for id,ss in ipairs(roster) do
				local data = ss
				if id==1 or data.isDefault then
					frame.storedvalue = data.value
				end
			end
		end
		local savedValue = frame.storedvalue
		local newrosterCount = 0
		for id,ss in ipairs(roster) do
			local data = ss
			local text,value,isHidden,funcOnSelection,deskr,frameHideOnSelection,DrawLocked = data.text, data.value, data.isHidden, data.funcOnSelection, data.deskr, data.funcframeHideOnSelection, data.funcDrawLocked
			if not frame[id] then
				frame[id]=DA.CreateFFGButton2(nil,frame,{"TOPLEFT",frame, "TOPLEFT",1, (height-((height+1)*id))},height,btnwidth,text or "",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_White]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
					-- func is set later anyways
				end,deskr,nil,optjusth or 'center')
			end
			if DrawLocked then
				local isLocked = DrawLocked() 
				if isLocked then
					frame[id]:Disable()
				else
					frame[id]:Enable()
				end
			end

			if savedValue == value then
				frame[id].fs:SetTextColor(0.2,1,1,1)
				button:SetText(text)
			else
				frame[id].fs:SetTextColor(0.85,1,1,1)
			end
			if isHidden then
				frame[id]:Hide()
			else
				frame[id]:SetText(text)
				frame[id]:SetScript("OnClick", function()
					frame.storedvalue = value
					if not frameHideOnSelection or frameHideOnSelection() then
						frame:Hide()
					end
					if funcOnSelection then DA.Safecall("[other]", funcOnSelection) end
					frame:reRender()
				end)
				newrosterCount = newrosterCount + 1
				frame[id]:Show()
			end
		end
		frame:SetSize(
			width ,
			(newrosterCount * (height+1)) + 1
		)
	end

	if title then
		local titleText, titleFontTable, titleRelPointTable = unpack(title)
		local titlePoint = titleRelPointTable and {
			titleRelPointTable[1],
			button,
			titleRelPointTable[2],
			titleRelPointTable[3] or 0,
			titleRelPointTable[4] or 10
		} or {"LEFT", button, "LEFT", 0, 10}

		fontTitle = DA.FontCreater(nil,titleText,titlePoint,button,15,180,titleFontTable,'left')
	end

	frame:reRender()

	return button, frame, fontTitle
end
local function tabFrameCreater(rel,subname,ttt)
	_G[rel][subname]=CreateFrame("Frame", nil, _G[rel])
	local f = _G[rel][subname]
	f.width  = _G[rel].width
	f.height = _G[rel].height
	-- f:SetFrameStrata("HIGH")
	f:SetSize(f.width, f.height)
	f:SetAllPoints(_G[rel])
	f:SetBackdropColor(1, 1, 1, 1)
	-- f:SetFrameLevel(_G[rel]:GetFrameLevel()+25)
	local fl = f:GetFrameLevel()

	f.art=CreateFrame("Frame",nil,f)
	f.art:SetSize(f.width, f.height)
	f.art:SetAllPoints(f)
	f.art:SetBackdropColor(1, 1, 1, 1)
	f.art:SetFrameLevel(fl-1)
	f.art.t = f.art:CreateTexture(nil, "BACKGROUND")
		f.art.t:SetAllPoints(f.art)
		f.art.t:SetTexture(ttt);
		f.art.t:SetAlpha(fuckingOptions.TXTartOpacity or 0.8)
		f.art.t:SetBlendMode(fuckingOptions.TXTArtTransp and "add" or "blend")

	f:EnableMouse(true)
	f:EnableMouseWheel(true)
	f:SetMovable(true)
	f:SetResizable(true)
	-- f:SetMinResize(100, 100)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) _G[rel]:GetScript("OnDragStart")(_G[rel]) end )
	f:SetScript("OnDragStop",  function(self) _G[rel]:GetScript("OnDragStop")(_G[rel]) end )

	-- f:Hide()
	f.bgtxt=CreateFrame("Frame",nil,f)
	f.bgtxt:SetSize(f.width, f.height)
	f.bgtxt:SetAllPoints(f)
	f.bgtxt:SetBackdropColor(1, 1, 1, 1)
	f.bgtxt:SetFrameLevel(fl-1)
		f.bgtxt.t =f.bgtxt:CreateTexture(nil, "BACKGROUND"); 
		f.bgtxt.t:SetAllPoints(f.bgtxt); 
		f.bgtxt.t:SetTexture(21/255, 18/255, 22/255, (fuckingOptions.TXTBgOpacity or 0.5));
		f.bgtxt.t:SetBlendMode(fuckingOptions.TXTBgTransp and "add" or "blend")

	if fuckingOptions.TXTArtOnFront then
		-- f.art:SetFrameLevel(math.max(fl-1, 0))
		-- f.bgtxt:SetFrameLevel(math.max(fl-2, 0))
		f.art.t:SetDrawLayer('ARTWORK')
		f.bgtxt.t:SetDrawLayer('BACKGROUND')
	else
		-- f.art:SetFrameLevel(math.max(fl-2, 0))
		-- f.bgtxt:SetFrameLevel(math.max(fl-1, 0))
		f.art.t:SetDrawLayer('BACKGROUND')
		f.bgtxt.t:SetDrawLayer('ARTWORK')
	end


end
function DA.TabCreater(point,heig,wid,heigt,widt,settext,fonttype,onclickscr,onclickscr2,textur)

	tabFrameCreater("DarkAngelGUI",settext,textur)

	local f = CreateFrame("Button", nil, _G["DarkAngelGUI"],"UIDarkAngelButtonTabs")
	f:SetNormalTexture(nil)
	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	f:RegisterForClicks("AnyUp",'AnyDown')
	f.fs = f:CreateFontString(nil, "ARTWORK", _G["DarkAngelGUI"])
		f.fs:SetFont(unpack(fonttype))
		f.fs:SetPoint(unpack(point))
		f.fs:SetHeight(heigt)
		f.fs:SetWidth(widt)
		f.fs:SetText(settext)
		f.fs:SetTextColor(0.85,1,1,1)

	f.mytext=settext
	f.txt = f:CreateTexture(nil, "BACKGROUND"); f.txt:SetAllPoints(); f.txt:SetTexture(21/255, 18/255, 22/255, 0.45); f.txt:SetBlendMode("blend")

	local function settab(tab)
		for n,t in pairs(_G["DarkAngelGUI"]['tabsl']) do
			if t==tab then
				_G['DarkAngelGUI'][_G["DarkAngelGUI"]['tabsl'][n]]:Show()
				_G['DarkAngelGUI'][_G["DarkAngelGUI"]['tabsl'][n]..'btn']:SetButtonState('PUSHED',true)
			else
				_G['DarkAngelGUI'][_G["DarkAngelGUI"]['tabsl'][n]]:Hide()
				_G['DarkAngelGUI'][_G["DarkAngelGUI"]['tabsl'][n]..'btn']:SetButtonState('NORMAL',false)
			end
		end
	end

	if onclickscr then f:SetScript("OnClick", function(self,clicktype,updown) if updown then settab(self.mytext);onclickscr(self) else onclickscr2(self) end  end) end
	-- if customscr1 then f:SetScript(unpack(customscr1)) end
	-- if customscr2 then f:SetScript(unpack(customscr2)) end
	_G["DarkAngelGUI"][settext..'btn']=f
	_G["DarkAngelGUI"]['tabsl']=_G["DarkAngelGUI"]['tabsl'] or {}
	table.insert(_G["DarkAngelGUI"]['tabsl'],settext)

	return f
end
function DA.CloseButtonCreater(name,rel,point,heig,wid,settext,framelevel)
local f = CreateFrame("Button", name, rel, "UIDarkAngelCloseButton")
	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	f:SetBackdropColor(1, 1, 1, 1)
	f:RegisterForClicks("LeftButtonUp","RightButtonUp")
	f:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up]])
	-- f:SetScript("OnClick", HideParentPanel)
	f:SetText(settext)
	if framelevel then
		f:SetFrameLevel(framelevel or 104)
	else
		f:SetFrameLevel(rel:GetFrameLevel() + 3)
	end
rel.myclosebtn=f
	return f
end
function DA.ButtonCreater(name,rel,point,heig,wid,settext,ntxt,onclickscr,justh,desrtag)
local f = CreateFrame("Button", name, rel, "UIDarkAngelButtonTemplate2")
	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	f:SetBackdropColor(1, 1, 1, 1)
	f:RegisterForClicks("LeftButtonUp","RightButtonUp")
	if ntxt then f:SetNormalTexture(ntxt) end
	if onclickscr then f:SetScript("OnClick", onclickscr) end
	if justh then
		f:SetText('')
		if justh:lower()=='left' then
			f.fs=DA.FontCreater(nil,settext,{'left',f,'left',3,0},f,15,170,{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},justh,{0.5,0.9,1,1})
		elseif justh:lower()=='right' then
			f.fs=DA.FontCreater(nil,settext,{'right',f,'right',-3,0},f,15,170,{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},justh,{0.5,0.9,1,1})
		elseif justh:lower()=='center' then
			f.fs=DA.FontCreater(nil,settext,{'center',f,'center'},f,15,170,{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},justh,{0.5,0.9,1,1})
		end

	else
		f:SetText(settext)
	end

	if desrtag and L['DESCr-'..desrtag] then
		f:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,L['DESCr-'..desrtag])
		end)

		f:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
		end)
	end

	return f
end
function DA.IconicButtonCreater(rel,point,size,texture,onclickscr,descrtext,customscript)
local f = CreateFrame("Button", nil, rel, "UIDarkAngelIconicButton")
	f:SetPoint(unpack(point))
	f:SetHeight(size)
	f:SetWidth(size)
	f:SetBackdropColor(1, 1, 1, 1)
	f:RegisterForClicks("LeftButtonUp","RightButtonUp")
	f:SetNormalTexture(texture)
	f:SetPushedTexture(nil)
	f:SetPushedTextOffset(1.56, -1.56)
	f:SetScript("OnClick", function(self)
		if customscript and customscript() then
		else
			if self:GetNormalTexture():IsDesaturated() then
				self:GetNormalTexture():SetDesaturated(false)
				self:SetAlpha(1)
				self.isenabled=true
			else
				self:GetNormalTexture():SetDesaturated(true)
				self:SetAlpha(0.6)
				self.isenabled=nil
			end
			if onclickscr then onclickscr(self) end
		end
		f:GetScript("OnLeave")(f)
		f:GetScript("OnEnter")(f)
	end)
	f.switch=function(state)
		if not f:GetNormalTexture() then return end
		if state then
			f:GetNormalTexture():SetDesaturated(false)
			f:SetAlpha(1)
			f.isenabled=true
		else
			f:GetNormalTexture():SetDesaturated(true)
			f:SetAlpha(0.6)
			f.isenabled=nil
		end
	end
	f.isenabled = true
	if descrtext then
		f:SetScript("OnEnter", function(self)
			self:SetAlpha(1)
			if type(descrtext)=='string' or type(descrtext)=='number' then
				DA.myShowTooltip(self,tostring(descrtext))
			elseif type(descrtext)=='function' then
				DA.myShowTooltip(self,tostring(descrtext()))
			end

		end)

		f:SetScript("OnLeave", function(self)
			if self.isenabled then
				self:SetAlpha(1)
			else
				self:SetAlpha(0.6)
			end
			DA.myHideTooltip()
		end)
	end

	return f
end
function DA.OptionsButtonCreater(name,rel,point,heig,wid,onclickscr,desrtag)
local f = CreateFrame("Button", name, rel, "UIDarkAngelOptionsButtonButton")
	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	f:SetBackdropColor(1, 1, 1, 1)
	f:RegisterForClicks("LeftButtonUp","RightButtonUp")
	if onclickscr then f:SetScript("OnClick", onclickscr) end

	if desrtag and L['DESCr-'..desrtag] then
		f:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,L['DESCr-'..desrtag])
		end)

		f:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
		end)
	end
	f:SetAlpha(1)
	return f
end
function DA.SliderCreater(name,rel,point,heig,wid,smin,smax,stepsize,setvalue,textmin,textmax,title,desrtag,funconapply)
	if not name then print('anonymous sliders are not allowed') return end
	if not smin then print('no min specified') return end
	if not smax then print('no max specified') return end

	local f = CreateFrame("Slider", name, rel, "OptionsSliderTemplate")
	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	f:SetBackdropColor(1, 1, 1, 1)
	f:SetOrientation('HORIZONTAL')
	f:SetMinMaxValues(smin,smax)
	f:SetValueStep(stepsize)

	if setvalue then
		if setvalue[3] then
			
			local function UpdateValue()
				local val = _G[setvalue[1]][_G[setvalue[3]]][setvalue[2]]
				f:SetValue(val)
			end
			UpdateValue()
			table.insert(DA.RunOnGuildUpdate, UpdateValue)

			f.val=DA.FontCreater(nil,_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]],{'center',f,'center',0,-10},f,15,170,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'center',{0.5,0.9,1,1})
			f:SetScript("OnMouseDown",function(self)
				self:SetScript("OnUpdate",function(self)
					local val=tonumber(string.format("%.3f", self:GetValue())); 
					_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]]=val;
					self.val:SetText(val)
				end)
			end)
			f:SetScript("OnMouseUp",function(self)
				self:SetScript("OnUpdate",nil)
				if funconapply then funconapply() end
			end)
			f:SetScript("OnHide",function(self)
				self:SetScript("OnUpdate",nil)
			end)
		else
			local function UpdateValue()
				local val = _G[setvalue[1]][setvalue[2]]
				f:SetValue(val)
			end
			UpdateValue()
			table.insert(DA.RunOnSettingsImport, UpdateValue)
			f.val=DA.FontCreater(nil,_G[setvalue[1]][setvalue[2]],{'center',f,'center',0,10},f,15,170,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'center',{0.5,0.9,1,1})
			f:SetScript("OnMouseDown",function(self)
				self:SetScript("OnUpdate",function(self)
					local val=tonumber(string.format("%.3f", self:GetValue())); _G[setvalue[1]][setvalue[2]]=val;self.val:SetText(val)
				end)
			end)
			f:SetScript("OnMouseUp",function(self)
				self:SetScript("OnUpdate",nil)
				if funconapply then funconapply() end
			end)
			f:SetScript("OnHide",function(self)
				self:SetScript("OnUpdate",nil)
			end)
		end

	elseif funconapply then
		f:SetScript("OnMouseUp",function(self)
			funconapply()
		end)

	end

	if textmin and getglobal(name .. 'Low') then getglobal(name .. 'Low'):SetText(textmin) end
	if textmax and getglobal(name .. 'High') then getglobal(name .. 'High'):SetText(textmax) end

	if title then
		f.title=DA.FontCreater(nil,title,{'left',f,'right',5,0},f,45,170,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'left',{0.5,0.9,1,1})
	end

	if desrtag and L['DESCr-'..desrtag] then
		f:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,L['DESCr-'..desrtag],nil,-10)
		end)

		f:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
		end)
	end
	-- f:GetThumbTexture():SetBlendMode('add')
	f:SetScale(0.7)
	f:SetAlpha(0.85)
	return f
end
function DA.SliderCreater2(name,rel,point,heig,wid,valuesRoster,valueFont,setvalue,textmin,textmax,title,desrtag,funconapply)
	local valuesRosterCount = #valuesRoster
	if valuesRosterCount == 0 then print('slider sets == 0') error() end
	local function getInRosterPosByVal(val)
		for i,entry in ipairs(valuesRoster) do
			if entry[1] == val then
				return i
			end
		end
	end
	local function getVal_FromSavedVar()
		if setvalue then
			if setvalue[3] then
				return getInRosterPosByVal(_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]])
			else
				return getInRosterPosByVal(_G[setvalue[1]][setvalue[2]])
			end
		else
			print('no setvalue')
			error()
		end
	end
	local function getText_FromSavedVar()
		local val = getVal_FromSavedVar()
		return valuesRoster[val][2]
	end
	local function getClosestNumber(target)
		local closest = nil
		local smallestDiff = math.huge

		for i = 1, valuesRosterCount do
			local num = valuesRoster[i][1]
			local diff = math.abs(num - target)

			if diff < smallestDiff then
				smallestDiff = diff
				closest = num
			end
		end

		return closest
	end
	
	local f = CreateFrame("Slider", name, rel, "OptionsSliderTemplate")
	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	f:SetHitRectInsets(-2, -2, -2, -2)
	f:SetBackdropColor(1, 1, 1, 1)
	f:SetOrientation('HORIZONTAL')
	f:SetMinMaxValues(1,valuesRosterCount)
	f:SetValueStep(1)

	if setvalue then
		local function UpdateValue()
			f:SetValue(getVal_FromSavedVar())
			f.val:SetText(getText_FromSavedVar())
		end
		function f:selfUpdateValue()
			UpdateValue()
		end
		if setvalue[3] then
			if not getInRosterPosByVal(_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]]) then
				_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]] = getClosestNumber(_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]])
			end
			f.val=DA.FontCreater(nil,getText_FromSavedVar(),{'center',f,'center',0,-10},f,15,170,valueFont,'center',{0.5,0.9,1,1})
			f:SetScript("OnMouseDown",function(self)
				self:SetScript("OnUpdate",function(self)
					local val=self:GetValue()
					_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]]=valuesRoster[val][1];
					self.val:SetText(valuesRoster[val][2])
				end)
			end)
			f:SetScript("OnMouseUp",function(self)
				self:SetScript("OnUpdate",nil)
				if funconapply then funconapply() end
			end)
			f:SetScript("OnHide",function(self)
				self:SetScript("OnUpdate",nil)
			end)

			UpdateValue()
			
			table.insert(DA.RunOnGuildUpdate, UpdateValue)
		else
			if not getInRosterPosByVal(_G[setvalue[1]][setvalue[2]]) then
				_G[setvalue[1]][setvalue[2]] = getClosestNumber(_G[setvalue[1]][setvalue[2]])
			end
			f:SetValue(getVal_FromSavedVar())
			f.val=DA.FontCreater(nil,getText_FromSavedVar(),{'center',f,'center',0,10},f,15,170,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'center',{0.5,0.9,1,1})
			f:SetScript("OnMouseDown",function(self)
				self:SetScript("OnUpdate",function(self)
					local val=self:GetValue()
					_G[setvalue[1]][setvalue[2]]=valuesRoster[val][1];
					self.val:SetText(valuesRoster[val][2])
				end)
			end)
			f:SetScript("OnMouseUp",function(self)
				self:SetScript("OnUpdate",nil)
				if funconapply then funconapply() end
			end)
			f:SetScript("OnHide",function(self)
				self:SetScript("OnUpdate",nil)
			end)
			table.insert(DA.RunOnSettingsImport, UpdateValue)
		end

	elseif funconapply then
		f:SetScript("OnMouseUp",function(self)
			funconapply()
		end)

	end

	if textmin and getglobal(name .. 'Low') then getglobal(name .. 'Low'):SetText(textmin) end
	if textmax and getglobal(name .. 'High') then getglobal(name .. 'High'):SetText(textmax) end

	if title then
		f.title=DA.FontCreater(nil,title,{'left',f,'right',5,0},f,45,170,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'left',{0.5,0.9,1,1})
	end

	if desrtag and L['DESCr-'..desrtag] then
		f:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,L['DESCr-'..desrtag],nil,-10)
		end)

		f:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
		end)
	end
	-- f:GetThumbTexture():SetBlendMode('add')
	f:SetScale(0.7)
	f:SetAlpha(0.85)
	return f
end
function DA.SecButtonCreater(name,rel,point,heig,wid,settext,onclickscr,justh,desrtag)
local f = CreateFrame("Button", name, rel, "UIDarkAngelSecureButton")
	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	f:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]])
		f:SetAttribute("type", "macro")
	f:SetBackdropColor(1, 1, 1, 1)
	f:RegisterForClicks("LeftButtonUp")
	if onclickscr then f:SetAttribute("macrotext", onclickscr) end
	if justh then
		f:SetText('')
		f.fs=DA.FontCreater(nil,settext,{'center',f,'center',0,0},f,15,wid,{UIDarkAngelFontConsolas:GetFont(), 10},justh,{0.5,0.9,1,1})
	else
		f:SetText(settext)
	end



	if desrtag and L['DESCr-'..desrtag] then
		f:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,L['DESCr-'..desrtag])
		end)

		f:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
		end)
	end

	return f
end
function DA.FontCreater(name,text,point,rel,heig,wid,fonttype,Hjust,txtcol,Vjust)
	local f = rel:CreateFontString(name, "ARTWORK")
	f:SetFont(unpack(fonttype))
	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	if txtcol then
		f:SetTextColor(unpack(txtcol))
	else
		f:SetTextColor(0.85,1,1,1)
	end
	if Vjust then f:SetJustifyV(Vjust) end
	if Hjust then f:SetJustifyH(Hjust) end
	f:SetText(text)
	f:SetShadowOffset(0.8,0.5)
	return f
end
function DA.HelpCreater(rel,point,desrtag,heig,wid)
local f = CreateFrame("Button", nil, rel, "UIDarkAngelButtonTemplate2")
	f:SetPoint(unpack(point))
	f:SetHeight(heig or 25)
	f:SetWidth(wid or 15)
	f:GetFontString():SetFont(UIDarkAngelFontConsolas:GetFont(), 8)
	f:GetFontString():SetTextColor(0.85,1,1,1)
	f:SetText("?")
	f:SetNormalTexture(nil)
	f:RegisterForClicks(false)
	if desrtag then
		local descrTT = L['DESCr-'..desrtag]
		if not descrTT then
			print("missing localization: ", desrtag)
		else
			f:SetScript("OnEnter", function(self)
				DA.myShowTooltip(self,descrTT)
			end)

			f:SetScript("OnLeave", function(self)
				DA.myHideTooltip()
			end)
		end
	end
	return f
end
function DA.CheckBtnCreater(name,rel,point,heig,wid,settext,onclickscr,setvalue,desrtag)
local f = CreateFrame("CheckButton", name, rel, "UIDarkAngelCheckButton")
	f:SetPoint(unpack(point))
	f:SetHeight(heig)
	f:SetWidth(wid)
	if onclickscr then f:SetScript("OnClick", onclickscr) end
	if setvalue then
		if setvalue[3] then
			local function UpdateValue()
				local val = _G[setvalue[1]][_G[setvalue[3]]][setvalue[2]]
				f:SetChecked(val)
			end
			rel:HookScript('OnShow', UpdateValue)
			UpdateValue()
			table.insert(DA.RunOnGuildUpdate, UpdateValue)
		else
			local function UpdateValue()
				local val = _G[setvalue[1]][setvalue[2]]
				f:SetChecked(val)
			end
			UpdateValue()
			table.insert(DA.RunOnSettingsImport, UpdateValue)
		end
	end
	if settext and name then
		_G[name.."Text"]:SetText(settext)
	elseif settext then
		f.font=DA.FontCreater(nil,settext,{"LEFT",f,"CENTER",8,0.5},f,15,190,{"Fonts\\FRIZQT__.TTF", 8, "OUTLINE"},'left')
	end
	if desrtag and L['DESCr-'..desrtag] then
		f:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,L['DESCr-'..desrtag])
		end)

		f:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
		end)
	end


	return f
end
function DA.EditBoxCreater(name,rel,point,size,text,allowMultiLine,allowAutoFocus,fonttype,scOnEscapePressed,scOnEnterPressed,scOnEditFocusLost,scOnEditFocusGained,scOnTextChanged,isnumeric,desrtag,blend,customtxt)
local txtcol={0.176, 0.286, 0.356, 1}
local badcol={0.36, 0.20, 0.18, 1}

local f = CreateFrame("EditBox", name, rel)
	f:SetPoint(unpack(point))
	f:SetSize(unpack(size))
	if text then f:SetText(text) end

	f:SetMultiLine(allowMultiLine)
	f:SetAutoFocus(allowAutoFocus)
	f:SetFont(unpack(fonttype))
	f:SetFrameLevel(rel:GetFrameLevel() + 2)

    if scOnEscapePressed then
		f:SetScript("OnEscapePressed", scOnEscapePressed)
	elseif scOnEscapePressed==false then

	else
		f:SetScript("OnEscapePressed", function(self) if self:GetText()~="" then self.t:SetBlendMode("blend") else self.t:SetBlendMode("ADD") end; self:ClearFocus(); self.focusgained=nil; end)
	end

	if scOnEnterPressed then
		f:SetScript("OnEnterPressed", scOnEnterPressed)
	elseif scOnEnterPressed==false then

	else
		f:SetScript("OnEnterPressed", function(self) if self:GetText()~="" then self.t:SetBlendMode("blend") else self.t:SetBlendMode("ADD") end; self:ClearFocus(); self.focusgained=nil; end)
	end

	if scOnEditFocusLost then
		f:SetScript("OnEditFocusLost", scOnEditFocusLost)
	elseif scOnEditFocusLost==false then

	else
		f:SetScript("OnEditFocusLost", function(self) if self:GetText()~="" then self.t:SetBlendMode("blend") else self.t:SetBlendMode("ADD") end; self:ClearFocus(); self.focusgained=nil; end)
	end
	if scOnEditFocusGained then
		f:SetScript("OnEditFocusGained", scOnEditFocusGained)
	elseif scOnEditFocusGained==false then

	else
		f:SetScript("OnEditFocusGained", function(self) self.t:SetBlendMode("blend");self.focusgained=1; end)
	end



	if scOnTextChanged then f:SetScript("OnTextChanged", scOnTextChanged) end
	if isnumeric then f:SetNumeric(isnumeric) end

	
	f.t = f:CreateTexture(nil, "BACKGROUND")
	f.t:SetAllPoints()
	function f:SetGoodColor()
		self.t:SetTexture(unpack(txtcol));
	end
	function f:SetBadColor()
		self.t:SetTexture(unpack(badcol));
	end
	if customtxt then
		f.t:SetTexture(unpack(customtxt));
	else
		f.t:SetTexture(unpack(txtcol));
	end
	if blend then
		f.t:SetBlendMode("blend")
	else
		f.t:SetBlendMode("add")
	end

	f.t:SetAlpha(0.7)
	
	if desrtag and L['DESCr-'..desrtag] then
		f:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,L['DESCr-'..desrtag])
			self.t:SetAlpha(1)
		end)

		f:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
			self.t:SetAlpha(0.7)
		end)
	else
		f:SetScript("OnEnter",function(self)
			self.t:SetAlpha(1)
		end)
		f:SetScript("OnLeave",function(self)
			self.t:SetAlpha(0.7)
		end)
	end
	return f
end
function DA.EditBoxCreater2(name,rel,point,size,text,allowMultiLine,allowAutoFocus,fonttype,checkingvalue,valuemin,valuemax,isnumeric,adfont,adcheckbox,desrtag,runonenter)
local txtcol={0.176, 0.286, 0.356, 1}
local badcol={0.36, 0.20, 0.18, 1}
local f = CreateFrame("EditBox", name, rel)
	f:SetPoint(unpack(point))
	f:SetSize(unpack(size))
	if text then f:SetText(text) end

	f:SetMultiLine(allowMultiLine)
	f:SetAutoFocus(allowAutoFocus)
	f:SetFont(unpack(fonttype))
	f:SetFrameLevel(rel:GetFrameLevel() + 2)
	f.stored=false

--	28/255, 32/255, 50/255
	if isnumeric=='text' then
		f:SetScript("OnEscapePressed", function(self)
			if (valuemin and #self:GetText()<valuemin) or (valuemax and #self:GetText()>valuemax) then
				self:SetText(self.stored or valuemin)
				self.focusgained=nil;self:ClearFocus()
				if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tostring(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tostring(self:GetText()) end end
				return
			end
			if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tostring(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tostring(self:GetText()) end end
			self.stored=self:GetText()
			self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
			if runonenter then runonenter() end
		end)
		f:SetScript("OnEnterPressed", function(self)
				if (valuemin and #self:GetText()<valuemin) or (valuemax and #self:GetText()>valuemax) then
					self:SetText(self.stored or valuemin)
					self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
					if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tostring(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tostring(self:GetText()) end end
					return
				end
				if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tostring(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tostring(self:GetText()) end end
				self.stored=self:GetText()
				self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
				if runonenter then runonenter() end
			end)
		f:SetScript("OnEditFocusLost", function(self)
				if (valuemin and #self:GetText()<valuemin) or (valuemax and #self:GetText()>valuemax) then
					self:SetText(self.stored or valuemin)
					self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
					if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tostring(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tostring(self:GetText()) end end
					return
				end
				if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tostring(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tostring(self:GetText()) end end
				self.stored=self:GetText()
				self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
				if runonenter then runonenter() end
			end)
		f:SetScript("OnEditFocusGained", function(self)
			if checkingvalue and ((valuemin and #self:GetText()<valuemin) or (valuemax and #self:GetText()>valuemax)) then
				if checkingvalue[3] then self:SetText(_G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]) else self:SetText(_G[checkingvalue[1]][checkingvalue[2]]) end
			end
			self.stored=tostring(self:GetText())
			self.t:SetBlendMode("BLEND");self.focusgained=1;
		end)


	elseif isnumeric=='textnum' then
		f:SetScript("OnEscapePressed", function(self)
			if not tonumber(self:GetText()) or (valuemin and tonumber(self:GetText())<valuemin) or (valuemax and tonumber(self:GetText())>valuemax) then
				self:SetText(self.stored or valuemin)
				self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
				if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
				return
			end
			if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
			self.stored=tonumber(self:GetText())
			self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
			if runonenter then runonenter() end
		end)
		f:SetScript("OnEnterPressed", function(self)
				if not tonumber(self:GetText()) or (valuemin and tonumber(self:GetText())<valuemin) or (valuemax and tonumber(self:GetText())>valuemax) then
					self:SetText(self.stored or valuemin)
					self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
					if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
					return
				end
				if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
				self.stored=tonumber(self:GetText())
				self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
				if runonenter then runonenter() end
			end)
		f:SetScript("OnEditFocusLost", function(self)
				if not tonumber(self:GetText()) or (valuemin and tonumber(self:GetText())<valuemin) or (valuemax and tonumber(self:GetText())>valuemax) then
					self:SetText(self.stored or valuemin)
					self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
					if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
					return
				end
				if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
				self.stored=tonumber(self:GetText())
				self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
				if runonenter then runonenter() end
			end)
		f:SetScript("OnEditFocusGained", function(self)
			if checkingvalue and (not tonumber(self:GetText()) or (valuemin and tonumber(self:GetText())<valuemin) or (valuemax and tonumber(self:GetText())>valuemax)) then
				if checkingvalue[3] then self:SetText(_G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]) else self:SetText(_G[checkingvalue[1]][checkingvalue[2]]) end
			end
			self.stored=tonumber(self:GetText())
			self.t:SetBlendMode("BLEND");self.focusgained=1;
		end)

	elseif isnumeric==true then
		f:SetNumeric(isnumeric)
		f:SetScript("OnEscapePressed", function(self)
			if not tonumber(self:GetText()) or (valuemin and tonumber(self:GetText())<valuemin) or (valuemax and tonumber(self:GetText())>valuemax) then
				self:SetText(self.stored or valuemin)
				self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
				if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
				return
			end
			if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
			self.stored=tonumber(self:GetText())
			self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
			if runonenter then runonenter() end
		end)
		f:SetScript("OnEnterPressed", function(self)
				if not tonumber(self:GetText()) or (valuemin and tonumber(self:GetText())<valuemin) or (valuemax and tonumber(self:GetText())>valuemax) then
					self:SetText(self.stored or valuemin)
					self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
					if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
					return
				end
				if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
				self.stored=tonumber(self:GetText())
				self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
				if runonenter then runonenter() end
			end)
		f:SetScript("OnEditFocusLost", function(self)
				if not tonumber(self:GetText()) or (valuemin and tonumber(self:GetText())<valuemin) or (valuemax and tonumber(self:GetText())>valuemax) then
					self:SetText(self.stored or valuemin)
					self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
					if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
					return
				end
				if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
				self.stored=tonumber(self:GetText())
				self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
				if runonenter then runonenter() end
			end)
		f:SetScript("OnEditFocusGained", function(self)
			if checkingvalue and (not tonumber(self:GetText()) or (valuemin and tonumber(self:GetText())<valuemin) or (valuemax and tonumber(self:GetText())>valuemax)) then
				if checkingvalue[3] then self:SetText(_G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]) else self:SetText(_G[checkingvalue[1]][checkingvalue[2]]) end
			end
			self.stored=tonumber(self:GetText())
			self.t:SetBlendMode("BLEND");self.focusgained=1;
		end)

	else
		f:SetScript("OnEscapePressed", function(self)
			if not tonumber(self:GetText()) or (valuemin and tonumber(self:GetText())<valuemin) or (valuemax and tonumber(self:GetText())>valuemax) then
				self:SetText(self.stored or valuemin)
				self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
				if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
				return
			end
			if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
			self.stored=tonumber(self:GetText())
			self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
			if runonenter then runonenter() end
		end)
		f:SetScript("OnEnterPressed", function(self)
				if not tonumber(self:GetText()) or (valuemin and tonumber(self:GetText())<valuemin) or (valuemax and tonumber(self:GetText())>valuemax) then
					self:SetText(self.stored or valuemin)
					self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
					if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
					return
				end
				if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
				self.stored=tonumber(self:GetText())
				self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
				if runonenter then runonenter() end
			end)
		f:SetScript("OnEditFocusLost", function(self)
				if not tonumber(self:GetText()) or (valuemin and tonumber(self:GetText())<valuemin) or (valuemax and tonumber(self:GetText())>valuemax) then
					self:SetText(self.stored or valuemin)
					self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
					if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
					return
				end
				if checkingvalue then if checkingvalue[3] then _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]=tonumber(self:GetText()) else _G[checkingvalue[1]][checkingvalue[2]]=tonumber(self:GetText()) end end
				self.stored=tonumber(self:GetText())
				self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
				if runonenter then runonenter() end
			end)
		f:SetScript("OnEditFocusGained", function(self)
			if checkingvalue and (not tonumber(self:GetText()) or (valuemin and tonumber(self:GetText())<valuemin) or (valuemax and tonumber(self:GetText())>valuemax)) then
				if checkingvalue[3] then self:SetText(_G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]) else self:SetText(_G[checkingvalue[1]][checkingvalue[2]]) end
			end
			self.stored=tonumber(self:GetText())
			self.t:SetBlendMode("BLEND");self.focusgained=1;
		end)

	end
	if checkingvalue then
		local UpdateValue
		if checkingvalue[3] then
			UpdateValue = function()
				local val = _G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]
				f:SetText(val)
				f.stored=val
			end
			table.insert(DA.RunOnGuildUpdate, UpdateValue)
		else
			UpdateValue = function()
				local val = _G[checkingvalue[1]][checkingvalue[2]]
				f:SetText(val)
				f.stored=val
			end
			table.insert(DA.RunOnSettingsImport, UpdateValue)
		end
	end
f.t = f:CreateTexture(nil, "BACKGROUND")
	f.t:SetAllPoints()
	f.t:SetTexture(unpack(txtcol));
	f.t:SetBlendMode("add")
	f.t:SetAlpha(0.7)
	function f:SetGoodColor()
		self.t:SetTexture(unpack(txtcol));
	end
	function f:SetBadColor()
		self.t:SetTexture(unpack(badcol));
	end
	if desrtag and L['DESCr-'..desrtag] then
		f:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,L['DESCr-'..desrtag])
			self.t:SetAlpha(1)
		end)

		f:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
			self.t:SetAlpha(0.7)
		end)

	else
		f:SetScript("OnEnter",function(self)
			self.t:SetAlpha(1)
		end)
		f:SetScript("OnLeave",function(self)
			self.t:SetAlpha(0.7)
		end)
	end
	if adfont and adcheckbox then
		if desrtag and L['DESCr-'..desrtag] then
			f.cb=DA.CheckBtnCreater(nil,rel,{"CENTER",f,"CENTER",30,0},15,15,adfont,function(self) _G[adcheckbox[1]][adcheckbox[2]]=(self:GetChecked() or false) end,{adcheckbox[1],adcheckbox[2]},desrtag)
		else
			f.cb=DA.CheckBtnCreater(nil,rel,{"CENTER",f,"CENTER",30,0},15,15,adfont,function(self) _G[adcheckbox[1]][adcheckbox[2]]=(self:GetChecked() or false) end,{adcheckbox[1],adcheckbox[2]})
		end
	elseif adfont then

		f.font=DA.FontCreater(nil,adfont,{"LEFT",f,"RIGHT",3,0},f,15,170,{"Fonts\\FRIZQT__.TTF", 8, "OUTLINE"},'left')


	end
return f
end
function DA.ScrollBarCreater(name, rel, size, point, exclude)

	local f = CreateFrame("Frame", name, rel)
	f:SetSize(unpack(size))
	f:SetPoint(unpack(point))
	f.storedpoint = point
	f.storedsize = size

	f:SetMovable(true)
	f:SetResizable(true)

	-- ScrollFrame
	f.scrollframe = CreateFrame("ScrollFrame", name.."ScrollFrame", f, "UIDarkAngelScrollFrame")
	f.scrollframe:SetAllPoints(f)
	f.scrollframe:SetScript("OnLoad", f.scrollframe_OnLoad)

	-- ScrollChild (must be parented to scrollframe)
	f.scrollchild = CreateFrame("Frame", nil, f.scrollframe)

	-- Important: anchor instead of setting size
	f.scrollchild:SetPoint("TOPLEFT", f.scrollframe, "TOPLEFT", 0, 0)
	f.scrollchild:SetPoint("TOPRIGHT", f.scrollframe, "TOPRIGHT", 0, 0)
	f.scrollchild:SetSize(1, 1)

	f.scrollframe:SetScrollChild(f.scrollchild)

	-- Scrollbar elements
	local scrollbarName = f.scrollframe:GetName()

	f.scrollbar = _G[scrollbarName.."ScrollBar"]
	f.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"]
	f.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"]

	-- Reposition buttons
	f.scrollupbutton:ClearAllPoints()
	f.scrollupbutton:SetPoint("TOPRIGHT", f.scrollframe, "TOPRIGHT", -2, -2)

	f.scrolldownbutton:ClearAllPoints()
	f.scrolldownbutton:SetPoint("BOTTOMRIGHT", f.scrollframe, "BOTTOMRIGHT", -2, 2)

	-- Scrollbar positioning
	f.scrollbar:ClearAllPoints()
	f.scrollbar:SetPoint("TOP", f.scrollupbutton, "BOTTOM", 0, -2)
	f.scrollbar:SetPoint("BOTTOM", f.scrolldownbutton, "TOP", 0, 2)

	-- Hide visuals
	f.scrollupbutton:Hide()
	f.scrolldownbutton:Hide()

	if f.scrollbar:GetThumbTexture() then
		f.scrollbar:GetThumbTexture():Hide()
	end

	-- Register scrollbox if needed
	if not exclude then
		_G["DarkAngelGUI"].scrollbexes = _G["DarkAngelGUI"].scrollbexes or {}
		table.insert(_G["DarkAngelGUI"].scrollbexes, name)
	end

	return f
end
function DA.HideBarCreater(name,rel,size,point)

local f = CreateFrame("Frame", name, rel);
f:SetSize(unpack(size))
f:SetPoint(unpack(point))
f:EnableMouse(true)
-- local t = f:CreateTexture(nil, "BACKGROUND"); t:SetAllPoints(); t:SetTexture(80/255, 12/255, 20/255, 0.45); t:SetBlendMode("blend")
f:SetMovable(true)
f:SetResizable(true)
f:SetFrameLevel(rel:GetFrameLevel() + 30 )
f.scrollframe = f.scrollframe or CreateFrame("ScrollFrame", name..'ScrollFrame', f, "UIDarkAngelScrollFrame");
f.scrollchild = f.scrollchild or CreateFrame("Frame");
local scrollbarName = f.scrollframe:GetName()
f.scrollbar = _G[scrollbarName.."ScrollBar"]
f.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"]
f.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"]
	f.scrollbar:Hide()
	f.scrollbar.isHider=true
	f.scrollbar:GetThumbTexture():Hide()
	f.scrollupbutton:Hide()
	f.scrolldownbutton:Hide()

f.scrollupbutton:ClearAllPoints()
f.scrollupbutton:SetPoint("TOPRIGHT", f.scrollframe, "TOPRIGHT", -2, -2)
f.scrolldownbutton:ClearAllPoints();
f.scrolldownbutton:SetPoint("BOTTOMRIGHT", f.scrollframe, "BOTTOMRIGHT", -2, 2)

f.scrollbar:ClearAllPoints()
f.scrollbar:SetPoint("TOP", f.scrollupbutton, "BOTTOM", 0, -2)
f.scrollbar:SetPoint("BOTTOM", f.scrolldownbutton, "TOP", 0, 2)
f.scrollframe:SetScrollChild(f.scrollchild)
f.scrollframe:SetAllPoints(f)
-- local tf = f.scrollframe:CreateTexture(nil, "BACKGROUND"); tf:SetAllPoints(); tf:SetTexture(21/255, 18/255, 22/255, 0.5); tf:SetBlendMode("blend")
f.scrollchild:SetSize(f.scrollframe:GetWidth(), f.scrollframe:GetHeight())
-- local tc = f.scrollchild:CreateTexture(nil, "BACKGROUND"); tc:SetAllPoints(); tc:SetTexture(21/255, 18/255, 22/255, 0.5); tc:SetBlendMode("blend")
f.scrollframe:SetScript("OnHorizontalScroll", nil)
f.scrollframe:SetScript("OnVerticalScroll", nil)
f.scrollframe:SetScript("OnSizeChanged", function(self, width, height)
    f.scrollchild:SetSize(width, height)
end)

f.scrollupbutton:Hide()
f.scrolldownbutton:Hide()
f.scrollbar:GetThumbTexture():Hide()
f.scrollbar:Hide()

return f
end
function DA.CreateScaler(Frametoscale,minsc,maxsc,setvalue,customparent,custompoint)
	if not Frametoscale then print('error 1086') return end

	if type(Frametoscale)=='table' then
	elseif type(Frametoscale)=='string' then
		Frametoscale=_G[Frametoscale]
	end

	local SOS = {
		dist = 0,
		x = 0,
		y = 0,
		left = 0,
		top = 0,
		scale = 1,
	}
	local function getvalue()
		return 
				setvalue[3] and _G[setvalue[1]][_G[setvalue[3]]][setvalue[2]]
			or 	setvalue[2] and _G[setvalue[1]][setvalue[2]]
	end
	local function writevalue(val)
		if setvalue[3] then
			_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]] = val
		elseif setvalue[2] then
			_G[setvalue[1]][setvalue[2]] = val
		end
	end
	local function GetScaleDistance()
		local left, top = SOS.left, SOS.top
		local scale = SOS.EFscale

		local x, y = GetCursorPosition()
		local x = x/scale - left
		local y = top - y/scale

		return sqrt(x*x+y*y)
	end
	local function UpdateValue()
		Frametoscale:SetScale(getvalue())
	end
	local function OnUpdate(self)
		local scale = GetScaleDistance()/SOS.dist*SOS.scale
		if scale < minsc then
			scale = minsc
		elseif scale > maxsc then
			scale = maxsc
		end

		writevalue(scale)
		Frametoscale:SetScale(scale)

		if customparent and custompoint then
			Frametoscale:SetParent(customparent)
			Frametoscale:SetPoint(unpack(custompoint))
		else
			local s = SOS.scale/Frametoscale:GetScale()
			local x = SOS.x*s
			local y = SOS.y*s
			Frametoscale:ClearAllPoints()
			Frametoscale:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, y)
		end
	end

	UpdateValue()
	if setvalue[3] then
		table.insert(DA.RunOnGuildUpdate, UpdateValue)
	elseif setvalue[2] then
		table.insert(DA.RunOnSettingsImport, UpdateValue)
	end

	

	local mousetracker = CreateFrame("Frame", nil, Frametoscale)
	mousetracker:SetFrameLevel(Frametoscale:GetFrameLevel()+10)
	mousetracker:SetWidth(12)
	mousetracker:SetHeight(12)
	mousetracker:SetPoint('center',Frametoscale,'bottomright',-6,6)
	mousetracker:EnableMouse(true)

	local scaler = mousetracker:CreateTexture(nil, "OVERLAY")
	scaler:SetWidth(12)
	scaler:SetHeight(12)
	scaler:SetPoint('center',mousetracker,'center',0,0)
	scaler:SetTexture([[Interface\BUTTONS\UI-AutoCastableOverlay]])
	scaler:SetAlpha(0.4)
	scaler:SetTexCoord(0.619, 0.760, 0.612, 0.762)
	scaler:SetDesaturated(true)
	Frametoscale.scaler=scaler

	mousetracker:SetScript("OnEnter", function()
		scaler:SetDesaturated(false)
	end)
	mousetracker:SetScript("OnLeave", function()
		scaler:SetDesaturated(true)
	end)
	mousetracker:HookScript("OnHide", function()
		scaler:SetDesaturated(true)
		mousetracker:SetScript("OnUpdate", nil)
		mousetracker:SetPoint('center',Frametoscale,'bottomright',-6,6)
	end)
	mousetracker:SetScript("OnMouseUp", function(self)
		self:SetScript("OnUpdate", nil)
		self:SetPoint('center',Frametoscale,'bottomright',-6,6)
	end)
	mousetracker:SetScript("OnMouseDown",function(self)
		SOS.left, SOS.top = Frametoscale:GetLeft(), Frametoscale:GetTop()
		SOS.scale = Frametoscale:GetScale()
		SOS.x, SOS.y = SOS.left, SOS.top-(UIParent:GetHeight()/SOS.scale)
		SOS.EFscale = Frametoscale:GetEffectiveScale()
		SOS.dist = GetScaleDistance()
		self:SetScript("OnUpdate", OnUpdate)
	end)
end

--- Tooltips
function DA.myShowTooltip(self, text, fontleft1, pointy)
    local tt = DA_Tooltip
	tt:Hide()
	tt:SetBackdrop({bgFile="Interface\\Tooltips\\UI-Tooltip-Background",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile="true",tileSize="16",edgeSize="16",insets={bottom="5",left="5",right="5",top="5"}})
	tt:SetBackdropColor(0, 0, 0, 0.85)
	tt:SetBackdropBorderColor(0.2, 0.2, 0.2, 1.0)

    tt:SetOwner(self, "ANCHOR_NONE")

    if pointy then
        tt:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, pointy)
    else
        tt:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
    end

	local textleft1 = getglobal("DA_TooltipTextLeft1")

	if textleft1 then
		if fontleft1 then
			textleft1:SetFont(unpack(fontleft1)) 
		else
			textleft1:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
		end 
	end

    DA_TooltipTextRight1:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    DA_TooltipTextLeft2:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")

    tt:SetText(text, 0.75, 0.95, 0.95, 1)
    tt:Show()
end
function DA.myHideTooltip()
	if getglobal("DA_TooltipTextLeft1") then getglobal("DA_TooltipTextLeft1"):SetFont("Fonts\\FRIZQT__.TTF", 14, "") end
    DA_Tooltip:Hide()
	GameTooltip:Hide()
end
function DA.myHideMMTooltip()
	if getglobal("DA_TooltipMMTextLeft1") then getglobal("DA_TooltipMMTextLeft1"):SetFont("Fonts\\FRIZQT__.TTF", 14, "") end
    DA_TooltipMM:Hide()
end
local function Dropdown_get_dump(o)
   if type(o) == 'table' then
	  local s = {}
	  for k,v in pairs(o) do
		 table.insert(s,{k, Dropdown_get_dump(v)})
	  end
	  if DA.modules.Logger then
		  for k,_ in pairs(DA_Leavers[DA_CurrentGuild]) do
			 table.insert(s,{k, DA.Log_PlayerOfficerNote(DA_CurrentGuild,k) or "leaver"})
		  end
	  end
	  return s

   else
	  return tostring(o)
   end
end
local function Dropdown_process_dump(data2, phrase,num)

	local data = Dropdown_get_dump(data2)
	local result, counter = {}, 0
	local l_phrase=string.lower(phrase)

	for i=1,#data do
		local entry=data[i]
		if string.lower(string.gsub(entry[1],"\"","")):find(l_phrase) or string.lower(string.gsub(entry[2],"\"","")):find(l_phrase) then
			table.insert(result,{entry[1],entry[2]})
			counter=counter+1
		end

		if counter>=num then
			break
		end

	end

	if counter==0 then
		return nil
	else
		return result
	end

end
local function Dropdown_Fill(num, player, short,frame,noteeb,customwnd,notetype)

	local mainframe=_G["FFG"..short.."_guy_btn"..num]
	if mainframe then
		mainframe:Show()
		_G["FFG"..short.."_guy_btn"..num.."b"]:Show()
	else
		local f = CreateFrame("Button", "FFG"..short.."_guy_btn"..num, frame, "UIDarkAngelButtonTemplate2")
			f:SetPoint("TOPLEFT",frame,"TOPLEFT",10,-5-11*num)
			f:SetHeight(10)
			f:SetWidth(75)
			f:SetBackdropColor(1, 1, 1, 1)
			f:SetText("")
			f.fs=DA.FontCreater(nil,"",{'left',f,'left'},f,15,170,{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},'left',{1,1,1,1})
			f:RegisterForClicks("LeftButtonUp")
			f:SetNormalTexture(nil)
			f:SetScript("OnClick", function(self)
				if self.fs:GetText() then
					noteeb:SetText(self.fs:GetText())
					if customwnd then noteeb.focusgained=nil;noteeb:ClearFocus();customwnd:Hide() end
					if not customwnd then noteeb.t:SetTexture(70/255, 12/255, 20/255, 0.4)
						if notetype=='note' then
							DarkAngelGUI.Guild.micromenu.noteset:Enable()
							DarkAngelGUI.Guild.micromenu.notecancel:Enable()
						else
							DarkAngelGUI.Guild.micromenu.ofnoteset:Enable()
							DarkAngelGUI.Guild.micromenu.ofnotecancel:Enable()
						end
					end
				end
			end)
		mainframe=f

		local g = CreateFrame("Button", "FFG"..short.."_guy_btn"..num.."b", frame, "UIDarkAngelButtonTemplate2")
			g:SetPoint("TOPLEFT",frame,"TOPLEFT",90,-5-11*num)
			g:SetHeight(10)
			g:SetWidth(75)
			g:SetBackdropColor(1, 1, 1, 1)
			g:SetText("")
			g.fs=DA.FontCreater(nil,"",{'left',g,'left'},g,15,170,{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},'left',{1,1,1,1})
			g:RegisterForClicks("LeftButtonUp")
			g:SetNormalTexture(nil)
			g:SetScript("OnClick", function(self)
				if self.fs:GetText() then
					noteeb:SetText(self.fs:GetText())
					if customwnd then noteeb.focusgained=nil;noteeb:ClearFocus();customwnd:Hide() end
					if not customwnd then noteeb.t:SetTexture(70/255, 12/255, 20/255, 0.4)
						if notetype=='note' then
							DarkAngelGUI.Guild.micromenu.noteset:Enable()
							DarkAngelGUI.Guild.micromenu.notecancel:Enable()
						else
							DarkAngelGUI.Guild.micromenu.ofnoteset:Enable()
							DarkAngelGUI.Guild.micromenu.ofnotecancel:Enable()
						end
					end
				end
			end)
	end


	local mainframeFS=mainframe.fs
	local secondaryframeFS=_G["FFG"..short.."_guy_btn"..num.."b"].fs

	mainframeFS:SetText(string.gsub(player[1],"\"",""))
	secondaryframeFS:SetText(player[2])

	local Mnt = DA.DecodeNote(FEP_gMain[mainframeFS:GetText()])
	local Tnt = DA.DecodeNote(FEP_gMain[secondaryframeFS:GetText()])

	-- Main
	if FEP_gMain[mainframeFS:GetText()] then
		if Mnt=="m" then
			mainframeFS:SetTextColor(0.85,1,1,1)
		elseif Mnt=="f" then
			mainframeFS:SetTextColor(0.4,0.5,0.9,1)
		elseif Mnt=="t" then
			if FEP_gMain[FEP_gMain[mainframeFS:GetText()]] then
				local MnR = DA.DecodeNote(FEP_gMain[FEP_gMain[mainframeFS:GetText()]])
				if MnR=="m" then
					mainframeFS:SetTextColor(0.6,0.6,0.6,1)
				elseif MnR=="f" then
					mainframeFS:SetTextColor(0.3,0.4,0.7,1)
				elseif MnR=="t" then
					mainframeFS:SetTextColor(1,0.53,1,1)
				end
			else
				mainframeFS:SetTextColor(0.5,0.3,0.3,1)
			end
		end
	else
		mainframeFS:SetTextColor(0.8,0.3,0.4,1)
	end

	-- Secondary
	if notetype=='note' then
		secondaryframeFS:SetTextColor(0.85,1,1,1)

	elseif notetype=='officernote' then
		if FEP_gMain[secondaryframeFS:GetText()] then
			if Tnt=="m" then
				secondaryframeFS:SetTextColor(0.85,1,1,1)
			elseif Tnt=="f" then
				secondaryframeFS:SetTextColor(0.4,0.5,0.9,1)
			else
				secondaryframeFS:SetTextColor(0.5,0.5,0.5,1)
			end
		else
			local ttt=DA.DecodeNote(secondaryframeFS:GetText())
			if ttt=="m" then
				secondaryframeFS:SetTextColor(0.5,0.8,0.8,1)
			elseif ttt=="f" then
				secondaryframeFS:SetTextColor(0.4,0.5,0.9,1)
			elseif DA.modules.Logger and DA_Leavers[DA_CurrentGuild][secondaryframeFS:GetText()] then
				secondaryframeFS:SetTextColor(0.8,0.3,0.4,1)
			else
				secondaryframeFS:SetTextColor(0.5,0.5,0.5,1)
			end
		end
	end


end
function DA.DropdownHint(text,noteeb,frame,short,dataname,notetype,customwnd,entries)

	local dump=Dropdown_process_dump(_G[dataname], text, entries or 10)

	if not dump then
		if customwnd then customwnd:Hide() end
	else
		if customwnd then customwnd:Show() end
		for i=1,(entries or 10)*2 do
			if _G["FFG"..short.."_guy_btn".. i] then
				_G["FFG"..short.."_guy_btn".. i]:Hide()
				_G["FFG"..short.."_guy_btn".. i .. "b"]:Hide()
			end
		end

		for i=1,#dump do
			Dropdown_Fill(i,dump[i],short,frame,noteeb,customwnd,notetype)

		end
		frame:SetSize(170,12+(#dump)*12)
	end


end



---- Fun functions ----

--- Fake loot drop in RaidRoll:Loot module ----
--- 49623 -- Shadowmourne
--- 50182 -- blood pendant of Lana'Tel
--- 19019 -- Thunderfury, Blessed Blade of the Windseeker
--- 
--- Usage:
--- /run DA_fakeloot(49623,'LichKing','RLname')
function DA_fakeloot(ItemId,boss,looter)

	local playername = UnitName("player")
	local target = UnitName("target")

	if not boss then boss="Unknown" end
	if not looter then looter=playername end


	if not ItemId or type(boss)~='string' or type(looter)~='string' then
		DA.Print("Usage:")
		DA.Print("DA_fakeloot(ItemId,'boss','looter')") 
		DA.Print("'boss' and 'looter' are optional. If skipped, boss is assigned 'Unknown' and 'looter' is assigned your name") 
		DA.Print("using 't' in 'boss' or 'looter' will grab your /target. You may also skip it as well, so mob name will be printed as \"Unknown\"")
		return
	end

	if boss:lower() == 't' then boss=target or "Unknown" end
	if looter:lower() == 't' then looter=target or "Unknown" end

	local lootName, _, rarity, ItemLvl = GetItemInfo(ItemId)
	if not ( (rarity and tonumber(rarity) > 3) or 
		ItemId == 	46110 	or		-- Alchemist's Cache
		ItemId == 	47556	or		-- Crusader Orb
		ItemId == 	45087	or		-- Runed Orb
		ItemId == 	49908 )	-- Primordial Saronite
	then
		DA.Print("Item's rarity should be at least Epic")
		return
	end

	local a = "\a"
	local payload = {
		"Beta_2",
		looter,
		boss,
		tostring(ItemId),
		lootName,
		tostring(ItemLvl)
	}

	SendAddonMessage("RRL",table.concat(payload,a),"RAID")
end

--- Checks Quests whether they are completed or not
--- You can pass multiple quest IDs, separated by comma
--- 
--- Usage:
--- /run DA_CheckQuestsCompleted(12915,12956) --Sons of Hodir quest chain
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

--- Checks all action bars for outdated spell levels
--- 
--- Usage:
--- /run DA_CheckActionBars()
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

--- Checks guild roster for members who has more than X tvins in guild
--- if second argument is specified, results are simply printed in chat
--- if omitted, writes output to 
--- ./WTF/Account/XXXXX/SavedVariables/DarkAngel.lua as FFTestFF table 
--- 
--- Usage:
--- /run DA_GetTvins_N(3)
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

-- creates waypoint at little distance at azimuth Z
function DA_CreateWaypointAtAzimuth(Z)
    SetMapToCurrentZone()
    Z=(Z or 0) +180
    local x, y = GetPlayerMapPosition("player")
    if not x or not y or (x == 0 and y == 0) then
        return
    end

    local rad = math.rad(Z)

    local newX = x + 0.03 * math.sin(rad)
    local newY = y + 0.03 * math.cos(rad)

    SlashCmdList.NOWAY()

    SlashCmdList.WAY(newX .. " " .. newY)
end

-- azimuth to GM Island when rocketboots-slowfall-jumping from Teldrassil's branch at 22.5, 41.3 
-- unsuccessfull even with 300% speed engineering boots; still, the best one attempt w/o using terrain patches
-- we should look for a way to travel distance without falling down at all; for example dc from server 
-- DA_CreateWaypointAtAzimuth(90-24)

function DA_FakeItemReceived(playername, itemID, count)
    count = count or 1

    local itemName, _ = GetItemInfo(itemID)

    local itemLink = "|cffa335ee|Hitem:"..itemID..":0:0:0:0:0:0:0:80|h["..itemName.."]|h|r"
    local message = (count > 1)
        and string.format(LOOT_ITEM_MULTIPLE, playername, itemLink, count)
        or string.format(LOOT_ITEM, playername, itemLink)
	local c = ChatTypeInfo.LOOT
    DEFAULT_CHAT_FRAME:AddMessage(message, c.r, c.g, c.b)
end

