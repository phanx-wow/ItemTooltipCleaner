--[[--------------------------------------------------------------------
	Item Tooltip Cleaner
	Compacts equipment bonus text and removes extraneous lines from item tooltips.
	Copyright (c) 2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/addons/info19129-ItemTooltipCleaner.html
	http://www.curse.com/addons/wow/itemtooltipcleaner
----------------------------------------------------------------------]]

local ADDON_NAME, namespace = ...

local GAME_LOCALE = GetLocale()

------------------------------------------------------------------------

local settings = {
	compactBonuses = true,
	enchantColor = { 0, 0.8, 1 },
	hideEquipmentSets = true,
--	hideHeroic = false,
	hideItemLevel = true,
	hideMadeBy = true,
--	hideRaidFinder = false,
--	hideReforged = false,
	hideRightClickBuy = true,
	hideRightClickSocket = true,
--	hideSellValue = false,
--	hideSoulbound = false,
	customTooltips = {
		"AtlasLootTooltip",		-- AtlasLoot
		"AtlasQuestTooltip",	-- AtlasQuest
		"EQCompareTooltip",		-- EQCompare
		"ComparisonTooltip",	-- EquipCompare
		"LinksTooltip",			-- Links
		"tekKompareTooltip",	-- tekKompare
	},
}

namespace.settings = settings

------------------------------------------------------------------------

if not namespace.L then namespace.L = { } end

local L = setmetatable(namespace.L, { __index = function(t, k)
	if k == nil then return "" end
	local v = tostring(k)
	t[k] = v
	return v
end })

------------------------------------------------------------------------

if not namespace.patterns then
	namespace.patterns = {
		"^Equip: I[nm][cp]r[eo][av][se][es]s y?o?u?r? ?(.+) by (%d+)%.", -- catches "Improves" and "Increases"
		"^Equip: Restores (%d+) (health per 5 sec%.)",
		"^Equip: (.+) increased by (%d+)%.",
	}
end

local stat_patterns = namespace.patterns
local stat_strings = namespace.strings

------------------------------------------------------------------------

local stat_names = setmetatable({ }, { __index = function(t, k)
	if type(k) ~= "string" then
		return ""
	end
	local v
	if GAME_LOCALE:match("^[de]") then
		-- de, en: Capitalize each word.
		for word in k:gmatch("%S+") do
			local i, c = 2, word:sub(1, 1)
			if c:byte() > 127 then
				i, c = 3, word:sub(1, 2)
			end
			word = c:upper() .. word:sub(i)
			v = v and (v .. " " .. word) or word
		end
	elseif GAME_LOCALE:match("^[ef][sr]") then
		-- es, fr, it, pt: Lowercase everything.
		v = k:lower()
	else
		v = k
	end
	rawset(t, k, v)
	return v
end })

namespace.names = stat_names

------------------------------------------------------------------------

local ITEM_HEROIC = ITEM_HEROIC
local ITEM_HEROIC_EPIC = ITEM_HEROIC_EPIC
local ITEM_SOCKETABLE = ITEM_SOCKETABLE
local ITEM_SOULBOUND = ITEM_SOULBOUND
local ITEM_VENDOR_STACK_BUY = ITEM_VENDOR_STACK_BUY
local RAID_FINDER = RAID_FINDER
local REFORGED = REFORGED

local S_ARMOR_TEMPLATE = "^" .. ARMOR_TEMPLATE:gsub("%%d", "%%d+") .. "$"
local S_ITEM_CREATED_BY = "^" .. ITEM_CREATED_BY:gsub("%%s", ".+") .. "$"
local S_ITEM_LEVEL = "^" .. ITEM_LEVEL:gsub("%%d", "%%d+") .. "$"
local S_ITEM_MIN_LEVEL = ITEM_MIN_LEVEL:gsub("%%d", "%%d+")
local S_ITEM_REQ_REPUTATION = ITEM_REQ_REPUTATION:gsub("%%s", ".+")
local S_ITEM_REQ_SKILL = ITEM_REQ_SKILL:gsub("%%s", ".+")
local S_ITEM_SOCKET_BONUS = "^" .. ITEM_SOCKET_BONUS:gsub("%%s", ""):trim()
local S_ITEM_SPELL_TRIGGER_ONEQUIP = "^"..ITEM_SPELL_TRIGGER_ONEQUIP -- not used
local S_ITEM_SPELL_TRIGGER_ONPROC = "^"..ITEM_SPELL_TRIGGER_ONPROC
local S_ITEM_SPELL_TRIGGER_ONUSE = "^"..ITEM_SPELL_TRIGGER_ONUSE -- not used

local cache = setmetatable({ }, { __mode = "kv" }) -- weak table to enable garbage collection

local function ReformatItemTooltip(tooltip)
	local tooltipName = tooltip:GetName()
	for i = 2, tooltip:NumLines() do
		local line = _G[tooltipName .. "TextLeft" .. i]
		local text = line:GetText()
		if text then
			if (text == ITEM_HEROIC and settings.hideHeroic)
			or (text == ITEM_SOCKETABLE and settings.hideRightClickSocket)
			or (text == ITEM_SOULBOUND and settings.hideSoulbound)
			or (text == ITEM_VENDOR_STACK_BUY and settings.hideRightClickBuy)
			or (text == REFORGED and settings.hideReforged)
			or (text == RAID_FINDER and settings.hideRaidFinder)
			or (settings.hideItemLevel and text:match(S_ITEM_LEVEL))
			or (settings.hideMadeBy and text:match(S_ITEM_CREATED_BY))
			or (settings.hideRequirements and (text:match(S_ITEM_MIN_LEVEL) or text:match(S_ITEM_REQ_REPUTATION) or text:match(S_ITEM_REQ_SKILL) or text:match(L["Enchantment Requires"]) or text:match(L["Socket Requires"]))) then
				line:SetText("")
			elseif not text:match("<") then
				local r, g, b = line:GetTextColor()
				if r > 0.05 or g < 0.95 or text:match("^%a+:") or text:match(S_ITEM_SPELL_TRIGGER_ONPROC) or text:match(S_ARMOR_TEMPLATE) or text:match(S_ITEM_SOCKET_BONUS) then
					if settings.compactBonuses then
						if cache[text] then
							line:SetText(cache[text])
							line:SetTextColor(0, 1, 0)
						else
							for i, pattern in ipairs(stat_patterns) do
								local stat, value = text:match(pattern)
								if stat then
									if tonumber(stat) then
										stat, value = value, stat
									end
									local str = stat_strings and stat_strings[i] or "+%d %s"
									local result = str:format(value, stat_names[stat] or stat)
									cache[text] = result
									line:SetText(result)
									line:SetTextColor(0, 1, 0)
									break
								end
							end
						end
					end
				else
					line:SetTextColor(unpack(settings.enchantColor))
				end
			end
			tooltip:Show()
		end
	end
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
}

local prehook = GameTooltip_OnTooltipAddMoney

function GameTooltip_OnTooltipAddMoney(...)
	if not settings.hideSellValue then
		return prehook(...)
	end
	for _, frame in pairs(showPriceFrames) do
		if _G[frame]:IsShown() then
			return prehook(...)
		end
	end
end