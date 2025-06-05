local DA=LibStub("AceAddon-3.0"):GetAddon("DarkAngel")
local L = LibStub("AceLocale-3.0"):GetLocale("DarkAngel")

CreateFrame("Frame", "DarkAngelGUI", UIParent)
DarkAngelGUI.width  = 496
DarkAngelGUI.height = 300
DarkAngelGUI:SetBackdropColor(1, 1, 1, 1)
DarkAngelGUI:SetFrameStrata("FULLSCREEN")
DarkAngelGUI:SetSize(DarkAngelGUI.width, DarkAngelGUI.height)
DA_XTimers={}
DA.Players_Selected={}

DA_G_Processed={}

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





function DA.FrameCreater(name,rel,width,heigh,point,textc,addtxtfr, moreframelvl)
local f=CreateFrame("Frame", name, rel)
f.width  = width
f.height = heigh
f:SetBackdropColor(1, 1, 1, 1)
f:SetFrameStrata("FULLSCREEN_DIALOG")
f:SetSize(f.width, f.height)
if point then f:SetPoint(unpack(point)) end


f:EnableMouse(true)
f:EnableMouseWheel(true)
-- local texture = f:CreateTexture(nil, "BACKGROUND"); texture:SetAllPoints(); texture:SetTexture(8/255, 12/255, 20/255, 0.45); texture:SetBlendMode("blend")
if textc then
	if type(textc)=='string' and textc=='no' then
	elseif type(textc)=='table' then
		f.t = f:CreateTexture(nil, "BACKGROUND"); f.t:SetAllPoints(); f.t:SetTexture(unpack(textc)); 
	else
		f.t = f:CreateTexture(nil, "BACKGROUND"); f.t:SetAllPoints(); f.t:SetTexture(textc); 
		f.t:SetBlendMode(fuckingOptions.txt1extra and "add" or "blend")
		f.t:SetAlpha(fuckingOptions.txt1op or 0.8)
	end
else
	f.t = f:CreateTexture(nil, "BACKGROUND"); f.t:SetAllPoints(); f.t:SetTexture(0.03, 0.04, 0.07, 0.45); f.t:SetBlendMode("blend")
end
f:SetMovable(true)
f:Hide()

f:SetFrameLevel(rel:GetFrameLevel() + 25 +(moreframelvl and 35 or 0) )
if addtxtfr then
	f.add=CreateFrame("Frame",nil,f)
	f.add.width  = f.width
	f.add.height = f.height
	f.add:SetFrameStrata("FULLSCREEN_DIALOG")
	f.add:SetSize(f.add.width, f.add.height)
	f.add:SetAllPoints(f)
	f.add:SetBackdropColor(1, 1, 1, 1)
	
	f.add.t=f.add:CreateTexture(nil, "BACKGROUND"); f.add.t:SetAllPoints(); f.add.t:SetTexture(8/255, 12/255, 20/255, (fuckingOptions.txt2op or 0.5)); 
	f.add:SetFrameLevel(math.max(f:GetFrameLevel() - 1,0))
	if fuckingOptions.txt2extra then
		f.add.t:SetBlendMode("add")
	else
		f.add.t:SetBlendMode("blend")
	end

end


return f
end
function DA.CreateFFGDropFrame(rel,text,width,heigh,point,frw,frh,frorient,justh,addfunctiononshow,addfunctiononhide,desrtag)
local button=DA.CreateFFGButton2(nil,rel,point,width,heigh,text,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function() end,nil,nil,justh)
local frpoint
	if not frorient then 
		frorient="BOTTOMLEFT" 
	end
	if frorient=="TOPLEFT-right" then
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
local frame=DA.FrameCreater(nil,rel,frw,frh,frpoint,{0.03, 0.04, 0.07, 0.75})
	button:SetScript("OnClick",
		function()
			if frame:IsShown() then
				frame:Hide()
				if addfunctiononhide then
					addfunctiononhide()
				end
			else
				frame:Show()
				if addfunctiononshow then
					addfunctiononshow()
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
function DA.TabFrameCreater(rel,subname,ttt)
_G[rel][subname]=CreateFrame("Frame", nil, _G[rel])
_G[rel][subname].width  = _G[rel].width
_G[rel][subname].height = _G[rel].height
_G[rel][subname]:SetFrameStrata("FULLSCREEN_DIALOG")
_G[rel][subname]:SetSize(_G[rel][subname].width, _G[rel][subname].height)
_G[rel][subname]:SetAllPoints(_G[rel])
_G[rel][subname]:SetBackdropColor(1, 1, 1, 1)

_G[rel][subname].t = _G[rel][subname]:CreateTexture(nil, "BACKGROUND")
	_G[rel][subname].t:SetAllPoints()
	if ttt then
		_G[rel][subname].t:SetTexture(ttt);
		_G[rel][subname].t:SetAlpha(fuckingOptions.txt1op or 0.8)
	else
		_G[rel][subname].t:SetTexture(8/255, 12/255, 20/255, 0.45);
	end
	if fuckingOptions.txt1extra then
		_G[rel][subname].t:SetBlendMode("add")
	else
		_G[rel][subname].t:SetBlendMode("blend")
	end
	
_G[rel][subname]:EnableMouse(true)
_G[rel][subname]:EnableMouseWheel(true)
_G[rel][subname]:SetMovable(true)
_G[rel][subname]:SetResizable(true)
-- _G[rel][subname]:SetMinResize(100, 100)
_G[rel][subname]:RegisterForDrag("LeftButton")
_G[rel][subname]:SetScript("OnDragStart", function(self) _G[rel]:GetScript("OnDragStart")(_G[rel]) end )
_G[rel][subname]:SetScript("OnDragStop",  function(self) _G[rel]:GetScript("OnDragStop")(_G[rel]) end ) 

-- _G[rel][subname]:Hide()
_G[rel][subname].add=CreateFrame("Frame",nil,_G[rel][subname])
_G[rel][subname].add.width  = _G[rel].width
_G[rel][subname].add.height = _G[rel].height
_G[rel][subname].add:SetFrameStrata("FULLSCREEN_DIALOG")
_G[rel][subname].add:SetSize(_G[rel][subname].add.width, _G[rel][subname].add.height)
_G[rel][subname].add:SetAllPoints(_G[rel])
_G[rel][subname].add:SetBackdropColor(1, 1, 1, 1)

_G[rel][subname].add.t =_G[rel][subname].add:CreateTexture(nil, "BACKGROUND"); _G[rel][subname].add.t:SetAllPoints(); _G[rel][subname].add.t:SetTexture(8/255, 12/255, 20/255, (fuckingOptions.txt2op or 0.5)); 
if fuckingOptions.txt2extra then
	_G[rel][subname].add.t:SetBlendMode("add")
else
	_G[rel][subname].add.t:SetBlendMode("blend")
end



end
function DA.TabCreater(point,heig,wid,heigt,widt,settext,fonttype,onclickscr,onclickscr2,textur)
	---Tab frame itself
DA.TabFrameCreater("DarkAngelGUI",settext,textur)
	---Tab button
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
	f.txt = f:CreateTexture(nil, "BACKGROUND"); f.txt:SetAllPoints(); f.txt:SetTexture(8/255, 12/255, 20/255, 0.45); f.txt:SetBlendMode("blend")
	
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
	f:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up.blp')
	-- f:SetScript("OnClick", HideParentPanel)
	f:SetText(settext)
	f:SetFrameStrata("FULLSCREEN_DIALOG");
	f:SetFrameLevel(framelevel or 104)
	f:SetFrameLevel(rel:GetFrameLevel() + 61)
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
function DA.IconicButtonCreater(name,rel,point,size,texture,onclickscr,descrtext,customscript)
local f = CreateFrame("Button", name, rel, "UIDarkAngelIconicButton")
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
		if state then
			f:GetNormalTexture():SetDesaturated(false)
			f:SetAlpha(0.85)
			f.isenabled=true
		else
			f:GetNormalTexture():SetDesaturated(true)
			f:SetAlpha(0.6)
			f.isenabled=nil
		end	
	end
	
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
				self:SetAlpha(0.85)
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
			rel:HookScript('OnShow',function() f:SetValue(_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]]) end)
			f:SetValue(_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]])
			f.val=DA.FontCreater(nil,_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]],{'center',f,'center',0,-10},f,15,170,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'center',{0.5,0.9,1,1})
			f:SetScript("OnMouseDown",function(self) 
				self:SetScript("OnUpdate",function(self) 
					local val=tonumber(string.format("%.3f", self:GetValue())); _G[setvalue[1]][_G[setvalue[3]]][setvalue[2]]=val;self.val:SetText(val)  
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
			f:SetValue(_G[setvalue[1]][setvalue[2]]) 
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
	
	-- f.tooltipText = 'This is the Tooltip hint' --Creates a tooltip on mouseover.
	if textmin and getglobal(name .. 'Low'):SetText(textmin) then end
	if textmax and getglobal(name .. 'High'):SetText(textmax) then end
	if title then 
		f.title=DA.FontCreater(nil,title,{'left',f,'right',5,0},f,45,170,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'left',{0.5,0.9,1,1})
	end
	
	if desrtag and L['DESCr-'..desrtag] then
		f:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,L['DESCr-'..desrtag],nil,nil,-10)
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
local f = rel:CreateFontString(name, "ARTWORK", rel)
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
	if desrtag and L['DESCr-'..desrtag] then
		f:SetScript("OnEnter", function(self)
			DA.myShowTooltip(self,L['DESCr-'..desrtag],1)
		end)
		
		f:SetScript("OnLeave", function(self)
			DA.myHideTooltip()
		end)
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
			rel:HookScript('OnShow',function() f:SetChecked(_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]]) end)
			f:SetChecked(_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]])
		else
			f:SetChecked(_G[setvalue[1]][setvalue[2]]) 
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
function DA.EditBoxCreater(name,rel,point,size,text,allowMultiLine,allowAutoFocus,fonttype,scOnEscapePressed,scOnEnterPressed,scOnEditFocusLost,scOnEditFocusGained,scOnTextChanged,isnumeric,desrtag,blend)
local txtcol={0.176, 0.286, 0.356, 1}

local f = CreateFrame("EditBox", name, rel)
	f:SetPoint(unpack(point))
	f:SetSize(unpack(size))
	if text then f:SetText(text) end
	
	f:SetMultiLine(allowMultiLine)
	f:SetAutoFocus(allowAutoFocus)
	f:SetFont(unpack(fonttype))
	f:SetFrameLevel(rel:GetFrameLevel() + 1)
	
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
	f.t:SetTexture(unpack(txtcol));
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
local f = CreateFrame("EditBox", name, rel)
	f:SetPoint(unpack(point))
	f:SetSize(unpack(size))
	if text then f:SetText(text) end
	
	f:SetMultiLine(allowMultiLine)
	f:SetAutoFocus(allowAutoFocus)
	f:SetFont(unpack(fonttype))
	f:SetFrameLevel(rel:GetFrameLevel() + 1)
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
	if checkingvalue and checkingvalue[3] then 
		rel:HookScript('OnShow',function() f:SetText(_G[checkingvalue[1]][_G[checkingvalue[3]]][checkingvalue[2]]);f.stored=f:GetText() end)
	end
f.t = f:CreateTexture(nil, "BACKGROUND")
	f.t:SetAllPoints()
	f.t:SetTexture(unpack(txtcol));
	f.t:SetBlendMode("add")
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
function DA.ScrollBarCreater(name,rel,size,point,exclude)
local f = CreateFrame("Frame", name, rel);
f:SetSize(unpack(size))
f:SetPoint(unpack(point))
f.storedpoint=point
f.storedsize=size

-- local t = f:CreateTexture(nil, "BACKGROUND"); t:SetAllPoints(); t:SetTexture(80/255, 12/255, 20/255, 0.45); t:SetBlendMode("blend")
f:SetMovable(true)
f:SetResizable(true)
f.scrollframe = f.scrollframe or CreateFrame("ScrollFrame", name..'ScrollFrame', _G[name], "UIDarkAngelScrollFrame");
f.scrollchild = f.scrollchild or CreateFrame("Frame");
local scrollbarName = f.scrollframe:GetName()
f.scrollbar = _G[scrollbarName.."ScrollBar"]
f.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"]
f.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"]
f.scrollupbutton:ClearAllPoints()
f.scrollupbutton:SetPoint("TOPRIGHT", f.scrollframe, "TOPRIGHT", -2, -2)
f.scrolldownbutton:ClearAllPoints();
f.scrolldownbutton:SetPoint("BOTTOMRIGHT", f.scrollframe, "BOTTOMRIGHT", -2, 2)
 
f.scrollbar:ClearAllPoints()
f.scrollbar:SetPoint("TOP", f.scrollupbutton, "BOTTOM", 0, -2)
f.scrollbar:SetPoint("BOTTOM", f.scrolldownbutton, "TOP", 0, 2)
f.scrollframe:SetScrollChild(f.scrollchild)
f.scrollframe:SetAllPoints(f) -----------
-- local tf = f.scrollframe:CreateTexture(nil, "BACKGROUND"); tf:SetAllPoints(); tf:SetTexture(8/255, 12/255, 20/255, 0.5); tf:SetBlendMode("blend")
f.scrollchild:SetSize(f.scrollframe:GetWidth(), f.scrollframe:GetHeight())
f.scrollframe:SetScript("OnLoad",f.scrollframe_OnLoad)
-- local tc = f.scrollchild:CreateTexture(nil, "BACKGROUND"); tc:SetAllPoints(); tc:SetTexture(8/255, 12/255, 20/255, 0.5); tc:SetBlendMode("blend")
f.scrollupbutton:Hide()
f.scrolldownbutton:Hide()
f.scrollbar:GetThumbTexture():Hide()
	if not exclude then 
		_G["DarkAngelGUI"]['scrollbexes']=_G["DarkAngelGUI"]['scrollbexes'] or {}
			table.insert(_G["DarkAngelGUI"]['scrollbexes'],name)
	end
		-- f.getsomething=3
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
f.scrollframe = f.scrollframe or CreateFrame("ScrollFrame", name..'ScrollFrame', _G[name], "UIDarkAngelScrollFrame");
f.scrollchild = f.scrollchild or CreateFrame("Frame");
local scrollbarName = f.scrollframe:GetName()
f.scrollbar = _G[scrollbarName.."ScrollBar"]
f.scrollupbutton = _G[scrollbarName.."ScrollBarScrollUpButton"]
f.scrolldownbutton = _G[scrollbarName.."ScrollBarScrollDownButton"]
f.scrollupbutton:ClearAllPoints()
f.scrollupbutton:SetPoint("TOPRIGHT", f.scrollframe, "TOPRIGHT", -2, -2)
f.scrolldownbutton:ClearAllPoints();
f.scrolldownbutton:SetPoint("BOTTOMRIGHT", f.scrollframe, "BOTTOMRIGHT", -2, 2)
 
f.scrollbar:ClearAllPoints()
f.scrollbar:SetPoint("TOP", f.scrollupbutton, "BOTTOM", 0, -2)
f.scrollbar:SetPoint("BOTTOM", f.scrolldownbutton, "TOP", 0, 2)
f.scrollframe:SetScrollChild(f.scrollchild)
f.scrollframe:SetAllPoints(f)
-- local tf = f.scrollframe:CreateTexture(nil, "BACKGROUND"); tf:SetAllPoints(); tf:SetTexture(8/255, 12/255, 20/255, 0.5); tf:SetBlendMode("blend")
f.scrollchild:SetSize(f.scrollframe:GetWidth(), f.scrollframe:GetHeight())
-- local tc = f.scrollchild:CreateTexture(nil, "BACKGROUND"); tc:SetAllPoints(); tc:SetTexture(8/255, 12/255, 20/255, 0.5); tc:SetBlendMode("blend")
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
function DA.CreateScaler(Frametoscale,minsc,maxsc,setvalue)
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
	local function GetScaleDistance()
		local left, top = SOS.left, SOS.top
		local scale = SOS.EFscale

		local x, y = GetCursorPosition()
		local x = x/scale - left
		local y = top - y/scale

		return sqrt(x*x+y*y)
	end
		
	local function OnUpdate(self)
		local scale = GetScaleDistance()/SOS.dist*SOS.scale
		if scale < minsc then
			scale = minsc
		elseif scale > maxsc then 
			scale = maxsc
		end
		if setvalue[3] then
			_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]]=scale
			Frametoscale:SetScale(_G[setvalue[1]][_G[setvalue[3]]][setvalue[2]])
		else
			_G[setvalue[1]][setvalue[2]]=scale
			Frametoscale:SetScale(_G[setvalue[1]][setvalue[2]])		
		end
		
		local s = SOS.scale/Frametoscale:GetScale()
		local x = SOS.x*s
		local y = SOS.y*s
		Frametoscale:ClearAllPoints()
		Frametoscale:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, y)
	end

		local scaler = Frametoscale:CreateTexture(nil, "OVERLAY")
		scaler:SetWidth(12)
		scaler:SetHeight(12)
		scaler:SetPoint('center',Frametoscale,'bottomright',-6,6)
		scaler:SetTexture([[Interface\BUTTONS\UI-AutoCastableOverlay]])
		scaler:SetAlpha(0.4)
		scaler:SetTexCoord(0.619, 0.760, 0.612, 0.762)
		scaler:SetDesaturated(true)
		Frametoscale.scaler=scaler

		local mousetracker = CreateFrame("Frame", nil, Frametoscale)
		mousetracker:SetFrameStrata("TOOLTIP")
		mousetracker:SetAllPoints(scaler)
		mousetracker:EnableMouse(true)
		mousetracker:SetScript("OnEnter", function()
			scaler:SetDesaturated(false)
		end)
		mousetracker:SetScript("OnLeave", function()
			scaler:SetDesaturated(true)
		end)
		mousetracker:SetScript("OnMouseUp", function(self)
			self:SetScript("OnUpdate", nil)
			self:SetAllPoints(scaler)
		end)
		mousetracker:SetScript("OnMouseDown",function(self)
			SOS.left, SOS.top = Frametoscale:GetLeft(), Frametoscale:GetTop()
			SOS.scale = Frametoscale:GetScale()
			SOS.x, SOS.y = SOS.left, SOS.top-(UIParent:GetHeight()/SOS.scale)
			SOS.EFscale = Frametoscale:GetEffectiveScale()
			SOS.dist = GetScaleDistance()
			self:SetScript("OnUpdate", OnUpdate)
			self:SetAllPoints(UIParent)
		end)
end

function DA.myShowTooltip(self,text,noadd,customleft1,custdown)
	GameTooltip:SetOwner(self,'ANCHOR_NONE')
	if custdown then
		GameTooltip:SetPoint('topleft',self,'bottomleft',0,custdown)
	else
		GameTooltip:SetPoint('topleft',self,'bottomleft',0,-5)
	end
	
	if customleft1 then 
		GameTooltipTextLeft1:SetFont(unpack(customleft1))
	else
		GameTooltipTextLeft1:SetFont("Fonts\\FRIZQT__.TTF", 12,'outline')
	end
	GameTooltipTextRight1:SetFont("Fonts\\FRIZQT__.TTF", 12,'outline')
	GameTooltipTextLeft2:SetFont("Fonts\\FRIZQT__.TTF", 12,'outline')
	
	GameTooltip:SetText(text,0.75,0.95,0.95,1)
	
	if noadd then
	else
		-- for _,j in pairs({GameTooltip:GetRegions()}) do if j:GetObjectType()=='Texture' then j:SetBlendMode('add') end end
	end
	GameTooltip:Show()
end
function DA.myShowTooltipMinimap(self)
	GameTooltip:SetOwner(self,'ANCHOR_NONE')
	GameTooltip:SetPoint('bottomright',self,'topleft',0,5)
	GameTooltip:ClearLines()
	
	GameTooltipTextLeft1:SetFont(UIDarkAngelFontConsolas:GetFont(), 15,'outline')
	GameTooltipTextRight1:SetFont(UIDarkAngelFontConsolas:GetFont(), 15,'outline')
	
	GameTooltipTextLeft2:SetFont("Fonts\\FRIZQT__.TTF", 11,'outline')
	
	GameTooltip:AddDoubleLine("|cff03fcf4DarkAngel|r","v"..GetAddOnMetadata("DarkAngel",'version'),0.25,0.85,0.85,0.35,0.85,0.45)
	GameTooltip:AddLine(L["minimaptooltip"],0.45,0.65,0.65,1)
	
	for _,j in pairs({GameTooltip:GetRegions()}) do if j:GetObjectType()=='Texture' then j:SetBlendMode('add') end end
	GameTooltip:Show()
end
function DA.myHideTooltip()
	GameTooltip:Hide()
	GameTooltipTextLeft1:SetFont(unpack(FEP_TT_savedfont1))
	GameTooltipTextRight1:SetFont(unpack(FEP_TT_savedfont1))
	GameTooltipTextLeft2:SetFont(unpack(FEP_TT_savedfont2))
end

function DA.CreateTimer(runfromstart,short,startfrom,speed,runwhile,OnRun)
	DA_XTimers[short]=CreateFrame('frame')
	local f=DA_XTimers[short]
	f.speed=speed
	f.time=startfrom

	if type(runwhile)=='boolean' and runwhile then
		f.myscript=function(self,elapsed)		
			self.time = self.time - elapsed
			if self.time <= 0 then
				self.time=f.speed
				self.code(self)
			end
		end
	else
		f.myscript=function(self,elapsed)
			if runwhile() then 
			else 
				self:SetScript("OnUpdate",nil)
				return 
			end
			
			self.time = self.time - elapsed
			if self.time <= 0 then
				self.time=f.speed
				self.code(self)
			end
		end
	end


	f.code=OnRun

	if runfromstart then
		f:SetScript("OnUpdate", f.myscript)
	end

end

function DA.ResumeTimer(short)

	if DA_XTimers[short] then
		if DA_XTimers[short]:GetScript("OnUpdate") then
			-- print(short..' already runnin')
		else
			-- print('resumed',short)
			DA_XTimers[short]:SetScript("OnUpdate", DA_XTimers[short].myscript)
		end
	else
		-- print('no such timer-'..short)
		return
	end
end
function DA.StopTimer(short)
	if DA_XTimers[short] then
		-- print('stopped',short)
		DA_XTimers[short]:SetScript("OnUpdate", nil)
	else
		-- print('no such timer-'..short)
		return
	end
end
function DA.SetTimerTime(short,times)
	if DA_XTimers[short] then
		DA_XTimers[short]['time']=times
	else
		print('no such timer-'..short)
		return
	end
end
function DA.SetTimerSpeed(short,speed)
	if DA_XTimers[short] then
		DA_XTimers[short]['speed']=speed
	else
		print('no such timer-'..short)
		return
	end
end

DA.ButtonCreater("DarkAngel_bind2",nil,{"TOPLEFT",UIParent,"TOPLEFT",-334,110},1,1,'','',function()
	if DA.loaded_Modules['Inviter'] and DarkAngel_minimapBtn and DarkAngel_minimapBtn.fullyloaded then
		DA_Inviter.OpenClose()
	end
end):RegisterForClicks('anydown')
DA.ButtonCreater("DarkAngel_bind3",nil,{"TOPLEFT",UIParent,"TOPLEFT",-334,110},1,1,'','',function()
	if DA.loaded_Modules['Awarder'] and DarkAngel_minimapBtn and DarkAngel_minimapBtn.fullyloaded then
		DA_Awarder.OpenClose()
	end
end):RegisterForClicks('anydown')
DA.ButtonCreater("DarkAngel_bind4",nil,{"TOPLEFT",UIParent,"TOPLEFT",-334,110},1,1,'','',function()
	if DA.loaded_Modules['BidTracker'] and DarkAngel_minimapBtn and DarkAngel_minimapBtn.fullyloaded then
		if DA_BidTracker:IsShown() then
			DA_BidTracker:Hide()
		else
			DA_BidTracker:Show()
		end
	end
end):RegisterForClicks('anydown')
DA.ButtonCreater("DarkAngel_bind5",nil,{"TOPLEFT",UIParent,"TOPLEFT",-334,110},1,1,'','',function()
	if DA.loaded_Modules['Dispenser'] and DarkAngel_minimapBtn and DarkAngel_minimapBtn.fullyloaded then
		if DA_Flasker:IsShown() then
			DA_Flasker:Hide()
		else
			DA_Flasker:Show()
		end
	end
end):RegisterForClicks('anydown')

local pattern_empty_rank={
	name="NewRank",
	guildchat_listen=true,
	guildchat_speak=true,
	officerchat_listen=false,
	officerchat_speak=false,
	promote=false,
	demote=false,
	invite_member=false,
	remove_member=false,
	set_motd=false,
	edit_public_note=false,
	view_officer_note=true,
	edit_officer_note=false,
	modify_guild_info=false,
	withdraw_repair=false,
	withdraw_gold=false,
	create_guild_event=false,
	gwithraw="0",
	bankpermissions={
		{
			canView=false,
			canDeposit=false,
			canEditInfo=false,
			stacksPerDay=false
		},
		{
			canView=false,
			canDeposit=false,
			canEditInfo=false,
			stacksPerDay=false
		},
		{
			canView=false,
			canDeposit=false,
			canEditInfo=false,
			stacksPerDay=false
		},
		{
			canView=false,
			canDeposit=false,
			canEditInfo=false,
			stacksPerDay=false
		},
		{
			canView=false,
			canDeposit=false,
			canEditInfo=false,
			stacksPerDay=false
		},
		{
			canView=false,
			canDeposit=false,
			canEditInfo=false,
			stacksPerDay=false
		},
	}
}

local function RanksFrameUpd(aaaa)

if aaaa or DarkAngelGUI.Guild.micromenu.ranksmenuFrame:IsVisible() then else return end
	local myrank=({GetGuildInfo('player')})[3]	
	local targetrank=DarkAngelGUI.Guild.micromenu.ranksmenubtn.realrankid
	
	local maxrank=GuildControlGetNumRanks()
	for i=1,10 do
		if i<=maxrank then
			if DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i] then
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i].fs:SetText(GuildControlGetRankName(i))
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:SetScript("OnClick",function() DA.DemotePromotePlayer(DarkAngelGUI.Guild.micromenu.plbox:GetText(),DarkAngelGUI.Guild.micromenu.ranksmenubtn.realrankid,i);if fuckingOptions.mmenucloserank then DarkAngelGUI.Guild.micromenu.ranksmenuFrame:Hide() end end)
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:SetPoint("TOPLEFT", DarkAngelGUI.Guild.micromenu.ranksmenuFrame, "TOPLEFT", 1,10-11*i)
			else
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu.ranksmenuFrame,{"TOPLEFT", DarkAngelGUI.Guild.micromenu.ranksmenuFrame, "TOPLEFT", 1,10-11*i},10,68,GuildControlGetRankName(i),'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function() 
					DA.DemotePromotePlayer(DarkAngelGUI.Guild.micromenu.plbox:GetText(),DarkAngelGUI.Guild.micromenu.ranksmenubtn.realrankid,i)
					if fuckingOptions.mmenucloserank then DarkAngelGUI.Guild.micromenu.ranksmenuFrame:Hide() end
				end,nil,nil,'left')
			end
			DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:Show()
		elseif DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i] then
			DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:Hide()
		end
		
	end
	
	if targetrank<myrank then
		--target is HIGHER rank than me
		for i=1,GuildControlGetNumRanks() do
			DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:Disable()
			if i-1==targetrank then
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i].fs:SetTextColor(0.2,1,1,1)
				-- DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up.blp')
			else
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i].fs:SetTextColor(0.85,1,1,1)
				-- DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp')
			end
		end
	elseif targetrank==myrank then
		--target is same rank
		for i=1,GuildControlGetNumRanks() do
			if i-1==targetrank then
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:Enable()
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i].fs:SetTextColor(0.2,1,1,1)
				-- DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up.blp')
			else
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:Disable()
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i].fs:SetTextColor(0.85,1,1,1)
				-- DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp')
			end
		end
	else
		--target is LOWER rank than me
		for i=1,GuildControlGetNumRanks() do
			if i-1==targetrank then
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:Enable()
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i].fs:SetTextColor(0.2,1,1,1)
				-- DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up.blp')
			elseif i-1<=myrank then
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:Disable()
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i].fs:SetTextColor(0.85,1,1,1)
				-- DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp')
			else
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:Enable()
				DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i].fs:SetTextColor(0.85,1,1,1)
				-- DarkAngelGUI.Guild.micromenu.ranksmenuFrame['rankbtn'..i]:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp')
			end
		end
	end

	DarkAngelGUI.Guild.micromenu.ranksmenuFrame:SetSize(70,GuildControlGetNumRanks()*11)
end

function DA.DKPawardfunc(name,value,reason,isfake,wh,isblk)
if name and value and reason then else return end
if type(value)=='number' then else print('error 1044') return end
if FEP_gMain[name] then else DA.Print(DA.GetColorName(name or 'no_name')..' -not found') return end


local typ,ep,gp,hrs=DA.DecodeNote(FEP_gMain[name])

if typ=='f' then
	DA.Print((wh or name).. ' has frozen DKP')
	return
end

if DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
	if not isfake then
		if tonumber(value)>0 then
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), "Net:"..tostring(tonumber(ep)+tonumber(value)).." Tot:"..tostring(tonumber(gp)+tonumber(value))..((hrs and " Hrs:"..hrs) or "") )
			SendChatMessage("QDKP2> "..name.." Gains "..value.." DKP ("..reason..")",'guild')
		else
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), "Net:"..tostring(tonumber(ep)+tonumber(value)).." Tot:"..tostring(tonumber(gp))..((hrs and " Hrs:"..hrs) or "") )
			SendChatMessage("QDKP2> "..name.." Spends "..math.abs(value).." DKP ("..reason..")",'guild')
		end
	end
	SendAddonMessage("DA_log",name.."\031"..value, "guild")
	

	if wh and isblk and UnitInRaid('player') then
		if value>0 then
			SendChatMessage("QDKP2> "..wh.." Gains "..value.." DKP ("..reason..")".."["..name.."]",'raid')
		else
			SendChatMessage("QDKP2> "..wh.." Spends "..-value.." DKP ("..reason..")".."["..name.."]",'raid')
		end
	end
end


end
function DA.EPawardfunc(name,value,reason,isfake,wh,isblk)
if name and value and reason then else return end
if type(value)=='number' then else print('error 1044') return end
if FEP_gMain[name] then else DA.Print(DA.GetColorName(name or 'no_name')..' -not found') return end


local typ,ep,gp,hrs=DA.DecodeNote(FEP_gMain[name])

if typ=='f' then
	DA.Print((wh or name).. ' has frozen EPGP')
	return
end

	if EPGP then --insert EPGP log
		tinsert(EPGP_DB.namespaces.log.profiles[DA_CurrentGuild].log , {GetTimestamp(),'EP',name,reason,tonumber(value)})
	end

	DA_fakeep(name,'EP',value,reason)

	if not isfake then
		if tonumber(ep)+tonumber(value)>=0 then
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), tostring(tonumber(ep)+tonumber(value))..","..tostring(gp) )
		else
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), "0,"..tostring(gp) )
			DA.Print((L["settingep0"]:gsub("$1",name)):gsub("$2",tonumber(ep).."/"..tonumber(value)))
		end
	end

	if wh and isblk and UnitInRaid('player') then
		if value>0 then
			SendChatMessage("EPGP: +"..value.." EP ("..reason..") "..wh.."["..name.."]",'raid')
		else
			SendChatMessage("EPGP: "..value.." EP ("..reason..") "..wh.."["..name.."]",'raid')
		end
	end

end
function DA.GPawardfunc(name,value,reason,isfake,wh,isblk)
if name and value and reason then else return end
if type(value)=='number' then else print('error 1044') return end
if FEP_gMain[name] then else DA.Print(DA.GetColorName(name or 'no_name')..' -not found') return end

local typ,ep,gp=DA.DecodeNote(FEP_gMain[name])

if typ=='f' then
	DA.Print((wh or name).. ' has frozen EPGP')
	return
end

	if EPGP then --insert EPGP log
		tinsert(EPGP_DB.namespaces.log.profiles[DA_CurrentGuild].log , {GetTimestamp(),'GP',name,reason,tonumber(value)})
	end
		
	DA_fakeep(name,'GP',value,reason)

	if not isfake then
		if tonumber(gp)+tonumber(value)>=0 then
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), (tostring(ep)..","..tostring(tonumber(gp)+tonumber(value))) )
		else
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), (tostring(ep)..",0") )
			DA.Print((L["settinggp0"]:gsub("$1",name)):gsub("$2",tonumber(gp).."/"..tonumber(value)))
		end
	end

	if wh and isblk and UnitInRaid('player') then
		if value>0 then
			SendChatMessage("EPGP: +"..value.." EP ("..reason..") "..wh.."["..name.."]",'raid')
		else
			SendChatMessage("EPGP: "..value.." EP ("..reason..") "..wh.."["..name.."]",'raid')
		end
	end

end



local Guild_Create_ScrollBar

function DA.CreateGUIs()
---- MAIN ----
---- MAIN ----

	DA.CloseButtonCreater(nil,DarkAngelGUI,{"TOPRIGHT", DarkAngelGUI, "TOPRIGHT", -5,-5},10,10,'x')
	DarkAngelGUI.myclosebtn:HookScript("OnClick",function() DA.Garbage_Collect() end)
	
	if UISpecialFrames then 
		tinsert(UISpecialFrames, "DarkAngelGUI")
		tinsert(UISpecialFrames, "DAOptMenuFrame") 
	end
	
	DA.CreateScaler('DarkAngelGUI',0.6,2,{'fuckingOptions','FFGScale'})
---- rightclick options ---- 
---- rightclick options ---- 
---- rightclick options ---- 
do
	do --frame
		DA.FrameCreater("DAOptMenuFrame",UIParent,62,105,{"TOPLEFT",UIParent,"TOPLEFT"})
		DAOptMenuFrame:SetFrameStrata("FULLSCREEN_DIALOG")
		DAOptMenuFrame:SetFrameLevel(107)
		DAOptMenuFrame.timerticked=0
		DAOptMenuFrame.t:SetTexture(0.03, 0.04, 0.07, 0.8)
		DAOptMenuFrame:SetScript("OnEnter",function() DAOptMenuFrame.timerticked=0 end)
		DAOptMenuFrame:SetScript("OnShow",function()
			if InCombatLockdown() then

			else
					DAOptMenuFrame.target:SetParent(DAOptMenuFrame)
					DAOptMenuFrame.focus:SetParent(DAOptMenuFrame)
					DAOptMenuFrame.MT:SetParent(DAOptMenuFrame)
					DAOptMenuFrame.OT:SetParent(DAOptMenuFrame)
				DAOptMenuFrame.target:SetPoint("CENTER",DAOptMenuFrame,"TOPRIGHT",-117,-12)
				DAOptMenuFrame.focus:SetPoint("CENTER",DAOptMenuFrame,"TOPRIGHT",-117,-27)
				DAOptMenuFrame.MT:SetPoint("CENTER",DAOptMenuFrame,"TOPRIGHT",-123.5,-50)
				DAOptMenuFrame.OT:SetPoint("CENTER",DAOptMenuFrame,"TOPRIGHT",-92,-50)
				if DAOptMenuFrame.calledfrom=="DA_Awarder" then
					DAOptMenuFrame.target:Show()
					DAOptMenuFrame.focus:Show()
					DAOptMenuFrame.MT:Show()
					DAOptMenuFrame.OT:Show()
				end
				-- DAOptMenuFrame.hiddenframe

			end
		end)
		DAOptMenuFrame:SetScript("OnHide",function()
			if InCombatLockdown() then

			else
				DAOptMenuFrame.target:SetParent('UIParent')
				DAOptMenuFrame.focus:SetParent('UIParent')
				DAOptMenuFrame.MT:SetParent('UIParent')
				DAOptMenuFrame.OT:SetParent('UIParent')
					DAOptMenuFrame.target:ClearAllPoints()
					DAOptMenuFrame.focus:ClearAllPoints()
					DAOptMenuFrame.MT:ClearAllPoints()
					DAOptMenuFrame.OT:ClearAllPoints()
				DAOptMenuFrame.target:Hide()
				DAOptMenuFrame.focus:Hide()
				DAOptMenuFrame.MT:Hide()
				DAOptMenuFrame.OT:Hide()

			end
		end)
		DAOptMenuFrame:SetScript("OnEvent", function(self) if self:IsShown() then self:GetScript("OnShow")(self) end if DA.loaded_Modules['Awarder'] then FEP_GatherRaid() end end)
		DAOptMenuFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		
		
	end
	
	-- content
	do 
		local closer99a=DA.CloseButtonCreater(nil,DAOptMenuFrame,{"BOTTOMLEFT", DAOptMenuFrame, "TOPRIGHT", 2,2},10,10,'x')
		-- closer99a:SetFrameLevel(119)
		closer99a:SetScript("OnEvent", function(self) if DAOptMenuFrame:IsShown() and DAOptMenuFrame.calledfrom=="DA_Awarder" then self:Click(self) end end)
		closer99a:RegisterEvent("PLAYER_REGEN_DISABLED")
		
		DA.CreateFFGButton2(nil,DAOptMenuFrame,{"LEFT",DAOptMenuFrame,"TOPRIGHT",-75,-10},14,73,L['Whisper'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},function()
			DAOptMenuFrame:Hide(); 
			if DAOptMenuFrame.player then
				_G[SELECTED_CHAT_FRAME:GetName().."EditBox"]:SetText('/w '..DAOptMenuFrame.player..' ')
				ChatEdit_ActivateChat(_G[SELECTED_CHAT_FRAME:GetName().."EditBox"])
			end
		end,nil,nil,'left')
		DAOptMenuFrame.invite=DA.CreateFFGButton2(nil,DAOptMenuFrame,{"LEFT",DAOptMenuFrame,"TOPRIGHT",-75,-25},14,73,L['Invite'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
			DAOptMenuFrame:Hide(); 
			if DAOptMenuFrame.player then
				InviteUnit(DAOptMenuFrame.player)
			end
		end,nil,nil,'left')
		
		DAOptMenuFrame.detailsbtn=DA.CreateFFGButton2(nil,DAOptMenuFrame,{"LEFT",DAOptMenuFrame,"TOPRIGHT",-75,-50},14,73,L['Details'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},function()
			DAOptMenuFrame:Hide(); 
			if DAOptMenuFrame.player then
				SlashCmdList.DAtargetsearch(DAOptMenuFrame.player)
			end
		end,nil,nil,'left')
		DA.CreateFFGButton2(nil,DAOptMenuFrame,{"LEFT",DAOptMenuFrame,"TOPRIGHT",-75,-65},14,73,L['Twinks'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},function()
			DAOptMenuFrame:Hide(); 
			DarkAngelGUI:Show()
			local ofnote=DAOptMenuFrame.ofnote or DAOptMenuFrame.altnote
			if DAOptMenuFrame.player then
				if ofnote and (DA.DecodeNote(ofnote)=='m' or DA.DecodeNote(ofnote)=='f' ) then
				--is main/frozen main
					DarkAngelGUI.Guild.precmatch:SetChecked(false);fuckingOptions.precisematchsearch=false
					DarkAngelGUI.Guild.showlocals:SetChecked(1);fuckingOptions.showlocals=1
					DarkAngelGUI.Guild.EB1:SetText(DAOptMenuFrame.player)
					DarkAngelGUI.Guild.EB2:SetText("")
					DarkAngelGUI.Guild.EB3:SetText("")
					DarkAngelGUI.Guild.EB4:SetText(DAOptMenuFrame.player)
					DarkAngelGUI.Guild.EB5:SetText("")
					DarkAngelGUI.Guild.EB6:SetText("")
					
					if DarkAngelGUI.Guild.bulkmenu:IsShown() then
						DarkAngelGUI.Guild.bulkmenu.assignedto:SetText(DAOptMenuFrame.player)
					end
					fuckingOptions.showoffl=1
					DarkAngelGUI.Guild.offliners:SetChecked(1)
					DA.GetGuildData();DA.GuildSetAllLines()
					
				elseif ofnote and (DA.DecodeNote(ofnote)=='t' and 2 ) then
				--is main/frozen main
					DarkAngelGUI.Guild.precmatch:SetChecked(false);fuckingOptions.precisematchsearch=false
					DarkAngelGUI.Guild.showlocals:SetChecked(1);fuckingOptions.showlocals=1
					DarkAngelGUI.Guild.EB1:SetText(ofnote)
					DarkAngelGUI.Guild.EB2:SetText("")
					DarkAngelGUI.Guild.EB3:SetText("")
					DarkAngelGUI.Guild.EB4:SetText(ofnote)
					DarkAngelGUI.Guild.EB5:SetText("")
					DarkAngelGUI.Guild.EB6:SetText("")
					
					if DarkAngelGUI.Guild.bulkmenu:IsShown() then
						DarkAngelGUI.Guild.bulkmenu.assignedto:SetText(ofnote)
					end
					fuckingOptions.showoffl=1
					DarkAngelGUI.Guild.offliners:SetChecked(1)
					DA.GetGuildData();DA.GuildSetAllLines()
				end
				_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',true)
				_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',false)
			end
		end,nil,nil,'left')
		
		DAOptMenuFrame.epgpaward,DAOptMenuFrame.epgpawardFrame=DA.CreateFFGDropFrame(DAOptMenuFrame,L['award'],14,73,{"LEFT",DAOptMenuFrame,"TOPRIGHT",-75,-80},120,57,"TOPRIGHT",'left')
		DAOptMenuFrame.epgpaward:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White')
		DAOptMenuFrame.epgpaward.fs:SetTextColor(0.5,0.9,1,1)
		DAOptMenuFrame.epgpawardFrame.t:SetTexture(0.03, 0.04, 0.07, 0.8)
			do 
				local function awardfunc(name,epgp,value,reason)

					if epgp=='ep' then
						if FEP_gMain[name] then
							if DA.DecodeNote(FEP_gMain[name])=='m' then
								DA.EPawardfunc(name,value,reason)
							elseif DA.DecodeNote(FEP_gMain[name])=='t' and FEP_gMain[FEP_gMain[name]] and DA.DecodeNote(FEP_gMain[FEP_gMain[name]])=='m' then
								DA.EPawardfunc(FEP_gMain[name],value,reason)
							end
						elseif FEP_L_gMain[DA_CurrentGuild][name] then
							if FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]] and DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]])=='m' then
								DA.EPawardfunc(FEP_L_gMain[DA_CurrentGuild][name],value,reason,nil,name)
								
							end
						end
					elseif epgp=='gp' then
						if FEP_gMain[name] then
							if DA.DecodeNote(FEP_gMain[name])=='m' then
								DA.GPawardfunc(name,value,reason)
							elseif DA.DecodeNote(FEP_gMain[name])=='t' and FEP_gMain[FEP_gMain[name]] and DA.DecodeNote(FEP_gMain[FEP_gMain[name]])=='m' then
								DA.GPawardfunc(FEP_gMain[name],value,reason)
							end
						elseif FEP_L_gMain[DA_CurrentGuild][name] then
							if FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]] and DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]])=='m' then
								DA.GPawardfunc(FEP_L_gMain[DA_CurrentGuild][name],value,reason,nil,name)
								
							end
						end
						
					elseif epgp=='+dkp' then
						if FEP_gMain[name] then
							if DA.DecodeNote(FEP_gMain[name])=='m' then
								DA.DKPawardfunc(name,value,reason)
							elseif DA.DecodeNote(FEP_gMain[name])=='t' and FEP_gMain[FEP_gMain[name]] and DA.DecodeNote(FEP_gMain[FEP_gMain[name]])=='m' then
								DA.DKPawardfunc(FEP_gMain[name],value,reason)
							end
						elseif FEP_L_gMain[DA_CurrentGuild][name] then
							if FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]] and DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]])=='m' then
								DA.DKPawardfunc(FEP_L_gMain[DA_CurrentGuild][name],value,reason,nil,name)
								
							end
						end
					elseif epgp=='-dkp' then
						if FEP_gMain[name] then
							if DA.DecodeNote(FEP_gMain[name])=='m' then
								DA.DKPawardfunc(name,-value,reason)
							elseif DA.DecodeNote(FEP_gMain[name])=='t' and FEP_gMain[FEP_gMain[name]] and DA.DecodeNote(FEP_gMain[FEP_gMain[name]])=='m' then
								DA.DKPawardfunc(FEP_gMain[name],-value,reason)
							end
						elseif FEP_L_gMain[DA_CurrentGuild][name] then
							if FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]] and DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]])=='m' then
								DA.DKPawardfunc(FEP_L_gMain[DA_CurrentGuild][name],-value,reason,nil,name)
								
							end
						end
					end
				if DA.loaded_Modules['Awarder'] then
					FEP_GatherRaid()
					tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
				end
				tinsert(DA_Fep_bulk,function() DAOptMenuFrame.epgpawardFrame.start:Enable() end)
				tinsert(DA_Fep_bulk,function() if DarkAngelGuild:IsShown() then DA.GetGuildData();DA.GuildSetAllLines() end end)
				DA.ResumeTimer('fep')

				end

				DAOptMenuFrame.epgpawardFrame.start=DA.CreateFFGButton2(nil,DAOptMenuFrame.epgpawardFrame,{"TOPLEFT", DAOptMenuFrame.epgpawardFrame, "TOPLEFT", 60, -2},13,50,L['add'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
					self:Disable() 
					DAOptMenuFrame.epgpawardFrame.value.focusgained=nil
					DAOptMenuFrame.epgpawardFrame.value:ClearFocus()
					DAOptMenuFrame.epgpawardFrame.reason.focusgained=nil
					DAOptMenuFrame.epgpawardFrame.reason:ClearFocus()
					
					if CanEditOfficerNote() then
					else
						DA.Print(L['I am not a guild officer'])
						self:Enable()
						return
					end
					
					local reason=DAOptMenuFrame.epgpawardFrame.reason:GetText()
					if reason=="" then reason='test' end
						
					local value=DAOptMenuFrame.epgpawardFrame.value:GetText()
					if value=="" or not tonumber(value) then 
						self:Enable()
						return
					end
					
					awardfunc(DAOptMenuFrame.player,string.lower(DAOptMenuFrame.epgpawardFrame.epgp.fs:GetText()),tonumber(value),tostring(reason))
				end,nil,nil)
				
				local epgpdkpfunc
				if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
					epgpdkpfunc=function(self)
						if self.fs:GetText()=='EP' then
							self.fs:SetText('GP')
							self:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Yellow.blp')
						elseif self.fs:GetText()=='GP' then
							self.fs:SetText('EP')
							self:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Green.blp')
						end
					end
				elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
					epgpdkpfunc=function(self)
						if self.fs:GetText()=='+DKP' then
							self.fs:SetText('-DKP')
							self:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Yellow.blp')
						elseif self.fs:GetText()=='-DKP' then
							self.fs:SetText('+DKP')
							self:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Green.blp')
						end
					end
				end
				DAOptMenuFrame.epgpawardFrame.epgp=DA.CreateFFGButton2(nil,DAOptMenuFrame.epgpawardFrame,{"TOPLEFT", DAOptMenuFrame.epgpawardFrame, "TOPLEFT", 5, -2},13,40,((DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' and 'EP') or (DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' and '+DKP')),'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Green',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},epgpdkpfunc)
				
				DAOptMenuFrame.epgpawardFrame.reason=DA.EditBoxCreater(nil,DAOptMenuFrame.epgpawardFrame,{"TOPLEFT", DAOptMenuFrame.epgpawardFrame, "TOPLEFT", 5, -30},{50,18},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 9.5},
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end,
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end, --enter here
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end,
					function(self) 	
						if self:GetParent():IsShown() then
							self.t:SetBlendMode('blend');
							self.focusgained=1
							self:HighlightText()
						end
					end
				)
				DAOptMenuFrame.epgpawardFrame.reason:SetText("test")
				DA.FontCreater(nil,L['reason'],{"LEFT",DAOptMenuFrame.epgpawardFrame.reason,"LEFT",3,15},DAOptMenuFrame.epgpawardFrame.reason,15,170,{UIDarkAngelFontConsolas:GetFont(), 10},'left',{0.85,1,1,0.8})
				
				DAOptMenuFrame.epgpawardFrame.value=DA.EditBoxCreater(nil,DAOptMenuFrame.epgpawardFrame,{"TOPLEFT", DAOptMenuFrame.epgpawardFrame, "TOPLEFT", 60, -30},{50,18},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 9.5},
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end,
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end, --enter here
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end,
					function(self) 	
						if self:GetParent():IsShown() then
							self.t:SetBlendMode('blend');
							self.focusgained=1
						end
					end
					,nil,true
				)
				DA.FontCreater(nil,L['value'],{"LEFT",DAOptMenuFrame.epgpawardFrame.value,"LEFT",3,15},DAOptMenuFrame.epgpawardFrame.value,15,170,{UIDarkAngelFontConsolas:GetFont(), 10},'left',{0.85,1,1,0.8})
				
			end
		DAOptMenuFrame.GKick=DA.CreateFFGButton2(nil,DAOptMenuFrame,{"LEFT",DAOptMenuFrame,"TOPRIGHT",-75,-95},14,73,L['G.Kick'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
			if DAOptMenuFrame.player~=UnitName('player') then
				if CanGuildRemove() then
					if IsShiftKeyDown() then 
						GuildUninvite(DAOptMenuFrame.player)
					else
						DA.Print(L['requires Shift+Click'])
						return
					end
				else
					DA.Print(L['I am not allowed to kick guild members'])
					return
				end
			
			else 
				DA.Print('stupid?')
				DA.Print('Ctrl+Alt+Shift+Click to leave guild')
				if IsShiftKeyDown() and IsAltKeyDown() and IsControlKeyDown() then 
					GuildLeave()
				end
				return
			end
		end,nil,nil,'left')
		DAOptMenuFrame.GKick.fs:SetTextColor(1,0.88,0.88,1)
				
		DAOptMenuFrame.hiddenframe=CreateFrame('Frame');DAOptMenuFrame.hiddenframe:Hide()
		
		DAOptMenuFrame.target=DA.SecButtonCreater(nil,DAOptMenuFrame.hiddenframe,{'TOPRIGHT'},14,44,L['target'],nil,'left')
		DAOptMenuFrame.focus=DA.SecButtonCreater(nil,DAOptMenuFrame.hiddenframe,{'TOPRIGHT'},14,44,L['focus'],nil,'left')
		
		DAOptMenuFrame.MT=DA.SecButtonCreater(nil,DAOptMenuFrame.hiddenframe,{'TOPRIGHT'},15,30,'')
			DAOptMenuFrame.MT.icon=DAOptMenuFrame:CreateTexture(nil, "BACKGROUND"); 
			DAOptMenuFrame.MT.icon:SetTexture("Interface\\GroupFrame\\UI-Group-MainTankIcon")
			DAOptMenuFrame.MT.icon:SetPoint('center',DAOptMenuFrame.MT,'center')
			DAOptMenuFrame.MT.icon:SetParent(DAOptMenuFrame.MT);DAOptMenuFrame.MT.icon:SetBlendMode("blend")
		
		DAOptMenuFrame.OT=DA.SecButtonCreater(nil,DAOptMenuFrame.hiddenframe,{'TOPRIGHT'},15,30,'')
			DAOptMenuFrame.OT.icon=DAOptMenuFrame:CreateTexture(nil, "BACKGROUND")
			DAOptMenuFrame.OT.icon:SetTexture("Interface\\GroupFrame\\UI-Group-MainAssistIcon")
			DAOptMenuFrame.OT.icon:SetPoint('center',DAOptMenuFrame.OT,'center')
			DAOptMenuFrame.OT.icon:SetParent(DAOptMenuFrame.OT)
			DAOptMenuFrame.OT.icon:SetBlendMode("blend")
		
		DAOptMenuFrame.assist=DA.CreateFFGButton2(nil,DAOptMenuFrame,{"CENTER",DAOptMenuFrame,"TOPRIGHT",-123.5,-66},15,30,'','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self,butt)
			if butt=='LeftButton' then
				if UnitIsPartyLeader('player') then
					if UnitIsRaidOfficer(DAOptMenuFrame.player) then
						DemoteAssistant(DAOptMenuFrame.player)
					else
						PromoteToAssistant(DAOptMenuFrame.player)
					end
				end
			elseif butt=='RightButton' and IsShiftKeyDown() and UnitIsPartyLeader('player') and DAOptMenuFrame.player~=UnitName('player') then
				PromoteToLeader(DAOptMenuFrame.player)
			end
		end,'optmenuleader')
		DAOptMenuFrame.assist.icon=DAOptMenuFrame:CreateTexture(nil, "BACKGROUND"); DAOptMenuFrame.assist.icon:SetTexture("Interface\\GroupFrame\\UI-Group-AssistantIcon"); DAOptMenuFrame.assist.icon:SetPoint('center',DAOptMenuFrame.assist,'center'); DAOptMenuFrame.assist.icon:SetParent(DAOptMenuFrame.assist);DAOptMenuFrame.assist.icon:SetBlendMode("blend")
		
		DAOptMenuFrame.looter=DA.CreateFFGButton2(nil,DAOptMenuFrame,{"CENTER",DAOptMenuFrame,"TOPRIGHT",-92,-66},15,30,'','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self,butt)
			if UnitIsPartyLeader('player') then
				DAOptMenuFrame.lootername=false
				if GetNumRaidMembers()==0 then return end
				for i=1,GetNumRaidMembers() do
					
					local nam, _, _, _, _, _, _, _, _, _, isML = GetRaidRosterInfo(i)
					if isML then
						DAOptMenuFrame.lootername=nam
						break
					end
				end
				
				DAOptMenuFrame.assist:SetAlpha(1)
				DAOptMenuFrame.assist:Enable()
				DAOptMenuFrame.looter:SetAlpha(1)
				DAOptMenuFrame.looter:Enable()
				
				if DAOptMenuFrame.lootername==DAOptMenuFrame.player then
					if UnitIsPartyLeader(DAOptMenuFrame.player) then
					else
						DA.Print('selected looter '..UnitName('player'))
						SetLootMethod("master", UnitName('player'))
					end
				else
					SetLootMethod("master", DAOptMenuFrame.player)
				end
			else
				DAOptMenuFrame.assist:SetAlpha(0.5)
				DAOptMenuFrame.assist:Disable()
				DAOptMenuFrame.looter:SetAlpha(0.5)
				DAOptMenuFrame.looter:Disable()
			end
		end)
		DAOptMenuFrame.looter.icon=DAOptMenuFrame:CreateTexture(nil, "BACKGROUND"); DAOptMenuFrame.looter.icon:SetTexture("Interface\\GroupFrame\\UI-Group-MasterLooter"); DAOptMenuFrame.looter.icon:SetPoint('center',DAOptMenuFrame.looter,'center'); DAOptMenuFrame.looter.icon:SetParent(DAOptMenuFrame.looter);DAOptMenuFrame.looter.icon:SetBlendMode("blend")
		
		DAOptMenuFrame.kick=DA.CreateFFGButton2(nil,DAOptMenuFrame,{"CENTER",DAOptMenuFrame,"TOPRIGHT",-116.5,-90},15,44,L['kick'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight',{UIDarkAngelFontConsolas:GetFont(), 9},function()
			if UnitIsRaidOfficer('player') and UnitInRaid(DAOptMenuFrame.player) then
				if GetLootMethod()=='master' and DAOptMenuFrame.lootername and DAOptMenuFrame.lootername==DAOptMenuFrame.player then
					SetLootMethod("master", UnitName('player'))
					UninviteUnit(DAOptMenuFrame.player)
				else
					UninviteUnit(DAOptMenuFrame.player)
				end
			end
		end,nil,nil,'left')
		DAOptMenuFrame.kick.fs:SetTextColor(1,0.88,0.88,1)
	
	
	end
end
---- 1 TAB ------
---- 1 TAB ------
---- 1 TAB ------
DA.TabCreater({"TOP",_G["DarkAngelGUI"],"BOTTOMLEFT",55,0},15,40,10,50,"Guild",{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},function(self) DA.SetTimerTime('grefresher',5)  DA.GetGuildData();DA.GuildSetAllLines();DA.ResetScrollBoxes() end,function() DA.ResetScrollBoxes() end,"Interface\\AddOns\\DarkAngel\\template\\pict\\a1")
local copyFrame_Update
local update_class_srch
do
	
	Guild_Create_ScrollBar()
		DarkAngelGUI.Guild.precmatch=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",65,-6},14,14,'A',function(self) fuckingOptions.precisematchsearch=(self:GetChecked() or false) DA.GetGuildData(1);DA.GuildSetAllLines() end,{'fuckingOptions','precisematchsearch'},"precisematchsearch")
		DarkAngelGUI.Guild.showlocals=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",65,-16},14,14,'L',function(self) fuckingOptions.showlocals=(self:GetChecked() or false) DA.GetGuildData(1);DA.GuildSetAllLines() end,{'fuckingOptions','showlocals'},"showlocals")
		
		DarkAngelGUI.Guild.onliners=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",93,-6},14,14,'online',function(self) fuckingOptions.showonl=(self:GetChecked() or false) DA.GetGuildData();DA.GuildSetAllLines() end,{'fuckingOptions','showonl'})
		DarkAngelGUI.Guild.offliners=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",93,-16},14,14,'offline',function(self) fuckingOptions.showoffl=(self:GetChecked() or false) DA.GetGuildData();DA.GuildSetAllLines() end,{'fuckingOptions','showoffl'})

		-- refresh
		DarkAngelGUI.Guild.refreshbtn=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",163,-8},8,52,L['refresh'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
			DA.GetGuildData();DA.GuildSetAllLines()
		end)
		DarkAngelGUI.Guild.activescan=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",148,-16},14,14,'auto',function(self) 
			fuckingOptions.grefr=(self:GetChecked() or false) 
			if self:GetChecked() then
				DA.ResumeTimer('grefresher')
			else
				DA.StopTimer('grefresher')
			end 
		end,{'fuckingOptions','grefr'},'grefr')  ; if fuckingOptions.grefr then SetCVar("guildMemberNotify",1) end 
		_G["DarkAngelGuild"]:HookScript("OnShow", function () 
			if fuckingOptions.grefr then 
				DA.ResumeTimer('grefresher')
			end  
		end)
		
		-- sort
		do
			local additgsort={
				{"-no sort-"},
				{"online"},
				{"name"},
				{"rank"},
				{"note"},
				{"offic.note"},
				{"level"},
				{"class"},
				{"online:tvin groups",7,'onltvingrps'},
			}
			if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
				tinsert(additgsort,{'EPGP:EP'})
				tinsert(additgsort,{'EPGP:GP'})
				tinsert(additgsort,{'EPGP:PR'})
			elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
				tinsert(additgsort,{'DKP:Net'})
				tinsert(additgsort,{'DKP:Total'})
				tinsert(additgsort,{'DKP:Hours'})
			end
			
			local function re_highlight_gsort()
				for i=1,#additgsort do
					if DarkAngelGUI.Guild.gsortFrame[i].fs:GetText()==fuckingOptions.gsort then
						DarkAngelGUI.Guild.gsortFrame[i].fs:SetTextColor(0.2,1,1,1)
					else
						DarkAngelGUI.Guild.gsortFrame[i].fs:SetTextColor(0.85,1,1,1)
					end
				end	
			end
			
			DarkAngelGUI.Guild.gsortbtn,DarkAngelGUI.Guild.gsortFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild,L["sort"],12,32,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",215,-10},164,93,"TOP")
			
			for i,criteria in pairs(additgsort) do
				DarkAngelGUI.Guild.gsortFrame[i]=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.gsortFrame,{"TOPLEFT", DarkAngelGUI.Guild.gsortFrame, "TOPLEFT", (i>8 and 70.5 or 1),10-11*(i>8 and i-8 or i)},10,(i>8 and 92 or 68),criteria[1],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), criteria[2] or 9, "OUTLINE"},function(self) 
				
					fuckingOptions.gsort=self.fs:GetText()
					DA.GetGuildData(1)
					DA.GuildSetAllLines()
					re_highlight_gsort()
				end,criteria[3] or nil,nil,'center')
			end
			
			re_highlight_gsort()
			
			
			DarkAngelGUI.Guild.gsortFrame.onlineFirst=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.gsortFrame,{"CENTER",DarkAngelGUI.Guild.gsortFrame,"TOPLEFT",90,-61},14,14,L['online'],function(self) fuckingOptions.onlineFirst=(self:GetChecked() or false) DA.GetGuildData();DA.GuildSetAllLines() end,{'fuckingOptions','onlineFirst'},'desc_onlinefirst')
			DarkAngelGUI.Guild.gsortFrame.reverseSort=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.gsortFrame,{"CENTER",DarkAngelGUI.Guild.gsortFrame,"TOPLEFT",90,-72},14,14,L['reverse'],function(self) fuckingOptions.reverseSort=(self:GetChecked() or false) DA.GetGuildData();DA.GuildSetAllLines() end,{'fuckingOptions','reverseSort'},'desc_reverse')
			
			
			
		end
		
		-- copy
		do
			DarkAngelGUI.Guild.copybtn,DarkAngelGUI.Guild.copyFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild,L["copy"],12,35,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",40,-6},80,175,"TOP",nil,function() copyFrame_Update() end)
			
			local search_patterns={
				{"name", "plname"},
				{"lvl", "lvl"},
				{"note", "note"},
				{"off.note", "officernote"},
				{"rank", "rankTxt"},
				{"class", "class"},
				{"online", "online"}
			}
			for i,criteria in pairs(search_patterns) do
				DarkAngelGUI.Guild.copyFrame[criteria[1]]=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.copyFrame,{"TOPLEFT", DarkAngelGUI.Guild.copyFrame, "TOPLEFT", 10,5-12*i},15,15,criteria[1],function() copyFrame_Update() end)
				if i==1 or i==3 or i==4 or i==6 then
					DarkAngelGUI.Guild.copyFrame[criteria[1]]:SetChecked(true)
				end
			end
			--separator
			do
				DarkAngelGUI.Guild.copyFrame.separator=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.copyFrame,{"LEFT", DarkAngelGUI.Guild.copyFrame, "TOPLEFT", 10, -115},{55,15},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 10},
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
						fuckingOptions.gcopyfrsep=self:GetText()
						copyFrame_Update()
					end
				)
				DarkAngelGUI.Guild.copyFrame.separator:HighlightText()
				DarkAngelGUI.Guild.copyFrame.separator:SetText(fuckingOptions.gcopyfrsep)
				DA.FontCreater(nil,L['separator'],{"LEFT",DarkAngelGUI.Guild.copyFrame.separator,"LEFT",-5,13},DarkAngelGUI.Guild.copyFrame.separator,15,170,{UIDarkAngelFontConsolas:GetFont(), 8},'left',{0.85,1,1,0.4})
			end
			--numlines
			do
				DarkAngelGUI.Guild.copyFrame.numlines=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.copyFrame,{"LEFT", DarkAngelGUI.Guild.copyFrame, "TOPLEFT", 10, -155},{55,15},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 10},
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
						if tonumber(self:GetText()) and tonumber(self:GetText())>0 then 
							fuckingOptions.gcopyfrnumlines=self:GetText()
							copyFrame_Update()
						end
					end,1
				)
				DarkAngelGUI.Guild.copyFrame.numlines:SetText(fuckingOptions.gcopyfrnumlines)
				
				DarkAngelGUI.Guild.copyFrame.selected=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.copyFrame,{"TOPLEFT", DarkAngelGUI.Guild.copyFrame, "TOPLEFT", 10,-132},15,15,"selected",function(self) 
				if self:GetChecked() then DarkAngelGUI.Guild.copyFrame.numlines:EnableMouse(false);DarkAngelGUI.Guild.copyFrame.numlines:SetAlpha(0.6) else DarkAngelGUI.Guild.copyFrame.numlines:EnableMouse(true);DarkAngelGUI.Guild.copyFrame.numlines:SetAlpha(1) end copyFrame_Update() end)
				DA.FontCreater(nil,L['lines to print'],{"LEFT",DarkAngelGUI.Guild.copyFrame.selected,"LEFT",-5,9},DarkAngelGUI.Guild.copyFrame.selected,15,170,{UIDarkAngelFontConsolas:GetFont(), 8},'left',{0.85,1,1,0.4})
				
				if next(DA.Players_Selected) then DarkAngelGUI.Guild.copyFrame.selected:SetChecked(true) end
			end
			
			local CopyFrameAdditional=DA.FrameCreater(nil,DarkAngelGUI.Guild.copyFrame,499,175,{"BOTTOMLEFT",DarkAngelGUI.Guild.copyFrame,"BOTTOMRIGHT"})
			CopyFrameAdditional:Show()
			DA.CloseButtonCreater(nil,DarkAngelGUI.Guild.copyFrame,{"TOPRIGHT", CopyFrameAdditional, "TOPRIGHT", -5,-5},10,10,'x')
			
			DA.ScrollBarCreater("DarkAngelGuild_CopyFrame",CopyFrameAdditional,{CopyFrameAdditional.width-5, CopyFrameAdditional.height-30},{"TOPLEFT", 5, -20},1)
			local copyfr_Scrolled=DarkAngelGuild_CopyFrame.scrollchild

			CopyFrameAdditional.EB=DA.EditBoxCreater(nil,copyfr_Scrolled,{"TOPLEFT", copyfr_Scrolled, "TOPLEFT", 5, -2},{462,390},nil,true,false,{UIDarkAngelFontConsolas:GetFont(), 8},
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
			
			copyFrame_Update = function()
				local unlocked
				local search={}
				for i,c in pairs(search_patterns) do
					if DarkAngelGUI.Guild.copyFrame[c[1]]:GetChecked() then
						unlocked=true
						search[c[2]]=true
					end
				end

				local editbox=CopyFrameAdditional.EB
				
				if not unlocked then DA.Print(L['select at least one criteria']) return end
				
				local separator=DarkAngelGUI.Guild.copyFrame.separator:GetText()
				if not separator then 
					DA.Print("separating data with single spacing")
					separator=" "
				end
				
				local doing_by_selection = DarkAngelGUI.Guild.copyFrame.selected:GetChecked()
				

				if not tonumber(fuckingOptions.gcopyfrnumlines) or tonumber(fuckingOptions.gcopyfrnumlines)<=0 then 
					fuckingOptions.gcopyfrnumlines=1000
					DarkAngelGUI.Guild.copyFrame.numlines:SetText(fuckingOptions.gcopyfrnumlines)
				end
				
				local result = ""
				
				if doing_by_selection then
					for _,player in ipairs(DA_G_Processed) do
						if DA.Players_Selected[player.plname] then
							-- if player.isLocal then
							local line=""
							for _,patt in ipairs(search_patterns) do
								if search[patt[2]] and player[patt[2]] then
									line=line .. player[patt[2]] .. "|r" .. separator
								end
							end
							if line~="" then
								result = result .. line..'\n'
							end
						end
					end
					
				else
					for i=1,tonumber(fuckingOptions.gcopyfrnumlines) do
						local player = DA_G_Processed[i]
						if player then
							-- if player.isLocal then
							local line=""
							for _,patt in ipairs(search_patterns) do
								if search[patt[2]] and player[patt[2]] then
									line=line .. player[patt[2]] .. "|r" .. separator
								end
							end
							if line~="" then
								result = result .. line..'\n'
							end
						end
					end
					
				end
				
				editbox:SetText(result)
				
			end
		
		end
		
		DA.CheckBtnCreater(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",253,-25},10,10,nil,function(self) fuckingOptions_g[DA_CurrentGuild].evaluateoffnote=(self:GetChecked() or false) DA.GetGuildData();DA.GuildSetAllLines(); if DarkAngelGUI.Guild.copyFrame:IsShown() then copyFrame_Update() end end,{'fuckingOptions_g','evaluateoffnote','DA_CurrentGuild'},'desc_evaluate')
		
		-- clear
		DA.CreateFFGButton2(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",265,-10},12,50,L['clear'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
			DarkAngelGUI.Guild.precmatch:SetChecked(1);fuckingOptions.precisematchsearch=1
			DarkAngelGUI.Guild.showlocals:SetChecked(false);fuckingOptions.showlocals=false
			DarkAngelGUI.Guild.EB1:SetText("")
			DarkAngelGUI.Guild.EB1:SetFocus();DarkAngelGUI.Guild.EB1:ClearFocus();
			DarkAngelGUI.Guild.EB2:SetText("")
			DarkAngelGUI.Guild.EB3:SetText("")
			DarkAngelGUI.Guild.EB4:SetText("")
			DarkAngelGUI.Guild.EB5:SetText("")
			DarkAngelGUI.Guild.EB6:SetText("")
			table.wipe(DarkAngelGUI.Guild.classTbl)
			update_class_srch()
			DarkAngelGUI.Guild.classFrame:Hide()
			DA.GetGuildData();DA.SelectGuildMember(nil,true)
			DA.GuildSetAllLines()
			
		end)
		
		-- guild control
		do
			DarkAngelGUI.Guild.GC=DA.FrameCreater(nil,UIParent,525,300,{"TOPRIGHT",DarkAngelGUI,"TOPLEFT",-2,0},{0.03, 0.04, 0.07, 0.65})
			DA.CreateScaler(DarkAngelGUI.Guild.GC,0.6,2,{'fuckingOptions','GCScale'})
			local gc=DarkAngelGUI.Guild.GC
				gc:RegisterForDrag("LeftButton")
				gc:SetScript("OnDragStart", function(self) self:StartMoving() end)
				gc:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end) 
		
			gc.run_Bulk={}
			DA.CloseButtonCreater(nil,gc,{"TOPRIGHT", gc, "TOPRIGHT", -5,-5},10,10,'x')
			
			DA.ScrollBarCreater("DA_GC_ch",gc,{gc.width+5, gc.height-58},{"TOPLEFT", gc, "TOPLEFT", 0, -55},1)
			
			local gc_Scrolled=DA_GC_ch.scrollchild
			
			local function run_setchecked_ranks()
				if gc.run.saveranks then
					gc.run.saveranks:SetChecked(true)
					gc.run.run:Enable()
				end
			end
			local function run_setchecked_addranks()
				if gc.run.matchranks then
					gc.run.matchranks:SetChecked(true)
					gc.run.run:Enable()
				end
			end
			local function run_setchecked_players()
				if gc.run.moveplayers and gc.run.lockranks then
					gc.run.moveplayers:SetChecked(true)
					-- gc.run.lockranks:SetChecked(true)
					gc.run.run:Enable()
				end
			end
			
			local function set_text_size(frame)
				if frame:GetNumLetters()>10 then
					frame:SetFont(UIDarkAngelFontConsolas:GetFont(), 5)
				elseif frame:GetNumLetters()>9 then
					frame:SetFont(UIDarkAngelFontConsolas:GetFont(), 5.5)
				elseif frame:GetNumLetters()>8 then
					frame:SetFont(UIDarkAngelFontConsolas:GetFont(), 6)
				elseif frame:GetNumLetters()>7 then
					frame:SetFont(UIDarkAngelFontConsolas:GetFont(), 7)
				elseif frame:GetNumLetters()>6 then
					frame:SetFont(UIDarkAngelFontConsolas:GetFont(), 8)
				else
					frame:SetFont(UIDarkAngelFontConsolas:GetFont(), 8.5)
				end
			end
			
			gc.players_roster={}
			gc.players_Moved_roster={
			{moved=nil,combined=nil},
			{moved=nil,combined=nil},
			{moved=nil,combined=nil},
			{moved=nil,combined=nil},
			{moved=nil,combined=nil},
			{moved=nil,combined=nil},
			{moved=nil,combined=nil},
			{moved=nil,combined=nil},
			{moved=nil,combined=nil},
			{moved=nil,combined=nil}}
			
			local function get_players()	
				gc.players_roster={}
				gc.players_Moved_roster={
				{moved=nil,combined=nil},
				{moved=nil,combined=nil},
				{moved=nil,combined=nil},
				{moved=nil,combined=nil},
				{moved=nil,combined=nil},
				{moved=nil,combined=nil},
				{moved=nil,combined=nil},
				{moved=nil,combined=nil},
				{moved=nil,combined=nil},
				{moved=nil,combined=nil}}
				for k=1,DA.GetNumGMembers() do
					local _, _, rankIndex, _, _, _, _, _, _, _, _, _, _, _, _, _ = GetGuildRosterInfo(k);
					if rankIndex then
						if not gc.players_roster[rankIndex+1] then
							gc.players_roster[rankIndex+1]=1
						else
							gc.players_roster[rankIndex+1]=gc.players_roster[rankIndex+1]+1
						end
					end
				end
			end
			
			local function get_players_text(ID)
				local result
				if gc.players_Moved_roster[ID].combined and gc.players_Moved_roster[ID].moved then
					local str="["
					for s in pairs(gc.players_Moved_roster[ID].combined) do
						if str=="[" then
							str="[|cffff99ff"..tostring(tonumber(s)-1).."|r"
						else
							str=str..",|cffff99ff"..tostring(tonumber(s)-1).."|r"
						end
					end
					if str=="[" then
						result = "[moved]"
					else
						result = str.."]"
					end
					
				elseif gc.players_Moved_roster[ID].moved then
					result = "[moved]"
				elseif gc.players_Moved_roster[ID].combined then
					local str="["
					for s in pairs(gc.players_Moved_roster[ID].combined) do
						if str=="[" then
							str="[|cffff99ff"..tostring(tonumber(s)-1).."|r"
						else
							str=str..",|cffff99ff"..tostring(tonumber(s)-1).."|r"
						end
					end
					
					if gc.players_roster[ID] and gc.players_roster[ID]>0 and str=="[" then
						result = gc.players_roster[ID]
					elseif gc.players_roster[ID] and gc.players_roster[ID]>0 then
						result = gc.players_roster[ID].."+"..str.."]"
					elseif str=="[" then
						result = "0"
					else
						result = str.."]"
					end
				else
					result = gc.players_roster[ID] or "0"
				end
				
				if result=="0" or gc.ranksroster[ID] then
					gc['d'..ID..'pplcount']:SetTextColor(0.75,0.95,0.95,0.95)
				else
					gc['d'..ID..'pplcount']:SetTextColor(0.9,0.5,0.5,1)
				end
				
				return result
				
			end
			
			local function check_consists_pl(ID)
				if get_players_text(ID)~="0" then 
					return true
				end
			end
			
			local function reRender_gc()
			
				local current_guild_ranks=GuildControlGetNumRanks()
				
				for i=1,10 do
					gc['d'..i..'pplcount']:SetText(get_players_text(i))
					
					if gc.ranksroster[i] then
						gc['d'..i..'name']:SetText(gc.ranksroster[i].name or "noname")
						set_text_size(gc['d'..i..'name'])
						gc['d'..i..'name']:Show()
						
						
						if i>4 then
							gc.createnewrank:SetPoint("LEFT",gc['d'..i ..'name'],"RIGHT",2,0)
						end
						
						
						if i==1 then
						else
							gc['d'..i..'pplcount']:Show()
							gc['d'..i..'rankID']:Show()
							gc['d'..i..'mover']:Show()
							
							if i>current_guild_ranks then
								gc['d'..i..'name'].t:SetTexture(0.176, 0.586, 0.356, 1)
							else
								gc['d'..i..'name'].t:SetTexture(0.176, 0.286, 0.356, 1)
							end
							
							gc['d'..i..'gwithraw']:Show()
							for pos,tag in ipairs({'guildchat_listen','guildchat_speak','officerchat_listen','officerchat_speak','promote','demote','invite_member','remove_member','set_motd','edit_public_note','view_officer_note','edit_officer_note','modify_guild_info','withdraw_repair','withdraw_gold','create_guild_event'}) do
								
								if gc.ranksroster[i][tag] then
									gc['d'..i..tag]:SetChecked(true)
								else
									gc['d'..i..tag]:SetChecked(false)
								end
							end
							
							if gc.ranksroster[i].gwithraw and tonumber(gc.ranksroster[i].gwithraw)==0 then
								gc['d'..i..'gwithraw']:SetText("")
							else
								gc['d'..i..'gwithraw']:SetText(gc.ranksroster[i].gwithraw or '')
							end
									
							local lasttab=GetNumGuildBankTabs()
							
							for b=1,6 do
								if b<=lasttab then
									gc['db'..i..'w'..b]:SetChecked(gc.ranksroster[i].bankpermissions[b].canView)
									gc['db'..i..'d'..b]:SetChecked(gc.ranksroster[i].bankpermissions[b].canDeposit)
									gc['db'..i..'e'..b]:SetChecked(gc.ranksroster[i].bankpermissions[b].canEditInfo)
									if gc.ranksroster[i].bankpermissions[b].stacksPerDay and tonumber(gc.ranksroster[i].bankpermissions[b].stacksPerDay)==0 then
										gc['db'..i..'s'..b]:SetText("")
									else
										gc['db'..i..'s'..b]:SetText(gc.ranksroster[i].bankpermissions[b].stacksPerDay or '')
									end
									
									gc['db'..i..'w'..b]:Show()
									gc['db'..i..'d'..b]:Show()
									gc['db'..i..'e'..b]:Show()
									gc['db'..i..'s'..b]:Show()
								else
									gc['db'..i..'w'..b]:Hide()
									gc['db'..i..'d'..b]:Hide()
									gc['db'..i..'e'..b]:Hide()
									gc['db'..i..'s'..b]:Hide()
								end
							end
							
						end
					elseif i~=1 then
						
						gc['d'..i..'name']:Hide()
						gc['d'..i..'gwithraw']:Hide()
						gc['d'..i..'pplcount']:Hide()
						gc['d'..i..'rankID']:Hide()
						gc['d'..i..'mover']:Hide()
					end
				end
				
				if #gc.ranksroster<10 then
					gc.createnewrank:Show()
				else
					gc.createnewrank:Hide()
				end
				
				
				for i=10,6,-1 do
					-- if gc['d'..i..'name']:IsShown() or check_consists_pl(i) then
						-- gc['d'..i..'pplcount']:Show()
						-- gc['d'..i..'rankID']:Show()
						-- gc['d'..i..'mover']:Show()
						-- print('show',i)
					-- else
						-- gc['d'..i..'pplcount']:Hide()
						-- gc['d'..i..'rankID']:Hide()
						-- gc['d'..i..'mover']:Hide()
						-- print('hide',i)
					-- end
						
					if i==6 or gc['d'..i..'name']:IsShown() or check_consists_pl(i) then
						gc:SetSize(63+46*i,300)
						DA_GC_ch:SetSize(68+46*i,242)
						break
					end
				end
				
			end
			
			local function players_move(initRank,newRank)
				
				for i=2,10 do
					if gc.players_Moved_roster[i].combined and gc.players_Moved_roster[i].combined[initRank] then
						gc.players_Moved_roster[i].combined[initRank]=nil
					end
				end
				
				if initRank==newRank then
					gc.players_Moved_roster[initRank].moved=false
					
				elseif not(gc.players_roster[initRank] and gc.players_roster[initRank]>0) then
				
				else
					gc.players_Moved_roster[initRank].moved=newRank
					
					if not gc.players_Moved_roster[newRank].combined then
						gc.players_Moved_roster[newRank].combined={}
					end
					
					gc.players_Moved_roster[newRank].combined[initRank]=true
					
				end
				
				reRender_gc()
				run_setchecked_players()
			end
			
			local function get_from_guild()
			gc.ranksroster={}
				
				for i=1,GuildControlGetNumRanks() do
					GuildControlSetRank(i)
					
					local guildchat_listen, guildchat_speak, officerchat_listen, officerchat_speak, promote, demote, invite_member, remove_member, set_motd, edit_public_note, view_officer_note, edit_officer_note, modify_guild_info, _, withdraw_repair, withdraw_gold, create_guild_event = GuildControlGetRankFlags()
					local bankpermissions={}
					local gwithraw=GetGuildBankWithdrawLimit()
						
					if i==1 then
						gc.ranksroster[i]={
							name=GuildControlGetRankName(i)
						}
						
					else
						for b=1,GetNumGuildBankTabs() do
							local canViewr, canDepositr, canEditInfor, stacksPerDayr = GetGuildBankTabPermissions(b)
							-- print(i,b, canViewr, canDepositr, canEditInfor, stacksPerDayr)
							bankpermissions[b]={
								canView=canViewr or false,
								canDeposit=canDepositr or false,
								canEditInfo=canEditInfor or false,
								stacksPerDay=stacksPerDayr or false
							}
						end	
						gc.ranksroster[i]={
							name=GuildControlGetRankName(i),
							guildchat_listen=guildchat_listen or false,
							guildchat_speak=guildchat_speak or false,
							officerchat_listen=officerchat_listen or false,
							officerchat_speak=officerchat_speak or false,
							promote=promote or false,
							demote=demote or false,
							invite_member=invite_member or false,
							remove_member=remove_member or false,
							set_motd=set_motd or false,
							edit_public_note=edit_public_note or false,
							view_officer_note=view_officer_note or false,
							edit_officer_note=edit_officer_note or false,
							modify_guild_info=modify_guild_info or false,
							withdraw_repair=withdraw_repair or false,
							withdraw_gold=withdraw_gold or false,
							create_guild_event=create_guild_event or false,
							gwithraw=gwithraw or false,
							bankpermissions=bankpermissions
						}
					end
				end
				
				gc.ranksOnClickMenu:Hide()
				get_players()
				reRender_gc()
			end
			
			local function rank_move(fromIndex,toIndex)
				local subtable = table.remove(gc.ranksroster, fromIndex)
				table.insert(gc.ranksroster, toIndex, subtable)
				
				reRender_gc()
				run_setchecked_ranks()
			end
			

			local function show_push_frames()
				gc['db2s1']:SetFocus()
				gc['db2s1']:ClearFocus()
				for i=2,10 do
					if gc['d'..i..'name']:IsShown() then
						gc['d'..i..'pos_frm']:Show()
					end
				end
			end
			
			local function hide_push_frames()
				for i=2,10 do
					if gc['d'..i..'pos_frm'] then
						gc['d'..i..'pos_frm']:Hide()
					end
				end
			end
			
			local function create_new_rank(position)
				if #gc.ranksroster<10 then
					if position then
						if gc.ranksroster[position] then
							tinsert(gc.ranksroster, position, DA.DeepCopy(pattern_empty_rank))
						else
							gc.ranksroster[position]=DA.DeepCopy(pattern_empty_rank)
						end
					else
						gc.ranksOnClickMenu:Hide()
						tinsert(gc.ranksroster,DA.DeepCopy(pattern_empty_rank))
					end
					
					reRender_gc()
					run_setchecked_ranks()
					run_setchecked_addranks()
				else
					print('error 2031: cant add rank 11')
					return
				end
			end
			
			local function create_rank_duplicate(position)
				if #gc.ranksroster<10 then
					tinsert(gc.ranksroster,position,DA.DeepCopy(gc.ranksroster[position]))
					
					reRender_gc()
					run_setchecked_ranks()
					run_setchecked_addranks()
				else
					print('error 2046: cant add rank 11')
					return
				end
			end
			
			local function clear_rank(position)
				gc.ranksroster[position]=nil
				gc.ranksroster[position]=DA.DeepCopy(pattern_empty_rank)
				
				reRender_gc()
				run_setchecked_ranks()
			end
			
			local function delete_rank(position)
				if #gc.ranksroster>5 then
					table.remove(gc.ranksroster,position)
					
					reRender_gc()
					run_setchecked_ranks()
					run_setchecked_addranks()
				else
					print('error 2064: cant delete rank when less 6 ranks')
					return
				end
			end
			
			
			
			gc.restbtn=DA.CreateFFGButton2(nil,gc,{"CENTER",gc,"TOPLEFT",17,-34},12,30,'reset','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9},function()
				get_from_guild()
				if gc.run.saveranks and gc.run.matchranks then
					gc.run.saveranks:SetChecked(false)
					gc.run.matchranks:SetChecked(false)
				end
				if gc.run.moveplayers and gc.run.lockranks then
					gc.run.moveplayers:SetChecked(false)
					gc.run.lockranks:SetChecked(false)
				end
				gc.run.run:Disable()
			end)
				
			
			DarkAngelGUI.Guild.OpenGC_Btn=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",425,-10},12,25,'gc','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
				if gc:IsShown() then
					gc:Hide()
				else
					if not gc.ranksroster then 
						get_from_guild()
					end
					gc:Show()
				end
			end)
				
			gc.ranksOnClickMenu=DA.FrameCreater(nil,gc,280,42,{"TOPRIGHT",gc,"TOPRIGHT",0,0})
			gc.ranksOnClickMenu:Hide()
			-- gc.ranksOnClickMenu:SetFrameLevel(100)
			gc.ranksOnClickMenu.t:SetTexture(0.03, 0.04, 0.07, 0.8)
			
			gc.ranksOnClickMenu.duplicate=DA.CreateFFGButton2(nil,gc.ranksOnClickMenu,{"left",gc.ranksOnClickMenu,"topleft",1,-6},10,gc.ranksOnClickMenu.width-2,L["create duplicate rank, shift rest right"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function() end,nil,nil,'left')
			gc.ranksOnClickMenu.duplicate:GetFontString():SetTextColor(0.5,0.8,0.9,1)
			gc.ranksOnClickMenu.new=DA.CreateFFGButton2(nil,gc.ranksOnClickMenu,{"left",gc.ranksOnClickMenu,"topleft",1,-16},10,gc.ranksOnClickMenu.width-2,L["create new rank here, shift rest right"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function() end,nil,nil,'left')
			gc.ranksOnClickMenu.new:GetFontString():SetTextColor(0.5,0.8,0.9,1)
			gc.ranksOnClickMenu.clear=DA.CreateFFGButton2(nil,gc.ranksOnClickMenu,{"left",gc.ranksOnClickMenu,"topleft",1,-26},10,gc.ranksOnClickMenu.width-2,L["clear permissions"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function() end,nil,nil,'left')
			gc.ranksOnClickMenu.clear:GetFontString():SetTextColor(0.5,0.8,0.9,1)
			gc.ranksOnClickMenu.delete=DA.CreateFFGButton2(nil,gc.ranksOnClickMenu,{"left",gc.ranksOnClickMenu,"topleft",1,-36},10,gc.ranksOnClickMenu.width-2,L["delete rank, shift rest left"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function() end,nil,nil,'left')
			gc.ranksOnClickMenu.delete:GetFontString():SetTextColor(0.9,0.5,0.5,1)
			
			local function setupButton(button, isEnabled, onClick, r, g, b, a)
				if isEnabled then
					button:SetScript("OnClick", onClick)
					button:Enable()
					button:GetFontString():SetTextColor(r, g, b, a)
				else
					button:Disable()
					button:GetFontString():SetTextColor(r, g, b, a * 0.5)
				end
			end
			gc.ranksOnClickMenu.ShowOnSelf=function(targetframe,ID)
				local isRankNameShown = gc['d' .. ID .. 'name']:IsShown()
				local canCreateNewRank = #gc.ranksroster < 10
				local canDeleteRank = isRankNameShown and #gc.ranksroster > 5

				if canCreateNewRank and gc['d' .. ID-1 .. 'name']:IsShown() then
					setupButton(gc.ranksOnClickMenu.new, true, function(self)
						create_new_rank(ID)
						gc.ranksOnClickMenu:Hide()
					end, 0.5, 0.8, 0.9, 1)
				else
					setupButton(gc.ranksOnClickMenu.new, false, nil, 0.5, 0.8, 0.9, 1)
				end

				setupButton(gc.ranksOnClickMenu.duplicate, canCreateNewRank and isRankNameShown, function(self)
					create_rank_duplicate(ID)
					gc.ranksOnClickMenu:Hide()
				end, 0.5, 0.8, 0.9, 1)

				setupButton(gc.ranksOnClickMenu.clear, isRankNameShown, function(self)
					clear_rank(ID)
					gc.ranksOnClickMenu:Hide()
				end, 0.5, 0.8, 0.9, 1)

				setupButton(gc.ranksOnClickMenu.delete, canDeleteRank, function(self)
					delete_rank(ID)
					gc.ranksOnClickMenu:Hide()
				end, 0.9, 0.5, 0.5, 1)
				
				gc.ranksOnClickMenu:SetPoint("TOPRIGHT",targetframe,'center',-5,-5)
				gc.ranksOnClickMenu:Show()
			end

			
			for i=1,10 do
				--name
				gc['d'..i..'name']=DA.EditBoxCreater(nil,gc,{"CENTER",gc,"TOPLEFT",23+46*i,-45},{45,12},"",false,false,{UIDarkAngelFontConsolas:GetFont(), 4},
					function(self) self.t:SetBlendMode("ADD") ;self:ClearFocus(); self.focusgained=nil;set_text_size(self) end,
					function(self) self.t:SetBlendMode("ADD") ;self:ClearFocus(); self.focusgained=nil;set_text_size(self) end, --enter here
					function(self) self.t:SetBlendMode("ADD") ;self:ClearFocus(); self.focusgained=nil;set_text_size(self) end,
					function(self) 	
						if self:GetParent():IsShown() then
							self.t:SetBlendMode('blend');
							self.focusgained=1
						end
					end,
					function(self) if self.focusgained then gc.ranksroster[i].name=self:GetText():gsub("%s",''); run_setchecked_ranks() end end)
					
				
				--Players
				gc['d'..i..'pplcount']=DA.FontCreater(nil,"0",{"center",gc,"topleft",22.5+46*i,-23},gc,15,50,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"center",{0.75,0.95,0.95,0.95})
				
				-- ID
				gc['d'..i..'rankID']=DA.FontCreater(nil,"["..i-1 .."]",{"center",gc['d'..i..'name'],"center",-1,32},gc,15,50,{UIDarkAngelFontConsolas:GetFont(), 6, "OUTLINE"},"center",{1,0.6,1,1})
				
				if i==1 then
					DarkAngelGUI.Guild.GC.fir=DA.FontCreater(nil,L['rank'],{"RIGHT",gc,"TOPLEFT",61,-13},gc,15,150,{UIDarkAngelFontConsolas:GetFont(), 6, "OUTLINE"},"right",{0.75,0.9,0.9,0.9})
					DarkAngelGUI.Guild.GC.fir2=DA.FontCreater(nil,L['players'],{"RIGHT",gc,"TOPLEFT",61,-23},gc,15,150,{UIDarkAngelFontConsolas:GetFont(), 6, "OUTLINE"},"right",{0.75,0.9,0.9,0.9})
					DarkAngelGUI.Guild.GC.fir3=DA.FontCreater(nil,L['mover'],{"RIGHT",gc,"TOPLEFT",88,-33},gc,15,150,{UIDarkAngelFontConsolas:GetFont(), 6, "OUTLINE"},"right",{0.75,0.9,0.9,0.9})
					
					for pos,tag in ipairs({'guildchat_listen','guildchat_speak','officerchat_listen','officerchat_speak','promote','demote','invite_member','remove_member','set_motd','edit_public_note','view_officer_note','edit_officer_note','modify_guild_info','withdraw_repair','withdraw_gold','create_guild_event'}) do
						DA.FontCreater(nil,L[tag],{"RIGHT",gc_Scrolled,"TOPLEFT",95,3-11*pos},gc_Scrolled,15,150,{UIDarkAngelFontConsolas:GetFont(), 6, "OUTLINE"},"right",{0.75,0.9,0.9,0.9})
					end
					
				else
					
					--mover
					do
						gc['d'..i..'mover']=DA.CreateFFGButton2(nil,gc,{"CENTER",gc,"TOPLEFT",22+46*i,-33},8,13,"<>",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',{UIDarkAngelFontConsolas:GetFont(), 9},function(self,mouse) 
							if mouse=="RightButton" then
								DA.myHideTooltip()
								DarkAngel_minimapBtn.menu:Hide(); 
								
								DarkAngelGUI:Show()
								_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',true)
								_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',false)
								
								DarkAngelGUI.Guild.offliners:SetChecked(1);fuckingOptions.showoffl=1
								DarkAngelGUI.Guild.onliners:SetChecked(1);fuckingOptions.showonl=1
								DarkAngelGUI.Guild.precmatch:SetChecked(1);fuckingOptions.precisematchsearch=1
								DarkAngelGUI.Guild.showlocals:SetChecked(false);fuckingOptions.showlocals=false
								DarkAngelGUI.Guild.EB1:SetText("")
								DarkAngelGUI.Guild.EB2:SetText("")
								DarkAngelGUI.Guild.EB3:SetText("")
								DarkAngelGUI.Guild.EB4:SetText("")
								DarkAngelGUI.Guild.EB5:SetText(i-1)
								DarkAngelGUI.Guild.EB6:SetText("")
								DA.GetGuildData();DA.GuildSetAllLines()
								return
							end
							
							if gc.ranksOnClickMenu:IsShown() then
								gc.ranksOnClickMenu:Hide()
							else
								gc.ranksOnClickMenu.ShowOnSelf(self,i)
								
							end
						end)
						
						gc['d'..i..'pos_frm']=DA.FrameCreater(nil,gc['d'..i..'name'],25,18,{"BOTTOMRIGHT",gc['d'..i..'mover'],"BOTTOMLEFT",-2,0})
						gc['d'..i..'pos_frm'].t:SetTexture(0.7, 1, 1, 0.6)
						gc['d'..i..'pos_frm'].t:SetBlendMode('add')
						DA.FontCreater(nil,">>>",{"RIGHT",gc['d'..i..'pos_frm'],"RIGHT",-2,0},gc['d'..i..'pos_frm'],15,50,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"right",{0.75,0.95,0.95,0.75})
						
						gc['d'..i..'mover'].storedpoint={"center",gc['d'..i..'name'],"center",0,12}
						gc['d'..i..'mover'].storedrank=i
						gc['d'..i..'mover']:EnableMouse(true)
						gc['d'..i..'mover']:EnableMouseWheel(true)
						gc['d'..i..'mover']:SetMovable(true)
						gc['d'..i..'mover']:SetResizable(enable)
						gc['d'..i..'mover']:SetMinResize(100, 100)
						gc['d'..i..'mover']:RegisterForDrag("LeftButton")
						gc['d'..i..'mover']:RegisterForClicks("AnyUp")
						gc['d'..i..'mover']:SetScript("OnEnter", function(self)
							if not self.ismoving then
								DA.myShowTooltip(self,L['DESCr-GCmover'])
							end
						end)
						gc['d'..i..'mover']:SetScript("OnLeave", function()
							DA.myHideTooltip()
						end)
						gc['d'..i..'mover']:SetScript("OnDragStart", function(self,...) self.ismoving=1;gc.ranksOnClickMenu:Hide();gc['d'..i..'mover'].StartMoving(self,...);show_push_frames();gc['d'..i..'pos_frm']:Hide();DA.myHideTooltip() end)
						gc['d'..i..'mover']:SetScript("OnDragStop", function(self) 
							self:StopMovingOrSizing(); 
							self.ismoving=false
							local found
							for rank=2,10 do
								if gc['d'..rank..'pos_frm']:IsMouseOver() and gc['d'..rank..'pos_frm']:IsVisible() then
									
									if not IsShiftKeyDown() and not IsControlKeyDown() then
										if gc['d'..i..'name']:IsShown() then
											-- DA.Print('moving rank '..self.storedrank-1 .." -> "..rank-1)
											if rank~=self.storedrank and gc.ranksroster[self.storedrank] then
												rank_move(self.storedrank,rank)
											end
										else
											DA.Print("there is no rank here, you can move only its players")
										end
									elseif IsShiftKeyDown() and not IsControlKeyDown() then
										
										
										-- DA.Print('moving players '..self.storedrank-1 .." -> "..rank-1)
										players_move(self.storedrank,rank)
									elseif not IsShiftKeyDown() and IsControlKeyDown() then
										
										if gc['d'..i..'name']:IsShown() then
											-- DA.Print('moving rank+players '..self.storedrank-1 .." -> "..rank-1)
											if rank~=self.storedrank and gc.ranksroster[self.storedrank] then
												rank_move(self.storedrank,rank)
												players_move(self.storedrank,rank)
											end
										else
											-- DA.Print('moving players '..self.storedrank-1 .." -> "..rank-1)
											players_move(self.storedrank,rank)
										end
									end
									found=true
									break
									
								end
							end
							if not found then
								if not IsShiftKeyDown() then
									if gc.players_Moved_roster[i].moved then
										-- DA.Print('rank '..i-1 .." moving players cleared")
										players_move(self.storedrank,self.storedrank)
									end
								end
							end
							self:ClearAllPoints()
							self:SetPoint(unpack(self.storedpoint)) 
							hide_push_frames()
						end) 
					end
					
					gc['d'..i..'gwithraw']=DA.EditBoxCreater(nil,gc_Scrolled,{"CENTER",gc_Scrolled,"TOPLEFT",24+46*i,-192},{44,12},"",false,false,{UIDarkAngelFontConsolas:GetFont(), 7,'outline'},
					function(self)
						if not tonumber(self:GetText()) or (tonumber(self:GetText())<0) then
							self:SetText("")
						elseif tonumber(self:GetText())>200000 then
							self:SetText("200000")
						end
						self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
						gc.ranksroster[i].gwithraw=self:GetText()
					end,
					function(self)
						if not tonumber(self:GetText()) or (tonumber(self:GetText())<0) then
							self:SetText("")
						elseif tonumber(self:GetText())>200000 then
							self:SetText("200000")
						end
						self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
						gc.ranksroster[i].gwithraw=self:GetText()
					end, --enter here
					function(self)
						if not tonumber(self:GetText()) or (tonumber(self:GetText())<0) then
							self:SetText("")
						elseif tonumber(self:GetText())>200000 then
							self:SetText("200000")
						end
						self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
						gc.ranksroster[i].gwithraw=self:GetText()
					end,
					function(self) 	
						self.t:SetBlendMode("BLEND");self.focusgained=1; 
					end,
					function(self) if self.focusgained then run_setchecked_ranks() end end,true)
				
					gc['d'..i..'gwithraw']:SetTextColor(0.9,0.9,0.2,1)
					if i==2 then
						DA.FontCreater(nil,L['gwithraw'],{"RIGHT",gc['d'..i..'gwithraw'],"LEFT",-7,0},gc['d'..i..'gwithraw'],15,150,{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"},"right",{0.75,0.9,0.9,0.9})
					end
					
					for pos,tag in ipairs({'guildchat_listen','guildchat_speak','officerchat_listen','officerchat_speak','promote','demote','invite_member','remove_member','set_motd','edit_public_note','view_officer_note','edit_officer_note','modify_guild_info','withdraw_repair','withdraw_gold','create_guild_event'}) do
						gc['d'..i..tag]=DA.CheckBtnCreater(nil,gc['d'..i..'gwithraw'],{"CENTER",gc['d'..i..'gwithraw'],"CENTER",0,195-11*pos},15,15,nil,function(self) gc.ranksroster[i][tag]=self:GetChecked() or false;run_setchecked_ranks() end)
						
					end
					
					--bank tabs
					do
						for b=1,6 do
							gc['db'..i..'w'..b]=DA.CheckBtnCreater(nil,gc['d'..i..'gwithraw'],{"LEFT",gc['d'..i..'gwithraw'],"LEFT",-2,-7-25*b},15,15,nil,function(self) gc.ranksroster[i].bankpermissions[b].canView=self:GetChecked() or false;run_setchecked_ranks() end)
							gc['db'..i..'d'..b]=DA.CheckBtnCreater(nil,gc['d'..i..'gwithraw'],{"LEFT",gc['d'..i..'gwithraw'],"LEFT",8,-7-25*b},15,15,nil,function(self) gc.ranksroster[i].bankpermissions[b].canDeposit=self:GetChecked() or false;run_setchecked_ranks() end)
							gc['db'..i..'e'..b]=DA.CheckBtnCreater(nil,gc['d'..i..'gwithraw'],{"LEFT",gc['d'..i..'gwithraw'],"LEFT",18,-7-25*b},15,15,nil,function(self) gc.ranksroster[i].bankpermissions[b].canEditInfo=self:GetChecked() or false;run_setchecked_ranks() end)
							
							gc['db'..i..'s'..b]=DA.EditBoxCreater(nil,gc['d'..i..'gwithraw'],{"LEFT",gc['d'..i..'gwithraw'],"LEFT",0,-16-25*b},{30,9},"",false,false,{UIDarkAngelFontConsolas:GetFont(), 6},
							function(self)
								if not tonumber(self:GetText()) or (tonumber(self:GetText())<0) then
									self:SetText("")
								elseif tonumber(self:GetText())>100000 then
									self:SetText("100000")
								end
								self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
								gc.ranksroster[i].bankpermissions[b].stacksPerDay=self:GetText()
							end,
							function(self)
								if not tonumber(self:GetText()) or (tonumber(self:GetText())<0) then
									self:SetText("")
								elseif tonumber(self:GetText())>100000 then
									self:SetText("100000")
								end
								self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
								gc.ranksroster[i].bankpermissions[b].stacksPerDay=self:GetText()
							end, --enter here
							function(self)
								if not tonumber(self:GetText()) or (tonumber(self:GetText())<0) then
									self:SetText("")
								elseif tonumber(self:GetText())>100000 then
									self:SetText("100000")
								end
								self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
								gc.ranksroster[i].bankpermissions[b].stacksPerDay=self:GetText()
							end,
							function(self) 	
								self.t:SetBlendMode("BLEND");self.focusgained=1; 
							end,
							function(self) if self.focusgained then run_setchecked_ranks() end end,true)
						end
					end
					
					
				end
				
				
				
			end	
			
			gc.createnewrank=DA.CreateFFGButton2(nil,gc,{"LEFT",gc['d'..GuildControlGetNumRanks() ..'name'],"RIGHT",2,0},10,12,"+",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 8},function()
				create_new_rank()
			end)
		
			
			gc.banktabsfont=DA.FontCreater(nil,L['bank_tabs_notes'],{"LEFT",gc_Scrolled,"TOPLEFT",82,-212},gc_Scrolled,15,250,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.75,0.9,0.9,0.9})
			
			for b=1,6 do
				gc['db'.. 2 ..'w'..b].adfnt=DA.FontCreater(nil,L['Bank Tab'].." #"..b,{"RIGHT",gc['db'.. 2 ..'w'..b],"LEFT",-3,0},gc['db'.. 2 ..'w'..b],15,150,{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"},"right",{0.75,0.9,0.9,0.9})
			end
			
			--export
			do
				gc.finish_import = function()
					get_players()
					reRender_gc()
				end
				gc.exportBtn=DA.CreateFFGButton2(nil,gc,{"CENTER",gc,"TOPLEFT",17,-46},12,30,'export','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9},function(self) 
					if gc.exportFrame:IsShown() then
						gc.exportFrame:Hide()
					else
						gc.exportFrame:Show()
					end
				end)
				
				gc.exportFrame=DA.FrameCreater(nil,gc,130,38,{"BOTTOMRIGHT", gc, "TOPRIGHT", 0, 2})
				
				gc.exportFrame.apply=DA.CreateFFGButton2(nil,gc.exportFrame,{"CENTER",gc.exportFrame,"TOPLEFT",30,-26},12,35,L['import'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
				function(self)
					if gc.exportFrame.EB:GetText() and gc.exportFrame.EB:GetText()~="" then
						gc.ranksroster=nil
						gc.ranksroster=DA.stringToTable(gc.exportFrame.EB:GetText())
						
						gc.finish_import()
					end
				end)
				
				gc.exportFrame.exp=DA.CreateFFGButton2(nil,gc.exportFrame,{"CENTER",gc.exportFrame,"TOPLEFT",90,-26},12,45,L['export'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
				function(self)
					gc.exportFrame.EB:SetText('')
					gc.exportFrame.EB:SetText(DA.tableToString(gc.ranksroster))
					gc.exportFrame.EB:SetCursorPosition(5)
				end)
				
				gc.exportFrame.EB=DA.EditBoxCreater(nil,gc.exportFrame,{"TOPLEFT", gc.exportFrame, "TOPLEFT", 5, -2},{120,15},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 8},
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
			
			-- help window
			do
				gc.helpwindow=DA.FrameCreater(nil,gc,350,150,{"TOPLEFT",gc,"TOPLEFT",30,-40})
					-- gc.helpwindow:SetFrameLevel(22)
					gc.helpwindow.t:SetTexture(0.05, 0.12, 0.18, 0.8)
				
					DA.FontCreater(nil,L['gc_helper'],{"TOPLEFT",gc.helpwindow,"TOPLEFT",5,-12},gc.helpwindow,160,340,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},"left",{0.75,0.9,0.9,0.9}):SetJustifyV("top")
					
					DA.CreateFFGButton2(nil,gc.helpwindow,{"CENTER",gc.helpwindow,"BOTTOM",0,10},12,80,L["got it, close"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',{UIDarkAngelFontConsolas:GetFont(), 9},function()
						 gc.helpwindow:Hide()
					end)
			
				DA.CreateFFGButton2(nil,gc,{"CENTER",gc,"TOPLEFT",9,-9},12,15,"?",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9},function()
					 gc.helpwindow:Show()
				end)
				if fuckingOptions.firsttimeloaded then
					gc.helpwindow:Show()
				end
			end
			
			
			-- run  
			do
				local function is_any_player_ranks_moved()
					for i=2,10 do
						if gc.players_Moved_roster[i] and gc.players_Moved_roster[i].moved then
							return true
						end
					end
					
					return false
				end
				local function recalculate_run_bulk(force)
				
					if force or gc.run:IsShown() then else return end
					
					table.wipe(gc.run_Bulk)
					
					if gc.run.createbackup:GetChecked() then
						tinsert(gc.run_Bulk, {L['create guild backup'],tec='backup',status=nil})
					end
					
					if gc.run.matchranks:GetChecked() then
						if #gc.ranksroster==GuildControlGetNumRanks() then
							tinsert(gc.run_Bulk, {L['add/remove ranks'],tec='add',status='skip',addit=L['not required']})
						else
							tinsert(gc.run_Bulk, {L['add/remove ranks'],tec='add',status=nil})
						end
					end
					
					local moving_players=is_any_player_ranks_moved()
					
					if gc.run.lockranks:GetChecked() then
						if gc.run.moveplayers:GetChecked() and gc.run.saveranks:GetChecked() and moving_players then
							tinsert(gc.run_Bulk, {L["lock ranks"],tec='lock',status=nil})
						else
							tinsert(gc.run_Bulk, {L["lock ranks"],tec='lock',status='skip',addit=L['not required']})
						end
					end
					
					if gc.run.moveplayers:GetChecked() then
						if moving_players then
							tinsert(gc.run_Bulk, {L['move players'],tec='movepl',status=nil})
						else
							tinsert(gc.run_Bulk, {L['move players'],tec='movepl',status='skip',addit=L['no transpositions']})
						end
					end
					
					if gc.run.saveranks:GetChecked() then
						if gc.run.lockranks:GetChecked() and gc.run.moveplayers:GetChecked() and moving_players then
							tinsert(gc.run_Bulk, {L["unlock+save rank permissions"],tec='save',status=nil})
						else
							tinsert(gc.run_Bulk, {L['save rank permissions'],tec='save',status=nil})
						end
					end
					
					
					
				end
				local function set_run_EB(force,only_reRender,on_run)
					
					if on_run or not only_reRender then
						recalculate_run_bulk(force)
					end
					
					local EB=gc.run.procEB
					EB:SetText( on_run and "|cffffaaaaStarting in |cff99ffff5|cffffaaaa seconds|r...\n" or "" )
					
					for i,j in ipairs(gc.run_Bulk) do
						if j.status and j.status=='skip' then
							EB:Insert("|cffee77ee[|cff507375"..j[1].."|cffee77ee]|r ["..L["skipped"].."]: "..(j.addit or "").."\n")
						elseif j.status and j.status=='done' then
							EB:Insert("|cffee77ee[|cff1acc4d"..j[1].."|cffee77ee]|r\n")
						elseif j.status and j.status=='inprogress' then
							EB:Insert("|cffee77ee[|cffded535"..j[1].."|cffee77ee]|r: "..(j.progress or "").."\n")
						elseif not j.status then
							EB:Insert("|cffee77ee[|r"..j[1].."|cffee77ee]|r\n")
						end
					
					end
					if not only_reRender then
						if gc.run.saveranks:GetChecked() or gc.run.moveplayers:GetChecked() then
							gc.run.run:Enable()
						else
							gc.run.run:Disable()
						end
					end
					
				end
				
				gc.run=DA.FrameCreater(nil,gc,gc.width,gc.height,{"TOPLEFT",gc,"TOPLEFT",0,0})
						gc.run:SetPoint("BOTTOMRIGHT",gc,"BOTTOMRIGHT",0,0)
					-- gc.run:SetFrameLevel(23)
					gc.run.t:SetTexture(0.05, 0.08, 0.08, 0.8)
					gc.run.closebtn=DA.CloseButtonCreater(nil,gc.run,{"TOPRIGHT", gc.run, "TOPRIGHT", -5,-5},10,10,'x')
				
				
				
				-- L['take a peek at what a real boss of this gym can do']="взгляните на то, на что способен настоящий босс этого спортзала а также получите велосипеды"
				
				do --run checkboxes
					for i,j in pairs({
						{"createbackup",L['create guild backup'],'gc_createbackup'},
						{"matchranks",L['add/remove ranks'],'gc_matchranks'},
						{},
						{"saveranks",L['save rank permissions'],'gc_saveranks'},
						{"moveplayers",L['move players'],'gc_moveplayers'},
						{"lockranks",L['freeze ranks'],'gc_lockranks'},
					}) do
						if j[1] then
							gc.run[j[1]]=DA.CheckBtnCreater(nil,gc.run,{"CENTER",gc.run,"TOPLEFT",35,-20-(16*i)},25,25,j[2],function() set_run_EB() end,nil,(j[3] or nil))
							gc.run[j[1]].font:SetSize(280,20)
							gc.run[j[1]].font:SetFont(UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE")
							if i==4 or i==5 then
								gc.run[j[1]].font:SetTextColor(0.8,0.4,0.5,1)
							end
							
						end
					end
					
					gc.run.createbackup:SetChecked(true)
					
				end
				
				DA.FontCreater(nil,L["Save options"],{"LEFT",gc.run.createbackup,"TOPLEFT",7,5},gc.run.createbackup,15,170,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
				
				DA.HelpCreater(gc.run,{"CENTER",gc.run,"TOPLEFT",9,-9},'gc_run_notif',15,15)
					
				gc.run.procEB=DA.EditBoxCreater(nil,gc.run,{"TOPLEFT", gc.run, "TOPLEFT", 15, -150},{310,50},nil,true,false,{UIDarkAngelFontConsolas:GetFont(), 8},
					function(self) 	self:ClearFocus() end,
					function(self) 	self:ClearFocus() end, --enter here
					function(self) 	self:ClearFocus() end,
					function(self) 	self:ClearFocus() end,
					nil,nil,nil,1
				)
				
				
				
				DA.CreateFFGButton2(nil,gc,{"CENTER",gc,"TOPLEFT",17,-22},12,30,"Save",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9},function()
					if not IsGuildLeader() then 
						DA.Print(L['only guild master can use it'])
						return
					elseif not gc.helpwindow:IsShown() then
						if GuildControlGetNumRanks()<5 then DA.Print('error: guild data not loaded yet') return end
						set_run_EB(1)
						
						gc.run:Show()
					end
				end)
				
				


				local run_process_next
				local unlock_run_CBs
				
				local function run_stop(emerg,via_button)
					DA.StopTimer('bulkprocessor')
					table.wipe(DA_Bulk_list)
					unlock_run_CBs()
					gc.run.stop:Disable()
					gc.run.closebtn:Enable()
					if not emerg and (gc.run.saveranks:GetChecked() or gc.run.moveplayers:GetChecked()) then
						gc.run.run:Enable()
					else
						gc.run.run:Disable()
					end
					if via_button then
						gc.run.procEB:Insert("|cffee77eeAborted|r")
						DA.Print("the process was forcefully stopped. we would re-render new player's positions only. if you want to check what have been actually done, click 'reset'")
						DA.Print("|cffffaaaa!!! do not reset if you have stopped the process during 'rank lock' (or after and before 'rank save'), especially if you have no backups")
						get_players()
						reRender_gc()
					else
						gc.run.procEB:Insert(L['fepupddone'])
						get_from_guild()
					end
				end
				local function run_process_specific(tasktbl)
					set_run_EB(1,1)
					local task=tasktbl.tec
					
					if task=='backup' then
						do
							tinsert(DA_Bulk_list,function() 
								DA.CreateBackup(nil,1,1,1,1,1,1,1)
								tasktbl.status='done'
							end)
							tinsert(DA_Bulk_list,function()
								set_run_EB(1,1)
								run_process_next()
							end)
						end
					elseif task=='add' then
						do
							local guild_num_ranks=GuildControlGetNumRanks()
							if #gc.ranksroster==0 then 
								DA.Print('error 2869 ') run_stop(1) 
								return
								
							elseif #gc.ranksroster>guild_num_ranks then
								tasktbl.progress=guild_num_ranks.."/"..#gc.ranksroster;set_run_EB(1,1)
								for i=1,#gc.ranksroster-guild_num_ranks do
									tinsert(DA_Bulk_list,function() 
										GuildControlAddRank('NewRank'..i)
									end)
									tinsert(DA_Bulk_list,function() tasktbl.progress=guild_num_ranks+i.."/"..#gc.ranksroster;set_run_EB(1,1) end)
								end
							elseif #gc.ranksroster<guild_num_ranks then
								tasktbl.progress=guild_num_ranks.."/"..#gc.ranksroster;set_run_EB(1,1)
								for i=guild_num_ranks,#gc.ranksroster+1,-1 do
									tinsert(DA_Bulk_list,function() 
										GuildControlDelRank(GuildControlGetRankName(i))
									end)
									tinsert(DA_Bulk_list,function() tasktbl.progress=i.."/"..#gc.ranksroster;set_run_EB(1,1) end)
								end
							end 
							
							tinsert(DA_Bulk_list,function() 
								tasktbl.status='done'
							end)
							tinsert(DA_Bulk_list,function()
								set_run_EB(1,1)
								run_process_next()
							end)
						end
					elseif task=='save' or task=='lock' then
						do
							local lock
							if task=='lock' then lock=true end
							
							tasktbl.progress="0/"..#gc.ranksroster;set_run_EB(1,1)
							
							local bankslots=GetNumGuildBankTabs()
							if bankslots==0 then bankslots=false end
							
							for selectedrank=1,#gc.ranksroster do
								tinsert(DA_Bulk_list,function() DA.Process_GMranking(gc.ranksroster,selectedrank,bankslots,task=='lock') end)
								tinsert(DA_Bulk_list,function()  end)
								tinsert(DA_Bulk_list,function()  end)
								tinsert(DA_Bulk_list,function() tasktbl.progress=selectedrank.."/"..#gc.ranksroster;set_run_EB(1,1) end)
							end
							tinsert(DA_Bulk_list,function() 
								tasktbl.status='done'
							end)
							tinsert(DA_Bulk_list,function()
								set_run_EB(1,1)
								run_process_next()
							end)
						end
					elseif task=='movepl' then
						do
							--form list of needed transactions
							-- for i=2,10 do
								-- if gc.players_Moved_roster[i] and gc.players_Moved_roster[i].moved then
									
								-- end
							-- end
							local run_movingplayers={}
								run_movingplayers.r_done=0
								run_movingplayers.r_total=0
							for i=1,DA.GetNumGMembers() do
								local name, _, rankIndex, _ =GetGuildRosterInfo(i)
								if gc.players_Moved_roster[rankIndex+1].moved then
									tinsert(run_movingplayers,{name=name,initrank=tonumber(rankIndex),needed=gc.players_Moved_roster[rankIndex+1].moved-1})
									run_movingplayers.r_total=run_movingplayers.r_total+1
								end
							end
							
							--init Bulk
							tasktbl.progress="0/"..run_movingplayers.r_total;set_run_EB(1,1)
							for i,j in ipairs(run_movingplayers) do
								tinsert(DA_Bulk_list,function() 
									DA.DemotePromotePlayer(j.name,j.initrank,j.needed,1) 
									run_movingplayers.r_done=run_movingplayers.r_done+1
								end)
								tinsert(DA_Bulk_list,function() tasktbl.progress=run_movingplayers.r_done.."/"..run_movingplayers.r_total;set_run_EB(1,1) end)
								
							end
							
							tinsert(DA_Bulk_list,function() 
								tasktbl.status='done'
							end)
							tinsert(DA_Bulk_list,function()
								set_run_EB(1,1)
								run_process_next()
							end)
						end
					else
						print('error 2939')
						return
					end
				end
				function run_process_next()
					for i,j in ipairs(gc.run_Bulk) do
						if j.status and j.status=='skip' then
							--skip
						elseif j.status and j.status=='done' then
							--skip
						elseif j.status and j.status=='inprogress' then
							print('error 2985: id '..i..' in progress while run_process_next was called ('..j[1]..')')
							return
						elseif not j.status then
							j.status='inprogress'
							
							tinsert(DA_Bulk_list,function() run_process_specific(j) end)
					
							DA.ResumeTimer('bulkprocessor')
							
							return
						end
						
					end
					
					run_stop()
					return
				end
				local function lock_run_CBs()
					for _,j in pairs({"createbackup","matchranks","lockranks","saveranks","moveplayers"}) do
						gc.run[j]:Disable()
					end
				end
				function unlock_run_CBs()
					for _,j in pairs({"createbackup","matchranks","lockranks","saveranks","moveplayers"}) do
						gc.run[j]:Enable()
					end
				end
				local function insertpause()
					for i=1,25 do
						tinsert(DA_Bulk_list,function()  end)
					end
				end
				local function StartGMSave()
					lock_run_CBs()
					set_run_EB(1,1,1)
					-- DA.Print('')
					insertpause()
					run_process_next()
				end
				
				gc.run.run=DA.CreateFFGButton2(nil,gc.run,{"CENTER",gc.run,"TOPLEFT",48,-142},15,34,"Run",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9},function(self)
					if gc.run.saveranks:GetChecked() or gc.run.moveplayers:GetChecked() then
						if #DA_Bulk_list==0 then
							self:Disable()
							gc.run.closebtn:Disable()
							gc.run.stop:Enable()
							StartGMSave()
							return
						else
							print("error 2857: addon is currently processing a bulk")
							return
						end
					else
						print("error 2774: nor save_ranks or move_players checked")
						self:Disable()
						return
					end
				end)
				gc.run.run:Disable()
				
				gc.run.stop=DA.CreateFFGButton2(nil,gc.run,{"CENTER",gc.run,"TOPLEFT",88,-142},15,34,"Stop",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9},function(self)
					run_stop(nil,1)
				end)
				gc.run.stop:Disable()
			end
			
		end
		
		-- patterns
		do
			DarkAngelGUI.Guild.patternsbtn,DarkAngelGUI.Guild.patternsFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild,L["patterns"],12,55,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",325,-10},147,82,"TOP")
			
			do --defaults
			local patterns_c={
				{
					1,		--line
					1, 		--column
					"m",	--text
					1,		--precise
					false,	--showlocals
					"",	--texture
					'p_mains',
					ebx={
						nil,
						nil,
						nil,
						(DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' and "^(%d+),(%d+)" or "Ne?t?:(%-?%d+)"),
						nil,
						nil,
					}
				},
				{
					2,		--line
					1, 		--column
					"t",	--text
					1,		--precise
					false,	--showlocals
					"",	--texture
					'p_tvins',
					ebx={
						nil,
						nil,
						nil,
						"cffffffff",
						nil,
						nil,
					}
				},
			}
			
			if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
				tinsert(patterns_c,{
					1,		--line
					2, 		--column
					"f",	--text
					1,		--precise
					false,	--showlocals
					"_Blue", --texture
					'p_frozen_main',
					ebx={
						nil,
						nil,
						nil,
						"%.",
						nil,
						nil,
					}
				})
				tinsert(patterns_c,{
					2,		--line
					2, 		--column
					"ft",	--text
					1,		--precise
					false,	--showlocals
					"_Blue", --texture
					'p_frozen_tvins',
					ebx={
						nil,
						nil,
						nil,
						"cff8888ff",
						nil,
						nil,
					}
				})
				tinsert(patterns_c,{
					3,		--line
					2, 		--column
					"fm",	--text
					1,		--precise
					false,	--showlocals
					"_Blue", --texture
					'p_main_frozen_m',
					ebx={
						nil,
						nil,
						nil,
						"%,",
						nil,
						nil,
					}
				})
			end
			
			local additionals={
				{
					3,		--line
					1, 		--column
					"d",	--text
					1,		--precise
					1,	--showlocals
					"_Purple", --texture
					'p_dupl_tvins',
					ebx={
						nil,
						nil,
						nil,
						"cffff88ff",
						nil,
						nil,
					}
				},
				{
					4,		--line
					2, 		--column
					"lt",	--text
					1,		--precise
					false,	--showlocals
					"_Yellow", --texture
					'p_leaver_s_tvins',
					ebx={
						nil,
						nil,
						nil,
						"cffb27373",
						nil,
						nil,
					}
				},
				{
					4,		--line
					1, 		--column
					"et",	--text
					1,		--precise
					false,	--showlocals
					"_Black", --texture
					'p_not_assigned',
					ebx={
						nil,
						nil,
						nil,
						"cff736666",
						nil,
						nil,
					}
				},
				{
					5,		--line
					1, 		--column
					"na",	--text
					1,		--precise
					false,	--showlocals
					"_Black", --texture
					'p_na_tvins',
					ebx={
						nil,
						nil,
						nil,
						"^$",
						nil,
						nil,
					}
				},
				{
					5,		--line
					2, 		--column
					"L",	--text
					1,		--precise
					1,	--showlocals
					"", --texture
					'local_assign',
					ebx={
						nil,
						nil,
						"_local",
						nil,
						nil,
						nil,
					}
				},
			}
			for _, su in ipairs(additionals) do
				table.insert(patterns_c, su)
			end
			
			
			for _,ss in ipairs(patterns_c) do
				DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.patternsFrame,{"TOPLEFT", DarkAngelGUI.Guild.patternsFrame, "TOPLEFT",-25+((ss[2])*26),	10-(11*(ss[1]))},10,25,ss[3],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up'..ss[6],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
					DarkAngelGUI.Guild.precmatch:SetChecked(ss[4]);fuckingOptions.precisematchsearch=ss[4]
					DarkAngelGUI.Guild.showlocals:SetChecked(ss[5]);fuckingOptions.showlocals=ss[5]
					for i=1,6 do
						if ss.ebx[i] then
							DarkAngelGUI.Guild["EB"..i]:SetText(ss.ebx[i])
						else
							DarkAngelGUI.Guild["EB"..i]:SetText("")
						end
					end
					DA.GetGuildData();DA.GuildSetAllLines()
				end,ss[7])
			
			end
			
			end
			
			local function re_render_custom_patterns()
				
				for i=1,7 do
					if fuckingOptions.storedpatterns[i] then
						DarkAngelGUI.Guild.patternsFrame['pat'..i]:SetScript("OnClick",function()
							DarkAngelGUI.Guild.precmatch:SetChecked(fuckingOptions.storedpatterns[i][1]);fuckingOptions.precisematchsearch=fuckingOptions.storedpatterns[i][1] or false
							DarkAngelGUI.Guild.showlocals:SetChecked(fuckingOptions.storedpatterns[i][2]);fuckingOptions.showlocals=fuckingOptions.storedpatterns[i][2] or false
							-- DarkAngelGUI.Guild.onlclassselector:SetText(fuckingOptions.storedpatterns[i][4] and L['online'] or L['class']);fuckingOptions.onlclass=fuckingOptions.storedpatterns[i][4] or false
							if next(fuckingOptions.storedpatterns[i][4]) then DarkAngelGUI.Guild.classTbl=fuckingOptions.storedpatterns[i][4] ; update_class_srch() end
							DarkAngelGUI.Guild.onliners:SetChecked(fuckingOptions.storedpatterns[i][5]);fuckingOptions.showonl=fuckingOptions.storedpatterns[i][5] or false
							DarkAngelGUI.Guild.offliners:SetChecked(fuckingOptions.storedpatterns[i][6]);fuckingOptions.showoffl=fuckingOptions.storedpatterns[i][6] or false
							for j=1,6 do
								if fuckingOptions.storedpatterns[i].ebx[j] then
									DarkAngelGUI.Guild["EB"..j]:SetText(fuckingOptions.storedpatterns[i].ebx[j])
								else
									DarkAngelGUI.Guild["EB"..j]:SetText("")
								end
							end
							DA.GetGuildData();DA.GuildSetAllLines()
						end)
						
						DarkAngelGUI.Guild.patternsFrame['pat'..i]:SetText(fuckingOptions.storedpatterns[i][3])
						
						DarkAngelGUI.Guild.patternsFrame['pat'..i]:Show()
					else
						DarkAngelGUI.Guild.patternsFrame['pat'..i]:Hide()
					end
				end
				if #fuckingOptions.storedpatterns==0 then
					DarkAngelGUI.Guild.patternsFrame:SetSize(54,82)
				else
					DarkAngelGUI.Guild.patternsFrame:SetSize(147,82)
				end
				
			end
			
			do --custom
				
				for i=1,7 do 
					DarkAngelGUI.Guild.patternsFrame['pat'..i]=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.patternsFrame,{"TOPLEFT", DarkAngelGUI.Guild.patternsFrame, "TOPLEFT", 54, 10-11*i},10,80,"",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) end)
					DarkAngelGUI.Guild.patternsFrame['patdel'..i]=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.patternsFrame['pat'..i],{"LEFT", DarkAngelGUI.Guild.patternsFrame['pat'..i], "RIGHT", 2, 0},9,9,"x",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
						if fuckingOptions.storedpatterns[i] then table.remove(fuckingOptions.storedpatterns,i) end 
						re_render_custom_patterns()
					end)
				end
				
				DarkAngelGUI.Guild.patternsFrame.addnewFrame=DA.FrameCreater(nil,DarkAngelGUI.Guild.patternsFrame,90,38,{"TOPLEFT", DarkAngelGUI.Guild.patternsFrame, "TOPRIGHT", 2, 0})
					DA.CloseButtonCreater(nil,DarkAngelGUI.Guild.patternsFrame.addnewFrame,{"TOPRIGHT", DarkAngelGUI.Guild.patternsFrame.addnewFrame, "TOPRIGHT", -2,-1},10,10,'x')
				DarkAngelGUI.Guild.patternsFrame.addnewFrame.name=DA.EditBoxCreater2(nil,DarkAngelGUI.Guild.patternsFrame.addnewFrame,{"TOPLEFT", DarkAngelGUI.Guild.patternsFrame.addnewFrame, "TOPLEFT",2,-12},{85,12},"new",false,false,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},nil,1,14,'text')
				DA.FontCreater(nil,L["pattern name"],{"CENTER",DarkAngelGUI.Guild.patternsFrame.addnewFrame.name,"CENTER",-5,13},DarkAngelGUI.Guild.patternsFrame.addnewFrame.name,15,170,{UIDarkAngelFontConsolas:GetFont(), 10},'center',{0.85,1,1,0.8})
				
				DarkAngelGUI.Guild.patternsFrame.addnewFrame.save=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.patternsFrame.addnewFrame,{"CENTER",DarkAngelGUI.Guild.patternsFrame.addnewFrame.name,"CENTER",-5,-13},8,35,L["save"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
					DarkAngelGUI.Guild.patternsFrame.addnewFrame.name:SetFocus()
					DarkAngelGUI.Guild.patternsFrame.addnewFrame.name:ClearFocus()
					if #fuckingOptions.storedpatterns<7 then else return end
					
					local ebx={}
					local anyfound
					for i=1,6 do
						if DarkAngelGUI.Guild["EB"..i]:GetText() and DarkAngelGUI.Guild["EB"..i]:GetText()~="" then
							ebx[i]=DarkAngelGUI.Guild["EB"..i]:GetText()
							anyfound=true
						else
							ebx[i]=false
						end
					end
					
					if next(DarkAngelGUI.Guild.classTbl) then
						anyfound=true
					end
					
					if anyfound then
						tinsert(fuckingOptions.storedpatterns,{
							fuckingOptions.precisematchsearch,
							fuckingOptions.showlocals,
							DarkAngelGUI.Guild.patternsFrame.addnewFrame.name:GetText(),
							DA.DeepCopy(DarkAngelGUI.Guild.classTbl),
							fuckingOptions.showonl,
							fuckingOptions.showoffl,
							ebx=ebx
						})
						
						re_render_custom_patterns()
					else
						DA.Print(L["All search fields are empty"])
						re_render_custom_patterns()
					end
				end)
				
				DarkAngelGUI.Guild.patternsFrame.save=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.patternsFrame,{"TOPLEFT", DarkAngelGUI.Guild.patternsFrame, "TOPLEFT",12, -61.5},8,35,L["save"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
					if DarkAngelGUI.Guild.patternsFrame.addnewFrame:IsShown() then
						DarkAngelGUI.Guild.patternsFrame.addnewFrame:Hide()
					else
						DarkAngelGUI.Guild.patternsFrame.addnewFrame:Show()
					end
				end,'patternsFrame_save')
				
			end
			
			re_render_custom_patterns()
			
		end
		
		-- bulk
		DarkAngelGUI.Guild.bulkBtn=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",385,-10},12,40,'bulk','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
			if DarkAngelGUI.Guild.bulkmenu:IsShown() then
				DarkAngelGUI.Guild.bulkmenu:Hide()
			else
				DarkAngelGUI.Guild.bulkmenu:Show()
			end
		end)
		
		-- backup close
		DarkAngelGUI.Guild.backupClose=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",345,-54.5},10,90,L['roster from backup'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
			self:Hide()
			DarkAngelGuild.custom_mode=nil
			DarkAngelGUI.Guild.micromenu:Hide()
			DAOptMenuFrame.epgpawardFrame:Hide()
			DarkAngelGUI.Guild.bulkmenu:Hide()
			DarkAngelGUI.Guild.bulkBtn:Enable()
			
			DA.GetGuildData()
			DA.GuildSetAllLines()
		end)
		DarkAngelGUI.Guild.backupClose:Hide()
		
		-- micromenu
		do
			--main
			do
				DarkAngelGUI.Guild.micromenu=DA.FrameCreater(nil,DarkAngelGUI.Guild,188.25,155,{"TOPLEFT",DarkAngelGUI.Guild,'TOPRIGHT',3,0},nil)
				
				DA.CloseButtonCreater(nil,DarkAngelGUI.Guild.micromenu,{"TOPRIGHT", DarkAngelGUI.Guild.micromenu, "TOPRIGHT", -5,-5},10,10,'x')
				
				DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",90,-11},12,50,L['tvins'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function() 
					if DarkAngelGUI.Guild.micromenu.ofnotebox:GetText() and (DA.DecodeNote(DarkAngelGUI.Guild.micromenu.ofnotebox:GetText())=='m' or DA.DecodeNote(DarkAngelGUI.Guild.micromenu.ofnotebox:GetText())=='f' ) then
					--is main/frozen main
						DarkAngelGUI.Guild.precmatch:SetChecked(false);fuckingOptions.precisematchsearch=false
						DarkAngelGUI.Guild.showlocals:SetChecked(1);fuckingOptions.showlocals=1
						DarkAngelGUI.Guild.EB1:SetText(DarkAngelGUI.Guild.micromenu.plbox:GetText())
						DarkAngelGUI.Guild.EB2:SetText("")
						DarkAngelGUI.Guild.EB3:SetText("")
						DarkAngelGUI.Guild.EB4:SetText(DarkAngelGUI.Guild.micromenu.plbox:GetText())
						DarkAngelGUI.Guild.EB5:SetText("")
						DarkAngelGUI.Guild.EB6:SetText("")
						
						if DarkAngelGUI.Guild.bulkmenu:IsShown() then
							DarkAngelGUI.Guild.bulkmenu.assignedto:SetText(DarkAngelGUI.Guild.micromenu.plbox:GetText())
						end
						fuckingOptions.showoffl=1
						DarkAngelGUI.Guild.offliners:SetChecked(1)
						DA.GetGuildData();DA.GuildSetAllLines()
						
					elseif DarkAngelGUI.Guild.micromenu.ofnotebox:GetText() and (DA.DecodeNote(DarkAngelGUI.Guild.micromenu.ofnotebox:GetText())=='t' and 2 ) then
					--is main/frozen main
						DarkAngelGUI.Guild.precmatch:SetChecked(false);fuckingOptions.precisematchsearch=false
						DarkAngelGUI.Guild.showlocals:SetChecked(1);fuckingOptions.showlocals=1
						DarkAngelGUI.Guild.EB1:SetText(DarkAngelGUI.Guild.micromenu.ofnotebox:GetText())
						DarkAngelGUI.Guild.EB2:SetText("")
						DarkAngelGUI.Guild.EB3:SetText("")
						DarkAngelGUI.Guild.EB4:SetText(DarkAngelGUI.Guild.micromenu.ofnotebox:GetText())
						DarkAngelGUI.Guild.EB5:SetText("")
						DarkAngelGUI.Guild.EB6:SetText("")
						
						if DarkAngelGUI.Guild.bulkmenu:IsShown() then
							DarkAngelGUI.Guild.bulkmenu.assignedto:SetText(DarkAngelGUI.Guild.micromenu.ofnotebox:GetText())
						end
						fuckingOptions.showoffl=1
						DarkAngelGUI.Guild.offliners:SetChecked(1)
						DA.GetGuildData();DA.GuildSetAllLines()
					end
				end)
				
				DarkAngelGUI.Guild.micromenu.deletelocal=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",10,-85},10,45,L['delete'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self,clicktype) 
					if clicktype=='RightButton' then
						if FEP_L_gMain[DA_CurrentGuild][DarkAngelGUI.Guild.micromenu.plbox:GetText()] then
							FEP_L_gMain[DA_CurrentGuild][DarkAngelGUI.Guild.micromenu.plbox:GetText()]=nil
							DA.GetGuildData();DA.GuildSetAllLines()
							DarkAngelGUI.Guild.micromenu:Hide()
							return
						else
							if DarkAngelGuild.custom_mode then
								DA.Print("This is local tvin from the backup, you can't delete it, baaaaka")
								DA.GetGuildData();DA.GuildSetAllLines()
								DarkAngelGUI.Guild.micromenu:Hide()
								return
							end
							DA.Print("error 3550: no such local found")
							DA.GetGuildData();DA.GuildSetAllLines()
							DarkAngelGUI.Guild.micromenu:Hide()
							return
						end
					end
				end,'confirm_rightclick')
				DarkAngelGUI.Guild.micromenu.deletelocal:Hide()
			end
			
			--ranks menu
			do
				DarkAngelGUI.Guild.micromenu.ranksmenubtn,DarkAngelGUI.Guild.micromenu.ranksmenuFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild.micromenu,"",12,80,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",5,-11},70,GuildControlGetNumRanks()*11,"TOP",'left',
				function() 
					RanksFrameUpd(1)
				end)
				
				DarkAngelGUI.Guild.micromenu.plbox=DA.FontCreater(nil,'player',{"TOPLEFT",DarkAngelGUI.Guild.micromenu.ranksmenubtn,"TOPLEFT",10,-10},DarkAngelGUI.Guild.micromenu.ranksmenubtn,15,170,{UIDarkAngelFontConsolas:GetFont(), 12,'outline'},'left',{0.85,1,1,1})
				DarkAngelGUI.Guild.micromenu.plclasslvl=DA.FontCreater(nil,'player_class_lvl',{"TOPLEFT",DarkAngelGUI.Guild.micromenu.ranksmenubtn,"TOPLEFT",15,-22},DarkAngelGUI.Guild.micromenu.ranksmenubtn,15,170,{UIDarkAngelFontConsolas:GetFont(), 8,'outline'},'left',{0.85,1,1,0.8})
				
			end
			-- note
			do
				--editbox
				DarkAngelGUI.Guild.micromenu.notebox=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",4,-68},{182,12},"",false,false,{UIDarkAngelFontConsolas:GetFont(), 9},
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil end,
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil end, 
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil end,
					function(self) 	 	
						if self:GetParent():IsShown() then 
							self.focusgained=1 
							DA.RegatherGuildNotes()
							self.t:SetBlendMode("BLEND")
						end	
					end,
					function(self) 
						if self.focusgained then 
							self.t:SetTexture(70/255, 12/255, 20/255, 0.4)
							DarkAngelGUI.Guild.micromenu.noteset:Enable()
							DarkAngelGUI.Guild.micromenu.notecancel:Enable()
							if #(self:GetText()):gsub('[\128-\191]', '')>31 then
								self:SetText(self.mytext)
							else
								self.mytext=self:GetText()
							end
							if fuckingOptions.mmenuqcopy and ({string.gsub(self:GetText(),"%s","")})[1]~="" then
								DarkAngelGUI.Guild.micromenu.notecopymenuFrame:Show()
								DarkAngelGUI.Guild.micromenu.notecopymenuFrame.EB:SetText(self:GetText())
								DA.DropdownHint(DarkAngelGUI.Guild.micromenu.notecopymenuFrame.EB:GetText(),DarkAngelGUI.Guild.micromenu.notebox,DarkAngelGUI.Guild.micromenu.notecopymenuFrame,"PN","FFG_gMain","note",DarkAngelGUI.Guild.micromenu.notecopymenuFrame)
							elseif fuckingOptions.mmenuqcopy then
								DarkAngelGUI.Guild.micromenu.notecopymenuFrame:Hide()
								DarkAngelGUI.Guild.micromenu.notecopymenuFrame.EB:SetText("")
							end
						end
					end,nil,nil,1
				)
				DarkAngelGUI.Guild.micromenu.noteboxfont=DA.FontCreater(nil,L['note'],{"TOPLEFT",DarkAngelGUI.Guild.micromenu.notebox,"TOPLEFT",5,12},DarkAngelGUI.Guild.micromenu.notebox,15,170,{UIDarkAngelFontConsolas:GetFont(), 9,'outline'},'left',{0.85,1,1,0.8})
				--set
				DarkAngelGUI.Guild.micromenu.noteset=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",6,-80},12,30,L['set'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
					function()
						DarkAngelGUI.Guild.micromenu.notebox:ClearFocus();DarkAngelGUI.Guild.micromenu.notebox.focusgained=nil
						if CanEditPublicNote() then else DA.Print(L['I am not allowed to edit public notes']) return end
						DarkAngelGUI.Guild.micromenu.notebox.t:SetTexture(28/255, 32/255, 50/255, 1);
						DarkAngelGUI.Guild.micromenu.noteset:Disable()
						DarkAngelGUI.Guild.micromenu.notecancel:Disable()
						
						DA.SetPublicnote(DarkAngelGUI.Guild.micromenu.plbox:GetText(),DarkAngelGUI.Guild.micromenu.notebox:GetText())
						DA.UpdateMicroMenu('notebox') 
						DA.UpdateMicroMenu('notebox') 
						
					end
				)
				DarkAngelGUI.Guild.micromenu.noteset:Disable()
				--cancel
				DarkAngelGUI.Guild.micromenu.notecancel=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",39,-80},12,50,L['cancel'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
					function() 
						DarkAngelGUI.Guild.micromenu.notebox:ClearFocus();DarkAngelGUI.Guild.micromenu.notebox.focusgained=nil
						DarkAngelGUI.Guild.micromenu.notebox.t:SetTexture(28/255, 32/255, 50/255, 1);
						DarkAngelGUI.Guild.micromenu.noteset:Disable()
						DarkAngelGUI.Guild.micromenu.notecancel:Disable()
						
						DarkAngelGUI.Guild.micromenu.notebox:SetText(DarkAngelGUI.Guild.micromenu.notebox.orignote) 
					end
				)
				DarkAngelGUI.Guild.micromenu.notecancel:Disable()
				--refresh
				DarkAngelGUI.Guild.micromenu.noterefresh=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",92,-80},12,50,L['refresh'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
					function()
						DarkAngelGUI.Guild.micromenu.notebox:ClearFocus();DarkAngelGUI.Guild.micromenu.notebox.focusgained=nil
						DarkAngelGUI.Guild.micromenu.notebox.t:SetTexture(28/255, 32/255, 50/255, 1);
						DarkAngelGUI.Guild.micromenu.noteset:Disable()
						DarkAngelGUI.Guild.micromenu.notecancel:Disable()
						
						DA.UpdateMicroMenu('notebox') 
						DA.UpdateMicroMenu('notebox') 
					end
				)
				
				--copy
				DarkAngelGUI.Guild.micromenu.notecopymenubtn,DarkAngelGUI.Guild.micromenu.notecopymenuFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild.micromenu,L["copy"],12,40,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",145,-80},160,20,"TOPRIGHT")
				
				DarkAngelGUI.Guild.micromenu.notecopymenuFrame.EB=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.micromenu.notecopymenuFrame,{"TOPLEFT", DarkAngelGUI.Guild.micromenu.notecopymenuFrame, "TOPLEFT", 5, -2},{150,12},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 10},
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil DA.DropdownHint(self:GetText(),DarkAngelGUI.Guild.micromenu.notebox,DarkAngelGUI.Guild.micromenu.notecopymenuFrame,"PN","FFG_gMain","note",DarkAngelGUI.Guild.micromenu.notecopymenuFrame) end,
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil DA.DropdownHint(self:GetText(),DarkAngelGUI.Guild.micromenu.notebox,DarkAngelGUI.Guild.micromenu.notecopymenuFrame,"PN","FFG_gMain","note",DarkAngelGUI.Guild.micromenu.notecopymenuFrame) end, --enter here
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil DA.DropdownHint(self:GetText(),DarkAngelGUI.Guild.micromenu.notebox,DarkAngelGUI.Guild.micromenu.notecopymenuFrame,"PN","FFG_gMain","note",DarkAngelGUI.Guild.micromenu.notecopymenuFrame) end,
					function(self) 	
						if self:GetParent():IsShown() then
							DA.RegatherGuildNotes()
							self.t:SetBlendMode("BLEND")
							self.focusgained=1
						end
					end,
					function(self)
						if self.focusgained then
							DA.DropdownHint(self:GetText(),DarkAngelGUI.Guild.micromenu.notebox,DarkAngelGUI.Guild.micromenu.notecopymenuFrame,"PN","FFG_gMain","note",DarkAngelGUI.Guild.micromenu.notecopymenuFrame)
						end
						
					end
				)
					
			end
			
			-- officer note
			do
				--editbox
				DarkAngelGUI.Guild.micromenu.ofnotebox=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",4,-108},{182,12},"",false,false,{UIDarkAngelFontConsolas:GetFont(), 9},
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil end,
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil end, 
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil end,
					function(self) 	 	
						if self:GetParent():IsShown() then 
							self.focusgained=1 
							DA.RegatherGuildNotes()
							self.t:SetBlendMode("BLEND")
						end	
					end,
					function(self) 
						if self.focusgained then 
							self.t:SetTexture(70/255, 12/255, 20/255, 0.4)
							DarkAngelGUI.Guild.micromenu.ofnoteset:Enable()
							DarkAngelGUI.Guild.micromenu.ofnotecancel:Enable()
							if #(self:GetText()):gsub('[\128-\191]', '')>31 then
								self:SetText(self.mytext)
							else
								self.mytext=self:GetText()
							end
							if fuckingOptions.mmenuqcopy and ({string.gsub(self:GetText(),"%s","")})[1]~="" then
								DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame:Show()
								DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame.EB:SetText(self:GetText())
								DA.DropdownHint(DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame.EB:GetText(),DarkAngelGUI.Guild.micromenu.ofnotebox,DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame,"ON","FEP_gMain","officernote")
							elseif fuckingOptions.mmenuqcopy then
								DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame:Hide()
								DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame.EB:SetText("")
							end
						end
					end,nil,nil,1
				)
				DarkAngelGUI.Guild.micromenu.ofnoteboxfont=DA.FontCreater(nil,L['officer note'],{"TOPLEFT",DarkAngelGUI.Guild.micromenu.ofnotebox,"TOPLEFT",5,12},DarkAngelGUI.Guild.micromenu.ofnotebox,15,170,{UIDarkAngelFontConsolas:GetFont(), 9,'outline'},'left',{0.85,1,1,0.8})
				--set
				DarkAngelGUI.Guild.micromenu.ofnoteset=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",6,-120},12,30,L['set'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
					function()
							
						if DarkAngelGUI.Guild.micromenu.islocal then
							if DarkAngelGuild.custom_mode then
								DA.Print("This is data from the backup, you can't edit it, baaaaka")
								DA.GetGuildData();DA.GuildSetAllLines()
								DarkAngelGUI.Guild.micromenu:Hide()
								return
							end
							
							local entered=DarkAngelGUI.Guild.micromenu.ofnotebox:GetText()
							if not FEP_gMain[entered] then 
								DA.Print('invalid main name specified!!!')
								DarkAngelGUI.Guild.micromenu.ofnotebox.t:SetTexture(110/255, 12/255, 20/255, 0.4)
								return
							elseif FEP_gMain[entered] and DA.DecodeNote(FEP_gMain[entered])=='t' then 
								DA.Print('this player is twink')
								DarkAngelGUI.Guild.micromenu.ofnotebox.t:SetTexture(110/255, 12/255, 20/255, 0.4)
								return
							elseif FEP_gMain[entered] and DA.DecodeNote(FEP_gMain[entered])=='f' then 
								DA.Print('this player is frozen')
								DarkAngelGUI.Guild.micromenu.ofnotebox.t:SetTexture(110/255, 12/255, 20/255, 0.4)
								return
							elseif FEP_gMain[entered] and DA.DecodeNote(FEP_gMain[entered])=='m' then
								FEP_L_gMain[DA_CurrentGuild][DarkAngelGUI.Guild.micromenu.plbox:GetText()]=entered
								DarkAngelGUI.Guild.micromenu.ofnotebox:ClearFocus();DarkAngelGUI.Guild.micromenu.ofnotebox.focusgained=nil
								DarkAngelGUI.Guild.micromenu.ofnotebox.t:SetTexture(28/255, 32/255, 50/255, 1);
								DarkAngelGUI.Guild.micromenu.ofnoteset:Disable()
								DarkAngelGUI.Guild.micromenu.ofnotecancel:Disable()
								DA.UpdateMicroMenu('ofnotebox') 
								DA.UpdateMicroMenu('ofnotebox') 
								if DA_Awarder and DA_Awarder:IsShown() then
									tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
									tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
									DA.ResumeTimer('fep')
								end
							else
								DA.Print('invalid main name specified!!!')
								DarkAngelGUI.Guild.micromenu.ofnotebox.t:SetTexture(110/255, 12/255, 20/255, 0.4)
								return
							end
							
						else
							if CanEditOfficerNote() then else DA.Print(L['I am not allowed to edit officer notes']) return end
							DarkAngelGUI.Guild.micromenu.ofnotebox:ClearFocus();DarkAngelGUI.Guild.micromenu.ofnotebox.focusgained=nil
							DarkAngelGUI.Guild.micromenu.ofnotebox.t:SetTexture(28/255, 32/255, 50/255, 1);
							DarkAngelGUI.Guild.micromenu.ofnoteset:Disable()
							DarkAngelGUI.Guild.micromenu.ofnotecancel:Disable()
							
							DA.SetOfficernote(DarkAngelGUI.Guild.micromenu.plbox:GetText(),DarkAngelGUI.Guild.micromenu.ofnotebox:GetText())
							
							DA.UpdateMicroMenu('ofnotebox')
							DA.UpdateMicroMenu('ofnotebox') 
							if DA_Awarder and DA_Awarder:IsShown() then
								tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
								tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
								DA.ResumeTimer('fep')
							end
						end
					end
				)
				DarkAngelGUI.Guild.micromenu.ofnoteset:Disable()
				--cancel
				DarkAngelGUI.Guild.micromenu.ofnotecancel=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",39,-120},12,50,L['cancel'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
					function() 
						DarkAngelGUI.Guild.micromenu.ofnotebox:ClearFocus();DarkAngelGUI.Guild.micromenu.ofnotebox.focusgained=nil
						DarkAngelGUI.Guild.micromenu.ofnotebox.t:SetTexture(28/255, 32/255, 50/255, 1);
						DarkAngelGUI.Guild.micromenu.ofnoteset:Disable()
						DarkAngelGUI.Guild.micromenu.ofnotecancel:Disable()
						
						DarkAngelGUI.Guild.micromenu.ofnotebox:SetText(DarkAngelGUI.Guild.micromenu.ofnotebox.orignote) 
					end
				)
				DarkAngelGUI.Guild.micromenu.ofnotecancel:Disable()
				--refresh
				DarkAngelGUI.Guild.micromenu.ofnoterefresh=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",92,-120},12,50,L['refresh'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
					function()
						DarkAngelGUI.Guild.micromenu.ofnotebox:ClearFocus();DarkAngelGUI.Guild.micromenu.ofnotebox.focusgained=nil
						DarkAngelGUI.Guild.micromenu.ofnotebox.t:SetTexture(28/255, 32/255, 50/255, 1);
						DarkAngelGUI.Guild.micromenu.ofnoteset:Disable()
						DarkAngelGUI.Guild.micromenu.ofnotecancel:Disable()
						
						DA.UpdateMicroMenu('ofnotebox') 
						DA.UpdateMicroMenu('ofnotebox') 
					end
				)
				
				--freeze
				if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
					DarkAngelGUI.Guild.micromenu.ofnotefreeze=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"CENTER",DarkAngelGUI.Guild.micromenu,"TOPLEFT",110,-103},10,10,'f','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Blue.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"}, 
						function(self)
							local note=DarkAngelGUI.Guild.micromenu.ofnotebox:GetText()
							local typ,ep,gp=DA.DecodeNote(note)
								if typ=='f' then
									DarkAngelGUI.Guild.micromenu.ofnotebox:SetText(ep..","..gp)
								elseif typ=='m' then	
									DarkAngelGUI.Guild.micromenu.ofnotebox:SetText("."..ep..","..gp)
								else
									return
								end
							DarkAngelGUI.Guild.micromenu.ofnotebox.t:SetTexture(70/255, 12/255, 20/255, 0.4)
							DarkAngelGUI.Guild.micromenu.ofnoteset:Enable()
							DarkAngelGUI.Guild.micromenu.ofnotecancel:Enable()
							
						end
					)
				
				end
				
				
				--copy
				DarkAngelGUI.Guild.micromenu.ofnotecopymenubtn,DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild.micromenu,L["copy"],12,40,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",145,-120},160,20,"BOTTOMRIGHT")
				
				DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame.EB=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame,{"TOPLEFT", DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame, "TOPLEFT", 5, -2},{150,12},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 10},
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil DA.DropdownHint(self:GetText(),DarkAngelGUI.Guild.micromenu.ofnotebox,DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame,"ON","FEP_gMain","officernote",DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame) end,
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil DA.DropdownHint(self:GetText(),DarkAngelGUI.Guild.micromenu.ofnotebox,DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame,"ON","FEP_gMain","officernote",DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame) end, --enter here
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil DA.DropdownHint(self:GetText(),DarkAngelGUI.Guild.micromenu.ofnotebox,DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame,"ON","FEP_gMain","officernote",DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame) end,
					function(self) 	
						if self:GetParent():IsShown() then
							DA.RegatherGuildNotes()
							self.t:SetBlendMode("BLEND")
							self.focusgained=1
						end
					end,
					function(self)
						if self.focusgained then
							DA.DropdownHint(self:GetText(),DarkAngelGUI.Guild.micromenu.ofnotebox,DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame,"ON","FEP_gMain","officernote",DarkAngelGUI.Guild.micromenu.ofnotecopymenuFrame)
						end
						
					end
				)
				
			end
			
			-- checkboxes
			do
				DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",8,-138},15,15,L['copy'],function(self) fuckingOptions.mmenuqcopy=(self:GetChecked() or false) end,{'fuckingOptions','mmenuqcopy'},'mmenuqcopy')
				DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",60,-138},15,15,L['focus'],function(self) fuckingOptions.mmenuleavefocus=(self:GetChecked() or false) end,{'fuckingOptions','mmenuleavefocus'},'mmenuleavefocus')
				DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",120,-138},15,15,L['rank'],function(self) fuckingOptions.mmenucloserank=(self:GetChecked() or false) end,{'fuckingOptions','mmenucloserank'},'mmenucloserank')
			end
			
			
			
		end
		-- bulk actions
		do
			--bulk
			do
				DarkAngelGUI.Guild.bulkmenu=DA.FrameCreater(nil,DarkAngelGUI.Guild,188.25,142,{"TOPLEFT",DarkAngelGUI.Guild,'TOPRIGHT',3,-158},nil)
					
				DA.CloseButtonCreater(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPRIGHT", DarkAngelGUI.Guild.bulkmenu, "TOPRIGHT", -5,-5},10,10,'x')
					
				DA.FontCreater(nil,L['Bulk actions'],{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",5,-5},DarkAngelGUI.Guild.bulkmenu,15,170,{UIDarkAngelFontConsolas:GetFont(), 9,'outline'},'left',{0.85,1,1,0.8})
				
				
				DA.HelpCreater(DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",82,0},'BulkHelp')
				DA.HelpCreater(DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",95,0},'BulkHelp2')
				
				--APPLY TO
				DarkAngelGUI.Guild.bulkmenu.applytobtn,DarkAngelGUI.Guild.bulkmenu.applytoFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild.bulkmenu,L['selected'],12,85,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",58,-25},70,23,"BOTTOM",'left',function() 
					DarkAngelGUI.Guild.bulkmenu.actionFrame:Hide()
					DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
				end)
				for i,j in pairs({L['selected'],L['all found']}) do 
					DarkAngelGUI.Guild.bulkmenu.applytoFrame['fr'..i]=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu.applytoFrame,{"TOPLEFT", DarkAngelGUI.Guild.bulkmenu.applytoFrame, "TOPLEFT", 1,10-11*i},10,68,j,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
						DarkAngelGUI.Guild.bulkmenu.applytobtn.fs:SetText(self.fs:GetText())
						DarkAngelGUI.Guild.bulkmenu.applytoFrame:Hide()
						if DarkAngelGUI.Guild.bulkmenu.applytobtn.fs:GetText() and DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText() and (not DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() or (DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() and DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.fs:GetText())) then
							DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
						else
							DarkAngelGUI.Guild.bulkmenu.startbulk:Disable()
						end
					end,nil,nil,'left')
				end
				DA.FontCreater(nil,L['Apply to'],{"RIGHT",DarkAngelGUI.Guild.bulkmenu.applytobtn,"LEFT",-1,0},DarkAngelGUI.Guild.bulkmenu.applytobtn,15,80,{UIDarkAngelFontConsolas:GetFont(), 8,'outline'},'right',{0.85,1,1,0.8})
				
				--SELECT ACTION
				DarkAngelGUI.Guild.bulkmenu.actionbtn,DarkAngelGUI.Guild.bulkmenu.actionFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild.bulkmenu,'',12,85,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",58,-38},80,45,"BOTTOM",'left',function() 
					DarkAngelGUI.Guild.bulkmenu.applytoFrame:Hide()
					DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
				end)
				for i,j in pairs({L['note'],L['officer note'],L['rank'],L['kick']}) do 
					DarkAngelGUI.Guild.bulkmenu.actionFrame['fr'..i]=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu.actionFrame,{"TOPLEFT", DarkAngelGUI.Guild.bulkmenu.actionFrame, "TOPLEFT", 1,10-11*i},10,78,j,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
						DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:SetText(self.fs:GetText())
						DarkAngelGUI.Guild.bulkmenu.actionFrame:Hide()
						if self.fs:GetText()==L['note'] or self.fs:GetText()==L['officer note'] then
							--ranks
							DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:Hide()
							DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
							DarkAngelGUI.Guild.bulkmenu.adranksmenufont:Hide()
							--eb
							DarkAngelGUI.Guild.bulkmenu.adnotebox:Show()
						elseif self.fs:GetText()==L['rank'] then
							--ranks
							DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:Show()
							DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
							DarkAngelGUI.Guild.bulkmenu.adranksmenufont:Show()
							--eb
							DarkAngelGUI.Guild.bulkmenu.adnotebox:Hide()
						elseif self.fs:GetText()==L['kick'] then
							--ranks
							DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:Hide()
							DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
							DarkAngelGUI.Guild.bulkmenu.adranksmenufont:Hide()
							--eb
							DarkAngelGUI.Guild.bulkmenu.adnotebox:Hide()
						end
						if DarkAngelGUI.Guild.bulkmenu.applytobtn.fs:GetText() and DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText() and (not DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() or (DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() and DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.fs:GetText())) then
							DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
						else
							DarkAngelGUI.Guild.bulkmenu.startbulk:Disable()
						end
					end,nil,nil,'left')
				end
				DA.FontCreater(nil,L['action'],{"RIGHT",DarkAngelGUI.Guild.bulkmenu.actionbtn,"LEFT",-1,0},DarkAngelGUI.Guild.bulkmenu.actionbtn,15,80,{UIDarkAngelFontConsolas:GetFont(), 8,'outline'},'right',{0.85,1,1,0.8})
				
				--RANK (hidden)
				DarkAngelGUI.Guild.bulkmenu.adranksmenubtn,DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild.bulkmenu,"",12,85,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",58,-51},70,GuildControlGetNumRanks()*11,"BOTTOM",'left',
				function() 
					DarkAngelGUI.Guild.bulkmenu.actionFrame:Hide()
					DarkAngelGUI.Guild.bulkmenu.applytoFrame:Hide() 
					
					local myrank=({GetGuildInfo('player')})[3]						
						for i=1,GuildControlGetNumRanks() do 
							if DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i] then
								DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i].fs:SetText(GuildControlGetRankName(i))
								DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i]:SetScript("OnClick",function(self) 
									DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.fs:SetText(self.fs:GetText())
									DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.rankid=i-1
									DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
									if DarkAngelGUI.Guild.bulkmenu.applytobtn.fs:GetText() and DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText() and (not DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() or (DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() and DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.fs:GetText())) then
										DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
									else
										DarkAngelGUI.Guild.bulkmenu.startbulk:Disable()
									end
								end)
								DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i]:SetPoint("TOPLEFT", DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame, "TOPLEFT", 1,10-11*i)
							else
								DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i]=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame,{"TOPLEFT", DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame, "TOPLEFT", 1,10-11*i},10,68,GuildControlGetRankName(i),'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
									DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.fs:SetText(self.fs:GetText())
									DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.rankid=i-1
									DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
									if DarkAngelGUI.Guild.bulkmenu.applytobtn.fs:GetText() and DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText() and (not DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() or (DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() and DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.fs:GetText())) then
										DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
									else
										DarkAngelGUI.Guild.bulkmenu.startbulk:Disable()
									end
								end,nil,nil,'left')
							end
							DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i]:Show()
							
							if i-1<=myrank then
								DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i]:Disable()
								DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i].fs:SetTextColor(0.4,0.4,0.4,1)
							else
								DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i]:Enable()
								DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i].fs:SetTextColor(0.5,0.9,1,1)
							end
						end
						local gcnr=GuildControlGetNumRanks()
						for i=1,20 do
							if i<=gcnr then
							else
								if DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i] then
									DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i]:Hide()
								end
							end
						end
						DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:SetSize(70,GuildControlGetNumRanks()*11)
						
				end)
				for i=1,GuildControlGetNumRanks() do 
					DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i]=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame,{"TOPLEFT", DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame, "TOPLEFT", 1,10-11*i},10,68,GuildControlGetRankName(i),'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
						DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.fs:SetText(self.fs:GetText())
						DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.rankid=i-1
						DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
						if DarkAngelGUI.Guild.bulkmenu.applytobtn.fs:GetText() and DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText() and (not DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() or (DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() and DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.fs:GetText())) then
							DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
						else
							DarkAngelGUI.Guild.bulkmenu.startbulk:Disable()
						end
					end,nil,nil,'left')
					
					local myrank=({GetGuildInfo('player')})[3]
					if i-1<=myrank then
						DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i]:Disable()
					else
						DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame['rankbtn'..i]:Enable()
					end
				end
				DarkAngelGUI.Guild.bulkmenu.adranksmenufont=DA.FontCreater(nil,L["rank"],{"RIGHT",DarkAngelGUI.Guild.bulkmenu.adranksmenubtn,"LEFT",-1,0},DarkAngelGUI.Guild.bulkmenu.adranksmenubtn,15,170,{UIDarkAngelFontConsolas:GetFont(), 9,'outline'},'right',{0.85,1,1,0.8})

				--EB (hidden)
				DarkAngelGUI.Guild.bulkmenu.adnotebox=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",5,-51},{133,12},"",false,false,{UIDarkAngelFontConsolas:GetFont(), 9},
					function(self) 		self:ClearFocus(); self.focusgained=nil end,
					function(self) 		self:ClearFocus(); self.focusgained=nil end, 
					function(self) 		self:ClearFocus(); self.focusgained=nil end,
					function(self) 	 	if self:GetParent():IsShown() then self.focusgained=1 end	end,
					function(self) 
						if self.focusgained then 
							if #(self:GetText()):gsub('[\128-\191]', '')>31 then
								self:SetText(self.mytext)
							else
								self.mytext=self:GetText()
							end
						end
					end,nil,nil,1
				)


				--deselect
				DarkAngelGUI.Guild.bulkmenu.autodeselect=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",142,-64},14,14,L["desaftblk"])
				DarkAngelGUI.Guild.bulkmenu.autodeselect.font:SetSize(80,30)
				DarkAngelGUI.Guild.bulkmenu.autodeselect.font:SetFont(UIDarkAngelFontConsolas:GetFont(), 6.5)
				DarkAngelGUI.Guild.bulkmenu.autodeselect:SetChecked(false)
				
				DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu,{"CENTER",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",166,-56.5},10,40,L['clear'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 8},function(self) 
					DA.SelectGuildMember(nil,true)
					DarkAngelGUI.Guild.UpdRows(DarkAngelGuild.offset or 1)
				end)

				----START
				DarkAngelGUI.Guild.bulkmenu.startbulk=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu,{"CENTER",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",166,-30.5},10,40,L["bulkstart"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red.blp',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self)
						DarkAngelGUI.Guild.bulkmenu.adnotebox:ClearFocus()
						DarkAngelGUI.Guild.bulkmenu.adnotebox.focusgained=nil
						if DarkAngelGUI.Guild.bulkmenu.applytobtn.fs:GetText() and DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText() and (not DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() or (DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() and DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.fs:GetText())) then
							self:Disable()
							DA.ProcessBulk()
						else
							self:Disable()
						end
					end
				)
				DarkAngelGUI.Guild.bulkmenu.startbulk:Disable()

				--- STOP
				DarkAngelGUI.Guild.bulkmenu.stoper=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu,{"CENTER",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",166,-43.5},10,40,L["bulkstop"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red.blp',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self)
						DA.StopTimer('bulkprocessor')
						table.wipe(DA_Bulk_list)
						DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
						self:Disable()
						DA.GetGuildData();DA.GuildSetAllLines()
					end
				)
				
				--hides
				do
					--ranks
					DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:Hide()
					DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
					DarkAngelGUI.Guild.bulkmenu.adranksmenufont:Hide()
					--eb
					DarkAngelGUI.Guild.bulkmenu.adnotebox:Hide()
					
					DarkAngelGUI.Guild.bulkmenu.stoper:Disable()
				end
			end

			----retwink menu----
			do
				DarkAngelGUI.Guild.bulkmenu.assignedto=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",10,-92},{100,12},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 10},
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil ;DarkAngelGUI.Guild.bulkmenu.astdropfr:Hide() end,
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil ;DarkAngelGUI.Guild.bulkmenu.astdropfr:Hide() end , --enter here
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil ;DarkAngelGUI.Guild.bulkmenu.astdropfr:Hide() end,
					function(self) 	
						if self:GetParent():IsShown() then
							DA.RegatherGuildNotes()
							self.t:SetBlendMode("BLEND")
							self.focusgained=1
						end
					end,
					function(self)
						if self:GetParent():IsShown() and self.focusgained then
						DA.DropdownHint(self:GetText(),DarkAngelGUI.Guild.bulkmenu.assignedto,DarkAngelGUI.Guild.bulkmenu.astdropfr,"RTAT","FEP_gMain","officernote",DarkAngelGUI.Guild.bulkmenu.astdropfr)
						end
					end
				)
				DA.FontCreater(nil,L['re-twink twins assigned to'],{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu.assignedto,"TOPLEFT",5,12},DarkAngelGUI.Guild.bulkmenu.assignedto,15,170,{UIDarkAngelFontConsolas:GetFont(), 8,'outline'},'left',{0.85,1,1,0.8})
				DarkAngelGUI.Guild.bulkmenu.astdropfr=DA.FrameCreater(nil,DarkAngelGUI.Guild.bulkmenu.assignedto,160,20,{"BOTTOMLEFT",DarkAngelGUI.Guild.bulkmenu.assignedto,"TOPLEFT"})
				
				DarkAngelGUI.Guild.bulkmenu.newmain=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",10,-122},{100,12},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 10},
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil ;DarkAngelGUI.Guild.bulkmenu.nmdropfr:Hide() end,
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil ;DarkAngelGUI.Guild.bulkmenu.nmdropfr:Hide() end , --enter here
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil ;DarkAngelGUI.Guild.bulkmenu.nmdropfr:Hide() end,
					function(self) 	
						if self:GetParent():IsShown() then
							DA.RegatherGuildNotes()
							self.t:SetBlendMode("BLEND")
							self.focusgained=1
						end
					end,
					function(self)
						if self:GetParent():IsShown() and self.focusgained then
						DA.DropdownHint(self:GetText(),DarkAngelGUI.Guild.bulkmenu.newmain,DarkAngelGUI.Guild.bulkmenu.nmdropfr,"TTNM","FEP_gMain","officernote",DarkAngelGUI.Guild.bulkmenu.nmdropfr)
						end
					end
				)
				DA.FontCreater(nil,L['to the new main'],{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu.newmain,"TOPLEFT",5,12},DarkAngelGUI.Guild.bulkmenu.newmain,15,170,{UIDarkAngelFontConsolas:GetFont(), 8,'outline'},'left',{0.85,1,1,0.8})
				DarkAngelGUI.Guild.bulkmenu.nmdropfr=DA.FrameCreater(nil,DarkAngelGUI.Guild.bulkmenu.newmain,160,20,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu.newmain,"BOTTOMLEFT"})
				
				DarkAngelGUI.Guild.bulkmenu.ismakingnewmain=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.bulkmenu,{"CENTER",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",137,-122},15,15,L["Make it new Main"],function(self) end)
				DarkAngelGUI.Guild.bulkmenu.ismakingnewmain.font:SetSize(80,30)
				
				DarkAngelGUI.Guild.bulkmenu.retvgobtn=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu,{"center",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",163,-102},12,40,L["bulkstart"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function(self)
					DarkAngelGUI.Guild.bulkmenu.assignedto.focusgained=nil;DarkAngelGUI.Guild.bulkmenu.assignedto:ClearFocus()
					DarkAngelGUI.Guild.bulkmenu.newmain.focusgained=nil;DarkAngelGUI.Guild.bulkmenu.newmain:ClearFocus()
					if not CanEditOfficerNote() then
						DA.Print(L['I am not allowed to edit officer notes'])
						return 
					else
						self:Disable()
						DA.Retwink()
					end
				end)
				
				DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",85,-108},10,28,'swap','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function()
					local first=DarkAngelGUI.Guild.bulkmenu.assignedto:GetText()
					local second=DarkAngelGUI.Guild.bulkmenu.newmain:GetText()
					DarkAngelGUI.Guild.bulkmenu.assignedto:SetText(second)
					DarkAngelGUI.Guild.bulkmenu.newmain:SetText(first)
				end)
				DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",110,-92},13,10,'>','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function()
					DarkAngelGUI.Guild.precmatch:SetChecked(false);fuckingOptions.precisematchsearch=false
					DarkAngelGUI.Guild.showlocals:SetChecked(1);fuckingOptions.showlocals=1
					DarkAngelGUI.Guild.EB1:SetText(DarkAngelGUI.Guild.bulkmenu.assignedto:GetText())
					DarkAngelGUI.Guild.EB2:SetText("")
					DarkAngelGUI.Guild.EB3:SetText("")
					DarkAngelGUI.Guild.EB4:SetText(DarkAngelGUI.Guild.bulkmenu.assignedto:GetText())
					DarkAngelGUI.Guild.EB5:SetText("")
					DarkAngelGUI.Guild.EB6:SetText("")
					DA.GetGuildData();DA.GuildSetAllLines()
					
				end)
				DarkAngelGUI.Guild.bulkmenu.retvrunsrch2=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",110,-122},13,10,'>','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function()
					DarkAngelGUI.Guild.precmatch:SetChecked(false);fuckingOptions.precisematchsearch=false
					DarkAngelGUI.Guild.showlocals:SetChecked(1);fuckingOptions.showlocals=1
					DarkAngelGUI.Guild.EB1:SetText(DarkAngelGUI.Guild.bulkmenu.newmain:GetText())
					DarkAngelGUI.Guild.EB2:SetText("")
					DarkAngelGUI.Guild.EB3:SetText("")
					DarkAngelGUI.Guild.EB4:SetText(DarkAngelGUI.Guild.bulkmenu.newmain:GetText())
					DarkAngelGUI.Guild.EB5:SetText("")
					DarkAngelGUI.Guild.EB6:SetText("")
					DA.GetGuildData();DA.GuildSetAllLines()
					
				end)
				
			end

		end
		
		-- SEARCH EBoxes
		do
			--name EB
			for i,j in pairs(
			{
			{5,85,9.5,L['name']},
			{95,25,10,L['lvl']},
			{125,125,9.5,L['note']},
			{255,100,9.5,L['officer note']},
			{360,65,9.5,L['rank']},
			{430,50,10,L['online']},
			}
			) do
				DarkAngelGUI.Guild["EB"..i]=DA.EditBoxCreater(nil,DarkAngelGUI.Guild,{"TOPLEFT", DarkAngelGUI.Guild, "TOPLEFT", j[1], -30},{j[2],18},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), j[3]},
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil end,
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil DA.GuildSetAllLines() end,
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end self:ClearFocus(); self.focusgained=nil end,
					function(self) 	
						if self:GetParent():IsShown() then
							self.t:SetBlendMode("BLEND")
							self.focusgained=1
						end
					end,
					function(self)
						if self.focusgained then
							DA.GuildSetAllLines()
						end
					end
				)
				
				DA.CreateFFGButton2(nil,DarkAngelGUI.Guild["EB"..i],{"TOPRIGHT",DarkAngelGUI.Guild["EB"..i],"TOPRIGHT",0,0},5,5,'x','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 6},function() DarkAngelGUI.Guild["EB"..i]:ClearFocus();DarkAngelGUI.Guild["EB"..i]:SetText(""); DA.GuildSetAllLines()  end,nil,nil,'left')
			
				DA.FontCreater(nil,j[4],{"LEFT",DarkAngelGUI.Guild["EB"..i],"LEFT",2.5,15},DarkAngelGUI.Guild["EB"..i],15,170,{UIDarkAngelFontConsolas:GetFont(), 10},'left',{0.85,1,1,0.8})
				
			end
			
			DarkAngelGUI.Guild.foundtext=DA.FontCreater(nil,'found:',{"LEFT",DarkAngelGUI.Guild.EB1,"LEFT",10,-15},DarkAngelGUI.Guild.EB1,15,400,{UIDarkAngelFontConsolas:GetFont(), 9,'outline'},'left',{0.85,1,1,0.6})
			
			DarkAngelGUI.Guild.classTbl={}
			DarkAngelGUI.Guild.classbtn,DarkAngelGUI.Guild.classFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild,L["class"],7,35,{"CENTER", DarkAngelGUI.Guild, "TOPLEFT", 65, -24},70,120.5,"BOTTOM",nil,function() end)
			DarkAngelGUI.Guild.classbtn:SetFrameLevel(DarkAngelGUI.Guild:GetFrameLevel()+2)
			local classes={
				"DEATHKNIGHT",
				"PALADIN",
				"WARRIOR",
				"HUNTER",
				"ROGUE",
				"MAGE",
				"WARLOCK",
				"PRIEST",
				"DRUID",
				"SHAMAN",
			}
			
			
			for i,class in ipairs(classes) do
				DarkAngelGUI.Guild.classFrame[class] = DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.classFrame,{"TOPLEFT", DarkAngelGUI.Guild.classFrame, "TOPLEFT", 1, -(11*i)},10,68,class,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
					if self.enabled then DarkAngelGUI.Guild.classTbl[class]=nil else DarkAngelGUI.Guild.classTbl[class]=true end
					update_class_srch()
					DA.GetGuildData();DA.GuildSetAllLines()
					copyFrame_Update()
				end)
				DarkAngelGUI.Guild.classFrame[class].fs:SetTextColor(unpack(DA.GetClassColor(class)))
			
			end
			DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.classFrame,{"TOPLEFT", DarkAngelGUI.Guild.classFrame, "TOPLEFT", 1, -1},9,33.5,"all",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
					local w = next(DarkAngelGUI.Guild.classTbl) and true or nil
					if w then
						for i,class in ipairs(classes) do DarkAngelGUI.Guild.classTbl[class]=nil ; DarkAngelGUI.Guild.classFrame[class].enabled=false end
					else
						for i,class in ipairs(classes) do DarkAngelGUI.Guild.classTbl[class]=true ; DarkAngelGUI.Guild.classFrame[class].enabled=true end
					end
					update_class_srch()
					DA.GetGuildData();DA.GuildSetAllLines()
					copyFrame_Update()
				end)
			DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.classFrame,{"TOPRIGHT", DarkAngelGUI.Guild.classFrame, "TOPRIGHT", -1, -1},9,33.5,"inv",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
					for i,class in ipairs(classes) do
					if DarkAngelGUI.Guild.classTbl[class] then
						DarkAngelGUI.Guild.classTbl[class]=nil
					else
						DarkAngelGUI.Guild.classTbl[class]=true
					end
				end
					update_class_srch()
					DA.GetGuildData();DA.GuildSetAllLines()
					copyFrame_Update()
				end)
			
			function update_class_srch()
				for i,class in ipairs(classes) do
					if DarkAngelGUI.Guild.classTbl[class] then
						DarkAngelGUI.Guild.classFrame[class]:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White')
						DarkAngelGUI.Guild.classFrame[class].enabled=true
					else
						DarkAngelGUI.Guild.classFrame[class]:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black')
						DarkAngelGUI.Guild.classFrame[class].enabled=false
					end
				end
			end
			
		end
end

---- Con ------
---- Con ------
---- Con ------
DA.TabCreater({"TOP",_G["DarkAngelGUI"],"BOTTOMLEFT",255,0},15,30,10,30,"Con",{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},function(self) DA.ResetScrollBoxes() end,function() DA.ResetScrollBoxes() end,"Interface\\AddOns\\DarkAngel\\template\\pict\\a31")
do
	DA.ScrollBarCreater("DarkAngelcon",DarkAngelGUI.Con,{DarkAngelGUI.Con.width-5, DarkAngelGUI.Con.height-70},{"TOPLEFT",DarkAngelGUI.Con,"TOPLEFT",5, -30})
	local con_scrolled = DarkAngelcon.scrollchild
	DarkAngelGUI.Con.EB=DA.EditBoxCreater(nil,con_scrolled,{"TOPLEFT",con_scrolled,"TOPLEFT",5,-2},{460,15},"",true,false,{UIDarkAngelFontConsolas:GetFont(), 9.5},
		function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end,
		false, --enter here
		function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); self.focusgained=nil end,
		function(self) 	
			if self:GetParent():IsShown() then
				self.t:SetBlendMode('blend');
				self.focusgained=1
			end
		end
	)
	DarkAngelGUI.Con.EB:SetText(
[=[
--[[
    You can run some large chunks of code here.
    Average player wont need this... are you though? :)
]]

for i=1,5 do
     print(i .. " !")
end
DarkAngel.Print("Hello world!")
]=])

	DarkAngelGUI.Con.runbtn=DA.CreateFFGButton2(nil,DarkAngelGUI.Con,{"CENTER",DarkAngelGUI.Con,"TOPLEFT",58,-20},12,50,'/run','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 12, "OUTLINE"},function() 
		DarkAngelGUI.Con.EB:ClearFocus()
			loadstring(DarkAngelGUI.Con.EB:GetText(),'Piece of Shiet')()
	end)
	DA.FontCreater(nil,"Multiline Console",{"LEFT",DarkAngelGUI.Con.runbtn,"RIGHT",7,0},DarkAngelGUI.Con.runbtn,15,170,{UIDarkAngelFontConsolas:GetFont(), 10},'left',{0.85,1,1,0.4})
		

end
-----  opt ---------
-----  opt ---------
-----  opt ---------
do
	DA.TabCreater({"TOP",_G["DarkAngelGUI"],"BOTTOMLEFT",15,0},15,20,10,40,"opt",{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},function(self) end,function(self) end,"Interface\\AddOns\\DarkAngel\\template\\pict\\a31")
	DA.ScrollBarCreater("DarkAngelopt",DarkAngelGUI.opt,{DarkAngelGUI.opt.width-5, DarkAngelGUI.opt.height-5},{"TOPLEFT", DarkAngelGUI.opt, "TOPLEFT", 5, -5})
	local options_scrolled=DarkAngelopt.scrollchild

	do --texture options
		local Textureopt=DA.EditBoxCreater2(nil,options_scrolled,{"CENTER",options_scrolled,"TOPLEFT",25,-30},{30,12},fuckingOptions.txt1op,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions","txt1op"},0,1,false,L["Art texture alpha"],nil,'arttextalpha',function() DA.RePaintFrames() end)
			DA.FontCreater(nil,L["Texture Options"],{"LEFT",Textureopt,"CENTER",-10,13},Textureopt,15,90,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
		local txt2col=DA.EditBoxCreater2(nil,Textureopt,{"CENTER",Textureopt,"CENTER",0,-15},{30,12},fuckingOptions.txt2op,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions","txt2op"},0,1,false,L["BG texture alpha"],nil,'bgtextalpha',function() DA.RePaintFrames() end)
		local txt1cc=DA.CheckBtnCreater(nil,Textureopt,{"CENTER",Textureopt,"CENTER",95,0},15,15,L['+transp'],function(self) fuckingOptions.txt1extra=(self:GetChecked() or false) DA.RePaintFrames() end,{'fuckingOptions','txt1extra'},'txt1extra')
		local txt2cc=DA.CheckBtnCreater(nil,Textureopt,{"CENTER",Textureopt,"CENTER",95,-15},15,15,L['+transp'],function(self) fuckingOptions.txt2extra=(self:GetChecked() or false) DA.RePaintFrames() end,{'fuckingOptions','txt2extra'},'txt2extra')
		--presets	
		for i,j in ipairs({
			{1,1,false,1},
			{1,0,false,false},
			{1,0.25,false,false},
			{1,0.7,1,false},
			{1,0,1,false},
			{0.6,0.4,1,false},
			{0,0.2,false,false},
			{0,1,false,1},
			{0.1,0.3,1,1}
		}) do
			DA.CreateFFGButton2(nil,Textureopt,{"CENTER",Textureopt,"CENTER",130+15*i,-0},12,12,tostring(i),'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
				fuckingOptions.txt1op=j[1]
				fuckingOptions.txt2op=j[2]
				fuckingOptions.txt1extra=j[3]
				fuckingOptions.txt2extra=j[4]
				Textureopt:SetText(fuckingOptions.txt1op)
				txt2col:SetText(fuckingOptions.txt2op)
				txt1cc:SetChecked(fuckingOptions.txt1extra)
				txt2cc:SetChecked(fuckingOptions.txt2extra)
				DA.RePaintFrames()
			end)
		end
			DA.FontCreater(nil,L["texture presets"],{"CENTER",Textureopt,"CENTER",227,10},Textureopt,15,170,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
	end
	
			
	do	--alias and binds
		local aliasbtn = DA.ButtonCreater(nil,GuildFrame,{"CENTER",GuildFrame,"TOPRIGHT",-27,-330},22,22,">",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up.blp',function() DarkAngel_minimapBtn:Click() end) 
		local function aliasShowHide()
			if fuckingOptions.gwinbtn then 
				aliasbtn:Show()
			else
				aliasbtn:Hide()
			end
		end
		DA.CheckBtnCreater(nil,options_scrolled,{"CENTER",options_scrolled,"TOPLEFT",160,-60},15,15,L['guild window alias button'],function(self) fuckingOptions.gwinbtn=(self:GetChecked() or false) aliasshowhide() end,{'fuckingOptions','gwinbtn'},nil)
		
		DA.CheckBtnCreater(nil,options_scrolled,{"CENTER",options_scrolled,"TOPLEFT",15,-60},15,15,L['Additional binds'],
			function(self) 
				fuckingOptions.ctrlobind=(self:GetChecked() or false) 
				if fuckingOptions.ctrlobind and not InCombatLockdown() then 
					SetBinding('CTRL-O',"CLICK DarkAngel_minimapBtn:LeftButton") 
					SetBindingClick('SHIFT-O',"DarkAngel_bind2") 
					SetBindingClick('ALT-O',"DarkAngel_bind3") 
					SetBindingClick('ALT-CTRL-O',"DarkAngel_bind4") 
					SetBindingClick('CTRL-SHIFT-O',"DarkAngel_bind5") 
					
				elseif GetBindingAction('SHIFT-O')=="CLICK DarkAngel_bind2:LeftButton" and not InCombatLockdown() then 
					SetBinding('CTRL-O',nil) 
					SetBinding('ALT-O',nil) 
					SetBinding('ALT-CTRL-O',nil) 
					SetBinding('CTRL-SHIFT-O',nil) 
					SetBinding('SHIFT-O',"TOGGLECHANNELPULLOUT")
				end
			end,{'fuckingOptions','ctrlobind'},'additionalbinds')
		if fuckingOptions.ctrlobind and not InCombatLockdown() then 
			SetBinding('CTRL-O',"CLICK DarkAngel_minimapBtn:LeftButton") 
			SetBindingClick('SHIFT-O',"DarkAngel_bind2") 
			SetBindingClick('ALT-O',"DarkAngel_bind3") 
			SetBindingClick('ALT-CTRL-O',"DarkAngel_bind4") 
			SetBindingClick('CTRL-SHIFT-O',"DarkAngel_bind5") 
		end
	end
	
	DA.DKP_commUpdate()
		
end


end
function DA.CreateTweakGUIs(modOptTable,loaded_Modules)
	local f = DA.FrameCreater(nil,DarkAngelopt.scrollchild,154,80)
	f:Show()
	DA.FontCreater(nil,"Tweaks",{"LEFT",f,"TOPLEFT",5,-6},f,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
	tinsert(modOptTable, {'Tweaks',f})	
	
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-20},15,15,L['epgp: officer note warning'],function(self) fuckingOptions.epgpofficer=(self:GetChecked() or false);DA.RunTweaks('epgpofficer') end,{'fuckingOptions','epgpofficer'},'epgpofficernote')
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-32},15,15,L['epgp: multiple masters warning'],function(self) fuckingOptions.epgpmultiple=(self:GetChecked() or false);DA.RunTweaks('epgpmultiple') end,{'fuckingOptions','epgpmultiple'},'epgpmmasters')
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-44},15,15,L['epgp: custom tvins and loot'],function(self) fuckingOptions.epgptwinksandloot=(self:GetChecked() or false);DA.RunTweaks('epgptwinksandloot') end,{'fuckingOptions','epgptwinksandloot'},'epgptwinsandloot')
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",25,-54},15,15,L['epgp: EP Auc'],function(self) fuckingOptions_g[DA_CurrentGuild].epgpepauc=(self:GetChecked() or false);DA.RunTweaks('epgptwinksandloot') end,{'fuckingOptions_g','epgpepauc','DA_CurrentGuild'},'epgpepauc')
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-68},15,15,L['raidroll_epgp: DarkAngel tvins'],function(self) fuckingOptions.rrtwinks=(self:GetChecked() or false);DA.RunTweaks('rrtwinks') end,{'fuckingOptions','rrtwinks'},'rrtwins')
	loaded_Modules['Tweaks']=true
end

local function getNoteInfoWhisper_micro(ep,gp,frozen)
	if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
		return ((frozen and " "..L["[FROZEN]"]) or "").." "..ep.." EP  "..gp.." GP"
	elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
		return ((frozen and " "..L["[FROZEN]"]) or "").." "..ep.." DKP"
	end
end
local function getNoteInfoWhisper(author)
	if FEP_gMain[author] then
		local typ,ep,gp,_=DA.DecodeNote(FEP_gMain[author])
		if typ=='m' then
			return L["Your credit is"]..getNoteInfoWhisper_micro(ep,gp)
		elseif typ=='f' then
			return L["Your credit is"]..getNoteInfoWhisper_micro(ep,gp,1)
		elseif typ=='t' then
			if FEP_gMain[FEP_gMain[author]] then
				local t_typ,t_ep,t_gp,_=DA.DecodeNote(FEP_gMain[FEP_gMain[author]])
				if t_typ=='m' then
					return L["Your credit is"]..getNoteInfoWhisper_micro(t_ep,t_gp)
				elseif t_typ=='f' then
					return L["Your credit is"]..getNoteInfoWhisper_micro(t_ep,t_gp,1)
				elseif t_typ=='t' then
					return L["Broken guild officer note (double tvin). You can set your main via '?main <name>' command"]
				end
			else
				return L["Broken guild officer note. You can set your main via '?main <name>' command"]
			end
		end
	elseif FEP_L_gMain[DA_CurrentGuild][author] then
		if FEP_gMain[FEP_L_gMain[DA_CurrentGuild][author]] then
			local typ,ep,gp,_=DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][author]])
			if typ=='m' then
				return L["Your credit is"]..getNoteInfoWhisper_micro(ep,gp)
			elseif typ=='f' then
				return L["Your credit is"]..getNoteInfoWhisper_micro(ep,gp,1)
			elseif typ=='t' then
				return L["Broken local assignment. You can set your main via '?main <name>' command"]
			end
		else
			return L["You are not in guild and not assigned. You can set your main via '?main <name>' command"]
		end
	else
		return L["You are not in guild and not assigned. You can set your main via '?main <name>' command"]
	end
end
local function setTvinInfoWhisper_micro(islocal,new_name,author,newtyp)
	-- print(islocal,new_name,author,newtyp)
	local doingmain=new_name
	
	if newtyp=='f' then
		return L["This main is frozen. Do you want to un-freeze it?"]
	elseif newtyp=='t' then
		local t_typ,t_ep,t_gp,_=DA.DecodeNote(FEP_gMain[FEP_gMain[new_name]])
		if t_typ=='m' then
			doingmain=FEP_gMain[new_name]
		elseif t_typ=='f' then
			return L["This main is frozen. Do you want to un-freeze it?"]
		elseif t_typ=='t' then
			return L["Broken guild officer note (double tvin). You can set your main via '?main <name>' command"]
		end
	elseif not newtyp then
		return L["No such character found in guild - "]..new_name
	end
	
	if islocal then
		-- print('doing L '..author.." "..doingmain)
		FEP_L_gMain[DA_CurrentGuild][author]=doingmain
		return "[OK]"
	else
		if not CanEditOfficerNote() then
			return L['i cant edit officer notes']
		else
			-- print('doing '..author.." "..doingmain)
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(author), doingmain)
			return "[OK]"
		end
	end
	
	
end
local function setTvinInfoWhisper(author,message)
local new_name=DA.capitalizeFirstCharacter(message:gsub("%s",""):gsub("?main",""))

-- print(author,message)
-- print(new_name)
if author==new_name or ((FEP_gMain[author] or FEP_L_gMain[DA_CurrentGuild][author]) and message:gsub("%s","")=="?main") then
	if FEP_gMain[author] then
		local typ,ep,gp,_=DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][author]])
		if typ=='m' then
			if FEP_gMain[author]:gsub("%s","")=="" then
				return L["Your character is main in guild (empty note = main). You can set your main via '?main <name>' command"]
			else
				return L["Your character is main in guild"]..". "..L["Your credit is"]..getNoteInfoWhisper_micro(ep,gp)
			end
		elseif typ=='f' then
			return L["Your character is main in guild"]..". "..L["Your credit is"]..getNoteInfoWhisper_micro(ep,gp,1)
		elseif  typ=='t' then
			if FEP_gMain[FEP_gMain[author]] then
				local t_typ,t_ep,t_gp,_=DA.DecodeNote(FEP_gMain[FEP_gMain[author]])
				if t_typ=='m' then
					return L["Your main is"].." "..FEP_gMain[author]
				elseif t_typ=='f' then
					return L["Your main is"].." "..L["[FROZEN]"].." "..FEP_gMain[author]
				elseif t_typ=='t' then
					return L["Broken guild officer note (double tvin). You can set your main via '?main <name>' command"]
				end
			else
				return L["Broken guild officer note. You can set your main via '?main <name>' command"]
			end
		end
	elseif FEP_L_gMain[DA_CurrentGuild][author] then
		if FEP_gMain[FEP_L_gMain[DA_CurrentGuild][author]] then
			local typ,ep,gp,_=DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][author]])
			if typ=='m' then
				return L["Your main is"].." "..FEP_L_gMain[DA_CurrentGuild][author]..". "..L["Your credit is"]..getNoteInfoWhisper_micro(ep,gp)
			elseif typ=='f' then
				return L["Your main is"].." "..FEP_L_gMain[DA_CurrentGuild][author]..". "..L["Your credit is"]..getNoteInfoWhisper_micro(ep,gp,1)
			elseif typ=='t' then
				return L["Broken local assignment. You can set your main via '?main <name>' command"]
			end
		else
			return L["You are not in guild and not assigned. You can set your main via '?main <name>' command"]
		end
	elseif author==new_name then
		return L["You cant assign your character to itself. dumbass (respectfully)"]
	end
end

	local oldtyp,oldep
	local newtyp,newep
	if FEP_gMain[author] then
		oldtyp,oldep,oldgp,_=DA.DecodeNote(FEP_gMain[author])
	elseif FEP_L_gMain[DA_CurrentGuild][author] and FEP_gMain[FEP_L_gMain[DA_CurrentGuild][author]] then
		oldtyp,oldep,oldgp,_=DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][author]])
	end
	if FEP_gMain[new_name] then
		newtyp,newep,newgp,_=DA.DecodeNote(FEP_gMain[new_name])
	end
	
	if FEP_gMain[author] then
		if oldtyp=='m' then
			if oldep==0 and oldgp==0 then
				return setTvinInfoWhisper_micro(nil,new_name,author,newtyp)
			else
				return L["Cant change main automatically"]
			end
			
		elseif oldtyp=='f' then
			return L["Your current values are frozen. You need to un-freeze it?"]
			
		elseif oldtyp=='t' then
			if FEP_gMain[FEP_gMain[author]] then
				if FEP_gMain[author]==new_name then
					return L["You are already assigned correctly"]
				else
					return L["Cant change main automatically"]
				end
			else
				return setTvinInfoWhisper_micro(nil,new_name,author,newtyp)
			end
		end
	elseif FEP_L_gMain[DA_CurrentGuild][author] then
		if FEP_L_gMain[DA_CurrentGuild][author]==new_name then
			return L["You are already assigned correctly"]
		end
		if oldtyp=='m' then
			return L["Cant change local assignment automatically"]
		elseif oldtyp=='f' then
			return L["Your current values are frozen. You need to un-freeze it?"]
			
		elseif oldtyp=='t' then
			return setTvinInfoWhisper_micro("_local",new_name,author,newtyp)
		end
		
	elseif newtyp then
		return setTvinInfoWhisper_micro("_local",new_name,author,newtyp)
	else
		return L["No such character found in guild - "]..new_name
	end
	
end
local DA_DKP_comm = CreateFrame("Frame")
function DA.DKP_commUpdate()

if fuckingOptions_g[DA_CurrentGuild].dkpcomm then
	DA_DKP_comm:RegisterEvent("CHAT_MSG_WHISPER")
else
	DA_DKP_comm:UnregisterEvent("CHAT_MSG_WHISPER")
end

	DA_DKP_comm:SetScript("OnEvent", function(_,_,message,author)
		if not fuckingOptions_g[DA_CurrentGuild].dkpcomm_inraid or UnitInRaid('player') then
			if (message:find("?dkp") or message:find("?epgp") or message:find("?main")) and not CanViewOfficerNote() then
				DA.Print(L['error, i cant read officer notes'])
				return
			end
		else
			return
		end
			
		if message:find("?dkp") or message:find("?epgp") then
			SendChatMessage(getNoteInfoWhisper(author), "whisper",nil,author)
		elseif message:find("?main") then
			local response=setTvinInfoWhisper(author,message)
			if response=="[OK]" then
				if UnitInRaid('player') then 
					tinsert(DA_Fep_bulk,function()  end)
					tinsert(DA_Fep_bulk,function() SendChatMessage(response, "whisper",nil,author) end)
					tinsert(DA_Fep_bulk,function()  end)
					tinsert(DA_Fep_bulk,function()  end)
					tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
					tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
				end
			else
				tinsert(DA_Fep_bulk,function()  end)
				tinsert(DA_Fep_bulk,function() SendChatMessage(response, "whisper",nil,author) end)
			
			end
			DA.ResumeTimer('fep')
		end
	end)
end



function DA.GetGfoundList(mod)

	local result={}

	if mod=='sel' then
		for _,player in ipairs(DA_G_Processed) do
			local name = player.plname
			
			if DA.Players_Selected[name] then
				if player.isLocal then
					tinsert(result,{'local',name})
				else
					tinsert(result,{'normal',name,player.rankID,player.isOnline})
				end
			end
		end
		
	elseif mod=='all' then
		for _,player in ipairs(DA_G_Processed) do
			local name = player.plname
			if player.isLocal then
				tinsert(result,{'local',name})
			else
				tinsert(result,{'normal',name,player.rankID,player.isOnline})
			end
		end
		
	end
	
	return result
	
end
function DA.ProcessBulk()

local mode
if not DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText() then
	DA.Print(L['no action selected']) 
	DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
	return
elseif DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText()==L['note'] then
	mode='note'
	if not CanEditPublicNote() then
		DA.Print(L['I am not allowed to edit public notes'])
		DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
		return 
	end
elseif DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText()==L['officer note'] then
	mode='of.note'
	if not CanEditOfficerNote() then
		DA.Print(L['I am not allowed to edit officer notes'])
		DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
		return 
	end
elseif DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText()==L['rank'] then
	mode='rank'
	if not DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.fs:GetText() then
		DA.Print(L['no rank selected'])
		DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
		return 
	end
	if not CanGuildDemote() or not CanGuildPromote() then
		DA.Print(L['I cant demote and/or promote'])
		-- DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
		-- return 
	end
elseif DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText()==L['kick'] then
	mode='kick'
	if not CanGuildRemove() then
		DA.Print(L['I am not allowed to kick guild members'])
		DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
		return 
	end
end




if not mode then DA.Print(L['no action selected']);DarkAngelGUI.Guild.bulkmenu.startbulk:Enable() return end

local playersarray
if not DarkAngelGUI.Guild.bulkmenu.applytobtn.fs:GetText() then
	DA.Print(L["no apply to selected"]) 
	DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
	return
elseif DarkAngelGUI.Guild.bulkmenu.applytobtn.fs:GetText()==L['selected'] then
	playersarray=DA.GetGfoundList('sel')
elseif DarkAngelGUI.Guild.bulkmenu.applytobtn.fs:GetText()==L['all found'] then
	playersarray=DA.GetGfoundList('all')
end

if not playersarray or #playersarray==0 then DA.Print(L['no players found']);DarkAngelGUI.Guild.bulkmenu.startbulk:Enable() return end

if not DA_unlock200 and #playersarray>=200 then
	DA.Print('|cffff0000####################################')
	DA.Print('|cffff4444stupid protection triggered')
	DA.Print('|cffff7744bulk was started for '..#playersarray..' players')
	DA.Print('|cffff7744you can disable this protection using the following command:')
	DA.Print('|cff44ffff/run DA_unlock200=1')
	DA.Print('|cffff0000####################################')
	DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()



	return 
end
if not DA_unlockallguild and DarkAngelGUI.Guild.bulkmenu.applytobtn.fs:GetText()==L['all found'] and 
(DarkAngelGUI.Guild.EB1:GetText() or '')=='' and 
(DarkAngelGUI.Guild.EB2:GetText() or '')=='' and 
(DarkAngelGUI.Guild.EB3:GetText() or '')=='' and
(DarkAngelGUI.Guild.EB4:GetText() or '')=='' and
(DarkAngelGUI.Guild.EB5:GetText() or '')=='' and
(DarkAngelGUI.Guild.EB6:GetText() or '')=='' then
	DA.Print('|cffff0000####################################')
	DA.Print('|cffff4444stupid protection triggered')
	DA.Print('|cffff7744bulk was started for all guild members')
	DA.Print('|cffff7744you can disable this protection using the following command:')
	DA.Print('|cff44ffff/run DA_unlockallguild=1')
	DA.Print('|cffff0000####################################')
	DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
	return 
end
DarkAngelGUI.Guild.bulkmenu.stoper:Enable()
-- LKAGkao=playersarray

if mode=='note' then
	local new=(DarkAngelGUI.Guild.bulkmenu.adnotebox:GetText() or "")
	
	for _,pltbl in pairs(playersarray) do
		if pltbl[1]=='local' then
			DA.Print(pltbl[2]..' skipped (is not a guild member)')
		elseif pltbl[1]=='normal' then
			tinsert(DA_Bulk_list,function() DA.SetPublicnote(pltbl[2],new) end)
		end
	end
elseif mode=='of.note' then
	local new=(DarkAngelGUI.Guild.bulkmenu.adnotebox:GetText() or "")
	
	for _,pltbl in pairs(playersarray) do
		if pltbl[1]=='local' then
			if FEP_L_gMain[DA_CurrentGuild][pltbl[2]] then FEP_L_gMain[DA_CurrentGuild][pltbl[2]]=new end
		elseif pltbl[1]=='normal' then
			tinsert(DA_Bulk_list,function() DA.SetOfficernote(pltbl[2],new) end)
		end
	end
elseif mode=='rank' then
	local new=DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.rankid
	for _,pltbl in pairs(playersarray) do
		if pltbl[1]=='local' then
			DA.Print(pltbl[2]..' skipped (is not a guild member)')
		elseif pltbl[1]=='normal' then
			if pltbl[3]=="0" then
				DA.Print(pltbl[2]..' skipped (is guild leader)')
			elseif pltbl[2]==GetUnitName('player') then
				DA.Print(pltbl[2]..' skipped (self)')
			else
				tinsert(DA_Bulk_list,function() DA.DemotePromotePlayer(pltbl[2],pltbl[3],new,1) end)
			end
		end
	end
elseif mode=='kick' then
	for _,pltbl in pairs(playersarray) do
		if pltbl[1]=='local' then
			if FEP_L_gMain[DA_CurrentGuild][pltbl[2]] then FEP_L_gMain[DA_CurrentGuild][pltbl[2]]=nil end
		elseif pltbl[1]=='normal' then
			if pltbl[3]=="0" then
				DA.Print(pltbl[2]..' skipped (is guild leader)')
			elseif pltbl[2]==GetUnitName('player') then
				DA.Print(pltbl[2]..' skipped (self)')
			else
				GuildUninvite(pltbl[2])
			end
		end
	end
end

tinsert(DA_Bulk_list,function()  end)
tinsert(DA_Bulk_list,function()  DA.GetGuildData(); end)
tinsert(DA_Bulk_list,function()  DA.GuildSetAllLines();if DarkAngelGUI.Guild.bulkmenu.autodeselect:GetChecked() then DA.SelectGuildMember(nil,true) end end)
tinsert(DA_Bulk_list,function()  DA.UpdateMicroMenu() end)
tinsert(DA_Bulk_list,function()  DA.UpdateMicroMenu();DarkAngelGUI.Guild.bulkmenu.startbulk:Enable();DarkAngelGUI.Guild.bulkmenu.stoper:Disable() end)
		DA.ResumeTimer('bulkprocessor')
		

end


function DA.OpenOptMenu(parent,name, in_guild_backup)
DAOptMenuFrame:Hide()
DAOptMenuFrame:SetPoint("TOPLEFT",parent,"BOTTOM")
if not name then return end

if parent.ismtot and parent.ismtot==2 then
	DAOptMenuFrame.ismt=true
elseif parent.ismtot and parent.ismtot==1 then
	DAOptMenuFrame.ismt=false
elseif parent.ismtot and parent.ismtot==0 then
	DAOptMenuFrame.ismt=false
else
	DAOptMenuFrame.ismt=false
end

if DAOptMenuFrame.calledfrom=="DA_Awarder" then
	DAOptMenuFrame:SetSize(141,104)
	
	if InCombatLockdown() then 
		if UnitIsRaidOfficer('player') then
			DAOptMenuFrame.kick:Show()
			DAOptMenuFrame.kick:SetAlpha(1)
			DAOptMenuFrame.kick:Enable()
		else
			DAOptMenuFrame.kick:Hide()
			DAOptMenuFrame.kick:SetAlpha(0.5)
			DAOptMenuFrame.kick:Disable()
		end
	else
		DAOptMenuFrame.target:Show()
		DAOptMenuFrame.focus:Show()
		DAOptMenuFrame.MT:Show()
		DAOptMenuFrame.OT:Show()
		if UnitIsRaidOfficer('player') then
			DAOptMenuFrame.kick:Show()
			DAOptMenuFrame.kick:SetAlpha(1)
			DAOptMenuFrame.kick:Enable()
			DAOptMenuFrame.MT:SetAlpha(1)
			DAOptMenuFrame.MT:Enable()
			DAOptMenuFrame.OT:SetAlpha(1) 
			DAOptMenuFrame.OT:Enable()
		else
			DAOptMenuFrame.kick:SetAlpha(0.5)
			DAOptMenuFrame.kick:Disable()
			DAOptMenuFrame.MT:SetAlpha(0.5)
			DAOptMenuFrame.MT:Disable()
			DAOptMenuFrame.OT:SetAlpha(0.5)
			DAOptMenuFrame.OT:Disable()
		end
		DAOptMenuFrame.target:SetAlpha(1)
		DAOptMenuFrame.focus:SetAlpha(1)
		DAOptMenuFrame.target:Enable()
		DAOptMenuFrame.focus:Enable()
		
		DAOptMenuFrame.target:SetAttribute("macrotext", '/target '..name)
		DAOptMenuFrame.focus:SetAttribute("macrotext", '/focus '..name)
		
		
		if GetPartyAssignment('MAINTANK',name, 1) then
			DAOptMenuFrame.MT:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Green.blp")
			DAOptMenuFrame.OT:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight")
			
			local ottxt="/run ClearPartyAssignment('MAINTANK','"..name.."', 1);DAOptMenuFrame.ismt=false \n"
			DAOptMenuFrame.MT:SetAttribute("macrotext", ottxt)
			local ottxt2="/run if GetPartyAssignment('MAINTANK','"..name.."', 1) then ClearPartyAssignment('MAINTANK','"..name.."', 1) end;DAOptMenuFrame.ismt=false \n"; ottxt2=ottxt2.."/mainassist "..name
			DAOptMenuFrame.OT:SetAttribute("macrotext", ottxt2)
		elseif GetPartyAssignment('MAINASSIST',name, 1) then
			DAOptMenuFrame.MT:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight")
			DAOptMenuFrame.OT:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Green.blp")
			
			local ottxt="/run DAOptMenuFrame.ismt=true \n"; ottxt=ottxt.."/maintank "..name
			DAOptMenuFrame.MT:SetAttribute("macrotext", ottxt)
			local ottxt2="/run ClearPartyAssignment('MAINASSIST','"..name.."', 1) ;DAOptMenuFrame.ismt=false \n"
			DAOptMenuFrame.OT:SetAttribute("macrotext", ottxt2)
		else
			DAOptMenuFrame.MT:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight")
			DAOptMenuFrame.OT:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight")
			
			local ottxt="/run DAOptMenuFrame.ismt=true \n"; ottxt=ottxt.."/maintank "..name
			DAOptMenuFrame.MT:SetAttribute("macrotext", ottxt)
			local ottxt2="/run if GetPartyAssignment('MAINTANK','"..name.."', 1) then ClearPartyAssignment('MAINTANK','"..name.."', 1) end;DAOptMenuFrame.ismt=false \n"; ottxt2=ottxt2.."/mainassist "..name
			DAOptMenuFrame.OT:SetAttribute("macrotext", ottxt2)
		end
		
		
	end

	if UnitIsPartyLeader('player') then
		if GetLootMethod()=='master' then
			DAOptMenuFrame.lootername=false
			if GetNumRaidMembers()==0 then return end
			for i=1,GetNumRaidMembers() do
				
				local nam, _, _, _, _, _, _, _, _, _, isML = GetRaidRosterInfo(i)
				if isML then
					DAOptMenuFrame.lootername=nam
					break
				end
			end
		end
		
		DAOptMenuFrame.assist:SetAlpha(1)
		DAOptMenuFrame.assist:Enable()
		DAOptMenuFrame.looter:SetAlpha(1)
		DAOptMenuFrame.looter:Enable()
		if UnitIsPartyLeader(name) then
			DAOptMenuFrame.assist:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Red.blp")
		elseif UnitIsRaidOfficer(name) then
			DAOptMenuFrame.assist:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-UP_Green.blp")
		else
			DAOptMenuFrame.assist:SetNormalTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Highlight")
		end
		
		if GetLootMethod()=='master' and DAOptMenuFrame.lootername==name then
			if UnitIsPartyLeader(name) then
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
	
	DAOptMenuFrame.assist:Show()
	DAOptMenuFrame.looter:Show()
	
	
else
	if not InCombatLockdown() then 
		DAOptMenuFrame.target:Hide()
		DAOptMenuFrame.focus:Hide()
		DAOptMenuFrame.MT:Hide()
		DAOptMenuFrame.OT:Hide()
	end
	DAOptMenuFrame:SetSize(77,104)
	
	DAOptMenuFrame.assist:Hide()
	DAOptMenuFrame.looter:Hide()
	DAOptMenuFrame.kick:Hide()
end

DAOptMenuFrame.timerticked=0
DAOptMenuFrame.parentbtn=parent

DAOptMenuFrame.player=name
if FEP_gMain[name] then
	if DA.DecodeNote(FEP_gMain[name])=='m' or DA.DecodeNote(FEP_gMain[name])=='f' then
		DAOptMenuFrame.ofnote=name
	elseif DA.DecodeNote(FEP_gMain[name])=='t' and FEP_gMain[FEP_gMain[name]] and DA.DecodeNote(FEP_gMain[FEP_gMain[name]])=='m' then
		DAOptMenuFrame.ofnote=FEP_gMain[name]
	end
elseif FEP_L_gMain[DA_CurrentGuild][name] then
	if FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]] and DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]])=='m' then
		DAOptMenuFrame.ofnote=FEP_L_gMain[DA_CurrentGuild][name]
	end
end

if DAOptMenuFrame.player and not DAOptMenuFrame.ofnote then
	DAOptMenuFrame.altnote=name
else
	DAOptMenuFrame.altnote=nil
end

if UnitInRaid(name) then
	DAOptMenuFrame.invite:SetAlpha(0.5)
	DAOptMenuFrame.invite:Disable()
else
	DAOptMenuFrame.invite:SetAlpha(1)
	DAOptMenuFrame.invite:Enable()

end

if in_guild_backup then 
	DAOptMenuFrame.epgpaward:Disable()
	DAOptMenuFrame.GKick:Disable()
else
	DAOptMenuFrame.epgpaward:Enable()
	DAOptMenuFrame.GKick:Enable()
end

DAOptMenuFrame:Show()
DA.ResumeTimer('OptHider')

DAOptMenuFrame:ClearAllPoints()

end

function DA.SelectGuildMember(name,wipe)
	if name then
		if DA.Players_Selected[name] then
			DA.Players_Selected[name]=nil
		else
			DA.Players_Selected[name]=true
		end
		DarkAngelGUI.Guild.lastselected=name
		
	elseif wipe then
		table.wipe(DA.Players_Selected)
		DarkAngelGUI.Guild.lastselected=nil
		
	end

end
function DA.SelectGMembersInRange(Name_1, Name_2)
	local found_1
	local found_2
	local list={}
	
	local changeprev = DA.Players_Selected[Name_2]
	
	for _,player in ipairs(DA_G_Processed) do
		local name = player.plname
		
		if name==Name_1 then
		
			found_1=true
			if changeprev then
				tinsert(list, name)
			end
		elseif name==Name_2 then
			found_2=true
			tinsert(list, name)
		elseif found_1 and found_2 then
			break
		elseif found_1 or found_2 then
			tinsert(list, name)
		end
	end
	
	if found_1 and found_2 then
		for _,name in ipairs(list) do
			DA.SelectGuildMember(name)
		end
	end

end

function DA.RePaintFrames()
local alpha=fuckingOptions.txt1op
local beta=fuckingOptions.txt2op;
local blend1=fuckingOptions.txt1extra; if blend1 then blend1='add' else blend1='blend' end
local blend2=fuckingOptions.txt2extra; if blend2 then blend2='add' else blend2='blend' end

local function getNestedFrame(path)
    local current = _G
    for nested in path:gmatch("[^%.]+") do
        current = current[nested]
        if not current then
            return nil
        end
    end
    return current
end

	for n,t in pairs(_G["DarkAngelGUI"]['tabsl']) do
		_G['DarkAngelGUI'][_G["DarkAngelGUI"]['tabsl'][n]].t:SetBlendMode(blend1)
		_G['DarkAngelGUI'][_G["DarkAngelGUI"]['tabsl'][n]].t:SetAlpha(alpha)
		_G['DarkAngelGUI'][_G["DarkAngelGUI"]['tabsl'][n]].add.t:SetBlendMode(blend2)
		_G['DarkAngelGUI'][_G["DarkAngelGUI"]['tabsl'][n]].add.t:SetTexture(8/255, 12/255, 20/255, beta)
		
	end
	
	for i,data in ipairs({'DarkAngelGUI.Guild.micromenu','DarkAngelGUI.Guild.bulkmenu','DA_Inviter','DA_Flasker.FlaskDispenser','DA_Flasker.optionsFrame','DA_Awarder'}) do
		local mainFrame = getNestedFrame(data)
		local addFrame = mainFrame and mainFrame.add

		if mainFrame and mainFrame.t then
			if not addFrame then
				mainFrame.t:SetBlendMode(blend2)
				mainFrame.t:SetTexture(8/255, 12/255, 20/255, beta)
			else
				mainFrame.t:SetBlendMode(blend1)
				mainFrame.t:SetAlpha(alpha)
			end
		end
		if addFrame and addFrame.t then
			addFrame.t:SetBlendMode(blend2)
			addFrame.t:SetTexture(8/255, 12/255, 20/255, beta)
		end
		
	
	end
	
	
end
function DA.Retwink()



local assignedto,_=DarkAngelGUI.Guild.bulkmenu.assignedto:GetText():gsub("%s","")
	if not assignedto then
		DA.Print('[|cffffa0a0ERROR|r] please specify any name for \"assigned to\"')
		DarkAngelGUI.Guild.bulkmenu.retvgobtn:Enable()
		return
	elseif not FEP_gMain[assignedto] then
		DA.Print('[|cffffa0a0ERROR|r] '..assignedto..' not found in guild')
		DarkAngelGUI.Guild.bulkmenu.retvgobtn:Enable()
		return
	end

local newmain,_=DarkAngelGUI.Guild.bulkmenu.newmain:GetText():gsub("%s","")
	if not newmain then
		DA.Print('[|cffffa0a0ERROR|r] please specify any name for \"new main\"')
		DarkAngelGUI.Guild.bulkmenu.retvgobtn:Enable()
		return
	elseif not FEP_gMain[newmain] then
		DA.Print('[|cffffa0a0ERROR|r] '..newmain..' not found in guild')
		DarkAngelGUI.Guild.bulkmenu.retvgobtn:Enable()
		return
	elseif assignedto==newmain then
		DA.Print('[|cffffa0a0ERROR|r] stupid :) ???? ')
		DarkAngelGUI.Guild.bulkmenu.retvgobtn:Enable()
		return
	end
	
local changingmain=DarkAngelGUI.Guild.bulkmenu.ismakingnewmain:GetChecked()
local assignedEP
if changingmain then
	
	if not (DA.DecodeNote(FEP_gMain[assignedto])=="m" or DA.DecodeNote(FEP_gMain[assignedto])=="f") then
		DA.Print('[|cffffa0a0ERROR|r] [Main change] '..assignedto.." "..L["is not main"])
		DarkAngelGUI.Guild.bulkmenu.retvgobtn:Enable()
		return
	elseif (DA.DecodeNote(FEP_gMain[newmain])=="m" or DA.DecodeNote(FEP_gMain[newmain])=="f") then
		if FEP_gMain[newmain]=="" and FEP_gMain[assignedto]=="" then
			assignedEP=""
		elseif FEP_gMain[newmain]=="" then
			assignedEP=FEP_gMain[assignedto]
		elseif FEP_gMain[assignedto]=="" then
			assignedEP=FEP_gMain[newmain]
		else
			DA.Print("[|cff0088ffINFO|r] "..assignedto..","..newmain.." -"..L["mains merged"])
			local _,a,b,c=DA.DecodeNote(FEP_gMain[assignedto])
			local _,na,nb,nc=DA.DecodeNote(FEP_gMain[newmain])
			if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
				assignedEP=a+na..","..b+nb
			elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
				assignedEP="Net:"..a+na.." Tot:"..b+nb..( ((c or nc) and " Hrs:"..c+nc) or "")
			end
		end
	else
		assignedEP=FEP_gMain[assignedto]
	end
end

---local binds
for i,p in pairs(FEP_L_gMain[DA_CurrentGuild]) do
	if p==assignedto then
		FEP_L_gMain[DA_CurrentGuild][i]=newmain
	end
end

---guild shit
for i=1,DA.GetNumGMembers() do
	local name, _, _, _, _, _, _, officernote, _, _, _ = GetGuildRosterInfo(i);
	if name then
		if name==newmain and changingmain and assignedEP then
			DA.SetOfficernote(name,tostring(assignedEP))
			DA.Print('[|cff00ffa0SUCCESS|r] Mained '..name..' assigned '..assignedEP)
		
		elseif name==assignedto and changingmain and assignedEP then
			DA.SetOfficernote(name,tostring(newmain))
			DA.Print('[|cff00ffa0SUCCESS|r] Old main '..name..' tvined')
			
		elseif officernote==assignedto then
			DA.SetOfficernote(name,tostring(newmain))
			DA.Print('[|cff00ffa0SUCCESS|r] Retvined '..name)
		
		

		end
		
	end
end

DA.UpdateMicroMenu()
		

tinsert(DA_Fep_bulk,function() end)
tinsert(DA_Fep_bulk,function() DA.RegatherGuildNotes() end)
tinsert(DA_Fep_bulk,function() end)
tinsert(DA_Fep_bulk,function() DA.UpdateMicroMenu();DarkAngelGUI.Guild.bulkmenu.retvgobtn:Enable() end)
DA.ResumeTimer('fep')

end
function DA.SetPublicnote(player,note)
	GuildRosterSetPublicNote(DA.GetPlayerGuildIndex(player), tostring(note) )
end
function DA.SetOfficernote(player,note)
	GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(player), tostring(note) )
end

local function FFG_get_dump(o)
   if type(o) == 'table' then
	  local s = {}
	  for k,v in pairs(o) do
		 table.insert(s,{k, FFG_get_dump(v)})
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
local function FFG_process_dump(data2, phrase,num)

	local data = FFG_get_dump(data2)
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
local function FFG_guy_ButtonFill(num, player, short,frame,noteeb,customwnd,notetype)
	
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

	local dump=FFG_process_dump(_G[dataname], text, entries or 10)
	
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
			FFG_guy_ButtonFill(i,dump[i],short,frame,noteeb,customwnd,notetype)

		end
		frame:SetSize(170,12+(#dump)*12)
	end


end

FFGGuildArray={}

local function remove_color_codes(a)
	return "|cff575757"..a:gsub("%|c........", "")
end
local function resort_gdata(data)
local mode=fuckingOptions.gsort
if mode=="-no sort-" 
or (DarkAngelGuild.custom_mode and (mode=="online" or mode=="level")) then 
	return 
end
local onlineFirst=fuckingOptions.onlineFirst
local reverseSort=fuckingOptions.reverseSort

if mode=="online" then
	do
	if onlineFirst then
		if reverseSort then
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[1] > b[1]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a.offlinecounter > b.offlinecounter
				end
			end)
		else
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[1] < b[1]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a.offlinecounter < b.offlinecounter
				end
			end)
		end
	else
		if reverseSort then
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[1] > b[1]
				elseif a[7] == "online" then
					return false
				elseif b[7] == "online" then
					return true
				else
					return a.offlinecounter > b.offlinecounter
				end
			end)
		else
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[1] < b[1]
				elseif a[7] == "online" then
					return false
				elseif b[7] == "online" then
					return true
				else
					return a.offlinecounter < b.offlinecounter
				end
			end)
		end
	end
	end
elseif mode=="name" then
	do
	if onlineFirst then
		if reverseSort then
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[1] > b[1]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a[1] > b[1]
				end
			end)
		else
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[1] < b[1]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a[1] < b[1]
				end
			end)
		end
	else
		if reverseSort then
			table.sort(data,function(a,b)
				return a[1] > b[1]
			end)
		else
			table.sort(data,function(a,b)
				return a[1] < b[1]
			end)
		end
	end
	end
elseif mode=="rank" then
	do
	if onlineFirst then
		if reverseSort then
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[5][1] > b[5][1]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a[5][1] > b[5][1]
				end
			end)
		else
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[5][1] < b[5][1]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a[5][1] < b[5][1]
				end
			end)
		end
	else
		if reverseSort then
			table.sort(data,function(a,b)
				return a[5][1] > b[5][1]
			end)
		else
			table.sort(data,function(a,b)
				return a[5][1] < b[5][1]
			end)
		end
	end
	end
elseif mode=="note" then
	do
	if onlineFirst then
		if reverseSort then
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[3] > b[3]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a[3] > b[3]
				end
			end)
		else
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[3] < b[3]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a[3] < b[3]
				end
			end)
		end
	else
		if reverseSort then
			table.sort(data,function(a,b)
				return a[3] > b[3]
			end)
		else
			table.sort(data,function(a,b)
				return a[3] < b[3]
			end)
		end
	end
	end
elseif mode=="offic.note" then
	do
	if onlineFirst then
		if reverseSort then
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[4][1] > b[4][1]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a[4][1] > b[4][1]
				end
			end)
		else
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[4][1] < b[4][1]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a[4][1] < b[4][1]
				end
			end)
		end
	else
		if reverseSort then
			table.sort(data,function(a,b)
				return a[4][1] > b[4][1]
			end)
		else
			table.sort(data,function(a,b)
				return a[4][1] < b[4][1]
			end)
		end
	end
	end
elseif mode=="level" then
	do
	if onlineFirst then
		if reverseSort then
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[2] > b[2]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a[2] > b[2]
				end
			end)
		else
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[2] < b[2]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a[2] < b[2]
				end
			end)
		end
	else
		if reverseSort then
			table.sort(data,function(a,b)
				return a[2] > b[2]
			end)
		else
			table.sort(data,function(a,b)
				return a[2] < b[2]
			end)
		end
	end
	end
elseif mode=="class" then
	do
	if onlineFirst then
		if reverseSort then
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[6] > b[6]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a[6] > b[6]
				end
			end)
		else
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					return a[6] < b[6]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					if not a[6] and not b[6] then
						return nil
					else
						return a[6] < b[6]
					end
				end
			end)
		end
	else
		if reverseSort then
			table.sort(data,function(a,b)
				return a[6] > b[6]
			end)
		else
			table.sort(data,function(a,b)
				return a[6] < b[6]
			end)
		end
	end
	end
elseif mode=="online:tvin groups" then
	do
	
    local groups = {}
    
    for _, player in ipairs(data) do
		local typ,ep,gp,_=DA.DecodeNote(player[4][1])
        
        if typ=='t' and not groups[ep] then
            groups[ep] = { main = nil, alts = {} }
		elseif (typ=='m' or typ=='f') and not groups[player[1]] then
			groups[player[1]] = { main = player, alts = {} }
        end
        
        if typ=='m' or typ=='f' then
            groups[player[1]].main = player
        elseif typ=='t' then
            table.insert(groups[ep].alts, player)
        end
    end
	    
    for _, group in pairs(groups) do
            table.sort(group.alts, function(a,b) 
				if a[7] == "online" and b[7] == "online" then
					return a[1] < b[1]
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					return a.offlinecounter < b.offlinecounter
				end
			end)
			
			if group.main and group.main[7] == "online" then
				group.lastonline="online"
			elseif group.alts[1] and group.alts[1][7] == "online" then
				group.lastonline="online"
			elseif group.main and not group.alts[1] then
				group.lastonline=group.main.offlinecounter
			elseif group.alts[1] then
				if group.main and group.main.offlinecounter < group.alts[1].offlinecounter then
					group.lastonline=group.main.offlinecounter
				else
					group.lastonline=group.alts[1].offlinecounter
				end
			end
    end
	HSFHSFSDSDFSDFSDF=groups
	local groupsArray = {}
	for _, group in pairs(groups) do
		table.insert(groupsArray, group)
	end
	
	if reverseSort then
		table.sort(groupsArray,function(a, b)
			if a.lastonline == "online" and b.lastonline == "online" then
				return (a.main or a.alts[1])[1]> (b.main or b.alts[1])[1]
			elseif a.lastonline == "online" then
				return false
			elseif b.lastonline == "online" then
				return true
			else
				return a.lastonline > b.lastonline
			end
		end)
	else
		table.sort(groupsArray,function(a, b)
			if a.lastonline == "online" and b.lastonline == "online" then
				return (a.main or a.alts[1])[1] < (b.main or b.alts[1])[1]
			elseif a.lastonline == "online" then
				return true
			elseif b.lastonline == "online" then
				return false
			else
				return a.lastonline < b.lastonline
			end
		end)
	end
	
	local sortedPlayers = {}
	for _, group in pairs(groupsArray) do
		if group.main then
			if group.main[7] == "online" then
			elseif group.lastonline==group.main.offlinecounter then
			else
				group.main[7] = remove_color_codes(group.main[7])
			end
			
			table.insert(sortedPlayers, group.main)
		end
		for _, alt in ipairs(group.alts) do
			if alt[7] == "online" then
			elseif group.lastonline==alt.offlinecounter then
			else
				alt[7] = remove_color_codes(alt[7])
			end
			table.insert(sortedPlayers, alt)
		end
	end
	
    
    FFGGuildArray = sortedPlayers


	end
elseif mode=="EPGP:EP" or mode=="DKP:Net" then
	do
	if onlineFirst then
		if reverseSort then
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
						return a_ep < b_ep
					elseif (a_typ=="m" or a_typ=="f") then
						return true
					elseif (b_typ=="m" or b_typ=="f") then
						return false
					else
						return nil
					end
					
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
						return a_ep < b_ep
					elseif (a_typ=="m" or a_typ=="f") then
						return true
					elseif (b_typ=="m" or b_typ=="f") then
						return false
					else
						return nil
					end
				end
			end)
		else
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
						return a_ep > b_ep
					elseif (a_typ=="m" or a_typ=="f") then
						return true
					elseif (b_typ=="m" or b_typ=="f") then
						return false
					else
						return nil
					end
					
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
						return a_ep > b_ep
					elseif (a_typ=="m" or a_typ=="f") then
						return true
					elseif (b_typ=="m" or b_typ=="f") then
						return false
					else
						return nil
					end
				end
			end)
		end
	else
		if reverseSort then
			table.sort(data,function(a,b)
				local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
				local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
				
				if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
					return a_ep < b_ep
				elseif (a_typ=="m" or a_typ=="f") then
					return true
				elseif (b_typ=="m" or b_typ=="f") then
					return false
				else
					return nil
				end
			end)
		else
			table.sort(data,function(a,b)
				local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
				local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
				
				if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
					return a_ep > b_ep
				elseif (a_typ=="m" or a_typ=="f") then
					return true
				elseif (b_typ=="m" or b_typ=="f") then
					return false
				else
					return nil
				end
			end)
		end
	end
	end
elseif mode=="EPGP:GP" or mode=="DKP:Total" then
	do
	if onlineFirst then
		if reverseSort then
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
						return a_gp < b_gp
					elseif (a_typ=="m" or a_typ=="f") then
						return true
					elseif (b_typ=="m" or b_typ=="f") then
						return false
					else
						return nil
					end
					
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
						return a_gp < b_gp
					elseif (a_typ=="m" or a_typ=="f") then
						return true
					elseif (b_typ=="m" or b_typ=="f") then
						return false
					else
						return nil
					end
				end
			end)
		else
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
						return a_gp > b_gp
					elseif (a_typ=="m" or a_typ=="f") then
						return true
					elseif (b_typ=="m" or b_typ=="f") then
						return false
					else
						return nil
					end
					
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
						return a_gp > b_gp
					elseif (a_typ=="m" or a_typ=="f") then
						return true
					elseif (b_typ=="m" or b_typ=="f") then
						return false
					else
						return nil
					end
				end
			end)
		end
	else
		if reverseSort then
			table.sort(data,function(a,b)
				local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
				local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
				
				if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
					return a_gp < b_gp
				elseif (a_typ=="m" or a_typ=="f") then
					return true
				elseif (b_typ=="m" or b_typ=="f") then
					return false
				else
					return nil
				end
			end)
		else
			table.sort(data,function(a,b)
				local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
				local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
				
				if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
					return a_gp > b_gp
				elseif (a_typ=="m" or a_typ=="f") then
					return true
				elseif (b_typ=="m" or b_typ=="f") then
					return false
				else
					return nil
				end
			end)
		end
	end
	end
elseif mode=="EPGP:PR" then
	do
	local minep=DA_Guild_Info[DA_CurrentGuild].minep1
	local base=DA_Guild_Info[DA_CurrentGuild].base1
	if onlineFirst then
		if reverseSort then
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if ((a_typ=="m" or a_typ=="f") and a_ep>=minep) and ((b_typ=="m" or b_typ=="f") and b_ep>=minep) then
						return (a_ep/a_gp+base) < (b_ep/b_gp+base)
					elseif ((a_typ=="m" or a_typ=="f") and a_ep>=minep) then
						return true
					elseif ((b_typ=="m" or b_typ=="f") and b_ep>=minep)then
						return false
					else
						return nil
					end
					
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if ((a_typ=="m" or a_typ=="f") and a_ep>=minep) and ((b_typ=="m" or b_typ=="f") and b_ep>=minep) then
						return (a_ep/a_gp+base) < (b_ep/b_gp+base)
					elseif ((a_typ=="m" or a_typ=="f") and a_ep>=minep) then
						return true
					elseif ((b_typ=="m" or b_typ=="f") and b_ep>=minep)then
						return false
					else
						return nil
					end
				end
			end)
		else
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if ((a_typ=="m" or a_typ=="f") and a_ep>=minep) and ((b_typ=="m" or b_typ=="f") and b_ep>=minep) then
						return (a_ep/a_gp+base) > (b_ep/b_gp+base)
					elseif ((a_typ=="m" or a_typ=="f") and a_ep>=minep) then
						return true
					elseif ((b_typ=="m" or b_typ=="f") and b_ep>=minep)then
						return false
					else
						return nil
					end
					
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if ((a_typ=="m" or a_typ=="f") and a_ep>=minep) and ((b_typ=="m" or b_typ=="f") and b_ep>=minep) then
						return (a_ep/a_gp+base) > (b_ep/b_gp+base)
					elseif ((a_typ=="m" or a_typ=="f") and a_ep>=minep) then
						return true
					elseif ((b_typ=="m" or b_typ=="f") and b_ep>=minep)then
						return false
					else
						return nil
					end
				end
			end)
		end
	else
		if reverseSort then
			table.sort(data,function(a,b)
				local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
				local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
				
				if ((a_typ=="m" or a_typ=="f") and a_ep>=minep) and ((b_typ=="m" or b_typ=="f") and b_ep>=minep) then
					return (a_ep/a_gp+base) < (b_ep/b_gp+base)
				elseif ((a_typ=="m" or a_typ=="f") and a_ep>=minep) then
					return true
				elseif ((b_typ=="m" or b_typ=="f") and b_ep>=minep)then
					return false
				else
					return nil
				end
			end)
		else
			table.sort(data,function(a,b)
				local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
				local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
				
				if ((a_typ=="m" or a_typ=="f") and a_ep>=minep) and ((b_typ=="m" or b_typ=="f") and b_ep>=minep) then
					return (a_ep/a_gp+base) > (b_ep/b_gp+base)
				elseif ((a_typ=="m" or a_typ=="f") and a_ep>=minep) then
					return true
				elseif ((b_typ=="m" or b_typ=="f") and b_ep>=minep)then
					return false
				else
					return nil
				end
			end)
		end
	end
	end
elseif mode=="DKP:Hours" then
	do
	if onlineFirst then
		if reverseSort then
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
						return (a_hrs or 0) < (b_hrs or 0)
					elseif (a_typ=="m" or a_typ=="f") then
						return true
					elseif (b_typ=="m" or b_typ=="f") then
						return false
					else
						return nil
					end
					
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
						return (a_hrs or 0) < (b_hrs or 0)
					elseif (a_typ=="m" or a_typ=="f") then
						return true
					elseif (b_typ=="m" or b_typ=="f") then
						return false
					else
						return nil
					end
				end
			end)
		else
			table.sort(data,function(a,b)
				if a[7] == "online" and b[7] == "online" then
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
						return (a_hrs or 0) > (b_hrs or 0)
					elseif (a_typ=="m" or a_typ=="f") then
						return true
					elseif (b_typ=="m" or b_typ=="f") then
						return false
					else
						return nil
					end
					
				elseif a[7] == "online" then
					return true
				elseif b[7] == "online" then
					return false
				else
					local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
					
					if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
						return (a_hrs or 0) > (b_hrs or 0)
					elseif (a_typ=="m" or a_typ=="f") then
						return true
					elseif (b_typ=="m" or b_typ=="f") then
						return false
					else
						return nil
					end
				end
			end)
		end
	else
		if reverseSort then
			table.sort(data,function(a,b)
				local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
				local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
				
				if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
					return (a_hrs or 0) < (b_hrs or 0)
				elseif (a_typ=="m" or a_typ=="f") then
					return true
				elseif (b_typ=="m" or b_typ=="f") then
					return false
				else
					return nil
				end
			end)
		else
			table.sort(data,function(a,b)
				local a_typ,a_ep,a_gp,a_hrs=DA.DecodeNote(a[4][1])
				local b_typ,b_ep,b_gp,b_hrs=DA.DecodeNote(b[4][1])
				
				if (a_typ=="m" or a_typ=="f") and (b_typ=="m" or b_typ=="f") then
					return (a_hrs or 0) > (b_hrs or 0)
				elseif (a_typ=="m" or a_typ=="f") then
					return true
				elseif (b_typ=="m" or b_typ=="f") then
					return false
				else
					return nil
				end
			end)
		end
	end
	end
	
end


end
local function microdatapattern(a)
	if not a then return nil end
	
	if type(a)=="string" then
		if #a==2 then
			return a
		else
			return "0"..a
		end
	elseif type(a)=="number" then
		if a>=10 then
			return a
		else
			return "0"..a
		end
	end
end
-- local inittimetaken
local function get_RankNameFromBackupRankID(id)
	return DA_Unpacked.guildranks[id+1].name
end
local function get_RankStuffFromBackup(rankID,max_rank)
	rankID=tonumber(rankID)
	if max_rank>=rankID+1 then
		return {dat.rank, get_RankNameFromBackupRankID(dat.rank)}
	else
		return {dat.rank, "<N/A rank>", true}
	end
end
function DA.GetGuildData(initiate)
if DA_CurrentGuild~="n0-guild" then else return end
-- inittimetaken=GetTime()
if initiate or not DarkAngelGuild.custom_mode then
else
	return
end
local gtype
table.wipe(FFGGuildArray)

	if DarkAngelGuild.custom_mode then
		gtype=DA.DetermineDKPorEPGPguild(1)
		
		if DA_Unpacked.guildranks then
			local max_rank=#DA_Unpacked.guildranks
			
			for name,dat in pairs(DA_Unpacked.pl_data) do
				tinsert(FFGGuildArray,{name,"",dat.note,{dat.ofnote,DA.GetColorUnpackedName(dat.ofnote,1,gtype)},get_RankStuffFromBackup(dat.rank,max_rank),dat.class,""  , offlinecounter="00000000"})
			end
		else
			for name,dat in pairs(DA_Unpacked.pl_data) do
				tinsert(FFGGuildArray,{name,"",dat.note,{dat.ofnote,DA.GetColorUnpackedName(dat.ofnote,1,gtype)},{dat.rank,""},dat.class,""  , offlinecounter="00000000"})
			end
		end
	
	else
		local max_rank=GuildControlGetNumRanks()-1
		for i=1,DA.GetNumGMembers() do
			local name, rank, rankIndex, level, _, _, note, officernote, online, _, class = GetGuildRosterInfo(i);
			
			if not rank or rank=="" then rank="<N/A rank>" end
			
			if name and ((fuckingOptions.showonl and online) or (fuckingOptions.showoffl and not online)) then
				if online then
					tinsert(FFGGuildArray,{name,level,note,{officernote,DA.GetColorName(officernote,1)},{rankIndex,rank,rankIndex>max_rank},class,'online'})
				else
					local y, m, d, h = GetGuildRosterLastOnline(i);
					if y==0 and m==0 and d==0 and h==0 then
						tinsert(FFGGuildArray,{name,level,note,{officernote,DA.GetColorName(officernote,1)},{rankIndex,rank,rankIndex>max_rank},class, ('|cffffafaf<h'), offlinecounter="00000000"})
					else
						local offlinecounter=((microdatapattern(y) or "00")..(microdatapattern(m) or "00")..(microdatapattern(d) or "00")..(microdatapattern(h) or "00"))
						if y==0 then y=nil else h=nil end
						if m==0 then m=nil else h=nil end
						if d==0 then d=nil end
						if h==0 then h=nil end
						
						tinsert(FFGGuildArray,{name,level,note,{officernote,DA.GetColorName(officernote,1)},
							{rankIndex,rank,rankIndex>max_rank},class, (((y and '|cffff0000'..y..'y') or "")..((m and '|cffff5555'..m..'m') or "")..((d and '|cffff8f8f'..d..'d') or "")..((h and '|cffffafaf'..h..'h') or "")), 
						offlinecounter=offlinecounter })
					
					end
				end
			end
		end
	end
	resort_gdata(FFGGuildArray)
	
	if fuckingOptions.showlocals then
		if DarkAngelGuild.custom_mode then
			if DA_Unpacked.localtvins then
				for player,main in pairs(DA_Unpacked.localtvins) do
					-- tinsert(FFGGuildArray,{name,"",dat.note,{dat.ofnote,DA.GetColorName(dat.ofnote,1)},{dat.rank,""},dat.class,""  , offlinecounter="00000000"})
					tinsert(FFGGuildArray,{player,"","|cff55ffff_local",{main,DA.GetColorUnpackedName(main,1,gtype)},{"local",""},""})
				end
			end
		else
			for player,main in pairs(FEP_L_gMain[DA_CurrentGuild]) do
				tinsert(FFGGuildArray,{player,"","|cff55ffff_local",{main,DA.GetColorName(main,1)},{"local",""},""})
			end
		end
	end
end
function DA.DemotePromotePlayer(name,curentrank,i,isbulk)
if isbulk then
else
i=i-1
end
local myrank=tonumber(({GetGuildInfo('player')})[3])
if myrank==curentrank then
	if isbulk then
		DA.Print(name.." "..L['same rank as me'])
		return
	else
		DA.Print(L['target on the same rank as me'])
		return
	end
elseif i<=myrank then
	DA.Print(L['requested rank is too high'])
	return
elseif myrank<curentrank then 
	if i<curentrank then 
		if CanGuildPromote() then else DA.Print(L['I cannot promote players']) return end
		--promoting
		for r=1,curentrank-i do
			GuildPromote(name)
		end
		if not isbulk then
			tinsert(DA_Fep_bulk,function() end)
			tinsert(DA_Fep_bulk,function() DA.UpdateMicroMenu() end)
			tinsert(DA_Fep_bulk,function() DA.UpdateMicroMenu() end)
			DA.ResumeTimer('fep')
		end
		return
	elseif i==curentrank then
		if not isbulk then
			DA.Print(L['already this rank'])
		end
		return
	elseif i>curentrank then
		if CanGuildDemote() then else DA.Print(L['I cannot demote players']) return end
		--demoting
		for r=1,i-curentrank do
			GuildDemote(name)
		end
		if not isbulk then
			tinsert(DA_Fep_bulk,function() end)
			tinsert(DA_Fep_bulk,function() DA.UpdateMicroMenu() end)
			tinsert(DA_Fep_bulk,function() DA.UpdateMicroMenu() end)
			DA.ResumeTimer('fep')
		end
		return
	else
		print('error 900')
		return
	end
elseif myrank>curentrank then
	DA.Print(L['target is having a higher rank than me'])
	return
else
print('error 908')
return
	
end
	
end
function DA.UpdateMicroMenu(typ)
	tinsert(DA_Fep_bulk,function() DA.GetGuildData() end)
	tinsert(DA_Fep_bulk,function() DA.GuildSetAllLines() end)
	tinsert(DA_Fep_bulk,function() 
		if DarkAngelGUI.Guild.micromenu:IsShown() then
			for i=1,DA.GetNumGMembers() do
				local name, rank, rankIndex, level, _, _, note, officernote, _, _, class = GetGuildRosterInfo(i);
				if name and name==DarkAngelGUI.Guild.micromenu.plbox:GetText() then
					if not typ then
						DarkAngelGUI.Guild.micromenu.ranksmenubtn.fs:SetText("["..rankIndex.."]"..rank)
						DarkAngelGUI.Guild.micromenu.ranksmenubtn.realrankid=rankIndex
						RanksFrameUpd()
						DarkAngelGUI.Guild.micromenu.notebox:SetText(note)
						DarkAngelGUI.Guild.micromenu.notebox.orignote=note
						DarkAngelGUI.Guild.micromenu.ofnotebox:SetText(officernote)
						DarkAngelGUI.Guild.micromenu.ofnotebox.orignote=officernote
						return
					elseif typ=='plrankID' then
						DarkAngelGUI.Guild.micromenu.ranksmenubtn.fs:SetText("["..rankIndex.."]"..rank)
						DarkAngelGUI.Guild.micromenu.ranksmenubtn.realrankid=rankIndex
						RanksFrameUpd()
						return
					elseif typ=='notebox' then
						DarkAngelGUI.Guild.micromenu.notebox:SetText(note)
						DarkAngelGUI.Guild.micromenu.notebox.orignote=note
						return
					elseif typ=='ofnotebox' then
						DarkAngelGUI.Guild.micromenu.ofnotebox:SetText(officernote)
						DarkAngelGUI.Guild.micromenu.ofnotebox.orignote=officernote
						return
					end
				end
			end
		end
	end)
	DA.ResumeTimer('fep')

end


local function checker(s,x)
	local a=string.lower(s)
	if a:find(string.lower(x)) then
		return true
	end
	
end
local function mathchecker(s,x)
	local countera=0
	local counterb=0
	for sy in string.gmatch(x,'.') do
		if string.find(sy,"<") then
			countera=countera+1
		end
		if string.find(sy,">") then
			counterb=counterb+1
		end
	end
	if countera==0 and counterb==0 then
		return checker(s,x)
	elseif countera<2 and counterb<2 then
		if countera==1 and counterb==1 and tonumber(s) and tonumber(string.match(x,'%>(%d+)')) and tonumber(s)>=tonumber(string.match(x,'%>(%d+)')) and tonumber(string.match(x,'%<(%d+)')) and tonumber(s)<=tonumber(string.match(x,'%<(%d+)')) then
			return true
		elseif countera==1 and counterb==0 and tonumber(s) and tonumber(string.match(x,'%<(%d+)')) and tonumber(s)<=tonumber(string.match(x,'%<(%d+)')) then
			return true
		elseif countera==0 and counterb==1 and tonumber(s) and tonumber(string.match(x,'%>(%d+)')) and tonumber(s)>=tonumber(string.match(x,'%>(%d+)')) then
			return true
		else
			return checker(s,x)
		end
	else
		return checker(s,x)
	end
	
end

local function sanitizeInput(value)
	if value and #value == 1 and (value == "%" or value == "[") then
		return nil
	end
	return value
end
function DA.GuildSearchTec(eb_name, eb_lvl, eb_note, eb_offnote, eb_rank, eb_online)
    local data = FFGGuildArray
    local result = {}
    local lightscan
	

    eb_name = sanitizeInput(eb_name)
    eb_lvl = sanitizeInput(eb_lvl)
    eb_note = sanitizeInput(eb_note)
    eb_offnote = sanitizeInput(eb_offnote)
    eb_rank = sanitizeInput(eb_rank)
    eb_online = sanitizeInput(eb_online)
	
	local classTbl = DarkAngelGUI.Guild.classTbl
    local anyclass = next(classTbl) and true or false
	
    -- If no filters are applied, return all data unfiltered
    if not (eb_name or eb_lvl or eb_note or eb_offnote or eb_rank or eb_online or anyclass) then
        return data
    end

    local datacount = #data

    -- Preprocess eb_rank and eb_online to avoid repeated function calls
    local lower_eb_rank = eb_rank and string.lower(eb_rank)
    local lower_eb_online = eb_online and string.lower(eb_online)

    local preciseMatch = fuckingOptions.precisematchsearch

	for i = 1, datacount do
		local entry=data[i]
		
		if 
		(preciseMatch and
			(not eb_name or checker(entry[1], eb_name)) and
			(not eb_lvl or mathchecker(entry[2], eb_lvl)) and
			(not eb_note or mathchecker(entry[3], eb_note)) and
			(not eb_offnote or mathchecker(entry[4][2], eb_offnote)) and
			(not eb_rank or string.lower(string.gsub(entry[5][1], "\"", "")):find(lower_eb_rank) or
						  string.lower(string.gsub(entry[5][2], "\"", "")):find(lower_eb_rank) or
						  mathchecker(entry[5][1], eb_rank)) and
			(not eb_online or 
				(entry[5][1] ~= 'local' and
					string.lower(string.gsub(entry[7], "\"", "")):find(lower_eb_online))) and
			(not anyclass or
				classTbl[entry[6]])
			)
		or 
		   ((eb_name and checker(entry[1], eb_name)) or
			(eb_lvl and mathchecker(entry[2], eb_lvl)) or
			(eb_note and mathchecker(entry[3], eb_note)) or
			(eb_offnote and mathchecker(entry[4][2], eb_offnote)) or
			(eb_rank and (string.lower(string.gsub(entry[5][1], "\"", "")):find(lower_eb_rank) or
						  string.lower(string.gsub(entry[5][2], "\"", "")):find(lower_eb_rank) or
						  mathchecker(entry[5][1], eb_rank))) or
			(eb_online and 
				(entry[5][1] ~= 'local' and
					string.lower(string.gsub(entry[7], "\"", "")):find(lower_eb_online))) or
			(anyclass and
				classTbl[entry[6]])
			)
		then
			result[#result + 1] = entry
		end
	end
	

    return #result > 0 and result or 0
end

local function numonlpl(dump)
	if DarkAngelGuild.custom_mode then
		local playerscounter=0
		local localscounter=0
		for _,t in pairs(dump) do
			if t[5] and t[5][1] and t[5][1]=='local' then
				localscounter=localscounter+1
			elseif t[7] then
				playerscounter=playerscounter+1
			end
		end
		if playerscounter>0 then
			if localscounter>0 then
				return "(|cfffff53b"..playerscounter.."|r players |cff3ce6e6"..localscounter.."|r locals)"
			else
				return "players"
			end
		elseif localscounter>0 then
			return "locals"
		end
	else
		if fuckingOptions.showonl and fuckingOptions.showoffl then
			local onlcounter=0
			local offlcounter=0
			local localscounter=0
			for _,t in pairs(dump) do
				if t[5] and t[5][1] and t[5][1]=='local' then
					localscounter=localscounter+1
				elseif t[7] and t[7]=='online' then
					onlcounter=onlcounter+1
				elseif t[7] then
					offlcounter=offlcounter+1
				end
			end
			if onlcounter>0 and offlcounter>0 then
				if localscounter>0 then
					return "(|cff09f505"..onlcounter.."|r online |cfffff53b"..offlcounter.."|r offline |cff3ce6e6"..localscounter.."|r locals)"
				else
					return "(|cff09f505"..onlcounter.."|r online |cfffff53b"..offlcounter.."|r offline)"
				end
			elseif onlcounter>0 then
				if localscounter>0 then
					return "(|cff09f505"..onlcounter.."|r online |cff3ce6e6"..localscounter.."|r locals)"
				else
					return "online"
				end
			elseif offlcounter>0 then
				if localscounter>0 then
					return "(|cfffff53b"..offlcounter.."|r offline |cff3ce6e6"..localscounter.."|r locals)"
				else
					return "offline"
				end
			elseif localscounter>0 then
				return "locals"
			end
		elseif not fuckingOptions.showonl and fuckingOptions.showoffl then
			return "offline"
		elseif fuckingOptions.showonl and not fuckingOptions.showoffl then
			return "online"
		else
			return "(|cffff3b5fno online/offline specified|r)"
		end
	end
end

function DA.GuildSetAllLines()
if DA_CurrentGuild~="n0-guild" then else return end
DarkAngelGuild.timerticked=0
DarkAngelGuild.scrolled=false
DarkAngelGuild.btnshidden=false

local eb={}
for r=1,5 do
	local ebt = DarkAngelGUI.Guild["EB"..r]:GetText()
	if ebt~="" then
		eb[r]=ebt
		DarkAngelGUI.Guild["EB"..r].t:SetBlendMode("BLEND")
	else
		DarkAngelGUI.Guild["EB"..r].t:SetBlendMode("ADD")
	end
end

if DarkAngelGuild.custom_mode then

elseif not fuckingOptions.showonl and not fuckingOptions.showoffl then
	DarkAngelGUI.Guild.foundtext:SetText("found |cffffaaff0|r players (|cffff3b5fno online/offline specified|r)")
	return
end
		
local dump,foundd
if fuckingOptions.gcut=='infinite' then
	dump=DA.GuildSearchTec(eb[1],eb[2],eb[3],eb[4],eb[5],eb[6])
else
	dump,foundd=DA.GuildSearchTec(eb[1],eb[2],eb[3],eb[4],eb[5],eb[6])
end

	if dump==0 then
		DarkAngelGuild:Hide()
		DarkAngelGUI.Guild.foundtext:SetText("found |cffffaaff0|r players")
	else
		
		if DarkAngelGuild.custom_mode then
		else
			DA.RegatherGuildNotes()
		end
		
		DarkAngelGuild.found=#dump
		local numonlpl_dump=numonlpl(dump)
		if foundd and tonumber(foundd) and tonumber(DarkAngelGuild.found) and tonumber(DarkAngelGuild.found)~=tonumber(foundd) then
			if DarkAngelGuild.custom_mode then 
				DarkAngelGUI.Guild.foundtext:SetText('backup: |cff00ffff'..foundd.."|r "..numonlpl_dump.." (cut to |cff00ffff"..DarkAngelGuild.found..'|r)') 
			else
				DarkAngelGUI.Guild.foundtext:SetText('found |cff00ffff'..foundd.."|r players "..numonlpl_dump.." (cut to |cff00ffff"..DarkAngelGuild.found..'|r)') 
			end
		elseif tonumber(DarkAngelGuild.found) then 
			if DarkAngelGuild.found and numonlpl_dump then
				if DarkAngelGuild.custom_mode then 
					DarkAngelGUI.Guild.foundtext:SetText('backup: |cff00ffff'..DarkAngelGuild.found.."|r "..numonlpl_dump) 
				else
					DarkAngelGUI.Guild.foundtext:SetText('found |cff00ffff'..DarkAngelGuild.found.."|r players "..numonlpl_dump) 
				end
			end
		end
		
		DarkAngelGuild:Show()
			DA.GuildSetLine(dump)
	end
end

function DA.GetOfficerNoteColored(note)
	if not note or note:gsub("%s","")=="" then
		return note
	end
	
	if fuckingOptions_g[DA_CurrentGuild].evaluateoffnote then
		local tz,net,tot,hrs=DA.DecodeNote(note)
		
		if (tz=='m' or tz=='f') and (net~=0 or tot~=0 or hrs~=0) then
			if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
				if not DA_Guild_Info[DA_CurrentGuild].base1 then 
					if tot==0 then
						return "|cff00ffffPR|r:"..net
					else
						return note.." |cff00ffffPR|r:"..math.floor(net/tot * 10) /10
					end
				elseif tot+DA_Guild_Info[DA_CurrentGuild].base1==0 or tot+DA_Guild_Info[DA_CurrentGuild].base1==1 then 
					return "|cff00ffffPR|r:"..net
				else
					return note.." |cff00ffffPR|r:"..math.floor((net/tot+DA_Guild_Info[DA_CurrentGuild].base1) * 10) /10
				end
				
			elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
				return "|cffa964ccDKP|r:"..net..","..tot..((hrs and (","..hrs)) or "")
			end
		else
			return note
		end
	else
		return note
	end

		

end

Guild_Create_ScrollBar = function ()
	local NUM_ROWS = 15
	local ROW_HEIGHT = 15

	local ScrollFrame = CreateFrame("ScrollFrame", "DarkAngelGuild", DarkAngelGUI.Guild, "UIDarkAngelScrollFrame2")
	ScrollFrame:SetPoint("TOPLEFT",DarkAngelGUI.Guild,"TOPLEFT",6,-60)
	ScrollFrame:SetPoint("BOTTOMRIGHT",DarkAngelGUI.Guild,"BOTTOMRIGHT",-25,10)
-- local tf = ScrollFrame:CreateTexture(nil, "BACKGROUND"); tf:SetAllPoints(); tf:SetTexture(8/255, 12/255, 20/255, 0.5); tf:SetBlendMode("blend")


	local ContentFrame = CreateFrame("Frame", "DarkAngelGuildCF", ScrollFrame)
	
	ScrollFrame:SetScrollChild(ContentFrame)
-- local zxc = ContentFrame:CreateTexture(nil, "BACKGROUND"); zxc:SetAllPoints(); zxc:SetTexture(8/255, 55/255, 20/255, 0.5); zxc:SetBlendMode("blend")

	local RowButtons = {}
	local font=UIDarkAngelFontConsolas:GetFont()
	
	for i = 1, NUM_ROWS do
		local row = DA.CreateFFGButton2(nil, DarkAngelGuild, {"TOPLEFT", DarkAngelGuild, "TOPLEFT", 0, 10 - (ROW_HEIGHT * i)}, ROW_HEIGHT-1, 465, "", nil, {font, 9, "OUTLINE"},function(self, clickType)
            local data=self.mydata
			for kk = 1, 6 do 
                local editBox = DarkAngelGUI.Guild['EB' .. kk]
                editBox:ClearFocus()
                editBox.focusgained = nil
            end
            
            if clickType == 'LeftButton' then
                if DarkAngelGuild.custom_mode then return end
                
				local shiftdown=IsShiftKeyDown()
				local ctrldown=IsControlKeyDown()
				
				if (not shiftdown) and (not ctrldown) then
					do
						DarkAngelGUI.Guild.lastselected=data.plname
						local menu = DarkAngelGUI.Guild.micromenu
						menu.plbox:SetText(data.plname)
						local isLocal = data.isLocal
						menu.islocal = isLocal
						
						if isLocal then
							menu.ranksmenubtn.fs:SetText("/local/")
							menu.deletelocal:Show()
							menu.ranksmenubtn:Disable()
							menu.ranksmenuFrame:Hide()
							menu.ranksmenubtn.realrankid = nil
							menu.plclasslvl:Hide()
							menu.notebox:Hide()
							menu.noteboxfont:Hide()
							menu.notebox.orignote = nil
							menu.noteset:Hide()
							menu.notecancel:Hide()
							menu.noterefresh:Hide()
							menu.notecopymenubtn:Hide()
							menu.notecopymenuFrame:Hide()
							menu.ofnotebox:EnableMouse(true)
							menu.ofnotebox:SetAlpha(1)
							menu.ofnoteboxfont:SetText(L['assigned to'])
							menu.ofnotebox:SetText(data.officerNoteText)
							menu.ofnotebox.orignote = data.officerNoteText
							menu.ofnoterefresh:Hide()
							if menu.ofnotefreeze then menu.ofnotefreeze:Hide() end
						else
							menu.ranksmenubtn:Enable()
							menu.ranksmenubtn.fs:SetText(data.rankTxt)
							menu.deletelocal:Hide()
							menu.ranksmenubtn.realrankid = data.rankID
							RanksFrameUpd(1)
							menu.plclasslvl:Show()
							menu.plclasslvl:SetTextColor(unpack(data.colorname))
							menu.plclasslvl:SetText("|cff999999[" .. data.lvl .. "]|r" .. data.class)
							menu.notebox:EnableMouse(CanEditPublicNote())
							menu.ofnotebox:EnableMouse(CanEditOfficerNote())
							menu.notebox:SetAlpha(CanEditPublicNote() and 1 or 0.6)
							menu.ofnotebox:SetAlpha(CanEditOfficerNote() and 1 or 0.6)
							menu.notebox:SetText(data.note)
							menu.notebox.orignote = data.note
							menu.ofnoteboxfont:SetText(L['officer note'])
							menu.ofnotebox:SetText(data.officerNoteText)
							menu.ofnotebox.orignote = data.officerNoteText
							menu.noterefresh:Show()
							menu.notebox:Show()
							menu.noteset:Show()
							menu.notecancel:Show()
							menu.notecopymenubtn:Show()
							menu.noteboxfont:Show()
							menu.ofnoterefresh:Show()
							if menu.ofnotefreeze then menu.ofnotefreeze:Show() end
							
						
						end
						
						if not fuckingOptions.mmenuleavefocus then
							menu.notebox:ClearFocus()
							menu.ofnotebox:ClearFocus()
						end
						menu.notebox.t:SetTexture(28/255, 32/255, 50/255, 1);
						menu.ofnotebox.t:SetTexture(28/255, 32/255, 50/255, 1);
						menu:Show()
					end
					
				elseif (shiftdown) and (not ctrldown) then
					if not DarkAngelGUI.Guild.lastselected or DarkAngelGUI.Guild.lastselected==data.plname then
					
						DA.SelectGuildMember(data.plname)
					else
						DA.SelectGMembersInRange(DarkAngelGUI.Guild.lastselected, data.plname)
					end
					
					DarkAngelGUI.Guild.bulkmenu:Show()
					DarkAngelGUI.Guild.UpdRows(DarkAngelGuild.offset or 1)
				elseif (not shiftdown) and (ctrldown)  then
					DA.SelectGuildMember(data.plname)
					
					DarkAngelGUI.Guild.bulkmenu:Show()
					DarkAngelGUI.Guild.UpdRows(DarkAngelGuild.offset or 1)
				end
				
				
                
            elseif clickType == 'RightButton' then
                if data.plname and data.officerNoteText then
                    DAOptMenuFrame.calledfrom = "DarkAngelGUI"
                    DA.OpenOptMenu(self, data.plname, DarkAngelGuild.custom_mode)
                else
                    DAOptMenuFrame:Hide()
                end
            end
        end)
			row.selfID=i
		row:RegisterForClicks("AnyUp")
        row:SetNormalTexture('')
		
		row:SetScript("OnEnter", function(self)
			self:RegisterEvent('MODIFIER_STATE_CHANGED')
			local shiftdown=IsShiftKeyDown()
			if shiftdown and GetMouseFocus() and GetMouseFocus().selfID == self.selfID and self.mydata.plname and self.mydata.officerNoteText then
				DA.myShowTooltip(self, DA.GetTwinsInfo(self.mydata.plname, self.mydata.officerNoteText), 1, {font, 10})
			elseif not shiftdown and GameTooltip:IsShown() then
				DA.myHideTooltip()
			end
		end)
		row:SetScript("OnEvent", function(self)
			if self:IsVisible() and self:IsMouseOver() and GetMouseFocus() and GetMouseFocus().selfID and GetMouseFocus().selfID==self.selfID then
				self:GetScript('OnEnter')(GetMouseFocus())
			end
		end)
		row:SetScript("OnLeave", function(self)
			self:UnregisterEvent('MODIFIER_STATE_CHANGED')
			DA.myHideTooltip()
		end)
		
		
		
		row.buttons = {}
		row.buttons[1]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 1, 0}, 20, 110, {font, 10, "OUTLINE"}, "", nil, nil, "LEFT")
		row.buttons[2]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 75, 0}, 20, 30, {font, 9, "OUTLINE"}, "", {0.6, 0.6, 0.6, 1}, nil, "LEFT")
		row.buttons[3]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 95, 0}, 20, 130, {font, 9, "OUTLINE"}, "", {0.7, 0.8, 0.8, 1}, nil, "LEFT")
		row.buttons[4]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 233, 0}, 20, 115, {font, 9, "OUTLINE"}, "", {0.7, 0.8, 0.8, 1}, nil, "LEFT")
		row.buttons[5]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 348, 0}, 20, 100, {font, 7.5, "OUTLINE"}, "", nil, nil, "LEFT")
		row.buttons[6]=DA.CreateFFGFont(nil, row, {"LEFT", row, "LEFT", 428, 0}, 20, 100, {font, 8, "OUTLINE"}, "", nil, nil, "LEFT")
		
		RowButtons[i] = row
	end
	
	local function UpdateRows(offset)
		
		DarkAngelGuild.offset=offset
		
		local rowIndex = math.floor(offset / ROW_HEIGHT + 0.5) + 1
		for i = 1, NUM_ROWS do
			local data = DA_G_Processed[rowIndex + i - 1]
			if data then
				local row = RowButtons[i]
					if DA.Players_Selected[data.plname] then row:SetButtonState('PUSHED',true) else row:SetButtonState('NORMAL',false) end
					row:Show()
					row.mydata=data
				row.buttons[1]:SetText(data.plname or "")
					if type(data.colorname)=='string' then row.buttons[1]:SetTextColor(0.33, 1, 1, 1) else row.buttons[1]:SetTextColor(unpack(data.colorname)) end
				row.buttons[2]:SetText(data.lvl or "")
				row.buttons[3]:SetText(data.note or "")
				row.buttons[4]:SetText(data.officernote or "")
				row.buttons[5]:SetText(data.rankTxt or "")
					if data.rankNA then row.buttons[5]:SetTextColor(1, 0.27, 0.27, 1) else row.buttons[5]:SetTextColor(0.7, 0.8, 0.8, 1) end
				row.buttons[6]:SetText(data.online or "")
				row.buttons[6]:SetTextColor(unpack(data.onlineColor))
			else
				RowButtons[i]:Hide()
			end
		end
	end
		
	DarkAngelGUI.Guild.UpdRows=UpdateRows
	
	ScrollFrame:EnableMouseWheel(true)
	local scrollbar = _G[ScrollFrame:GetName().."ScrollBar"]
	scrollbar:SetScript("OnValueChanged", function(self, value)
		UpdateRows(value)
	end)

end
function DA.GuildSetLine(data1)

   table.wipe(DA_G_Processed)
	
    for pos, data in ipairs(data1) do
        local name, level, note, officerNote, rank, class, status = unpack(data)
        local rankID, rankName, rankNA = unpack(rank)
        local officerNoteText, officerNoteTextCol = unpack(officerNote)
        local isLocal = rankID == 'local'
        local color = DA.GetClassColor(class)
        
		DA_G_Processed[pos]={}
		local plDat = DA_G_Processed[pos]
		
        
		plDat.plname=name
		plDat.officerNoteText=officerNoteText
		plDat.colorname=isLocal and 'local' or color
		plDat.isLocal=isLocal
		plDat.lvl=level
		plDat.note=note
		
		plDat.officernote=DA.GetOfficerNoteColored(officerNoteTextCol)
		
		plDat.rankNA=rankNA
		plDat.rankTxt="[" .. rankID .. "]" .. (rankName or "")
		plDat.rankID=rankID
		
		plDat.class=class
		plDat.isOnline = (status == "online")
		plDat.onlineColor=plDat.isOnline and {0.1, 0.8, 0.3, 1} or {86/255, 18/255, 35/255, 1}
		plDat.online=status
	
    end
	
	DarkAngelGuildCF:SetSize(5, #DA_G_Processed * 15)
	
	DarkAngelGUI.Guild.UpdRows(DarkAngelGuild.offset or 1)
	
end

-- Minimap button
local minibtn = CreateFrame("Button", "DarkAngel_minimapBtn", Minimap)
minibtn:SetFrameLevel(99)
minibtn:SetSize(28,28)
minibtn:SetMovable(true)
minibtn:SetFrameStrata("MEDIUM")
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
				FFuckingSearch:SetText(UnitName('target') or UnitName('player'))
				DA.RunLogSearch(FFuckingSearch:GetText())
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
	DA.myShowTooltipMinimap(self)
end)
minibtn:SetScript("OnLeave",function(self)
	DA.myHideTooltip()
	for _,j in pairs({GameTooltip:GetRegions()}) do if j:GetObjectType()=='Texture' then j:SetBlendMode('blend') end end
end)

DarkAngel_minimapBtn:Hide()
DarkAngel_minimapBtn.menu=CreateFrame("Button", nil,UIParent)
DarkAngel_minimapBtn.menu.timerticked=0
DarkAngel_minimapBtn.menu.width  = 87
DarkAngel_minimapBtn.menu.height = 80
DarkAngel_minimapBtn.menu:SetBackdropColor(1, 1, 1, 1)
DarkAngel_minimapBtn.menu:SetFrameStrata("FULLSCREEN_DIALOG")
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
		'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), j[2]},j[3],nil,'center','left').fs:SetTextColor(0.1,0.1,0.1,0.8)
	end
	
	DarkAngel_minimapBtn.menu:SetSize(87,#listbtns*15+3)

end

