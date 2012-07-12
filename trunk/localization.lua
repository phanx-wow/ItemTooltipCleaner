--[[--------------------------------------------------------------------
	Item Tooltip Cleaner
	Compacts equipment bonus text and removes extraneous lines from item tooltips.
	Copyright (c) 2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/addons/info19129-ItemTooltipCleaner.html
	http://www.curse.com/addons/wow/itemtooltipcleaner
----------------------------------------------------------------------]]

local GAME_LOCALE = GetLocale()
if GAME_LOCALE:match( "^en" ) then return end

local ADDON_NAME, namespace = ...

------------------------------------------------------------------------
--	German | Deutsch
--	Last updated 2011-02-16 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "deDE" then

	namespace.L = {
	--	["Enchantment color"] = "",
	--	["Compact equipment bonuses"] = "",
	--	["Hide item levels"] = "",
	--	["Hide buying instructions"] = "",
	--	["Hide socketing instructions"] = "",
	--	["Hide \"Made By\" lines"] = "",
	--	["Hide \"Raid Finder\" lines"] = "",
	--	["Hide \"Soulbound\" lines"] = "",
	--	["Hide vendor values"] = "",
	--	["Hide vendor values, except while interacting with a vendor."] = "",
	}

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
--	Spanish | Español
--	Last updated 2011-03-01 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "esES" or GAME_LOCALE == "esMX" then

	namespace.L = {
		["Enchantment color"] = "Color de encantamientos",
		["Compact equipment bonuses"] = "Compacto texto de bonos equipos",
		["Hide item levels"] = "Ocultar niveles de objecto",
		["Hide buying instructions"] = "Ocultar instrucciones para comprar",
		["Hide socketing instructions"] = "Ocultar instrucciones para insertar gemas",
		["Hide \"Made By\" lines"] = "Ocultar \"Hecho por...\"",
		["Hide \"Raid Finder\" lines"] = "Ocultar \"Buscador de bandas\"",
		["Hide \"Soulbound\" lines"] = "Ocultar \"Ligado\"",
		["Hide vendor values"] = "Ocultar precio de venta",
		["Hide vendor values, except while interacting with a vendor."] = "Ocultar precio de venta, excepto cuando interactúan con un vendedor.",
	}

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

return end

------------------------------------------------------------------------
--	French | Français
--	Last updated 2011-02-16 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "frFR" then

	namespace.L = {
	--	["Enchantment color"] = "",
	--	["Compact equipment bonuses"] = "",
	--	["Hide item levels"] = "",
	--	["Hide buying instructions"] = "",
	--	["Hide socketing instructions"] = "",
	--	["Hide \"Made By\" lines"] = "",
	--	["Hide \"Raid Finder\" lines"] = "",
	--	["Hide \"Soulbound\" lines"] = "",
	--	["Hide vendor values"] = "",
	--	["Hide vendor values, except while interacting with a vendor."] = "",
	}

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
--	Italian | Italiano
--	Last updated YYYY-MM-DD
------------------------------------------------------------------------

if GAME_LOCALE == "itIT" then

	namespace.L = {
	--	["Enchantment color"] = "",
	--	["Compact equipment bonuses"] = "",
	--	["Hide item levels"] = "",
	--	["Hide buying instructions"] = "",
	--	["Hide socketing instructions"] = "",
	--	["Hide \"Made By\" lines"] = "",
	--	["Hide \"Raid Finder\" lines"] = "",
	--	["Hide \"Soulbound\" lines"] = "",
	--	["Hide vendor values"] = "",
	--	["Hide vendor values, except while interacting with a vendor."] = "",
	}

	namespace.patterns = {
	}

	namespace.strings = {
	}

return end

------------------------------------------------------------------------
--	Portuguese | Português
--	Last updated 2011-12-11 by Phanx
------------------------------------------------------------------------

if GAME_LOCALE == "ptBR" then

	namespace.L = {
		["Enchantment color"] = "Cor do encantamentos",
		["Compact equipment bonuses"] = "Encurtar bônus de equipamentos",
		["Hide item levels"] = "Ocultar níveis de itens",
		["Hide buying instructions"] = "Ocultar instruções para comprar",
		["Hide socketing instructions"] = "Ocultar instruções para engastar",
		["Hide \"Made By\" lines"] = "Ocultar \"Criado por\" linhas",
		["Hide \"Raid Finder\" lines"] = "Ocultar \"Localizador de Raides\" linhas",
		["Hide \"Soulbound\" lines"] = "Ocultar \"Vinculado\" linhas",
		["Hide vendor values"] = "Esconder preço de venda",
		["Hide vendor values, except while interacting with a vendor."] = "Ocultar preço de venda, exceto quando interagem com um vendedor.",
	}

	namespace.patterns = {
		"^Equipado: Aumenta [ao] ?s?u?a?( ?[ct][ha][ax][na]c?e? ?d?e? .+) em (%d+).",
		"^Equipado: [AM][ue][ml][eh][no][tr]a o (.+) em até (%d+).",
		"^Equipado: Recupera (%d+) ?p?o?n?t?o?s? de (.+) por 5 segundos.",
	}

	namespace.strings = {
		"+%d %s",
		"+%d %s",
		"+%d pontos de %s toutes les 5 sec.",
	}

return end

------------------------------------------------------------------------
--	Russian | Русский
--	Last updated 2011-03-03 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "ruRU" then

	namespace.L = {
	--	["Enchantment color"] = "",
	--	["Compact equipment bonuses"] = "",
	--	["Hide item levels"] = "",
	--	["Hide buying instructions"] = "",
	--	["Hide socketing instructions"] = "",
	--	["Hide \"Made By\" lines"] = "",
	--	["Hide \"Raid Finder\" lines"] = "",
	--	["Hide \"Soulbound\" lines"] = "",
	--	["Hide vendor values"] = "",
	--	["Hide vendor values, except while interacting with a vendor."] = "",
	}

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
--	Korean | 한국어
--	Last updated 2011-03-03 by Akkorian
------------------------------------------------------------------------

if GAME_LOCALE == "koKR" then

	namespace.L = {
	--	["Enchantment color"] = "",
	--	["Compact equipment bonuses"] = "",
	--	["Hide item levels"] = "",
	--	["Hide buying instructions"] = "",
	--	["Hide socketing instructions"] = "",
	--	["Hide \"Made By\" lines"] = "",
	--	["Hide \"Raid Finder\" lines"] = "",
	--	["Hide \"Soulbound\" lines"] = "",
	--	["Hide vendor values"] = "",
	--	["Hide vendor values, except while interacting with a vendor."] = "",
	}

	namespace.patterns = {
		"^착용 효과: (.+)가 (%d+)만큼 증가합니다.",
		"^착용 효과: (.+)이 (%d+)만큼 증가합니다.", -- maybe can be combined with #1, depending on how string.match works in koKR?
		"^착용 효과: 매 5초마다 (%d+)의 (.+)을 회복합니다.",
		"^착용 효과: (.+) (%d+)만큼 증가합니다.",
	}

	namespace.strings = {
		"+%d %s",
		"+%d %s",
		"+%d 5초당 %s",
		"+%d %s",
	}

return end

------------------------------------------------------------------------
--	Traditional Chinese |
--	Last updated 2012-02-26 by Phanx
------------------------------------------------------------------------

if GAME_LOCALE == "zhCN" then

	namespace.L = {
	--	["Enchantment color"] = "",
	--	["Compact equipment bonuses"] = "",
	--	["Hide item levels"] = "",
	--	["Hide buying instructions"] = "",
	--	["Hide socketing instructions"] = "",
		["Hide \"Made By\" lines"] = "隐藏\"由谁制造\"标签",
	--	["Hide \"Raid Finder\" lines"] = "",
	--	["Hide \"Soulbound\" lines"] = "",
	--	["Hide vendor values"] = "",
	--	["Hide vendor values, except while interacting with a vendor."] = "",
	}

	namespace.patterns = {
	}

	namespace.strings = {
	}

return end

------------------------------------------------------------------------
--	Simplified Chinese | 繁體中文
--	Last updated 2012-02-26 by Phanx
------------------------------------------------------------------------

if GAME_LOCALE == "zhTW" then

	namespace.L = {
	--	["Enchantment color"] = "",
	--	["Compact equipment bonuses"] = "",
	--	["Hide item levels"] = "",
	--	["Hide buying instructions"] = "",
	--	["Hide socketing instructions"] = "",
	--	["Hide \"Made By\" lines"] = "",
	--	["Hide \"Raid Finder\" lines"] = "",
	--	["Hide \"Soulbound\" lines"] = "",
	--	["Hide vendor values"] = "",
	--	["Hide vendor values, except while interacting with a vendor."] = "",
	}

	namespace.patterns = {
		"^裝備:%s*提高(%d+)點(.+)。", -- Improves by (%d+) points your (.+).
		"^裝備:%s*使你的(.+)提高(%d+)點。", -- Improves your (.+) by (%d+) points.
		"^裝備:%s*使你的(.+)提高(%d+)。", -- Mastery rating
		"^裝備:%s*每5秒恢復(%d+)點生命力。", -- Restores (%d+) health per 5 seconds.
		"^裝備:%s*每5秒恢復(%d+)生命力。",
		"^裝備:%s*每5秒恢復(%d+)點法力。", -- Restores (%d+) mana per 5 seconds.
	}

	namespace.strings = {
		"+%d %s",
		"+%d %s",
		"+%d %s",
		"+%d 生命力每5秒",
		"+%d 生命力每5秒",
		"+%d 法力每5秒",
	}

return end