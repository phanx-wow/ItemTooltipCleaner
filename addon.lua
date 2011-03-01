------------------------------------------------------------------------
--	Item Tooltip Cleaner
--	Compacts equipment bonus text and removes extraneous lines from item tooltips.
--	by Akkorian < akkorian@hotmail.com >
--	Copyright © 2010–2011. Some rights reserved. See LICENSE.txt for details.
--	http://www.wowinterface.com/addons/info-ItemTooltipCleaner.html
--	http://wow.curseforge.com/addons/itemtooltipcleaner/
------------------------------------------------------------------------

local ADDON_NAME, namespace = ...

------------------------------------------------------------------------

local settings = {
	compactBonuses = true,
	enchantColor = { 0, 0.8, 1 },
	hideItemLevel = true,
	hideMadeBy = true,
	hideRightClickBuy = true,
	hideRightClickSocket = true,
	hideSellValue = false,
	hideSoulbound = false,
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

local L = setmetatable( namespace.L, {
	__index = function( t, k )
		if k == nil then return "" end
		local v = tostring( k )
		t[ k ] = v
		return v
	end
} )

L["^%d+ Armor$"]     = "^" .. ARMOR_TEMPLATE:replace( "%d", "%d+" ) .. "$"
L["^Chance on hit:"] = "^" .. ITEM_SPELL_TRIGGER_ONPROC
L["^Item Level %d"]  = "^" .. ITEM_LEVEL:replace( "%d", "%d+" )
L["^<Made by %S+>$"] = "^" .. ITEM_CREATED_BY:replace( "%s", "%S+" ) .. "$"
L["^Socket Bonus:"]  = "^" .. ITEM_SOCKET_BONUS:replace( "%s", "" ):trim()

------------------------------------------------------------------------

local stat_patterns = namespace.stat_patterns or {
	"^Equip: I[nm][cp]r[eo][av][se][es]s y?o?u?r? ?(.+) by (%d+)%.", -- catches "Improves" and "Increases"
	"^Equip: (.+) increased by (%d+)%.",
}

------------------------------------------------------------------------

local uppercase = namespace.uppercase or string.upper

local stat_names = setmetatable( { }, {
	__index = function( t, k )
		if k == nil then return "" end
		local v = k:gsub( "^(%l)", uppercase, 1 ):gsub( "( %l)", uppercase )
		rawset( t, k, v )
		return v
	end
} )

------------------------------------------------------------------------

local ITEM_HEROIC = ITEM_HEROIC
local ITEM_HEROIC_EPIC = ITEM_HEROIC_EPIC
local ITEM_SOCKETABLE = ITEM_SOCKETABLE
local ITEM_SOULBOUND = ITEM_SOULBOUND
local ITEM_VENDOR_STACK_BUY = ITEM_VENDOR_STACK_BUY

local cache = setmetatable( { }, { __mode = "kv" } ) -- weak table to enable garbage collection

local function ReformatItemTooltip( tooltip )
	local tooltipName = tooltip:GetName()
	for i = 2, tooltip:NumLines() do
		local line = _G[ tooltipName .. "TextLeft" .. i ]
		local text = line:GetText()
		if text and text ~= ITEM_HEROIC and text ~= ITEM_HEROIC_EPIC then
			if ( text == ITEM_SOULBOUND and settings.hideSoulbound ) or ( text == ITEM_SOCKETABLE and settings.hideRightClickSocket ) or ( text == ITEM_VENDOR_STACK_BUY and settings.hideRightClickBuy ) or ( settings.hideItemLevel and text:match( L["^Item Level %d"] ) ) or ( settings.hideMadeBy and text:match( L["^<Made by %S+>$"] ) ) then
				line:SetText( "" )
			else
				local r, g, b = line:GetTextColor()
				if r > 0.05 or g < 0.95 or text:match( "^%a+:" ) or text:match( L["^Chance on hit:"] ) or text:match( L["^%d+ Armor$"] ) or text:match( L["^Socket Bonus:"] ) then
					if settings.compactBonuses then
						if cache[ text ] then
							line:SetText( cache[ text ] )
							line:SetTextColor( 0, 1, 0 )
						else
							for _, pattern in ipairs( stat_patterns ) do
								local stat, value = text:match( pattern )
								if stat then
									if tonumber( stat ) then
										stat, value = value, stat
									end
									local result = string.format( "+%d %s", value, stat_names[ stat ] or stat )
									cache[ text ] = result
									line:SetText( result )
									line:SetTextColor( 0, 1, 0 )
									break
								end
							end
						end
					end
				else
					line:SetTextColor( unpack( settings.enchantColor ) )
				end
			end
			tooltip:Show()
		end
	end
end

for _, tooltip in pairs( {
	"GameTooltip",
	"ItemRefTooltip",
	"ShoppingTooltip1",
	"ShoppingTooltip2",
} ) do
	if _G[ tooltip ] then
		_G[ tooltip ]:HookScript( "OnTooltipSetItem", ReformatItemTooltip )
	end
end

------------------------------------------------------------------------

local prehook = GameTooltip_OnTooltipAddMoney

function GameTooltip_OnTooltipAddMoney( ... )
	if settings.hideSellValue and not MerchantFrame:IsShown() then
		return
	end
	return prehook( ... )
end

THE_ALPHABET = "а б в г д е ё ж з и й к л м н о п р с т у ф х ц ч ш щ ъ ы ь э ю я"