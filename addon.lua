------------------------------------------------------------------------
--	Item Tooltip Cleaner
--	Compacts equipment bonus text and removes extraneous lines from item tooltips.
--	by Akkorian < akkorian@hotmail.com >
--	http://www.wowinterface.com/addons/info-ItemTooltipCleaner.html
--	http://wow.curseforge.com/addons/itemtooltipcleaner/
------------------------------------------------------------------------

local settings = {
	compactBonuses = true,
	enchantColor = { 0, 0.8, 1 },
	hideItemLevel = true,
	hideMadeBy = true,
	hideRightClickBuy = true,
	hideRightClickSocket = true,
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

------------------------------------------------------------------------

local L = setmetatable( {
	["^%d+ Armor$"]     = "^" .. ARMOR_TEMPLATE:replace( "%d", "%d+" ) .. "$",
	["^Item Level %d"]  = "^" .. ITEM_LEVEL:replace( "%d", "%d+" ),
	["^<Made by %S+>$"] = "^" .. ITEM_CREATED_BY:replace( "%s", "%S+" ) .. "$",
	["^Socket Bonus:"]  = "^" .. ITEM_SOCKET_BONUS:replace( "%s", "" ):trim(),
}, {
	__index = function( t, k )
		if k == nil then return "" end
		local v = tostring( k )
		t[ k ] = v
		return v
	end
} )

------------------------------------------------------------------------

local patterns = {
	L["^Equip: Increases y?o?u?r? ?(.+) by (%d+)%.$"],
	L["^Equip: Improves y?o?u?r? ?(.+) by (%d+)%.$"],
	L["^Equip: Restores (%d+) (.+)%.$"],
	L["^Equip: Increases ([dh][ae][ma][al][gi][en]g? done by magical spells and effects) by up to (%d+.)$"],
	L["^Equip: Increases attack power by (%d+) (in Cat, Bear, Dire Bear, and Moonkin forms only).$"],
}

------------------------------------------------------------------------

local names = setmetatable( {
	[L["in Cat, Bear, Dire Bear, and Moonkin forms only"]] = ITEM_MOD_FERAL_ATTACK_POWER_SHORT,

	[L["shield block rating"]] = ITEM_MOD_BLOCK_RATING_SHORT,
	[L["the block value of your shield"]] = ITEM_MOD_BLOCK_VALUE_SHORT,

	[L["damage done by magical spells and effects"]] = ITEM_MOD_SPELL_DAMAGE_DONE_SHORT,
	[L["healing done by magical spells and effects"]] = ITEM_MOD_SPELL_HEALING_DONE_SHORT,

	[L["melee critical avoidance rating"]] = ITEM_MOD_CRIT_TAKEN_MELEE_RATING_SHORT,
	[L["ranged critical avoidance rating"]] = ITEM_MOD_CRIT_TAKEN_RANGED_RATING_SHORT,
	[L["spell critical avoidance rating"]] = ITEM_MOD_CRIT_TAKEN_SPELL_RATING_SHORT,

	[L["melee critical strike rating"]] = ITEM_MOD_CRIT_MELEE_RATING_SHORT,
	[L["ranged critical strike rating"]] = ITEM_MOD_CRIT_RANGED_RATING_SHORT,
	[L["spell critical strike rating"]] = ITEM_MOD_CRIT_SPELL_RATING_SHORT,

	[L["melee haste rating"]] = ITEM_MOD_HASTE_MELEE_RATING_SHORT,
	[L["ranged haste rating"]] = ITEM_MOD_HASTE_RANGED_RATING_SHORT,
	[L["spell haste rating"]] = ITEM_MOD_HASTE_SPELL_RATING_SHORT,

	[L["melee hit avoidance rating"]] = ITEM_MOD_HIT_TAKEN_MELEE_RATING_SHORT,
	[L["ranged hit avoidance rating"]] = ITEM_MOD_HIT_TAKEN_RANGED_RATING_SHORT,
	[L["spell hit avoidance rating"]] = ITEM_MOD_HIT_TAKEN_SPELL_RATING_SHORT,

	[L["melee hit rating"]] = ITEM_MOD_HIT_MELEE_RATING_SHORT,
	[L["ranged hit rating"]] = ITEM_MOD_HIT_RANGED_RATING_SHORT,
	[L["spell hit rating"]] = ITEM_MOD_HIT_SPELL_RATING_SHORT,
}, {
	__index = function( t, k )
		if k == nil then return "" end
		local v = k:gsub( "(%l)", string.upper, 1 ):gsub( "( %l)", string.upper )
		t[ k ] = v
		return v
	end
} )

------------------------------------------------------------------------

local cache = setmetatable( { }, { __mode = "kv" } ) -- weak table to enable garbage collection

local function ReformatItemTooltip( tooltip )
	local tooltipName = tooltip:GetName()
	for i = 2, tooltip:NumLines() do
		local line = _G[ tooltipName .. "TextLeft" .. i ]
		local text = line:GetText()
		if text and text ~= ITEM_HEROIC and text ~= ITEM_HEROIC_EPIC then
			if ( text == ITEM_SOCKETABLE and settings.hideRightClickSocket ) or ( text == ITEM_VENDOR_STACK_BUY and settings.hideRightClickBuy ) or (settings.hideItemLevel and text:match( L["^Item Level %d"] ) ) or ( settings.hideMadeBy and text:match( L["^<Made by %S+>$"] ) ) then
				line:SetText( "" )
			else
				local r, g, b = line:GetTextColor()
				if r < 0.05 and g > 0.95 and not text:match( "^%a+:" ) and not text:match( L["^%d+ Armor$"] ) and not text:match( L["^Socket Bonus:"] ) then
					line:SetTextColor( unpack( settings.enchantColor ) )
				elseif settings.compactBonuses then
					if cache[ text ] then
						line:SetText( cache[ text ] )
						line:SetTextColor( 0.2, 1, 0.2 )
					else
						for _, pattern in ipairs( patterns ) do
							local stat, value = text:match( pattern )
							if stat then
								if tonumber( stat ) then
									stat, value = value, stat
								end
								local result = string.format( "+%d %s", value, names[ stat ] or stat )
								cache[ text ] = result
								line:SetText( result )
								line:SetTextColor( 0.2, 1, 0.2 )
								break
							end
						end
					end
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

local _, ns = ...
ns.settings = settings
ns.L = L