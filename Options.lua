--[[--------------------------------------------------------------------
	Item Tooltip Cleaner
	Removes extraneous lines from item tooltips.
	Copyright (c) 2010-2011 Akkorian <akkorian@hotmail.com>
	Copyright (c) 2011-2015 Phanx <addons@phanx.net>. All rights reserved.
	http://www.wowinterface.com/addons/info19129-ItemTooltipCleaner.html
	http://www.curse.com/addons/wow/itemtooltipcleaner
	https://github.com/Phanx/ItemTooltipCleaner
----------------------------------------------------------------------]]

local ADDON_NAME, namespace = ...

local panel = LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME, nil, function(self)
	local db = ItemTooltipCleanerSettings
	local L = namespace.L
	local GAP, BIGGAP = 8, 32

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
	checkBlank.OnValueChanged = OnValueChanged
	checkBlank.key = "hideBlank"
	tinsert(checks, checkBlank)

	local checkDifficulty = self:CreateCheckbox(format(L.HIDE_DIFFICULTY))
	checkDifficulty:SetPoint("TOPLEFT", checkBlank, "BOTTOMLEFT", 0, -GAP)
	checkDifficulty.OnValueChanged = OnValueChanged
	checkDifficulty.key = "hideRaidDifficulty"
	tinsert(checks, checkDifficulty)

	local checkDurability = self:CreateCheckbox(L.HIDE_DURABILITY)
	checkDurability:SetPoint("TOPLEFT", checkDifficulty, "BOTTOMLEFT", 0, -GAP)
	checkDurability.OnValueChanged = OnValueChanged
	checkDurability.key = "hideDurability"
	tinsert(checks, checkDurability)

	local checkILevel = self:CreateCheckbox(L.HIDE_ILEVEL)
	checkILevel:SetPoint("TOPLEFT", checkDurability, "BOTTOMLEFT", 0, -GAP)
	checkILevel.OnValueChanged = OnValueChanged
	checkILevel.key = "hideItemLevel"
	tinsert(checks, checkILevel)
	
	local checkUnused = self:CreateCheckbox(L.HIDE_UNUSED)
	checkUnused:SetPoint("TOPLEFT", checkILevel, "BOTTOMLEFT", 0, -GAP)
	checkUnused.OnValueChanged = OnValueChanged
	checkUnused.key = "hideUnusedStats"
	tinsert(checks, checkUnused)

	local checkUpgrade = self:CreateCheckbox(L.HIDE_UPGRADE)
	checkUpgrade:SetPoint("TOPLEFT", checkUnused, "BOTTOMLEFT", 0, -GAP)
	checkUpgrade.OnValueChanged = OnValueChanged
	checkUpgrade.key = "hideUpgradeLevel"
	tinsert(checks, checkUpgrade)

	local checkCraftingReagent = self:CreateCheckbox(format(L.HIDE_TAG, PROFESSIONS_USED_IN_COOKING))
	checkCraftingReagent:SetPoint("TOPLEFT", checkUpgrade, "BOTTOMLEFT", 0, -GAP)
	checkCraftingReagent.OnValueChanged = OnValueChanged
	checkCraftingReagent.key = "hideCraftingReagent"
	tinsert(checks, checkCraftingReagent)

	local checkEnchantLabel = self:CreateCheckbox(format(L.HIDE_TAG, strmatch(ENCHANTED_TOOLTIP_LINE, "[^:]+")))
	checkEnchantLabel:SetPoint("TOPLEFT", checkCraftingReagent, "BOTTOMLEFT", 0, -GAP)
	checkEnchantLabel.OnValueChanged = OnValueChanged
	checkEnchantLabel.key = "hideEnchantLabel"
	tinsert(checks, checkEnchantLabel)

	local checkMadeBy = self:CreateCheckbox(format(L.HIDE_TAG, L.MADE_BY))
	checkMadeBy:SetPoint("TOPLEFT", checkEnchantLabel, "BOTTOMLEFT", 0, -GAP)
	checkMadeBy.OnValueChanged = OnValueChanged
	checkMadeBy.key = "hideMadeBy"
	tinsert(checks, checkMadeBy)

	local checkSoulbound = self:CreateCheckbox(format(L.HIDE_TAG, ITEM_SOULBOUND))
	checkSoulbound:SetPoint("TOPLEFT", checkMadeBy, "BOTTOMLEFT", 0, -GAP)
	checkSoulbound.OnValueChanged = OnValueChanged
	checkSoulbound.key = "hideSoulbound"
	tinsert(checks, checkSoulbound)

	local checkUnique = self:CreateCheckbox(format(L.HIDE_TAG, ITEM_UNIQUE))
	checkUnique:SetPoint("TOPLEFT", checkSoulbound, "BOTTOMLEFT", 0, -GAP)
	checkUnique.OnValueChanged = OnValueChanged
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
	checkSetBonuses.OnValueChanged = OnValueChanged
	checkSetBonuses.key = "hideSetBonuses"
	tinsert(checks, checkSetBonuses)

	local checkSetItems = self:CreateCheckbox(L.HIDE_SETLIST)
	checkSetItems:SetPoint("TOPLEFT", checkSetBonuses, "BOTTOMLEFT", 0, -GAP)
	checkSetItems.OnValueChanged = OnValueChanged
	checkSetItems.key = "hideSetItems"
	tinsert(checks, checkSetItems)

	local checkBuy = self:CreateCheckbox(L.HIDE_CLICKBUY)
	checkBuy:SetPoint("TOPLEFT", checkSetItems, "BOTTOMLEFT", 0, -GAP)
	checkBuy.OnValueChanged = OnValueChanged
	checkBuy.key = "hideRightClickBuy"
	tinsert(checks, checkBuy)

	local checkSocket = self:CreateCheckbox(L.HIDE_CLICKSOCKET)
	checkSocket:SetPoint("TOPLEFT", checkBuy, "BOTTOMLEFT", 0, -GAP)
	checkSocket.OnValueChanged = OnValueChanged
	checkSocket.key = "hideRightClickSocket"
	tinsert(checks, checkSocket)

	local checkValue = self:CreateCheckbox(L.HIDE_VALUE, L.HIDE_VALUE_TIP)
	checkValue:SetPoint("TOPLEFT", checkSocket, "BOTTOMLEFT", 0, -GAP)
	checkValue.OnValueChanged = OnValueChanged
	checkValue.key = "hideSellValue"
	tinsert(checks, checkValue)



	local checkReqs = self:CreateCheckbox(L.HIDE_REQUIREMENTS, L.HIDE_REQUIREMENTS_TIP)
	checkReqs:SetPoint("TOPLEFT", checkValue, "BOTTOMLEFT", 0, -BIGGAP)
	checkReqs.OnValueChanged = OnValueChanged
	checkReqs.key = "hideRequirements"
	tinsert(checks, checkReqs)

	local checkReqsMet = self:CreateCheckbox(L.HIDE_REQUIREMENTS_MET)
	checkReqsMet:SetPoint("TOPLEFT", checkReqs, "BOTTOMLEFT", 26, -GAP)
	checkReqsMet.OnValueChanged = OnValueChanged
	checkReqsMet.key = "hideRequirementsMetOnly"
	checkReqsMet.parent = checkReqs
	tinsert(checks, checkReqsMet)

	local checkTransmog = self:CreateCheckbox(L.HIDE_TRANSMOG)
	checkTransmog:SetPoint("TOPLEFT", checkReqsMet, "BOTTOMLEFT", -26, -GAP)
	checkTransmog.OnValueChanged = OnValueChanged
	checkTransmog.key = "hideTransmog"
	tinsert(checks, checkTransmog)

	local checkTransmogLabel = self:CreateCheckbox(L.HIDE_TRANSMOG_LABEL, L.HIDE_TRANSMOG_LABEL_TIP)
	checkTransmogLabel:SetPoint("TOPLEFT", checkTransmog, "BOTTOMLEFT", 26, -GAP)
	checkTransmogLabel.OnValueChanged = OnValueChanged
	checkTransmogLabel.key = "hideTransmogLabelOnly"
	checkTransmogLabel.parent = checkTransmog
	tinsert(checks, checkTransmogLabel)

	local checkFlavor = self:CreateCheckbox(L.HIDE_FLAVOR, L.HIDE_FLAVOR_TIP)
	checkFlavor:SetPoint("TOPLEFT", checkTransmogLabel, "BOTTOMLEFT", -26, -GAP)
	checkFlavor.OnValueChanged = OnValueChanged
	checkFlavor.key = "hideFlavor"
	tinsert(checks, checkFlavor)

	local checkFlavorTrade = self:CreateCheckbox(L.HIDE_FLAVOR_TRADE, L.HIDE_FLAVOR_TRADE_TIP)
	checkFlavorTrade:SetPoint("TOPLEFT", checkFlavor, "BOTTOMLEFT", 26, -GAP)
	checkFlavorTrade.OnValueChanged = OnValueChanged
	checkFlavorTrade.key = "hideFlavorTrade"
	checkFlavorTrade.parent = checkFlavor
	tinsert(checks, checkFlavorTrade)


	LibStub("LibAboutPanel").new(ADDON_NAME, ADDON_NAME)


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