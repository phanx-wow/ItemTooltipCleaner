------------------------------------------------------------------------
--	Item Tooltip Cleaner
--	Compacts equipment bonus text and removes extraneous lines from item tooltips.
--	by Akkorian < akkorian@hotmail.com >
--	Maintained by Phanx < addons@phanx.net >
--	Copyright © 2010–2011. Some rights reserved. See LICENSE.txt for details.
--	http://www.wowinterface.com/addons/info-ItemTooltipCleaner.html
--	http://wow.curseforge.com/addons/itemtooltipcleaner/
------------------------------------------------------------------------

local ADDON_NAME, namespace = ...
local settings = namespace.settings
local L = namespace.L

local panel = LibStub( "PhanxConfig-OptionsPanel" ).CreateOptionsPanel( ADDON_NAME )

panel:RegisterEvent( "ADDON_LOADED" )
panel:SetScript( "OnEvent", function( self, event, addon )
	if addon ~= ADDON_NAME then return end

	if ItemTooltipCleanerSettings then
		for k, v in pairs( settings ) do
			if type( v ) ~= type( ItemTooltipCleanerSettings[ k ] ) then
				ItemTooltipCleanerSettings[ k ] = v
			end
		end
		for k, v in pairs( ItemTooltipCleanerSettings ) do
			settings[ k ] = v
		end
	end
	ItemTooltipCleanerSettings = settings

	local stat_names = namespace.names
	local stat_patterns = namespace.patterns
--[[
	for k, v in pairs( _G ) do
		if type( v ) == "string" and v:match( "%%d" ) and k:match( "^ITEM_MOD" ) and not k:match( "_SHORT$" ) then
			local str = v:gsub( "%%d", 13 )
			for i, pattern in ipairs( stat_patterns ) do
				local stat, amount = str:match( pattern:gsub( "^" .. ITEM_SPELL_TRIGGER_ONEQUIP, "" ):trim() )
				if stat and amount then
					if stat == "13" then stat = amount end
					stat_names[ stat ] = _G[ k .. "_SHORT" ]
				end
			end
		end
	end
--]]
	self:UnregisterAllEvents()
	self:SetScript( "OnEvent", nil )
end )

panel.runOnce = function( self )
	local title, notes = LibStub( "PhanxConfig-Header" ).CreateHeader( self, ADDON_NAME, GetAddOnMetadata( ADDON_NAME, "Notes" ) )

	local colorEnchant = LibStub( "PhanxConfig-ColorPicker" ).CreateColorPicker( self, L["Enchantment color"] )
	colorEnchant:SetPoint( "TOPLEFT", notes, "BOTTOMLEFT", 4, -12 )
	colorEnchant:SetColor( unpack( settings.enchantColor ) )
	colorEnchant.GetColor = function()
		return unpack( settings.enchantColor )
	end
	colorEnchant.OnColorChanged = function( self, r, g, b )
		settings.enchantColor[ 1 ] = r
		settings.enchantColor[ 2 ] = g
		settings.enchantColor[ 3 ] = b
	end

	local CreateCheckbox = LibStub( "PhanxConfig-Checkbox" ).CreateCheckbox
	local function OnClick( self, checked )
		settings[ self.key ] = checked
	end

	local checkBonus = CreateCheckbox( self, L["Compact equipment bonuses"] )
	checkBonus:SetPoint( "TOPLEFT", colorEnchant, "BOTTOMLEFT", -3, -10 )
	checkBonus.OnClick = OnClick
	checkBonus.key = "compactBonuses"

	local checkILevel = CreateCheckbox( self, L["Hide item levels"] )
	checkILevel:SetPoint( "TOPLEFT", checkBonus, "BOTTOMLEFT", 0, -8 )
	checkILevel.OnClick = OnClick
	checkILevel.key = "hideItemLevel"

	local checkBuy = CreateCheckbox( self, L["Hide buying instructions"] )
	checkBuy:SetPoint( "TOPLEFT", checkILevel, "BOTTOMLEFT", 0, -8 )
	checkBuy.OnClick = OnClick
	checkBuy.key = "hideRightClickBuy"

	local checkSocket = CreateCheckbox( self, L["Hide socketing instructions"] )
	checkSocket:SetPoint( "TOPLEFT", checkBuy, "BOTTOMLEFT", 0, -8 )
	checkSocket.OnClick = OnClick
	checkSocket.key = "hideRightClickSocket"

	local checkMadeBy = CreateCheckbox( self, L["Hide \"Made By\" tags"] )
	checkMadeBy:SetPoint( "TOPLEFT", checkSocket, "BOTTOMLEFT", 0, -8 )
	checkMadeBy.OnClick = OnClick
	checkMadeBy.key = "hideMadeBy"

	local checkSoulbound = CreateCheckbox( self, L["Hide \"Soulbound\" lines"] )
	checkSoulbound:SetPoint( "TOPLEFT", checkMadeBy, "BOTTOMLEFT", 0, -8 )
	checkSoulbound.OnClick = OnClick
	checkSoulbound.key = "hideSoulbound"

	local checkValue = CreateCheckbox( self, L["Hide vendor values"], L["Hide vendor values, except while interacting with a vendor."] )
	checkValue:SetPoint( "TOPLEFT", checkSoulbound, "BOTTOMLEFT", 0, -8 )
	checkValue.OnClick = OnClick
	checkValue.key = "hideSellValue"

	self.refresh = function( self )
		checkBonus:SetChecked( settings.compactBonuses )
		checkILevel:SetChecked( settings.hideItemLevel )
		checkBuy:SetChecked( settings.hideRightClickBuy )
		checkSocket:SetChecked( settings.hideRightClickSocket )
		checkMadeBy:SetChecked( settings.hideMadeBy )
		checkSoulbound:SetChecked( settings.hideSoulbound )
		checkValue:SetChecked( settings.hideSellValue )
	end
end

local about = LibStub( "LibAboutPanel" ).new( ADDON_NAME, ADDON_NAME )

SLASH_ITEMTOOLTIPCLEANER1 = "/itc"

SlashCmdList["ITEMTOOLTIPCLEANER"] = function()
	InterfaceOptionsFrame_OpenToCategory( about )
	InterfaceOptionsFrame_OpenToCategory( panel )
end