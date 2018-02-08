--[[--------------------------------------------------------------------
	Item Tooltip Cleaner
	Removes extraneous lines from item tooltips.
	Copyright (c) 2010-2017 Akkorian <armordecai@protonmail.com>
	Copyright (c) 2011-2018 Phanx <addons@phanx.net>
	All rights reserved. See LICENSE.txt for more info.
	https://github.com/Phanx/ItemTooltipCleaner
	https://www.curseforge.com/addons/wow/itemtooltipcleaner
	https://www.wowinterface.com/addons/info19129-ItemTooltipCleaner.html
----------------------------------------------------------------------]]

local ADDON_NAME, namespace = ...

local panel = LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME, nil, function(self)
	local db = ItemTooltipCleanerSettings
	local L = namespace.L
	local GAP, INDENT = 8, 26

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

	local checkinfos = {
		{
			-- key, title, tooltip, isChild, func
			{ "hideBlank", L.HIDE_BLANK },
			{ "hideDurability", L.HIDE_DURABILITY },
			{ "hideItemLevel", L.HIDE_ILEVEL },
			{ "hideRaidDifficulty", L.HIDE_DIFFICULTY },
			{ "hideUnusedStats", L.HIDE_UNUSED },
			{ "hideUpgradeLevel", L.HIDE_UPGRADE },
			{ "hideSellValue", L.HIDE_VALUE, L.HIDE_VALUE_TIP },
			{ "hideCraftingReagent", format(L.HIDE_TAG, PROFESSIONS_USED_IN_COOKING) },
			{ "hideEnchantLabel", format(L.HIDE_TAG, strmatch(ENCHANTED_TOOLTIP_LINE, "[^:]+")) },
			{ "hideMadeBy", format(L.HIDE_TAG, L.MADE_BY) },
			{ "hideSoulbound", format(L.HIDE_TAG, ITEM_SOULBOUND) },
			{ "hideUnique", format(L.HIDE_TAG, ITEM_UNIQUE) },
		},
		{
			-- key, title, tooltip, isChild, func
			{ "hideEquipmentSets", L.HIDE_EQUIPSETS, L.HIDE_EQUIPSETS_TIP, nil,
				function()
					return GetCVarBool("dontShowEquipmentSetsOnItems")
				end,
				function(this, checked)
					SetCVar("dontShowEquipmentSetsOnItems", checked and "1" or "0")
					wipe(namespace.cache)
				end },
			{ "hideSetBonuses", L.HIDE_SETBONUS },
			{ "hideSetBonusesLegacy", L.HIDE_SETBONUS_LEGACY, nil, true },
			{ "hideSetItems", L.HIDE_SETLIST },
			{ "hideRightClickBuy", L.HIDE_CLICKBUY },
			{ "hideRightClickSocket", L.HIDE_CLICKSOCKET },
			{ "hideRequirements", L.HIDE_REQUIREMENTS, L.HIDE_REQUIREMENTS_TIP },
			{ "hideRequirementsMet", L.HIDE_REQUIREMENTS_MET, nil, true },
			{ "hideTransmog", L.HIDE_TRANSMOG },
			{ "hideTransmogLabelOnly", L.HIDE_TRANSMOG_LABEL, L.HIDE_TRANSMOG_LABEL_TIP, true },
			{ "hideAppearanceKnown", L.HIDE_APPEARANCE_KNOWN },
			{ "hideAppearanceUnknown", L.HIDE_APPEARANCE_UNKNOWN },
			{ "hideFlavor", L.HIDE_FLAVOR, L.HIDE_FLAVOR_TIP },
			{ "hideFlavorTrade", L.HIDE_FLAVOR_TRADE, L.HIDE_FLAVOR_TRADE_TIP, true },
		}
	}

	local checks = {}

	local function addColumn(options, ...)
		local anchor
		local parent

		for i = 1, #options do
			local key, label, tooltip, isChild, getter, setter = unpack(options[i])

			local check = self:CreateCheckbox(label, tooltip)
			check.OnValueChanged = setter
			check.getter = getter
			check.index = i
			check.key = key

			if i > 1 then
				parent = isChild and parent or check
				check.parent = isChild and parent or nil

				local x = 0
				local previousIsChild = options[i - 1][4]
				if isChild and not previousIsChild then
					x = INDENT
				elseif previousIsChild and not isChild then
					x = -INDENT
				end
				check:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", x, -GAP)
			else
				check:SetPoint("TOPLEFT", ...)
			end

			tinsert(checks, check)
			anchor = check
		end
	end

	addColumn(checkinfos[1], colorEnchant, "BOTTOMLEFT", 0, -GAP)
	addColumn(checkinfos[2], notes, "BOTTOM", 0, -GAP)


	local function OnValueChanged(this, checked)
		db[this.key] = checked
		wipe(namespace.cache)
		for _, other in pairs(checks) do
			if other.parent == this then
				other:SetEnabled(checked)
			end
		end
	end

	for _, check in pairs(checks) do
		if not check.OnValueChanged then
			check.OnValueChanged = OnValueChanged
		end
	end


	self.refresh = function(self)
		colorBonus:SetValue(unpack(db.bonusColor))
		colorEnchant:SetValue(unpack(db.enchantColor))

		for _, check in pairs(checks) do
			if checks.getter then
				check:SetChecked(checks.getter())
			else
				check:SetChecked(db[check.key])
			end
			if check.parent then
				check:SetEnabled(db[check.parent.key])
			end
		end
	end
end)

SLASH_ITEMTOOLTIPCLEANER1 = "/itc"
SlashCmdList["ITEMTOOLTIPCLEANER"] = function() InterfaceOptionsFrame_OpenToCategory(panel) end
