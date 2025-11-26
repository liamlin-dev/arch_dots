local wezterm = require("wezterm")
local nf = wezterm.nerdfonts

local M = {}

-- Process icon mapping
local process_icons = {
	["docker"] = nf.linux_docker,
	["docker-compose"] = nf.linux_docker,
	["psql"] = nf.dev_postgresql,
	["usql"] = nf.dev_database,
	["kuberlr"] = nf.linux_docker,
	["ssh"] = nf.fa_server,
	["ssh-add"] = nf.md_key_plus,
	["kubectl"] = nf.linux_docker,
	["stern"] = nf.linux_docker,
	["nvim"] = nf.custom_neovim,
	["vim"] = nf.dev_vim,
	["vi"] = nf.dev_vim,
	["git"] = nf.dev_git,
	["lazygit"] = nf.dev_git_branch,
	["node"] = nf.md_nodejs,
	["go"] = nf.md_language_go,
	["python"] = nf.dev_python,
	["python3"] = nf.dev_python,
	["ruby"] = nf.dev_ruby,
	["lua"] = nf.seti_lua,
	["wget"] = nf.md_arrow_down_box,
	["curl"] = nf.md_arrow_down_box,
	["gh"] = nf.dev_github_badge,
	["cargo"] = nf.dev_rust,
	["rustc"] = nf.dev_rust,
	["htop"] = nf.md_chart_donut_variant,
	["btop"] = nf.md_chart_donut_variant,
	["sudo"] = nf.fa_hashtag,
	["bash"] = nf.cod_terminal_bash,
	["zsh"] = nf.cod_terminal,
	["fish"] = nf.md_fish,
	["tmux"] = nf.cod_terminal_tmux,
}

-- Get icon for process
local function get_process_icon(process_name)
	if not process_name then
		return nf.cod_terminal
	end

	local name = process_name:match("([^/\\]+)$") or process_name
	return process_icons[name:lower()] or nf.cod_terminal
end

-- Get clean title
local function get_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

-- Get process name
local function get_process(tab)
	local process_name = tab.active_pane.foreground_process_name
	if not process_name then
		return nil
	end
	return process_name:match("([^/\\]+)$")
end

-- Truncate title to fit max width
local function truncate_title(title, max_len)
	if #title <= max_len then
		return title
	end
	return title:sub(1, max_len - 1) .. "…"
end

M.setup = function()
	wezterm.on("format-tab-title", function(tab, tabs, _panes, config, hover, max_width)
		local colors = config.resolved_palette

		-- Get tab info
		local tab_index = tab.tab_index + 1
		local process = get_process(tab)
		local icon = get_process_icon(process)
		local title = get_title(tab)

		-- Simplify title (remove common prefixes)
		title = title:gsub("^/home/[^/]+", "~")

		-- Build tab content: "N ICON TITLE"
		local tab_content = string.format("%d %s %s", tab_index, icon, title)

		-- Use max_width fully - this is the maximum width allocated to this tab
		-- Truncate title if content is too long
		local content_len = wezterm.column_width(tab_content)
		if content_len > (max_width - 4) then
			local prefix = string.format("%d %s ", tab_index, icon)
			local available_for_title = max_width - wezterm.column_width(prefix) - 4
			if available_for_title > 3 then
				title = truncate_title(title, available_for_title)
			else
				title = ""
			end
			tab_content = string.format("%d %s %s", tab_index, icon, title)
		end

		-- Pad to fill the ENTIRE max_width
		local content_width = wezterm.column_width(tab_content)
		local total_padding = max_width - content_width
		local left_pad = math.floor(total_padding / 2)
		local right_pad = total_padding - left_pad

		local tab_text = string.rep(" ", left_pad) .. tab_content .. string.rep(" ", right_pad)

		-- Color scheme based on state
		local bg_color
		local fg_color
		local intensity = "Half"

		if tab.is_active then
			bg_color = colors.tab_bar.active_tab.bg_color
			fg_color = colors.tab_bar.active_tab.fg_color
			intensity = "Bold"
		elseif hover then
			bg_color = colors.tab_bar.inactive_tab_hover.bg_color
			fg_color = colors.tab_bar.inactive_tab_hover.fg_color
			intensity = "Normal"
		else
			bg_color = colors.tab_bar.inactive_tab.bg_color
			fg_color = colors.tab_bar.inactive_tab.fg_color
			intensity = "Half"
		end

		return {
			{ Background = { Color = bg_color } },
			{ Foreground = { Color = fg_color } },
			{ Attribute = { Intensity = intensity } },
			{ Text = tab_text },
		}
	end)
end

return M
