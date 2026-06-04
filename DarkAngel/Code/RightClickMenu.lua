
---@class DarkAngelAddon
local DA = DarkAngel
local L = DA.L
local LGT=DA.LGT

DA.AddToBuildQueue("RightClickMenuFrame", function()

	if UISpecialFrames then
		tinsert(UISpecialFrames, "DarkAngelGUI")
		tinsert(UISpecialFrames, "DA_RightClickMenu")
	end


	do --frame
		DA_RightClickMenu = DA.FrameCreater("DA_RightClickMenu",UIParent,62,105,{"TOPLEFT",UIParent,"TOPLEFT"},nil,{0.1,0.12,0.19,0.7},nil,true)
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
		DA_RightClickMenu.epgpawardFrame.t:SetTexture(0.1,0.12,0.19,0.7)
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
					DA_RightClickMenu.epgpawardFrame.Dropdown['btn'..i]=DA.CreateFFGButton2(nil,DA_RightClickMenu.epgpawardFrame.Dropdown,{"TOPLEFT", DA_RightClickMenu.epgpawardFrame.Dropdown, "TOPLEFT", 1,10-11*i},10,268,"",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function(self)

					end,nil,nil,'left')
				end
				local Dropdown_rerender

				DA.HelpCreater(DA_RightClickMenu.epgpawardFrame,{"CENTER",DA_RightClickMenu.epgpawardFrame,"TOPLEFT",52.5,-8},'awardprocent_tt',10,10)

				DA_RightClickMenu.epgpawardFrame.start=DA.CreateFFGButton2(nil,DA_RightClickMenu.epgpawardFrame,{"TOPLEFT", DA_RightClickMenu.epgpawardFrame, "TOPLEFT", 60, -2},13,50,L['add'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Red]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
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
					DA_RightClickMenu:Hide()
					DA.ResumeTimer('greset')
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

		DA_RightClickMenu.kick=DA.CreateFFGButton2(nil,DA_RightClickMenu,{"CENTER",DA_RightClickMenu,"TOPRIGHT",-116.5,-85},15,44,L['kick'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9},function()
			if UnitIsRaidOfficer('player') and UnitInRaid(DA_RightClickMenu.player) then
				if GetLootMethod()=='master' and DA_RightClickMenu.lootername and DA_RightClickMenu.lootername==DA_RightClickMenu.player then
					SetLootMethod("master", UnitName('player'))
					if IsShiftKeyDown() then
						UninviteUnit(DA_RightClickMenu.player)
					else
						DA.Print(L['requires Shift+Click'])
						return
					end
				else
					if IsShiftKeyDown() then
						UninviteUnit(DA_RightClickMenu.player)
					else
						DA.Print(L['requires Shift+Click'])
						return
					end
				end
			end
		end,nil,nil,'left')
		DA_RightClickMenu.kick.fs:SetTextColor(1,0.88,0.88,1)


	end

	do --ms change
		local SelectRole
		local SelectSpec
		local PendingMS = {}
		local letPlayer
		local letClass
		local letRole
		local letSpec
		DA_RightClickMenu.mschangeFrame = DA.FrameCreater(nil,DA_RightClickMenu,172,70,{"TOPLEFT",DA_RightClickMenu,"BOTTOMLEFT",0,-2},nil,{0.1,0.12,0.19,0.7},nil,true)
		local closebtn = DA.CloseButtonCreater(nil,DA_RightClickMenu.mschangeFrame,{"center", DA_RightClickMenu.mschangeFrame, "TOPRIGHT", -7.5,-7.5},10,10,'x')
		local frame = DA_RightClickMenu.mschangeFrame
		DA_RightClickMenu.mschangeOpenBtn = DA.CreateFFGButton2(nil,DA_RightClickMenu,{"CENTER",DA_RightClickMenu,"BOTTOMLEFT",30,6},8,40,'^^^',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"}, function(s)
			DA_RightClickMenu.mschangeOpenBtn.interracted = true
			if not s.state then
				s.state = true
				frame:Hide()
				s:SetText("+++")
			else
				s.state = false
				frame:Show()
				s:SetText("^^^")

			end
		end)
		DA_RightClickMenu.mschangeOpenBtn:Hide()
		DA_RightClickMenu.mschangeOpenBtn.interracted = false
		closebtn:HookScript("OnClick",function() DA_RightClickMenu.mschangeOpenBtn:SetText("+++");DA_RightClickMenu.mschangeOpenBtn.state=true;DA_RightClickMenu.mschangeOpenBtn.interracted = true end)
		frame:Hide()
		frame.classBtn = DA.IconicButtonCreater(frame, {"TOPLEFT",frame,"TOPLEFT",2,-13}, 25, "", nil, "Class")
		frame.classBtn:EnableMouse(false)
		frame.roleBtn = DA.IconicButtonCreater(frame, {"LEFT",frame.classBtn,"RIGHT",2,0}, 25, "", nil, "Current Role")
		frame.roleBtn:EnableMouse(false)
		frame.specBtn = DA.IconicButtonCreater(frame, {"TOP",frame.roleBtn,"BOTTOM",0,-2}, 25, "", nil, "Current Spec")
		frame.specBtn:EnableMouse(false)
		frame.defaultBtn = DA.IconicButtonCreater(frame, {"TOP",frame.classBtn,"BOTTOM",0,-2}, 25, "", nil, L["reset"],function()
			DA_Tooltip:Hide()
			local name = letPlayer
			table.wipe(PendingMS)

			DarkAngel_BTMS[name] = nil

			local pack ={
				name=name,
				class=letClass,
				role=letRole,
				spec=letSpec,
				msRole=nil,
				msSpec=nil
			}
			DA.TimerAfterShort(0.1, function() frame:UpdateMSUI(pack) end)
		end)
		frame.defaultBtn:SetNormalTexture([[Interface\Icons\Spell_Shadow_SacrificialShield]])
		frame.defaultBtn:SetHighlightTexture("")
		frame.defaultBtn:Disable()
		frame.defaultBtn.switch(false)
		
		frame.currentFont=DA.FontCreater(nil,L["current"],{"LEFT",frame.classBtn,"TOPLEFT",1,6},frame.classBtn,30,100,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'left')

		frame.roleButtons = {}

		local roleOrder = {
			"tank",
			"healer",
			"melee",
			"caster"
		}

		for i, role in ipairs(roleOrder) do
			local btn = DA.IconicButtonCreater(frame, {"TOPLEFT",frame,"TOPLEFT",70 + (i-1)*25,-13}, 25, DA.RolesTextures[role], nil, role,function()
				SelectRole(role)
				DA_Tooltip:Hide()
			end)
			btn.switch(false)
			frame.roleButtons[role] = btn
		end

		frame.specButtons = {}

		for i = 1, 3 do
			local btn = DA.IconicButtonCreater(frame, {"TOPLEFT",frame,"TOPLEFT",82.5 + (i-1)*25,-40}, 25, "", nil, function()
				local class = letClass
				if class then
					local trnames = {LGT:GetTreeNames(class)}
					return #trnames==3 and trnames[i] or "Spec #"..i
				else
					return "Spec #"..i
				end
			end, function() 
				SelectSpec(i)
				DA_Tooltip:Hide()
			end)

			btn.switch(false)

			frame.specButtons[i] = btn
		end
		
		frame.MSFont=DA.FontCreater(nil,L["MS Change"],{"LEFT",frame.classBtn,"TOPLEFT",71,6},frame.classBtn,30,100,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'left')

		DA.HelpCreater(frame,{"CENTER", frame, "TOPRIGHT", -18,-7.5},'mschange_rightclickmenu',10,10)
		
		local specTextures = {
			WARRIOR = {
				[[Interface\Icons\Ability_Warrior_SavageBlow]],      -- Arms
				[[Interface\Icons\Ability_Warrior_InnerRage]],       -- Fury
				[[Interface\Icons\Ability_Warrior_DefensiveStance]], -- Protection
			},
			PALADIN = {
				[[Interface\Icons\Spell_Holy_HolyBolt]],             -- Holy
				[[Interface\Icons\Spell_Holy_DevotionAura]],         -- Protection
				[[Interface\Icons\Ability_Paladin_HeartOfTheCrusader]], -- Retribution
			},
			HUNTER = {
				[[Interface\Icons\Ability_Hunter_BeastTaming]],      -- Beast Mastery
				[[Interface\Icons\Ability_Marksmanship]],            -- Marksmanship
				[[Interface\Icons\Ability_Hunter_Swiftness]],        -- Survival
			},
			ROGUE = {
				[[Interface\Icons\Ability_Rogue_Eviscerate]],        -- Assassination
				[[Interface\Icons\Ability_BackStab]],                -- Combat
				[[Interface\Icons\Ability_Stealth]],                 -- Subtlety
			},
			PRIEST = {
				[[Interface\Icons\Spell_Holy_WordFortitude]],        -- Discipline
				[[Interface\Icons\Spell_Holy_GuardianSpirit]],       -- Holy
				[[Interface\Icons\Spell_Shadow_ShadowWordPain]],     -- Shadow
			},
			DEATHKNIGHT = {
				[[Interface\Icons\Spell_Deathknight_BloodPresence]], -- Blood
				[[Interface\Icons\Spell_Deathknight_FrostPresence]], -- Frost
				[[Interface\Icons\Spell_Deathknight_UnholyPresence]],-- Unholy
			},
			SHAMAN = {
				[[Interface\Icons\Spell_Nature_Lightning]],          -- Elemental
				[[Interface\Icons\Spell_Nature_LightningShield]],    -- Enhancement
				[[Interface\Icons\Spell_Nature_MagicImmunity]],      -- Restoration
			},
			MAGE = {
				[[Interface\Icons\Spell_Holy_MagicalSentry]],        -- Arcane
				[[Interface\Icons\Spell_Fire_FireBolt02]],           -- Fire
				[[Interface\Icons\Spell_Frost_FrostBolt02]],         -- Frost
			},
			WARLOCK = {
				[[Interface\Icons\Spell_Shadow_DeathCoil]],          -- Affliction
				[[Interface\Icons\Spell_Shadow_Metamorphosis]],      -- Demonology
				[[Interface\Icons\Spell_Shadow_RainOfFire]],         -- Destruction
			},
			DRUID = {
				[[Interface\Icons\Ability_Druid_Balance]],           -- Balance
				[[Interface\Icons\Ability_Druid_CatForm]],           -- Feral
				[[Interface\Icons\Spell_Nature_HealingTouch]],       -- Restoration
			},
		}
		local QUESTION_MARK = [[Interface\Icons\INV_Misc_QuestionMark]]
		local function GetSpecIcon(class, spec)
			if not class or not spec or type(spec) ~= "number" then
				return QUESTION_MARK
			end

			local classSpecs = specTextures[class]
			if not classSpecs then
				return QUESTION_MARK
			end

			return classSpecs[spec] or QUESTION_MARK
		end
		local function btnSetRoleTxt(btn, role)
			btn:SetNormalTexture(role and DA.RolesTextures[role] or QUESTION_MARK)
		end
		local RoleSpecMap = {
			WARRIOR = {
				tank = {
					specs = {3},
				},
				melee = {
					default = 2, -- Fury
					specs = {1,2}, -- Arms/Fury
				},
			},
			PALADIN = {
				tank = {
					specs = {2},
				},
				healer = {
					specs = {1},
				},
				melee = {
					specs = {3},
				},
			},
			DEATHKNIGHT = {
				tank = {
					default = 1, -- Blood
					specs = {1,2,3},
				},
				melee = {
					-- no default
					specs = {1,2,3},
				},
			},
			DRUID = {
				tank = {
					specs = {2},
				},
				melee = {
					specs = {2},
				},
				caster = {
					specs = {1},
				},
				healer = {
					specs = {3},
				},
			},
			PRIEST = {
				healer = {
					default = 1, -- Discipline
					specs = {1,2}, -- Disc/Holy
				},
				caster = {
					specs = {3},
				},
			},
			SHAMAN = {
				healer = {
					specs = {3},
				},
				melee = {
					specs = {2},
				},
				caster = {
					specs = {1},
				},
			},
			MAGE = {
				caster = {
					-- no default
					specs = {1,2,3},
				},
			},
			WARLOCK = {
				caster = {
					-- no default
					specs = {1,2,3},
				},
			},
			HUNTER = {
				caster = {
					default = 2, -- Marksmanship
					specs = {1,2,3},
				},
			},
			ROGUE = {
				melee = {
					default = 2, -- Combat
					specs = {1,2,3},
				},
			},
		}
		local SpecRoleMap = {
			WARRIOR = {
				[1] = { -- Arms
					roles = {"melee"},
				},
				[2] = { -- Fury
					roles = {"melee"},
				},
				[3] = { -- Protection
					roles = {"tank"},
				},
			},
			PALADIN = {
				[1] = { -- Holy
					roles = {"healer"},
				},
				[2] = { -- Protection
					roles = {"tank"},
				},
				[3] = { -- Retribution
					roles = {"melee"},
				},
			},
			DEATHKNIGHT = {
				[1] = { -- Blood
					default = "tank",
					roles = {"tank","melee"},
				},
				[2] = { -- Frost
					default = "melee",
					roles = {"tank","melee"},
				},
				[3] = { -- Unholy
					default = "melee",
					roles = {"tank","melee"},
				},
			},
			DRUID = {
				[1] = { -- Balance
					roles = {"caster"},
				},
				[2] = { -- Feral
					default = "melee",
					roles = {"tank","melee"},
				},
				[3] = { -- Restoration
					roles = {"healer"},
				},
			},
			PRIEST = {
				[1] = { -- Discipline
					roles = {"healer"},
				},
				[2] = { -- Holy
					roles = {"healer"},
				},
				[3] = { -- Shadow
					roles = {"caster"},
				},
			},
			SHAMAN = {
				[1] = { -- Elemental
					roles = {"caster"},
				},
				[2] = { -- Enhancement
					roles = {"melee"},
				},
				[3] = { -- Restoration
					roles = {"healer"},
				},
			},
			MAGE = {
				[1] = { -- Arcane
					roles = {"caster"},
				},
				[2] = { -- Fire
					roles = {"caster"},
				},
				[3] = { -- Frost
					roles = {"caster"},
				},
			},
			WARLOCK = {
				[1] = { -- Affliction
					roles = {"caster"},
				},
				[2] = { -- Demonology
					roles = {"caster"},
				},
				[3] = { -- Destruction
					roles = {"caster"},
				},
			},
			HUNTER = {
				[1] = { -- Beast Mastery
					roles = {"caster"},
				},
				[2] = { -- Marksmanship
					roles = {"caster"},
				},
				[3] = { -- Survival
					roles = {"caster"},
				},
			},
			ROGUE = {
				[1] = { -- Assassination
					roles = {"melee"},
				},
				[2] = { -- Combat
					roles = {"melee"},
				},
				[3] = { -- Subtlety
					roles = {"melee"},
				},
			},
		}
		local function UpdateAvailableRoles(class, msRole)

			local map = RoleSpecMap[class]

			for role, btn in pairs(frame.roleButtons) do

				if msRole and msRole==role then
					btn.switch(true)
					btn:SetAlpha(1)
					btn:EnableMouse(true)
				elseif map and map[role] then
					btn.switch(false)
					if msRole then
						btn:SetAlpha(0.7)
					else
						btn:SetAlpha(1)
					end
					btn:EnableMouse(true)
				else
					btn.switch(false)
					btn:SetAlpha(0.3)
					btn:EnableMouse(false)
				end

			end

		end
		local function UpdateSelectedSpec(msSpec)
			
			for specID, btn in pairs(frame.specButtons) do

				if msSpec and msSpec==specID then
					btn.switch(true)
					btn:SetAlpha(1)
				else
					btn.switch(false)
					btn:SetAlpha(0.7)
				end

			end
		end
		local function CommitMS()
			local name = letPlayer

			local newGlobal = {msrole=PendingMS.role, msspec=PendingMS.spec}
			DarkAngel_BTMS[name] = newGlobal

			local pack ={
				name=name,
				class=letClass,
				role=letRole,
				spec=letSpec,
				msRole=newGlobal.msrole,
				msSpec=newGlobal.msspec
			}
			DA.TimerAfterShort(0.1, function() frame:UpdateMSUI(pack) end)
		end
		SelectRole = function (role)
			local class = letClass
			PendingMS.role = role
			if PendingMS.spec then
				CommitMS()
				return
			end

			local roleData = RoleSpecMap[class][role]
			local specs = roleData.specs

			if #specs == 1 then
				PendingMS.spec = specs[1]
				CommitMS()
			elseif roleData.default then
				PendingMS.spec = roleData.default
				CommitMS()
			else
				PendingMS.spec = nil
			end
		end
		SelectSpec = function (spec)
			local class = letClass
			PendingMS.spec = spec
			if PendingMS.role then
				CommitMS()
				return
			end

			local specData = SpecRoleMap[class][spec]

			if #specData.roles == 1 then
				PendingMS.role = specData.roles[1]
				CommitMS()
			elseif specData.default then
				PendingMS.role = specData.default
				CommitMS()
			else
				PendingMS.role = nil
			end
		end
		local function clearGlobal()
			local raidroster={}
			for i=1,GetNumRaidMembers() do

				local name, _ = GetRaidRosterInfo(i)
				raidroster[name]=true
			end

			for name,_ in pairs(DarkAngel_BTMS) do
				if not UnitInRaid(name) and not raidroster[name] then
					DarkAngel_BTMS[name] = nil
				end
			end

		end
		function frame:UpdateMSUI(playerData)
			clearGlobal()
			local name =  playerData.name
			local class	= playerData.class
			local role	= playerData.role
			local spec	= playerData.spec
			local msRole = playerData.msRole or PendingMS.role
			local msSpec = playerData.msSpec or PendingMS.spec

			if letPlayer and letPlayer~=name then
				table.wipe(PendingMS)
			end
			letPlayer = name
			letClass = class
			letRole = role
			letSpec = spec

			-- Default textures
			self.classBtn:SetNormalTexture([[Interface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES]])
			self.classBtn:GetNormalTexture():SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
			btnSetRoleTxt(self.roleBtn, role)
			self.specBtn:SetNormalTexture(GetSpecIcon(class, spec) )
			for specID = 1, 3 do
				self.specButtons[specID]:SetNormalTexture(GetSpecIcon(class, specID))
			end

			-- Override exists
			UpdateAvailableRoles(class, msRole)
			UpdateSelectedSpec(msSpec)
			
			-- Default button
			if msRole or msSpec then
				self.defaultBtn:Enable()
				self.defaultBtn.switch(true)
			else
				self.defaultBtn:Disable()
				self.defaultBtn.switch(false)
			end

		end
	end
end)

function DA.OpenOptMenu(parent,name, in_guild_backup, MSChangePack)
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

		-- MS CHANGE Frame
		if DA.loaded_Modules['BidTracker'] and GetNumRaidMembers()>0 and MSChangePack then
			-- DA_RightClickMenu.mschangeFrame.mspacked = MSChangePack
			DA_RightClickMenu.mschangeOpenBtn:Show()
			if GetLootMethod()=='master' and not DA_RightClickMenu.mschangeOpenBtn.interracted then
				DA_RightClickMenu.mschangeFrame:Show()
			end
			
			--call mschangeFrame update
			DA_RightClickMenu.mschangeFrame:UpdateMSUI(MSChangePack)
		else
			DA_RightClickMenu.mschangeFrame:Hide()
			DA_RightClickMenu.mschangeOpenBtn:Hide()
		end
	else
		if not InCombatLockdown() then
			DA_RightClickMenu.target:Hide()
			DA_RightClickMenu.focus:Hide()
			DA_RightClickMenu.MT:Hide()
			DA_RightClickMenu.OT:Hide()
		end
			DA_RightClickMenu.mschangeFrame:Hide()
			DA_RightClickMenu.mschangeOpenBtn:Hide()
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