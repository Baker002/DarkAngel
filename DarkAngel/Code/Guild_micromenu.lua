
---@class DarkAngelAddon
local DA = DarkAngel
local L = DA.L

function DA.UpdateMicroMenu(typ)
	tinsert(DA_Fep_bulk,function() DA.GetGuildData() end)
	tinsert(DA_Fep_bulk,function() DA.GuildSetAllLines() end)
	tinsert(DA_Fep_bulk,function()
		if DarkAngelGUI.Guild.micromenu:IsShown() then
			for i=1,DA.GetNumGMembers() do
				local name, rank, rankIndex, level, _, _, note, officernote, _, _, class = GetGuildRosterInfo(i);
				if name and name==DarkAngelGUI.Guild.micromenu.plbox:GetText() then
					if not typ then
						-- DarkAngelGUI.Guild.micromenu.ranksmenubtn.fs:SetText("["..rankIndex.."]"..rank)
						DarkAngelGUI.Guild.micromenu.ranksmenuFrame.storedvalue=rankIndex
						DarkAngelGUI.Guild.micromenu.ranksmenuFrame:reRender()
						DarkAngelGUI.Guild.micromenu.notebox:SetText(note)
						DarkAngelGUI.Guild.micromenu.notebox.orignote=note
						DarkAngelGUI.Guild.micromenu.ofnotebox:SetText(officernote)
						DarkAngelGUI.Guild.micromenu.ofnotebox.orignote=officernote
						return
					elseif typ=='plrankID' then
						-- DarkAngelGUI.Guild.micromenu.ranksmenubtn.fs:SetText("["..rankIndex.."]"..rank)
						DarkAngelGUI.Guild.micromenu.ranksmenuFrame.storedvalue=rankIndex
						DarkAngelGUI.Guild.micromenu.ranksmenuFrame:reRender()
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

DA.AddToBuildQueue("About", function()
    --main
    do
        DarkAngelGUI.Guild.micromenu=DA.FrameCreater(nil,DarkAngelGUI.Guild,188.25,140,{"TOPLEFT",DarkAngelGUI.Guild,'TOPRIGHT',3,0})

        DA.CloseButtonCreater(nil,DarkAngelGUI.Guild.micromenu,{"center", DarkAngelGUI.Guild.micromenu, "TOPRIGHT", -8.5,-8.5},12,12,'x')

        DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",90,-11},12,50,L['tvins'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
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

        DarkAngelGUI.Guild.micromenu.deletelocal=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",10,-85},10,45,L['delete'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Red]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self,clicktype)
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
        DarkAngelGUI.Guild.micromenu.ranksmenubtn, DarkAngelGUI.Guild.micromenu.ranksmenuFrame=DA.CreateDropdownNoValueSelector({
            rel = DarkAngelGUI.Guild.micromenu,
            point = {"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",5,-11},
            width = 80,
            height = 12,
            frpoint = "TOP",
            valuesrosterDynamic = function()
                local gcnr=GuildControlGetNumRanks()
                local myrank=({GetGuildInfo('player')})[3]
                local targetrank=
                    DarkAngelGUI.Guild.micromenu and
                    DarkAngelGUI.Guild.micromenu.ranksmenuFrame and
                    DarkAngelGUI.Guild.micromenu.ranksmenuFrame.storedvalue or
                    myrank or 5
                local canDoRanks, canPromote, canDemote
                if targetrank<myrank or targetrank==myrank then
                    --target is same or HIGHER rank
                else
                    canDoRanks = true
                    canPromote,canDemote = CanGuildPromote(), CanGuildDemote()
                end
                local valuesroster = {}
                for i=1,10 do
                    if i<=gcnr then
                        table.insert(valuesroster, { text = "["..(i-1).."]"..GuildControlGetRankName(i), value = i-1, 
                            isDefault = i == targetrank or false,
                            funcOnSelection = function()
                                if DarkAngelGUI.Guild.micromenu.plbox then
                                    DA.DemotePromotePlayer(DarkAngelGUI.Guild.micromenu.plbox:GetText(),targetrank,i)
                                end
                            end,
                            funcframeHideOnSelection = function()
                                if fuckingOptions.mmenucloserank then return true end
                            end,
                            funcDrawLocked = function ()
                                if not canDoRanks or i-1<=myrank then return true end
                                if i-1 > targetrank and not canDemote then
                                    return true
                                elseif i-1 < targetrank and not canPromote then
                                    return true
                                end
                                
                            end
                        })
                    else
                        table.insert(valuesroster, { text = "#"..i, value = i-1, isHidden = true})
                    end
                end
                return valuesroster
            end,
            justh = 'left',
            optjusth = 'left',
            funcOnShow = function(s) s:reRender() end,
        })

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
        DarkAngelGUI.Guild.micromenu.noteset=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",6,-80},12,30,L['set'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
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
        DarkAngelGUI.Guild.micromenu.notecancel=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",39,-80},12,50,L['cancel'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
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
        DarkAngelGUI.Guild.micromenu.noterefresh=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",92,-80},12,50,L['refresh'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
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
        DarkAngelGUI.Guild.micromenu.ofnoteset=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",6,-120},12,30,L['set'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
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
        DarkAngelGUI.Guild.micromenu.ofnotecancel=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",39,-120},12,50,L['cancel'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
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
        DarkAngelGUI.Guild.micromenu.ofnoterefresh=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"TOPLEFT",DarkAngelGUI.Guild.micromenu,"TOPLEFT",92,-120},12,50,L['refresh'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
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
        DarkAngelGUI.Guild.micromenu.ofnotefreeze=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.micromenu,{"CENTER",DarkAngelGUI.Guild.micromenu,"TOPLEFT",110,-103},10,10,'f',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Blue]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
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

        end)
        local function offnoteFreezeUpdate()
            if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
                DarkAngelGUI.Guild.micromenu.ofnotefreeze:Show()
            else
                DarkAngelGUI.Guild.micromenu.ofnotefreeze:Hide()
            end
        end
        offnoteFreezeUpdate()
        table.insert(DA.RunOnGuildUpdate, offnoteFreezeUpdate)



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
        DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.micromenu,{"CENTER",DarkAngelGUI.Guild.micromenu,"TOPLEFT",5,-5},7,7,nil,function(self) fuckingOptions.mmenuqcopy=(self:GetChecked() or false) end,{'fuckingOptions','mmenuqcopy'},'mmenuqcopy')
        DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.micromenu,{"CENTER",DarkAngelGUI.Guild.micromenu,"TOPLEFT",13,-5},7,7,nil,function(self) fuckingOptions.mmenuleavefocus=(self:GetChecked() or false) end,{'fuckingOptions','mmenuleavefocus'},'mmenuleavefocus')
        DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.micromenu,{"CENTER",DarkAngelGUI.Guild.micromenu,"TOPLEFT",21,-5},7,7,nil,function(self) fuckingOptions.mmenucloserank=(self:GetChecked() or false) end,{'fuckingOptions','mmenucloserank'},'mmenucloserank')
    end

end)