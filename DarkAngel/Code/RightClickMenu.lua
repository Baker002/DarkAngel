
---@class DarkAngelAddon
local DA = DarkAngel
local L = DA.L

DA.AddToBuildQueue("RightClickMenuFrame", function()

	if UISpecialFrames then
		tinsert(UISpecialFrames, "DarkAngelGUI")
		tinsert(UISpecialFrames, "DA_RightClickMenu")
	end

	DA.CreateScaler('DarkAngelGUI',0.6,2,{'fuckingOptions','FFGScale'})

	do --frame
		DA_RightClickMenu = DA.FrameCreater("DA_RightClickMenu",UIParent,62,105,{"TOPLEFT",UIParent,"TOPLEFT"},nil,{0.06,0.09,0.12,0.7},nil,true)
		DA_RightClickMenu:SetFrameLevel(107)
		DA_RightClickMenu.timerticked=0
		DA_RightClickMenu:SetScript("OnEnter",function() DA_RightClickMenu.timerticked=0 end)
		DA_RightClickMenu:SetScript("OnShow",function()
			if InCombatLockdown() then

			else
					DA_RightClickMenu.target:SetParent(DA_RightClickMenu)
					DA_RightClickMenu.focus:SetParent(DA_RightClickMenu)
					DA_RightClickMenu.MT:SetParent(DA_RightClickMenu)
					DA_RightClickMenu.OT:SetParent(DA_RightClickMenu)
				DA_RightClickMenu.target:SetPoint("CENTER",DA_RightClickMenu,"TOPRIGHT",-117,-12)
				DA_RightClickMenu.focus:SetPoint("CENTER",DA_RightClickMenu,"TOPRIGHT",-117,-27)
				DA_RightClickMenu.MT:SetPoint("CENTER",DA_RightClickMenu,"TOPRIGHT",-123.5,-50)
				DA_RightClickMenu.OT:SetPoint("CENTER",DA_RightClickMenu,"TOPRIGHT",-92,-50)
				if (DA_RightClickMenu.calledfrom=="DA_Awarder" or DA_RightClickMenu.calledfrom=="DA_BidTracker") and DA_RightClickMenu.player and DA.IsInSameRaid(DA_RightClickMenu.player) then
					DA_RightClickMenu.target:Show()
					DA_RightClickMenu.focus:Show()
					DA_RightClickMenu.MT:Show()
					DA_RightClickMenu.OT:Show()
				end
				-- DA_RightClickMenu.hiddenframe

			end
		end)
		DA_RightClickMenu:SetScript("OnHide",function()
			if InCombatLockdown() then

			else
				DA_RightClickMenu.target:SetParent('UIParent')
				DA_RightClickMenu.focus:SetParent('UIParent')
				DA_RightClickMenu.MT:SetParent('UIParent')
				DA_RightClickMenu.OT:SetParent('UIParent')
					DA_RightClickMenu.target:ClearAllPoints()
					DA_RightClickMenu.focus:ClearAllPoints()
					DA_RightClickMenu.MT:ClearAllPoints()
					DA_RightClickMenu.OT:ClearAllPoints()
				DA_RightClickMenu.target:Hide()
				DA_RightClickMenu.focus:Hide()
				DA_RightClickMenu.MT:Hide()
				DA_RightClickMenu.OT:Hide()

			end
		end)
		DA_RightClickMenu:SetScript("OnEvent", function(self) if self:IsShown() then self:GetScript("OnShow")(self) end if DA.loaded_Modules['Awarder'] then FEP_GatherRaid() end end)
		DA_RightClickMenu:RegisterEvent("PLAYER_REGEN_ENABLED")


	end

	-- content
	do
		local closer99a=DA.CloseButtonCreater(nil,DA_RightClickMenu,{"BOTTOMLEFT", DA_RightClickMenu, "TOPRIGHT", 2,2},10,10,'x')
		-- closer99a:SetFrameLevel(119)
		closer99a:SetScript("OnEvent", function(self) if DA_RightClickMenu:IsShown() and (DA_RightClickMenu.calledfrom=="DA_Awarder" or DA_RightClickMenu.calledfrom=="DA_BidTracker") then self:Click(self) end end)
		closer99a:RegisterEvent("PLAYER_REGEN_DISABLED")

		DA.CreateFFGButton2(nil,DA_RightClickMenu,{"LEFT",DA_RightClickMenu,"TOPRIGHT",-75,-10},14,73,L['Whisper'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},function()
			DA_RightClickMenu:Hide();
			if DA_RightClickMenu.player then
				_G[SELECTED_CHAT_FRAME:GetName().."EditBox"]:SetText('/w '..DA_RightClickMenu.player..' ')
				ChatEdit_ActivateChat(_G[SELECTED_CHAT_FRAME:GetName().."EditBox"])
			end
		end,nil,nil,'left')
		DA_RightClickMenu.invite=DA.CreateFFGButton2(nil,DA_RightClickMenu,{"LEFT",DA_RightClickMenu,"TOPRIGHT",-75,-25},14,73,L['Invite'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
			DA_RightClickMenu:Hide();
			if DA_RightClickMenu.player then
				InviteUnit(DA_RightClickMenu.player)
			end
		end,nil,nil,'left')

		DA_RightClickMenu.detailsbtn=DA.CreateFFGButton2(nil,DA_RightClickMenu,{"LEFT",DA_RightClickMenu,"TOPRIGHT",-75,-50},14,73,L['Details'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},function()
			DA_RightClickMenu:Hide();
			if DA_RightClickMenu.player then
				DA.OpenLogSearch(DA_RightClickMenu.player)
			end
		end,nil,nil,'left')
		DA.CreateFFGButton2(nil,DA_RightClickMenu,{"LEFT",DA_RightClickMenu,"TOPRIGHT",-75,-65},14,73,L['Twins'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},function()
			DA_RightClickMenu:Hide();
			DarkAngelGUI:Show()
			local ofnote=DA_RightClickMenu.ofnote or DA_RightClickMenu.altnote
			if DA_RightClickMenu.player then
				if ofnote and (DA.DecodeNote(ofnote)=='m' or DA.DecodeNote(ofnote)=='f' ) then
				--is main/frozen main
					DarkAngelGUI.Guild.precmatch:SetChecked(false);fuckingOptions.precisematchsearch=false
					DarkAngelGUI.Guild.showlocals:SetChecked(1);fuckingOptions.showlocals=1
					DarkAngelGUI.Guild.EB1:SetText(DA_RightClickMenu.player)
					DarkAngelGUI.Guild.EB2:SetText("")
					DarkAngelGUI.Guild.EB3:SetText("")
					DarkAngelGUI.Guild.EB4:SetText(DA_RightClickMenu.player)
					DarkAngelGUI.Guild.EB5:SetText("")
					DarkAngelGUI.Guild.EB6:SetText("")

					if DarkAngelGUI.Guild.bulkmenu:IsShown() then
						DarkAngelGUI.Guild.bulkmenu.assignedto:SetText(DA_RightClickMenu.player)
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

		DA_RightClickMenu.epgpaward,DA_RightClickMenu.epgpawardFrame=DA.CreateFFGDropFrame(DA_RightClickMenu,L['award'],14,73,{"LEFT",DA_RightClickMenu,"TOPRIGHT",-75,-80},120,57,"TOPRIGHT",'left',nil,nil,nil,true)
		DA_RightClickMenu.epgpawardFrame.t:SetTexture(0.06,0.09,0.12,0.7)
		DA_RightClickMenu.epgpaward:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]])
		DA_RightClickMenu.epgpaward.fs:SetTextColor(0.5,0.9,1,1)
			do --award
				local function awardfunc(name,epgp,value,reason)
					local source,is_local
					local main
					local altTable
					
					local localKey = FEP_L_gMain[DA_CurrentGuild][name]
					if localKey and FEP_gMain[localKey] then
						source = FEP_gMain[localKey]
						is_local = true
					elseif FEP_gMain[name] then
						source = FEP_gMain[name]
					else
						DA.Print(name..' - Player is not found in guild')
						DA_RightClickMenu.epgpawardFrame.start:Enable()
						return
					end

					local typ,ep,_,_=DA.DecodeNote(source)
					if is_local and typ=='m' then
						main = localKey
					elseif typ=='m' then
						main = name
					elseif typ=='f' then
						DA.Print(name..' - is frozen. Care to unfreeze?')
						DA_RightClickMenu.epgpawardFrame.start:Enable()
						return
					elseif typ=='t' and not is_local then
						local source_2 = FEP_gMain[source]
						if source_2 then
							local typ_t,_,_,_=DA.DecodeNote(source_2)
							if typ_t=='m' then
								main = source
							elseif typ_t=='f' then
								DA.Print(name..' - has frozen main. Care to unfreeze?')
								DA_RightClickMenu.epgpawardFrame.start:Enable()
								return
							elseif typ_t=='t' then
								DA.Print(name..' - is duplicate twin')
								DA_RightClickMenu.epgpawardFrame.start:Enable()
								return
							end
						else
							DA.Print('skipped [bad note]: '..name..' ('..ep..')')
							DA_RightClickMenu.epgpawardFrame.start:Enable()
							return
						end
					else
						DA.Print(name..' - Player is not found in guild')
						DA_RightClickMenu.epgpawardFrame.start:Enable()
						return
					end
					
					if main ~= name then
						altTable = {name, is_local}
					end

					local dkpinverted
					if epgp=='ep' then
						DA.EPawardfunc(main,value,reason, altTable)
					elseif epgp=='gp' then
						DA.GPawardfunc(main,value,reason, altTable)

					elseif epgp=='+dkp' or epgp=='-dkp' then
						if (epgp=='-dkp' and not tostring(value):find("-") ) then
							DA.DKPawardfunc(main,"-"..value,reason, altTable)
							dkpinverted = true
						else
							DA.DKPawardfunc(main,value,reason, altTable)
						end
					end
					if DA.loaded_Modules['Awarder'] then
						FEP_GatherRaid()
						tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
					end
					tinsert(DA_Fep_bulk,function() DA_RightClickMenu.epgpawardFrame.start:Enable() end)
					tinsert(DA_Fep_bulk,function() if DarkAngelGuild:IsShown() then DA.GetGuildData();DA.GuildSetAllLines() end end)
					DA.ResumeTimer('fep')

					DA.AddRecentAward(name,epgp,dkpinverted and "-"..value or value,reason)
				end


				DA_RightClickMenu.epgpawardFrame.Dropdown = DA.FrameCreater(nil,DA_RightClickMenu.epgpawardFrame,270,111,{"TOPLEFT",DA_RightClickMenu.epgpawardFrame,"BOTTOMLEFT",2,-2},nil,{0.15, 0.17, 0.2, 0.65})
					DA.CloseButtonCreater(nil,DA_RightClickMenu.epgpawardFrame.Dropdown,{"BOTTOMLEFT", DA_RightClickMenu.epgpawardFrame.Dropdown, "TOPRIGHT", 2,2},10,10,'x')
				for i=1,20 do
					DA_RightClickMenu.epgpawardFrame.Dropdown['btn'..i]=DA.CreateFFGButton2(nil,DA_RightClickMenu.epgpawardFrame.Dropdown,{"TOPLEFT", DA_RightClickMenu.epgpawardFrame.Dropdown, "TOPLEFT", 1,10-11*i},10,268,"",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function(self)

					end,nil,nil,'left')
				end
				local Dropdown_rerender

				DA.HelpCreater(DA_RightClickMenu.epgpawardFrame,{"CENTER",DA_RightClickMenu.epgpawardFrame,"TOPLEFT",52.5,-8},'awardprocent_tt',10,10)

				DA_RightClickMenu.epgpawardFrame.start=DA.CreateFFGButton2(nil,DA_RightClickMenu.epgpawardFrame,{"TOPLEFT", DA_RightClickMenu.epgpawardFrame, "TOPLEFT", 60, -2},13,50,L['add'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
					self:Disable()
					DA_RightClickMenu.epgpawardFrame.value.focusgained=nil
					DA_RightClickMenu.epgpawardFrame.value:ClearFocus()
					DA_RightClickMenu.epgpawardFrame.reason.focusgained=nil
					DA_RightClickMenu.epgpawardFrame.reason:ClearFocus()

					if CanEditOfficerNote() then
					else
						DA.Print(L['I am not a guild officer'])
						self:Enable()
						return
					end

					local reason=DA_RightClickMenu.epgpawardFrame.reason:GetText()
					if reason=="" or reason:gsub("%s+","")=="" then reason='test' end

					local value=DA_RightClickMenu.epgpawardFrame.value:GetText()
					if value=="" or value:gsub("%s+","")=="" or (not value:match("^-?[w,W]%d+$") and not tonumber(value)) then
						self:Enable()
						return
					end

					DA_RightClickMenu.epgpawardFrame.Dropdown:Hide()

					awardfunc(DA_RightClickMenu.player,string.lower(DA_RightClickMenu.epgpawardFrame.epgp.fs:GetText()),value,tostring(reason))
				end,nil,nil)

				local function epgpdkpfunc(self)
					local self = self or DA_RightClickMenu.epgpawardFrame.epgp
					if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
						if self.fs:GetText()=='EP' then
							self.fs:SetText('GP')
							self:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Yellow.blp')
						else
							self.fs:SetText('EP')
							self:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Green.blp')
						end
					elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
						if self.fs:GetText()=='+DKP' then
							self.fs:SetText('-DKP')
							self:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Yellow.blp')
						else
							self.fs:SetText('+DKP')
							self:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Green.blp')
						end
					end
				end
				table.insert(DA.RunOnGuildUpdate, epgpdkpfunc)
				DA_RightClickMenu.epgpawardFrame.epgp=DA.CreateFFGButton2(nil,DA_RightClickMenu.epgpawardFrame,{"TOPLEFT", DA_RightClickMenu.epgpawardFrame, "TOPLEFT", 5, -2},13,40,((DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' and 'EP') or (DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' and '+DKP')),'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Green',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},epgpdkpfunc)


				DA_RightClickMenu.epgpawardFrame.reason=DA.EditBoxCreater(nil,DA_RightClickMenu.epgpawardFrame,{"TOPLEFT", DA_RightClickMenu.epgpawardFrame, "TOPLEFT", 5, -30},{50,18},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 9.5},
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); DA_RightClickMenu.epgpawardFrame.Dropdown:Hide();self.focusgained=nil end,
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); DA_RightClickMenu.epgpawardFrame.Dropdown:Hide();self.focusgained=nil end, --enter here
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); DA_RightClickMenu.epgpawardFrame.Dropdown:Hide();self.focusgained=nil end,
					function(self)
						if self:GetParent():IsShown() then
							self.t:SetBlendMode('blend');
							self.focusgained=1
							self:HighlightText()
							Dropdown_rerender()
						end
					end,
					function(self)
						if self:GetParent():IsShown() and self.focusgained then
							Dropdown_rerender()
						end
					end
				)
				DA_RightClickMenu.epgpawardFrame.reason:SetText("test")
				DA.CreateFFGButton2(nil,DA_RightClickMenu.epgpawardFrame.reason,{"TOPRIGHT",DA_RightClickMenu.epgpawardFrame.reason,"TOPRIGHT",0,0},5,5,'x',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 6},function() DA_RightClickMenu.epgpawardFrame.reason:SetText("") end,nil,nil,'left')

				DA.FontCreater(nil,L['reason'],{"LEFT",DA_RightClickMenu.epgpawardFrame.reason,"LEFT",3,15},DA_RightClickMenu.epgpawardFrame.reason,15,170,{UIDarkAngelFontConsolas:GetFont(), 10},'left',{0.85,1,1,0.8})

				DA_RightClickMenu.epgpawardFrame.value=DA.EditBoxCreater(nil,DA_RightClickMenu.epgpawardFrame,{"TOPLEFT", DA_RightClickMenu.epgpawardFrame, "TOPLEFT", 60, -30},{50,18},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 9.5},
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); DA_RightClickMenu.epgpawardFrame.Dropdown:Hide();self.focusgained=nil end,
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); DA_RightClickMenu.epgpawardFrame.Dropdown:Hide();self.focusgained=nil end, --enter here
					function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); DA_RightClickMenu.epgpawardFrame.Dropdown:Hide();self.focusgained=nil end,
					function(self)
						if self:GetParent():IsShown() then
							self.t:SetBlendMode('blend');
							self.focusgained=1
							Dropdown_rerender()
						end
					end,
					function(self)
						if self:GetParent():IsShown() and self.focusgained then
							Dropdown_rerender()
						end
					end
				)
				DA.FontCreater(nil,L['value'],{"LEFT",DA_RightClickMenu.epgpawardFrame.value,"LEFT",3,15},DA_RightClickMenu.epgpawardFrame.value,15,170,{UIDarkAngelFontConsolas:GetFont(), 10},'left',{0.85,1,1,0.8})

				DA.CreateFFGButton2(nil,DA_RightClickMenu.epgpawardFrame.value,{"TOPRIGHT",DA_RightClickMenu.epgpawardFrame.value,"TOPRIGHT",0,0},5,5,'x',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 6},function() DA_RightClickMenu.epgpawardFrame.value:SetText("") end,nil,nil,'left')

				function Dropdown_rerender()
					local entries = DA.getRecentAwardsFiltered(DA_RightClickMenu.epgpawardFrame.reason:GetText(), DA_RightClickMenu.epgpawardFrame.value:GetText())
					if #entries == 0 then
						DA_RightClickMenu.epgpawardFrame.Dropdown:Hide()
						return
					end

					local displaydate
					local counted = 0
					for i=1,20 do
						local entry = entries[i]

						if not entry then
							DA_RightClickMenu.epgpawardFrame.Dropdown['btn'..i]:Hide()
						else

							local name,epgp,value,reason,timest = unpack(entry)
							local dat,tim = unpack(timest)

							local printdate
							if not displaydate then
								displaydate=dat
								printdate=true
							elseif displaydate==dat then
							else
								printdate=true
								displaydate=dat
							end

							local TimeText = ((printdate and "|cff85aaaa"..dat or string.rep(" ", #dat)) .. " |r"..tim )

							DA_RightClickMenu.epgpawardFrame.Dropdown['btn'..i]:SetText(TimeText .. "  |r"..name.. "  |r"..DA.getColoredRecentAwardValue(epgp,value).. " |r("..reason.."|r)")
							DA_RightClickMenu.epgpawardFrame.Dropdown['btn'..i]:SetScript("OnClick",function()
								DA_RightClickMenu.epgpawardFrame.reason:ClearFocus()
								DA_RightClickMenu.epgpawardFrame.value:ClearFocus()
								DA_RightClickMenu.epgpawardFrame.reason:SetText(reason)
								DA_RightClickMenu.epgpawardFrame.value:SetText(value)
								DA.SetRecentAwardBtnTxt(epgp, DA_RightClickMenu.epgpawardFrame.epgp)
							end)
							DA_RightClickMenu.epgpawardFrame.Dropdown['btn'..i]:Show()
							counted = counted + 1
						end
					end
					DA_RightClickMenu.epgpawardFrame.Dropdown:SetSize(270,((counted * 11) + 1))
					DA_RightClickMenu.epgpawardFrame.Dropdown:Show()
				end
			end
		DA_RightClickMenu.GKick=DA.CreateFFGButton2(nil,DA_RightClickMenu,{"LEFT",DA_RightClickMenu,"TOPRIGHT",-75,-95},14,73,L['G.Kick'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
			if DA_RightClickMenu.player~=UnitName('player') then
				if CanGuildRemove() then
					if IsShiftKeyDown() then
						GuildUninvite(DA_RightClickMenu.player)
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
		DA_RightClickMenu.GKick.fs:SetTextColor(1,0.88,0.88,1)

		DA_RightClickMenu.hiddenframe=CreateFrame('Frame');DA_RightClickMenu.hiddenframe:Hide()

		DA_RightClickMenu.target=DA.SecButtonCreater(nil,DA_RightClickMenu.hiddenframe,{'TOPRIGHT'},14,44,L['target'],nil,'left')
		DA_RightClickMenu.focus=DA.SecButtonCreater(nil,DA_RightClickMenu.hiddenframe,{'TOPRIGHT'},14,44,L['focus'],nil,'left')

		DA_RightClickMenu.MT=DA.SecButtonCreater(nil,DA_RightClickMenu.hiddenframe,{'TOPRIGHT'},15,30,'')
			DA_RightClickMenu.MT.icon=DA_RightClickMenu:CreateTexture(nil, "BACKGROUND");
			DA_RightClickMenu.MT.icon:SetTexture("Interface\\GroupFrame\\UI-Group-MainTankIcon")
			DA_RightClickMenu.MT.icon:SetPoint('center',DA_RightClickMenu.MT,'center')
			DA_RightClickMenu.MT.icon:SetParent(DA_RightClickMenu.MT);DA_RightClickMenu.MT.icon:SetBlendMode("blend")

		DA_RightClickMenu.OT=DA.SecButtonCreater(nil,DA_RightClickMenu.hiddenframe,{'TOPRIGHT'},15,30,'')
			DA_RightClickMenu.OT.icon=DA_RightClickMenu:CreateTexture(nil, "BACKGROUND")
			DA_RightClickMenu.OT.icon:SetTexture("Interface\\GroupFrame\\UI-Group-MainAssistIcon")
			DA_RightClickMenu.OT.icon:SetPoint('center',DA_RightClickMenu.OT,'center')
			DA_RightClickMenu.OT.icon:SetParent(DA_RightClickMenu.OT)
			DA_RightClickMenu.OT.icon:SetBlendMode("blend")

		DA_RightClickMenu.assist=DA.CreateFFGButton2(nil,DA_RightClickMenu,{"CENTER",DA_RightClickMenu,"TOPRIGHT",-123.5,-66},15,30,'','',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self,butt)
			if butt=='LeftButton' then
				if UnitIsPartyLeader('player') then
					if UnitIsRaidOfficer(DA_RightClickMenu.player) then
						DemoteAssistant(DA_RightClickMenu.player)
					else
						PromoteToAssistant(DA_RightClickMenu.player)
					end
				end
			elseif butt=='RightButton' and IsShiftKeyDown() and UnitIsPartyLeader('player') and DA_RightClickMenu.player~=UnitName('player') then
				PromoteToLeader(DA_RightClickMenu.player)
			end
		end,'optmenuleader')
		DA_RightClickMenu.assist.icon=DA_RightClickMenu:CreateTexture(nil, "BACKGROUND"); DA_RightClickMenu.assist.icon:SetTexture("Interface\\GroupFrame\\UI-Group-AssistantIcon"); DA_RightClickMenu.assist.icon:SetPoint('center',DA_RightClickMenu.assist,'center'); DA_RightClickMenu.assist.icon:SetParent(DA_RightClickMenu.assist);DA_RightClickMenu.assist.icon:SetBlendMode("blend")

		DA_RightClickMenu.looter=DA.CreateFFGButton2(nil,DA_RightClickMenu,{"CENTER",DA_RightClickMenu,"TOPRIGHT",-92,-66},15,30,'','',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self,butt)
			if UnitIsPartyLeader('player') then
				DA_RightClickMenu.lootername=false
				if GetNumRaidMembers()==0 then return end
				for i=1,GetNumRaidMembers() do

					local nam, _, _, _, _, _, _, _, _, _, isML = GetRaidRosterInfo(i)
					if isML then
						DA_RightClickMenu.lootername=nam
						break
					end
				end

				DA_RightClickMenu.assist:SetAlpha(1)
				DA_RightClickMenu.assist:Enable()
				DA_RightClickMenu.looter:SetAlpha(1)
				DA_RightClickMenu.looter:Enable()

				if DA_RightClickMenu.lootername==DA_RightClickMenu.player then
					if UnitIsPartyLeader(DA_RightClickMenu.player) then
					else
						DA.Print('selected looter '..UnitName('player'))
						SetLootMethod("master", UnitName('player'))
					end
				else
					SetLootMethod("master", DA_RightClickMenu.player)
				end
			else
				DA_RightClickMenu.assist:SetAlpha(0.5)
				DA_RightClickMenu.assist:Disable()
				DA_RightClickMenu.looter:SetAlpha(0.5)
				DA_RightClickMenu.looter:Disable()
			end
		end)
		DA_RightClickMenu.looter.icon=DA_RightClickMenu:CreateTexture(nil, "BACKGROUND"); DA_RightClickMenu.looter.icon:SetTexture("Interface\\GroupFrame\\UI-Group-MasterLooter"); DA_RightClickMenu.looter.icon:SetPoint('center',DA_RightClickMenu.looter,'center'); DA_RightClickMenu.looter.icon:SetParent(DA_RightClickMenu.looter);DA_RightClickMenu.looter.icon:SetBlendMode("blend")

		DA_RightClickMenu.kick=DA.CreateFFGButton2(nil,DA_RightClickMenu,{"CENTER",DA_RightClickMenu,"TOPRIGHT",-116.5,-90},15,44,L['kick'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9},function()
			if UnitIsRaidOfficer('player') and UnitInRaid(DA_RightClickMenu.player) then
				if GetLootMethod()=='master' and DA_RightClickMenu.lootername and DA_RightClickMenu.lootername==DA_RightClickMenu.player then
					SetLootMethod("master", UnitName('player'))
					UninviteUnit(DA_RightClickMenu.player)
				else
					UninviteUnit(DA_RightClickMenu.player)
				end
			end
		end,nil,nil,'left')
		DA_RightClickMenu.kick.fs:SetTextColor(1,0.88,0.88,1)


	end
end)

function DA.OpenOptMenu(parent,name, in_guild_backup)
	DA_RightClickMenu:Hide()
	DA_RightClickMenu:SetPoint("TOPLEFT",parent,"BOTTOM")
	if not name then return end

	if parent.ismtot and parent.ismtot==2 then
		DA_RightClickMenu.ismt=true
	elseif parent.ismtot and parent.ismtot==1 then
		DA_RightClickMenu.ismt=false
	elseif parent.ismtot and parent.ismtot==0 then
		DA_RightClickMenu.ismt=false
	else
		DA_RightClickMenu.ismt=false
	end

	if (DA_RightClickMenu.calledfrom=="DA_Awarder" or DA_RightClickMenu.calledfrom=="DA_BidTracker") and DA.IsInSameRaid(name) then
		DA_RightClickMenu:SetSize(141,104)

		if InCombatLockdown() then
			if UnitIsRaidOfficer('player') then
				DA_RightClickMenu.kick:Show()
				DA_RightClickMenu.kick:SetAlpha(1)
				DA_RightClickMenu.kick:Enable()
			else
				DA_RightClickMenu.kick:Hide()
				DA_RightClickMenu.kick:SetAlpha(0.5)
				DA_RightClickMenu.kick:Disable()
			end
		else
			DA_RightClickMenu.target:Show()
			DA_RightClickMenu.focus:Show()
			DA_RightClickMenu.MT:Show()
			DA_RightClickMenu.OT:Show()
			if UnitIsRaidOfficer('player') then
				DA_RightClickMenu.kick:Show()
				DA_RightClickMenu.kick:SetAlpha(1)
				DA_RightClickMenu.kick:Enable()
				DA_RightClickMenu.MT:SetAlpha(1)
				DA_RightClickMenu.MT:Enable()
				DA_RightClickMenu.OT:SetAlpha(1)
				DA_RightClickMenu.OT:Enable()
			else
				DA_RightClickMenu.kick:SetAlpha(0.5)
				DA_RightClickMenu.kick:Disable()
				DA_RightClickMenu.MT:SetAlpha(0.5)
				DA_RightClickMenu.MT:Disable()
				DA_RightClickMenu.OT:SetAlpha(0.5)
				DA_RightClickMenu.OT:Disable()
			end
			DA_RightClickMenu.target:SetAlpha(1)
			DA_RightClickMenu.focus:SetAlpha(1)
			DA_RightClickMenu.target:Enable()
			DA_RightClickMenu.focus:Enable()

			DA_RightClickMenu.target:SetAttribute("macrotext", '/target '..name)
			DA_RightClickMenu.focus:SetAttribute("macrotext", '/focus '..name)


			if GetPartyAssignment('MAINTANK',name, 1) then
				DA_RightClickMenu.MT:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Green]])
				DA_RightClickMenu.OT:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]])

				local ottxt="/run ClearPartyAssignment('MAINTANK','"..name.."', 1);DA_RightClickMenu.ismt=false \n"
				DA_RightClickMenu.MT:SetAttribute("macrotext", ottxt)
				local ottxt2="/run if GetPartyAssignment('MAINTANK','"..name.."', 1) then ClearPartyAssignment('MAINTANK','"..name.."', 1) end;DA_RightClickMenu.ismt=false \n"; ottxt2=ottxt2.."/mainassist "..name
				DA_RightClickMenu.OT:SetAttribute("macrotext", ottxt2)
			elseif GetPartyAssignment('MAINASSIST',name, 1) then
				DA_RightClickMenu.MT:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]])
				DA_RightClickMenu.OT:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Green]])

				local ottxt="/run DA_RightClickMenu.ismt=true \n"; ottxt=ottxt.."/maintank "..name
				DA_RightClickMenu.MT:SetAttribute("macrotext", ottxt)
				local ottxt2="/run ClearPartyAssignment('MAINASSIST','"..name.."', 1) ;DA_RightClickMenu.ismt=false \n"
				DA_RightClickMenu.OT:SetAttribute("macrotext", ottxt2)
			else
				DA_RightClickMenu.MT:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]])
				DA_RightClickMenu.OT:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]])

				local ottxt="/run DA_RightClickMenu.ismt=true \n"; ottxt=ottxt.."/maintank "..name
				DA_RightClickMenu.MT:SetAttribute("macrotext", ottxt)
				local ottxt2="/run if GetPartyAssignment('MAINTANK','"..name.."', 1) then ClearPartyAssignment('MAINTANK','"..name.."', 1) end;DA_RightClickMenu.ismt=false \n"; ottxt2=ottxt2.."/mainassist "..name
				DA_RightClickMenu.OT:SetAttribute("macrotext", ottxt2)
			end


		end

		if UnitIsPartyLeader('player') then
			if GetLootMethod()=='master' then
				DA_RightClickMenu.lootername=false
				if GetNumRaidMembers()==0 then return end
				for i=1,GetNumRaidMembers() do

					local nam, _, _, _, _, _, _, _, _, _, isML = GetRaidRosterInfo(i)
					if isML then
						DA_RightClickMenu.lootername=nam
						break
					end
				end
			end

			DA_RightClickMenu.assist:SetAlpha(1)
			DA_RightClickMenu.assist:Enable()
			DA_RightClickMenu.looter:SetAlpha(1)
			DA_RightClickMenu.looter:Enable()
			if UnitIsPartyLeader(name) then
				DA_RightClickMenu.assist:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Red]])
			elseif UnitIsRaidOfficer(name) then
				DA_RightClickMenu.assist:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Green]])
			else
				DA_RightClickMenu.assist:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]])
			end

			if GetLootMethod()=='master' and DA_RightClickMenu.lootername==name then
				if UnitIsPartyLeader(name) then
					DA_RightClickMenu.looter:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Red]])
				else
					DA_RightClickMenu.looter:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Green]])
				end
			else
				DA_RightClickMenu.looter:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]])
			end
		else
			DA_RightClickMenu.assist:SetAlpha(0.5)
			DA_RightClickMenu.assist:Disable()
			DA_RightClickMenu.looter:SetAlpha(0.5)
			DA_RightClickMenu.looter:Disable()
		end

		DA_RightClickMenu.assist:Show()
		DA_RightClickMenu.looter:Show()


	else
		if not InCombatLockdown() then
			DA_RightClickMenu.target:Hide()
			DA_RightClickMenu.focus:Hide()
			DA_RightClickMenu.MT:Hide()
			DA_RightClickMenu.OT:Hide()
		end
		DA_RightClickMenu:SetSize(77,104)

		DA_RightClickMenu.assist:Hide()
		DA_RightClickMenu.looter:Hide()
		DA_RightClickMenu.kick:Hide()
	end

	DA_RightClickMenu.timerticked=0
	DA_RightClickMenu.parentbtn=parent

	DA_RightClickMenu.player=name
	if FEP_gMain[name] then
		if DA.DecodeNote(FEP_gMain[name])=='m' or DA.DecodeNote(FEP_gMain[name])=='f' then
			DA_RightClickMenu.ofnote=name
		elseif DA.DecodeNote(FEP_gMain[name])=='t' and FEP_gMain[FEP_gMain[name]] and DA.DecodeNote(FEP_gMain[FEP_gMain[name]])=='m' then
			DA_RightClickMenu.ofnote=FEP_gMain[name]
		end
	elseif FEP_L_gMain[DA_CurrentGuild][name] then
		if FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]] and DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]])=='m' then
			DA_RightClickMenu.ofnote=FEP_L_gMain[DA_CurrentGuild][name]
		end
	end

	if DA_RightClickMenu.player and not DA_RightClickMenu.ofnote then
		DA_RightClickMenu.altnote=name
	else
		DA_RightClickMenu.altnote=nil
	end

	if UnitInRaid(name) then
		DA_RightClickMenu.invite:SetAlpha(0.5)
		DA_RightClickMenu.invite:Disable()
	else
		DA_RightClickMenu.invite:SetAlpha(1)
		DA_RightClickMenu.invite:Enable()

	end

	if in_guild_backup then
		DA_RightClickMenu.epgpaward:Disable()
		DA_RightClickMenu.GKick:Disable()
	else
		DA_RightClickMenu.epgpaward:Enable()
		DA_RightClickMenu.GKick:Enable()
	end

	DA_RightClickMenu:Show()
	DA.ResumeTimer('OptHider')

	DA_RightClickMenu:ClearAllPoints()

end