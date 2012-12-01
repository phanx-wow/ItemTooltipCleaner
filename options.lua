--[[--------------------------------------------------------------------
	Item Tooltip Cleaner
	Removes extraneous lines from item tooltips.
	Copyright (c) 2010-2012 Akkorian, Phanx. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/addons/info19129-ItemTooltipCleaner.html
	http://www.curse.com/addons/wow/itemtooltipcleaner
----------------------------------------------------------------------]]

local ADDON_NAME, namespace = ...
local settings = namespace.settings
local L = namespace.L

local panel = LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME)

panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, event, addon)
	if addon ~= ADDON_NAME then return end

	if ItemTooltipCleanerSettings then
		for k, v in pairs(settings) do
			if type(v) ~= type(ItemTooltipCleanerSettings[k]) then
				ItemTooltipCleanerSettings[k] = v
			end
		end
		for k, v in pairs(ItemTooltipCleanerSettings) do
			settings[k] = v
		end
	end
	ItemTooltipCleanerSettings = settings

	self:UnregisterAllEvents()
	self:SetScript("OnEvent", nil)
end)

panel.runOnce = function(self)
	local title, notes = LibStub("PhanxConfig-Header").CreateHeader(self, ADDON_NAME, GetAddOnMetadata(ADDON_NAME, "Notes"))


	local CreateCheckbox = LibStub("PhanxConfig-Checkbox").CreateCheckbox
	local function OnClick(self, checked)
		settings[self.key] = checked
	end


	local colorBonus = LibStub("PhanxConfig-ColorPicker").CreateColorPicker(self, L.BONUS_COLOR)
	colorBonus:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -8)
	colorBonus.GetValue = function()
		return unpack(settings.bonusColor)
	end
	colorBonus.OnValueChanged = function(self, r, g, b)
		settings.bonusColor[1] = r
		settings.bonusColor[2] = g
		settings.bonusColor[3] = b
	end

	local colorEnchant = LibStub("PhanxConfig-ColorPicker").CreateColorPicker(self, L.ENCHANT_COLOR)
	colorEnchant:SetPoint("TOPLEFT", colorBonus, "BOTTOMLEFT", 0, -8)
	colorEnchant.GetValue = function()
		return unpack(settings.enchantColor)
	end
	colorEnchant.OnValueChanged = function(self, r, g, b)
		settings.enchantColor[1] = r
		settings.enchantColor[2] = g
		settings.enchantColor[3] = b
	end

	local colorReforge = LibStub("PhanxConfig-ColorPicker").CreateColorPicker(self, L.REFORGE_COLOR)
	colorReforge:SetPoint("TOPLEFT", colorEnchant, "BOTTOMLEFT", 0, -8)
	colorReforge.GetValue = function()
		return unpack(settings.reforgeColor)
	end
	colorReforge.OnValueChanged = function(self, r, g, b)
		settings.reforgeColor[1] = r
		settings.reforgeColor[2] = g
		settings.reforgeColor[3] = b
	end


	local checkDura = CreateCheckbox(self, L.HIDE_DURABILITY)
	checkDura:SetPoint("TOPLEFT", colorReforge, "BOTTOMLEFT", 0, -8)
	checkDura.OnValueChanged = OnClick
	checkDura.key = "hideDurability"

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

	local checkReqs = CreateCheckbox(self, L.HIDE_REQUIREMENTS, L.HIDE_REQUIREMENTS_TIP)
	checkReqs:SetPoint("TOPLEFT", checkILevel, "BOTTOMLEFT", 0, -8)
	checkReqs.OnValueChanged = OnClick
	checkReqs.key = "hideRequirements"

	local checkUpgrade = CreateCheckbox(self, L.HIDE_UPGRADE)
	checkUpgrade:SetPoint("TOPLEFT", checkReqs, "BOTTOMLEFT", 0, -8)
	checkUpgrade.OnValueChanged = OnClick
	checkUpgrade.key = "hideUpgradeLevel"

	local checkBuy = CreateCheckbox(self, L.HIDE_CLICKBUY)
	checkBuy:SetPoint("TOPLEFT", checkUpgrade, "BOTTOMLEFT", 0, -8)
	checkBuy.OnValueChanged = OnClick
	checkBuy.key = "hideRightClickBuy"

	local checkSocket = CreateCheckbox(self, L.HIDE_CLICKSOCKET)
	checkSocket:SetPoint("TOPLEFT", checkBuy, "BOTTOMLEFT", 0, -8)
	checkSocket.OnValueChanged = OnClick
	checkSocket.key = "hideRightClickSocket"

	local checkValue = CreateCheckbox(self, L.HIDE_VALUE, L.HIDE_VALUE_TIP)
	checkValue:SetPoint("TOPLEFT", checkSocket, "BOTTOMLEFT", 0, -8)
	checkValue.OnValueChanged = OnClick
	checkValue.key = "hideSellValue"


	local checkBlank = CreateCheckbox(self, L.HIDE_BLANK)
	checkBlank:SetPoint("TOPLEFT", notes, "BOTTOM", 0, -8)
	checkBlank.OnValueChanged = OnClick
	checkBlank.key = "hideBlank"


	local checkHeroic = CreateCheckbox(self, format(L.HIDE_TAG, ITEM_HEROIC))
	checkHeroic:SetPoint("TOPLEFT", checkBlank, "BOTTOMLEFT", 0, -42)
	checkHeroic.OnValueChanged = OnClick
	checkHeroic.key = "hideHeroic"

	local checkMadeBy = CreateCheckbox(self, format(L.HIDE_TAG, L.MADE_BY))
	checkMadeBy:SetPoint("TOPLEFT", checkHeroic, "BOTTOMLEFT", 0, -8)
	checkMadeBy.OnValueChanged = OnClick
	checkMadeBy.key = "hideMadeBy"

	local checkRaidFinder = CreateCheckbox(self, format(L.HIDE_TAG, RAID_FINDER))
	checkRaidFinder:SetPoint("TOPLEFT", checkMadeBy, "BOTTOMLEFT", 0, -8)
	checkRaidFinder.OnValueChanged = OnClick
	checkRaidFinder.key = "hideRaidFinder"

	local checkReforged = CreateCheckbox(self, format(L.HIDE_TAG, REFORGED))
	checkReforged:SetPoint("TOPLEFT", checkRaidFinder, "BOTTOMLEFT", 0, -8)
	checkReforged.OnValueChanged = OnClick
	checkReforged.key = "hideReforged"

	local checkSoulbound = CreateCheckbox(self, format(L.HIDE_TAG, ITEM_SOULBOUND))
	checkSoulbound:SetPoint("TOPLEFT", checkReforged, "BOTTOMLEFT", 0, -8)
	checkSoulbound.OnValueChanged = OnClick
	checkSoulbound.key = "hideSoulbound"

	local checkUnique = CreateCheckbox(self, format(L.HIDE_TAG, ITEM_UNIQUE))
	checkUnique:SetPoint("TOPLEFT", checkSoulbound, "BOTTOMLEFT", 0, -8)
	checkUnique.OnValueChanged = OnClick
	checkUnique.key = "hideUnique"


	local checkTransmog, checkTransmogLabel = CreateCheckbox(self, L.HIDE_TRANSMOG)
	checkTransmog:SetPoint("TOPLEFT", checkUnique, "BOTTOMLEFT", 0, -42)
	checkTransmog.OnValueChanged = function(self, checked)
		settings.hideTransmog = checked
		checkTransmogLabel:SetEnabled(checked)
	end

	checkTransmogLabel = CreateCheckbox(self, L.HIDE_TRANSMOG_LABEL, L.HIDE_TRANSMOG_LABEL_TIP)
	checkTransmogLabel:SetPoint("TOPLEFT", checkTransmog, "BOTTOMLEFT", 26, -8)
	checkTransmogLabel.OnValueChanged = OnClick
	checkTransmogLabel.key = "hideTransmogLabelOnly"


	self.refresh = function(self)
		colorBonus:SetValue(unpack(settings.bonusColor))
		colorEnchant:SetValue(unpack(settings.enchantColor))
		colorReforge:SetValue(unpack(settings.reforgeColor))

		checkILevel:SetValue(settings.hideItemLevel)
		checkEquipSets:SetValue(GetCVarBool("dontShowEquipmentSetsOnItems"))
		checkBuy:SetValue(settings.hideRightClickBuy)
		checkSocket:SetValue(settings.hideRightClickSocket)
		checkDura:SetValue(settings.hideDurability)
		checkReqs:SetValue(settings.hideRequirements)
		checkValue:SetValue(settings.hideSellValue)

		checkHeroic:SetValue(settings.hideHeroic)
		checkMadeBy:SetValue(settings.hideMadeBy)
		checkRaidFinder:SetValue(settings.hideRaidFinder)
		checkReforged:SetValue(settings.hideReforged)
		checkSoulbound:SetValue(settings.hideSoulbound)
		checkUnique:SetValue(settings.hideUnique)

		checkTransmog:SetValue(settings.hideTransmog)
		checkTransmogLabel:SetValue(settings.hideTransmogLabelOnly)
		checkTransmogLabel:SetEnabled(settings.hideTransmog)
	end
end

local about = LibStub("LibAboutPanel").new(ADDON_NAME, ADDON_NAME)

SLASH_ITEMTOOLTIPCLEANER1 = "/itc"

SlashCmdList["ITEMTOOLTIPCLEANER"] = function()
	InterfaceOptionsFrame_OpenToCategory(about)
	InterfaceOptionsFrame_OpenToCategory(panel)
end