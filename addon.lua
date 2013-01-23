--[[--------------------------------------------------------------------
	Item Tooltip Cleaner
	Removes extraneous lines from item tooltips.
	Copyright (c) 2010-2013 Akkorian, Phanx. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/addons/info19129-ItemTooltipCleaner.html
	http://www.curse.com/addons/wow/itemtooltipcleaner
----------------------------------------------------------------------]]

local ADDON_NAME, namespace = ...

local GAME_LOCALE = GetLocale()
local format, gsub, ipairs, strmatch, unpack = format, gsub, ipairs, strmatch, unpack

------------------------------------------------------------------------

local settings = {
	bonusColor = { 0, 1, 0 },
	enchantColor = { 0, 0.8, 1 },
	reforgeColor = { 1, 0.5, 1 },
	hideBlank = true,
--	hideDurability = false,
	hideEquipmentSets = true,
--	hideHeroic = false,
	hideItemLevel = true,
	hideMadeBy = true,
--	hideRaidFinder = false,
	hideReforged = true,
	hideRequirements = true,
	hideRequirementsMet = true,
	hideRightClickBuy = true,
	hideRightClickSocket = true,
--	hideSellValue = false,
--	hideSoulbound = false,
--	hideTransmog = false,
--	hideTransmogLabel = false,
--	hideUnique = false,
--	hideUpgradeLevel = false,
}

namespace.settings = settings

------------------------------------------------------------------------

local L = setmetatable(namespace.L or {}, { __index = function(t, k)
	if k == nil then return "" end
	local v = tostring(k)
	t[k] = v
	return v
end })

if not namespace.L then
	namespace.L = L
end

------------------------------------------------------------------------

local ITEM_HEROIC      = ITEM_HEROIC
local ITEM_HEROIC_EPIC = ITEM_HEROIC_EPIC
local ITEM_SOCKETABLE  = ITEM_SOCKETABLE
local ITEM_SOULBOUND   = ITEM_SOULBOUND
local ITEM_UNIQUE      = ITEM_UNIQUE
local ITEM_UNIQUE_EQUIPPABLE = ITEM_UNIQUE_EQUIPPABLE
local ITEM_VENDOR_STACK_BUY  = ITEM_VENDOR_STACK_BUY
local RAID_FINDER      = RAID_FINDER
local REFORGED         = REFORGED

local S_DURABILITY      = "^" .. gsub(DURABILITY_TEMPLATE, "%%d", "%%d+")
local S_ENCHANTED       = "^" .. gsub(ENCHANTED_TOOLTIP_LINE, "%%s", "(.+)")
local S_ITEM_LEVEL      = "^" .. gsub(ITEM_LEVEL, "%%%d?$?d", "%%d+")
local S_MADE_BY         = "^" .. gsub(ITEM_CREATED_BY, "%%%d?$?s", ".+")
local S_REFORGED        = "^(" .. gsub(strsub(REFORGE_TOOLTIP_LINE, 1, 7), "%%[cs]", ".-") .. ")" .. gsub(gsub(strsub(REFORGE_TOOLTIP_LINE, 8), "%%s", ".-"), "[%(%)]", "%%%1")
local S_REQ_CLASS       = "^" .. gsub(ITEM_CLASSES_ALLOWED, "%%s", ".+")
local S_REQ_LEVEL       = "^" .. gsub(ITEM_MIN_LEVEL, "%%%d?$?d", "%%d+")
local S_REQ_RACE        = "^" .. gsub(ITEM_RACES_ALLOWED, "%%s", ".+")
local S_REQ_REPUTATION  = "^" .. gsub(ITEM_REQ_REPUTATION, "%%%d?$?s", ".+")
local S_REQ_SKILL       = "^" .. gsub(ITEM_REQ_SKILL, "%%%d?$?s", ".+")
local S_TRANSMOGRIFIED  = "^" .. gsub(TRANSMOGRIFIED, "%%s", "(.+)")
local S_UNIQUE_MULTIPLE = "^" .. gsub(ITEM_UNIQUE_MULTIPLE, "%%d", "%%d+")
local S_UPGRADE_LEVEL   = "^" .. gsub(ITEM_UPGRADE_TOOLTIP_FORMAT, "%%d", "%%d+")

local cache = setmetatable({ }, { __mode = "kv" }) -- weak table to enable garbage collection

local lines = setmetatable({ }, { __index = function(lines, tooltip)
	local lines_tooltip = setmetatable({ name = tooltip:GetName() }, { __index = function(lines_tooltip, line)
		local obj = _G[lines_tooltip.name .. "TextLeft" .. i]
		lines_tooltip[line] = obj
		return obj
	end })
	lines[tooltip] = lines_tooltip
	return lines_tooltip
end })

local function ReformatItemTooltip(tooltip)
	local tooltipName = tooltip:GetName()
	for i = 2, tooltip:NumLines() do
		local line = _G[tooltipName .. "TextLeft" .. i]
		local text = line:GetText()
		if text then
			if strmatch(text, S_ENCHANTED) then
				line:SetText(strmatch(text, S_ENCHANTED))
				line:SetTextColor(unpack(settings.enchantColor))

			elseif strmatch(text, S_REFORGED) then
				line:SetTextColor(unpack(settings.reforgeColor))
				if settings.hideReforged then
					line:SetText(strmatch(text, S_REFORGED))
				end

			elseif settings.hideTransmog and strmatch(text, S_TRANSMOGRIFIED) then
				if settings.hideTransmogLabelOnly then
					line:SetText(strmatch(text, S_TRANSMOGRIFIED))
				else
					line:SetText("")
				end

			elseif settings.hideRequirements and
			(strmatch(text, S_REQ_CLASS)
				or strmatch(text, S_REQ_RACE)
				or strmatch(text, S_REQ_LEVEL)
				or strmatch(text, S_REQ_REPUTATION)
				or strmatch(text, S_REQ_SKILL)
				or strmatch(text, L.ENCHANT_REQUIRES)
				or strmatch(text, L.SOCKET_REQUIRES)
			) then
				if settings.hideRequirementsMet then
					-- hide only if met
					local r, g, b = line:GetTextColor()
					if g > 0.9 and b > 0.9 then
						line:SetText("")
					end
				else
					line:SetText()
				end

			elseif (text == " " and settings.hideBlank) then
				local isAnchor
				if tooltip.shownMoneyFrames then
					for j = 1, tooltip.shownMoneyFrames do
						if select(2,_G[tooltip:GetName().."MoneyFrame"..j]:GetPoint("LEFT")) == line then
							isAnchor = true
							break
						end
					end
				end
				if not isAnchor then
					line:SetText("")
				end

			elseif (text == ITEM_HEROIC and settings.hideHeroic)
			or (text == ITEM_SOCKETABLE and settings.hideRightClickSocket)
			or (text == ITEM_SOULBOUND and settings.hideSoulbound)
			or (text == ITEM_VENDOR_STACK_BUY and settings.hideRightClickBuy)
			or (text == REFORGED and settings.hideReforged)
			or (text == RAID_FINDER and settings.hideRaidFinder)
			or (settings.hideDurability and strmatch(text, S_DURABILITY))
			or (settings.hideItemLevel and strmatch(text, S_ITEM_LEVEL))
			or (settings.hideMadeBy and strmatch(text, S_MADE_BY))
			or (settings.hideUpgradeLevel and strmatch(text, S_UPGRADE_LEVEL))
			or (settings.hideUnique and (text == ITEM_UNIQUE or text == ITEM_UNIQUE_EQUIPPABLE or strmatch(text, S_UNIQUE_MULTIPLE)))
				line:SetText("")

			elseif strmatch(text, "^%+%d+") then
				local r, g, b = line:GetTextColor()
				if r < 0.1 and g > 0.9 and b < 0.1 then
					line:SetTextColor(unpack(settings.bonusColor))
				end
			end
		end
	end
	tooltip:Show()
end

for _, tooltip in pairs({
	"GameTooltip",
	"ItemRefTooltip",
	"ItemRefShoppingTooltip1",
	"ItemRefShoppingTooltip2",
	"ItemRefShoppingTooltip3",
	"ShoppingTooltip1",
	"ShoppingTooltip2",
	"ShoppingTooltip3",
	"WorldMapCompareTooltip1",
	"WorldMapCompareTooltip2",
	"WorldMapCompareTooltip3",
}) do
	if _G[tooltip] then
		_G[tooltip]:HookScript("OnTooltipSetItem", ReformatItemTooltip)
	end
end

------------------------------------------------------------------------

local showPriceFrames = {
	"AuctionFrame",
	"MerchantFrame",
	"QuestRewardPanel",
	"QuestFrameRewardPanel",
}

local prehook = GameTooltip_OnTooltipAddMoney

function GameTooltip_OnTooltipAddMoney(...)
	if not settings.hideSellValue then
		return prehook(...)
	end
	for _, name in pairs(showPriceFrames) do
		local frame = _G[name]
		if frame and frame:IsShown() then
			return prehook(...)
		end
	end
end