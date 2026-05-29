
---@class DarkAngelAddon
local DA = DarkAngel
local L = DA.L


local Players_Selected={}
local FFGGuildArray={}

-- helpers
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
						local a_typ,a_ep,a_gp,_=DA.DecodeNote(a[4][1])
						local b_typ,b_ep,b_gp,_=DA.DecodeNote(b[4][1])

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
						local a_typ,a_ep,a_gp,_=DA.DecodeNote(a[4][1])
						local b_typ,b_ep,b_gp,_=DA.DecodeNote(b[4][1])

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
						local a_typ,a_ep,a_gp,_=DA.DecodeNote(a[4][1])
						local b_typ,b_ep,b_gp,_=DA.DecodeNote(b[4][1])

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
						local a_typ,a_ep,a_gp,_=DA.DecodeNote(a[4][1])
						local b_typ,b_ep,b_gp,_=DA.DecodeNote(b[4][1])

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
					local a_typ,a_ep,a_gp,_=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,_=DA.DecodeNote(b[4][1])

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
					local a_typ,a_ep,a_gp,_=DA.DecodeNote(a[4][1])
					local b_typ,b_ep,b_gp,_=DA.DecodeNote(b[4][1])

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
local function get_RankNameFromBackupRankID(id)
	return DA_Unpacked.guildranks[id+1].name
end
local function get_RankStuffFromBackup(rankID,max_rank)
	rankID=tonumber(rankID)
	if max_rank>=rankID+1 then
		return {rankID, get_RankNameFromBackupRankID(rankID)}
	else
		return {rankID, "<N/A rank>", true}
	end
end
local function SelectGuildMember(name,wipe)
	if name then
		if Players_Selected[name] then
			Players_Selected[name]=nil
		else
			Players_Selected[name]=true
		end
		DarkAngelGUI.Guild.lastselected=name

	elseif wipe then
		table.wipe(Players_Selected)
		DarkAngelGUI.Guild.lastselected=nil

	end

end
local function SelectGMembersInRange(Name_1, Name_2)
	local found_1
	local found_2
	local list={}

	local changeprev = Players_Selected[Name_2]

	for _,player in ipairs(DA.DA_GuildRoster) do
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
			SelectGuildMember(name)
		end
	end

end
local function guildData_Checker(s,x)
	local a=string.lower(s)
	if a:find(string.lower(x)) then
		return true
	end

end
local function guildData_mathChecker(s,x)
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
		return guildData_Checker(s,x)
	elseif countera<2 and counterb<2 then
		if countera==1 and counterb==1 and tonumber(s) and tonumber(string.match(x,'%>(%d+)')) and tonumber(s)>=tonumber(string.match(x,'%>(%d+)')) and tonumber(string.match(x,'%<(%d+)')) and tonumber(s)<=tonumber(string.match(x,'%<(%d+)')) then
			return true
		elseif countera==1 and counterb==0 and tonumber(s) and tonumber(string.match(x,'%<(%d+)')) and tonumber(s)<=tonumber(string.match(x,'%<(%d+)')) then
			return true
		elseif countera==0 and counterb==1 and tonumber(s) and tonumber(string.match(x,'%>(%d+)')) and tonumber(s)>=tonumber(string.match(x,'%>(%d+)')) then
			return true
		else
			return guildData_Checker(s,x)
		end
	else
		return guildData_Checker(s,x)
	end

end
local function sanitizeInput(value)
	if value and #value == 1 and (value == "%" or value == "[") then
		return nil
	end
	return value
end
local function GetGuildDataFiltered(eb_name, eb_lvl, eb_note, eb_offnote, eb_rank, eb_online)
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
			(not eb_name or guildData_Checker(entry[1], eb_name)) and
			(not eb_lvl or guildData_mathChecker(entry[2], eb_lvl)) and
			(not eb_note or guildData_mathChecker(entry[3], eb_note)) and
			(not eb_offnote or guildData_mathChecker(entry[4][2], eb_offnote)) and
			(not eb_rank or string.lower(string.gsub(entry[5][1], "\"", "")):find(lower_eb_rank)
				or string.lower(string.gsub(entry[5][2], "\"", "")):find(lower_eb_rank)
				or guildData_mathChecker(entry[5][1], eb_rank)) and
			(not eb_online or
				(entry[5][1] ~= 'local' and
					string.lower(string.gsub(entry[7], "\"", "")):find(lower_eb_online))) and
			(not anyclass
				or classTbl[entry[6]])
			)
		or (not preciseMatch and
		   ((eb_name and guildData_Checker(entry[1], eb_name)) or
			(eb_lvl and guildData_mathChecker(entry[2], eb_lvl)) or
			(eb_note and guildData_mathChecker(entry[3], eb_note)) or
			(eb_offnote and guildData_mathChecker(entry[4][2], eb_offnote)) or
			(eb_rank and (string.lower(string.gsub(entry[5][1], "\"", "")):find(lower_eb_rank) or
						  string.lower(string.gsub(entry[5][2], "\"", "")):find(lower_eb_rank) or
						  guildData_mathChecker(entry[5][1], eb_rank))) or
			(eb_online and
				(entry[5][1] ~= 'local' and
					string.lower(string.gsub(entry[7], "\"", "")):find(lower_eb_online))) or
			(anyclass and
				classTbl[entry[6]])
			))
		then
			result[#result + 1] = entry
		end
	end


    return #result > 0 and result or 0
end
local function GuildSetLine(data1)

   table.wipe(DA.DA_GuildRoster)

    for pos, data in ipairs(data1) do
        local name, level, note, officerNote, rank, class, status = unpack(data)
        local rankID, rankName, rankNA = unpack(rank)
        local officerNoteText, officerNoteTextCol = unpack(officerNote)
        local isLocal = rankID == 'local'
        local color = DA.GetNumericClassColor(class)

		DA.DA_GuildRoster[pos]={}
		local plDat = DA.DA_GuildRoster[pos]


		plDat.plname=name
		plDat.officerNoteText=officerNoteText
		plDat.colorname=isLocal and 'local' or color
		plDat.isLocal=isLocal
		plDat.lvl=level
		plDat.note=note

		plDat.officernote=DA.GetOfficerNotePretty(officerNoteTextCol)

		plDat.rankNA=rankNA
		plDat.rankTxt="[" .. rankID .. "]" .. (rankName or "")
		plDat.rankID=rankID

		plDat.class=class
		plDat.isOnline = (status == "online")
		plDat.onlineColor=plDat.isOnline and {0.1, 0.8, 0.3, 1} or {86/255, 18/255, 35/255, 1}
		plDat.online=status

    end

	DarkAngelGuildCF:SetSize(5, #DA.DA_GuildRoster * 15)

	DarkAngelGUI.Guild.UpdRows(DarkAngelGuild.offset or 1)

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
local function checkIsNotMalformed(pat)
    local i = 1
    local paren = 0   -- ()
    local bracket = 0 -- []

    while i <= #pat do
        local c = pat:sub(i, i)

        if c == "%" then
            if i == #pat then
                return false
            end
            i = i + 2
        else
            if c == "[" then
                bracket = bracket + 1

            elseif c == "]" then
                bracket = bracket - 1
                if bracket < 0 then
                    return false
                end

            elseif c == "(" then
                paren = paren + 1

            elseif c == ")" then
                paren = paren - 1
                if paren < 0 then
                    return false
                end
            end

            i = i + 1
        end
    end

    if bracket ~= 0 then return false end
    if paren ~= 0 then return false end

    return true
end



local function Guild_Create_ScrollBar()
	local NUM_ROWS = 15
	local ROW_HEIGHT = 15

	DarkAngelGuild = CreateFrame("ScrollFrame", "DarkAngelGuild", DarkAngelGUI.Guild, "UIDarkAngelScrollFrame2")
	local ScrollFrame = DarkAngelGuild
		DarkAngelGuild:Hide()
	ScrollFrame:SetPoint("TOPLEFT",DarkAngelGUI.Guild,"TOPLEFT",6,-60)
	ScrollFrame:SetPoint("BOTTOMRIGHT",DarkAngelGUI.Guild,"BOTTOMRIGHT",-25,10)
-- local tf = ScrollFrame:CreateTexture(nil, "BACKGROUND"); tf:SetAllPoints(); tf:SetTexture(21/255, 18/255, 22/255, 0.5); tf:SetBlendMode("blend")


	DarkAngelGuildCF = CreateFrame("Frame", "DarkAngelGuildCF", ScrollFrame)
	local ContentFrame = DarkAngelGuildCF

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
							menu.ranksmenuFrame.storedvalue = nil
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
							menu.ofnotefreeze:Hide()
						else
							menu.ranksmenubtn:Enable()
							-- menu.ranksmenubtn.fs:SetText(data.rankTxt)
							menu.deletelocal:Hide()
							menu.ranksmenuFrame.storedvalue = data.rankID
							menu.ranksmenuFrame:reRender()
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
							if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
								menu.ofnotefreeze:Show()
							else
								menu.ofnotefreeze:Hide()
							end


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

						SelectGuildMember(data.plname)
					else
						SelectGMembersInRange(DarkAngelGUI.Guild.lastselected, data.plname)
					end

					DarkAngelGUI.Guild.bulkmenu:Show()
					DarkAngelGUI.Guild.UpdRows(DarkAngelGuild.offset or 1)
				elseif (not shiftdown) and (ctrldown)  then
					SelectGuildMember(data.plname)

					DarkAngelGUI.Guild.bulkmenu:Show()
					DarkAngelGUI.Guild.UpdRows(DarkAngelGuild.offset or 1)
				end



            elseif clickType == 'RightButton' then
                if data.plname and data.officerNoteText then
                    DA_RightClickMenu.calledfrom = "DarkAngelGUI"
                    DA.OpenOptMenu(self, data.plname, DarkAngelGuild.custom_mode)
                else
                    DA_RightClickMenu:Hide()
                end
            end
        end)
			row.selfID=i
		row:RegisterForClicks("AnyUp")
        row:SetNormalTexture('')

		row:SetScript("OnEnter", function(self)
			self:RegisterEvent('MODIFIER_STATE_CHANGED')
			local shiftdown=IsShiftKeyDown()
			---@diagnostic disable-next-line: undefined-field
			if shiftdown and GetMouseFocus() and GetMouseFocus().selfID == self.selfID and self.mydata.plname and self.mydata.officerNoteText then
				DA.myShowTooltip(self, DA.GetTwinsInfo(self.mydata.plname, self.mydata.officerNoteText) or "", {font, 10})
			elseif not shiftdown and DA_Tooltip:IsShown() then
				DA.myHideTooltip()
			end
		end)
		row:SetScript("OnEvent", function(self)
			---@diagnostic disable-next-line: undefined-field
			if self:IsVisible() and self:IsMouseOver() and GetMouseFocus() and GetMouseFocus().selfID and GetMouseFocus().selfID==self.selfID then
				self:GetScript('OnEnter')(GetMouseFocus())
			end
		end)
		row:SetScript("OnLeave", function(self)
			self:UnregisterEvent('MODIFIER_STATE_CHANGED')
			if DA_Tooltip:IsShown() then
				DA.myHideTooltip()
			end
		end)



		row.buttons = {}
		row.buttons[1]=DA.FontCreater(nil,"",{"LEFT", row, "LEFT", 1, 0},row,20, 110,{font, 10, "OUTLINE"},"LEFT")
		row.buttons[2]=DA.FontCreater(nil,"",{"LEFT", row, "LEFT", 75, 0},row,20, 30,{font, 9, "OUTLINE"},"LEFT",{0.6, 0.6, 0.6, 1})
		row.buttons[3]=DA.FontCreater(nil,"",{"LEFT", row, "LEFT", 95, 0},row,20, 130,{font, 9, "OUTLINE"},"LEFT", {0.7, 0.8, 0.8, 1})
		row.buttons[4]=DA.FontCreater(nil,"",{"LEFT", row, "LEFT", 233, 0},row,20, 115,{font, 9, "OUTLINE"},"LEFT", {0.7, 0.8, 0.8, 1})
		row.buttons[5]=DA.FontCreater(nil,"",{"LEFT", row, "LEFT", 348, 0},row,20, 100,{font, 7.5, "OUTLINE"},"LEFT")
		row.buttons[6]=DA.FontCreater(nil,"",{"LEFT", row, "LEFT", 428, 0},row,20, 100,{font, 9, "OUTLINE"},"LEFT")

		RowButtons[i] = row
	end

	local function UpdateRows(offset)

		DarkAngelGuild.offset=offset

		local rowIndex = math.floor(offset / ROW_HEIGHT + 0.5) + 1
		for i = 1, NUM_ROWS do
			local data = DA.DA_GuildRoster[rowIndex + i - 1]
			if data then
				local row = RowButtons[i]
					if Players_Selected[data.plname] then row:SetButtonState('PUSHED',true) else row:SetButtonState('NORMAL',false) end
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
		local scrollBarname = self:GetName()
		local _, max= self:GetMinMaxValues();

		if DA_Tooltip:IsShown() then
			DA_Tooltip:Hide()
		end
		if ( value == 0 ) then
			_G[scrollBarname.."ScrollUpButton"]:Disable();
		else
			_G[scrollBarname.."ScrollUpButton"]:Enable();
		end
		if ((value - max) == 0) then
			_G[scrollBarname.."ScrollDownButton"]:Disable();
		else
			_G[scrollBarname.."ScrollDownButton"]:Enable();
		end
		UpdateRows(value)
	end)

end
local function Run_ProcessBulk()

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
	elseif DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText()==L['award'] then
		mode='award'
		if not CanEditOfficerNote() then
			DA.Print(L['I am not allowed to edit officer notes'])
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
		if not CanGuildDemote() and not CanGuildPromote() then
			DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
			return
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
	elseif mode=='award' then
		DarkAngelGUI.Guild.bulkmenu.award123Frame.value.focusgained=nil
		DarkAngelGUI.Guild.bulkmenu.award123Frame.value:ClearFocus()
		DarkAngelGUI.Guild.bulkmenu.award123Frame.reason.focusgained=nil
		DarkAngelGUI.Guild.bulkmenu.award123Frame.reason:ClearFocus()


		local reason=DarkAngelGUI.Guild.bulkmenu.award123Frame.reason:GetText()
		if reason=="" or reason:gsub("%s+","")=="" then reason='test' end

		local value=DarkAngelGUI.Guild.bulkmenu.award123Frame.value:GetText()
		if not value or value=="" or value:gsub("%s+","")=="" or (not value:match("^-?[w,W]%d+$") and not tonumber(value)) then
			DarkAngelGUI.Guild.bulkmenu.startbulk:Enable()
			DarkAngelGUI.Guild.bulkmenu.stoper:Disable()
			return	
		end

		local dkpinverted
		local function awardfunc(name,epgp,value,reason,altTable)
			if epgp=='ep' then
				DA.EPawardfunc(name,value,reason,altTable)
			elseif epgp=='gp' then
				DA.GPawardfunc(name,value,reason,altTable)

			elseif epgp=='+dkp' or epgp=='-dkp' then
				if (epgp=='-dkp' and not tostring(value):find("-") ) then
					DA.DKPawardfunc(name,"-"..value,reason,altTable)
					dkpinverted = true
				else
					DA.DKPawardfunc(name,value,reason,altTable)
				end
			end
		end
		
		local altTableByName={}
			
		DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown:Hide()
		local award_roster={}
		local is_alrdy_in_roster={}
		for _,pltbl in pairs(playersarray) do
			local pl_type = pltbl[1]
			local name = pltbl[2]
			if pl_type=='local' then
				local main = FEP_L_gMain[DA_CurrentGuild][name]
				local v_main = main and FEP_gMain[main] and (DA.DecodeNote(FEP_gMain[main])=='m' or DA.DecodeNote(FEP_gMain[main])=='f') and main
				if v_main then
					if not is_alrdy_in_roster[v_main] then
						is_alrdy_in_roster[v_main]=true
						altTableByName[v_main] = {name, true}
						tinsert(award_roster,v_main)
					else
						DA.Print('skipped [duplicate]: '..name..' ('..v_main..')')
					end
				else
					DA.Print('skipped [bad local]: '..name..' ('..main..')')
				end
			elseif pl_type=='normal' then
				if FEP_gMain[name] then
					local typ = DA.DecodeNote(FEP_gMain[name])
					local main = ((typ=='m' or typ=='f') and name)
						or (typ=='t' and FEP_gMain[FEP_gMain[name]] and (DA.DecodeNote(FEP_gMain[FEP_gMain[name]])=='m' or DA.DecodeNote(FEP_gMain[FEP_gMain[name]])=='f') and FEP_gMain[name])
					if main then
						if not is_alrdy_in_roster[main] then
							if main~=name then
								altTableByName[main] = {name, false}
							end
							is_alrdy_in_roster[main]=true
							tinsert(award_roster,main)
						else
							if name==main then
								DA.Print('skipped [duplicate]: '..name)
							else
								DA.Print('skipped [duplicate]: '..name..' ('..main..')')
							end
						end
					else
						DA.Print('skipped [bad note]: '..name..' ('..FEP_gMain[name]..')')
					end
				end
			end
		end

		if next(award_roster) then
			local epgp = string.lower(DarkAngelGUI.Guild.bulkmenu.award123Frame.epgp:GetText())
			
			for _,name in ipairs(award_roster) do
				tinsert(DA_Bulk_list,function() awardfunc(name,epgp,value,reason, altTableByName[name]) end)
			end
			tinsert(DA_Bulk_list,function()
				if DA.loaded_Modules['Awarder'] then
					FEP_GatherRaid()
					tinsert(DA_Fep_bulk,function() FEP_GatherRaid() end)
				end
				DA.AddRecentAward('|cffce95fc/bulk/|r',epgp,dkpinverted and "-"..value or value,reason)
			end)

			tinsert(DA_Fep_bulk,function() if DarkAngelGuild:IsShown() then DA.GetGuildData();DA.GuildSetAllLines() end end)
			DA.ResumeTimer('fep')

		end
	elseif mode=='rank' then
		local new=DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.rankid
		for _,pltbl in pairs(playersarray) do
			if pltbl[1]=='local' then
				DA.Print('skipped [not a guild member]: '..pltbl[2])
			elseif pltbl[1]=='normal' then
				if pltbl[3]=="0" then
					DA.Print('skipped [Guild Leader]: '..pltbl[2])
				elseif pltbl[2]==GetUnitName('player') then
					DA.Print('skipped [self]: '.. pltbl[2])
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
					DA.Print('skipped [Guild Leader]: '..pltbl[2])
				elseif pltbl[2]==GetUnitName('player') then
					DA.Print('skipped [self]: '.. pltbl[2])
				else
					GuildUninvite(pltbl[2])
				end
			end
		end
	end

	tinsert(DA_Bulk_list,function()  end)
	tinsert(DA_Bulk_list,function()  DA.GetGuildData(); end)
	tinsert(DA_Bulk_list,function()  DA.GuildSetAllLines();if DarkAngelGUI.Guild.bulkmenu.autodeselect:GetChecked() then SelectGuildMember(nil,true) end end)
	tinsert(DA_Bulk_list,function()  DA.UpdateMicroMenu() end)
	tinsert(DA_Bulk_list,function()  DA.UpdateMicroMenu();DarkAngelGUI.Guild.bulkmenu.startbulk:Enable();DarkAngelGUI.Guild.bulkmenu.stoper:Disable() end)
			DA.ResumeTimer('bulkprocessor')


end
local function Run_ReTwink()



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


--Shared usage
function DA.GetGfoundList(mod)

	local result={}

	if mod=='sel' then
		for _,player in ipairs(DA.DA_GuildRoster) do
			local name = player.plname

			if Players_Selected[name] then
				if player.isLocal then
					tinsert(result,{'local',name})
				else
					tinsert(result,{'normal',name,player.rankID,player.isOnline})
				end
			end
		end

	elseif mod=='all' then
		for _,player in ipairs(DA.DA_GuildRoster) do
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
function DA.GetGuildData(initiate)
	if DA_CurrentGuild=="n0-guild" and not DarkAngelGuild.custom_mode then return end

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
				tinsert(FFGGuildArray,{name,"",dat.note,{dat.ofnote,DA.GetUnpackedColorName(dat.ofnote,1,gtype)},get_RankStuffFromBackup(dat.rank,max_rank),dat.class,""  , offlinecounter="00000000"})
			end
		else
			for name,dat in pairs(DA_Unpacked.pl_data) do
				tinsert(FFGGuildArray,{name,"",dat.note,{dat.ofnote,DA.GetUnpackedColorName(dat.ofnote,1,gtype)},{dat.rank,""},dat.class,""  , offlinecounter="00000000"})
			end
		end

	else
		local max_rank=GuildControlGetNumRanks()-1
		for i=1,DA.GetNumGMembers() do
			local name, rank, rankIndex, level, _, _, note, officernote, online, _, class = GetGuildRosterInfo(i);

			if not rank or rank=="" then rank="<N/A rank>" end

			if name and ((fuckingOptions.showonl and online) or (fuckingOptions.showoffl and not online)) then
				if online then
					tinsert(FFGGuildArray,{name,level,note,{officernote,DA.GetStoredColorName(officernote,1)},{rankIndex,rank,rankIndex>max_rank},class,'online'})
				else
					local y, m, d, h = GetGuildRosterLastOnline(i);
					if y==0 and m==0 and d==0 and h==0 then
						tinsert(FFGGuildArray,{name,level,note,{officernote,DA.GetStoredColorName(officernote,1)},{rankIndex,rank,rankIndex>max_rank},class, ('|cffffafaf<h'), offlinecounter="00000000"})
					else
						local offlinecounter=((microdatapattern(y) or "00")..(microdatapattern(m) or "00")..(microdatapattern(d) or "00")..(microdatapattern(h) or "00"))
						if y==0 then y=nil else h=nil end
						if m==0 then m=nil else h=nil end
						if d==0 then d=nil end
						if h==0 then h=nil end

						tinsert(FFGGuildArray,{name,level,note,{officernote,DA.GetStoredColorName(officernote,1)},
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
					-- tinsert(FFGGuildArray,{name,"",dat.note,{dat.ofnote,DA.GetStoredColorName(dat.ofnote,1)},{dat.rank,""},dat.class,""  , offlinecounter="00000000"})
					tinsert(FFGGuildArray,{player,"","|cff55ffff_local",{main,DA.GetUnpackedColorName(main,1,gtype)},{"local",""},""})
				end
			end
		else
			for player,main in pairs(FEP_L_gMain[DA_CurrentGuild]) do
				tinsert(FFGGuildArray,{player,"","|cff55ffff_local",{main,DA.GetStoredColorName(main,1)},{"local",""},""})
			end
		end
	end
end
function DA.GuildSetAllLines()
	if DA_CurrentGuild=="n0-guild" and not DarkAngelGuild.custom_mode then return end

	local eb={}
	for r=1,6 do
		local ebt = DarkAngelGUI.Guild["EB"..r]:GetText()
		if ebt~="" then
			DarkAngelGUI.Guild["EB"..r].t:SetBlendMode("BLEND")
			if checkIsNotMalformed(ebt) then
				eb[r]=ebt
				DarkAngelGUI.Guild["EB"..r]:SetGoodColor()
			else
				DarkAngelGUI.Guild["EB"..r]:SetBadColor()
			end
		else
			DarkAngelGUI.Guild["EB"..r].t:SetBlendMode("ADD")
			DarkAngelGUI.Guild["EB"..r]:SetGoodColor()
		end
	end

	if DarkAngelGuild.custom_mode then

	elseif not fuckingOptions.showonl and not fuckingOptions.showoffl then
		DarkAngelGUI.Guild.foundtext:SetText("found |cffffaaff0|r players (|cffff3b5fno online/offline specified|r)")
		DarkAngelGuild:Hide()
		return
	end
	DarkAngelGuild:Show()

	local dump = GetGuildDataFiltered(eb[1],eb[2],eb[3],eb[4],eb[5],eb[6])

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
		if tonumber(DarkAngelGuild.found) then
			if DarkAngelGuild.found and numonlpl_dump then
				if DarkAngelGuild.custom_mode then
					DarkAngelGUI.Guild.foundtext:SetText('backup: |cff00ffff'..DarkAngelGuild.found.."|r "..numonlpl_dump)
				else
					DarkAngelGUI.Guild.foundtext:SetText('found |cff00ffff'..DarkAngelGuild.found.."|r players "..numonlpl_dump)
				end
			end
		end

		DarkAngelGuild:Show()
			GuildSetLine(dump)
	end
end



DA.AddToBuildQueue("Guild", function()
    DA.TabCreater({"TOP",_G["DarkAngelGUI"],"BOTTOMLEFT",55,0},15,40,10,50,"Guild",{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},function(self) DA.SetTimerTime('grefresher',5)  DA.GetGuildData();DA.TimerAfter(0, function() DA.GuildSetAllLines();DA.ResetScrollBoxes() end) end,function() DA.ResetScrollBoxes() end,[[Interface\AddOns\DarkAngel\template\pict\art_guild]])
    local copyFrame_Update
    local update_class_srch

    Guild_Create_ScrollBar()
    DarkAngelGUI.Guild.precmatch=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",65,-6},14,14,'A',function(self) fuckingOptions.precisematchsearch=(self:GetChecked() or false) DA.GetGuildData(1);DA.GuildSetAllLines() end,{'fuckingOptions','precisematchsearch'},"precisematchsearch")
    DarkAngelGUI.Guild.showlocals=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",65,-16},14,14,'L',function(self) fuckingOptions.showlocals=(self:GetChecked() or false) DA.GetGuildData(1);DA.GuildSetAllLines() end,{'fuckingOptions','showlocals'},"showlocals")

    DarkAngelGUI.Guild.onliners=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",93,-6},14,14,'online',function(self) fuckingOptions.showonl=(self:GetChecked() or false) DA.GetGuildData();DA.GuildSetAllLines() end,{'fuckingOptions','showonl'})
    DarkAngelGUI.Guild.offliners=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",93,-16},14,14,'offline',function(self) fuckingOptions.showoffl=(self:GetChecked() or false) DA.GetGuildData();DA.GuildSetAllLines() end,{'fuckingOptions','showoffl'})

    -- refresh
    DarkAngelGUI.Guild.refreshbtn=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",163,-8},8,52,L['refresh'],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function()
        DA.GetGuildData()
        DA.GuildSetAllLines()
    end)
    DarkAngelGUI.Guild.activescan=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",148,-16},14,14,'auto',function(self)
        fuckingOptions.grefr=(self:GetChecked() or false)
        if self:GetChecked() then
            DA.ResumeTimer('grefresher')
        else
            DA.StopTimer('grefresher')
        end
    end,{'fuckingOptions','grefr'},'grefr')
    if fuckingOptions.grefr then SetCVar("guildMemberNotify",1) end
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
            {'EPGP:EP'},
            {'EPGP:GP'},
            {'EPGP:PR'},
        }
        
        
        local function re_highlight_gsort()
            for i=1,#additgsort do
                if DarkAngelGUI.Guild.gsortFrame[i].fs:GetText()==fuckingOptions.gsort then
                    DarkAngelGUI.Guild.gsortFrame[i].fs:SetTextColor(0.2,1,1,1)
                else
                    DarkAngelGUI.Guild.gsortFrame[i].fs:SetTextColor(0.85,1,1,1)
                end
            end
        end
        local gsortfix = {
            ep = {
                'EPGP:EP',
                'EPGP:GP',
                'EPGP:PR',
            },
            dkp = {
                'DKP:Net',
                'DKP:Total',
                'DKP:Hours',
            }
        }

        local function re_render_gsort()

            local guild = DA_Guild_Info[DA_CurrentGuild]
            local isEPGP = guild and guild.GuildType == "epgp"

            local tablehint = isEPGP and "ep" or "dkp"
            local tableInversehint = isEPGP and "dkp" or "ep"

            local hintTable = gsortfix[tablehint]
            local inverseTable = gsortfix[tableInversehint]
            local frames = DarkAngelGUI.Guild.gsortFrame

            -- fix selected to match new gtype
            for id, value in ipairs(inverseTable) do
                if fuckingOptions.gsort == value then
                    fuckingOptions.gsort = hintTable[id]
                    break
                end
            end

            for i = 1, 3 do
                frames[i+9].fs:SetText(hintTable[i])
            end

            re_highlight_gsort()
        end
        DarkAngelGUI.Guild.gsortbtn,DarkAngelGUI.Guild.gsortFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild,L["sort"],12,32,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",215,-10},164,90,{"BOTTOMRIGHT", "TOPRIGHT", 65, 5})
        DarkAngelGUI.Guild.gsortFrame:SetFrameLevel(DarkAngelGUI.Guild:GetFrameLevel()+15)
        for i,criteria in pairs(additgsort) do
            DarkAngelGUI.Guild.gsortFrame[i]=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.gsortFrame,{"TOPLEFT", DarkAngelGUI.Guild.gsortFrame, "TOPLEFT", (i>8 and 70.5 or 1),10-11*(i>8 and i-8 or i)},10,(i>8 and 92 or 68),criteria[1],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), criteria[2] or 9, "OUTLINE"},function(self)

                fuckingOptions.gsort=self.fs:GetText()
                DA.GetGuildData(1)
                DA.GuildSetAllLines()
                re_highlight_gsort()
            end,criteria[3] or nil,nil,'center')
        end
        
        
        re_render_gsort()
        table.insert(DA.RunOnGuildUpdate, re_render_gsort)


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
                    if self.focusgained then
                        fuckingOptions.gcopyfrsep=self:GetText()
                        copyFrame_Update()
                    end
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
                    if self.focusgained and tonumber(self:GetText()) and tonumber(self:GetText())>0 then
                        fuckingOptions.gcopyfrnumlines=self:GetText()
                        copyFrame_Update()
                    end
                end,1
            )
            DarkAngelGUI.Guild.copyFrame.numlines:SetText(fuckingOptions.gcopyfrnumlines)

            DarkAngelGUI.Guild.copyFrame.selected=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.copyFrame,{"TOPLEFT", DarkAngelGUI.Guild.copyFrame, "TOPLEFT", 10,-132},15,15,"selected",function(self)
            if self:GetChecked() then DarkAngelGUI.Guild.copyFrame.numlines:EnableMouse(false);DarkAngelGUI.Guild.copyFrame.numlines:SetAlpha(0.6) else DarkAngelGUI.Guild.copyFrame.numlines:EnableMouse(true);DarkAngelGUI.Guild.copyFrame.numlines:SetAlpha(1) end copyFrame_Update() end)
            DA.FontCreater(nil,L['lines to print'],{"LEFT",DarkAngelGUI.Guild.copyFrame.selected,"LEFT",-5,9},DarkAngelGUI.Guild.copyFrame.selected,15,170,{UIDarkAngelFontConsolas:GetFont(), 8},'left',{0.85,1,1,0.4})

            if next(Players_Selected) then DarkAngelGUI.Guild.copyFrame.selected:SetChecked(true) end
        end

        local CopyFrameAdditional=DA.FrameCreater(nil,DarkAngelGUI.Guild.copyFrame,499,175,{"BOTTOMLEFT",DarkAngelGUI.Guild.copyFrame,"BOTTOMRIGHT"})
        CopyFrameAdditional:Show()
        DA.CloseButtonCreater(nil,DarkAngelGUI.Guild.copyFrame,{"center", CopyFrameAdditional, "TOPRIGHT", -8.5,-8.5},12,12,'x',CopyFrameAdditional:GetFrameLevel()+3)

        DarkAngelGuild_CopyFrame = DA.ScrollBarCreater("DarkAngelGuild_CopyFrame",CopyFrameAdditional,{CopyFrameAdditional.width-5, CopyFrameAdditional.height-30},{"TOPLEFT", 5, -20},1)
        local copyfr_Scrolled=DarkAngelGuild_CopyFrame.scrollchild

        CopyFrameAdditional.EB=DA.EditBoxCreater(nil,copyfr_Scrolled,{"TOPLEFT", copyfr_Scrolled, "TOPLEFT", 5, -2},{462,390},nil,true,false,{UIDarkAngelFontConsolas:GetFont(), 7},
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

        DA.CreateFFGButton2(nil,CopyFrameAdditional,{"CENTER",CopyFrameAdditional,"TOPLEFT",40,-12},12,50,'print','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 10, "OUTLINE"},function()
            copyFrame_Update(1)
        end)

        DA.CheckBtnCreater(nil,CopyFrameAdditional,{"CENTER",CopyFrameAdditional,"TOPLEFT",75,-12},15,15,"auto",function(self) fuckingOptions.guildcopyauto=(self:GetChecked() or false) end,{'fuckingOptions','guildcopyauto'})


        copyFrame_Update = function(manual)
            if not DarkAngelGUI.Guild.copyFrame:IsShown() then return end
            if not fuckingOptions.guildcopyauto and not manual then return end

            local unlocked
            local search={}
            for i,c in pairs(search_patterns) do
                if DarkAngelGUI.Guild.copyFrame[c[1]]:GetChecked() then
                    unlocked=true
                    search[c[2]]=true
                end
            end

            local editbox=CopyFrameAdditional.EB

            local oldtext = editbox:GetText()

            if not unlocked then DA.Print(L['select at least one criteria']) return end

            local separator=DarkAngelGUI.Guild.copyFrame.separator:GetText()
            if not separator or separator == "" then
                DA.Print("separating data with single spacing")
                separator=" "
            end

            local doing_by_selection = DarkAngelGUI.Guild.copyFrame.selected:GetChecked()


            if not tonumber(fuckingOptions.gcopyfrnumlines) or tonumber(fuckingOptions.gcopyfrnumlines)<=0 then
                fuckingOptions.gcopyfrnumlines=1000
                DarkAngelGUI.Guild.copyFrame.numlines:SetText(fuckingOptions.gcopyfrnumlines)
            end

            local result = {}

            if doing_by_selection then
                for _,player in ipairs(DA.DA_GuildRoster) do
                    if Players_Selected[player.plname] then
                        -- if player.isLocal then
                        local line = {}
                        for _,patt in ipairs(search_patterns) do
                            if search[patt[2]] and player[patt[2]] then
                                local ss,_ = tostring(player[patt[2]]):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                                tinsert(line, ss)
                            end
                        end
                        if next(line) then
                            tinsert(result, table.concat(line, separator))
                        end
                    end
                end

            else
                for i=1,tonumber(fuckingOptions.gcopyfrnumlines) do
                    local player = DA.DA_GuildRoster[i]
                    if player then
                        -- if player.isLocal then
                        local line = {}
                        for _,patt in ipairs(search_patterns) do
                            if search[patt[2]] and player[patt[2]] then
                                local ss,_ = tostring(player[patt[2]]):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                                tinsert(line, ss)
                            end
                        end
                        if next(line) then
                            tinsert(result, table.concat(line, separator))
                        end
                    end
                end

            end
            local newtext = table.concat(result, "\n")
            if oldtext ~= newtext then
                -- editbox:Hide()
                editbox:SetText(newtext)
                -- editbox:Show()
            end
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
        DA.GetGuildData();SelectGuildMember(nil,true)
        DA.GuildSetAllLines()

    end)

    -- patterns
    do
        DarkAngelGUI.Guild.patternsbtn,DarkAngelGUI.Guild.patternsFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild,L["patterns"],12,55,{"CENTER",DarkAngelGUI.Guild,"TOPLEFT",325,-10},147,79,{"BOTTOMLEFT", "TOPLEFT", 0, 5})
        DarkAngelGUI.Guild.patternsFrame:SetFrameLevel(DarkAngelGUI.Guild:GetFrameLevel()+15)
        do --defaults
            local function getMainPatternOffnote()
                return (DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' and "^(%d+),(%d+)" or "Ne?t?:(%-?%d+)")
            end
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
                        getMainPatternOffnote,
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
                
                --epgp frozen stuffs
                {
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
                    },
                    epgptype = true
                },
                {
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
                    },
                    epgptype = true
                },
                {
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
                    },
                    epgptype = true
                },
                
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

            local epgpPatternButtons={}
            -- 
            for _,ss in ipairs(patterns_c) do
                local f = DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.patternsFrame,{"TOPLEFT", DarkAngelGUI.Guild.patternsFrame, "TOPLEFT",-25+((ss[2])*26),	10-(11*(ss[1]))},10,25,ss[3],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up'..ss[6],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
                    DarkAngelGUI.Guild.precmatch:SetChecked(ss[4]);fuckingOptions.precisematchsearch=ss[4]
                    DarkAngelGUI.Guild.showlocals:SetChecked(ss[5]);fuckingOptions.showlocals=ss[5]
                    for i=1,6 do
                        if ss.ebx[i] then
                            if i==4 and type(ss.ebx[4])=='function' then
                                DarkAngelGUI.Guild["EB"..i]:SetText(ss.ebx[4]())
                            else
                                DarkAngelGUI.Guild["EB"..i]:SetText(ss.ebx[i])
                            end
                        else
                            DarkAngelGUI.Guild["EB"..i]:SetText("")
                        end
                    end
                    DA.GetGuildData();DA.GuildSetAllLines()
                end,ss[7])
                
                if ss.epgptype then
                    table.insert(epgpPatternButtons, f)
                end

            end

            local function updateEPGPButtons()
                local isEPGP = DA_Guild_Info[DA_CurrentGuild].GuildType == "epgp"
                local method = isEPGP and "Show" or "Hide"

                for _, btn in ipairs(epgpPatternButtons) do
                    btn[method](btn)
                end
            end
            updateEPGPButtons()
            table.insert(DA.RunOnGuildUpdate, updateEPGPButtons)
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
                DarkAngelGUI.Guild.patternsFrame:SetSize(54,79)
            else
                DarkAngelGUI.Guild.patternsFrame:SetSize(147,79)
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

            DarkAngelGUI.Guild.patternsFrame.addnewFrame.save=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.patternsFrame.addnewFrame,{"CENTER",DarkAngelGUI.Guild.patternsFrame.addnewFrame.name,"CENTER",-5,-13},8,35,L["save"],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
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

            DarkAngelGUI.Guild.patternsFrame.save=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.patternsFrame,{"TOPLEFT", DarkAngelGUI.Guild.patternsFrame, "TOPLEFT",12, -61.5},8,35,L["save"],[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
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
        DA_RightClickMenu.epgpawardFrame:Hide()
        DarkAngelGUI.Guild.bulkmenu:Hide()
        DarkAngelGUI.Guild.bulkBtn:Enable()

        DA.GetGuildData()
        DA.GuildSetAllLines()
    end)
    DarkAngelGUI.Guild.backupClose:Hide()

    -- bulk actions
    do
        --bulk
        do
            DarkAngelGUI.Guild.bulkmenu=DA.FrameCreater(nil,DarkAngelGUI.Guild,188.25,157,{"BOTTOMLEFT",DarkAngelGUI.Guild,'BOTTOMRIGHT',3,0})

            DA.CloseButtonCreater(nil,DarkAngelGUI.Guild.bulkmenu,{"center", DarkAngelGUI.Guild.bulkmenu, "TOPRIGHT", -8.5,-8.5},12,12,'x')

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
            local actions_list={L['award'],L['note'],L['officer note'],L['rank'],L['kick']}
            DarkAngelGUI.Guild.bulkmenu.actionbtn,DarkAngelGUI.Guild.bulkmenu.actionFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild.bulkmenu,'',12,85,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",58,-38},80,((#actions_list*11) +1),"BOTTOM",'left',function()
                DarkAngelGUI.Guild.bulkmenu.applytoFrame:Hide()
                DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
            end)
            for i,j in ipairs(actions_list) do
                DarkAngelGUI.Guild.bulkmenu.actionFrame['fr'..i]=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu.actionFrame,{"TOPLEFT", DarkAngelGUI.Guild.bulkmenu.actionFrame, "TOPLEFT", 1,10-11*i},10,78,j,'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
                    DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:SetText(self.fs:GetText())
                    DarkAngelGUI.Guild.bulkmenu.actionFrame:Hide()
                    if i<4 then
                        --ranks
                        DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:Hide()
                        DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
                        DarkAngelGUI.Guild.bulkmenu.adranksmenufont:Hide()
                        --eb
                        if i~=1 then
                            DarkAngelGUI.Guild.bulkmenu.adnotebox:Show()
                            DarkAngelGUI.Guild.bulkmenu.award123Frame:Hide()
                        else
                            DarkAngelGUI.Guild.bulkmenu.adnotebox:Hide()
                            DarkAngelGUI.Guild.bulkmenu.award123Frame:Show()
                        end
                    elseif i==4 then
                        --ranks
                        DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:Show()
                        DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
                        DarkAngelGUI.Guild.bulkmenu.adranksmenufont:Show()
                        --eb
                        DarkAngelGUI.Guild.bulkmenu.adnotebox:Hide()
                        DarkAngelGUI.Guild.bulkmenu.award123Frame:Hide()
                    elseif i==5 then
                        --ranks
                        DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:Hide()
                        DarkAngelGUI.Guild.bulkmenu.adranksmenuFrame:Hide()
                        DarkAngelGUI.Guild.bulkmenu.adranksmenufont:Hide()
                        --eb
                        DarkAngelGUI.Guild.bulkmenu.adnotebox:Hide()
                        DarkAngelGUI.Guild.bulkmenu.award123Frame:Hide()
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


            --Award
            DarkAngelGUI.Guild.bulkmenu.award123Frame=CreateFrame("Frame",nil,DarkAngelGUI.Guild.bulkmenu)
            DarkAngelGUI.Guild.bulkmenu.award123Frame:SetSize(1,1)
            -- DarkAngelGUI.Guild.bulkmenu.award123Frame:SetFrameLevel()
            DarkAngelGUI.Guild.bulkmenu.award123Frame:SetPoint("TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",3,-51)
                do
                    DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown = DA.FrameCreater(nil,DarkAngelGUI.Guild.bulkmenu.award123Frame,270,111,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPRIGHT",2,-59})
                        DA.CloseButtonCreater(nil,DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown,{"BOTTOMLEFT", DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown, "TOPRIGHT", 2,2},10,10,'x')
                    for i=1,20 do
                        DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown['btn'..i]=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown,{"TOPLEFT", DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown, "TOPLEFT", 1,10-11*i},10,268,"",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_White.blp',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function(self)

                        end,nil,nil,'left')
                    end
                    local AWDropdown_rerender


                    local function epgpdkpfunc(self)
                        local self = self or DarkAngelGUI.Guild.bulkmenu.award123Frame.epgp
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
                    DA.HelpCreater(DarkAngelGUI.Guild.bulkmenu.award123Frame,{"CENTER",DarkAngelGUI.Guild.bulkmenu.award123Frame,"TOPLEFT",15,-36},'awardprocent_tt',20,20)
                    DarkAngelGUI.Guild.bulkmenu.award123Frame.epgp=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu.award123Frame,{"TOPLEFT", DarkAngelGUI.Guild.bulkmenu.award123Frame, "TOPLEFT", 1, -9},15,30,((DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' and 'EP') or (DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' and '+DKP')),'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Green',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},epgpdkpfunc)

                    DarkAngelGUI.Guild.bulkmenu.award123Frame.reason=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.bulkmenu.award123Frame,{"TOPLEFT", DarkAngelGUI.Guild.bulkmenu.award123Frame, "TOPLEFT", 35, -10},{90,11},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 9},
                        function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown:Hide();self.focusgained=nil end,
                        function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown:Hide();self.focusgained=nil end, --enter here
                        function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown:Hide();self.focusgained=nil end,
                        function(self)
                            if self:GetParent():IsShown() then
                                self.t:SetBlendMode('blend');
                                self.focusgained=1
                                self:HighlightText()
                                AWDropdown_rerender()
                            end
                        end,
                        function(self)
                            if self:GetParent():IsShown() and self.focusgained then
                                AWDropdown_rerender()
                            end
                        end
                    )
                    DarkAngelGUI.Guild.bulkmenu.award123Frame.reason:SetText("test")
                        DA.FontCreater(nil,L['reason'],{"BOTTOMLEFT",DarkAngelGUI.Guild.bulkmenu.award123Frame.reason,"TOPLEFT",3,-3},DarkAngelGUI.Guild.bulkmenu.award123Frame.reason,15,170,{UIDarkAngelFontConsolas:GetFont(), 10},'left',{0.85,1,1,0.8})
                        DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu.award123Frame.reason,{"TOPRIGHT",DarkAngelGUI.Guild.bulkmenu.award123Frame.reason,"TOPRIGHT",0,0},5,5,'x',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 6},function() DarkAngelGUI.Guild.bulkmenu.award123Frame.reason:SetText("") end,nil,nil,'left')

                    DarkAngelGUI.Guild.bulkmenu.award123Frame.value=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.bulkmenu.award123Frame,{"TOPLEFT", DarkAngelGUI.Guild.bulkmenu.award123Frame, "TOPLEFT", 35, -32},{90,11},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 9},
                        function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown:Hide();self.focusgained=nil end,
                        function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown:Hide();self.focusgained=nil end, --enter here
                        function(self) 		if self:GetText()~="" then self.t:SetBlendMode("BLEND") else self.t:SetBlendMode("ADD") end ;self:ClearFocus(); DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown:Hide();self.focusgained=nil end,
                        function(self)
                            if self:GetParent():IsShown() then
                                self.t:SetBlendMode('blend');
                                self.focusgained=1
                                AWDropdown_rerender()
                            end
                        end,
                        function(self)
                            if self:GetParent():IsShown() and self.focusgained then
                                AWDropdown_rerender()
                            end
                        end
                    )
                    DA.FontCreater(nil,L['value'],{"BOTTOMLEFT",DarkAngelGUI.Guild.bulkmenu.award123Frame.value,"TOPLEFT",3,-3},DarkAngelGUI.Guild.bulkmenu.award123Frame.value,15,170,{UIDarkAngelFontConsolas:GetFont(), 10},'left',{0.85,1,1,0.8})
                    DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu.award123Frame.value,{"TOPRIGHT",DarkAngelGUI.Guild.bulkmenu.award123Frame.value,"TOPRIGHT",0,0},5,5,'x',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 6},function() DarkAngelGUI.Guild.bulkmenu.award123Frame.value:SetText("") end,nil,nil,'left')

                    function AWDropdown_rerender()
                        local entries = DA.getRecentAwardsFiltered(DarkAngelGUI.Guild.bulkmenu.award123Frame.reason:GetText(), DarkAngelGUI.Guild.bulkmenu.award123Frame.value:GetText())
                        if #entries == 0 then
                            DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown:Hide()
                            return
                        end

                        local displaydate
                        local counted = 0
                        for i=1,20 do
                            local entry = entries[i]

                            if not entry then
                                DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown['btn'..i]:Hide()
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

                                DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown['btn'..i]:SetText(TimeText .. "  |r"..name.. "  |r"..DA.getColoredRecentAwardValue(epgp,value).. " |r("..reason.."|r)")
                                DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown['btn'..i]:SetScript("OnClick",function()
                                    DarkAngelGUI.Guild.bulkmenu.award123Frame.reason:ClearFocus()
                                    DarkAngelGUI.Guild.bulkmenu.award123Frame.value:ClearFocus()
                                    DarkAngelGUI.Guild.bulkmenu.award123Frame.reason:SetText(reason)
                                    DarkAngelGUI.Guild.bulkmenu.award123Frame.value:SetText(value)
                                    DA.SetRecentAwardBtnTxt(epgp, DarkAngelGUI.Guild.bulkmenu.award123Frame.epgp)
                                end)
                                DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown['btn'..i]:Show()
                                counted = counted + 1
                            end
                        end
                        DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown:SetSize(270,((counted * 11) + 1))
                        DarkAngelGUI.Guild.bulkmenu.award123Frame.Dropdown:Show()
                    end

                end
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
                SelectGuildMember(nil,true)
                DarkAngelGUI.Guild.UpdRows(DarkAngelGuild.offset or 1)
            end)

            ----START
            DarkAngelGUI.Guild.bulkmenu.startbulk=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu,{"CENTER",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",166,-30.5},10,40,L["bulkstart"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red.blp',{UIDarkAngelFontConsolas:GetFont(), 9, 'outline'},function(self)
                    DarkAngelGUI.Guild.bulkmenu.adnotebox:ClearFocus()
                    DarkAngelGUI.Guild.bulkmenu.adnotebox.focusgained=nil
                    if DarkAngelGUI.Guild.bulkmenu.applytobtn.fs:GetText() and DarkAngelGUI.Guild.bulkmenu.actionbtn.fs:GetText() and (not DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() or (DarkAngelGUI.Guild.bulkmenu.adranksmenubtn:IsShown() and DarkAngelGUI.Guild.bulkmenu.adranksmenubtn.fs:GetText())) then
                        self:Disable()
                        Run_ProcessBulk()
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
                DarkAngelGUI.Guild.bulkmenu.award123Frame:Hide()
                DarkAngelGUI.Guild.bulkmenu.stoper:Disable()
            end
        end

        ----retwink menu----
        do
            DarkAngelGUI.Guild.bulkmenu.assignedto=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",10,-107},{100,12},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 10},
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
            DA.FontCreater(nil,L['re-assign players assigned to'],{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu.assignedto,"TOPLEFT",5,12},DarkAngelGUI.Guild.bulkmenu.assignedto,15,170,{UIDarkAngelFontConsolas:GetFont(), 8,'outline'},'left',{0.85,1,1,0.8})
            DarkAngelGUI.Guild.bulkmenu.astdropfr=DA.FrameCreater(nil,DarkAngelGUI.Guild.bulkmenu.assignedto,160,20,{"BOTTOMLEFT",DarkAngelGUI.Guild.bulkmenu.assignedto,"TOPLEFT"})

            DarkAngelGUI.Guild.bulkmenu.newmain=DA.EditBoxCreater(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",10,-137},{100,12},nil,false,false,{UIDarkAngelFontConsolas:GetFont(), 10},
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

            DarkAngelGUI.Guild.bulkmenu.ismakingnewmain=DA.CheckBtnCreater(nil,DarkAngelGUI.Guild.bulkmenu,{"CENTER",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",137,-137},15,15,L["Make it new Main"],function(self) end)
            DarkAngelGUI.Guild.bulkmenu.ismakingnewmain.font:SetSize(80,30)

            DarkAngelGUI.Guild.bulkmenu.retvgobtn=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu,{"center",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",163,-117},12,40,L["bulkstart"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function(self)
                DarkAngelGUI.Guild.bulkmenu.assignedto.focusgained=nil;DarkAngelGUI.Guild.bulkmenu.assignedto:ClearFocus()
                DarkAngelGUI.Guild.bulkmenu.newmain.focusgained=nil;DarkAngelGUI.Guild.bulkmenu.newmain:ClearFocus()
                if not CanEditOfficerNote() then
                    DA.Print(L['I am not allowed to edit officer notes'])
                    return
                else
                    self:Disable()
                    Run_ReTwink()
                end
            end)

            DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",85,-123},10,28,'swap','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function()
                local first=DarkAngelGUI.Guild.bulkmenu.assignedto:GetText()
                local second=DarkAngelGUI.Guild.bulkmenu.newmain:GetText()
                DarkAngelGUI.Guild.bulkmenu.assignedto:SetText(second)
                DarkAngelGUI.Guild.bulkmenu.newmain:SetText(first)
            end)
            DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",110,-107},13,10,'>','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function()
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
            DarkAngelGUI.Guild.bulkmenu.retvrunsrch2=DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.bulkmenu,{"TOPLEFT",DarkAngelGUI.Guild.bulkmenu,"TOPLEFT",110,-137},13,10,'>','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 8, 'outline'},function()
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

            DA.CreateFFGButton2(nil,DarkAngelGUI.Guild["EB"..i],{"TOPRIGHT",DarkAngelGUI.Guild["EB"..i],"TOPRIGHT",0,0},5,5,'x',[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 6},function() DarkAngelGUI.Guild["EB"..i]:ClearFocus();DarkAngelGUI.Guild["EB"..i]:SetText(""); DA.GuildSetAllLines()  end,nil,nil,'left')

            DA.FontCreater(nil,j[4],{"LEFT",DarkAngelGUI.Guild["EB"..i],"LEFT",2.5,15},DarkAngelGUI.Guild["EB"..i],15,170,{UIDarkAngelFontConsolas:GetFont(), 10},'left',{0.85,1,1,0.8})

        end

        DarkAngelGUI.Guild.foundtext=DA.FontCreater(nil,'found:',{"LEFT",DarkAngelGUI.Guild.EB1,"LEFT",10,-15},DarkAngelGUI.Guild.EB1,15,400,{UIDarkAngelFontConsolas:GetFont(), 9,'outline'},'left',{0.85,1,1,0.6})

        DarkAngelGUI.Guild.classTbl={}
        DarkAngelGUI.Guild.classbtn,DarkAngelGUI.Guild.classFrame=DA.CreateFFGDropFrame(DarkAngelGUI.Guild,L["class"],7,35,{"CENTER", DarkAngelGUI.Guild, "TOPLEFT", 65, -24},70,120.5,"BOTTOM",nil,function() end,nil,nil,true)
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
            DarkAngelGUI.Guild.classFrame[class] = DA.CreateFFGButton2(nil,DarkAngelGUI.Guild.classFrame,{"TOPLEFT", DarkAngelGUI.Guild.classFrame, "TOPLEFT", 1, -(11*i)},10,68,class,[[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]],{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
                if self.enabled then DarkAngelGUI.Guild.classTbl[class]=nil else DarkAngelGUI.Guild.classTbl[class]=true end
                update_class_srch()
                DA.GetGuildData();DA.GuildSetAllLines()
                copyFrame_Update()
            end)
            DarkAngelGUI.Guild.classFrame[class].fs:SetTextColor(unpack(DA.GetNumericClassColor(class)))

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
                    DarkAngelGUI.Guild.classFrame[class]:SetNormalTexture([[Interface\AddOns\DarkAngel\template\UI-Panel-Button-Up_Black]])
                    DarkAngelGUI.Guild.classFrame[class].enabled=false
                end
            end
        end

    end
end)
