
--[===[
================================================================================
In the Name of Allah, the Most Merciful, the Most Compassionate.

Ya Allah, please let this code execute as intended.
Let no nil value sneak where a table is expected.
Let no off-by-one error pass unnoticed.
Protect us from the wrath of unexpected nil indexing.

If this function returns correctly:
    Alhamdulillah.

If it throws an error:
    It was a test of patience.

If it works on the first try:
    Truly, miracles still exist.

If it only works after the 17th hotfix:
    You are the Best of Planners, and clearly I am not.

May the stack traces be short,
May the logs be clear,
May the variables be initialized,
And may the production server remain calm.

Should this code fail spectacularly,
I solemnly swear it worked on my machine.

Bismillah — we press Run.
================================================================================
]===]

---@class DarkAngelAddon
local DA = DarkAngel
	DA.L = LibStub("AceLocale-3.0"):GetLocale("DarkAngel")
local L = DA.L



--- Lua helpers
function DA.Safecall(func, ...)
	if type(func) ~= "function" then
		DA.Print("|cffff0000Safecall error:|r invalid function")
		return
	end

	local ok,
		result1, result2, result3,
		result4, result5, result6,
		result7, result8, result9 =
			pcall(func, ...)
			-- xpcall(func, debugstack, ...)

	if not ok then
		DA.Print("|cffff0000Error:|r "..tostring(result1))
		return
	end

	return
		result1, result2, result3,
		result4, result5, result6,
		result7, result8, result9
end
function DA.Print(...)
	print("[|cffed94edDarkAngel|cffffffff]:", ...)
end
function DA.ConcatStr(inputTable,maxl,separator)
	local outputTable = {}
	local currentString = ""

	for _, str in ipairs(inputTable) do
		if #currentString + #str + 1 <= maxl then
			if currentString ~= "" then
				currentString = currentString .. separator
			end
			currentString = currentString .. str
		else
			table.insert(outputTable, currentString)
			currentString = str
		end
	end

	if currentString ~= "" then
		table.insert(outputTable, currentString)
	end

	return outputTable
end
local garbage_collector=CreateFrame("Frame")
function DA.Garbage_Collect()
	--- I DECLARE A WAR :)
	local isGarbageProtectorAddonInstalled = GarbageProtectorDB or false
	local gpNeedsToggle = isGarbageProtectorAddonInstalled and (GarbageProtectorDB.Handlecollectgarbage and GarbageProtectorDB.Enabled)
	
	if not garbage_collector.r then
		garbage_collector.r=true
		if gpNeedsToggle then GarbageProtectorDB.Handlecollectgarbage = false end
		garbage_collector:SetScript("OnUpdate", function(self,_)
			if collectgarbage("step",128) then 
				self:SetScript("OnUpdate", nil)
				self.r=nil
				if gpNeedsToggle then GarbageProtectorDB.Handlecollectgarbage = true end
				return
			end
		end)
	end
end
function DA.DeepCopy(source)
    local copy = {}
    for key, value in pairs(source) do
        if type(value) == "table" then
            copy[key] = DA.DeepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end
function DA.stringToTable(str)
	return loadstring("return " .. str)()
end
function DA.serialize(tbl, indent)
	local str = ""
	local t = type(tbl)
	if t == "table" then
		str = str .. "{\n"
		for k, v in pairs(tbl) do
			str = str .. string.rep(" ", indent + 4) .. "[" .. DA.serialize(k, 0) .. "] = " .. DA.serialize(v, indent + 4) .. ",\n"
		end
		str = str .. string.rep(" ", indent) .. "}"
	elseif t == "number" or t == "boolean" then
		str = str .. tostring(tbl)
	elseif t == "string" then
		-- str = str .. string.format("%q", tbl)
		str = str .. '"' .. tbl .. '"'
	end
	return str
end
function DA.tableToString(tbl)
	return DA.serialize(tbl, 0)
end
function DA.capitalizeFirstCharacter(inputString)
    if inputString and inputString ~= "" then
        local firstChar, restOfString = inputString:match("([%z\1-\127\194-\244][\128-\191]*)(.*)")
        if firstChar then
            if string.byte(firstChar) == 207 or string.byte(firstChar) == 208 then
                -- Cyrillic character range
                firstChar = firstChar:gsub("^%l", string.upper)
            else
                firstChar = firstChar:upper()
            end
            return firstChar .. restOfString
        else
            return ""
        end
    else
        return ""
    end
end
function DA.CheckAndRestoreLocalizedTable(tablename, keepLocal)
	local lang = L.lang
	local default = DarklangelDefaultTables[tablename] and (DarklangelDefaultTables[tablename][lang] or DarklangelDefaultTables[tablename].enUS)
	local localExport
	if default then
		if not keepLocal and not _G[tablename] then
			_G[tablename] = DA.DeepCopy(default)
		elseif keepLocal then
			localExport = DA.DeepCopy(default)
		end
		DarklangelDefaultTables[tablename] = nil
		if not next(DarklangelDefaultTables) then --if there are no unused keys left, emptying the global so it would be eaten by gc
			DarklangelDefaultTables=nil
		end

		if localExport then
			return localExport
		end
	elseif not _G[tablename] then
		DA.Print(tablename, 'not exist, creating new global')
		_G[tablename] = {}
	end
end
function DA.PackTableForEditBox(tabl)
	local str=''
	for i=1,#tabl do
		if str=="" then 
			str=tabl[i]
		else
			str=str..'\n'..tabl[i]
		end
	end
	return str
end
function DA.PackEditBoxTextInTable(text)
	local rows = {}
	for row in text:gmatch("[^\r\n]+") do
		table.insert(rows, row)
	end
	return rows
end



--- Timers
local da_simpleTimer = CreateFrame("Frame")
da_simpleTimer.queue = {}
da_simpleTimer.count = 0
da_simpleTimer.nextTime = nil
local function simpleTimer_Insert(execTime, callback)
    local q = da_simpleTimer.queue
    local n = da_simpleTimer.count + 1
    da_simpleTimer.count = n

    local i = n
    while i > 1 and q[i - 1].time > execTime do
        q[i] = q[i - 1]
        i = i - 1
    end

    q[i] = {
        time = execTime,
        func = callback
    }

    da_simpleTimer.nextTime = q[1].time
    da_simpleTimer:Show()
end
local function simpleTimer_Shift()
    local q = da_simpleTimer.queue
    local n = da_simpleTimer.count

    if n == 1 then
        q[1] = nil
        da_simpleTimer.count = 0
        da_simpleTimer.nextTime = nil
        da_simpleTimer:Hide()
        return
    end

    for i = 1, n - 1 do
        q[i] = q[i + 1]
    end

    q[n] = nil
    da_simpleTimer.count = n - 1
    da_simpleTimer.nextTime = q[1].time
end
da_simpleTimer:Hide()
da_simpleTimer:SetScript("OnUpdate", function(self,_)
    local nextTime = self.nextTime
    if not nextTime then
        self:Hide()
        return
    end

    local now = GetTime()
    if now < nextTime then
        return
    end

    while self.count > 0 and self.queue[1].time <= now do
        local cb = self.queue[1].func
        simpleTimer_Shift()

		DA.Safecall(cb)
        -- local ok, err = pcall(cb)
        -- if not ok then
        --     DA.Print("|cffff0000Timer Error:|r "..tostring(err))
        -- end
    end
end)
DA.TimerAfter = function(duration, callback)
    if type(callback) ~= "function" then return end
    if not duration or duration < 0 then duration = 0 end

    simpleTimer_Insert(GetTime() + duration, callback)
end
DA.TimerAfterShort = function(duration, callback)
    if type(callback) ~= "function" then return end
    if not duration or duration < 0 then duration = 0 end

    -- hard cap to avoid absurd spam
    if duration < 0.01 then duration = 0.01 end

    simpleTimer_Insert(GetTime() + duration, callback)
end
DA.XTimers={}
function DA.CreateTimer(runfromstart,short,startfrom,speed,runwhile,OnRun)
	DA.XTimers[short]=CreateFrame('frame')
	local f=DA.XTimers[short]
	f.speed=speed
	f.time=startfrom

	if type(runwhile)=='boolean' then
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
	if DA.XTimers[short] then
		if DA.XTimers[short]:GetScript("OnUpdate") then
			-- print(short..' already runnin')
		else
			DA.XTimers[short]:SetScript("OnUpdate", DA.XTimers[short].myscript)
		end
	else
		print('no such timer-'..short)
		return
	end
end
function DA.StopTimer(short)
	if DA.XTimers[short] then
		-- print('stopped',short)
		DA.XTimers[short]:SetScript("OnUpdate", nil)
	else
		-- print('no such timer-'..short)
		return
	end
end
function DA.SetTimerTime(short,times)
	if DA.XTimers[short] then
		DA.XTimers[short]['time']=times
	else
		print('no such timer-'..short)
		return
	end
end
function DA.SetTimerSpeed(short,speed)
	if DA.XTimers[short] then
		DA.XTimers[short]['speed']=speed
	else
		print('no such timer-'..short)
		return
	end
end


-- Widget helpers
function DA.AnimateText(obj)
	if not obj then return end

	local fs = obj.fs or obj.font or obj.GetFontString and obj:GetFontString() or obj
	local origcolors = obj.origcolors or (fs.GetTextColor and {fs:GetTextColor()})
	if not origcolors then return end

	if not obj.origcolors then obj.origcolors = origcolors end

	obj:EnableMouse(false)

	for i=1,18 do
		local a = math.random(100)/100
		local b = math.random(100)/100
		local c = math.random(100)/100

		tinsert(DA_Fep_bulk, function()
			fs:SetTextColor(a, b, c, 1)
		end)
	end

	tinsert(DA_Fep_bulk, function() 
		fs:SetTextColor(unpack(origcolors))
		obj:EnableMouse(true)
	end)

	DA.ResumeTimer('fep')
end
function DA.ResetScrollBoxes()
	if true then return end

	for _,j in pairs(DarkAngelGUI.scrollbexes) do
		_G[j]:ClearAllPoints()
		-- _G[j]:SetPoint("TOPLEFT", _G[j]:GetParent(),"TOPLEFT",5, -62)
		-- _G[j]:SetSize(DarkAngelGUI.width-10, DarkAngelGUI.height-70)
		_G[j]:SetPoint(unpack(_G[j].storedpoint))
		_G[j]:SetSize(unpack(_G[j].storedsize))
		_G[j].scrollchild:ClearAllPoints()
		_G[j].scrollchild:SetPoint("TOPLEFT", _G[j..'ScrollFrame'],"TOPLEFT")
		-- _G[j].scrollchild:SetSize(496, (30+((_G[j].getsomething or 10) * 15)) )
		
		_G[j].scrollbar:GetThumbTexture():SetAlpha(0.3)
		_G[j].scrollupbutton:SetAlpha(0.3)
		_G[j].scrolldownbutton:SetAlpha(0.3)
		local a=_G[j].scrollbar.storedval
			_G[j].scrollbar:SetValue(-1)
			_G[j].scrollbar:SetValue(a or 0)
		if _G[j]:IsVisible() then
			if _G[j].scrollbar:GetThumbTexture():IsVisible() then
				
				_G[j].scrollupbutton:Show()
				_G[j].scrolldownbutton:Show()
			else
				_G[j].scrollupbutton:Hide()
				_G[j].scrolldownbutton:Hide()
			end
		end
	end
	-- DarkAngelGUI:GetScript("OnDragStop")(DarkAngelGUI)
	-- DarkAngelGUI:StopMovingOrSizing()
end
local RePaintFrameslocked
function DA.RePaintFrames(onlyTxtPos,lock,unlock)
	if unlock then
		RePaintFrameslocked = nil
	end
	if lock then
		RePaintFrameslocked = true
	end
	if RePaintFrameslocked then return end

	local alpha=fuckingOptions.TXTartOpacity
	local beta=fuckingOptions.TXTBgOpacity;
	local blend1=fuckingOptions.TXTArtTransp; if blend1 then blend1='add' else blend1='blend' end
	local blend2=fuckingOptions.TXTBgTransp; if blend2 then blend2='add' else blend2='blend' end


	for n,_ in pairs(_G["DarkAngelGUI"]['tabsl']) do
		local frame = _G['DarkAngelGUI'][_G["DarkAngelGUI"]['tabsl'][n]]
		if onlyTxtPos then
			if fuckingOptions.TXTArtOnFront then
				frame.art.t:SetDrawLayer('ARTWORK')
				frame.bgtxt.t:SetDrawLayer('BACKGROUND')
			else
				frame.art.t:SetDrawLayer('BACKGROUND')
				frame.bgtxt.t:SetDrawLayer('ARTWORK')
			end
		else
			frame.art.t:SetBlendMode(blend1)
			frame.art.t:SetAlpha(alpha)
			frame.bgtxt.t:SetBlendMode(blend2)
			frame.bgtxt.t:SetTexture(21/255, 18/255, 22/255, beta)
		end

	end

	for _,frame in ipairs(DA.DrawnFrames) do
		if frame.art and onlyTxtPos then
			if fuckingOptions.TXTArtOnFront then
				frame.art.t:SetDrawLayer('ARTWORK')
				frame.t:SetDrawLayer('BACKGROUND')
			else
				frame.art.t:SetDrawLayer('BACKGROUND')
				frame.t:SetDrawLayer('ARTWORK')
			end
		elseif not onlyTxtPos then
			if frame.art then
				frame.art.t:SetBlendMode(blend1)
				frame.art.t:SetAlpha(alpha)
			end
			if frame.tf then
				frame.t:SetBlendMode(blend2)
				if frame.t.myStoredTxt then
					frame.t:SetTexture(frame.t.myStoredTxt[1], frame.t.myStoredTxt[2], frame.t.myStoredTxt[3],  (beta or frame.t.myStoredTxt[4] or 0.5));
				else
					frame.t:SetTexture(21/255, 18/255, 22/255, beta)
				end
				
			end
		end

	end

end



-- Guild API helpers
local guildInfoCache = ""
local guildInfoEmptyHits = 0
local guildMOTDCache = ""
local guildMOTDEmptyHits = 0
function DA.GetGuildInfoTextCached()
	if not IsInGuild() then
		return ""
	end

	local txt = GetGuildInfoText()

	if txt == "" then
		guildInfoEmptyHits = guildInfoEmptyHits + 1

		if guildInfoEmptyHits >= 3 then
			guildInfoCache = ""
		end
	else
		guildInfoCache = txt
		guildInfoEmptyHits = 0
	end

	return guildInfoCache
end
function DA.GetGuildRosterMOTDCached()
	if not IsInGuild() then
		return ""
	end

	local txt = GetGuildRosterMOTD()

	if txt == "" then
		guildMOTDEmptyHits = guildMOTDEmptyHits + 1

		if guildMOTDEmptyHits >= 3 then
			guildMOTDCache = ""
		end
	else
		guildMOTDCache = txt
		guildMOTDEmptyHits = 0
	end

	return guildMOTDCache
end
function DA.CheckEPGPGuildInfo()
	if IsInGuild() and GetGuildInfoText() and #GetGuildInfoText() and #GetGuildInfoText()>0 and GetGuildInfoText()~='' then
		if string.find(GetGuildInfoText(),"@BASE_GP:") and string.match(GetGuildInfoText(),"@BASE_GP:(%d+)") and tonumber(string.match(GetGuildInfoText(),"@BASE_GP:(%d+)")) then
			DA_Guild_Info[DA_CurrentGuild].base1=tonumber(string.match(GetGuildInfoText(),"@BASE_GP:(%d+)"))
		else 
			DA_Guild_Info[DA_CurrentGuild].base1=0
		end
		if string.find(GetGuildInfoText(),"@DECAY_P:") and string.match(GetGuildInfoText(),"@DECAY_P:(%d+)") and tonumber(string.match(GetGuildInfoText(),"@DECAY_P:(%d+)")) then
			DA_Guild_Info[DA_CurrentGuild].decay1=tonumber(string.match(GetGuildInfoText(),"@DECAY_P:(%d+)"))/100
		else 
			DA_Guild_Info[DA_CurrentGuild].decay1=false
		end
		if string.find(GetGuildInfoText(),"@EXTRAS_P:") and string.match(GetGuildInfoText(),"@EXTRAS_P:(%d+)") and tonumber(string.match(GetGuildInfoText(),"@EXTRAS_P:(%d+)")) then 
			DA_Guild_Info[DA_CurrentGuild].extra1=tonumber(string.match(GetGuildInfoText(),"@EXTRAS_P:(%d+)"))/100
		else
			DA_Guild_Info[DA_CurrentGuild].extra1=1
		end
		if string.find(GetGuildInfoText(),"@MIN_EP:") and string.match(GetGuildInfoText(),"@MIN_EP:(%d+)") and tonumber(string.match(GetGuildInfoText(),"@MIN_EP:(%d+)")) then 
			DA_Guild_Info[DA_CurrentGuild].minep1=tonumber(string.match(GetGuildInfoText(),"@MIN_EP:(%d+)"))
		else
			DA_Guild_Info[DA_CurrentGuild].minep1=0
		end
		
		DA.guild_info_found=true
	end
end
function DA.RegatherGuildNotes(scanning)
table.wipe(FEP_gMain)
table.wipe(FFG_gMain)
	if scanning then 
		local rr={}
		for k=1,DA.GetNumGMembers() do
			local name, rankName, rank, _, _, _, note, officernote, _, _, _, _, _, _, _, _ = GetGuildRosterInfo(k);
			if name then
				-- print(name,k)
				rr[name]={}
				if note then
					FFG_gMain[name]=note
					rr[name].n=note
					-- print("N=",note)
				end
				if officernote then
					FEP_gMain[name]=officernote
					rr[name].o=officernote
					-- print("N=",officernote)
				end
				if rank then
					FRG_gMain[name]=rank
					rr[name].r={rank,rankName}
					-- print("R=",rank,rankName)
				end
			end
		end
		return rr
	else
		for k=1,DA.GetNumGMembers() do
			local name, _, _, _, _, _, note, officernote, _, _, _, _, _, _, _, _ = GetGuildRosterInfo(k);
			if name then
				if note then
					FFG_gMain[name]=note
				end
				if officernote then
					FEP_gMain[name]=officernote
				end
			end
		end
	end
end
function DA.IsInSameGuild(character)
	if FEP_gMain[character] then return true else return false end
end
function DA.IsInSameRaid(name) -- not sure if this is useful, but it should include cross-realm players
	if not IsInRaid() then return end
	if GetNumRaidMembers()==0 then return end

	if UnitInRaid(name) then return true end

	for i=1,GetNumRaidMembers() do
		local nam, _, _, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
		if nam==name then return true end

	end
	return
end
function DA.GetPlayerGuildIndex(name)
	for k=1,DA.GetNumGMembers() do
		local m={GetGuildRosterInfo(k)}
		if m[1]==name then return k end
	end
end
local lastGuildUpdate = 0
function DA.GetNumGMembers()
	if not IsInGuild() then
		return 0;
	end
    if (time() - lastGuildUpdate > 10) then
        GuildRoster()
        lastGuildUpdate = time()
    end

	return GetNumGuildMembers(true)
end
local guildControl_PermissionListByID={
	guildchat_listen=1,
	guildchat_speak=2,
	officerchat_listen=3,
	officerchat_speak=4,
	promote=5,
	demote=6,
	invite_member=7,
	remove_member=8,
	set_motd=9,
	edit_public_note=10,
	view_officer_note=11,
	edit_officer_note=12,
	modify_guild_info=13,
	notexists=999,
	withdraw_repair=15,
	withdraw_gold=16,
	create_guild_event=17,
}
local guildControl_BankPermissionIDs={
	canView=1,
	canDeposit=2,
	canEditInfo=3,
}
function DA.Process_GMranking(db,selectedrank,bankslots,lock,anons)


	
	GuildControlSetRank(selectedrank)
	
	if selectedrank>1 then
		for rank,val in pairs(db[selectedrank]) do
			if rank~='name' and rank~='bankpermissions' and rank~='gwithraw' then
				GuildControlSetRankFlag(guildControl_PermissionListByID[tostring(rank)],(not lock and val) or false)
			elseif rank=='gwithraw' then
				SetGuildBankWithdrawLimit((not lock and tonumber(db[selectedrank].gwithraw)) or 0)
			end
		end
		
		if bankslots and db[selectedrank].bankpermissions then
			for banktab=1,bankslots do
				for rank,val in pairs(db[selectedrank].bankpermissions[banktab]) do
					if rank=='stacksPerDay'then
						SetGuildBankTabWithdraw(banktab,((not lock and tonumber(val)) or 0))
					else
						SetGuildBankTabPermissions(banktab,guildControl_BankPermissionIDs[tostring(rank)],(not lock and val) or false)
					end
				end
			end
		end
	end
	
	GuildControlSaveRank(db[selectedrank].name)
	
	if anons then
		DA.Print('processing rank_ID['..selectedrank.."] \""..db[selectedrank].name.."\" guild+guildbank")
	end
	
end
function DA.GetGuilGMSettings()
	local guildranks={}
	for i=1,GuildControlGetNumRanks() do
		GuildControlSetRank(i)
		
		local guildchat_listen, guildchat_speak, officerchat_listen, officerchat_speak, promote, demote, invite_member, remove_member, set_motd, edit_public_note, view_officer_note, edit_officer_note, modify_guild_info, _, withdraw_repair, withdraw_gold, create_guild_event = GuildControlGetRankFlags()
		local bankpermissions={}
		local gwithraw=GetGuildBankWithdrawLimit()
			
		for b=1,GetNumGuildBankTabs() do
			local canViewr, canDepositr, canEditInfor, stacksPerDayr = GetGuildBankTabPermissions(b)
			bankpermissions[b]={
				canView=canViewr or false,
				canDeposit=canDepositr or false,
				canEditInfo=canEditInfor or false,
				stacksPerDay=stacksPerDayr or false
			}
		end	
		
		guildranks[i]={
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
			bankpermissions=bankpermissions or false --table with permissions for this rank for each bank tab
		}
	end
	
	return guildranks
end
local function spacesraidID(name,addonline,iszam)
	if not iszam then
		for i=1,GetNumRaidMembers() do
			local character, _, subgroup, _, _, _, _, online, _, _, _ = GetRaidRosterInfo(i)
			if character and string.lower(string.gsub(character,"\"",""))==string.lower(string.gsub(name,"\"",""))  then
				if online or addonline then
					return "["..subgroup.."]|cff00ffaa+|r"
				else
					return "["..subgroup.."] "
				end
			end
		end
	elseif string.find(DA_Standby[DA_CurrentGuild],name.."\n") then
		if addonline then
			return "[z]|cff00ffaa+|r"
		else
			return "[z] "
		end
	end
	
	if addonline then
		return "   |cff00ffaa+|r"
	else
		return "    "
	end
	
end
function DA.GetTwinsInfo(name,ofnote,iszamena)
	local main

	if DA.DecodeNote(ofnote)=='m' or DA.DecodeNote(ofnote)=='f' then
		main=name

	elseif DA.DecodeNote(ofnote)=='t' then
		main=ofnote

	else
		return
	end
	
	local found={}
	for i=1,DA.GetNumGMembers() do
		local character, rank, rankIndex, level, _, _, note, officernote, online, _, class, _, _, _, _, _ = GetGuildRosterInfo(i)
		
		if character==main or ( DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' and string.lower(main)==main and DA.capitalizeFirstCharacter(main)==character ) then
			if IsControlKeyDown() and not iszamena then
				if online then
					found.main={DA.GetSimpleColorName(character,class),note,online,ofn=officernote,onl='|cff1acc4donline',rank="|r[|cff0df2ff"..rankIndex.."|r]"..rank}
				else
					local y, m, d, h = GetGuildRosterLastOnline(i);
					if y==0 and m==0 and d==0 and h==0 then
						found.main={DA.GetSimpleColorName(character,class),note,online,ofn=officernote,onl='|cffffafaf<h',rank="|r[|cff0df2ff"..rankIndex.."|r]"..rank}
					else
						if y==0 then y=nil else h=nil end
						if m==0 then m=nil else h=nil end
						if d==0 then d=nil end
						if h==0 then h=nil end
						found.main={DA.GetSimpleColorName(character,class),note,online,ofn=officernote,onl=(((y and '|cffff0000'..y..'y') or "")..((m and '|cffff5555'..m..'m') or "")..((d and '|cffff8f8f'..d..'d') or "")..((h and '|cffffafaf'..h..'h') or "")),rank="|r[|cff0df2ff"..rankIndex.."|r]"..rank}
						
					
					end
				end
			else
				found.main={DA.GetSimpleColorName(character,class),note,online,ofn=officernote}
			end
		elseif officernote==main or ( DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' and ((string.lower(main)==main and DA.capitalizeFirstCharacter(main)==officernote ) or (string.lower(officernote)==officernote and DA.capitalizeFirstCharacter(officernote)==main ))) then
			
			if IsControlKeyDown() and not iszamena then
				if online then
					tinsert(found,{DA.GetSimpleColorName(character,class),note,online,onl='|cff1acc4donline',rank="|r[|cff0df2ff"..rankIndex.."|r]"..rank})
				else
					local y, m, d, h = GetGuildRosterLastOnline(i);
					if y==0 and m==0 and d==0 and h==0 then
						tinsert(found,{DA.GetSimpleColorName(character,class),note,online,onl='|cffffafaf<h',rank="|r[|cff0df2ff"..rankIndex.."|r]"..rank})
					else
						if y==0 then y=nil else h=nil end
						if m==0 then m=nil else h=nil end
						if d==0 then d=nil end
						if h==0 then h=nil end
						tinsert(found,{DA.GetSimpleColorName(character,class),note,online,onl=(((y and '|cffff0000'..y..'y') or "")..((m and '|cffff5555'..m..'m') or "")..((d and '|cffff8f8f'..d..'d') or "")..((h and '|cffffafaf'..h..'h') or "")),rank="|r[|cff0df2ff"..rankIndex.."|r]"..rank})
						
					end
				end
			else
				tinsert(found,{DA.GetSimpleColorName(character,class),note,online})
			end
		end
	end
	
	if (iszamena and fuckingOptions.assisterlocals) or not iszamena then
		for chelik,gmain in pairs(FEP_L_gMain[DA_CurrentGuild]) do
			if gmain==main then
				tinsert(found,{"|cff00ffff"..chelik.."|r","|cff00ffff_local|r",islocal=true})
			end
		end
	end
	

	local result=""
	if found.main then 
		local epgpdkpvalues=DA.GetOfficerNotePretty(found.main.ofn)
		
		if IsControlKeyDown() and not iszamena then
			result=(spacesraidID(string.sub(found.main[1],11,-3),found.main[3])..found.main[1].. string.rep(" ",16-#(string.sub(found.main[1],11,-3)):gsub('[\128-\191]', ''))..found.main[2]..
			string.rep(" ",30-#(found.main[2]:gsub('[\128-\191]', ''))).." "..found.main.onl..
			string.rep(" ",8-#(found.main.onl:gsub('|cff%w%w%w%w%w%w','')))..found.main.rank.."\n"..((epgpdkpvalues and ("       "..epgpdkpvalues.."\n") ) or "")) 
			
		else
			result=(spacesraidID(string.sub(found.main[1],11,-3),found.main[3])..found.main[1].. string.rep(" ",16-#(string.sub(found.main[1],11,-3)):gsub('[\128-\191]', ''))..found.main[2].."\n"..((epgpdkpvalues and ("       "..epgpdkpvalues.."\n") ) or "")) 
		end
	end

	if IsControlKeyDown() and not iszamena then
		for i=1,#found do
			if found[i].islocal then
				result=result..(spacesraidID(string.sub(found[i][1],11,-3),found[i][3])..found[i][1]..string.rep(" ",16-#(string.sub(found[i][1],11,-3)):gsub('[\128-\191]', ''))..found[i][2].."\n")
				
			else
				result=result..(spacesraidID(string.sub(found[i][1],11,-3),found[i][3])..found[i][1]..string.rep(" ",16-#(string.sub(found[i][1],11,-3)):gsub('[\128-\191]', ''))..found[i][2]..
				string.rep(" ",30-#(found[i][2]:gsub('[\128-\191]', ''))).." "..found[i].onl..
				string.rep(" ",8-#(found[i].onl:gsub('|cff%w%w%w%w%w%w','')))..found[i].rank.."\n")
			end
		end
	else
		for i=1,#found do
			result=result..(spacesraidID(string.sub(found[i][1],11,-3),found[i][3])..found[i][1].. string.rep(" ",16-#(string.sub(found[i][1],11,-3)):gsub('[\128-\191]', ''))..found[i][2].."\n")
		end
		if not iszamena then
			result=result..L["hold_ctrl_for_more"]
		end
	end
	
	return result
end
function DA.IsFullGuildRaid(fullGuildSetting)
	local members=0
	local non_members=0
	local Guild = FEP_gMain
	local Assigned = FEP_L_gMain[DA_CurrentGuild]
	for i=1,40 do
		local name,_,_= GetRaidRosterInfo(i)
		if name then
			if Guild[name] or (Assigned[name] and Guild[Assigned[name]]) then
				members = members + 1
			elseif fullGuildSetting then
				return false
			else
				non_members = non_members + 1
			end
		end
	end
	local raidMembers = members + non_members
	if members/raidMembers >= 0.7 then
		return true
	end

end
function DA.SetPublicnote(player,note)
	GuildRosterSetPublicNote(DA.GetPlayerGuildIndex(player), tostring(note) )
end
function DA.SetOfficernote(player,note)
	GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(player), tostring(note) )
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


-- EPGP/DKP stuff helpers
function DA.GetEPGPTimestamp()
local timearray = {}
  timearray.month = select(2, CalendarGetDate())
  timearray.day = select(3, CalendarGetDate())
  timearray.year = select(4, CalendarGetDate())
  timearray.hour = select(1, GetGameTime())
  timearray.min = select(2, GetGameTime())
  return time(timearray)
end
local function Guild_determine(frombackup)
	local dkp=0
	local epgp=0
	
	if frombackup then
		table.wipe(UNP_gMain)
		for name,dat in pairs(DA_Unpacked.pl_data) do
			UNP_gMain[name]=dat.ofnote
			
			if string.match(dat.ofnote, "^%.?(%d+),(%d+)$") then
				epgp=epgp+1
			elseif string.match(dat.ofnote, "Ne?t?:(%d+)%sTo?t?:(%d+)") then
				dkp=dkp+1
			end
		end
	
	
	else
		for i=1,DA.GetNumGMembers() do
			local name, _, _, _, _, _, note, officernote, _, _, _ = GetGuildRosterInfo(i);
			if name and officernote then
				if string.match(officernote, "^%.?(%d+),(%d+)$") then
					epgp=epgp+1
				elseif string.match(officernote, "Ne?t?:(%d+)%sTo?t?:(%d+)") then
					dkp=dkp+1
				end
			end
		end
	end

	if (dkp==0 and epgp==0) then
		return 'no-type'
	elseif epgp>dkp then	
		return 'epgp'
	elseif dkp>epgp then
		return 'dkp'
	end
	
	
		
end
function DA.DetermineDKPorEPGPguild(frombackup)

	if DA_CurrentGuild=='n0-guild' and not frombackup then
		return 'epgp'
	end
	
	local gtype=Guild_determine(frombackup)
	if gtype=='no-type' then
		-- if not DA_Guild_Info[DA_CurrentGuild].GuildType then
			if not frombackup then 
				DA.Print(L['addon_failed_recognize_gtype_set'])
				return 'epgp'
			end
		-- end
	elseif gtype=='epgp' then
		if not DA_Guild_Info[DA_CurrentGuild].GuildType then
			if not frombackup then DA.Print("|cff00ffffEPGP|r mode") end
		elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
			if not frombackup then DA.Print(L['addon_registered_gtype_change']) end
			if not frombackup then DA.Print("new: |cff00ffffEPGP|r mode") end
		end
		return 'epgp'
	elseif gtype=='dkp' then
		if not DA_Guild_Info[DA_CurrentGuild].GuildType then
			if not frombackup then DA.Print("|cffeb4bfaDKP|r mode") end
		elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
			if not frombackup then DA.Print(L['addon_registered_gtype_change']) end
			if not frombackup then DA.Print("new: |cffeb4bfaDKP|r mode") end
		end
		return 'dkp'
	end
end
function DA.DecodeNote(note, custom_gtype)
	if not note or note == "" or ({string.gsub(note,"%s","")})[1]=="" or note=="0,0" then
		return "m",0, 0
	else
		if custom_gtype and custom_gtype=='dkp' or DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
			local net, tot, hrs = string.match(note, "Ne?t?:(%-?%d+)%sTo?t?:(%-?%d+)%s?H?r?s?:?(%-?%d*)")
			if tonumber(net) and tonumber(tot) then
				return "m",tonumber(net), tonumber(tot), tonumber(hrs)
			else
				return "t", note
			end
		elseif custom_gtype and custom_gtype=='epgp' or DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
			local ep, gp = string.match(note, "^(%d+),(%d+)$")
			if tonumber(ep) and tonumber(gp) then
				return "m",tonumber(ep), tonumber(gp)
			else
				local ep, gp = string.match(note, "^[.](%d+),(%d+)$")
				if tonumber(ep) and tonumber(gp) then
					return 'f',tonumber(ep), tonumber(gp)
				else
					return "t", note
				end
			end
		end
	end
end
local blizzardPopupAnchors = {}
local function SaveAnchors(t, ...)
  for n=1,select('#', ...) do
    local frame = select(n, ...)
    for i=1,frame:GetNumPoints() do
      local point, relativeTo, relativePoint, x, y = frame:GetPoint(i)
      if point then
        table.insert(t, {frame, point, relativeTo, relativePoint, x, y })
      end
    end
  end
end
local function RestoreAnchors(t)
  for i=1,#t do
    local frame, point, relativeTo, relativePoint, x, y = unpack(t[i])
    frame:SetPoint(point, relativeTo, relativePoint, x, y)
  end
end
StaticPopupDialogs["EPGP_CONFIRM_MINUS_EP_CREDIT"] = {
 text = "Award -EP for player %s",
  button1 = ACCEPT,
  button2 = CANCEL,
  timeout = 0,
  whileDead = 1,
  maxLetters = 16,
  hideOnEscape = 1,
  hasEditBox = 1,
  hasItemFrame = 1,


  OnAccept = function(self)
               local link = self.itemFrame.link
               local ep = tonumber(self.editBox:GetText())
               -- EPGP:IncGPBy(self.name, link, gp)
			   DA_targetep(link,-ep,self.name)
             end,


  OnShow = function(self, data)
             if not blizzardPopupAnchors[self] then
               blizzardPopupAnchors[self] = {}
               SaveAnchors(blizzardPopupAnchors[self],
                           self.itemFrame, self.editBox, self.button1)
             end
				self.itemFrame:ClearAllPoints()
             self.itemFrame:SetPoint("RIGHT", -180, 30)
             self.editBox:SetPoint("RIGHT", -55, 0)

             self.editBox:SetText("")
             self.editBox:HighlightText()
           end,

  OnHide = function(self)
             -- Clear anchor points of frames that we modified, and revert them.
             self.itemFrame:ClearAllPoints()
             self.editBox:ClearAllPoints()
             self.button1:ClearAllPoints()

             RestoreAnchors(blizzardPopupAnchors[self])

             if ChatEdit_GetActiveWindow() then
               ChatEdit_FocusActiveWindow()
             end
             self.editBox:SetText("100")
           end,

  EditBoxOnEnterPressed = function(self)
                            self:GetParent().button1:Click()
                          end,

  EditBoxOnEscapePressed = function(self)
                             self:GetParent():Hide()
                           end
}
function DA.GetOfficerNotePretty(note)
	if not note or note:gsub("%s","")=="" then
		return note
	end

	if fuckingOptions_g[DA_CurrentGuild].evaluateoffnote then
		local tz,net,tot,hrs=DA.DecodeNote(note)

		if (tz=='m' or tz=='f') and (net~=0 or tot~=0 or hrs~=0) then
			if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
				local base = (DA_Guild_Info[DA_CurrentGuild].base1 or 1) or (DA_Guild_Info[DA_CurrentGuild].base1==0 and 1)

				if base==1 and tot==0 then
					return "|cff00ffffPR|r:"..net
				elseif tot==0 then
					return "|cff00ffffPR|r:"..(ceil((net/base)*10) / 10)
				else
					return note.." |cff00ffffPR|r:"..(ceil((net/(tot+(base or 1)))*10) / 10)
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


-- Award functions
function DA.DKPawardfunc(name,value,reason,alt)
	if name and value and reason then else return end
	local IsPercentAward
	if tostring(value):match("^-?[w,W]%d+$") then
		IsPercentAward = true 
		value = tonumber((tostring(value):match("^-") or "") .. tostring(value):match("%d+$"))
		if value==0 or
			(value<-100) or
			(value>500)
		then
			DA.Print("Percentage might not exceed -100 <> 0 <> 500 intervals")
			return
		end
	else
		value = tonumber(value)
	end

	if type(value)=='number' then else print('error 1324') return end
	if FEP_gMain[name] then else DA.Print(DA.GetStoredColorName(name or 'no_name')..' -not found') return end

	local localName = alt and alt[2] and alt[1] or nil
	local altName = alt and not localName and alt[1] or nil
	local anyAltName = localName or altName or nil
	local processedName = anyAltName and anyAltName.." ("..name..")" or name

	local processedReason = IsPercentAward and ("["..value.."%]"..reason) or (reason)

	local typ,ep,gp,hrs=DA.DecodeNote(FEP_gMain[name])

	if typ=='f' then
		DA.Print(processedName.. ' has frozen DKP')
		return
	end
	if IsPercentAward then
		value = math.floor((tonumber(ep)*(value/100))+0.5)
		if value == 0 then
			DA.Print((L["percentageAwardValueIsZero"]:gsub("$1", processedName)))
			return
		end
	end
	if DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
		if tonumber(value)>0 then
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), "Net:"..tostring(tonumber(ep)+tonumber(value)).." Tot:"..tostring(tonumber(gp)+tonumber(value))..((hrs and " Hrs:"..hrs) or "") )
			SendChatMessage("QDKP2> "..processedName.." Gains "..value.." DKP ("..processedReason..")",'guild')
		else
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), "Net:"..tostring(tonumber(ep)+tonumber(value)).." Tot:"..tostring(tonumber(gp))..((hrs and " Hrs:"..hrs) or "") )
			SendChatMessage("QDKP2> "..processedName.." Spends "..math.abs(value).." DKP ("..processedReason..")",'guild')
		end
		SendAddonMessage("DA_log",name.."\031"..value.."\031"..processedReason, "guild")

		if localName and UnitInRaid(localName) then
			if value>0 then
				SendChatMessage("QDKP2> "..processedName.." Gains "..value.." DKP ("..processedReason..")",'raid')
			else
				SendChatMessage("QDKP2> "..processedName.." Spends "..-value.." DKP ("..processedReason..")",'raid')
			end
		end
	end


end
function DA.EPawardfunc(name,value,reason,alt)
	if name and value and reason then else return end
	local IsPercentAward
	if tostring(value):match("^-?[w,W]%d+$") then
		IsPercentAward = true 
		value = tonumber((tostring(value):match("^-") or "") .. tostring(value):match("%d+$"))
		if value==0 or
			(value<-100) or
			(value>500)
		then
			DA.Print("Percentage might not exceed -100 <> 0 <> 500 intervals")
			return
		end
	else
		value = tonumber(value)
	end

	if type(value)=='number' then else print('error 1733') return end
	if FEP_gMain[name] then else DA.Print(DA.GetStoredColorName(name or 'no_name')..' -not found') return end

	local localName = alt and alt[2] and alt[1] or nil
	local altName = alt and not localName and alt[1] or nil
	local anyAltName = localName or altName or nil
	local processedName = anyAltName and anyAltName.." ("..name..")" or name

	local processedReason = IsPercentAward and ("["..value.."%]"..reason) or (reason)

	local typ,ep,gp,_=DA.DecodeNote(FEP_gMain[name])

	if typ=='f' then
		DA.Print(processedName.. ' has frozen EPGP')
		return
	end
	
	if IsPercentAward then
		value = math.floor((tonumber(ep)*(value/100))+0.5)
		if value == 0 then
			DA.Print((L["percentageAwardValueIsZero"]:gsub("$1", processedName)))
			return
		end
	end

	if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
		if EPGP then --insert log in original EPGP addon
			tinsert(EPGP_DB.namespaces.log.profiles[DA_CurrentGuild].log , {DA.GetEPGPTimestamp(),'EP',name,processedReason,tonumber(value)})
		end

		if tonumber(ep)+tonumber(value)>=0 then
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), tostring(tonumber(ep)+tonumber(value))..","..tostring(gp) )
		else
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), "0,"..tostring(gp) )
			DA.Print((L["settingep0"]:gsub("$1",name)):gsub("$2",tonumber(ep).."/"..tonumber(value)))
		end
		
		local valueText = value > 0 and tostring("+" .. value) or tostring(value)
		SendAddonMessage("EPGP","LOG:" .. DA.GetEPGPTimestamp() .. "\031EP\031" .. name .. "\031" .. processedReason .. "\031" .. value,"guild")
		SendChatMessage("EPGP: " .. valueText .. " EP (" .. processedReason .. ") " .. L['fepfor'] .. " " .. processedName, "guild")
		
		if localName and UnitInRaid(localName) then
			SendChatMessage("EPGP: "..valueText.." EP ("..processedReason..") "..processedName,'raid')
		end
	end

end
function DA.GPawardfunc(name,value,reason,alt)
	if name and value and reason then else return end
	local IsPercentAward
	if tostring(value):match("^-?[w,W]%d+$") then
		IsPercentAward = true 
		value = tonumber((tostring(value):match("^-") or "") .. tostring(value):match("%d+$"))
		if value==0 or
			(value<-100) or
			(value>500)
		then
			DA.Print("Percentage might not exceed -100 <> 0 <> 500 intervals")
			return
		end
	else
		value = tonumber(value)
	end

	if type(value)=='number' then else print('error 1733') return end
	if FEP_gMain[name] then else DA.Print(DA.GetStoredColorName(name or 'no_name')..' -not found') return end

	local localName = alt and alt[2] and alt[1] or nil
	local altName = alt and not localName and alt[1] or nil
	local anyAltName = localName or altName or nil
	local processedName = anyAltName and anyAltName.." ("..name..")" or name

	local processedReason = IsPercentAward and ("["..value.."%]"..reason) or (reason)
	
	local typ,ep,gp,_=DA.DecodeNote(FEP_gMain[name])

	if typ=='f' then
		DA.Print(processedName.. ' has frozen EPGP')
		return
	end

	if IsPercentAward then
		value = math.floor((tonumber(gp)*(value/100))+0.5)
		if value == 0 then
			DA.Print((L["percentageAwardValueIsZero"]:gsub("$1", processedName)))
			return
		end
	end

	if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
		if EPGP then --insert log in original EPGP addon
			tinsert(EPGP_DB.namespaces.log.profiles[DA_CurrentGuild].log , {DA.GetEPGPTimestamp(),'GP',name,processedReason,tonumber(value)})
		end

		if tonumber(gp)+tonumber(value)>=0 then
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), (tostring(ep)..","..tostring(tonumber(gp)+tonumber(value))) )
		else
			GuildRosterSetOfficerNote(DA.GetPlayerGuildIndex(name), (tostring(ep)..",0") )
			DA.Print((L["settinggp0"]:gsub("$1",name)):gsub("$2",tonumber(gp).."/"..tonumber(value)))
		end

		local valueText = value > 0 and tostring("+" .. value) or tostring(value)
		SendAddonMessage("EPGP","LOG:" .. DA.GetEPGPTimestamp() .. "\031GP\031" .. name .. "\031" .. processedReason .. "\031" .. value,"guild")
		SendChatMessage("EPGP: " .. valueText .. " GP (" .. processedReason .. ") " .. L['fepfor'] .. " " .. processedName, "guild")

		if localName and UnitInRaid(localName) then
			SendChatMessage("EPGP: "..valueText.." GP ("..processedReason..") "..processedName,'raid')
		end
	end
end
function DA.AddRecentAward(name,epgp,value,reason)
	local t = DA_Guild_Info[DA_CurrentGuild].RecentAwards
	local dat,tim=string.match(date(), "(.+)%s(.+)")
	local p = 1
	local count = #t

	if count==100 then
		table.remove(t,1)
	elseif count~=0 then
		while true do

			local e = t[p]
			if e then
				if e[1]==name and e[2]==epgp and e[3]==value and e[4]==reason then
					table.remove(t,p)
				else
					p = p + 1
				end
			else
				break
			end
		end
	end

	tinsert(DA_Guild_Info[DA_CurrentGuild].RecentAwards, {name,epgp,value,reason,{dat,tim}})

end
function DA.getRecentAwardsFiltered(reason, value)
	local result={}
	local t = DA_Guild_Info[DA_CurrentGuild].RecentAwards
	local count = #t
	if count== 0 then return result end

	if reason=="" or reason:gsub("%s+","")=="" then
		reason=nil
	end

	if value=="0" or value=="" or value:gsub("%s+","")=="" then
		value=nil
	end
	local perfectmatch={}
	local anymatch={}

	for i=count,1,-1 do
		local e = t[i]
		if (not value or e[3] and tostring(e[3]):find(value,nil,true) )
		and (not reason or e[4] and tostring(e[4]):lower():find(reason:lower(),nil,true) )
		then
			tinsert(perfectmatch, e)

		elseif (not value or e[3] and tostring(e[3]):find(value,nil,true) )
		or (not reason or e[4] and tostring(e[4]):lower():find(reason:lower(),nil,true) )
		then
			tinsert(anymatch, e)
		end
	end

	for _,j in ipairs(perfectmatch) do
		tinsert(result,j)
	end

	for _,j in ipairs(anymatch) do
		tinsert(result,j)
	end

	return result
end
function DA.SetRecentAwardBtnTxt(epgp, btn)

	-- handling saves after guild type change
	if DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' and (epgp=='ep' or epgp=='gp') then
		if epgp=='ep' then
			btn:SetText("+DKP")
			btn:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Green.blp')
		elseif epgp=='gp' then
			btn:SetText("-DKP")
			btn:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Yellow.blp')
		end
	elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' and (epgp=='+dkp' or epgp=='-dkp') then
		btn:SetText("EP")
		btn:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Green.blp')


	-- regular cases
	elseif epgp=='ep' then
		btn:SetText("EP")
		btn:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Green.blp')
	elseif epgp=='gp' then
		btn:SetText("GP")
		btn:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Yellow.blp')
	elseif epgp=='+dkp' then
		btn:SetText("+DKP")
		btn:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Green.blp')
	elseif epgp=='-dkp' then
		btn:SetText("-DKP")
		btn:SetNormalTexture('Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Yellow.blp')
	end

end
function DA.getColoredRecentAwardValue(epgp,value)
	local isPositive = not tostring(value):find("-")
	if epgp=='ep' then
		if isPositive then
			return "|cffaaffff+"..value.." EP|r"
		else
			return "|cffff00ff"..value.." EP|r"
		end
	elseif epgp=='gp' then
		if isPositive then
			return "|cffedf500+"..value.." GP|r"
		else
			return "|cffff0000"..value.." GP|r"
		end
	elseif epgp=='+dkp' or epgp=='-dkp' then
		if isPositive then
			return "|cffaaffff+"..value.." DKP|r"
		else
			return "|cffff00ff"..value.." DKP|r"
		end
	end

end



-- Color helpers
local lightNumericClassColors = {
	DEATHKNIGHT	= {0.768, 0.12, 0.228, 1},
	PALADIN 	= {0.96, 0.552, 0.732, 1},
	WARRIOR 	= {	0.828, 0.66, 0.468, 1},
	HUNTER 		= {	0.648, 0.804, 0.444, 1},
	ROGUE 		= {	0.996, 0.96, 0.408, 1},
	MAGE 		= {	0.408, 0.804, 0.948, 1},
	WARLOCK 	= {	0.576, 0.504, 0.768, 1},
	PRIEST 		= {	1, 1, 1, 1},
	DRUID 		= {	0.996, 0.492, 0.036, 1},
	SHAMAN 		= {	0.012, 0.444, 0.9, 1}
}
function DA.GetNumericClassColor(clas)
	return lightNumericClassColors[clas] or { 0.40, 0.40, 0.40, 1 }
end
local lightHEXClassColors = {
	DEATHKNIGHT = "|cffC41F3A",
	PALADIN 	= "|cffF58DBB",
	WARRIOR 	= "|cffD3A877",
	HUNTER 		= "|cffA5CD71",
	ROGUE 		= "|cffFEF568",
	MAGE 		= "|cff68CDF2",
	WARLOCK 	= "|cff9381C4",
	PRIEST 		= "|cffFFFFFF",
	DRUID 		= "|cffFE7D09",
	SHAMAN 		= "|cff0371E5"
}
function DA.GetHexClassColorCode(clas)
	return lightHEXClassColors[clas] or "|cff7A7A7A"
end
function DA.GetSimpleColorName(name,clas)
	return table.concat({
		DA.GetHexClassColorCode(clas),
		name,
		"|r"
	})
end
function DA.GetStoredColorName(name,numeric)
if not name then return 'nil' end
if name=="" or name:gsub("%s","")=="" then return "" end

if select(1,DA.DecodeNote(name))=='t' or numeric then else return name end
	
	local na2me=nil
	if DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' and string.lower(name)==name then
		na2me=DA.capitalizeFirstCharacter(name)
	end
	
	if FEP_gMain[na2me or name] then
		if DA.modules.Logger and DA_Leavers[DA_CurrentGuild][na2me or name] then
			return '|cffb27373'..name..'|r' --assigned to stored leavers
		else
			local typ=select(1,DA.DecodeNote(FEP_gMain[na2me or name]))
			
			if typ=='f' then
				return '|cff8888ff'..name..'|r'
			elseif typ=='t' then	
				return '|cffff88ff'..name..'|r'
			else	
				return '|cffffffff'..name..'|r'
			end
		end
	else
		local typ=select(1,DA.DecodeNote(name))
			
		if typ=='f' then
			return '|cff7366ee'..name..'|r' --frozen
		elseif typ=='m' then	
			return name
		else	
			return '|cff736666'..name..'|r' --not assigned +assigned to old leavers
		end
	end

end
function DA.GetUnpackedColorName(name,numeric, gtype)
if not name then return 'nil' end
if name=="" or name:gsub("%s","")=="" then return "" end

if select(1,DA.DecodeNote(name, gtype))=='t' or numeric then else return name end
	
	local na2me=nil
	if gtype=='dkp' and string.lower(name)==name then
		na2me=DA.capitalizeFirstCharacter(name)
	end
	
	if UNP_gMain[na2me or name] then
		local typ=select(1,DA.DecodeNote(UNP_gMain[na2me or name], gtype))
		
		if typ=='f' then
			return '|cff8888ff'..name..'|r'
		elseif typ=='t' then	
			return '|cffff88ff'..name..'|r'
		else	
			return '|cffffffff'..name..'|r'
		end
	else
		local typ=select(1,DA.DecodeNote(name, gtype))
			
		if typ=='f' then
			return '|cff7366ee'..name..'|r' --frozen
		elseif typ=='m' then	
			return name
		else	
			return '|cff736666'..name..'|r' --not assigned +assigned to old leavers
		end
	end

end

