local wezterm = require("wezterm")

local fonts = {
	"Maple Mono Normal NF CN",
	"CaskaydiaCove Nerd Font",
}

local font_size = 12

return {
	font = wezterm.font_with_fallback(fonts),
	font_size = font_size,
	warn_about_missing_glyphs = false,

	--ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
	freetype_load_target = "Normal", ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
	freetype_render_target = "Normal", ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
