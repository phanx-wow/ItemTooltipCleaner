--[[--------------------------------------------------------------------
	Item Tooltip Cleaner
	Removes extraneous lines from item tooltips.
	Copyright (c) 2010-2013 Akkorian, Phanx. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/addons/info19129-ItemTooltipCleaner.html
	http://www.curse.com/addons/wow/itemtooltipcleaner
----------------------------------------------------------------------]]

local ADDON_NAME, namespace = ...

SLASH_ITEMTOOLTIPCLEANER1 = "/itc"
SlashCmdList["ITEMTOOLTIPCLEANER"] = function() InterfaceOptionsFrame_OpenToCategory(

LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME, nil, function(self)
	local db = ItemTooltipCleanerSettings
	local L = namespace.L


	local title, notes = LibStub("PhanxConfig-Header").CreateHeader(self, ADDON_NAME, GetAddOnMetadata(ADDON_NAME, "Notes"))


	local colorBonus = LibStub("PhanxConfig-ColorPicker").CreateColorPicker(self, L.BONUS_COLOR)
	colorBonus:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -8)
	colorBonus.GetValue = function()
		return unpack(db.bonusColor)
	end
	colorBonus.OnValueChanged = function(self, r, g, b)
		db.bonusColor[1] = r
		db.bonusColor[2] = g
		db.bonusColor[3] = b
	end

	local colorEnchant = LibStub("PhanxConfig-ColorPicker").CreateColorPicker(self, L.ENCHANT_COLOR)
	colorEnchant:SetPoint("TOPLEFT", colorBonus, "BOTTOMLEFT", 0, -8)
	colorEnchant.GetValue = function()
		return unpack(db.enchantColor)
	end
	colorEnchant.OnValueChanged = function(self, r, g, b)
		db.enchantColor[1] = r
		db.enchantColor[2] = g
		db.enchantColor[3] = b
	end

	local colorReforge = LibStub("PhanxConfig-ColorPicker").CreateColorPicker(self, L.REFORGE_COLOR)
	colorReforge:SetPoint("TOPLEFT", colorEnchant, "BOTTOMLEFT", 0, -8)
	colorReforge.GetValue = function()
		return unpack(db.reforgeColor)
	end
	colorReforge.OnValueChanged = function(self, r, g, b)
		db.reforgeColor[1] = r
		db.reforgeColor[2] = g
		db.reforgeColor[3] = b
	end


	local checks = {}
	local CreateCheckbox = LibStub("PhanxConfig-Checkbox").CreateCheckbox
	local function OnClick(this, checked)
		db[this.key] = not not checked
	end


	local checkBlank = CreateCheckbox(self, L.HIDE_BLANK)
	checkBlank:SetPoint("TOPLEFT", colorReforge, "BOTTOMLEFT", 0, -42)
	checkBlank.OnValueChanged = OnClick
	checkBlank.key = "hideBlank"
	tinsert(checks, checkBlank)

	local checkDura = CreateCheckbox(self, L.HIDE_DURABILITY)
	checkDura:SetPoint("TOPLEFT", checkBlank, "BOTTOMLEFT", 0, -42)
	checkDura.OnValueChanged = OnClick
	checkDura.key = "hideDurability"
	tinsert(checks, checkDura)

	local checkEquipSets = CreateCheckbox(self, L.HIDE_EQUIPSETS)
	checkEquipSets:SetPoint("TOPLEFT", checkDura, "BOTTOMLEFT", 0, -8)
	checkEquipSets.OnValueChanged = function(self, checked)
		if checked then
			SetCVar("dontShowEquipmentSetsOnItems", 1)
		else
			SetCVar("dontShowEquipmentSetsOnItems", 0)
		end
	end

	local checkILevel = CreateCheckbox(self, L.HIDE_ILEVEL)
	checkILevel:SetPoint("TOPLEFT", checkEquipSets, "BOTTOMLEFT", 0, -8)
	checkILevel.OnValueChanged = OnClick
	checkILevel.key = "hideItemLevel"
	tinsert(checks, checkILevel)

	local checkUpgrade = CreateCheckbox(self, L.HIDE_UPGRADE)
	checkUpgrade:SetPoint("TOPLEFT", checkILevel, "BOTTOMLEFT", 0, -8)
	checkUpgrade.OnValueChanged = OnClick
	checkUpgrade.key = "hideUpgradeLevel"
	tinsert(checks, checkUpgrade)

	local checkBuy = CreateCheckbox(self, L.HIDE_CLICKBUY)
	checkBuy:SetPoint("TOPLEFT", checkUpgrade, "BOTTOMLEFT", 0, -8)
	checkBuy.OnValueChanged = OnClick
	checkBuy.key = "hideRightClickBuy"
	tinsert(checks, checkBuy)

	local checkSocket = CreateCheckbox(self, L.HIDE_CLICKSOCKET)
	checkSocket:SetPoint("TOPLEFT", checkBuy, "BOTTOMLEFT", 0, -8)
	checkSocket.OnValueChanged = OnClick
	checkSocket.key = "hideRightClickSocket"
	tinsert(checks, checkSocket)

	local checkValue = CreateCheckbox(self, L.HIDE_VALUE, L.HIDE_VALUE_TIP)
	checkValue:SetPoint("TOPLEFT", checkSocket, "BOTTOMLEFT", 0, -8)
	checkValue.OnValueChanged = OnClick
	checkValue.key = "hideSellValue"
	tinsert(checks, checkValue)


	local checkHeroic = CreateCheckbox(self, format(L.HIDE_TAG, ITEM_HEROIC))
	checkHeroic:SetPoint("TOPLEFT", notes, "BOTTOM", 0, -8)
	checkHeroic.OnValueChanged = OnClick
	checkHeroic.key = "hideHeroic"
	tinsert(checks, checkHeroic)

	local checkMadeBy = CreateCheckbox(self, format(L.HIDE_TAG, L.MADE_BY))
	checkMadeBy:SetPoint("TOPLEFT", checkHeroic, "BOTTOMLEFT", 0, -8)
	checkMadeBy.OnValueChanged = OnClick
	checkMadeBy.key = "hideMadeBy"
	tinsert(checks, checkMadeBy)

	local checkRaidFinder = CreateCheckbox(self, format(L.HIDE_TAG, RAID_FINDER))
	checkRaidFinder:SetPoint("TOPLEFT", checkMadeBy, "BOTTOMLEFT", 0, -8)
	checkRaidFinder.OnValueChanged = OnClick
	checkRaidFinder.key = "hideRaidFinder"
	tinsert(checks, checkRaidFinder)

	local checkReforged = CreateCheckbox(self, format(L.HIDE_TAG, REFORGED))
	checkReforged:SetPoint("TOPLEFT", checkRaidFinder, "BOTTOMLEFT", 0, -8)
	checkReforged.OnValueChanged = OnClick
	checkReforged.key = "hideReforged"
	tinsert(checks, checkReforged)

	local checkSoulbound = CreateCheckbox(self, format(L.HIDE_TAG, ITEM_SOULBOUND))
	checkSoulbound:SetPoint("TOPLEFT", checkReforged, "BOTTOMLEFT", 0, -8)
	checkSoulbound.OnValueChanged = OnClick
	checkSoulbound.key = "hideSoulbound"
	tinsert(checks, checkSoulbound)

	local checkUnique = CreateCheckbox(self, format(L.HIDE_TAG, ITEM_UNIQUE))
	checkUnique:SetPoint("TOPLEFT", checkSoulbound, "BOTTOMLEFT", 0, -8)
	checkUnique.OnValueChanged = OnClick
	checkUnique.key = "hideUnique"
	tinsert(checks, checkUnique)


	local checkSetBonuses = CreateCheckbox(self, "Hide set bonuses")
	checkSetBonuses:SetPoint("TOPLEFT", checkUnique, "BOTTOMLEFT", 0, -42)
	checkSetBonuses.OnValueChanged = OnClick
	checkSetBonuses.key = "hideSetBonuses"
	tinsert(checks, checkSetBonuses)

	local checkSetItems = CreateCheckbox(self, "Hide set item list")
	checkSetItems:SetPoint("TOPLEFT", checkSetBonuses, "BOTTOMLEFT", 0, -8)
	checkSetItems.OnValueChanged = OnClick
	checkSetItems.key = "hideSetItems"
	tinsert(checks, checkSetItems)

	local checkReqs, checkReqsMet = CreateCheckbox(self, L.HIDE_REQUIREMENTS, L.HIDE_REQUIREMENTS_TIP)
	checkReqs:SetPoint("TOPLEFT", checkSetItems, "BOTTOMLEFT", 0, -8)
	checkReqs.OnValueChanged = OnClick
	checkReqs.OnValueChanged = function(self, checked)
		db.hideRequirements = checked
		checkReqsMet:SetEnabled(checked)
	end

	checkReqsMet = CreateCheckbox(self, L.HIDE_REQUIREMENTS_MET)
	checkReqsMet:SetPoint("TOPLEFT", checkReqs, "BOTTOMLEFT", 26, -8)
	checkReqsMet.OnValueChanged = OnClick
	checkReqsMet.key = "hideRequirementsMetOnly"
	tinsert(checks, checkReqsMet)

	local checkTransmog, checkTransmogLabel = CreateCheckbox(self, L.HIDE_TRANSMOG)
	checkTransmog:SetPoint("TOPLEFT", checkReqsMet, "BOTTOMLEFT", -26, -8)
	checkTransmog.OnValueChanged = function(self, checked)
		db.hideTransmog = checked
		checkTransmogLabel:SetEnabled(checked)
	end

	checkTransmogLabel = CreateCheckbox(self, L.HIDE_TRANSMOG_LABEL, L.HIDE_TRANSMOG_LABEL_TIP)
	checkTransmogLabel:SetPoint("TOPLEFT", checkTransmog, "BOTTOMLEFT", 26, -8)
	checkTransmogLabel.OnValueChanged = OnClick
	checkTransmogLabel.key = "hideTransmogLabelOnly"
	tinsert(checks, checkTransmogLabel)


	LibStub("LibAboutPanel").new(ADDON_NAME, ADDON_NAME)


	self.refresh = function(self)
		colorBonus:SetValue(unpack(db.bonusColor))
		colorEnchant:SetValue(unpack(db.enchantColor))
		colorReforge:SetValue(unpack(db.reforgeColor))

		for _, check in pairs(checks) do
			check:SetChecked(db[check.key])
		end

		checkEquipSets:SetChecked(GetCVarBool("dontShowEquipmentSetsOnItems"))
		checkTransmog:SetChecked(db.hideTransmog)
		checkTransmogLabel:SetEnabled(db.hideTransmog)
	end


	hooksecurefunc(self, "okay", function() wipe(namespace.cache) end)

end)

) end