
---@class DarkAngelAddon
local DA = DarkAngel
local L = DA.L


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

	local oldtyp,oldep,oldgp
	local newtyp,newep,newgp
	if FEP_gMain[author] then
		oldtyp,oldep,oldgp,_=DA.DecodeNote(FEP_gMain[author])
	elseif FEP_L_gMain[DA_CurrentGuild][author] and FEP_gMain[FEP_L_gMain[DA_CurrentGuild][author]] then
		oldtyp,oldep,oldgp,_=DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][author]])
	end
	if FEP_gMain[new_name] then
		newtyp,newep,newgp=DA.DecodeNote(FEP_gMain[new_name])
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
local function checkCommPerm(author)
	local val = fuckingOptions_g[DA_CurrentGuild].commWhispersPerm

	if val == 1 then
		return true
	end
	
	if (not UnitInRaid('player') or GetNumRaidMembers()==0) or not UnitInRaid(author) then return false end
	

	if val==2 then 
		return true
	else
		local isFullGuildCheck = val==4 or false
		return DA.IsFullGuildRaid(isFullGuildCheck)
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
		if not checkCommPerm(author) then return end

		if (message:find("?dkp") or message:find("?epgp") or message:find("?main")) and not CanViewOfficerNote() then
			DA.Print(L['error, i cant read officer notes'])
			return
		end
			

		

		if message:find("?dkp") or message:find("?epgp") then
			SendChatMessage(getNoteInfoWhisper(author), "whisper",nil,author)
		elseif message:find("?main") then
			local response=setTvinInfoWhisper(author,message)
			if response=="[OK]" then
				if fuckingOptions_g[DA_CurrentGuild].dkpcomm_sendLocals then
					DA.PublishLocal(author)
				end
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


DA.AddToBuildQueue("Options", function()

	DA.TabCreater({"TOP",_G["DarkAngelGUI"],"BOTTOMLEFT",15,0},15,20,10,40,"opt",{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},function(self) end,function(self) end,[[Interface\AddOns\DarkAngel\template\pict\art_options]])
	DarkAngelopt = DA.ScrollBarCreater("DarkAngelopt",DarkAngelGUI.opt,{DarkAngelGUI.opt.width-5, DarkAngelGUI.opt.height-5},{"TOPLEFT", DarkAngelGUI.opt, "TOPLEFT", 5, -5})
	local options_scrolled=DarkAngelopt.scrollchild

	do --texture options
		
		local textureModes ={
			{0, 	"---"},
			{0.1, 	"10%"},
			{0.2, 	"20%"},
			{0.3, 	"30%"},
			{0.4, 	"40%"},
			{0.5, 	"50%"},
			{0.6, 	"60%"},
			{0.7, 	"70%"},
			{0.8, 	"80%"},
			{0.9, 	"90%"},
			{1, 	"100%"}
		}
		local sl_art = DA.SliderCreater2('DA_OptTxtArt',options_scrolled,{"LEFT",options_scrolled,"TOPLEFT",10,-30},17,120, textureModes, {UIDarkAngelFontConsolas:GetFont(), 12, "OUTLINE"}, {'fuckingOptions','TXTartOpacity'},'','',L["Art texture alpha"],'arttextalpha',function() DA.RePaintFrames() end)
		sl_art.title:SetPoint('left',sl_art,'right',20,1)
		local sl_bg = DA.SliderCreater2('DA_OptTxtBG',options_scrolled,{"LEFT",options_scrolled,"TOPLEFT",10,-56},17,120, textureModes, {UIDarkAngelFontConsolas:GetFont(), 12, "OUTLINE"}, {'fuckingOptions','TXTBgOpacity'},'','',L["BG texture alpha"],'bgtextalpha',function() DA.RePaintFrames() end)
		sl_bg.title:SetPoint('left',sl_bg,'right',20,1)
		DA.FontCreater(nil,L["Texture Options"],{"LEFT",sl_art,"TOPLEFT",0,11},options_scrolled,15,190,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
		
		local txt1cc=DA.CheckBtnCreater(nil,options_scrolled,{"LEFT",sl_art,"RIGHT",1,0},15,15,nil,function(self) fuckingOptions.TXTArtTransp=(self:GetChecked() or false) DA.RePaintFrames() end,{'fuckingOptions','TXTArtTransp'},'TXTArtTransp')
		local txt2cc=DA.CheckBtnCreater(nil,options_scrolled,{"LEFT",sl_bg,"RIGHT",1,0},15,15,nil,function(self) fuckingOptions.TXTBgTransp=(self:GetChecked() or false) DA.RePaintFrames() end,{'fuckingOptions','TXTBgTransp'},'TXTBgTransp')
		
		local txtPositionChan=DA.CheckBtnCreater(nil,options_scrolled,{"LEFT",sl_bg,"RIGHT",80,0},15,15,L["TXTArtOnFront"],function(self) fuckingOptions.TXTArtOnFront=(self:GetChecked() or false) DA.RePaintFrames(true) end,{'fuckingOptions','TXTArtOnFront'},'TXTArtOnFront')
		
		
		--presets	
		for i,j in ipairs({
			{0.5, 0.2, 1, false, true},
			{0.3, 0.1, false, false, true},
			{0.3, 0.5, 1, false, true},
			{0.5, 0.3, false, false, true},	-- defaults
			{0.8, 0.4, false, false, true},
			{1,   0.4, false, 1, false},
			{1,   0.8, false, 1, true},
			{0.3, 0.7, 1, false, false},
			{0.5, 0.7, 1, false, false},
			{0.2, 0.8, false, 1, false},
			{0.1, 1,   false, 1, false},
			{0.8, 0.6, 1, 1, true},

		}) do
			-- local col = (i - 1) % 10
			-- local row = math.floor((i - 1) / 10)

			local btn = DA.CreateFFGButton2(nil,options_scrolled,{"CENTER",sl_art,"CENTER",115 + (15 * i), 0},12,12,tostring(i),[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
				fuckingOptions.TXTartOpacity=j[1]
				fuckingOptions.TXTBgOpacity=j[2]
				fuckingOptions.TXTArtTransp=j[3]
				fuckingOptions.TXTBgTransp=j[4]
				if fuckingOptions.TXTArtOnFront~=j[5] then
					fuckingOptions.TXTArtOnFront=j[5]
					DA.RePaintFrames(1)
				end

				DA.RePaintFrames(nil,1)
				sl_art:selfUpdateValue()
				sl_bg:selfUpdateValue()
				txt1cc:SetChecked(fuckingOptions.TXTArtTransp)
				txt2cc:SetChecked(fuckingOptions.TXTBgTransp)
				txtPositionChan:SetChecked(fuckingOptions.TXTArtOnFront)
				DA.RePaintFrames(nil,nil,1)
			end)

			if i == 1 then
				DA.FontCreater(nil,L["texture presets"],{"LEFT",btn,"TOPLEFT",0,4},btn,15,170,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
			end
		end
			
	end

	do	--import/export settings
		_,DarkAngelGUI.opt.importOptFrame=DA.CreateFFGDropFrame(DarkAngelopt.scrollchild,L["transfer_settings"],22,55,{"CENTER",DarkAngelopt.scrollchild,"TOPLEFT",415,-26},331,220,{"BOTTOMRIGHT","TOPRIGHT"},nil,nil,nil,'transfer_settings_tt1')
		DarkAngelGUI.opt.importOptFrame:SetParent(DarkAngelGUI.opt)
		DarkAngelGUI.opt.importOptFrame:SetPoint("BOTTOMRIGHT",DarkAngelGUI.opt,"TOPRIGHT",0,2)
		do --content
			local frame = DarkAngelGUI.opt.importOptFrame
			
			do -- manual
				DarkAngelImportOpt = DA.ScrollBarCreater("DarkAngelImportOpt",frame,{200, 218},{"TOPLEFT", 1, -1},1)
				local import_scrolled=DarkAngelImportOpt.scrollchild

				frame.EB=DA.EditBoxCreater(nil,import_scrolled,{"TOPLEFT", import_scrolled, "TOPLEFT", 0, 0},{1,1},nil,true,false,{UIDarkAngelFontConsolas:GetFont(), 8},
					function(self) 		 self:ClearFocus(); self.focusgained=nil;self:HighlightText(0,0)  end,
					function(self) 		 self:Insert("\n")  end, --enter here
					function(self) 		 self:ClearFocus(); self.focusgained=nil;self:HighlightText(0,0)  end,
					function(self) 	     self.t:SetBlendMode("BLEND") self.focusgained=1 self:HighlightText() end,
					nil,nil,nil,1
				)
				frame.EB:SetPoint("BOTTOMRIGHT", DarkAngelImportOpt, "BOTTOMRIGHT", -18, 1)

				DA.HelpCreater(frame,{"CENTER",frame,"TOPRIGHT",-125,-16},'transfer_settings_tt2',10,10)

				DA.FontCreater(nil,L["Manual settings transfer"],{"LEFT",frame,"TOPRIGHT",-118,-16},frame,15,170,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
				
				local import_global=DA.CheckBtnCreater(nil,frame,{"CENTER",frame,"TOPRIGHT",-125,-30},15,15,L["global setings"]) ; import_global:SetChecked(true)
				local import_guild=DA.CheckBtnCreater(nil,frame,{"CENTER",frame,"TOPRIGHT",-125,-45},15,15,L["guild setings"]) ; import_guild:SetChecked(true)
				
				DA.CreateFFGButton2(nil,frame,{"CENTER",frame,"TOPRIGHT",-105,-60},12,45,L['export'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"}, function(self)
					local exportLine = {}
					if import_global:GetChecked() then exportLine.DA_GLOBAL_SETTINGS = fuckingOptions end
					if import_guild:GetChecked() then exportLine.DA_GUILD_SPECIFIC_SETTINGS = fuckingOptions_g end
					if next(exportLine) then
						frame.EB:SetText('')
						frame.EB:SetText(DA.tableToString(exportLine))
						frame.EB:SetCursorPosition(0)
					else
						frame.EB:SetText('')
					end
				end)

				DA.CreateFFGButton2(nil,frame,{"CENTER",frame,"TOPRIGHT",-50,-60},12,45,L['import'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"}, function(self,btnType)
					if not(btnType=="RightButton" and frame.EB:GetText() and frame.EB:GetText():gsub("%s+","")~="") then return end

					self:Disable()

					local ok, result = pcall(DA.stringToTable, frame.EB:GetText())
					if not ok or not result or not(result.DA_GLOBAL_SETTINGS or result.DA_GUILD_SPECIFIC_SETTINGS) then
						DA.Print("|cffff7777Wrong settings format. Correctly copied the settings, have you? Along with the { } braces, hmm?")
						self:Enable()
						return
					end
					if import_global:GetChecked() and result.DA_GLOBAL_SETTINGS then 
						fuckingOptions = DA.DeepCopy(result.DA_GLOBAL_SETTINGS)
						DA.TimerAfter(0, function() DA.Run_OnSettingsImport();DA.RePaintFrames(true);DA.RePaintFrames() end)
					end
					if import_guild:GetChecked() and result.DA_GUILD_SPECIFIC_SETTINGS then 
						fuckingOptions_g = DA.DeepCopy(result.DA_GUILD_SPECIFIC_SETTINGS)
						DA.TimerAfter(0, function() DA.Run_OnGuildUpdate() end)
					end
					DA.TimerAfter(0, function() 
						DA.Print(L["import_settings_success"])
						self:Enable()
					end)
				end,'confirm_rightclick')

				DA.CreateFFGButton2(nil,frame,{"CENTER",frame,"BOTTOMRIGHT",-121,5},6,20,'<<<','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"}, function(s)
					if not s.state then
						s.state = true
						frame:SetSize(DarkAngelGUI.width,220)
						DarkAngelImportOpt:SetSize(365, 218)
						s:SetText(">>>")
					else
						s.state = false
						frame:SetSize(331,220)
						DarkAngelImportOpt:SetSize(200, 218)
						s:SetText("<<<")

					end
				end)
				local cat = 
[==[

   
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
      

]==]			
				DA.CreateFFGButton2(nil,frame,{"CENTER",frame,"BOTTOMRIGHT",-100,5},6,18,':3','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"}, function()
					frame.EB:SetText(cat)
				end)
			end
			
			do	-- guild migration

				DA.FontCreater(nil,L["Migrate guild settings"],{"LEFT",frame,"TOPRIGHT",-118,-103},frame,15,170,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
				
				DA.HelpCreater(frame,{"CENTER",frame,"TOPRIGHT",-125,-103},'transfer_settings_tt3',10,10)

				DA.CreateDropdownNoValueSelector({
					rel = frame,
					point = {"LEFT",frame,"TOPRIGHT",-130,-127},
					width = 125,
					height = 12,
					title = {
						"from",
						{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"}
					},
					frpoint = "TOP",
					valuesrosterDynamic = function()
						local result = {}
						for guildName,_ in pairs(fuckingOptions_g) do
							if guildName ~= "n0-guild" then
								table.insert(result, {text = guildName, value = guildName})
							end
						end
						return result
					end,
					justh = 'left',
					optjusth = 'left',
					funcOnShow = function(s) s:reRender() end,
				})

				DA.CreateDropdownNoValueSelector({
					rel = frame,
					point = {"LEFT",frame,"TOPRIGHT",-130,-150},
					width = 125,
					height = 12,
					title = {
						"to",
						{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"}
					},
					frpoint = "BOTTOM",
					valuesrosterDynamic = function()
						local result = {}
						for guildName,_ in pairs(fuckingOptions_g) do
							if guildName ~= "n0-guild" then
								table.insert(result, {text = guildName, value = guildName, isDefault = DA_CurrentGuild==guildName or false})
							end
						end
						return result
					end,
					justh = 'left',
					optjusth = 'left',
					funcOnShow = function(s) s:reRender() end,
				})

				DA.CreateFFGButton2(nil,frame,{"CENTER",frame,"TOPRIGHT",-50,-170},12,45,L['import'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"}, function(self,btnType)
					if not(btnType=="RightButton" and frame.fromFrame.storedvalue and frame.toFrame.storedvalue and frame.fromFrame.storedvalue~=frame.toFrame.storedvalue) then return end

					
					fuckingOptions_g[frame.toFrame.storedvalue] = DA.DeepCopy(fuckingOptions_g[frame.fromFrame.storedvalue])
					if frame.toFrame.storedvalue == DA_CurrentGuild then
						DA.TimerAfter(0, function() DA.Run_OnGuildUpdate() end)
						DA.TimerAfter(0, function() DA.Print(L["import_settings_success"]) end)
					else
						DA.Print(L["import_settings_success"])
					end
				end,'confirm_rightclick')
			end
			
		end
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
		DA.CheckBtnCreater(nil,options_scrolled,{"CENTER",options_scrolled,"TOPLEFT",160,-60},15,15,L['guild window alias button'],function(self) fuckingOptions.gwinbtn=(self:GetChecked() or false) aliasShowHide() end,{'fuckingOptions','gwinbtn'},nil)

		DarkAngelopt.scrollchild.addbinds_ch = DA.CheckBtnCreater(nil,options_scrolled,{"CENTER",options_scrolled,"TOPLEFT",15,-60},15,15,L['Additional binds'],
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

	local modOptTable = {}
	for _,t in ipairs(DA.modOptCreate) do
		local modName,modOptFunc = unpack(t)
		local ok, result = pcall(modOptFunc, DarkAngelGUI.opt, DarkAngelopt)
        if not ok then
            DA.Print("|cffff0000["..modName.."]: Init Error:|r "..tostring(result))
		else
			table.insert(modOptTable, {modName, result})
			DA.loaded_Modules[modName]=true
        end
	end

	do --resort ModOpt order
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
			-- print('[|cffed94edDarkAngel|cffffffff]: Processing module index:', i)

			local modName = tbl[1]
			local modOptFrame = tbl[2]

			-- print("[|cffed94edDarkAngel|cffffffff]: Module Name:", modName)
			-- print("[|cffed94edDarkAngel|cffffffff]: Module Frame:", modOptFrame)

			if DA.loaded_Modules[modName] then
				-- print("[|cffed94edDarkAngel|cffffffff]:", modName, "is loaded")

				if modName == "Tweaks" then
					-- print("[|cffed94edDarkAngel|cffffffff]: Special positioning logic for Tweaks")

					if anchors["BidTracker"] then
						-- DA.Print("Anchoring Tweaks to BidTracker")
						modOptFrame:SetPoint("TOPLEFT", anchors["BidTracker"], "BOTTOMLEFT", 0, -spacing)
					elseif anchors["Awarder"] then
						-- DA.Print("Anchoring Tweaks to Awarder")
						modOptFrame:SetPoint("TOPLEFT", anchors["Awarder"], "BOTTOMLEFT", 0, -spacing)
					elseif anchors["Logger"] then
						-- DA.Print("Anchoring Tweaks to Logger")
						modOptFrame:SetPoint("TOPLEFT", anchors["Logger"], "TOPRIGHT", spacing, 0)
					else
						-- DA.Print("Anchoring Tweaks to default position")
						modOptFrame:SetPoint("TOPLEFT", DarkAngelopt.scrollchild, "TOPLEFT", xOffset, yOffset)
					end
				else
					-- print("[|cffed94edDarkAngel|cffffffff]: Standard positioning for", modName)
					modOptFrame:SetPoint("TOPLEFT", DarkAngelopt.scrollchild, "TOPLEFT", xOffset, yOffset)
					
					local width = modOptFrame:GetWidth()
					-- print("[|cffed94edDarkAngel|cffffffff]: Width of", modName, "frame:", width)

					xOffset = xOffset + width + spacing
					-- print("[|cffed94edDarkAngel|cffffffff]: New xOffset:", xOffset)

					anchors[modName] = modOptFrame
					-- print("[|cffed94edDarkAngel|cffffffff]: Anchor updated for", modName)
				end
			else
				-- print("[|cffed94edDarkAngel|cffffffff]: ",modName, "is not loaded. Skipping.")
			end
		end
	end
	
end)

DA.AddModOptions('Tweaks', function(optFrame,optScrollFrame)
	
	local f = DA.FrameCreater(nil,optScrollFrame.scrollchild,154,80)
	f:Show()
	

	local epgpOff = DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-20},15,15,L['epgp: officer note warning'],function(self) fuckingOptions.epgpofficer=(self:GetChecked() or false);DA.RunTweaks('epgpofficer') end,{'fuckingOptions','epgpofficer'},'epgpofficernote')
		DA.FontCreater(nil,"Tweaks",{"LEFT",f,"TOPLEFT",5,-6},epgpOff,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-32},15,15,L['epgp: multiple masters warning'],function(self) fuckingOptions.epgpmultiple=(self:GetChecked() or false);DA.RunTweaks('epgpmultiple') end,{'fuckingOptions','epgpmultiple'},'epgpmmasters')
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-44},15,15,L['epgp: custom tvins and loot'],function(self) fuckingOptions.epgptwinksandloot=(self:GetChecked() or false);DA.RunTweaks('epgptwinksandloot') end,{'fuckingOptions','epgptwinksandloot'},'epgptwinsandloot')
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",25,-54},15,15,L['epgp: EP Auc'],function(self) fuckingOptions_g[DA_CurrentGuild].epgpepauc=(self:GetChecked() or false);DA.RunTweaks('epgptwinksandloot') end,{'fuckingOptions_g','epgpepauc','DA_CurrentGuild'},'epgpepauc')
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-68},15,15,L['raidroll_epgp: DarkAngel tvins'],function(self) fuckingOptions.rrtwinks=(self:GetChecked() or false);DA.RunTweaks('rrtwinks') end,{'fuckingOptions','rrtwinks'},'rrtwins')
	local function updTweaks()
		if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
			f:SetAlpha(1)
		else
			f:SetAlpha(0.5)
		end
	end
	table.insert(DA.RunOnGuildUpdate, updTweaks)
	updTweaks()
	return f
end)