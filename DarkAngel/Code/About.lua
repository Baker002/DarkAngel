
---@class DarkAngelAddon
local DA = DarkAngel
local L = DA.L

DA.AddToBuildQueue("About", function()
	DA.TabCreater({"TOP",_G["DarkAngelGUI"],"BOTTOMLEFT",299,0},15,40,10,50,"About",{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},function(self) end,function(self) end,[[Interface\AddOns\DarkAngel\template\pict\art_about]])
	local frame = DarkAngelGUI.About
	local function do_frame(rel, width, heigh, point)
		local f = DA.FrameCreater(nil, rel, width, heigh, point, nil, {0.03, 0.04, 0.05, 0.6}, nil, true)
		f:Show()
		f.t:SetBlendMode('add')
		return f
	end
	local function font_do(text, point, rel, fontSize, hjust, textColor)
		local f = DA.FontCreater(nil, text, point, rel, 18, 150, {UIDarkAngelFontConsolas:GetFont(), fontSize, "OUTLINE"}, hjust, textColor)
		return f
	end
	local function do_eb_with_title(rel, point,ebText,labelText)
		local eb = DA.EditBoxCreater2(nil, rel, point, {180, 10}, ebText, false, false, {UIDarkAngelFontConsolas:GetFont(), 6, "OUTLINE"},nil,nil,nil,'text')
		local label = DA.FontCreater(nil, labelText, {"BOTTOMLEFT", eb, "TOPLEFT", 1, -1}, eb, 15, 180, {UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"}, "left", {0.80, 0.88, 1, 1})
		return eb,label
	end
	do
		frame.aboutPanel = do_frame(frame, 220, 280, {"TOPLEFT", frame, "TOPLEFT", 10, -10})
		
		frame.addonName = DA.FontCreater(nil, "DarkAngel", {"CENTER", frame.aboutPanel, "TOPLEFT", 100, -18}, frame.aboutPanel, 200, 220, {UIDarkAngelFontConsolas:GetFont(), 15, "OUTLINE"}, "CENTER", {0.50, 0.88, 1, 1},'MIDDLE')

		frame.authorBtn = DA.CreateFFGButton2(nil, frame.aboutPanel, {"TOPLEFT", frame.aboutPanel, "TOPLEFT", 20, -35}, 18, 64, "Author", [[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]], {UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"}, function(self)
			self.clicks = (self.clicks or 0) + 1
			-- future easter egg hook
		end)
			frame.authorFont = font_do("Baker", {"LEFT", frame.authorBtn, "RIGHT", 10, 0}, frame.authorBtn, 11, "left", {0.93, 0.90, 0.75, 1})

		frame.versionBtn = DA.CreateFFGButton2(nil, frame.aboutPanel, {"TOPLEFT", frame.aboutPanel, "TOPLEFT", 20, -60}, 18, 64, "Version", [[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]], {UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"}, function(self)
			self.clicks = (self.clicks or 0) + 1
			-- future easter egg hook
		end)
		local addonVersion = GetAddOnMetadata("DarkAngel",'version')
			frame.versionFont = DA.FontCreater(nil, addonVersion, {"LEFT", frame.versionBtn, "RIGHT", 10, 0}, frame.versionBtn, 18, 68, {UIDarkAngelFontConsolas:GetFont(), 11, "OUTLINE"}, "left", {0.93, 0.90, 0.75, 1})

		
		frame.youtubeEb,frame.youtubeFont = do_eb_with_title(frame.aboutPanel, {"TOPLEFT", frame.aboutPanel, "TOPLEFT", 10, -105},"https://www.youtube.com/watch?v=GB8TdZ0teTI&list=PLbW5Le0wT0UX1jZhLLoQVSB_PEi1OyNHs","Video tutorial")
		frame.youtubeEb:SetCursorPosition(0)
		frame.dsEb,frame.dsFont = do_eb_with_title(frame.aboutPanel, {"TOPLEFT", frame.aboutPanel, "TOPLEFT", 10, -130},"https://discord.gg/rrQXzCD4MY","Discord")
		
		frame.donateEB,frame.donateFont = do_eb_with_title(frame.aboutPanel, {"TOPLEFT", frame.aboutPanel, "TOPLEFT", 10, -155},"https://donatello.to/darkangeladdon","Support author <3")
		
		frame.gitEb,frame.gitFont = do_eb_with_title(frame.aboutPanel, {"TOPLEFT", frame.aboutPanel, "TOPLEFT", 10, -180},"https://github.com/Baker002/DarkAngel","GitHub")
		
		local welcomeText=
[[Thank you for installing my addon <3
It truly means a lot to me that my work may have become part of your guild and raid management.

If you enjoy using it and would like to support further development, please consider making a small donation.
Your support genuinely helps keep the project alive and motivates future updates.

Either way — thank you for giving it a try, and have a great time!]]

		
		frame.infos = DA.FontCreater(nil, welcomeText, {"TOPLEFT", frame.aboutPanel, "TOPLEFT", 8, -200}, frame.aboutPanel, 200, 220, {UIDarkAngelFontConsolas:GetFont(), 6, "OUTLINE"}, "left", {0.80, 0.88, 1, 1},'TOP')


	end

	
	
end)