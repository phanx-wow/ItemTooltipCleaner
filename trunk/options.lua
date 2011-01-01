------------------------------------------------------------------------
--	Item Tooltip Cleaner
--	Compacts equipment bonus text and removes extraneous lines from item tooltips.
--	by Akkorian < akkorian@hotmail.com >
--	http://www.wowinterface.com/addons/info-ItemTooltipCleaner.html
--	http://wow.curseforge.com/addons/itemtooltipcleaner/
------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local settings = ns.settings
local L = ns.L

local panel = CreateFrame("Frame")
panel.name = GetAddOnMetadata(ADDON_NAME, "Title")

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

panel:Hide()
panel:SetScript("OnShow", function(self)
	self.CreateCheckbox = LibStub("PhanxConfig-Checkbox").CreateCheckbox
	self.CreateColorPicker = LibStub("PhanxConfig-ColorPicker").CreateColorPicker

	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetPoint("TOPRIGHT", -16, -16)
	title:SetJustifyH("LEFT")
	title:SetText(self.name)

	local notes = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	notes:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	notes:SetPoint("TOPRIGHT", title, 0, -8)
	notes:SetHeight(32)
	notes:SetJustifyH("LEFT")
	notes:SetJustifyV("TOP")
	notes:SetNonSpaceWrap(true)
	notes:SetText( GetAddOnMetadata(ADDON_NAME, "Notes") )

	local colorEnchant = self:CreateColorPicker(L["Enchantment color"])
	colorEnchant:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 4, -12)
	colorEnchant:SetColor( unpack(settings.enchantColor) )
	colorEnchant.GetColor = function()
		return unpack(settings.enchantColor)
	end
	colorEnchant.OnColorChanged = function(self, r, g, b)
		settings.enchantColor[1] = r
		settings.enchantColor[2] = g
		settings.enchantColor[3] = b
	end

	local checkBonus = self:CreateCheckbox(L["Compact equipment bonuses"])
	checkBonus:SetPoint("TOPLEFT", colorEnchant, "BOTTOMLEFT", -3, -10)
	checkBonus:SetChecked(settings.compactBonuses)
	checkBonus.OnClick = function(self, checked)
		settings.compactBonuses = checked
	end

	local checkILevel = self:CreateCheckbox(L["Hide item levels"])
	checkILevel:SetPoint("TOPLEFT", checkBonus, "BOTTOMLEFT", 0, -8)
	checkILevel:SetChecked(settings.hideItemLevel)
	checkILevel.OnClick = function(self, checked)
		settings.hideItemLevel = checked
	end

	local checkBuy = self:CreateCheckbox(L["Hide buying instructions"])
	checkBuy:SetPoint("TOPLEFT", checkILevel, "BOTTOMLEFT", 0, -8)
	checkBuy:SetChecked(settings.hideRightClickBuy)
	checkBuy.OnClick = function(self, checked)
		settings.hideRightClickBuy = checked
	end

	local checkSocket = self:CreateCheckbox(L["Hide socketing instructions"])
	checkSocket:SetPoint("TOPLEFT", checkBuy, "BOTTOMLEFT", 0, -8)
	checkSocket:SetChecked(settings.hideRightClickSocket)
	checkSocket.OnClick = function(self, checked)
		settings.hideRightClickSocket = checked
	end

	local checkMadeBy = self:CreateCheckbox(L["Hide \"Made By\" tags"])
	checkMadeBy:SetPoint("TOPLEFT", checkSocket, "BOTTOMLEFT", 0, -8)
	checkMadeBy:SetChecked(settings.hideMadeBy)
	checkMadeBy.OnClick = function(self, checked)
		settings.hideMadeBy = checked
	end

	local checkSoulbound = self:CreateCheckbox(L["Hide \"Soulbound\" text"])
	checkSoulbound:SetPoint("TOPLEFT", checkMadeBy, "BOTTOMLEFT", 0, -8)
	checkSoulbound:SetChecked(settings.hideSoulbound)
	checkSoulbound.OnClick = function(self, checked)
		settings.hideSoulbound = checked
	end

	self:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(panel)

panel.about = LibStub("LibAboutPanel").new(panel.name, ADDON_NAME)

SLASH_ITEMTOOLTIPCLEANER1 = "/itc"

SlashCmdList["ITEMTOOLTIPCLEANER"] = function()
	InterfaceOptionsFrame_OpenToCategory(panel.about)
	InterfaceOptionsFrame_OpenToCategory(panel)
end