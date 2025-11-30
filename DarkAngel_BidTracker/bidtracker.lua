
local DA=LibStub("AceAddon-3.0"):GetAddon("DarkAngel")
local L = LibStub("AceLocale-3.0"):GetLocale("DarkAngel")
local LGT=LibStub:GetLibrary('LibGroupTalents-1.0')
local Mod = DA:NewModule("BidTracker")



local item_IDs_roster={
	["Axe1H"] = 50191,
	["Axe2H"] = 49888,
	["Bow"] = 50034,
	["Gun"] = 50444,
	["Mace1H"] = 50738,
	["Mace2H"] = 50603,
	["Polearm"] = 50735,
	["Sword1H"] = 50732,
	["Sword2H"] = 50761,
	["Staff"] = 50731,
	["FistWeapon"] = 51003,
	["Dagger"] = 50736,
	["Thrown"] = 47659,
	["Crossbow"] = 50733,
	["Wand"] = 49852,
	["Other"] = 50781,
	
	["Cloth"] = 50449,
	["Leather"] = 51296,
	["Mail"] = 51241,
	["Plate"] = 51225,
	["Shield"] = 50729
}
local classRestrictions = {
	WARRIOR = {
		weapons = {
			Axe1H = true, Axe2H = true,
			Mace1H = true, Mace2H = true,
			Sword1H = true, Sword2H = true,
			Polearm = true, Staff = true,
			FistWeapon = true, Dagger = true,
			Thrown = true, Bow = true, Crossbow = true, Gun = true
		},
		armors = {
			Cloth = true, Leather = true, Mail = true, Plate = true, Shield = true
		}
	},
	PALADIN = {
		weapons = {
			Axe1H = true, Axe2H = true,
			Mace1H = true, Mace2H = true,
			Sword1H = true, Sword2H = true,
			Polearm = true
		},
		armors = {
			Cloth = true, Leather = true, Mail = true, Plate = true, Shield = true
		}
	},
	HUNTER = {
		weapons = {
			Axe1H = true, Axe2H = true,
			Sword1H = true, Sword2H = true,
			Staff = true, Polearm = true, Dagger = true, FistWeapon = true,
			Thrown = true, Bow = true, Crossbow = true, Gun = true
		},
		armors = {
			Cloth = true, Leather = true, Mail = true
		}
	},
	ROGUE = {
		weapons = {
			Axe1H = true, Mace1H = true,
			Sword1H = true,
			FistWeapon = true, Dagger = true,
			Thrown = true, Bow = true, Crossbow = true, Gun = true
		},
		armors = {
			Cloth = true, Leather = true
		}
	},
	PRIEST = {
		weapons = {
			Staff = true, Wand = true, Dagger = true, Mace1H = true
		},
		armors = {
			Cloth = true
		}
	},
	SHAMAN = {
		weapons = {
			Axe1H = true, Axe2H = true,
			Mace1H = true, Mace2H = true,
			Staff = true, Dagger = true, FistWeapon = true
		},
		armors = {
			Cloth = true, Leather = true, Mail = true, Shield = true
		}
	},
	MAGE = {
		weapons = {
			Staff = true, Wand = true, Dagger = true, Sword1H = true
		},
		armors = {
			Cloth = true
		}
	},
	WARLOCK = {
		weapons = {
			Staff = true, Wand = true, Dagger = true, Sword1H = true
		},
		armors = {
			Cloth = true
		}
	},
	DRUID = {
		weapons = {
			Mace1H = true, Mace2H = true, Polearm = true, 
			Staff = true, Dagger = true, FistWeapon = true,
		},
		armors = {
			Cloth = true, Leather = true
		}
	},
	DEATHKNIGHT = {
		weapons = {
			Axe1H = true, Axe2H = true,
			Mace1H = true, Mace2H = true,
			Sword1H = true, Sword2H = true,
			Polearm = true
		},
		armors = {
			Cloth = true, Leather = true, Mail = true, Plate = true
		}
	}
}
local healerTrinkets = {
	[50339] = true, [50346] = true, -- осколок чистейшего льда
	[50359] = true, [50366] = true, -- счёты алтора
	[54573] = true, [54589] = true, -- чешка хил
	[47271] = true, [47432] = true, [47041] = true, [47059] = true, -- Утешение павших\Утешение побежденных
	[47880] = true, [48019] = true, [47728] = true, [47947] = true, -- Связующий камень\Связующий свет
}
local tankTrinkets = {
	[50349] = true, [50352] = true, -- монета
	[50341] = true, [50344] = true, -- орган
	[50361] = true, [50364] = true, -- клык
	[54571] = true, [54591] = true, -- чешка танк
	[47290] = true, [47451] = true, [47080] = true, [47088] = true, -- Жизненная сила владыки мира\Упрямый скарабей Сатрины
	[47882] = true, [48021] = true, [47727] = true, [47949] = true, -- Клятва Эйтригга\Страсть Зиморожденных
}
local meleeTrinkets = {
	[50342] = true, [50343] = true, -- череп
	[50362] = true, [50363] = true, -- воля
	[50351] = true, [50706] = true, -- колба
	[54569] = true, [54590] = true, -- чешка мдпс
	[47881] = true, [48020] = true, [47725] = true, [47948] = true, -- Отмщение Отрекшихся\Зов победителя
	[47303] = true, [47464] = true, [47115] = true, [47131] = true, -- Выбор смерти\Приговор смерти
}
local casterTrinkets = {
	[50340] = true, [50345] = true, -- труба
	[50348] = true, [50353] = true, -- обьект
	[50360] = true, [50365] = true, -- тбл
	[54572] = true, [54588] = true, -- чешка рдпс
	[47879] = true, [48018] = true, [47726] = true, [47946] = true, -- Фетиш\Талисман
	[47316] = true, [47477] = true, [47182] = true, [47188] = true, -- Власть мертвых
}

local anyClassItems = {
	[49908] = true, -- Древнейший саронит
	[47556] = true, -- Сфера рыцаря
	[47242] = true, -- Трофей Авангарда
	[50818] = true, -- Поводья Непобедимого
	[49046] = true, -- Стремительный ордынский волк
	[49044] = true, -- Стремительный скакун Альянса
}
local shadowmourneItems = {
	[50274] = true,
	[50231] = true,
	[50226] = true,
}
local shadowmourneClasses = {
	WARRIOR = true,
	DEATHKNIGHT = true,
	PALADIN = true,
}
local ValanyrClasses = {
	SHAMAN = true,
	DRUID = true,
	PALADIN = true,
	PRIEST = true,	--Valanir is bad for both priest healer specs, however, we'll let RL to decide
}
local tierTokens = {
	-- ROGUE, DEATHKNIGHT, MAGE, DRUID
	[52025] = { ROGUE = true, DEATHKNIGHT = true, MAGE = true, DRUID = true },
	[52028] = { ROGUE = true, DEATHKNIGHT = true, MAGE = true, DRUID = true },
	[47559] = { ROGUE = true, DEATHKNIGHT = true, MAGE = true, DRUID = true },

	-- WARRIOR, HUNTER, SHAMAN
	[52026] = { WARRIOR = true, HUNTER = true, SHAMAN = true },
	[52029] = { WARRIOR = true, HUNTER = true, SHAMAN = true },
	[47558] = { WARRIOR = true, HUNTER = true, SHAMAN = true },

	-- PALADIN, PRIEST, WARLOCK
	[52027] = { PALADIN = true, PRIEST = true, WARLOCK = true },
	[52030] = { PALADIN = true, PRIEST = true, WARLOCK = true },
	[47557] = { PALADIN = true, PRIEST = true, WARLOCK = true },
}


CreateFrame("GameTooltip", "DACItemCacheTooltip", nil, "GameTooltipTemplate")
local function QueueItemForCache(itemID)

	local itemname, itemLink, itemRarity, _, _, itemType, itemSubType, _, _, _, _ = GetItemInfo(itemID)
	
    if not (itemname and itemLink) then
        local tooltip = DACItemCacheTooltip
		tooltip:SetOwner(UIParent, "ANCHOR_NONE")
		tooltip:SetHyperlink(string.format("|Hitem:%d:0:0:0:0:0:0:0|h[Unknown Item]|h", itemID))
		tooltip:Hide()
		return
    else
		if itemID==50191 then
			fuckingOptions.localized_items_data["Weapon"]=itemType
			fuckingOptions.localized_items_data["Axe1H"]=itemSubType
				local tooltip = DACItemCacheTooltip or CreateFrame("GameTooltip", "DACItemCacheTooltip", nil, "GameTooltipTemplate")
				tooltip:Show()
				tooltip:SetOwner(UIParent, "ANCHOR_NONE")
				tooltip:SetHyperlink("|Hitem:50191:0:0:0:0:0:0:0|h[Unknown Item]|h")
				local speed
				for i=1,10 do
					if _G["DACItemCacheTooltipTextRight"..i]:GetText() and _G["DACItemCacheTooltipTextRight"..i]:GetText():match("(.+)%s%d%.%d+$") then
						speed=_G["DACItemCacheTooltipTextRight"..i]:GetText():match("(.+)%s%d%.%d+$")
						break
					end
				end
			fuckingOptions.localized_items_data["Weapon_speed"]=speed
				tooltip:Hide()
		elseif itemID==50781 then
			fuckingOptions.localized_items_data["Other"]=itemSubType
		elseif itemID==50729 then
			fuckingOptions.localized_items_data["Armor"]=itemType
			fuckingOptions.localized_items_data["Shield"]=itemSubType
		else
			for item,itemIDToFetch in pairs(item_IDs_roster) do
				if itemIDToFetch==itemID then
					fuckingOptions.localized_items_data[item]=itemSubType
					return
				end
			end
		end
    end
end




DA_BidTracker=DA.FrameCreater(nil,UIParent,150,213,{"TOPLEFT", UIParent, "CENTER", 0, 0})
	DA.CloseButtonCreater(nil,DA_BidTracker,{"TOPRIGHT", DA_BidTracker, "TOPRIGHT", -2,-1},10,10,'x')
DA_BidTracker:RegisterForDrag("LeftButton")
DA_BidTracker:SetScript("OnDragStart", function(self) 
	self:StartMoving(self)
	self.ismoving=1
end )
DA_BidTracker:SetScript("OnDragStop", 	function(self) 
	self:StopMovingOrSizing(self)
	
	local point={DA_BidTracker:GetPoint(1)}
	fuckingOptions.saved_guiPositions.DA_BidTracker={point[1] or "TOPLEFT",point[3] or "CENTER",point[4] or 0,point[5] or 0}
	
end) 

DA.FontCreater(nil,L["Bid tracker"],{"LEFT",DA_BidTracker,"TOPLEFT",2,5},DA_BidTracker,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')

DA_BidTracker.itemicon=DA.ButtonCreater(nil,DA_BidTracker,{"TOPLEFT",DA_BidTracker,"TOPLEFT",2,-2},30,30,'','',function(self,mouse) 
	if not DA_BidTracker.working then 
		DA.Print(L["Bidder module is disabled. Enable it in main addon options"])
		return 
	end
	if mouse=="RightButton" then
		--disable all
		self:SetPushedTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
		self:SetNormalTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
		if DA_BidTracker.bidsession_active then
			SendChatMessage(L["Bid cancelled!"],'raid')
			DA_BidTracker.bidsession_active=false
			DA.StopTimer("itembidder")
		else
			DA.StopTimer("itembidder")
		end
		DA_BidTracker.winnerfont:SetText("")
		DA_BidTracker.itemfont:SetText("")
		DA_BidTracker.itemlink=nil
		DA_BidTracker.pricebox:SetText("1")
		DA_BidTracker.winnermain=nil
		DA_BidTracker.winneralt=nil
		for i=1,9 do
			DA_BidTracker['loot'..i]:Hide()
		end
		GameTooltip:Hide()
	else
		if (CursorHasItem() or (({GetCursorInfo()})[1] and ({GetCursorInfo()})[1]=='item')) and mouse=="LeftButton" then
			if IsRaidOfficer() then
				local _,_,z=GetCursorInfo()
				local name,itemLink,_,_,_,_,_,_,_,texture=GetItemInfo(z);
				SendChatMessage(itemLink,"raid_warning")
				ClearCursor()
				return
			else
				DA.Print(L['I am not RL/assist'])
				return
			end
		end
	end
end)
DA_BidTracker.itemicon:GetNormalTexture():SetBlendMode('blend')
DA_BidTracker.itemicon:GetNormalTexture():SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
DA_BidTracker.itemicon:GetNormalTexture():SetTexCoord(0.02, 0.98, 0.02, 0.98)

DA_BidTracker.itemicon:SetPushedTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
DA_BidTracker.itemicon:GetPushedTexture():SetTexCoord(0,1,0,1)
DA_BidTracker.itemicon:GetPushedTexture():SetBlendMode('blend')


DA_BidTracker.itemfont=DA.FontCreater(nil,"",{"LEFT",DA_BidTracker.itemicon,"RIGHT",2,0},DA_BidTracker.itemicon,30,100,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
do --item font texture
	DA_BidTracker.itemfont.t=DA_BidTracker:CreateTexture(nil, "BACKGROUND")
	DA_BidTracker.itemfont.t:SetPoint("TOPLEFT", DA_BidTracker.itemfont, "TOPLEFT", 0, 0)
	DA_BidTracker.itemfont.t:SetSize(100,30)
	DA_BidTracker.itemfont.t:SetTexture(0.03, 0.04, 0.07, 0.45)
	DA_BidTracker.itemfont.t:SetBlendMode("blend")
end

DA_BidTracker.timerfont=DA.FontCreater(nil,"25",{"LEFT",DA_BidTracker,"TOPLEFT",4,-172},DA_BidTracker,30,100,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'left')
do --timer texture
	DA_BidTracker.timerfont.t=DA_BidTracker:CreateTexture(nil, "BACKGROUND")
	DA_BidTracker.timerfont.t:SetPoint("TOPLEFT", DA_BidTracker.timerfont, "TOPLEFT", -1, -7)
	DA_BidTracker.timerfont.t:SetSize(144,14)
	DA_BidTracker.timerfont.t:SetTexture(0.03, 0.04, 0.07, 0.45)
	DA_BidTracker.timerfont.t:SetBlendMode("blend")
end

DA_BidTracker.timerset5=DA.CreateFFGButton2(nil,DA_BidTracker,{"center", DA_BidTracker, "TOPLEFT",25,-172},12,12,"0",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function()
	if DA_BidTracker.bidsession_active then
		DA.StopTimer("itembidder")
		Mod:BidTimeOut()
	else
		DA.StopTimer("itembidder")
		return
	end
end)

DA_BidTracker.timerset5=DA.CreateFFGButton2(nil,DA_BidTracker,{"center", DA_BidTracker, "TOPLEFT",40,-172},12,12,"5",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function()
	if DA_BidTracker.bidsession_active then
		DA_BidTracker.timer=time()-20
		DA.ResumeTimer("itembidder")
	else
		DA.StopTimer("itembidder")
		return
	end
end)

DA_BidTracker.timerstop=DA.CreateFFGButton2(nil,DA_BidTracker,{"center", DA_BidTracker, "TOPLEFT",61,-172},12,25,"inf",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function()
	DA.StopTimer("itembidder")
end)

DA_BidTracker.timercancelbid=DA.CreateFFGButton2(nil,DA_BidTracker,{"center", DA_BidTracker, "TOPLEFT",120,-172},12,50,"cancel",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function()
	if DA_BidTracker.bidsession_active then
		SendChatMessage(L["Bid cancelled!"],'raid')
		DA_BidTracker.bidsession_active=false
		DA.StopTimer("itembidder")
	else
		DA.StopTimer("itembidder")
		return
	end
end)

DA.FontCreater(nil,"Bid",{"LEFT",DA_BidTracker,"TOPLEFT",2,-40},DA_BidTracker,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
DA.FontCreater(nil,"Bank",{"LEFT",DA_BidTracker,"TOPLEFT",35,-40},DA_BidTracker,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
DA.FontCreater(nil,"Player",{"LEFT",DA_BidTracker,"TOPLEFT",70,-40},DA_BidTracker,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')

DA_BidTracker.winnerfont=DA.FontCreater(nil,"",{"LEFT",DA_BidTracker,"TOPLEFT",4,-187},DA_BidTracker,30,100,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},'left')
DA_BidTracker.pricebox=DA.EditBoxCreater2(nil,DA_BidTracker,{"LEFT", DA_BidTracker, "TOPLEFT",80,-187},{65,12},"1",false,false,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},nil,1,nil,true)

DA.CreateScaler('DA_BidTracker',0.8,2,{'fuckingOptions','BidTrackerScale'})

for i=1,9 do
	DA_BidTracker['loot'..i]=DA.CreateFFGButton2(nil,DA_BidTracker,{"center", DA_BidTracker, "TOP", 0,-40-13*i},12,145,"",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
	end,nil,nil,'left')
	DA_BidTracker['loot'..i]:Hide()
end

local function FindItemLink(message)
	if message:find("item") then
	else
		return nil
	end
	local itemLink = string.match(message, "|c%x+|Hitem:.-|h.-|h|r")
	return itemLink
end

local function getPlayerRaidIdent(name)
	for i=1,40 do
		local nam, _, _, _, _, _, _, online, _, _, _ = GetRaidRosterInfo(i)
		if not online and nam==name then
			return nil,true
		elseif nam and nam==name then
			return 'raid'..i,nil
		end
	end 
	return nil,nil
end
local function checkTradingItemInInventory(itemlink)
	for b=0,4 do 
		for s=1,GetContainerNumSlots(b) do 
			local currentitemlink=GetContainerItemLink(b,s)
			if currentitemlink and currentitemlink==itemlink then
				if not select(3,GetContainerItemInfo(b,s)) then 	
					return b,s
				end
			elseif (b==4 and s==GetContainerNumSlots(b)) then 
				return false
			end
		end 
	end 
end
local function sendMLLootToPlayer(itemlink,name)
	for lootIndex = 1, GetNumLootItems() do  
		if GetLootSlotLink(lootIndex) and GetLootSlotLink(lootIndex)==itemlink then
			for playerID = 1, 40 do
				if GetMasterLootCandidate(playerID,lootIndex) and GetMasterLootCandidate(playerID,lootIndex)==name then 
					GiveMasterLoot(lootIndex, playerID)
					return true
				end  
			end 
		end
	end
	return false
end

local whisperssent={}
	
local function is_tank_item(tbl)
	if 	tbl.ITEM_MOD_DEFENSE_SKILL_RATING_SHORT or
		tbl.ITEM_MOD_PARRY_RATING_SHORT or
		tbl.ITEM_MOD_DODGE_RATING_SHORT then
		return true
	end
end
local function is_caster_item(tbl)
	if 	tbl.ITEM_MOD_SPELL_POWER_SHORT then
		return true
	end
end
local function is_SPD_HIT_item(tbl)
	if 	tbl.ITEM_MOD_SPELL_POWER_SHORT 
		and tbl.ITEM_MOD_HIT_RATING_SHORT then
		return true
	end
end
local function is_SPD_SPIRIT_item(tbl)
	if 	tbl.ITEM_MOD_SPELL_POWER_SHORT and
		tbl.ITEM_MOD_SPIRIT_SHORT then
		return true
	end
end
local function is_SPD_MP5_item(tbl)
	if 	tbl.ITEM_MOD_SPELL_POWER_SHORT and
		tbl.ITEM_MOD_POWER_REGEN0_SHORT then
		return true
	end
end
local function is_AP_item(tbl)
	if 	tbl.ITEM_MOD_ATTACK_POWER_SHORT then
		return true
	end
end
local function is_STR_item(tbl)
	if 	tbl.ITEM_MOD_STRENGTH_SHORT then
		return true
	end
end
local function is_ARP_item(tbl)
	if 	tbl.ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT then
		return true
	end
end
local function get_1h_speed()
	for i=1,10 do
		if _G["DACItemCacheTooltipTextRight"..i] and _G["DACItemCacheTooltipTextRight"..i]:GetText() and _G["DACItemCacheTooltipTextRight"..i]:GetText():match(fuckingOptions.localized_items_data["Weapon_speed"]) then
			return tonumber(_G["DACItemCacheTooltipTextRight"..i]:GetText():match(fuckingOptions.localized_items_data["Weapon_speed"].."%s(%d%.%d+)$"))
			
		end
	end
end
local function addspacestovalue(value)
	local highest=#(tostring(DA_BidTracker.bidsession_roster[1][1]))
	local vallenght=#(tostring(value))
	
	return string.rep(" ",highest-vallenght)..value
end
local function addspacestobank(value)
	local highest=#(tostring(DA_BidTracker.bidsession_roster[1][3]))
	local vallenght=#(tostring(value))
	
	return string.rep(" ",highest-vallenght)..value
end

local function CanItemBeUsedByClass(itemLink, className)

local itemID = tonumber(itemLink:match("item:(%d+)") or 0)
	
	
	if anyClassItems[itemID] then
		return true
	elseif shadowmourneItems[itemID] then
		if shadowmourneClasses[className] then
			return true
		else
			return false
		end
	elseif tierTokens[itemID] then
		if tierTokens[itemID][className] then
			return true
		else
			return false
		end
	elseif itemID==45038 then --Valanyr
		if ValanyrClasses[className] then
			return true
		else
			return false
		end
	
	end

	
	local restrictions = classRestrictions[className]
	if not restrictions then
		return false, "Unknown class"
	end
	
	local _, _, itemRarity, _, _, itemType, itemSubType, _, _, _, _ = GetItemInfo(itemLink)
	local LK=fuckingOptions.localized_items_data

	if itemType == LK["Weapon"] then
		for allowedWeapon, isallowed in pairs(restrictions.weapons) do
			if isallowed and itemSubType == LK[allowedWeapon] then
				return true
			end
		end
	elseif itemType == LK["Armor"] then
		if itemSubType == LK["Other"] then
			return true
		end
		for allowedArmor, isallowed in pairs(restrictions.armors) do
			if isallowed and itemSubType == LK[allowedArmor] then
				return true
			end
		end
	else
		--not usable valuable item
		return true
	end

	return false
end
local function IsLootRoleMaches(class,role,spec_ID)
	for _,t in ipairs(DA_BidTracker.rosterRaidRoles) do
		if t and (not t[1] or class==t[1]) and
			(not t[2] or role==t[2]) and
			(not t[3] or spec_ID==t[3]) then
			return true
		end
	end
end
local function DetermineLootRolesForItem(itemLink, itemType, itemSubType, itemID)

	local itemStatsTbl = GetItemStats(itemLink)
	local LK = fuckingOptions.localized_items_data
	local raidroles = DA_BidTracker.rosterRaidRoles
	local tooltip = DACItemCacheTooltip
		tooltip:Show()
		tooltip:SetOwner(UIParent, "ANCHOR_NONE")
		tooltip:SetHyperlink(itemLink)
		
	if healerTrinkets[itemID] then
		tinsert(raidroles, {nil, 'healer'})
	elseif tankTrinkets[itemID] then
		tinsert(raidroles, {nil, 'tank'})
	elseif meleeTrinkets[itemID] then
		tinsert(raidroles, {nil, 'melee'})
	elseif casterTrinkets[itemID] then
		tinsert(raidroles, {nil, 'caster'})
	
	
	elseif itemType == LK["Weapon"] then
		if is_tank_item(itemStatsTbl) then
			if itemSubType==LK["Crossbow"] or itemSubType==LK["Bow"] or itemSubType==LK["Gun"] then
				tinsert(raidroles,{"WARRIOR",'tank'})
			else
				tinsert(raidroles,{"WARRIOR",'tank'})
				tinsert(raidroles,{"PALADIN",'tank'})
				tinsert(raidroles,{"DEATHKNIGHT",'tank','2'})
			end
		else
			if itemSubType==LK["Crossbow"] or itemSubType==LK["Bow"] or itemSubType==LK["Gun"] then
				tinsert(raidroles,{"HUNTER"})
				tinsert(raidroles,{"WARRIOR",'melee'})
				tinsert(raidroles,{"ROGUE"})
			elseif itemSubType==LK["Thrown"] then
				tinsert(raidroles,{"WARRIOR",'melee'})
				tinsert(raidroles,{"ROGUE"})
			elseif itemSubType==LK["Axe2H"] or itemSubType==LK["Mace2H"] or itemSubType==LK["Sword2H"] then
				tinsert(raidroles,{"DEATHKNIGHT",nil,1})
				tinsert(raidroles,{"DEATHKNIGHT",nil,3})
				tinsert(raidroles,{"WARRIOR",'melee'})
				tinsert(raidroles,{"PALADIN",'melee'})
			elseif itemSubType==LK["Wand"] then
				if is_SPD_SPIRIT_item(itemStatsTbl) then
					tinsert(raidroles,{"PRIEST",'healer'})
				elseif is_SPD_MP5_item(itemStatsTbl) then
					tinsert(raidroles,{"PRIEST",'healer'})
				elseif is_SPD_HIT_item(itemStatsTbl) then
					tinsert(raidroles,{"PRIEST",'caster'})
					tinsert(raidroles,{"WARLOCK"})
					tinsert(raidroles,{"MAGE"})
				else
					tinsert(raidroles,{"PRIEST"})
					tinsert(raidroles,{"WARLOCK"})
					tinsert(raidroles,{"MAGE"})
				end
			elseif itemSubType==LK["FistWeapon"] then
				tinsert(raidroles,{"SHAMAN",'melee'})
				tinsert(raidroles,{"HUNTER"})
			elseif itemSubType==LK["Axe1H"] or itemSubType==LK["Mace1H"] or itemSubType==LK["Sword1H"] then
				if is_caster_item(itemStatsTbl) then
					if itemSubType==LK["Mace1H"] then
						if is_SPD_SPIRIT_item(itemStatsTbl) then
							tinsert(raidroles,{"PRIEST",'healer'})
							tinsert(raidroles,{"DRUID",'healer'})
						elseif is_SPD_MP5_item(itemStatsTbl) then
							tinsert(raidroles,{"PRIEST",'healer'})
							tinsert(raidroles,{"DRUID",'healer'})
							tinsert(raidroles,{"PALADIN",'healer'})
							tinsert(raidroles,{"SHAMAN",'healer'})
						elseif is_SPD_HIT_item(itemStatsTbl) then
							tinsert(raidroles,{"PRIEST",'caster'})
							tinsert(raidroles,{"DRUID",'caster'})
							tinsert(raidroles,{"SHAMAN",'caster'})
						else
							tinsert(raidroles,{"PRIEST"})
							tinsert(raidroles,{"DRUID",'healer'})
							tinsert(raidroles,{"DRUID",'caster'})
							tinsert(raidroles,{"SHAMAN",'healer'})
							tinsert(raidroles,{"SHAMAN",'caster'})
							tinsert(raidroles,{"PALADIN",'healer'})
						end
					elseif itemSubType==LK["Sword1H"] then
						if is_SPD_MP5_item(itemStatsTbl) then
							tinsert(raidroles,{"PALADIN",'healer'})
						else
							tinsert(raidroles,{"PALADIN",'healer'})
							tinsert(raidroles,{"MAGE"})
							tinsert(raidroles,{"WARLOCK"})
						end
					end
				else
					local speed=get_1h_speed()
					if speed>=2.5 then
						tinsert(raidroles,{"WARRIOR",'tank'})
						tinsert(raidroles,{"PALADIN",'tank'})
						tinsert(raidroles,{"DEATHKNIGHT",'melee',2})
						if itemSubType==LK["Axe1H"] or itemSubType==LK["Mace1H"] then
							tinsert(raidroles,{"SHAMAN",'melee'})
						end
					end
					tinsert(raidroles,{"HUNTER"})
					tinsert(raidroles,{"ROGUE",nil,2})
				end
			elseif itemSubType==LK["Dagger"] then
				if is_caster_item(itemStatsTbl) then
					if is_SPD_SPIRIT_item(itemStatsTbl) then
						tinsert(raidroles,{"PRIEST",'healer'})
						tinsert(raidroles,{"DRUID",'healer'})
					elseif is_SPD_MP5_item(itemStatsTbl) then
						tinsert(raidroles,{"PRIEST",'healer'})
						tinsert(raidroles,{"DRUID",'healer'})
					elseif is_SPD_HIT_item(itemStatsTbl) then
						tinsert(raidroles,{"PRIEST",'caster'})
						tinsert(raidroles,{"DRUID",'caster'})
						tinsert(raidroles,{"MAGE"})
						tinsert(raidroles,{"WARLOCK"})
					else
						tinsert(raidroles,{"PRIEST"})
						tinsert(raidroles,{"DRUID",'healer'})
						tinsert(raidroles,{"DRUID",'caster'})
						tinsert(raidroles,{"MAGE"})
						tinsert(raidroles,{"WARLOCK"})
					end
				else
					tinsert(raidroles,{"ROGUE",nil,1})
				end
			elseif itemSubType==LK["Polearm"] then
				tinsert(raidroles,{"DRUID",'melee'})
				tinsert(raidroles,{"PALADIN",'melee'})
				tinsert(raidroles,{"HUNTER"})
			elseif itemSubType==LK["Staff"] then
				if is_caster_item(itemStatsTbl) then
					if is_SPD_SPIRIT_item(itemStatsTbl) then
						tinsert(raidroles,{"PRIEST",'healer',2})
					elseif is_SPD_MP5_item(itemStatsTbl) then
						tinsert(raidroles,{"DRUID",'healer'})
					elseif is_SPD_HIT_item(itemStatsTbl) then
						tinsert(raidroles,{"DRUID",'caster'})
						tinsert(raidroles,{"PRIEST",'caster'})
						tinsert(raidroles,{"SHAMAN",'caster'})
						tinsert(raidroles,{"MAGE"})
						tinsert(raidroles,{"WARLOCK"})
					else
						tinsert(raidroles,{"MAGE"})
						tinsert(raidroles,{"WARLOCK"})
						tinsert(raidroles,{"DRUID",'caster'})
						tinsert(raidroles,{"DRUID",'healer'})
						tinsert(raidroles,{"PRIEST",'caster'})
						tinsert(raidroles,{"PRIEST",'healer'})
						tinsert(raidroles,{"SHAMAN",'caster'})
						tinsert(raidroles,{"SHAMAN",'healer'})
					end
				else
					tinsert(raidroles,{"HUNTER"})
					tinsert(raidroles,{"DRUID",'melee'})
				end
			end
		end
	elseif itemType == LK["Armor"] then
		if itemSubType==LK["Shield"] then
			if is_caster_item(itemStatsTbl) then
				if is_SPD_SPIRIT_item(itemStatsTbl) then
					tinsert(raidroles,{"PALADIN",'healer'})
					tinsert(raidroles,{"SHAMAN",'healer'})
				elseif is_SPD_MP5_item(itemStatsTbl) then
					tinsert(raidroles,{"PALADIN",'healer'})
					tinsert(raidroles,{"SHAMAN",'healer'})
				elseif is_SPD_HIT_item(itemStatsTbl) then
					tinsert(raidroles,{"SHAMAN",'caster'})
				else
					tinsert(raidroles,{"PALADIN",'healer'})
					tinsert(raidroles,{"SHAMAN",'healer'})
					tinsert(raidroles,{"SHAMAN",'caster'})
				end
			else
				tinsert(raidroles,{"PALADIN",'tank'})
				tinsert(raidroles,{"WARRIOR",'tank'})
			end
		else
			if is_SPD_SPIRIT_item(itemStatsTbl) then
				tinsert(raidroles,{"PRIEST",'healer'})
				tinsert(raidroles,{"DRUID",'healer'})
			elseif is_SPD_MP5_item(itemStatsTbl) then
				tinsert(raidroles,{nil,'healer'})
			elseif is_SPD_HIT_item(itemStatsTbl) then
				tinsert(raidroles,{nil,'caster'})
			elseif is_caster_item(itemStatsTbl) then
				tinsert(raidroles,{nil,'healer'})
				tinsert(raidroles,{nil,'caster'})
			elseif is_tank_item(itemStatsTbl) then
				tinsert(raidroles,{nil,'tank'})
			elseif is_STR_item(itemStatsTbl) then
				if is_ARP_item then
					tinsert(raidroles,{'WARRIOR','melee'})
					tinsert(raidroles,{'DEATHKNIGHT','melee','1'})
					tinsert(raidroles,{'DEATHKNIGHT','melee','2'})
				
				else
					tinsert(raidroles,{'DEATHKNIGHT','melee','3'})
					tinsert(raidroles,{'PALADIN','melee'})
				end
				
			elseif is_AP_item(itemStatsTbl) then
					tinsert(raidroles,{'WARRIOR','melee'})
					tinsert(raidroles,{'DEATHKNIGHT','melee','1'})
					tinsert(raidroles,{'DEATHKNIGHT','melee','2'})
					tinsert(raidroles,{'PALADIN','melee'})
				tinsert(raidroles,{'ROGUE','melee'})
				tinsert(raidroles,{'HUNTER','melee'})
				tinsert(raidroles,{'SHAMAN','melee'})
				tinsert(raidroles,{'DRUID','melee'})
				tinsert(raidroles,{'DRUID','tank'})
			end
		end
	end

 

	tooltip:Hide()
end
local function Add_Check_Bid(value, name, isAllIn)
	
	local main
	local bank
	local altname
	
	if FEP_gMain[name] then
		local typ,ep,gp,_=DA.DecodeNote(FEP_gMain[name])
		if typ=='m' then
			main=name
			bank=ep
		elseif typ=='f' then
			if whisperssent[name] then
			else
				whisperssent[name]=true
				SendChatMessage(L['seems you got frozen epgp. Contact officer to fix it'], "whisper",nil,name)
			end
			return
		elseif typ=='t' then
			local typ_t,ep_t,gp_t,_=DA.DecodeNote(FEP_gMain[FEP_gMain[name]])
			if typ_t=='m' then
				main=FEP_gMain[name]
				bank=ep_t
			elseif typ_t=='f' then
				if whisperssent[name] then
				else
					whisperssent[name]=true
					SendChatMessage(L['seems your main got frozen epgp. Contact officer to fix it'], "whisper",nil,name)
				end
				return
			elseif typ_t=='t' then
				if whisperssent[name] then
				else
					whisperssent[name]=true
					SendChatMessage(L["seems you got incorrect officer note in guild (double tvin). Contact officer to fix it"], "whisper",nil,name)
				end
				return
			end
		end
		
	elseif FEP_L_gMain[DA_CurrentGuild][name] then
		if FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]] then
			local typ_t,ep_t,gp_t,_=DA.DecodeNote(FEP_gMain[FEP_L_gMain[DA_CurrentGuild][name]])
			if typ_t=='m' then
				main=FEP_L_gMain[DA_CurrentGuild][name]
				bank=ep_t
				altname=name
			elseif typ_t=='f' then
				if whisperssent[name] then
				else
					whisperssent[name]=true
					SendChatMessage(L['seems your main got frozen epgp. Contact officer to fix it'], "whisper",nil,name)
				end
				return
			elseif typ_t=='t' then
				if whisperssent[name] then
				else
					whisperssent[name]=true
					SendChatMessage(L["Broken local assignment. You can set your main via '?main <name>' command"], "whisper",nil,name)
				end
				return
			end
		else
			if whisperssent[name] then
			else
				whisperssent[name]=true
				SendChatMessage(L["corrupted local assign. The Old Buddy is back?"], "whisper",nil,name)
			end
			return
		end
	
	else
		if whisperssent[name] then
		else
			whisperssent[name]=true
			SendChatMessage(L["You are not in guild and not assigned. You can set your main via '?main <name>' command"], "whisper",nil,name)
		end
		
		return
	end
	
	if value and tonumber(value)==bank then
		isAllIn=true
	elseif not value and isAllIn then
		value = bank
	end
	
	value=tonumber(value)
	
	local TH=1
	local THM=1
	if not isAllIn and fuckingOptions_g[DA_CurrentGuild].auc_thousands and value<1000 then
		value=value*1000
		TH=1000
	elseif not isAllIn and fuckingOptions_g[DA_CurrentGuild].auc_thousands and value>=1000 then
		TH=1000
	end
	
	if not isAllIn and fuckingOptions_g[DA_CurrentGuild].auc_thousands and fuckingOptions_g[DA_CurrentGuild].auc_thousands_step then
		THM=1000
	end
	
	if value and value>=(fuckingOptions_g[DA_CurrentGuild].auc_minimal*TH) then
	else
		return
	end
	
	--filter same value bids
	for i, v in ipairs(DA_BidTracker.bidsession_roster) do
		if v[1] == value then
			return
		end
	end
	
	
	if bank<value then
		SendChatMessage(name.." "..L['You cannot afford such bid. Your current credit is'].." "..bank, "raid")
		return
	end
	
	
	
	local class
	for i=1,GetNumRaidMembers() do
		local nam, _, _, _, _, fileName, _, _, _, _, _ = GetRaidRosterInfo(i)
		if nam==name then
			class=fileName
			break
		end
	end
	local classCC=DA.GetClassColorCode(class)
	local usable=CanItemBeUsedByClass(DA_BidTracker.itemlink,class)
	
	local specname = select(1,LGT:GetUnitTalentSpec(name),1)
	local spec_a,spec_b,spec_c = LGT:GetTreeNames(class)
	local spec_ID = specname and ((spec_a and spec_a == specname and 1) or (spec_b and spec_b == specname and 2) or (spec_c and spec_c == specname and 3)) or nil
	local role=LGT:GetUnitRole(name)
	
	if DA_BidTracker.bidsession_roster[1] and value<DA_BidTracker.bidsession_roster[1][1] and fuckingOptions_g[DA_CurrentGuild].auc_allow_lower then
		-- not competive accepted
		table.insert(DA_BidTracker.bidsession_roster, 1, {value, name,bank,main,altname, class=class, classCC=classCC, usable=usable, role=role, spec_ID=spec_ID})
	elseif DA_BidTracker.bidsession_roster[1] and value<DA_BidTracker.bidsession_roster[1][1] then
		-- not competive discarded
		return
	else
		-- is competive
		if isAllIn then
			table.insert(DA_BidTracker.bidsession_roster, 1, {value, name,bank,main,altname, class=class, classCC=classCC, usable=usable, role=role, spec_ID=spec_ID})
			if fuckingOptions_g[DA_CurrentGuild].auc_bidconfirmed then
				SendChatMessage("["..value.."] "..name.."'s ALL IN accepted", "raid")
			end
		else
			for i=1,4 do
				if fuckingOptions_g[DA_CurrentGuild].aucoptsets[i] and fuckingOptions_g[DA_CurrentGuild].aucoptsets[i] and value<=(fuckingOptions_g[DA_CurrentGuild].aucoptsets[i][1]*TH) then
					if value%(fuckingOptions_g[DA_CurrentGuild].aucoptsets[i][2]*THM)==0 then
						--is multiplicable
						table.insert(DA_BidTracker.bidsession_roster, 1, {value, name,bank,main,altname, class=class, classCC=classCC, usable=usable, role=role, spec_ID=spec_ID})
						if fuckingOptions_g[DA_CurrentGuild].auc_bidconfirmed then
							SendChatMessage("["..value.."] "..name.."'s bid accepted", "raid")
						end
						break
					else
						SendChatMessage(name.." "..L['Your bid must be a multiple of'].." "..(fuckingOptions_g[DA_CurrentGuild].aucoptsets[i][2]*THM).." "..L['when placing bid up to'].." "..(fuckingOptions_g[DA_CurrentGuild].aucoptsets[i][1]*TH), "raid")
						if DA_BidTracker.timer+15<=time() then
							DA_BidTracker.timer=time()-15
							DA.ResumeTimer("itembidder")
						end
						return
					end
				elseif i==4 then
				
					if value%(fuckingOptions_g[DA_CurrentGuild].aucoptsets.lastincr*THM)==0 then
						--is multiplicable
						table.insert(DA_BidTracker.bidsession_roster, 1, {value, name,bank,main,altname, class=class, classCC=classCC, usable=usable, role=role, spec_ID=spec_ID})
						if fuckingOptions_g[DA_CurrentGuild].auc_bidconfirmed then
							SendChatMessage("["..value.."] "..name.."'s bid accepted", "raid")
						end
						break
					else
						if fuckingOptions_g[DA_CurrentGuild].aucoptsets[1] then
							SendChatMessage(name.." "..L['Your bid must be a multiple of'].." "..(fuckingOptions_g[DA_CurrentGuild].aucoptsets.lastincr*THM).." "..L['when placing bid higher than'].." "..(fuckingOptions_g[DA_CurrentGuild].aucoptsets[#fuckingOptions_g[DA_CurrentGuild].aucoptsets][1]*TH), "raid")
						else
							SendChatMessage(name.." "..L['Your bid must be a multiple of'].." "..(fuckingOptions_g[DA_CurrentGuild].aucoptsets.lastincr*THM), "raid")
						end
						if DA_BidTracker.timer+15<=time() then
							DA_BidTracker.timer=time()-15
							DA.ResumeTimer("itembidder")
						end
						return
					end
				end
			end
		end
	end
	
	if DA_BidTracker.timer+15<=time() then
		DA_BidTracker.timer=time()-15
		DA.ResumeTimer("itembidder")
	end
	
	
	
	table.sort(DA_BidTracker.bidsession_roster, function(a, b) return tonumber(a[1]) > tonumber(b[1]) end)
	
	
	if #DA_BidTracker.bidsession_roster > 9 then
		table.remove(DA_BidTracker.bidsession_roster)
	end
	
	for i=1,9 do
		if DA_BidTracker.bidsession_roster[i] then
			if DA_BidTracker.bidsession_roster[i].usable then
				if IsLootRoleMaches(DA_BidTracker.bidsession_roster[i].class,DA_BidTracker.bidsession_roster[i].role,DA_BidTracker.bidsession_roster[i].spec_ID) then
					DA_BidTracker['loot'..i]:SetText("|cff1ced93"..addspacestovalue(DA_BidTracker.bidsession_roster[i][1]).."  "..addspacestobank(DA_BidTracker.bidsession_roster[i][3]).."   "..DA_BidTracker.bidsession_roster[i].classCC..DA_BidTracker.bidsession_roster[i][2])
				else
					DA_BidTracker['loot'..i]:SetText(addspacestovalue(DA_BidTracker.bidsession_roster[i][1]).."  "..addspacestobank(DA_BidTracker.bidsession_roster[i][3]).."   "..DA_BidTracker.bidsession_roster[i].classCC..DA_BidTracker.bidsession_roster[i][2])
				end
			else
				DA_BidTracker['loot'..i]:SetText("|cff888888"..addspacestovalue(DA_BidTracker.bidsession_roster[i][1]).."  "..addspacestobank(DA_BidTracker.bidsession_roster[i][3]).."   "..DA_BidTracker.bidsession_roster[i].classCC..DA_BidTracker.bidsession_roster[i][2])
			end
			DA_BidTracker['loot'..i]:Show()
			DA_BidTracker['loot'..i]:SetScript("OnClick",function() 
				DA_BidTracker.winnerfont:SetText(DA_BidTracker.bidsession_roster[i][2])
				DA_BidTracker.pricebox:SetText(DA_BidTracker.bidsession_roster[i][1])
				DA_BidTracker.winnermain=DA_BidTracker.bidsession_roster[i][4] or nil
				DA_BidTracker.winneralt=DA_BidTracker.bidsession_roster[i][5] or nil
			end)
			DA_BidTracker['loot'..i].myID=i
			DA_BidTracker['loot'..i]:SetScript("OnEnter", function(self)
				self:RegisterEvent('MODIFIER_STATE_CHANGED')
				if IsShiftKeyDown() then
						GameTooltip:SetOwner(self,'ANCHOR_NONE')
						GameTooltip:SetPoint('topleft',self,'bottomleft',0,-5)
						GameTooltipTextLeft1:SetFont(UIDarkAngelFontConsolas:GetFont(), 10)
						GameTooltip:SetText(DA.GetTwinsInfo(DA_BidTracker.bidsession_roster[i][2],DA_BidTracker.bidsession_roster[i][4]),0.45,0.65,0.65,1)
						GameTooltip:Show()
				elseif not IsShiftKeyDown() and GameTooltip:IsShown() then
					DA.myHideTooltip()
				end
			end)
			DA_BidTracker['loot'..i]:SetScript("OnLeave", function(self)
				self:UnregisterEvent('MODIFIER_STATE_CHANGED')
				DA.myHideTooltip()
			end)
			DA_BidTracker['loot'..i]:SetScript("OnEvent", function(self)
				if self:IsVisible() and self:IsMouseOver() and GetMouseFocus().myID==self.myID then
					self:GetScript('OnEnter')(GetMouseFocus())
				end
			end)
			
		else
			DA_BidTracker['loot'..i]:SetText("")
			DA_BidTracker['loot'..i]:Hide()
		end
	end
end


DA_BidTracker.spendbutton=DA.CreateFFGButton2(nil,DA_BidTracker,{"center", DA_BidTracker, "TOPLEFT",113,-202},12,50,L["Spend"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function(self)
	self:Disable()
	local price=tonumber(DA_BidTracker.pricebox:GetText())
	local main=DA_BidTracker.winnermain
	local localTvin=DA_BidTracker.winneralt
	local item=DA_BidTracker.itemlink
	
	if main and main~="" then
		if price then
			DA.RegatherGuildNotes()
			DA_BidTracker.bidsession_active=false
			DA.StopTimer("itembidder")
			
			
			if DA_Guild_Info[DA_CurrentGuild].GuildType=='epgp' then
				tinsert(DA_Fep_bulk,function() 
					DA.EPawardfunc(main,-price,item,nil,localTvin,true)
					DA.AddRecentAward(main,"ep",-price,item)
				end)
				tinsert(DA_Fep_bulk,function() 
					self:Enable()
				end)
				DA.ResumeTimer('fep')
				return
			elseif DA_Guild_Info[DA_CurrentGuild].GuildType=='dkp' then
				tinsert(DA_Fep_bulk,function() 
					DA.DKPawardfunc(main,-price,item,nil,localTvin,true)
					DA.AddRecentAward(main,"-dkp",price,item)
				end)
				tinsert(DA_Fep_bulk,function() 
					self:Enable()
				end)
				DA.ResumeTimer('fep')
				return
			end
		else
			DA.Print(L["Fill in the price"])
			self:Enable()
			return
		end
	else
		DA.Print(L["Select winner"])
		self:Enable()
		return
	end
end)
DA_BidTracker.giveitembutton=DA.CreateFFGButton2(nil,DA_BidTracker,{"center", DA_BidTracker, "TOPLEFT",45,-202},12,70,L["Give item"],'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function()
	local item=DA_BidTracker.itemlink
	local player=DA_BidTracker.winnerfont:GetText()
	
	if not player then
		DA.Print(L["Select winner"])
		return
	end
	
	if item and player and player~="" and #player>0 then
	else --no player/item selected
		return
	end
	if GetNumLootItems() and GetNumLootItems()>0 then --DOING VIA ML LOOT
		
		local success=sendMLLootToPlayer(item,player)
		if success then
		else
			DA.Print(L["Item or player not found"])
		end
	else 
		
		if TradeFrame:IsShown() then
			for x=1,6 do
				local itemname,_,_,_,_=GetTradePlayerItemInfo(x)
				if itemname and item:find(itemname) then
					AcceptTrade()
					return
				end
			end
		end
		
		--lookup for the item in inventorty
		local b,s=checkTradingItemInInventory(item)
		if b and s then
		else
			DA.Print(L["Item not found"])
			return
		end
		if TradeFrame:IsShown() then --if trade window opened
			if TradeFrameRecipientNameText:GetText()==player then
				PickupContainerItem(b,s)
				ClickTradeButton(4)
			else
				CancelTrade()
				DA.Print("|cffff8888"..L["Trade window opened with wrong player!!!"].."|r")
			end
		else
			local playerID,isoffline=getPlayerRaidIdent(player)
			if isoffline then
				DA.Print("|cffff8888"..L["Needed player is offline"].."|r")
			elseif not playerID then
				DA.Print("|cffff8888"..L["Player not found"].."|r")
			elseif playerID then
				if CheckInteractDistance(playerID,2) then
					InitiateTrade(playerID)
					tinsert(DA_Fep_bulk,function() 
						if TradeFrame:IsShown() then
							PickupContainerItem(b,s);ClickTradeButton(4)
						else
							tinsert(DA_Fep_bulk,function() 
								if TradeFrame:IsShown() then
									PickupContainerItem(b,s);ClickTradeButton(4)
								else
									tinsert(DA_Fep_bulk,function() 
										if TradeFrame:IsShown() then
											PickupContainerItem(b,s);ClickTradeButton(4)
										else
											tinsert(DA_Fep_bulk,function() 
												if TradeFrame:IsShown() then
													PickupContainerItem(b,s);ClickTradeButton(4)
												end
											end)
										end
									end)
								end
							end)
						end
					end)
					DA.ResumeTimer('fep')
				else
					DA.Print("|cffff8888"..L["You are too far away from player"].."|r")
				end
			end
		end
	end
end)


DA_BidTracker:SetScript("OnEvent",function(self,event,message,author)
	if DA_BidTracker.working then
	else
		return
	end
	
	if event=="CHAT_MSG_RAID_WARNING" then
		local myname=GetUnitName("player")
		if author==myname or not fuckingOptions_g[DA_CurrentGuild].bidtracker_onlymine then
		else
			return
		end
		
		local itemLink=FindItemLink(message)
		if itemLink then
			Mod:start_new_bid_session(itemLink)
			return
		end
	else
		if self.bidsession_active then
			if fuckingOptions_g[DA_CurrentGuild].auc_allin and message=='all in' then
				Add_Check_Bid(nil,author,true)
			elseif message:match("^%d+$") then
				Add_Check_Bid(message:match("^%d+$"),author)
			end
		end
	end
end)

function Mod:OnInitialize()

	--item bidder
	DA.CreateTimer(nil,"itembidder",0,1,true,function(self)
		DA_BidTracker.timerfont:SetText(25+DA_BidTracker.timer-time())
		
		if DA_BidTracker.timer+25<=time() then
			DA_BidTracker.timerfont:SetText("0")
			self:SetScript("OnUpdate",nil)
			Mod:BidTimeOut()
			return
		elseif DA_BidTracker.timer+25-time()<6 then
			SendChatMessage(" -- "..(tostring(DA_BidTracker.timer+25-time()):match("%d+")).." -- ",'raid')
		end
	end)  
	
end

function Mod:OnEnable()
	DA_BidTracker:SetScale(fuckingOptions.BidTrackerScale)
	
	for item,itemIDToFetch in pairs(item_IDs_roster) do
		QueueItemForCache(itemIDToFetch)
	end
	if UISpecialFrames then 
		tinsert(UISpecialFrames, "DA_BidTracker")
	end
	DA:ModuleLoaded("BidTracker")
end




function Mod:OnGuildLoad()
	self:BidTracker_Load()
	self:UpdateStateEvents()
end

function Mod:UpdateStateEvents()
	if fuckingOptions_g[DA_CurrentGuild].bidtracker then
		DA_BidTracker.working=true
		DA_BidTracker:RegisterEvent("CHAT_MSG_RAID")
		DA_BidTracker:RegisterEvent("CHAT_MSG_RAID_WARNING")
		DA_BidTracker:RegisterEvent("CHAT_MSG_RAID_LEADER")
		
	else
		DA_BidTracker.working=false
		DA_BidTracker:UnregisterEvent("CHAT_MSG_RAID")
		DA_BidTracker:UnregisterEvent("CHAT_MSG_RAID_WARNING")
		DA_BidTracker:UnregisterEvent("CHAT_MSG_RAID_LEADER")
	end
end

function Mod:BidTimeOut()
	if DA_BidTracker.bidsession_roster[1] then
		DA_BidTracker.winnerfont:SetText(DA_BidTracker.bidsession_roster[1][2])
		DA_BidTracker.pricebox:SetText(DA_BidTracker.bidsession_roster[1][1])
		
		
		SendChatMessage(L["Time is up!"].." "..DA_BidTracker.bidsession_roster[1][2].." "..L["wins"].." "..DA_BidTracker.itemlink.."! "..L["Bet"]..": "..DA_BidTracker.bidsession_roster[1][1],'raid')
		DA_BidTracker.bidsession_active=false
		
		DA_BidTracker.winnerfont:SetText(DA_BidTracker.bidsession_roster[1][2])
		DA_BidTracker.pricebox:SetText(DA_BidTracker.bidsession_roster[1][1])
		DA_BidTracker.winnermain=DA_BidTracker.bidsession_roster[1][4] or nil
		DA_BidTracker.winneralt=DA_BidTracker.bidsession_roster[1][5] or nil
	else
		SendChatMessage(L["Time is up!"].." "..L["No bids for"].." "..DA_BidTracker.itemlink.."!",'raid')
		DA_BidTracker.bidsession_active=false
		DA_BidTracker.winnerfont:SetText("")
		DA_BidTracker.pricebox:SetText("1")
		DA_BidTracker.winnermain=nil
		DA_BidTracker.winneralt=nil
	end
end

function Mod:start_new_bid_session(itemLink)
	local _, _, itemRarity, _, _, itemType, itemSubType, _, _, itemTexture, _ = GetItemInfo(itemLink)
	local itemID = tonumber(itemLink:match("item:(%d+)") or 0)
	local icon=GetItemIcon(itemLink)
	DA_BidTracker.itemicon:GetNormalTexture():SetTexture(itemTexture or icon)
	DA_BidTracker.itemicon:GetPushedTexture():SetTexture(itemTexture or icon)
	
	DA_BidTracker.itemicon:SetScript("OnEnter", function(self)
		if (itemLink or itemID) and DA_BidTracker.itemfont:GetText() and DA_BidTracker.itemfont:GetText()~="" and #DA_BidTracker.itemfont:GetText()>0 then
			GameTooltip:SetOwner(self,'ANCHOR_CURSOR')
			GameTooltip:SetHyperlink(itemLink or "\124cffffffff\124Hitem:"..itemID.."::::::::70:::::\124h[loading data]\124h\124r")
			GameTooltip:Show()
		else
			GameTooltip:Hide()
		end
	end)
	DA_BidTracker.itemicon:SetScript("OnLeave", function()
		DA.myHideTooltip()
	end)
	
	DA_BidTracker.itemfont:SetText(itemLink)
	for i=1,9 do
		DA_BidTracker['loot'..i]:SetText("")
		DA_BidTracker['loot'..i]:Hide()
	end
	DA_BidTracker.bidsession_active=true
	DA_BidTracker.bidsession_roster=nil
	DA_BidTracker.bidsession_roster={}
	DA_BidTracker:Show()
	DA_BidTracker.timer=time()
	DA_BidTracker.itemlink=itemLink
	DA_BidTracker.rosterRaidRoles={}
	
	
	DetermineLootRolesForItem(itemLink, itemType, itemSubType, itemID)
	
	
	if RaidRoll_DB and fuckingOptions_g[DA_CurrentGuild].auc_RR_hide then
		RR_RollFrame:Hide()
	end
	DA_BidTracker.winnerfont:SetText("")
	DA_BidTracker.pricebox:SetText("1")
	DA_BidTracker.winnermain=nil
	DA_BidTracker.winneralt=nil
	DA.ResumeTimer("itembidder")
	if DA_BidTracker.itemicon:IsMouseOver() and (itemLink or itemID) and DA_BidTracker.itemfont:GetText() and DA_BidTracker.itemfont:GetText()~="" and #DA_BidTracker.itemfont:GetText()>0 then
		GameTooltip:SetOwner(DA_BidTracker.itemicon,'ANCHOR_CURSOR')
		GameTooltip:SetHyperlink(itemLink or "\124cffffffff\124Hitem:"..itemID.."::::::::70:::::\124h[loading data]\124h\124r")
		GameTooltip:Show()
	end
end

function Mod:BidTracker_Load()
	
	local re_render_auc_opt
	local function resort_and_rerender_auc_saves()
		table.sort(fuckingOptions_g[DA_CurrentGuild].aucoptsets,function(a,b) return a[1]<b[1] end)
		re_render_auc_opt()
	end
	local function auc_eb(self, i) 
		if not tonumber(self:GetText()) or tonumber(self:GetText())<1 then
			self:SetText(self.stored)
			self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
			return
		end
		if tonumber(self:GetText()) then
			for r=1,4 do
				if fuckingOptions_g[DA_CurrentGuild].aucoptsets[r] then
					if fuckingOptions_g[DA_CurrentGuild].aucoptsets[r][1]==tonumber(self:GetText()) then
						self:SetText(self.stored)
						self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
						return
					elseif r<i and fuckingOptions_g[DA_CurrentGuild].aucoptsets[r][1]>tonumber(self:GetText()) then
						fuckingOptions_g[DA_CurrentGuild].aucoptsets[i][1]=tonumber(self:GetText())
						self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
						resort_and_rerender_auc_saves()
						return
					elseif r>i and fuckingOptions_g[DA_CurrentGuild].aucoptsets[r][1]<tonumber(self:GetText()) then
						fuckingOptions_g[DA_CurrentGuild].aucoptsets[i][1]=tonumber(self:GetText())
						self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
						resort_and_rerender_auc_saves()
						return
					end
				end
			end
			
		end
		fuckingOptions_g[DA_CurrentGuild].aucoptsets[i][1]=tonumber(self:GetText())
		self.stored=tonumber(self:GetText())
		self.focusgained=nil;self:ClearFocus();self.t:SetBlendMode("add")
	end
	
	function re_render_auc_opt()
			
		for i=1,4 do
			if fuckingOptions_g[DA_CurrentGuild].aucoptsets[i] then
				DA_BidTracker.OptionsFr['opt'..i].del:SetScript("OnClick",function(self) table.remove(fuckingOptions_g[DA_CurrentGuild].aucoptsets,i);resort_and_rerender_auc_saves() end)
				
				DA_BidTracker.OptionsFr['opt'..i].bidincr:SetText(fuckingOptions_g[DA_CurrentGuild].aucoptsets[i][2])
				
				DA_BidTracker.OptionsFr['opt'..i].bidlimit:SetText(fuckingOptions_g[DA_CurrentGuild].aucoptsets[i][1])
				DA_BidTracker.OptionsFr['opt'..i].bidlimit:SetScript("OnEscapePressed",function(self) auc_eb(self, i) end)	
				DA_BidTracker.OptionsFr['opt'..i].bidlimit:SetScript("OnEnterPressed",function(self) auc_eb(self, i) end)		
				DA_BidTracker.OptionsFr['opt'..i].bidlimit:SetScript("OnEditFocusLost",function(self) auc_eb(self, i) end)
				
				DA_BidTracker.OptionsFr['opt'..i]:Show()
			else
				DA_BidTracker.OptionsFr['opt'..i]:Hide()
			end
		
		end
		DA_BidTracker.OptionsFr.optlast.bidincr:SetText(fuckingOptions_g[DA_CurrentGuild].aucoptsets.lastincr)
		
		if #fuckingOptions_g[DA_CurrentGuild].aucoptsets<4 then
			DA_BidTracker.OptionsFr.BSC.add:Show()
		else
			DA_BidTracker.OptionsFr.BSC.add:Hide()
		end
	
	end
	DA_BidTracker.OptionsFr=DA.FrameCreater(nil,DA_BidTracker,150,213,{"TOPLEFT", DA_BidTracker, "TOPRIGHT", 3, 0})
	DA.CloseButtonCreater(nil,DA_BidTracker.OptionsFr,{"TOPRIGHT", DA_BidTracker.OptionsFr, "TOPRIGHT", -2,-1},10,10,'x')
	
	DA.OptionsButtonCreater(nil,DA_BidTracker,{"center", DA_BidTracker, "TOPRIGHT", -8.5,-22},15,15,function(self)
		if DA_BidTracker.OptionsFr:IsShown() then
			DA_BidTracker.OptionsFr:Hide()
		else
			DA_BidTracker.OptionsFr:Show()
		end
	end)
	
	DA.EditBoxCreater2(nil,DA_BidTracker.OptionsFr,{"LEFT",DA_BidTracker.OptionsFr,"TOPLEFT",5,-10},{50,12},fuckingOptions_g[DA_CurrentGuild].auc_minimal,nil,nil,{"Fonts\\FRIZQT__.TTF", 10, "OUTLINE"},{"fuckingOptions_g","auc_minimal",'DA_CurrentGuild'},1,nil,true,"minimal bid")
	
	
	DA_BidTracker.OptionsFr.BSC=DA.FrameCreater(nil,DA_BidTracker.OptionsFr,DA_BidTracker.OptionsFr.width-10,104,{"TOPLEFT", DA_BidTracker.OptionsFr, "TOPLEFT", 5, -68})
	DA_BidTracker.OptionsFr.BSC:Show()
		DA_BidTracker.OptionsFr.BSC.add=DA.CreateFFGButton2(nil,DA_BidTracker.OptionsFr.BSC,{"center", DA_BidTracker.OptionsFr.BSC, "TOPLEFT",15,-17},10,14,"+",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function(self) 
			if #fuckingOptions_g[DA_CurrentGuild].aucoptsets<4 then
				if not fuckingOptions_g[DA_CurrentGuild].aucoptsets[1] then
					tinsert(fuckingOptions_g[DA_CurrentGuild].aucoptsets,{10 , 1})
				else
					tinsert(fuckingOptions_g[DA_CurrentGuild].aucoptsets,{fuckingOptions_g[DA_CurrentGuild].aucoptsets[#fuckingOptions_g[DA_CurrentGuild].aucoptsets][1]+10 , fuckingOptions_g[DA_CurrentGuild].aucoptsets[#fuckingOptions_g[DA_CurrentGuild].aucoptsets][2]})
				end
			end
			resort_and_rerender_auc_saves()
		end)
	DA.FontCreater(nil,L["Bid raise settings"],{"LEFT",DA_BidTracker.OptionsFr.BSC,"TOPLEFT",5,-5},DA_BidTracker.OptionsFr.BSC,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
	
	DA.FontCreater(nil,L["Bound"],{"LEFT",DA_BidTracker.OptionsFr.BSC,"TOPLEFT",32,-17},DA_BidTracker.OptionsFr.BSC,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
	DA.FontCreater(nil,L["Step"],{"LEFT",DA_BidTracker.OptionsFr.BSC,"TOPLEFT",77,-17},DA_BidTracker.OptionsFr.BSC,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
	ZXCZESFXCZx=DA.HelpCreater(DA_BidTracker.OptionsFr.BSC,{"CENTER",DA_BidTracker.OptionsFr.BSC,"TOPLEFT",125,-12},'LootTrackerOptHelp',12,12)
	ZXCZESFXCZ=DA.HelpCreater(DA_BidTracker.OptionsFr,{"CENTER",DA_BidTracker.OptionsFr,"TOPLEFT",125,-12},'auc_classspecinf',12,12)
	
	local increments = {
		[1] = 5,
		[5] = 10,
		[10] = 20,
		[20] = 25,
		[25] = 50,
		[50] = 100,
		[100] = 200,
		[200] = 250,
		[250] = 500,
		[500] = 1000,
		[1000] = 1
	}
	for i=1,4 do
		DA_BidTracker.OptionsFr['opt'..i]=DA.FrameCreater(nil,DA_BidTracker.OptionsFr.BSC,DA_BidTracker.OptionsFr.BSC.width-5,15,{"TOPLEFT", DA_BidTracker.OptionsFr.BSC, "TOPLEFT", 2.5, -6-16*i})
		
		DA_BidTracker.OptionsFr['opt'..i].del=DA.CreateFFGButton2(nil,DA_BidTracker.OptionsFr['opt'..i],{"center", DA_BidTracker.OptionsFr['opt'..i], "LEFT",12,0},10,15,"x",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Red',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function() end)
		DA_BidTracker.OptionsFr['opt'..i].bidlimit=DA.EditBoxCreater2(nil,DA_BidTracker.OptionsFr['opt'..i],{"LEFT", DA_BidTracker.OptionsFr['opt'..i], "LEFT",30,0},{35,12},"",false,false,{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},nil,1,nil,true)
		DA_BidTracker.OptionsFr['opt'..i].bidincr=DA.CreateFFGButton2(nil,DA_BidTracker.OptionsFr['opt'..i],{"center", DA_BidTracker.OptionsFr['opt'..i], "LEFT",85,0},12,30,"",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function(self) 
			local newValue = increments[tonumber(self:GetText())]
			if newValue then
				fuckingOptions_g[DA_CurrentGuild].aucoptsets[i][2] = newValue
			end
			re_render_auc_opt()
		end)
	end
	DA_BidTracker.OptionsFr.optlast=DA.FrameCreater(nil,DA_BidTracker.OptionsFr.BSC,DA_BidTracker.OptionsFr.BSC.width-5,15,{"TOPLEFT", DA_BidTracker.OptionsFr.BSC, "TOPLEFT", 2.5, -86})
	DA_BidTracker.OptionsFr.optlast:Show()
	DA.FontCreater(nil,"Any higher",{"LEFT",DA_BidTracker.OptionsFr.optlast,"LEFT",5,0},DA_BidTracker.OptionsFr.optlast,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
	DA_BidTracker.OptionsFr.optlast.bidincr=DA.CreateFFGButton2(nil,DA_BidTracker.OptionsFr.optlast,{"center", DA_BidTracker.OptionsFr.optlast, "LEFT",80,0},12,20,"",'Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up',{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},function(self) 
		local newValue = increments[tonumber(self:GetText())]
		if newValue then
			fuckingOptions_g[DA_CurrentGuild].aucoptsets.lastincr = newValue
		end
		re_render_auc_opt()
	end)
	
	DA.CheckBtnCreater(nil,DA_BidTracker.OptionsFr,{"CENTER",DA_BidTracker.OptionsFr,"TOPLEFT",11,-28},15,15,'Allow lower bids',function(self) fuckingOptions_g[DA_CurrentGuild].auc_allow_lower=(self:GetChecked() or false) end,{'fuckingOptions_g','auc_allow_lower','DA_CurrentGuild'},'auc_allow_lower')
	
	DA.CheckBtnCreater(nil,DA_BidTracker.OptionsFr,{"CENTER",DA_BidTracker.OptionsFr,"TOPLEFT",11,-43},15,15,'Bids in thousands',function(self) fuckingOptions_g[DA_CurrentGuild].auc_thousands=(self:GetChecked() or false) end,{'fuckingOptions_g','auc_thousands','DA_CurrentGuild'},'auc_thousands')
	
	DA.CheckBtnCreater(nil,DA_BidTracker.OptionsFr,{"CENTER",DA_BidTracker.OptionsFr,"TOPLEFT",18,-58},15,15,L["Step in thousands"],function(self) fuckingOptions_g[DA_CurrentGuild].auc_thousands_step=(self:GetChecked() or false) end,{'fuckingOptions_g','auc_thousands_step','DA_CurrentGuild'})

	if RaidRoll_DB then
		DA.CheckBtnCreater(nil,DA_BidTracker.OptionsFr,{"CENTER",DA_BidTracker.OptionsFr,"TOPLEFT",11,-180},15,15,HIDE.." ".."RaidRoll",function(self) fuckingOptions_g[DA_CurrentGuild].auc_RR_hide=(self:GetChecked() or false) end,{'fuckingOptions_g','auc_RR_hide','DA_CurrentGuild'},'auc_RR_hide')
		
		hooksecurefunc('RR_ARollHasOccured',function() if fuckingOptions_g[DA_CurrentGuild].auc_RR_hide and DA_BidTracker.bidsession_active then RR_RollFrame:Show() end end)
		hooksecurefunc('RR_Display',function() if fuckingOptions_g[DA_CurrentGuild].auc_RR_hide and DA_BidTracker.bidsession_active then RR_RollFrame:Hide() end end)
	end
	DA.CheckBtnCreater(nil,DA_BidTracker.OptionsFr,{"CENTER",DA_BidTracker.OptionsFr,"TOPLEFT",11,-192},15,15,L["Allow 'all in'"],function(self) fuckingOptions_g[DA_CurrentGuild].auc_allin=(self:GetChecked() or false) end,{'fuckingOptions_g','auc_allin','DA_CurrentGuild'},'auc_allin')
	DA.CheckBtnCreater(nil,DA_BidTracker.OptionsFr,{"CENTER",DA_BidTracker.OptionsFr,"TOPLEFT",11,-204},15,15,L["'Bid confirmed' message"],function(self) fuckingOptions_g[DA_CurrentGuild].auc_bidconfirmed=(self:GetChecked() or false) end,{'fuckingOptions_g','auc_bidconfirmed','DA_CurrentGuild'},'auc_bidconfirmed')
		
	resort_and_rerender_auc_saves()
	

end


function Mod:AddModOptions(modOptTable)
	local f = DA.FrameCreater(nil,DarkAngelopt.scrollchild,154,50)
	f:Show()
	tinsert(modOptTable, {'BidTracker',f})	
	
	DA.FontCreater(nil,"BidTracker",{"LEFT",f,"TOPLEFT",5,-6},f,15,180,{UIDarkAngelFontConsolas:GetFont(), 8, "OUTLINE"},'left')
	
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",15,-20},15,15,L['ep-auc/dkp bid tracker'],function(self) fuckingOptions_g[DA_CurrentGuild].bidtracker=(self:GetChecked() or false);Mod:UpdateStateEvents() end,{'fuckingOptions_g','bidtracker','DA_CurrentGuild'},'bidtracker')
	DA.CheckBtnCreater(nil,f,{"CENTER",f,"TOPLEFT",25,-30},15,15,L['only mine'],function(self) fuckingOptions_g[DA_CurrentGuild].bidtracker_onlymine=(self:GetChecked() or false) end,{'fuckingOptions_g','bidtracker_onlymine','DA_CurrentGuild'},nil)
	
	DA.CreateFFGButton2(nil,f,{"center", f, "TOPLEFT", 25,-41},10,30,'open','Interface\\AddOns\\DarkAngel\\template\\UI-Panel-Button-Up_Black.blp',{UIDarkAngelFontConsolas:GetFont(), 9, "OUTLINE"},function(self)
		local obj = DarkAngelopt.scrollchild.addbinds_ch.font
		local function colorChange_animate(colA, colB, colC)
			if colA and colB and colC then
				tinsert(DA_Fep_bulk, function() 
					obj:SetTextColor(colA, colB, colC, 1)
				end)
			end
			
		end
		for i=1,20 do
			if i==20 then
				break
			else
				local a = math.random(100)/100
				local b = math.random(100)/100
				local c = math.random(100)/100
				
				colorChange_animate(a,b,c)
			end
				
		end	
		
		colorChange_animate(0.85, 1, 1, 1)
		DA.ResumeTimer('fep')
		
	end,'bt_open')
end
