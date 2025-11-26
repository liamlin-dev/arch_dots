local wezterm = require("wezterm")
local platform = require("utils.platform")()
local ssh_util = require("utils.ssh")
local catppuccin = require("colors.catppuccin")

-- Helper function to create colored labels
local function create_label(text, color)
	return wezterm.format({
		{ Foreground = { Color = color } },
		{ Text = text },
	})
end

-- Platform icons for section headers
local PLATFORM_ICONS = {
	ssh = "🔐", -- SSH connections
	wsl = "🐧", -- WSL (Linux penguin)
	windows = "🪟", -- Windows
	macos = "🍎", -- macOS (Apple)
	linux = "🐧", -- Linux
}

-- Distro icons mapping (case-insensitive substring matching)
local distro_icon_patterns = {
	{ pattern = "ubuntu", icon = "🟠" },
	{ pattern = "debian", icon = "🔴" },
	{ pattern = "fedora", icon = "🔵" },
	{ pattern = "arch", icon = "🔷" },
	{ pattern = "alpine", icon = "🏔️" },
	{ pattern = "suse", icon = "🦎" },
	{ pattern = "kali", icon = "🐉" },
	{ pattern = "centos", icon = "💚" },
	{ pattern = "rocky", icon = "🟢" },
	{ pattern = "alma", icon = "💙" },
}

-- Helper function to get icon for distro
local function get_distro_icon(distro_name)
	local lower_name = distro_name:lower()
	for _, entry in ipairs(distro_icon_patterns) do
		if lower_name:find(entry.pattern, 1, true) then
			return entry.icon
		end
	end
	return "🐧" -- Default Linux penguin
end

-- ============================================================================
-- CONFIGURATION: Manually configure your WSL distributions here
-- ============================================================================
-- To avoid spawning console windows on every config reload,
-- manually list your WSL distributions here.
-- You can find them by running: wsl --list --quiet
local WSL_DISTRIBUTIONS = {
	"Ubuntu",
	"Fedora",
	-- "Debian",
	-- "Arch",
	-- Add your distributions here
}

-- Configure which Windows terminals to show
local WINDOWS_TERMINALS = {
	{
		name = "PowerShell Core",
		command = "pwsh",
		args = { "pwsh", "-NoLogo" },
		enabled = true, -- Set to false to disable
	},
	{
		name = "Command Prompt",
		command = "cmd",
		args = { "cmd" },
		enabled = true,
	},
	{
		name = "Git Bash",
		command = "bash.exe",
		args = { "bash.exe" },
		enabled = false, -- Set to true if you have Git Bash
	},
}

-- Configure shells for Linux/macOS
local UNIX_SHELLS = {
	{ name = "Bash", path = "bash", args = { "-l" } },
	{ name = "Zsh", path = "zsh", args = { "-l" } },
	{ name = "Fish", path = "fish", args = { "-l" } },
}

-- Build launch menu function
local function build_launch_menu()
	local launch_menu = {}

	-- ssh
	local ssh_hosts = ssh_util.parse_ssh_config()
	if #ssh_hosts > 0 then
		table.insert(launch_menu, {
			label = create_label(PLATFORM_ICONS.ssh .. "  SSH Hosts", catppuccin.mauve),
		})
		for _, host in ipairs(ssh_hosts) do
			table.insert(launch_menu, {
				label = create_label("  SSH to " .. host.display_name, catppuccin.mauve),
				args = { "ssh", host.name },
			})
		end
	end

	-- Platform-specific configurations
	if platform.is_win then
		-- WSL distributions (from static config)
		if #WSL_DISTRIBUTIONS > 0 then
			table.insert(launch_menu, {
				label = create_label(PLATFORM_ICONS.wsl .. "  WSL Distributions", catppuccin.yellow),
			})
			for _, distro in ipairs(WSL_DISTRIBUTIONS) do
				local icon = get_distro_icon(distro)
				table.insert(launch_menu, {
					label = create_label("  " .. icon .. " " .. distro .. " (Shell)", catppuccin.yellow),
					args = { "wsl", "~", "-d", distro, "--exec", "zsh" },
				})
				table.insert(launch_menu, {
					label = create_label("  " .. icon .. " " .. distro .. " (Tmux)", catppuccin.sky),
					args = { "wsl", "~", "-d", distro, "--exec", "zsh", "-c", "tmux" },
				})
			end
		end

		-- Windows terminals (from static config)
		table.insert(launch_menu, {
			label = create_label(PLATFORM_ICONS.windows .. "  Windows Terminals", catppuccin.peach),
		})
		for _, terminal in ipairs(WINDOWS_TERMINALS) do
			if terminal.enabled then
				table.insert(launch_menu, {
					label = create_label("  " .. terminal.name, catppuccin.peach),
					args = terminal.args,
				})
			end
		end
	elseif platform.is_mac then
		-- macOS shells (from static config)
		table.insert(launch_menu, {
			label = create_label(PLATFORM_ICONS.macos .. "  macOS Terminals", catppuccin.yellow),
		})
		for _, shell in ipairs(UNIX_SHELLS) do
			local shell_path = shell.path
			-- Special handling for Homebrew Fish
			if shell.name == "Fish" then
				local homebrew_fish = "/opt/homebrew/bin/fish"
				local file = io.open(homebrew_fish, "r")
				if file then
					file:close()
					shell_path = homebrew_fish
				end
			end
			table.insert(launch_menu, {
				label = create_label("  " .. shell.name, catppuccin.yellow),
				args = { shell_path, table.unpack(shell.args) },
			})
		end
	elseif platform.is_linux then
		-- Linux shells (from static config)
		table.insert(launch_menu, {
			label = create_label(PLATFORM_ICONS.linux .. "  Linux Terminals", catppuccin.yellow),
		})
		for _, shell in ipairs(UNIX_SHELLS) do
			table.insert(launch_menu, {
				label = create_label("  " .. shell.name, catppuccin.yellow),
				args = { shell.path, table.unpack(shell.args) },
			})
		end
	end

	return launch_menu
end

-- Set default programs
local default_prog = {}
if platform.is_win then
	default_prog = { "wsl", "~", "--exec", "zsh", "-c", "~/.config/wezterm/tmux-wezterm-startup.sh" }
elseif platform.is_mac then
	default_prog = { "zsh", "-l" }
elseif platform.is_linux then
	default_prog = { "zsh", "-c", "~/.config/wezterm/tmux-wezterm-startup.sh" }
end

-- Return options with lazy-loaded launch menu
local options = {
	default_prog = default_prog,
	launch_menu = build_launch_menu(),
}

return options
