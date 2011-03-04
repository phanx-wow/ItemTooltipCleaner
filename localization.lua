------------------------------------------------------------------------
--	Item Tooltip Cleaner
--	Compacts equipment bonus text and removes extraneous lines from item tooltips.
--	by Akkorian <akkorian@hotmail.com>
--	Copyright © 2010–2011. Some rights reserved. See LICENSE.txt for details.
--	http://www.wowinterface.com/addons/info-ItemTooltipCleaner.html
--	http://wow.curseforge.com/addons/itemtooltipcleaner/
------------------------------------------------------------------------

local ADDON_NAME, namespace = ...
local GAME_LOCALE = GetLocale()
namespace.GAME_LOCALE = GAME_LOCALE
if GAME_LOCALE:match( "^en" ) then return end

------------------------------------------------------------------------
--	Deutsch
--	Last updated 2011-02-16 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "deDE" then

	namespace.patterns = {
		"^Anlegen: Erhöht ?[Ed]?[uei]?[rne]?e? (.+) um (%d+).", -- "Eure" or "den" or "die"
		"^Anlegen: Stellt alle 5 Sek. (%d+) (.+) wieder her.",
		"^Anlegen: (.+) um (%d+) erhöht.",
	}

	namespace.strings = {
		"+%d %s",
		"+%d %s pro 5 Sek.",
		"+%d %s",
	}

return end

------------------------------------------------------------------------
--	Español (EU) y Español (LA)
--	Last updated 2011-03-01 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "esES" or GAME_LOCALE == "esMX" then

	namespace.patterns = {
		"^Equipar: [AM][ue][mj][eo][rn]t?a [tel][ula] (.+) (%d+) p.", -- "Aumentar" or "Mejora", "tu" or "el" or "la"
		"^Equipar: Restaura (%d+) p. de (salud cada 5 s)",
		"^Equipar: (.+) aumentada (%d+) p.",
	}

	namespace.strings = {
		"+%d %s",
		"+%d salud cada 5 s",
		"+%d habilidad de %s",
	}

	namespace.L = {
		["Enchantment color"] = "Color de encantamientos",
		["Compact equipment bonuses"] = "Compacto texto de bonos equipos",
		["Hide item levels"] = "Ocultar niveles de objecto",
		["Hide buying instructions"] = "Ocultar instrucciones para comprar",
		["Hide socketing instructions"] = "Ocultar instrucciones para insertar gemas",
		["Hide \"Made By\" tags"] = "Ocultar líneas con \"Hecho por...\"",
		["Hide \"Soulbound\" lines"] = "Ocultar líneas con \"Ligado\"",
		["Hide vendor values"] = "Ocultar orecio de venta",
		["Hide vendor values, except while interacting with a vendor."] = "Ocultar orecio de venta, excepto cuando interactúan con un vendedor.",
	}

return end

------------------------------------------------------------------------
--	Français
--	Last updated 2011-02-16 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "frFR" then

	namespace.patterns = {
		"^Équipé : Augmente [dlv][eao]t?r?e? (.+) de (%d+).", -- "de" or "la" or "votre"
		"^Équipé : Augmente de (%d+) le (.+).",
		"^Équipé : Rend (%d+) points de (vie toutes les 5 secondes).",
		"^Équipé : (.+) augmentée de (%d+).",
	}

	namespace.strings = {
		"+%d au %s",
		"+%d au %s",
		"+%d Points de vie toutes les 5 sec.",
		"+%d au %s",
	}

return end

------------------------------------------------------------------------
--	Русский
--	Last updated 2011-03-03 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "ruRU" then

	namespace.patterns = {
		"^Если на персонаже: Рейтинг (.+) +(%d+).",
		"^Если на персонаже: Увеличивает силу (.+) на %d.",
		"^Если на персонаже: Увеличивает (проникающую способность заклинаний) на %d.",
		"^Если на персонаже: Вос%S+ (%d+) ?е?д?.? (здоровья раз) в 5 секу?н?д?.",
		"^Если на персонаже: Навык (.+) увеличивается на (%d+).",
	}

	namespace.strings = {
		"+%d к рейтингу %s",
		"+%d к силе %s",
		"+%d проникающая способность заклинаний",
		"+%d здоровья в 5 сек.",
		"+%d к навыка %s",
	}

return end

------------------------------------------------------------------------
--	한국어
--	Last updated 2011-03-03 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "koKR" then

	namespace.patterns = {
		"^착용 효과: (.+)가 (%d+)만큼 증가합니다.",
		"^착용 효과: (.+)이 (%d+)만큼 증가합니다.", -- maybe can be combined with #1, depending on how string.match works in koKR?
		"^착용 효과: 매 5초마다 (%d+)의 (.+)을 회복합니다.",
		"^%착용 효과: (.+) (%d+)만큼 증가합니다.",
	}

	namespace.strings = {
		"+%d %s",
		"+%d %s",
		"+%d 5초당 %s",
		"+%d %s",
	}

return end

------------------------------------------------------------------------
--	繁體中文
--	Last updated 2011-03-03 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "zhTW" then

	namespace.patterns = {
		"^裝備:%s*提高(%d+)點(.+)。",
		"^裝備:%s*使你的(.+)提高(%d+)",
		"^裝備:%s*(每5秒恢復)(%d+)",
		"^裝備:%s*(.+)提高30點。",
	}

	namespace.strings = {
		"+%d %s",
		"+%d %s",
		"+%d 生命力每5秒",
		"+%d %s",
	}

return end