
---@class DarkAngelAddon
local DA = DarkAngel
local L = DA.L

local new_guildRank_template={
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

DA.AddToBuildQueue("GuildControl", function()
    DarkAngelGUI.Guild.GC=DA.FrameCreater(nil,UIParent,525,300,{"TOPRIGHT",DarkAngelGUI,"TOPLEFT",-2,0},nil,{0.03, 0.04, 0.07, 0.65})
    DA.CreateScaler(DarkAngelGUI.Guild.GC,0.6,2,{'fuckingOptions','GCScale'})
    local gc=DarkAngelGUI.Guild.GC
        gc:RegisterForDrag("LeftButton")
        gc:SetScript("OnDragStart", function(self) self:StartMoving() end)
        gc:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    gc.run_Bulk={}
    DA.CloseButtonCreater(nil,gc,{"center", gc, "TOPRIGHT", -8.5,-8.5},12,12,'x')

    DA_GC_ch = DA.ScrollBarCreater("DA_GC_ch",gc,{gc.width+5, gc.height-58},{"TOPLEFT", gc, "TOPLEFT", 0, -55},1)

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
                        if b<=lasttab and gc.ranksroster[i].bankpermissions[b] then
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
                    tinsert(gc.ranksroster, position, DA.DeepCopy(new_guildRank_template))
                else
                    gc.ranksroster[position]=DA.DeepCopy(new_guildRank_template)
                end
            else
                gc.ranksOnClickMenu:Hide()
                tinsert(gc.ranksroster,DA.DeepCopy(new_guildRank_template))
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
        gc.ranksroster[position]=DA.DeepCopy(new_guildRank_template)

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



    gc.restbtn=DA.CreateFFGButton2(nil,gc,{"CENTER",gc,"TOPLEFT",17,-34},12,30,'reset',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9},function()
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


    DarkAngelGUI.Guild.OpenGC_Btn=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",425,-10},12,25,'gm',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
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
    gc.ranksOnClickMenu:SetFrameLevel((gc:GetFrameLevel() or 5)+25)
    gc.ranksOnClickMenu.t:SetTexture(0.03, 0.04, 0.07, 0.8)

    gc.ranksOnClickMenu.duplicate=DA.CreateFFGButton2(nil,gc.ranksOnClickMenu,{"left",gc.ranksOnClickMenu,"topleft",1,-6},10,gc.ranksOnClickMenu.width-2,L["create duplicate rank, shift rest right"],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function() end,nil,nil,'left')
    gc.ranksOnClickMenu.duplicate:GetFontString():SetTextColor(0.5,0.8,0.9,1)
    gc.ranksOnClickMenu.new=DA.CreateFFGButton2(nil,gc.ranksOnClickMenu,{"left",gc.ranksOnClickMenu,"topleft",1,-16},10,gc.ranksOnClickMenu.width-2,L["create new rank here, shift rest right"],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function() end,nil,nil,'left')
    gc.ranksOnClickMenu.new:GetFontString():SetTextColor(0.5,0.8,0.9,1)
    gc.ranksOnClickMenu.clear=DA.CreateFFGButton2(nil,gc.ranksOnClickMenu,{"left",gc.ranksOnClickMenu,"topleft",1,-26},10,gc.ranksOnClickMenu.width-2,L["clear permissions"],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function() end,nil,nil,'left')
    gc.ranksOnClickMenu.clear:GetFontString():SetTextColor(0.5,0.8,0.9,1)
    gc.ranksOnClickMenu.delete=DA.CreateFFGButton2(nil,gc.ranksOnClickMenu,{"left",gc.ranksOnClickMenu,"topleft",1,-36},10,gc.ranksOnClickMenu.width-2,L["delete rank, shift rest left"],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function() end,nil,nil,'left')
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
                gc['d'..i..'mover']=DA.CreateFFGButton2(nil,gc,{"CENTER",gc,"TOPLEFT",22+46*i,-33},8,13,"<>",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up]],{UIDarkAngelFontConsolas:GetFont(), 9},function(self,mouse)
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

                gc['d'..i..'pos_frm']=DA.FrameCreater(nil,gc['d'..i..'name'],25,18,{"BOTTOMRIGHT",gc['d'..i..'mover'],"BOTTOMLEFT",-2,0},nil,{0.7, 1, 1, 0.6},true,true)
                gc['d'..i..'pos_frm'].t:SetBlendMode('add')
                DA.FontCreater(nil,">>>",{"RIGHT",gc['d'..i..'pos_frm'],"RIGHT",-2,0},gc['d'..i..'pos_frm'],15,50,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"right",{0.75,0.95,0.95,0.75})

                gc['d'..i..'mover'].storedpoint={"center",gc['d'..i..'name'],"center",0,12}
                gc['d'..i..'mover'].storedrank=i
                gc['d'..i..'mover']:EnableMouse(true)
                gc['d'..i..'mover']:EnableMouseWheel(true)
                gc['d'..i..'mover']:SetMovable(true)
                gc['d'..i..'mover']:SetResizable(false)
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

    gc.createnewrank=DA.CreateFFGButton2(nil,gc,{"LEFT",gc['d'..GuildControlGetNumRanks() ..'name'],"RIGHT",2,0},10,12,"+",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 8},function()
        create_new_rank()
    end)


    gc.banktabsfont=DA.FontCreater(nil,L['bank_tabs_notes'],{"LEFT",gc_Scrolled,"TOPLEFT",82,-212},gc_Scrolled,15,250,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},"left",{0.75,0.9,0.9,0.9})

    for b=1,6 do
        gc['db'.. 2 ..'w'..b].adfnt=DA.FontCreater(nil,L['Bank Tab'].." #"..b,{"RIGHT",gc['db'.. 2 ..'w'..b],"LEFT",-3,0},gc['db'.. 2 ..'w'..b],15,150,{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"},"right",{0.75,0.9,0.9,0.9})
    end

    --export
    do
        function gc.finish_import()
            get_players()
            reRender_gc()
        end
        gc.exportBtn=DA.CreateFFGButton2(nil,gc,{"CENTER",gc,"TOPLEFT",17,-46},12,30,'export',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9},function(self)
            if gc.exportFrame:IsShown() then
                gc.exportFrame:Hide()
            else
                gc.exportFrame:Show()
            end
        end)

        gc.exportFrame=DA.FrameCreater(nil,gc,130,38,{"BOTTOMRIGHT", gc, "TOPRIGHT", 0, 2})

        gc.exportFrame.apply=DA.CreateFFGButton2(nil,gc.exportFrame,{"CENTER",gc.exportFrame,"TOPLEFT",30,-26},12,35,L['import'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Red]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
        function(self)
            if gc.exportFrame.EB:GetText() and gc.exportFrame.EB:GetText()~="" then
                gc.ranksroster=nil
                gc.ranksroster=DA.stringToTable(gc.exportFrame.EB:GetText())

                gc.finish_import()
            end
        end)

        gc.exportFrame.exp=DA.CreateFFGButton2(nil,gc.exportFrame,{"CENTER",gc.exportFrame,"TOPLEFT",90,-26},12,45,L['export'],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
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
        gc.helpwindow=DA.FrameCreater(nil,gc,350,150,{"TOPLEFT",gc,"TOPLEFT",30,-40},nil,{0.05, 0.12, 0.18, 0.8},1)
            DA.FontCreater(nil,L['gc_helper'],{"TOPLEFT",gc.helpwindow,"TOPLEFT",5,-12},gc.helpwindow,160,340,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},"left",{0.75,0.9,0.9,0.9}):SetJustifyV("top")

            DA.CreateFFGButton2(nil,gc.helpwindow,{"CENTER",gc.helpwindow,"BOTTOM",0,10},12,80,L["got it, close"],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up]],{UIDarkAngelFontConsolas:GetFont(), 9},function()
                gc.helpwindow:Hide()
            end)

        DA.CreateFFGButton2(nil,gc,{"CENTER",gc,"TOPLEFT",9,-9},12,15,"?",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9},function()
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

        gc.run=DA.FrameCreater(nil,gc,gc.width,gc.height,{"TOPLEFT",gc,"TOPLEFT",0,0},nil,nil,1)
                gc.run:SetPoint("BOTTOMRIGHT",gc,"BOTTOMRIGHT",0,0)
            -- gc.run:SetFrameLevel(23)
            gc.run.t:SetTexture(0.05, 0.08, 0.08, 0.8)
            gc.run.closebtn=DA.CloseButtonCreater(nil,gc.run,{"center", gc.run, "TOPRIGHT", -8.5,-8.5},12,12,'x')



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



        DA.CreateFFGButton2(nil,gc,{"CENTER",gc,"TOPLEFT",17,-22},12,30,"Save",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9},function()
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

                    if bankslots and gc.ranksroster[2].bankpermissions and #gc.ranksroster[2].bankpermissions~=bankslots then
                        DA.Print(L["BankTabCountMismatch"])
                    end
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

        gc.run.run=DA.CreateFFGButton2(nil,gc.run,{"CENTER",gc.run,"TOPLEFT",48,-142},15,34,"Run",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Red]],{UIDarkAngelFontConsolas:GetFont(), 9},function(self)
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

        gc.run.stop=DA.CreateFFGButton2(nil,gc.run,{"CENTER",gc.run,"TOPLEFT",88,-142},15,34,"Stop",[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Red]],{UIDarkAngelFontConsolas:GetFont(), 9},function(self)
            run_stop(nil,1)
        end)
        gc.run.stop:Disable()
    end

end)
