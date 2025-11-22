return {
	-- keyboard encoding
	allow_win32_input_mode = true,
	-- enable_kitty_keyboard = true,

	-- behaviours
	automatically_reload_config = true,
	exit_behavior = "CloseOnCleanExit",
	status_update_interval = 1000,

	scrollback_lines = 10000,

	hyperlink_rules = {
		-- Matches: a URL in parens: (URL)
		{
			regex = "\\((\\w+://\\S+)\\)",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in brackets: [URL]
		{
			regex = "\\[(\\w+://\\S+)\\]",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in curly braces: {URL}
		{
			regex = "\\{(\\w+://\\S+)\\}",
			format = "$1",
			highlight = 1,
		},
		-- Matches: a URL in angle brackets: <URL>
		{
			regex = "<(\\w+://\\S+)>",
			format = "$1",
			highlight = 1,
		},
		-- Then handle URLs not wrapped in brackets
		{
			regex = "\\b\\w+://\\S+[)/a-zA-Z0-9-]+",
			format = "$0",
		},
		-- implicit mailto link
		{
			regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
			format = "mailto:$0",
		},
		-- GitHub issues/PRs: owner/repo#123
		{
			regex = "([\\w\\d\\-_\\.]+/[\\w\\d\\-_\\.]+)#(\\d+)",
			format = "https://github.com/$1/issues/$2",
		},
		-- File paths (absolute paths starting with / or ~)
		{
			regex = "[/~][\\w\\d\\-_/.]+",
			format = "file://$0",
		},
		-- IP addresses with optional port
		{
			regex = "\\b\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}(:\\d+)?\\b",
			format = "http://$0",
		},
	},
}
