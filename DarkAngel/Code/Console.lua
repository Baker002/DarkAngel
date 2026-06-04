
---@class DarkAngelAddon
local DA = DarkAngel
local L = DA.L

DA.AddToBuildQueue("Console", function()
    DA.TabCreater({"TOP",_G["DarkAngelGUI"],"BOTTOMLEFT",255,0},15,30,10,30,"Con",{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},function(self) DA.ResetScrollBoxes() end,function() DA.ResetScrollBoxes() end,[[Interface\AddOns\DarkAngel\template\pict\art_console]])

	DarkAngelcon = DA.ScrollBarCreater("DarkAngelcon",DarkAngelGUI.Con,{DarkAngelGUI.Con.width-5, DarkAngelGUI.Con.height-70},{"TOPLEFT",DarkAngelGUI.Con,"TOPLEFT",5, -30})
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
print("Hello world!")
]=])

	DarkAngelGUI.Con.runbtn=DA.CreateFFGButton2(nil,DarkAngelGUI.Con,{"CENTER",DarkAngelGUI.Con,"TOPLEFT",58,-20},12,50,'/run',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 12, "OUTLINE"},function()
		DarkAngelGUI.Con.EB:ClearFocus()
			loadstring(DarkAngelGUI.Con.EB:GetText(),'Piece of Shiet')()
	end)
	DA.FontCreater(nil,"Multiline Console",{"LEFT",DarkAngelGUI.Con.runbtn,"RIGHT",7,0},DarkAngelGUI.Con.runbtn,15,170,{UIDarkAngelFontConsolas:GetFont(), 10},'left',{0.85,1,1,0.4})


end)
