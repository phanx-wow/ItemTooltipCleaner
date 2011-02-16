------------------------------------------------------------------------
--	Item Tooltip Cleaner
--	Compacts equipment bonus text and removes extraneous lines from item tooltips.
--	by Akkorian <akkorian@hotmail.com>
--	http://www.wowinterface.com/addons/info-ItemTooltipCleaner.html
--	http://wow.curseforge.com/addons/itemtooltipcleaner/
------------------------------------------------------------------------

local ADDON_NAME, namespace = ...
local GAME_LOCALE = GetLocale()
if GAME_LOCALE:match( "^en" ) then return end

------------------------------------------------------------------------
--	Deutsch
--	Last updated 2011-02-16 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "deDE" then

	namespace.patterns = {
		"^Anlegen: Erhöht ?E?u?r?e? (.+) um (%d+).",
		"^Anlegen: (.+) um (%d+) erhöht.",
	}

return end

------------------------------------------------------------------------
--	Español (EU) y Español (LA)
--	Last updated 2011-02-16 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "esES" or GAME_LOCALE == "esMX" then

	namespace.patterns = {
		"^Equipar: [AM][ue][mj][eo][nr][ta]a? [ets][lu] (.+) (%d+) p.", -- captura "Aumentar" y "Mejora", y "el" y "tu" y "su"
		"^Equipar: (.+) aumendata (%d+) p.",
	}

return end

------------------------------------------------------------------------
--	Français
--	Last updated 2011-02-16 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "frFR" then

	namespace.patterns = {
		"^Équipé : Augmente de (%d+) le (.+).",
		"^Équipé : Augmente votre (.+) de (%d+).",
		"^Équipé : (.+) augmentée de (%d+)."
	}

return end