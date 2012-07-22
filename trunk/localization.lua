--[[--------------------------------------------------------------------
	Item Tooltip Cleaner
	Compacts equipment bonus text and removes extraneous lines from item tooltips.
	Copyright (c) 2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/addons/info19129-ItemTooltipCleaner.html
	http://www.curse.com/addons/wow/itemtooltipcleaner
----------------------------------------------------------------------]]

local GAME_LOCALE = GetLocale()
if GAME_LOCALE:match("^en") then return end

local ADDON_NAME, namespace = ...

------------------------------------------------------------------------
--	German | Deutsch
--	Last updated 2012-07-21 by Phanx
------------------------------------------------------------------------

if GAME_LOCALE == "deDE" then

	namespace.L = {
		["Enchantment Requires"] = "Verzauberung benötigt",
		["Socket Requires"] = "Sockel benötigt",

		["Enchantment color"] = "Verzauberungenfarbe",
		["Compact equipment bonuses"] = "Boni auf Ausrüstung verkürzen",
		["Hide item levels"] = "Gegenstandsstufen ausblenden",
		["Hide equipment sets"] = "Ausrüstungssets ausblenden",
		["Hide \"%s\" lines"] = "Etikett '%s' ausblenden",
		["Made by"] = "Hergestellt von",
		["Hide requirements"] = "Anforderungen ausblenden",
		["Hide level, reputation, and skill requirements for items, enchantements, and sockets."] = "Blenden Sie die Anforderungen an Stufe, Ruf und Fertigkeit, für Gegenstände, Verzauberungen und Sockel.",
		["Hide buying instructions"] = "Instruktionen zum Kauf ausblenden",
		["Hide socketing instructions"] = "Instruktionen zum Sockeln ausblenden",
		["Hide vendor values"] = "Händlerpreis ausblenden",
		["Hide vendor values, except while interacting with a vendor."] = "Händlerpreis ausblenden, außer wenn der Händlerfenster angezeigt wird.",
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
--	Last updated 2012-07-21 by Phanx
------------------------------------------------------------------------

if GAME_LOCALE == "esES" or GAME_LOCALE == "esMX" then

	namespace.L = {
		["Enchantment Requires"] = "Encantamiento requiere",
		["Socket Requires"] = "Ranura requiere",

		["Enchantment color"] = "Color de encantamientos",
		["Compact equipment bonuses"] = "Compacto texto de bonos equipos",
		["Hide item levels"] = "Ocultar niveles de objecto",
		["Hide equipment sets"] = "Ocultar equipamientos",
		["Hide \"%s\" lines"] = "Ocultar texto: %s",
		["Made by"] = "Hecho por",
		["Hide requirements"] = "Ocultar requerimientos",
		["Hide level, reputation, and skill requirements for items, enchantements, and sockets."] = "Ocultar los requerimientos de nivel, reputación y habilidad para objetos, encantamientos y ranuras.",
		["Hide buying instructions"] = "Ocultar instrucciones para comprar",
		["Hide socketing instructions"] = "Ocultar instrucciones para insertar gemas",
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
--	Last updated YYYY-MM-DD by NAME
------------------------------------------------------------------------

if GAME_LOCALE == "frFR" then

	namespace.L = {
		["Enchantment Requires"] = "L'enchantement requiert",
		["Socket Requires"] = "Le sertissage requiert",

	--	["Enchantment color"] = "",
	--	["Compact equipment bonuses"] = "",
	--	["Hide item levels"] = "",
	--	["Hide equipment sets"] = "",
	--	["Hide \"%s\" lines"] = "",
		["Made by"] = "Artisan",
	--	["Hide requirements"] = "",
	--	["Hide level, reputation, and skill requirements for items, enchantements, and sockets."] = "",
	--	["Hide buying instructions"] = "",
	--	["Hide socketing instructions"] = "",
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
		"+%d de vie toutes les 5 s",
		"+%d au %s",
	}

return end

------------------------------------------------------------------------
--	Italian | Italiano
--	Last updated YYYY-MM-DD by NAME
------------------------------------------------------------------------

if GAME_LOCALE == "itIT" then

	namespace.L = {
		["Enchantment Requires"] = "L'incantamento richiede",
		["Socket Requires"] = "L'incavo richiede",

	--	["Enchantment color"] = "",
	--	["Compact equipment bonuses"] = "",
	--	["Hide item levels"] = "",
	--	["Hide equipment sets"] = "",
	--	["Hide \"%s\" lines"] = "",
		["Made by"] = "Creazione di",
	--	["Hide requirements"] = "",
	--	["Hide level, reputation, and skill requirements for items, enchantements, and sockets."] = "",
	--	["Hide buying instructions"] = "",
	--	["Hide socketing instructions"] = "",
	--	["Hide vendor values"] = "",
	--	["Hide vendor values, except while interacting with a vendor."] = "",
	}

	namespace.patterns = {
		"^Equipaggia: Aumenta l['a] ?(.+) di (%d+).", -- "l'" "la "
		"^Equipaggia: Aumenta (i danni) e gli effetti magici fino a (%d+).",
		"^Equipaggia: Ripristina (%d+) (.+) ogni 5 s.",
	}

	namespace.strings = {
		"+%d %s",
		"+%d Bonus ai danni",
		"+%d %s ogni 5 s"
	}

return end

------------------------------------------------------------------------
--	Portuguese | Português
--	Last updated 2011-12-11 by Phanx
------------------------------------------------------------------------

if GAME_LOCALE == "ptBR" then

	namespace.L = {
		["Enchantment Requires"] = "Encantamento requer",
		["Socket Requires"] = "Engaste requer",

		["Enchantment color"] = "Cor do encantamentos",
		["Compact equipment bonuses"] = "Encurtar bônus de equipamentos",
		["Hide equipment sets"] = "Ocultar conjunto de equipamentos",
		["Hide item levels"] = "Ocultar níveis de itens",
		["Hide \"%s\" lines"] = "Ocultar texto: %s",
		["Made by"] = "Criado por",
		["Hide requirements"] = "Ocultar requisitos",
		["Hide level, reputation, and skill requirements for items, enchantements, and sockets."] = "Ocultar os requisitos de nível, reputação e habilidade para os itens, encantamentos e engastes.",
		["Hide buying instructions"] = "Ocultar instruções para comprar",
		["Hide socketing instructions"] = "Ocultar instruções para engastar",
		["Hide vendor values"] = "Esconder preço de venda",
		["Hide vendor values, except while interacting with a vendor."] = "Ocultar preço de venda, exceto quando interagem com um vendedor.",
	}

	namespace.patterns = {
		"^Equipado: Aumenta [ao] ?s?u?a?(?[ct][ha][ax][na]c?e? ?d?e? .+) em (%d+).",
		"^Equipado: [AM][ue][ml][eh][no][tr]a o (.+) em até (%d+).",
		"^Equipado: Recupera (%d+) ?p?o?n?t?o?s? de (.+) por 5 segundos.",
	}

	namespace.strings = {
		"+%d %s",
		"+%d %s",
		"+%d %s por 5 s",
	}

return end

------------------------------------------------------------------------
--	Russian | Русский
--	Last updated YYYY-MM-DD by NAME
------------------------------------------------------------------------

if GAME_LOCALE == "ruRU" then

	namespace.L = {
		["Enchantment Requires"] = "Для наложения чар",
		["Socket Requires"] = "Для (использования )?гнезда [тп][ре][ер][бс][уо][ен][та][сж]я?( должен быть не младше)?",

	--	["Enchantment color"] = "",
	--	["Compact equipment bonuses"] = "",
	--	["Hide item levels"] = "",
	--	["Hide equipment sets"] = "",
	--	["Hide \"%s\" lines"] = "",
		["Made by"] = "Изготовитель",
	--	["Hide requirements"] = "",
	--	["Hide level, reputation, and skill requirements for items, enchantements, and sockets."] = "",
	--	["Hide buying instructions"] = "",
	--	["Hide socketing instructions"] = "",
	--	["Hide vendor values"] = "",
	--	["Hide vendor values, except while interacting with a vendor."] = "",
	}

	namespace.patterns = {
		"^Если на персонаже: Рейтинг (.+) +(%d+).",
		"^Если на персонаже: Увеличивает силу (.+) на (%d+).",
		"^Если на персонаже: Увеличивает (проникающую способность заклинаний) на (%d+).",
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
--	Last updated YYYY-MM-DD by NAME
------------------------------------------------------------------------

if GAME_LOCALE == "koKR" then

	namespace.L = {
		["Enchantment Requires"] = "마법부여",
		["Socket Requires"] = "보석 홈",

	--	["Enchantment color"] = "",
	--	["Compact equipment bonuses"] = "",
	--	["Hide item levels"] = "",
	--	["Hide equipment sets"] = "",
	--	["Hide \"%s\" lines"] = "",
		["Made by"] = "제작자",
	--	["Hide buying instructions"] = "",
	--	["Hide requirements"] = "",
	--	["Hide level, reputation, and skill requirements for items, enchantements, and sockets."] = "",
	--	["Hide socketing instructions"] = "",
	--	["Hide vendor values"] = "",
	--	["Hide vendor values, except while interacting with a vendor."] = "",
	}

	namespace.patterns = {
		"^착용 효과: (.+)가 (%d+)만큼 증가합니다.",
		"^착용 효과: (.+)이 (%d+)만큼 증가합니다.", -- maybe can be combined with #1, depending on how string.match works in koKR
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
--	Simplified Chinese | 简体中文
--	Last updated 2011-12-15 by hydra0
------------------------------------------------------------------------

if GAME_LOCALE == "zhCN" then

	namespace.L = {
		["Enchantment Requires"] = "附魔要求",
		["Socket Requires"] = "插槽要求",

		["Enchantment color"] = "强化属性颜色",
		["Compact equipment bonuses"] = "简化装备属性",
		["Hide item levels"] = "隐藏物品等级",
		["Hide equipment sets"] = "隐藏装备方案",
		["Hide \"%s\" lines"] = "隐藏\"%s\"标签",
		["Made by"] = "由谁制造",
	--	["Hide requirements"] = "",
	--	["Hide level, reputation, and skill requirements for items, enchantements, and sockets."] = "",
	--	["Hide buying instructions"] = "",
	--	["Hide socketing instructions"] = "",
		["Hide vendor values"] = "隐藏卖价",
		["Hide vendor values, except while interacting with a vendor."] = "除非和商人交易,否则隐藏卖价.",
	}

	namespace.patterns = {
		"^装备：%s*(.+)提高(%d+)点。",
		"^装备：%s*每5秒恢复(%d+)点生命值。",
		"^装备：%s*使你的(.+)提高(%d+)。",
--		"^装备：使你的(.+)提高(%d+)点。",
--		"^装备：使你的盾牌(.+)提高(%d+)点。" -- maybe can be combined with #1, depending on how string.match works in zhCN
--		"^装备：(.+)提高(%d+)点。",
	}

	namespace.strings = {
		"+%d %s",
		"+%d HP/5s",
		"+%d %s",
	}

return end

------------------------------------------------------------------------
--	Traditional Chinese | 繁體中文
--	Last updated YYYY-MM-DD by NAME
------------------------------------------------------------------------

if GAME_LOCALE == "zhTW" then

	namespace.L = {
		["Enchantment Requires"] = "(此)?附魔需要",
		["Socket Requires"] = "插槽需要",

	--	["Enchantment color"] = "",
	--	["Compact equipment bonuses"] = "",
	--	["Hide item levels"] = "",
	--	["Hide equipment sets"] = "",
		["Hide \"%s\" lines"] = "隐藏\"%s\"行",
		["Made by"] = "灵魂绑定",
	--	["Hide requirements"] = "",
	--	["Hide level, reputation, and skill requirements for items, enchantements, and sockets."] = "",
	--	["Hide buying instructions"] = "",
	--	["Hide socketing instructions"] = "",
	--	["Hide vendor values"] = "",
	--	["Hide vendor values, except while interacting with a vendor."] = "",
	}

	namespace.patterns = {
		"^裝備:%s*提高(%d+)點(.+)。",
		"^裝備:%s*使你的(.+)提高(%d+)(點)?。",
		"^裝備:%s*每5秒恢復(%d+)(點)?生命力。", -- Restores (%d+) health per 5 seconds.
	}

	namespace.strings = {
		"+%d %s",
		"+%d %s",
		"+%d 生命力每5秒",
	}

return end