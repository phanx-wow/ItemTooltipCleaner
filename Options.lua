--[[--------------------------------------------------------------------
	Item Tooltip Cleaner
	Removes extraneous lines from item tooltips.
	Copyright (c) 2010-2011 Akkorian <akkorian@armord.net>
	Copyright (c) 2011-2016 Phanx <addons@phanx.net>
	All rights reserved. See LICENSE.txt for more info.
	https://github.com/Phanx/ItemTooltipCleaner
	https://mods.curse.com/addons/wow/itemtooltipcleaner
	http://www.wowinterface.com/addons/info19129-ItemTooltipCleaner.html
----------------------------------------------------------------------]]

local ADDON_NAME, namespace = ...

local panel = LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME, nil, function(self)
	local db = ItemTooltipCleanerSettings
	local L = namespace.L
	local GAP, BIGGAP = 8, 42

	local title, notes = self:CreateHeader(ADDON_NAME, L.HIDE)


	local colorBonus = self:CreateColorPicker(L.BONUS_COLOR)
	colorBonus:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -GAP)
	function colorBonus:GetValue()
		return unpack(db.bonusColor)
	end
	function colorBonus:OnValueChanged(r, g, b)
		db.bonusColor[1] = r
		db.bonusColor[2] = g
		db.bonusColor[3] = b
		wipe(namespace.cache)
	end

	local colorEnchant = self:CreateColorPicker(L.ENCHANT_COLOR)
	colorEnchant:SetPoint("TOPLEFT", colorBonus, "BOTTOMLEFT", 0, -GAP)
	function colorEnchant:GetValue()
		return unpack(db.enchantColor)
	end
	function colorEnchant:OnValueChanged(r, g, b)
		db.enchantColor[1] = r
		db.enchantColor[2] = g
		db.enchantColor[3] = b
		wipe(namespace.cache)
	end


	local checks = {}
	local function OnValueChanged(this, checked)
		db[this.key] = checked
		wipe(namespace.cache)
		for _, other in pairs(checks) do
			if other.parent == this then
				other:SetEnabled(checked)
			end
		end
	end


	local checkBlank = self:CreateCheckbox(L.HIDE_BLANK)
	checkBlank:SetPoint("TOPLEFT", colorEnchant, "BOTTOMLEFT", 0, -BIGGAP)
	checkBlank.key = "hideBlank"
	tinsert(checks, checkBlank)

	local checkDifficulty = self:CreateCheckbox(format(L.HIDE_DIFFICULTY))
	checkDifficulty:SetPoint("TOPLEFT", checkBlank, "BOTTOMLEFT", 0, -GAP)
	checkDifficulty.key = "hideRaidDifficulty"
	tinsert(checks, checkDifficulty)

	local checkDurability = self:CreateCheckbox(L.HIDE_DURABILITY)
	checkDurability:SetPoint("TOPLEFT", checkDifficulty, "BOTTOMLEFT", 0, -GAP)
	checkDurability.key = "hideDurability"
	tinsert(checks, checkDurability)

	local checkILevel = self:CreateCheckbox(L.HIDE_ILEVEL)
	checkILevel:SetPoint("TOPLEFT", checkDurability, "BOTTOMLEFT", 0, -GAP)
	checkILevel.key = "hideItemLevel"
	tinsert(checks, checkILevel)
	
	local checkUnused = self:CreateCheckbox(L.HIDE_UNUSED)
	checkUnused:SetPoint("TOPLEFT", checkILevel, "BOTTOMLEFT", 0, -GAP)
	checkUnused.key = "hideUnusedStats"
	tinsert(checks, checkUnused)

	local checkUpgrade = self:CreateCheckbox(L.HIDE_UPGRADE)
	checkUpgrade:SetPoint("TOPLEFT", checkUnused, "BOTTOMLEFT", 0, -GAP)
	checkUpgrade.key = "hideUpgradeLevel"
	tinsert(checks, checkUpgrade)

	local checkCraftingReagent = self:CreateCheckbox(format(L.HIDE_TAG, PROFESSIONS_USED_IN_COOKING))
	checkCraftingReagent:SetPoint("TOPLEFT", checkUpgrade, "BOTTOMLEFT", 0, -GAP)
	checkCraftingReagent.key = "hideCraftingReagent"
	tinsert(checks, checkCraftingReagent)

	local checkEnchantLabel = self:CreateCheckbox(format(L.HIDE_TAG, strmatch(ENCHANTED_TOOLTIP_LINE, "[^:]+")))
	checkEnchantLabel:SetPoint("TOPLEFT", checkCraftingReagent, "BOTTOMLEFT", 0, -GAP)
	checkEnchantLabel.key = "hideEnchantLabel"
	tinsert(checks, checkEnchantLabel)

	local checkMadeBy = self:CreateCheckbox(format(L.HIDE_TAG, L.MADE_BY))
	checkMadeBy:SetPoint("TOPLEFT", checkEnchantLabel, "BOTTOMLEFT", 0, -GAP)
	checkMadeBy.key = "hideMadeBy"
	tinsert(checks, checkMadeBy)

	local checkSoulbound = self:CreateCheckbox(format(L.HIDE_TAG, ITEM_SOULBOUND))
	checkSoulbound:SetPoint("TOPLEFT", checkMadeBy, "BOTTOMLEFT", 0, -GAP)
	checkSoulbound.key = "hideSoulbound"
	tinsert(checks, checkSoulbound)

	local checkUnique = self:CreateCheckbox(format(L.HIDE_TAG, ITEM_UNIQUE))
	checkUnique:SetPoint("TOPLEFT", checkSoulbound, "BOTTOMLEFT", 0, -GAP)
	checkUnique.key = "hideUnique"
	tinsert(checks, checkUnique)



	local checkEquipSets = self:CreateCheckbox(L.HIDE_EQUIPSETS, L.HIDE_EQUIPSETS_TIP)
	checkEquipSets:SetPoint("TOPLEFT", notes, "BOTTOM", 0, -GAP)
	function checkEquipSets:OnValueChanged(checked)
		SetCVar("dontShowEquipmentSetsOnItems", checked and "1" or "0")
		wipe(namespace.cache)
	end

	local checkSetBonuses = self:CreateCheckbox(L.HIDE_SETBONUS)
	checkSetBonuses:SetPoint("TOPLEFT", checkEquipSets, "BOTTOMLEFT", 0, -GAP)
	checkSetBonuses.key = "hideSetBonuses"
	tinsert(checks, checkSetBonuses)

	local checkSetItems = self:CreateCheckbox(L.HIDE_SETLIST)
	checkSetItems:SetPoint("TOPLEFT", checkSetBonuses, "BOTTOMLEFT", 0, -GAP)
	checkSetItems.key = "hideSetItems"
	tinsert(checks, checkSetItems)

	local checkBuy = self:CreateCheckbox(L.HIDE_CLICKBUY)
	checkBuy:SetPoint("TOPLEFT", checkSetItems, "BOTTOMLEFT", 0, -GAP)
	checkBuy.key = "hideRightClickBuy"
	tinsert(checks, checkBuy)

	local checkSocket = self:CreateCheckbox(L.HIDE_CLICKSOCKET)
	checkSocket:SetPoint("TOPLEFT", checkBuy, "BOTTOMLEFT", 0, -GAP)
	checkSocket.key = "hideRightClickSocket"
	tinsert(checks, checkSocket)

	local checkValue = self:CreateCheckbox(L.HIDE_VALUE, L.HIDE_VALUE_TIP)
	checkValue:SetPoint("TOPLEFT", checkSocket, "BOTTOMLEFT", 0, -GAP)
	checkValue.key = "hideSellValue"
	tinsert(checks, checkValue)



	local checkReqs = self:CreateCheckbox(L.HIDE_REQUIREMENTS, L.HIDE_REQUIREMENTS_TIP)
	checkReqs:SetPoint("TOPLEFT", checkValue, "BOTTOMLEFT", 0, -GAP)
	checkReqs.key = "hideRequirements"
	tinsert(checks, checkReqs)

		local checkReqsMet = self:CreateCheckbox(L.HIDE_REQUIREMENTS_MET)
		checkReqsMet:SetPoint("TOPLEFT", checkReqs, "BOTTOMLEFT", 26, -GAP)
		checkReqsMet.key = "hideRequirementsMetOnly"
		checkReqsMet.parent = checkReqs
		tinsert(checks, checkReqsMet)

	local checkTransmog = self:CreateCheckbox(L.HIDE_TRANSMOG)
	checkTransmog:SetPoint("TOPLEFT", checkReqsMet, "BOTTOMLEFT", -26, -GAP)
	checkTransmog.key = "hideTransmog"
	tinsert(checks, checkTransmog)

		local checkTransmogLabel = self:CreateCheckbox(L.HIDE_TRANSMOG_LABEL, L.HIDE_TRANSMOG_LABEL_TIP)
		checkTransmogLabel:SetPoint("TOPLEFT", checkTransmog, "BOTTOMLEFT", 26, -GAP)
		checkTransmogLabel.key = "hideTransmogLabelOnly"
		checkTransmogLabel.parent = checkTransmog
		tinsert(checks, checkTransmogLabel)

	local checkAppearanceKnown = self:CreateCheckbox(L.HIDE_APPEARANCE_KNOWN)
	checkAppearanceKnown:SetPoint("TOPLEFT", checkTransmogLabel, "BOTTOMLEFT", -26, -GAP)
	checkAppearanceKnown.key = "hideAppearanceKnown"
	tinsert(checks, checkAppearanceKnown)

	local checkAppearanceUnknown = self:CreateCheckbox(L.HIDE_APPEARANCE_UNKNOWN)
	checkAppearanceUnknown:SetPoint("TOPLEFT", checkAppearanceKnown, "BOTTOMLEFT", 0, -GAP)
	checkAppearanceUnknown.key = "hideAppearanceUnknown"
	tinsert(checks, checkAppearanceUnknown)

	local checkFlavor = self:CreateCheckbox(L.HIDE_FLAVOR, L.HIDE_FLAVOR_TIP)
	checkFlavor:SetPoint("TOPLEFT", checkAppearanceUnknown, "BOTTOMLEFT", 0, -GAP)
	checkFlavor.key = "hideFlavor"
	tinsert(checks, checkFlavor)

		local checkFlavorTrade = self:CreateCheckbox(L.HIDE_FLAVOR_TRADE, L.HIDE_FLAVOR_TRADE_TIP)
		checkFlavorTrade:SetPoint("TOPLEFT", checkFlavor, "BOTTOMLEFT", 26, -GAP)
		checkFlavorTrade.key = "hideFlavorTrade"
		checkFlavorTrade.parent = checkFlavor
		tinsert(checks, checkFlavorTrade)


	for _, check in pairs(checks) do
		if not check.OnValueChanged then
			check.OnValueChanged = OnValueChanged
		end
	end


	self.refresh = function(self)
		colorBonus:SetValue(unpack(db.bonusColor))
		colorEnchant:SetValue(unpack(db.enchantColor))

		for _, check in pairs(checks) do
			check:SetChecked(db[check.key])
			if check.parent then
				check:SetEnabled(db[check.parent.key])
			end
		end

		checkEquipSets:SetChecked(GetCVarBool("dontShowEquipmentSetsOnItems"))
	end
end)

SLASH_ITEMTOOLTIPCLEANER1 = "/itc"
SlashCmdList["ITEMTOOLTIPCLEANER"] = function() InterfaceOptionsFrame_OpenToCategory(panel) end
