--[[--------------------------------------------------------------------
	Item Tooltip Cleaner
	Removes extraneous lines from item tooltips.
	Copyright (c) 2010-2014 Akkorian <akkorian@hotmail.com>
	Copyright (c) 2010-2014 Phanx <addons@phanx.net>. All rights reserved.
	http://www.wowinterface.com/addons/info19129-ItemTooltipCleaner.html
	http://www.curse.com/addons/wow/itemtooltipcleaner
	https://github.com/Phanx/ItemTooltipCleaner
----------------------------------------------------------------------]]

local ADDON_NAME, namespace = ...

local panel = LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME, nil, function(self)
	local db = ItemTooltipCleanerSettings
	local L = namespace.L
	local GAP, BIGGAP = 8, 32

	local title, notes = self:CreateHeader(ADDON_NAME, GetAddOnMetadata(ADDON_NAME, "Notes"))


	local colorBonus = self:CreateColorPicker(L.BONUS_COLOR)
	colorBonus:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -GAP)
	function colorBonus:GetValue()
		return unpack(db.bonusColor)
	end
	function colorBonus:Callback(r, g, b)
		db.bonusColor[1] = r
		db.bonusColor[2] = g
		db.bonusColor[3] = b
		wipe(namespace.cache)
	end

	local colorEnchant = self:CreateColorPicker(L.ENCHANT_COLOR)
	colorEnchant:SetPoint("TOPLEFT", notes, "BOTTOM", 0, -GAP)
	function colorEnchant:GetValue()
		return unpack(db.enchantColor)
	end
	function colorEnchant:Callback(r, g, b)
		db.enchantColor[1] = r
		db.enchantColor[2] = g
		db.enchantColor[3] = b
		wipe(namespace.cache)
	end


	local checks = {}
	local function OnClick(this, checked)
		db[this.key] = not not checked
		wipe(namespace.cache)
		--print("Wiped cache.")
	end


	local checkBlank = self:CreateCheckbox(L.HIDE_BLANK)
	checkBlank:SetPoint("TOPLEFT", colorBonus, "BOTTOMLEFT", 0, -BIGGAP)
	checkBlank.Callback = OnClick
	checkBlank.key = "hideBlank"
	tinsert(checks, checkBlank)

	local checkDifficulty = self:CreateCheckbox(format(L.HIDE_DIFFICULTY))
	checkDifficulty:SetPoint("TOPLEFT", checkBlank, "BOTTOMLEFT", 0, -GAP)
	checkDifficulty.Callback = OnClick
	checkDifficulty.key = "hideRaidDifficulty"
	tinsert(checks, checkDifficulty)

	local checkDura = self:CreateCheckbox(L.HIDE_DURABILITY)
	checkDura:SetPoint("TOPLEFT", checkDifficulty, "BOTTOMLEFT", 0, -GAP)
	checkDura.Callback = OnClick
	checkDura.key = "hideDurability"
	tinsert(checks, checkDura)

	local checkILevel = self:CreateCheckbox(L.HIDE_ILEVEL)
	checkILevel:SetPoint("TOPLEFT", checkDura, "BOTTOMLEFT", 0, -GAP)
	checkILevel.Callback = OnClick
	checkILevel.key = "hideItemLevel"
	tinsert(checks, checkILevel)

	local checkUpgrade = self:CreateCheckbox(L.HIDE_UPGRADE)
	checkUpgrade:SetPoint("TOPLEFT", checkILevel, "BOTTOMLEFT", 0, -GAP)
	checkUpgrade.Callback = OnClick
	checkUpgrade.key = "hideUpgradeLevel"
	tinsert(checks, checkUpgrade)



	local checkCraftingReagent = self:CreateCheckbox(format(L.HIDE_TAG, PROFESSIONS_USED_IN_COOKING))
	checkCraftingReagent:SetPoint("TOPLEFT", checkUpgrade, "BOTTOMLEFT", 0, -BIGGAP)
	checkCraftingReagent.Callback = OnClick
	checkCraftingReagent.key = "hideCraftingReagent"
	tinsert(checks, checkCraftingReagent)

	local checkEnchantLabel = self:CreateCheckbox(format(L.HIDE_TAG, strtrim(gsub(gsub(ENCHANTED_TOOLTIP_LINE, ":", ""), "%%s", ""))))
	checkEnchantLabel:SetPoint("TOPLEFT", checkCraftingReagent, "BOTTOMLEFT", 0, -GAP)
	checkEnchantLabel.Callback = OnClick
	checkEnchantLabel.key = "hideEnchantLabel"
	tinsert(checks, checkEnchantLabel)

	local checkMadeBy = self:CreateCheckbox(format(L.HIDE_TAG, L.MADE_BY))
	checkMadeBy:SetPoint("TOPLEFT", checkEnchantLabel, "BOTTOMLEFT", 0, -GAP)
	checkMadeBy.Callback = OnClick
	checkMadeBy.key = "hideMadeBy"
	tinsert(checks, checkMadeBy)

	local checkSoulbound = self:CreateCheckbox(format(L.HIDE_TAG, ITEM_SOULBOUND))
	checkSoulbound:SetPoint("TOPLEFT", checkMadeBy, "BOTTOMLEFT", 0, -GAP)
	checkSoulbound.Callback = OnClick
	checkSoulbound.key = "hideSoulbound"
	tinsert(checks, checkSoulbound)

	local checkUnique = self:CreateCheckbox(format(L.HIDE_TAG, ITEM_UNIQUE))
	checkUnique:SetPoint("TOPLEFT", checkSoulbound, "BOTTOMLEFT", 0, -GAP)
	checkUnique.Callback = OnClick
	checkUnique.key = "hideUnique"
	tinsert(checks, checkUnique)



	local checkEquipSets = self:CreateCheckbox(L.HIDE_EQUIPSETS, L.HIDE_EQUIPSETS_TIP)
	checkEquipSets:SetPoint("TOPLEFT", colorEnchant, "BOTTOMLEFT", 0, -BIGGAP)
	function checkEquipSets:Callback(checked)
		if checked then
			SetCVar("dontShowEquipmentSetsOnItems", 1)
		else
			SetCVar("dontShowEquipmentSetsOnItems", 0)
		end
		wipe(namespace.cache)
	end

	local checkSetBonuses = self:CreateCheckbox(L.HIDE_SETBONUS)
	checkSetBonuses:SetPoint("TOPLEFT", checkEquipSets, "BOTTOMLEFT", 0, -GAP)
	checkSetBonuses.Callback = OnClick
	checkSetBonuses.key = "hideSetBonuses"
	tinsert(checks, checkSetBonuses)

	local checkSetItems = self:CreateCheckbox(L.HIDE_SETLIST)
	checkSetItems:SetPoint("TOPLEFT", checkSetBonuses, "BOTTOMLEFT", 0, -GAP)
	checkSetItems.Callback = OnClick
	checkSetItems.key = "hideSetItems"
	tinsert(checks, checkSetItems)

	local checkBuy = self:CreateCheckbox(L.HIDE_CLICKBUY)
	checkBuy:SetPoint("TOPLEFT", checkSetItems, "BOTTOMLEFT", 0, -GAP)
	checkBuy.Callback = OnClick
	checkBuy.key = "hideRightClickBuy"
	tinsert(checks, checkBuy)

	local checkSocket = self:CreateCheckbox(L.HIDE_CLICKSOCKET)
	checkSocket:SetPoint("TOPLEFT", checkBuy, "BOTTOMLEFT", 0, -GAP)
	checkSocket.Callback = OnClick
	checkSocket.key = "hideRightClickSocket"
	tinsert(checks, checkSocket)

	local checkValue = self:CreateCheckbox(L.HIDE_VALUE, L.HIDE_VALUE_TIP)
	checkValue:SetPoint("TOPLEFT", checkSocket, "BOTTOMLEFT", 0, -GAP)
	checkValue.Callback = OnClick
	checkValue.key = "hideSellValue"
	tinsert(checks, checkValue)



	local checkReqs, checkReqsMet = self:CreateCheckbox(L.HIDE_REQUIREMENTS, L.HIDE_REQUIREMENTS_TIP)
	checkReqs:SetPoint("TOPLEFT", checkValue, "BOTTOMLEFT", 0, -BIGGAP)
	checkReqs.Callback = OnClick
	checkReqs.key = "hideRequirements"
	tinsert(checks, checkReqs)
	function checkReqs:Callback(checked)
		db.hideRequirements = checked
		checkReqsMet:SetEnabled(checked)
		wipe(namespace.cache)
	end

	checkReqsMet = self:CreateCheckbox(L.HIDE_REQUIREMENTS_MET)
	checkReqsMet:SetPoint("TOPLEFT", checkReqs, "BOTTOMLEFT", 26, -GAP)
	checkReqsMet.Callback = OnClick
	checkReqsMet.key = "hideRequirementsMetOnly"
	tinsert(checks, checkReqsMet)

	local checkTransmog, checkTransmogLabel = self:CreateCheckbox(L.HIDE_TRANSMOG)
	checkTransmog:SetPoint("TOPLEFT", checkReqsMet, "BOTTOMLEFT", -26, -GAP)
	checkTransmog.key = "hideTransmog"
	tinsert(checks, checkTransmog)
	function checkTransmog:Callback(checked)
		db.hideTransmog = checked
		checkTransmogLabel:SetEnabled(checked)
		wipe(namespace.cache)
	end

	checkTransmogLabel = self:CreateCheckbox(L.HIDE_TRANSMOG_LABEL, L.HIDE_TRANSMOG_LABEL_TIP)
	checkTransmogLabel:SetPoint("TOPLEFT", checkTransmog, "BOTTOMLEFT", 26, -GAP)
	checkTransmogLabel.Callback = OnClick
	checkTransmogLabel.key = "hideTransmogLabelOnly"
	tinsert(checks, checkTransmogLabel)


	LibStub("LibAboutPanel").new(ADDON_NAME, ADDON_NAME)


	self.refresh = function(self)
		colorBonus:SetValue(unpack(db.bonusColor))
		colorEnchant:SetValue(unpack(db.enchantColor))

		for _, check in pairs(checks) do
			check:SetChecked(db[check.key])
		end

		checkEquipSets:SetChecked(GetCVarBool("dontShowEquipmentSetsOnItems"))

		checkReqsMet:SetEnabled(db.hideRequirements)
		checkTransmogLabel:SetEnabled(db.hideTransmog)
	end
end)

SLASH_ITEMTOOLTIPCLEANER1 = "/itc"
SlashCmdList["ITEMTOOLTIPCLEANER"] = function() InterfaceOptionsFrame_OpenToCategory(panel) end