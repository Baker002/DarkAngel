
---@class DarkAngelAddon
local DA = DarkAngel
local L = LibStub("AceLocale-3.0"):GetLocale("DarkAngel")
local Mod = DA:NewModule("Backup")




local function sortByStamp(a, b)
	local dateA, timeA = string.match(a["stamp"], "(%d+/%d+/%d+)%s|cff......([%d:]+)")
	local dateB, timeB = string.match(b["stamp"], "(%d+/%d+/%d+)%s|cff......([%d:]+)")

	local monthA, dayA, yearA = dateA:match("(%d+)/(%d+)/(%d+)")
	local monthB, dayB, yearB = dateB:match("(%d+)/(%d+)/(%d+)")

	if yearA ~= yearB then
		return yearA < yearB
	elseif monthA ~= monthB then
		return monthA < monthB
	elseif dayA ~= dayB then
		return dayA < dayB
	end

	local hourA, minA, secA = timeA:match("(%d+):(%d+):(%d+)")
	local hourB, minB, secB = timeB:match("(%d+):(%d+):(%d+)")

	if hourA ~= hourB then
		return hourA < hourB
	elseif minA ~= minB then
		return minA < minB
	else
		return secA < secB
	end
end
local function SortBCTable(table1)
    local worktable = table1
	
    table.sort(worktable, sortByStamp)

    return worktable
end
local function MergeBCTables(t1, t2)

    local result = {}
    for k, v in pairs(t1) do
        if type(v) == "table" then
            result[k] = {}
            for i = 1, #v do
                result[k][i] = {unpack(v[i])}
            end
        else
            result[k] = v
        end
    end

    for k, v in pairs(t2) do
        if type(v) == "table" then
            if type(result[k]) == "table" then
                for i = 1, #v do
                    result[k][#result[k] + 1] = {unpack(v[i])}
                end
            else
                result[k] = {}
                for i = 1, #v do
                    result[k][i] = {unpack(v[i])}
                end
            end
        else
            result[#result + 1] = v
        end
    end

    return result
end
local function MergeBCTablesWithHints(first, second)
    local merged = {}
    if first and #first>0 then
		for i, v in ipairs(first) do
			local entry = {}
			for key, value in pairs(v) do
				entry[key] = value
			end
			entry["source"] = {"G", i}
			table.insert(merged, entry)
		end
	end
    if second and #second>0 then
		for i, v in ipairs(second) do
			local entry = {}
			for key, value in pairs(v) do
				entry[key] = value
			end
			entry["source"] = {"L", i}
			table.insert(merged, entry)
		end
	end
    
    return merged
end

local function calculateTableSize(tbl)
    local visited = {}
    local function calculateSize(obj)
        local obj_type = type(obj)
        if obj_type == "number" then
            return 8
        elseif obj_type == "string" then
            return #obj * 2
        elseif obj_type == "boolean" then
            return 4
        elseif obj_type == "table" then
            if visited[obj] then return 0 end
            visited[obj] = true
            local size = 16
            for k, v in pairs(obj) do
                size = size + calculateSize(k)
                size = size + calculateSize(v)
            end
            return size
        else
            return 0
        end
    end
    return calculateSize(tbl)
end
local function formatSize(bytes)
    if bytes >= 1024 * 1024 then
        return string.format("%.1fMB", bytes / 1024 / 1024)
    elseif bytes >= 1024 then
        return string.format("%.1fkB", bytes / 1024)
    else
        return string.format("%d B", bytes)
    end
end
local function guildbackupsize(guild)
	local sizeInBytes=0
	if DA_BackupsDB[guild] then
		sizeInBytes = sizeInBytes + calculateTableSize(DA_BackupsDB[guild])
	end
	if DA_Backups_charDB[guild] then
		sizeInBytes = sizeInBytes + calculateTableSize(DA_Backups_charDB[guild])
	end
    return formatSize(sizeInBytes)
end
local function calculateAndFormatTableSize(tbl)
    local sizeInBytes = calculateTableSize(tbl)
    return formatSize(sizeInBytes)
end

local function re_render_on_backupselection()

	for _,i in pairs({"bcnote","bcofnote","bcrank","bclocals","bcgannounce","bcginfo","bcgmrank","showmotd","showGinfo","seedata","seeGMranks"}) do DarkAngelGUI.Backup[i]:Disable();DarkAngelGUI.Backup[i]:SetAlpha(0.6) end

	local anypldata
	local anyother
	if DA_Unpacked.pl_data then
		for _,dat in pairs(DA_Unpacked.pl_data) do
			if dat.note then
				DarkAngelGUI.Backup['bcnote']:Enable();DarkAngelGUI.Backup['bcnote']:SetAlpha(1)
				anypldata=1
			end
			if dat.ofnote then
				DarkAngelGUI.Backup['bcofnote']:Enable();DarkAngelGUI.Backup['bcofnote']:SetAlpha(1)
				anypldata=1
			end
			if dat.rank then
				DarkAngelGUI.Backup['bcrank']:Enable();DarkAngelGUI.Backup['bcrank']:SetAlpha(1)
				anypldata=1
			end
			
			break
		end
	end
	if DA_Unpacked.motd then
		DarkAngelGUI.Backup['bcgannounce']:Enable();DarkAngelGUI.Backup['bcgannounce']:SetAlpha(1)
		DarkAngelGUI.Backup['showmotd']:Enable();DarkAngelGUI.Backup['showmotd']:SetAlpha(1)
		anyother=1
	end
	if DA_Unpacked.ginfo then
		DarkAngelGUI.Backup['bcginfo']:Enable();DarkAngelGUI.Backup['bcginfo']:SetAlpha(1)
		DarkAngelGUI.Backup['showGinfo']:Enable();DarkAngelGUI.Backup['showGinfo']:SetAlpha(1)
		anyother=1
	end
	if DA_Unpacked.localtvins then
		DarkAngelGUI.Backup['bclocals']:Enable();DarkAngelGUI.Backup['bclocals']:SetAlpha(1)
		anyother=1
	end
	if DA_Unpacked.guildranks then
		DarkAngelGUI.Backup['bcgmrank']:Enable();DarkAngelGUI.Backup['bcgmrank']:SetAlpha(1)
		DarkAngelGUI.Backup['seeGMranks']:Enable();DarkAngelGUI.Backup['seeGMranks']:SetAlpha(1)
		anyother=1
	end

	if anypldata then
		for _,i in pairs({"restmain","restmain1","restmain2","resttvin","resttvin1","resttvin2",'passiverest','passiverestnote','passiverestofnote','passiverestrank'}) do
			DarkAngelGUI.Backup[i]:Enable()
			DarkAngelGUI.Backup[i]:SetAlpha(1)
		end
	else
		for _,i in pairs({"restmain","restmain1","restmain2","resttvin","resttvin1","resttvin2",'passiverest','passiverestnote','passiverestofnote','passiverestrank'}) do
			DarkAngelGUI.Backup[i]:Disable()
			DarkAngelGUI.Backup[i]:SetAlpha(0.6)
		end
	end
	
	if anypldata or DA_Unpacked.localtvins then
		DarkAngelGUI.Backup.seedata:Enable()
		DarkAngelGUI.Backup.seedata:SetAlpha(1)
	else
		DarkAngelGUI.Backup.seedata:Disable()
		DarkAngelGUI.Backup.seedata:SetAlpha(0.6)
	end

	if anypldata or anyother then
		DarkAngelGUI.Backup.runbtn:Enable()
		DarkAngelGUI.Backup.runbtn:SetAlpha(1)
	else
		DarkAngelGUI.Backup.runbtn:Disable()
		DarkAngelGUI.Backup.runbtn:SetAlpha(0.6)
	end
	
end
local Backup_ReRender_guild
local function Backup_ReRenderGuilds()
local guilds_Scrolled=DA_Backups_G.scrollchild
local counter=1
	
	local merged=MergeBCTables(DA_BackupsDB,DA_Backups_charDB)
	
	for guild,gdata in pairs(merged) do
		local coloredbk
		if #gdata==0 then
			coloredbk="|cffffaaaa0|r"
		else
			coloredbk="|cff99ffff"..#gdata.."|r"
		end
		DA.CreateFFGButton2("FFGGL"..counter..'but',guilds_Scrolled,{"TOPLEFT",guilds_Scrolled,"TOPLEFT",0,10-(11*counter)},13,155,guild.." "..coloredbk.." |cff3E6868"..guildbackupsize(guild),nil,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},
			function(self)
				Backup_ReRender_guild(self.gname)
			 end,
		nil,nil,'left'):RegisterForClicks("AnyUp","AnyDown")
		_G["FFGGL"..counter..'but'].gname=guild
		counter=counter+1
		
	end
	DA_Backups_G:ClearAllPoints()
	DA_Backups_G:SetPoint("TOPLEFT", DarkAngelGUI.Backup.guilds, "TOPLEFT", 0, -1)
		DA_Backups_G.scrollchild:ClearAllPoints()
		DA_Backups_G.scrollchild:SetPoint("TOPLEFT", DA_Backups_G, "TOPLEFT")
		-- DA_Backups_G.scrollbar:SetSize(160,(20+counter*15)/2)
		DA_Backups_G.scrollchild:SetSize(160,counter*13)
		
		if DA_Backups_G.scrollbar:GetThumbTexture():IsVisible() then
			DA_Backups_G.scrollbar:GetThumbTexture():SetAlpha(0.3)
			
			DA_Backups_G.scrollupbutton:Show()
			DA_Backups_G.scrolldownbutton:Show()
			DA_Backups_G.scrollupbutton:SetAlpha(0.3)
			DA_Backups_G.scrolldownbutton:SetAlpha(0.3)
		else
			DA_Backups_G.scrollbar:GetThumbTexture():SetAlpha(0)
			DA_Backups_G.scrollupbutton:Hide()
			DA_Backups_G.scrolldownbutton:Hide()
			DA_Backups_G.scrollupbutton:SetAlpha(0)
			DA_Backups_G.scrolldownbutton:SetAlpha(0)
		end
end
Backup_ReRender_guild = function(gname)
local db=MergeBCTablesWithHints(DA_BackupsDB[gname],DA_Backups_charDB[gname])
if #db>0 then else return end
DA_Backups_B.scrollbar:SetValue(0)
DarkAngelGUI.Backup.backupo.GFont:SetText(gname)
local DAgdb_sorted=SortBCTable(db)

local backupo_Scrolled=DA_Backups_B.scrollchild
local counter=0
for i=350,1,-1 do
	if DAgdb_sorted[i] then
		counter=counter+1
		local colorsource
		if DAgdb_sorted[i].source[1]=='L' then
			colorsource="|cff0de0cbL"
		elseif DAgdb_sorted[i].source[1]=='G' then
			colorsource="|cffe0e022G"
		else
			colorsource="|cffaa2222ERR"
		end
		
		local f=DA.CreateFFGButton2("FFGBL"..counter..'but',backupo_Scrolled,{"TOPLEFT",backupo_Scrolled,"TOPLEFT",0,10-(11*counter)},13,201.5,DAgdb_sorted[i].stamp..((DAgdb_sorted[i].isauto and "|cffaaffa0 A |r") or "|cffc490fc M |r")..colorsource.."|r  "..DAgdb_sorted[i].members.." |cff99aaaapl. |r".." |cff3E6868"..(
			(
				db[i].source[1]=='G' and calculateAndFormatTableSize(DA_BackupsDB[gname][db[i].source[2]])
			) or 
			(
				db[i].source[1]=='L' and calculateAndFormatTableSize(DA_Backups_charDB[gname][db[i].source[2]])
			) or "" 
		) ,nil,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},
			function(self)
				DA.UnpackBackup(DAgdb_sorted[i])
				re_render_on_backupselection()
				
				
				if DADckp_passive:IsEventRegistered('CHAT_MSG_SYSTEM') then
					DarkAngelGUI.Backup.passiverest:Click()
					DA.Print(L['passiverestdisabl'])
				end
			end,
		nil,nil,'left')
		f.stored=counter
		f:SetScript("OnEnter", function(self) _G["FFGBL"..self.stored..'cls']:Show() end)
		f:SetScript("OnLeave", function(self) if not _G["FFGBL"..self.stored..'cls']:IsMouseOver() then _G["FFGBL"..self.stored..'cls']:Hide() end end)
		
		DA.CreateFFGButton2("FFGBL"..counter..'cls',backupo_Scrolled,{"LEFT",f,"RIGHT",-0.5,0},13,13.5,'x',nil,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},
			function(self)
				self:Hide()
				f:Hide()
				if self.storedDBtype=='G' then
					table.remove(DA_BackupsDB[gname],self.storedId)
				elseif self.storedDBtype=='L' then
					table.remove(DA_Backups_charDB[gname],self.storedId)
				end
				
				Backup_ReRenderGuilds()
				Backup_ReRender_guild(gname)
			end,
		nil,nil,'center')
		_G["FFGBL"..counter..'cls']:SetHighlightTexture("Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red")
		_G["FFGBL"..counter..'cls']:GetFontString():SetTextColor(1,0.65,0.65,0.65,1)
		_G["FFGBL"..counter..'cls'].storedDBtype=db[i].source[1]
		_G["FFGBL"..counter..'cls'].storedId=db[i].source[2]
		_G["FFGBL"..counter..'cls']:Hide()
		_G["FFGBL"..counter..'cls']:SetScript("OnLeave", function(self) self:Hide() end)
		
		
	else
		if _G["FFGBL"..i..'but'] then
			_G["FFGBL"..i..'but']:Hide()
			_G["FFGBL"..i..'cls']:Hide()
		end
	end
end

	DA_Backups_B:ClearAllPoints()
	DA_Backups_B:SetPoint("TOPLEFT", DarkAngelGUI.Backup.backupo, "TOPLEFT", 0, -1)
		DA_Backups_B.scrollchild:ClearAllPoints()
		DA_Backups_B.scrollchild:SetPoint("TOPLEFT", DA_Backups_B, "TOPLEFT")
		-- DA_Backups_B.scrollbar:SetSize(190,(#db*13)/2)
		DA_Backups_B.scrollchild:SetSize(190,#db*13)
		
		DA_Backups_B.scrollbar:Hide()
		DA_Backups_B.scrollbar:GetThumbTexture():Hide()
		DA_Backups_B.scrollupbutton:Hide()
		DA_Backups_B.scrolldownbutton:Hide()

end


local function AutoBackupAlias()
if fucking2Options_char.autobackups and DA_CurrentGuild and DA_CurrentGuild~='n0-guild' then else return end

if fucking2Options_char.autonote or fucking2Options_char.autoofnote or fucking2Options_char.autorank or fucking2Options_char.autolocals or fucking2Options_char.autogannounce or fucking2Options_char.autoginfo or fucking2Options_char.autogmrank then 
else 
	fucking2Options_char.autobackups=false
	DarkAngelGUI.Backup.autobackups:SetChecked(false)
	return 
end

DA.CreateBackup(1,fucking2Options_char.autonote,fucking2Options_char.autoofnote,fucking2Options_char.autorank,fucking2Options_char.autolocals,fucking2Options_char.autogannounce,fucking2Options_char.autoginfo,fucking2Options_char.autogmrank)
end
local function AutoBackupCreate()
if fucking2Options_char.autobackups and DA_CurrentGuild and DA_CurrentGuild~='n0-guild' then else return end


local gname=DA_CurrentGuild

local db_sorted=SortBCTable(MergeBCTablesWithHints(DA_BackupsDB[gname],DA_Backups_charDB[gname]))

	for j=666,1,-1 do
		if db_sorted[j] and db_sorted[j].stamp and db_sorted[j].isauto then
			local dateA, timeA = string.match(db_sorted[j].stamp, "(%d+/%d+/%d+)%s|cff......([%d:]+)")
			local datX,timX=string.match(date(), "(.+)%s(.+)")
			if dateA==datX then
				if fucking2Options_char.doautohours then
					local hourA, _, _ = timeA:match("(%d+):(%d+):(%d+)")
					local hourB, _, _ = timX:match("(%d+):(%d+):(%d+)")
					if tonumber(hourB)-tonumber(hourA)>=fucking2Options_char.autohours then
						AutoBackupAlias()
					end
				end
			else
				AutoBackupAlias()
			end
				if DarkAngelGUI.Backup.backupo:IsVisible() then
					Backup_ReRenderGuilds()
					if DarkAngelGUI.Backup.backupo.GFont:GetText()==gname or DarkAngelGUI.Backup.backupo.GFont:GetText()=="" then
						Backup_ReRender_guild(gname)
					end
				end
		return
		end
	end
	AutoBackupAlias()

	if DarkAngelGUI.Backup.backupo:IsVisible() then
		Backup_ReRenderGuilds()
		if DarkAngelGUI.Backup.backupo.GFont:GetText()==gname or DarkAngelGUI.Backup.backupo.GFont:GetText()=="" then
			Backup_ReRender_guild(gname)
		end
	end
	
end
local function AutoBackupClean()
if fucking2Options_char.autobackups then else return end


local gname=DA_CurrentGuild
local numtostore=fucking2Options_char.storeautoNum

local db_sorted=SortBCTable(MergeBCTablesWithHints(DA_BackupsDB[gname],DA_Backups_charDB[gname]))

local foundautos=0
	for j=666,1,-1 do
		if db_sorted[j] and db_sorted[j].stamp and db_sorted[j].isauto then
				foundautos=foundautos+1
			if foundautos>numtostore then
				
				if db_sorted[j].source[1]=='G' then
					table.remove(DA_BackupsDB[gname],db_sorted[j].source[2])
				elseif db_sorted[j].source[1]=='L' then
					table.remove(DA_Backups_charDB[gname],db_sorted[j].source[2])
				end
			end
			
			
		end
	end
	
	

if DarkAngelGUI.Backup.backupo:IsVisible() then
	Backup_ReRenderGuilds()
	if DarkAngelGUI.Backup.backupo.GFont:GetText()==gname or DarkAngelGUI.Backup.backupo.GFont:GetText()=="" then
		Backup_ReRender_guild(gname)
	end
end

end


local function Backup_notes_ofnotes(donote,doofnote,Mains,MignNOTE,MignOFF,Tvins,TignNOTE,TignOFF)

local db=DA_Unpacked.pl_data

for i=1,DA.GetNumGMembers() do
	local name, _, _, _, _, _, note, officernote=GetGuildRosterInfo(i)

	if name and db[name] and db[name].ofnote then
		local typ=DA.DecodeNote(db[name].ofnote)
		if ((Mains and (typ=='m' or typ=='f') and (not MignNOTE or note=="") and (not MignOFF or officernote=="")) or (Tvins and typ=='t' and (not TignNOTE or note=="") and (not TignOFF or officernote==""))) then
			if donote then
				if db[name].note and db[name].note~="" then
					GuildRosterSetPublicNote(i, DA_Unpacked.pl_data[name].note)
				else
					DA.Print('[note] skipped '..name..' -blank note stored')
				end
			end
			if doofnote then
				if db[name].ofnote and db[name].ofnote~="" then
					GuildRosterSetOfficerNote(i, DA_Unpacked.pl_data[name].ofnote)
				else
					DA.Print('[ofnote] skipped '..name..' -blank ofnote stored')
				end
			end
		end
	end
end



end
local function Backup_ranks(Mains,MignNOTE,MignOFF,Tvins,TignNOTE,TignOFF)

local db=DA_Unpacked.pl_data
local needed = 0
local same = 0
	for i=1,DA.GetNumGMembers() do
		local name, _, rankIndex, _, _, _, note, officernote=GetGuildRosterInfo(i)

		if name and db[name] and db[name].ofnote and rankIndex>0 then
			local typ=DA.DecodeNote(db[name].ofnote)
			if ((Mains and (typ=='m' or typ=='f') and (not MignNOTE or note=="") and (not MignOFF or officernote=="")) or (Tvins and typ=='t' and (not TignNOTE or note=="") and (not TignOFF or officernote==""))) then
				if db[name].rank then
					if tonumber(rankIndex)==tonumber(db[name].rank) then
						same=same+1
					else
						needed=needed+1
						tinsert(DA_Bulk_list,function() DA.DemotePromotePlayer(name,tonumber(rankIndex),tonumber(db[name].rank),1) end)
						tinsert(DA_Bulk_list,function() end)
					end
				end
			end
		end
	end

	if needed==0 then
		DA.Print("|cff00ffffSkipped|r:|cffffaaaa All current guild ranks matches backup")
	else
		DA.Print( (same>0 and ("|cffffaaaaSame ranks: |cff00ffff" .. same .. " ") or "" ) .. "|cffffaaaaChange queued: |cff00ffff" .. needed  )
	end

end

local function UpdateAutoBackupsCHs()
	if fucking2Options_char.autobackups then
		for _,i in pairs({"autonote","autoofnote","autorank","autolocals","autogannounce","autoginfo","autogmrank",'doautohours','storeautoG','storeautoGeb'}) do
			if DarkAngelGUI.Backup[i]:GetObjectType()=='EditBox' then
				DarkAngelGUI.Backup[i]:EnableMouse(true)
				DarkAngelGUI.Backup[i]:SetAlpha(1)
			else
				DarkAngelGUI.Backup[i]:Enable()
				DarkAngelGUI.Backup[i]:SetAlpha(1)
			end
		end
		if fucking2Options_char.doautohours then DarkAngelGUI.Backup.doautohourseb:EnableMouse(true);DarkAngelGUI.Backup.doautohourseb:SetAlpha(1) else DarkAngelGUI.Backup.doautohourseb:EnableMouse(false);DarkAngelGUI.Backup.doautohourseb:SetAlpha(0.6) end
	else
		for _,i in pairs({"autonote","autoofnote","autorank","autolocals","autogannounce","autoginfo","autogmrank",'doautohours','storeautoG','storeautoGeb'}) do
			if DarkAngelGUI.Backup[i]:GetObjectType()=='EditBox' then
				DarkAngelGUI.Backup[i]:EnableMouse(false)
				DarkAngelGUI.Backup[i]:SetAlpha(0.6)
			else
				DarkAngelGUI.Backup[i]:Disable()
				DarkAngelGUI.Backup[i]:SetAlpha(0.6)
			end
		end
		DarkAngelGUI.Backup.doautohourseb:EnableMouse(false);DarkAngelGUI.Backup.doautohourseb:SetAlpha(0.6)
	end
	
end


local function compress_data(...) 
	local a=LibStub:GetLibrary("LibCompress"):CompressLZW(...) 
	a=LibStub:GetLibrary("LibCompress"):CompressHuffman(a) 
	return a
end
function DA.CreateBackup(isauto,donote,doofnote,dorank,dolocals,dogannounce,doginfo,dogmrank)
if DA_CurrentGuild and DA_CurrentGuild~='n0-guild' then else return end

if donote or doofnote or dorank or dolocals or dogannounce or doginfo or dogmrank then 
else 
	DA.Print(L['select at least one criteria'])
	return 0
end

	



	local gmembers=DA.GetNumGMembers()
	local data1=""
	local timest
		local datX,timX=string.match(date(), "(.+)%s(.+)")
		timest=datX..' |cff85aaaa'..timX
	local guildranks
	
	local localtvins
	if dolocals then
		for i,j in pairs(FEP_L_gMain[DA_CurrentGuild]) do
			if i then
				localtvins=DA.DeepCopy(FEP_L_gMain[DA_CurrentGuild])
				break
			end
		end
	end
	
	if dogmrank then
		guildranks=DA.GetGuilGMSettings()
	end
	
	if donote or doofnote or dorank then
		for i=1,gmembers do 
			local player, _, rankIndex, _, _, _, note, officernote,_,_,clas= GetGuildRosterInfo(i);
			if player then
				if clas=="DEATHKNIGHT" then
					clas=0
				elseif clas=="PALADIN" then
					clas=1
				elseif clas=="WARRIOR" then
					clas=2
				elseif clas=="HUNTER" then
					clas=3
				elseif clas=="ROGUE" then
					clas=4
				elseif clas=="MAGE" then
					clas=5
				elseif clas=="WARLOCK" then
					clas=6
				elseif clas=="PRIEST" then
					clas=7
				elseif clas=="DRUID" then
					clas=8
				elseif clas=="SHAMAN" then
					clas=9
				else
					clas=nil
				end
			
				-- if rank then rank="_ra"..rank else rank="" end
				if rankIndex and dorank then rankIndex="_ri"..rankIndex.."_eri" else rankIndex="" end
				if note and donote then note="_no"..note.."_noe" else note="" end
				if officernote and doofnote then officernote="_of"..officernote else officernote="" end
				
				data1=data1.."_st"..("_pl"..player.."_epl"..(clas and "_cl"..clas.."_ecl" or "")..rankIndex..note..officernote).."_en"
			
			
			end
		end
	else
		data1=nil
	end
	
	local motd
	if dogannounce then
		motd=GetGuildRosterMOTD()
	else
		motd=nil
	end
	
	local ginfo
	if doginfo then
		ginfo=GetGuildInfoText()
	else
		ginfo=nil
	end
	
	local writeto
	if (isauto and fucking2Options_char.storeautoG) or (not isauto and fucking2Options_char.storemanG) then
		writeto='DA_BackupsDB'
	else 
		writeto='DA_Backups_charDB'
	end
	
	if not _G[writeto][DA_CurrentGuild] then
		_G[writeto][DA_CurrentGuild]={}
	end
	tinsert(_G[writeto][DA_CurrentGuild],{
			isauto=isauto or false,
			stamp=timest,
			motd=motd or false,
			ginfo=ginfo or false,
			members=gmembers,
			data=data1 and compress_data(data1) or false,
			guildranks=guildranks or false,
			localtvins=localtvins or false,
		}) 
	DA.Garbage_Collect()
end
DA_Unpacked={}
function DA.UnpackBackup(db)

	local c
	if db.data then
		c=LibStub:GetLibrary("LibCompress"):Decompress(db.data) 
		c=LibStub:GetLibrary("LibCompress"):Decompress(c)
	end
	
	table.wipe(DA_Unpacked)
	
	if c then
		local plfound
		DA_Unpacked.pl_data={}
		for a in string.gmatch(c, "_st(.-)_en") do
		local player=string.match(a,   "_pl(.*)_epl")
			if player then
				plfound=true
				DA_Unpacked.pl_data[player]={}
				DA_Unpacked.pl_data[player].rank=string.match(a,   "_ri(.*)_eri") or nil
				DA_Unpacked.pl_data[player].note=string.match(a,   "_no(.*)_noe") or nil
				DA_Unpacked.pl_data[player].class=string.match(a,   "_cl(.*)_ecl") or nil
				DA_Unpacked.pl_data[player].ofnote=string.match(a,   "_of(.*)$") or nil
				
				if DA_Unpacked.pl_data[player].class then
					DA_Unpacked.pl_data[player].class=tonumber(DA_Unpacked.pl_data[player].class)
					if DA_Unpacked.pl_data[player].class==0 then
						DA_Unpacked.pl_data[player].class="DEATHKNIGHT"
					elseif DA_Unpacked.pl_data[player].class==1 then
						DA_Unpacked.pl_data[player].class="PALADIN"
					elseif DA_Unpacked.pl_data[player].class==2 then
						DA_Unpacked.pl_data[player].class="WARRIOR"
					elseif DA_Unpacked.pl_data[player].class==3 then
						DA_Unpacked.pl_data[player].class="HUNTER"
					elseif DA_Unpacked.pl_data[player].class==4 then
						DA_Unpacked.pl_data[player].class="ROGUE"
					elseif DA_Unpacked.pl_data[player].class==5 then
						DA_Unpacked.pl_data[player].class="MAGE"
					elseif DA_Unpacked.pl_data[player].class==6 then
						DA_Unpacked.pl_data[player].class="WARLOCK"
					elseif DA_Unpacked.pl_data[player].class==7 then
						DA_Unpacked.pl_data[player].class="PRIEST"
					elseif DA_Unpacked.pl_data[player].class==8 then
						DA_Unpacked.pl_data[player].class="DRUID"
					elseif DA_Unpacked.pl_data[player].class==9 then
						DA_Unpacked.pl_data[player].class="SHAMAN"
					else
						DA_Unpacked.pl_data[player].class=nil
					end
				end
				
			end
		end
		if not plfound then
			DA_Unpacked.pl_data=nil
		end
	end
	DA_Unpacked.isauto=db.isauto
	DA_Unpacked.stamp=db.stamp
	DA_Unpacked.motd=db.motd
	DA_Unpacked.ginfo=db.ginfo
	DA_Unpacked.members=db.members
	DA_Unpacked.guildranks=db.guildranks
	DA_Unpacked.localtvins=db.localtvins
	
	DA.Garbage_Collect()
end

local StopBackupRestoration
local function StartBackupRestoration()
local restore_GM_system=DarkAngelGUI.Backup.bcgmrank:GetChecked() or nil
local restore_G_info=DarkAngelGUI.Backup.bcginfo:GetChecked() or nil
local restore_G_motd=DarkAngelGUI.Backup.bcgannounce:GetChecked() or nil
local restore_bcnote=DarkAngelGUI.Backup.bcnote:GetChecked() or nil
local restore_bcofnote=DarkAngelGUI.Backup.bcofnote:GetChecked() or nil
local restore_bcrank=DarkAngelGUI.Backup.bcrank:GetChecked() or nil
local restore_bclocals=DarkAngelGUI.Backup.bclocals:GetChecked() or nil

local restoremains=DarkAngelGUI.Backup.restmain:GetChecked() or nil
	local restoremains_ign_Note=DarkAngelGUI.Backup.restmain.ino or nil
	local restoremains_ign_OFNote=DarkAngelGUI.Backup.restmain.inof or nil
	
local restoretvins=DarkAngelGUI.Backup.resttvin:GetChecked() or nil
	local restoretvins_ign_Note=DarkAngelGUI.Backup.resttvin.ino or nil
	local restoretvins_ign_OFNote=DarkAngelGUI.Backup.resttvin.inof or nil
	
	if restore_GM_system and not IsGuildLeader() then
		DA.Print('You need to be Guild Master to restore GM ranking system')
		DarkAngelGUI.Backup.runbtn:Enable();DarkAngelGUI.Backup.stopbtn:Disable()
		return 
	elseif restore_G_info and not CanEditGuildInfo() then
		DA.Print('I am not allowed to edit guild information tab')
		DarkAngelGUI.Backup.runbtn:Enable();DarkAngelGUI.Backup.stopbtn:Disable()
		return 
	elseif restore_G_motd and not CanEditMOTD() then
		DA.Print('I am not allowed to edit guild message of the day')
		DarkAngelGUI.Backup.runbtn:Enable();DarkAngelGUI.Backup.stopbtn:Disable()
		return 
	elseif restore_bcnote and not CanEditPublicNote() then
		DA.Print('I am not allowed to edit public notes')
		DarkAngelGUI.Backup.runbtn:Enable();DarkAngelGUI.Backup.stopbtn:Disable()
		return 
	elseif restore_bcofnote and (not CanViewOfficerNote() or not CanEditOfficerNote()) then
		DA.Print('I am not allowed to edit officer notes')
		DarkAngelGUI.Backup.runbtn:Enable();DarkAngelGUI.Backup.stopbtn:Disable()
		return 
	elseif restore_bcrank and (not CanGuildDemote() or not CanGuildPromote()) then
		DA.Print('I am not allowed to edit public notes')
		DarkAngelGUI.Backup.runbtn:Enable();DarkAngelGUI.Backup.stopbtn:Disable()
		return 
	elseif (restore_bcnote or restore_bcofnote or restore_bcrank) and not restoremains and not restoretvins then
		DA.Print(L['Select at least one option mains/tvins to restore'])
		DarkAngelGUI.Backup.runbtn:Enable();DarkAngelGUI.Backup.stopbtn:Disable()
		return 
	else
		DA.Print('|cffffaaaaStarting in |cff99ffff5|cffffaaaa seconds|r...')
	end
 
local function insertpause()
	for i=1,20 do
		tinsert(DA_Bulk_list,function()  end)
	end
end
	
	if restore_GM_system then
		DA.Print('|cff99ffffNext|r: |cffffaaaaGM rank system')
		if not DA_Unpacked or not DA_Unpacked.guildranks then DA.Print('error 2495; backup incorrectly loaded') StopBackupRestoration() return end 
		if GuildControlGetNumRanks()<5 then DA.Print('error 2497; probably guild GUI not fully loaded yet') StopBackupRestoration() return end
		insertpause()
		local db=DA_Unpacked.guildranks
		tinsert(DA_Bulk_list,function() 
			if #db==0 then 
				DA.Print('error 2500; backup incorrectly loaded') StopBackupRestoration() return
			elseif #db>GuildControlGetNumRanks() then
				for i=1,#db-GuildControlGetNumRanks() do
					GuildControlAddRank('temporary'..i)
				end
			elseif #db<GuildControlGetNumRanks() then
				for i=GuildControlGetNumRanks(),#db+1,-1 do
					GuildControlDelRank(GuildControlGetRankName(i))
				end
			end 
		end)
		local bankslots=GetNumGuildBankTabs()
		if bankslots==0 then bankslots=false end
		
		local bankslots=GetNumGuildBankTabs()
		if bankslots==0 then bankslots=false end
		
		for selectedrank=1,#db do
			tinsert(DA_Bulk_list,function() DA.Process_GMranking(DA_Unpacked.guildranks,selectedrank,bankslots,nil,1) end)
			tinsert(DA_Bulk_list,function()  end)
			tinsert(DA_Bulk_list,function()  end)
			
		end
		
		tinsert(DA_Bulk_list,function()  end)
		tinsert(DA_Bulk_list,function()  end)
	end
	if restore_G_info then
		if restore_GM_system then
			tinsert(DA_Bulk_list,function() DA.Print('|cff99ffffNext|r: |cffffaaaaGuild Info') end)
		else
			DA.Print('|cff99ffffNext|r: |cffffaaaaGuild Info')
		end
		insertpause()
		tinsert(DA_Bulk_list,function() if DA_Unpacked and DA_Unpacked.ginfo then SetGuildInfoText(DA_Unpacked.ginfo) end end)
		tinsert(DA_Bulk_list,function()  end)
	end 
	if restore_G_motd then
		if restore_GM_system or restore_G_info then
			tinsert(DA_Bulk_list,function() DA.Print('|cff99ffffNext|r: |cffffaaaaMessage of the day') end)
		else
			DA.Print('|cff99ffffNext|r: |cffffaaaaMessage of the day')
		end
		insertpause()
		tinsert(DA_Bulk_list,function() if DA_Unpacked and DA_Unpacked.motd then GuildSetMOTD(DA_Unpacked.motd) end end)
		tinsert(DA_Bulk_list,function()  end)
	end 
	
	if restore_bcnote or restore_bcofnote then
		if not DA_Unpacked or not DA_Unpacked.pl_data then DA.Print('error 2617; backup incorrectly loaded') StopBackupRestoration() return end 
		
		if restore_GM_system or restore_G_info or restore_G_motd then
			if restore_bcnote and restore_bcofnote then
				tinsert(DA_Bulk_list,function() DA.Print('|cff99ffffNext|r: |cffffaaaaNotes+Officernotes') end)
			elseif restore_bcnote then
				tinsert(DA_Bulk_list,function() DA.Print('|cff99ffffNext|r: |cffffaaaaNotes') end)
			elseif restore_bcofnote then
				tinsert(DA_Bulk_list,function() DA.Print('|cff99ffffNext|r: |cffffaaaaOfficernotes') end)
			end
		else
			if restore_bcnote and restore_bcofnote then
				DA.Print('|cff99ffffNext|r: |cffffaaaaNotes+Officernotes')
			elseif restore_bcnote then
				DA.Print('|cff99ffffNext|r: |cffffaaaaNotes')
			elseif restore_bcofnote then
				DA.Print('|cff99ffffNext|r: |cffffaaaaOfficernotes')
			end
		end
		insertpause()
		tinsert(DA_Bulk_list,function() Backup_notes_ofnotes(restore_bcnote,restore_bcofnote,restoremains,restoremains_ign_Note,restoremains_ign_OFNote,restoretvins,restoretvins_ign_Note,restoretvins_ign_OFNote) end)
		tinsert(DA_Bulk_list,function()  end)
		tinsert(DA_Bulk_list,function()  end)
		tinsert(DA_Bulk_list,function()  end)
		tinsert(DA_Bulk_list,function()  end)
		
	end 
	if restore_bclocals then
		if restore_GM_system or restore_G_info or restore_G_motd or restore_bcnote or restore_bcofnote then
			tinsert(DA_Bulk_list,function() DA.Print('|cff99ffffNext|r: |cffffaaaaLocal tvins') end)
		else
			DA.Print('|cff99ffffNext|r: |cffffaaaaLocal tvins')
		end
		insertpause()
		tinsert(DA_Bulk_list,function() 
			if DA_Unpacked and DA_Unpacked.localtvins then 
				for pl,mai in pairs(DA_Unpacked.localtvins) do
					FEP_L_gMain[DA_CurrentGuild][pl]=mai
				end
			end
		end)
		tinsert(DA_Bulk_list,function()  end)
	end 
	if restore_bcrank then
		if not DA_Unpacked or not DA_Unpacked.pl_data then DA.Print('error 2661; backup incorrectly loaded') StopBackupRestoration() return end 
		if restore_bclocals or restore_GM_system or restore_G_info or restore_G_motd or restore_bcnote or restore_bcofnote then
			tinsert(DA_Bulk_list,function() DA.Print('|cff99ffffNext|r: |cffffaaaaPlayer ranks') end)
		else
			DA.Print('|cff99ffffNext|r: |cffffaaaaPlayer ranks')
		end
		insertpause()
		tinsert(DA_Bulk_list,function() Backup_ranks(restoremains,restoremains_ign_Note,restoremains_ign_OFNote,restoretvins,restoretvins_ign_Note,restoretvins_ign_OFNote) end)
	end 

tinsert(DA_Bulk_list,function() tinsert(DA_Bulk_list,function()  end) end)
tinsert(DA_Bulk_list,function() tinsert(DA_Bulk_list,function() DA.Print('|cff99ffffBackup restoration finished|r');DarkAngelGUI.Backup.runbtn:Enable();DarkAngelGUI.Backup.stopbtn:Disable() end) end)
	DA.ResumeTimer('bulkprocessor')
		
end
StopBackupRestoration = function ()
	if #DA_Bulk_list==0 then DA.Print('Backup is not running...') else DA.Print('|cffffaaaaBackup aborted') end
	DA.StopTimer('bulkprocessor')
	table.wipe(DA_Bulk_list)
	DarkAngelGUI.Backup.runbtn:Enable();DarkAngelGUI.Backup.stopbtn:Disable()
end


function Mod:OnInitialize()
	
	--auto backup
	DA_autobackup_bulk={}
	DA.CreateTimer(nil,"autobackup",0,0.2,true,function(self)
		if not DA_autobackup_bulk[1] then 
			self:SetScript("OnUpdate",nil)
			return
		end
		DA_autobackup_bulk[1]() 
		table.remove(DA_autobackup_bulk,1)
	end)
	
	--auto backup on hours
	DA.CreateTimer(nil,"autobackup_hours",10,480,true,function(self)
		if not fucking2Options_char.doautohours then
			self:SetScript("OnUpdate",nil)
			return
		end
		
		if not DA_autobackup_bulk[1] then 
			tinsert(DA_autobackup_bulk,function() AutoBackupCreate() end)
			tinsert(DA_autobackup_bulk,function() AutoBackupClean() end)
			DA.ResumeTimer('autobackup')
		end
	end)
	
	
end

function Mod:OnEnable()
	DA:ModuleLoaded("Backup")
end


function Mod.Backup_Load()

	DA.TabCreater({"TOP",_G["DarkAngelGUI"],"BOTTOMLEFT",165,0},15,40,10,50,"Backup",{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},function(self) Backup_ReRenderGuilds() end,function() DA.ResetScrollBoxes() end,[[Interface\AddOns\DarkAngel\template\pict\art_backup]])
		
		do	--auto 
			
			
			DarkAngelGUI.Backup.autobackups=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",50,-20},15,15,L['Automatic_backups'],function(self) fucking2Options_char.autobackups=(self:GetChecked() or false) UpdateAutoBackupsCHs() if self:GetChecked() and fucking2Options_char.doautohours then DA.ResumeTimer('autobackup_hours') else DA.StopTimer('autobackup_hours') end end,{'fucking2Options_char','autobackups'},nil)
		
			DarkAngelGUI.Backup.autonote=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",60,-30},15,15,L['note'],function(self) fucking2Options_char.autonote=(self:GetChecked() or false) end,{'fucking2Options_char','autonote'},nil)
			DarkAngelGUI.Backup.autoofnote=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",60,-40},15,15,L['officer note'],function(self) fucking2Options_char.autoofnote=(self:GetChecked() or false) end,{'fucking2Options_char','autoofnote'},nil)
			DarkAngelGUI.Backup.autorank=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",60,-50},15,15,L['rank'],function(self) fucking2Options_char.autorank=(self:GetChecked() or false) end,{'fucking2Options_char','autorank'},nil)
			DarkAngelGUI.Backup.autolocals=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",60,-60},15,15,L['locals'],function(self) fucking2Options_char.autolocals=(self:GetChecked() or false) end,{'fucking2Options_char','autolocals'},nil)
			DarkAngelGUI.Backup.autogannounce=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",60,-70},15,15,L['guild MOTD'],function(self) fucking2Options_char.autogannounce=(self:GetChecked() or false) end,{'fucking2Options_char','autogannounce'},nil)
			DarkAngelGUI.Backup.autoginfo=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",60,-80},15,15,L['guild info'],function(self) fucking2Options_char.autoginfo=(self:GetChecked() or false) end,{'fucking2Options_char','autoginfo'},nil)
			DarkAngelGUI.Backup.autogmrank=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",60,-90},15,15,L['Guild GM system'],function(self) fucking2Options_char.autogmrank=(self:GetChecked() or false) end,{'fucking2Options_char','autogmrank'},nil)
		
			DarkAngelGUI.Backup.storeautoG=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",50,-105},15,15,'',
			function(self) 
				fucking2Options_char.storeautoG=(self:GetChecked() or false) 
				if fucking2Options_char.storeautoG then
					self.font:SetText(L['Global_storage'])
				else
					self.font:SetText(L['Local_storage'])
				end
			end,{'fucking2Options_char','storeautoG'},'storeautoman');if fucking2Options_char.storeautoG then DarkAngelGUI.Backup.storeautoG.font:SetText(L['Global_storage']) else DarkAngelGUI.Backup.storeautoG.font:SetText(L['Local_storage']) end
			DarkAngelGUI.Backup.storeautoGeb=DA.EditBoxCreater2(nil,DarkAngelGUI.Backup,{"LEFT",DarkAngelGUI.Backup,"TOPLEFT",45,-118},{20,12},fucking2Options_char.storeautoNum,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fucking2Options_char","storeautoNum"},1,10,true,L["number of automatic backups to keep"])
			
			DarkAngelGUI.Backup.doautohours=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",130,-105},15,15,L['each'],function(self) fucking2Options_char.doautohours=(self:GetChecked() or false);if self:GetChecked() then DarkAngelGUI.Backup.doautohourseb:EnableMouse(true);DarkAngelGUI.Backup.doautohourseb:SetAlpha(1);DA.ResumeTimer('autobackup_hours') else DarkAngelGUI.Backup.doautohourseb:EnableMouse(false);DarkAngelGUI.Backup.doautohourseb:SetAlpha(0.6);DA.StopTimer('autobackup_hours') end end,{'fucking2Options_char','doautohours'},'doautohours')
			DarkAngelGUI.Backup.doautohourseb=DA.EditBoxCreater2(nil,DarkAngelGUI.Backup,{"LEFT",DarkAngelGUI.Backup,"TOPLEFT",175,-105},{20,12},fucking2Options_char.autohours,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fucking2Options_char","autohours"},1,10,true,L["hour"])
			if fucking2Options_char.doautohours then DarkAngelGUI.Backup.doautohourseb:EnableMouse(true);DarkAngelGUI.Backup.doautohourseb:SetAlpha(1) else DarkAngelGUI.Backup.doautohourseb:EnableMouse(false);DarkAngelGUI.Backup.doautohourseb:SetAlpha(0.6) end
			
		
		end
		
		
		do --manual 
			
			StaticPopupDialogs["DarkAngel_backup_RELOADUI"] = {
				text = L["backup_reload_ui"],
				button1 = "Yes, reload UI",
				button2 = "No",
				OnAccept = function()
					ReloadUI()
				end,
				OnCancel = function()
					
				end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3, -- Avoid clashing with other popups
			}
			DA.CreateFFGButton2(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",345,-35},12,50,L['players data'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 6, "OUTLINE"},function() 
				for _,i in pairs({"manualnote","manualofnote","manualrank","manuallocals","manualgannounce","manualginfo","manualgmrank"}) do
					if i=="manualnote" or i=="manualofnote" or i=="manualrank" then
						DarkAngelGUI.Backup[i]:SetChecked(1)
					else
						DarkAngelGUI.Backup[i]:SetChecked(false)
					end
				end
			end)
			DA.CreateFFGButton2(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",345,-50},12,50,L['full guild'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"},function() 
				for _,i in pairs({"manualnote","manualofnote","manualrank","manuallocals","manualgannounce","manualginfo","manualgmrank"}) do
					DarkAngelGUI.Backup[i]:SetChecked(1)
				end
			end)
			DA.CreateFFGButton2(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",345,-65},12,50,L['clear'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"},function() 
				for _,i in pairs({"manualnote","manualofnote","manualrank","manuallocals","manualgannounce","manualginfo","manualgmrank"}) do
					DarkAngelGUI.Backup[i]:SetChecked(false)
				end
			end)
			DA.CreateFFGButton2(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",355,-85},12,50,"reloadUI",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"},function() 
				StaticPopup_Show('DarkAngel_backup_RELOADUI')
			end)
		
		
			DarkAngelGUI.Backup.manualnote=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",235,-30},15,15,L['note'])
			DarkAngelGUI.Backup.manualofnote=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",235,-40},15,15,L['officer note'])
			DarkAngelGUI.Backup.manualrank=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",235,-50},15,15,L['rank'])
			DarkAngelGUI.Backup.manuallocals=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",235,-60},15,15,L['locals'])
			DarkAngelGUI.Backup.manualgannounce=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",235,-70},15,15,L['guild MOTD'])
			DarkAngelGUI.Backup.manualginfo=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",235,-80},15,15,L['guild info'])
			DarkAngelGUI.Backup.manualgmrank=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",235,-90},15,15,L['Guild GM system'])
		
			DA.FontCreater(nil,L["Create_Manual_backup"],{"LEFT",DarkAngelGUI.Backup,"TOPLEFT",235,-20},DarkAngelGUI.Backup.manualnote,15,170,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
			
			DA.CreateFFGButton2(nil,DarkAngelGUI.Backup,{"LEFT",DarkAngelGUI.Backup,"TOPLEFT",260,-118},12,60,L['Create Backup'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function() 
				if DA.CreateBackup(
					nil,
					DarkAngelGUI.Backup.manualnote:GetChecked(),
					DarkAngelGUI.Backup.manualofnote:GetChecked(),
					DarkAngelGUI.Backup.manualrank:GetChecked(),
					DarkAngelGUI.Backup.manuallocals:GetChecked(),
					DarkAngelGUI.Backup.manualgannounce:GetChecked(),
					DarkAngelGUI.Backup.manualginfo:GetChecked(),
					DarkAngelGUI.Backup.manualgmrank:GetChecked())~=0 then
				Backup_ReRenderGuilds()
				Backup_ReRender_guild(DA_CurrentGuild) 
				end
			end)

			DarkAngelGUI.Backup.storemanG=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",255,-105},15,15,'',
			function(self) 
				fucking2Options_char.storemanG=(self:GetChecked() or false) 
				if fucking2Options_char.storemanG then
					self.font:SetText(L['Global_storage'])
				else
					self.font:SetText(L['Local_storage'])
				end
			end,{'fucking2Options_char','storemanG'},'storeautoman');if fucking2Options_char.storemanG then DarkAngelGUI.Backup.storemanG.font:SetText(L['Global_storage']) else DarkAngelGUI.Backup.storemanG.font:SetText(L['Local_storage']) end
			
		
		end
		
		
		do --guilds SCROLLBAR
			do --frame
				DarkAngelGUI.Backup.guilds  = CreateFrame("Frame", nil, DarkAngelGUI.Backup)
				DarkAngelGUI.Backup.guilds.width  = 160
				DarkAngelGUI.Backup.guilds.height = 70
				DarkAngelGUI.Backup.guilds:SetFrameStrata("MEDIUM")
				DarkAngelGUI.Backup.guilds:SetSize(DarkAngelGUI.Backup.guilds.width, DarkAngelGUI.Backup.guilds.height)
				DarkAngelGUI.Backup.guilds:SetPoint("TOPLEFT", DarkAngelGUI.Backup, "TOPLEFT", 10, -150)
				DarkAngelGUI.Backup.guilds:SetBackdropColor(1, 1, 1, 1)
					do
						DarkAngelGUI.Backup.guilds.t = DarkAngelGUI.Backup.guilds:CreateTexture(nil, "BACKGROUND")
						DarkAngelGUI.Backup.guilds.t:SetAllPoints()
						DarkAngelGUI.Backup.guilds.t:SetTexture(21/255, 18/255, 22/255, 0.6);
						DarkAngelGUI.Backup.guilds.t:SetBlendMode("blend")
						DarkAngelGUI.Backup.guilds.t:SetAlpha(0.7)

					end

				DarkAngelGUI.Backup.guilds:EnableMouse(true)
				DarkAngelGUI.Backup.guilds:EnableMouseWheel(true)
				DarkAngelGUI.Backup.guilds:SetMovable(true)
				DarkAngelGUI.Backup.guilds:SetMinResize(100, 100)
				
				DarkAngelGUI.Backup.guilds:SetScript("OnDragStart", function(self) DarkAngelGUI:StartMoving() end)
				DarkAngelGUI.Backup.guilds:SetScript("OnDragStop", function(self) DarkAngelGUI:StopMovingOrSizing() end) 
			end
		
		
			DA_Backups_G = DA.ScrollBarCreater("DA_Backups_G",DarkAngelGUI.Backup.guilds,{DarkAngelGUI.Backup.guilds.width+5, DarkAngelGUI.Backup.guilds.height-3},{"TOPLEFT", DarkAngelGUI.Backup.guilds, "TOPLEFT", 0, -1},1)
			
			local guilds=DarkAngelGUI.Backup.guilds
			local guilds_Scrolled=DA_Backups_G.scrollchild
			
			DA.FontCreater(nil,L["Saved guilds"],{"LEFT",guilds,"TOPLEFT",10,5},guilds,15,170,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
			
			DA.CreateFFGButton2(nil,guilds,{"LEFT",guilds,"TOPLEFT",90,5},10,40,L['refresh'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 7, "OUTLINE"},function() 
				Backup_ReRenderGuilds()
				Backup_ReRender_guild(DA_CurrentGuild)
				DA.SetTimerTime('autobackup_hours',1)
			end)


		end
	
		do --backupo SCROLLBAR
			do --frame
				DarkAngelGUI.Backup.backupo  = CreateFrame("Frame", nil, DarkAngelGUI.Backup)
				DarkAngelGUI.Backup.backupo.width  = 226
				DarkAngelGUI.Backup.backupo.height = 70
				DarkAngelGUI.Backup.backupo:SetFrameStrata("MEDIUM")
				DarkAngelGUI.Backup.backupo:SetSize(DarkAngelGUI.Backup.backupo.width, DarkAngelGUI.Backup.backupo.height)
				DarkAngelGUI.Backup.backupo:SetPoint("TOPLEFT", DarkAngelGUI.Backup, "TOPLEFT", 180, -150)
				DarkAngelGUI.Backup.backupo:SetBackdropColor(1, 1, 1, 1)
					do
						DarkAngelGUI.Backup.backupo.t = DarkAngelGUI.Backup.backupo:CreateTexture(nil, "BACKGROUND")
						DarkAngelGUI.Backup.backupo.t:SetAllPoints()
						DarkAngelGUI.Backup.backupo.t:SetTexture(21/255, 18/255, 22/255, 0.6);
						DarkAngelGUI.Backup.backupo.t:SetBlendMode("blend")
						DarkAngelGUI.Backup.backupo.t:SetAlpha(0.7)

					end

				DarkAngelGUI.Backup.backupo:EnableMouse(true)
				DarkAngelGUI.Backup.backupo:EnableMouseWheel(true)
				DarkAngelGUI.Backup.backupo:SetMovable(true)
				DarkAngelGUI.Backup.backupo:SetMinResize(100, 100)
				
				DarkAngelGUI.Backup.backupo:SetScript("OnDragStart", function(self) DarkAngelGUI:StartMoving() end)
				DarkAngelGUI.Backup.backupo:SetScript("OnDragStop", function(self) DarkAngelGUI:StopMovingOrSizing() end) 
			end
			
		
			DA_Backups_B = DA.ScrollBarCreater("DA_Backups_B",DarkAngelGUI.Backup.backupo,{DarkAngelGUI.Backup.backupo.width+5, DarkAngelGUI.Backup.backupo.height-3},{"TOPLEFT", DarkAngelGUI.Backup.backupo, "TOPLEFT", 0, -1},1)
			
			local backupo=DarkAngelGUI.Backup.backupo
			local backupo_Scrolled=DA_Backups_B.scrollchild
			
			DarkAngelGUI.Backup.backupo.GFont=DA.FontCreater(nil,"",{"LEFT",backupo,"TOPLEFT",70,5},backupo,15,170,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'left')
			DA.FontCreater(nil,L["Saves"],{"LEFT",backupo,"TOPLEFT",10,5},backupo,15,170,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')		




		end
	
		do --restoration checkboxes
			DarkAngelGUI.Backup.bcnote=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",20,-235},15,15,"|cff87edd4"..L['note'],function(self) if not CanEditPublicNote() then self:SetChecked(false) DA.Print(L['I am not allowed to edit public notes']) end end)
			DarkAngelGUI.Backup.bcofnote=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",20,-245},15,15,"|cff87edd4"..L['officer note'],function(self) if not(CanViewOfficerNote() and CanEditOfficerNote()) then self:SetChecked(false) DA.Print(L['I am not allowed to edit officer notes']) end end)
			DarkAngelGUI.Backup.bcrank=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",20,-255},15,15,"|cff87edd4"..L['rank'],function(self) if not(CanGuildDemote() and CanGuildPromote()) then self:SetChecked(false) DA.Print(L['I cant demote and/or promote']) end end)
			DarkAngelGUI.Backup.bclocals=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",20,-265},15,15,L['locals'])
			DarkAngelGUI.Backup.bcgannounce=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",20,-275},15,15,L['guild MOTD'],function(self) if not CanEditMOTD() then self:SetChecked(false) DA.Print(L['I am not allowed to edit guild message of the day']) end end)
			DarkAngelGUI.Backup.bcginfo=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",20,-285},15,15,L['guild info'],function(self) if not CanEditGuildInfo() then self:SetChecked(false) DA.Print(L['I am not allowed to edit guild information tab']) end end)
			DarkAngelGUI.Backup.bcgmrank=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",20,-295},15,15,L['Guild GM system'],function(self) if not IsGuildLeader() then self:SetChecked(false) DA.Print(L['only guild master can use it']) end end,nil,'bckgmckb')
			
			
			DA.FontCreater(nil,L["Restore data"],{"LEFT",DarkAngelGUI.Backup.bcnote,"TOPLEFT",7,3},DarkAngelGUI.Backup.storemanG,15,170,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
		
		end
		
		do --mains tvins
		
			DarkAngelGUI.Backup.restmain=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",135,-235},15,15,"|cff87edd4"..L['restore backup mains'],nil,nil,'bckprm')
				DarkAngelGUI.Backup.restmain1=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup.restmain,"CENTER",12,-10},15,15,nil,function(self) DarkAngelGUI.Backup.restmain.ino=self:GetChecked() end,nil,'bckpin')
				DarkAngelGUI.Backup.restmain2=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup.restmain,"CENTER",23,-10},15,15,nil,function(self) DarkAngelGUI.Backup.restmain.inof=self:GetChecked() end,nil,'bckpio')
				
			DarkAngelGUI.Backup.resttvin=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",135,-257},15,15,"|cff87edd4"..L['restore backup tvins'],nil,nil,'bckprt')
				DarkAngelGUI.Backup.resttvin1=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup.resttvin,"CENTER",12,-10},15,15,nil,function(self) DarkAngelGUI.Backup.resttvin.ino=self:GetChecked() end,nil,'bckpin')
				DarkAngelGUI.Backup.resttvin2=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup.resttvin,"CENTER",23,-10},15,15,nil,function(self) DarkAngelGUI.Backup.resttvin.inof=self:GetChecked() end,nil,'bckpio')
		
		end
		
		do --open data btns
		
			DarkAngelGUI.Backup.showmotd=DA.CreateFFGButton2(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",119,-275},8,13,'?','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
				if DA_Unpacked and DA_Unpacked.motd then
					StaticPopup_Show("DA_COPY_TEXT_POPUP", nil, nil, GUILD_MOTD_LABEL .. "\n" .. DA_Unpacked.motd)
				end
			end)
			DarkAngelGUI.Backup.showmotd:SetScript("OnEnter",function(self) 
				if DA_Unpacked and DA_Unpacked.motd then
					DA.myShowTooltip(self,GUILD_MOTD_LABEL .. "\n" .. DA_Unpacked.motd)
				end
			end)
			DarkAngelGUI.Backup.showmotd:SetScript("OnLeave",function(self)
				DA.myHideTooltip()
			end)
			DarkAngelGUI.Backup.showGinfo=DA.CreateFFGButton2(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",119,-285},8,13,'?','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
				if DA_Unpacked and DA_Unpacked.ginfo then
					StaticPopup_Show("DA_COPY_TEXT_POPUP", nil, nil, GUILD_INFORMATION .. "\n" .. DA_Unpacked.ginfo)
				end
			end)
			DarkAngelGUI.Backup.showGinfo:SetScript("OnEnter",function(self) 
				if DA_Unpacked and DA_Unpacked.ginfo then
					DA.myShowTooltip(self,GUILD_INFORMATION .. "\n" .. DA_Unpacked.ginfo)
				end
			end)
			DarkAngelGUI.Backup.showGinfo:SetScript("OnLeave",function(self)
				DA.myHideTooltip()
			end)
		
			DarkAngelGUI.Backup.seedata=DA.CreateFFGButton2(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",119,-250},38,13,'|cff87edd4>>','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
				if DA_Unpacked and (DA_Unpacked.pl_data or DA_Unpacked.localtvins ) then
					DarkAngelGuild.custom_mode=1
					DarkAngelGUI.Guild.micromenu:Hide()
					DA_RightClickMenu.epgpawardFrame:Hide()
					DarkAngelGUI.Guild.bulkmenu:Hide()
					DarkAngelGUI.Guild.bulkBtn:Disable()
					
					DA.GetGuildData(1)
					DarkAngelGUI.Guild.backupClose:Show()
					_G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',true)
					-- _G['DarkAngelGUI']['Guildbtn']:Click('LeftButton',false)
				end
			end,'Backup_seedata')
			
			DarkAngelGUI.Backup.seeGMranks=DA.CreateFFGButton2(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",119,-295},9,13,'>>','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
				if DA_Unpacked and DA_Unpacked.guildranks then
					DarkAngelGUI.Guild.OpenGC_Btn:Click()
					DarkAngelGUI.Guild.GC:Show()
					
					DarkAngelGUI.Guild.GC.ranksroster=DA_Unpacked.guildranks
					DarkAngelGUI.Guild.GC.finish_import()
				end
			end,'Backup_seeGMranks')
		
		end
		
		for _,i in pairs({"bcnote","bcofnote","bcrank","bclocals","bcgannounce","bcginfo","bcgmrank","showmotd","showGinfo","seedata","seeGMranks"}) do
			DarkAngelGUI.Backup[i]:Disable()
			DarkAngelGUI.Backup[i]:SetAlpha(0.6)
		end
	
		do --run and stop
			DarkAngelGUI.Backup.runbtn=DA.CreateFFGButton2(nil,DarkAngelGUI.Backup,{"LEFT",DarkAngelGUI.Backup,"TOPLEFT",250,-232},12,40,'start','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
				self:Disable()
				DarkAngelGUI.Backup.stopbtn:Enable()
				StartBackupRestoration()
			end)
			
			DarkAngelGUI.Backup.stopbtn=DA.CreateFFGButton2(nil,DarkAngelGUI.Backup,{"LEFT",DarkAngelGUI.Backup,"TOPLEFT",250,-247},12,40,L['stop'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self) 
				self:Disable()
				StopBackupRestoration()
			end)
			DarkAngelGUI.Backup.stopbtn:Disable()
			
		end
		
		do --guild inviter
		
			DarkAngelGUI.Backup.doginviter=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",395,-262},15,15,L['Guild inviter'],
			function(self) 
				fuckingOptions_g[DA_CurrentGuild].guildInviterEnabled=(self:GetChecked() or false);
				if self:GetChecked() and CanGuildInvite() then
				elseif self:GetChecked() then
					DA.Print("You are not allowed to invite new members to your guild")
					self:SetChecked(false)
					fuckingOptions_g[DA_CurrentGuild].guildInviterEnabled=false
					DarkAngelGUI.Backup.doginvitereb:EnableMouse(false);DarkAngelGUI.Backup.doginvitereb:SetAlpha(0.6) 
					return
				end
				if self:GetChecked() then 
					DarkAngelGUI.Backup.doginvitereb:EnableMouse(true);DarkAngelGUI.Backup.doginvitereb:SetAlpha(1) 
				else 
					DarkAngelGUI.Backup.doginvitereb:EnableMouse(false);DarkAngelGUI.Backup.doginvitereb:SetAlpha(0.6) 
				end 
			end,{'fuckingOptions_g','guildInviterEnabled',"DA_CurrentGuild"},'doginviter_d')
			DarkAngelGUI.Backup.doginvitereb=DA.EditBoxCreater2(nil,DarkAngelGUI.Backup,{"TOPLEFT",DarkAngelGUI.Backup.doginviter,"TOPLEFT",5,-15},{100,32},fuckingOptions_g[DA_CurrentGuild].guildInviterPhrase,true,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","guildInviterPhrase","DA_CurrentGuild"},4,200,'text')
			-- DA.FontCreater(nil,L["Secret phrase"],{"LEFT",DarkAngelGUI.Backup.doginvitereb,"TOPLEFT",5,5},DarkAngelGUI.Backup.doginvitereb,15,170,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
			
			if fuckingOptions_g[DA_CurrentGuild].guildInviterEnabled then DarkAngelGUI.Backup.doginvitereb:EnableMouse(true);DarkAngelGUI.Backup.doginvitereb:SetAlpha(1) else DarkAngelGUI.Backup.doginvitereb:EnableMouse(false);DarkAngelGUI.Backup.doginvitereb:SetAlpha(0.6) end
			
			
			
			
			local f=CreateFrame('Frame');f:RegisterEvent("CHAT_MSG_CHANNEL");f:SetScript("OnEvent",function(self,_,message,sender,...) if fuckingOptions_g[DA_CurrentGuild].guildInviterEnabled and fuckingOptions_g[DA_CurrentGuild].guildInviterPhrase~="" and message==fuckingOptions_g[DA_CurrentGuild].guildInviterPhrase then GuildInvite(sender) end end)
			
		end
				
		do --passive restoration
			DarkAngelGUI.Backup.passiverest=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",265,-262},15,15,L['passive restoration'],function(self) 
				if self:GetChecked() then
					_G['DADckp_passive']:RegisterEvent("CHAT_MSG_SYSTEM")
				else
					_G['DADckp_passive']:UnregisterEvent("CHAT_MSG_SYSTEM")
				end
			end,nil,'bckpassive')
			DarkAngelGUI.Backup.passiverest.font:SetTextColor(0.8,0.4,0.5,1)
			DarkAngelGUI.Backup.passiverestnote=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",275,-273},15,15,L['note'])
			DarkAngelGUI.Backup.passiverestofnote=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",275,-283},15,15,L['officer note'])
			DarkAngelGUI.Backup.passiverestrank=DA.CheckBtnCreater(nil,DarkAngelGUI.Backup,{"CENTER",DarkAngelGUI.Backup,"TOPLEFT",275,-293},15,15,L['rank'])
			
			DADckp_passive = CreateFrame('Frame','DADckp_passive');_G['DADckp_passive']:SetScript("OnEvent",function(_,_,msg,...)
				local msg=msg
				local player=msg:match("(.+)%s"..L['joins_guild'])
				GuildRoster()
				tinsert(DA_Bulk_list,function() end)
				tinsert(DA_Bulk_list,function() end)
				tinsert(DA_Bulk_list,function() end)
				tinsert(DA_Bulk_list,function() GuildRoster() end)
				
				if player and DA_Unpacked and DA_Unpacked.pl_data and DA_Unpacked.pl_data[player] then
					
					tinsert(DA_Bulk_list,function() 
						if DarkAngelGUI.Backup.passiverestnote:GetChecked() and DA_Unpacked.pl_data[player].note then
							DA.SetPublicnote(player,DA_Unpacked.pl_data[player].note)
						end
						if DarkAngelGUI.Backup.passiverestofnote:GetChecked() and DA_Unpacked.pl_data[player].ofnote then
							DA.SetOfficernote(player,DA_Unpacked.pl_data[player].ofnote)
						end
						if DarkAngelGUI.Backup.passiverestrank:GetChecked() and DA_Unpacked.pl_data[player].rank then
							DA.DemotePromotePlayer(player,tonumber(GuildControlGetNumRanks()-1),tonumber(DA_Unpacked.pl_data[player].rank),1)
						end
					end)
					
					tinsert(DA_Bulk_list,function() DA.Print(L['restored'].." "..player) end)
					DA.ResumeTimer('bulkprocessor')
				end
			end)
		
		end
		
		for _,i in pairs({"restmain","restmain1","restmain2","resttvin","resttvin1","resttvin2","runbtn",'passiverest','passiverestnote','passiverestofnote','passiverestrank'}) do
			DarkAngelGUI.Backup[i]:Disable()
			DarkAngelGUI.Backup[i]:SetAlpha(0.6)
		end




end

function Mod:OnGuildLoad()
	
    self.Backup_Load()
	UpdateAutoBackupsCHs()
	
	if fucking2Options_char.autobackups and fucking2Options_char.doautohours then
		DA.ResumeTimer('autobackup_hours')
	elseif fucking2Options_char.autobackups then
		tinsert(DA_autobackup_bulk,function() AutoBackupCreate() end)
		tinsert(DA_autobackup_bulk,function() AutoBackupClean() end)
		DA.ResumeTimer('autobackup')
	end

end