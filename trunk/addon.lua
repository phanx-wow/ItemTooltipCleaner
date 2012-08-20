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
		"^Equip: I[nm][cp]r[eo][av][se][es]s y?o?u?r? ?(.+) by ([%d,]+)%.", -- catches "Improves" and "Increases"
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

local lineobj, linetext, liner, lineg, lineb = {}, {}, {}, {}, {}

local lineobj_mt = { __index = function(t, i)
	local v = t.name and _G[t.name .. "TextLeft" .. i]
	if v then
		rawset(t, i, v)
		return v
	end
end }

local function ReformatItemTooltip(tooltip)
	local name = tooltip:GetName()
	local numLines = tooltip:GetNumLines()
	local lines = lineobj[tooltipName]

	-- Loop over the tooltip and get all the lines as-is
	for i = 2, numLines do
		linetext[i] = lines[i]:GetText()
		liner[i], lineg[i], lineb[i] = lines[i]:GetTextColor()
	end

	-- Loop over the stored lines and write back the wanted ones
	local line = 2
	for i = 2, numLines do
		local text = linetext[i]

		if text and strlen(text) > 1 then
			if (text == ITEM_HEROIC and settings.hideHeroic)
			or (text == ITEM_SOCKETABLE and settings.hideRightClickSocket)
			or (text == ITEM_SOULBOUND and settings.hideSoulbound)
			or (text == ITEM_VENDOR_STACK_BUY and settings.hideRightClickBuy)
			or (text == REFORGED and settings.hideReforged)
			or (text == RAID_FINDER and settings.hideRaidFinder)
			or (settings.hideItemLevel and text:match(S_ITEM_LEVEL))
			or (settings.hideMadeBy and text:match(S_ITEM_CREATED_BY))
			or (settings.hideRequirements and (text:match(S_ITEM_MIN_LEVEL) or text:match(S_ITEM_REQ_REPUTATION) or text:match(S_ITEM_REQ_SKILL) or text:match(L["Enchantment Requires"]) or text:match(L["Socket Requires"]))) then
				-- hide
			elseif not text:match("<") then
				local r, g, b = liner[i], lineg[i], lineb[i]
				if r > 0.05 or g < 0.95 or text:match("^%a+:") or text:match(S_ITEM_SPELL_TRIGGER_ONPROC) or text:match(S_ARMOR_TEMPLATE) or text:match(S_ITEM_SOCKET_BONUS) then
					if settings.compactBonuses then
						if cache[text] then
							lines[line]:SetText(cache[text])
							lines[line]:SetTextColor(0, 1, 0)
							line = line + 1
						else
							for j, pattern in ipairs(stat_patterns) do
								local stat, value = text:match(pattern)
								if stat then
									if strmatch(value, "[^%d,]") then -- needs localization
										stat, value = gsub(value, ",", ""), stat
									else
										value = gsub(value, ",", "")
									end

									local str = stat_strings and stat_strings[j] or "+%d %s"
									local result = format(str, value, stat_names[stat] or stat)
									cache[text] = result

									lines[line]:SetText(result)
									lines[line]:SetTextColor(0, 1, 0)
									line = line + 1
									break
								end
							end
						end
					end
				else
					lines[line]:SetText(text)
					lines[line]:SetTextColor(unpack(settings.enchantColor))
					line = line + 1
				end
			else
				lines[line]:SetText(text)
				lines[line]:SetTextColor(liner[i], lineg[i], lineb[i])
				line = line + 1
			end
		else
			lines[line]:SetText(" ")
			line = line + 1
		end
	end

	-- Get rid of any empty lines left at the end
	for i = line + 1, numLines do
		lines[i]:SetText(nil)
		lines[i]:Hide()
	end

	-- Redraw the tooltip
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
		lineobj[tooltip] = setmetatable({ name = tooltip }, lineobj_mt })
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