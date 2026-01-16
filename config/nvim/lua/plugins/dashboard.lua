return {
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = [[
⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⣠⡴⣟⣳⣶⣖⣤⢌⡙⠲⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⣴⣽⠟⢛⣭⣿⣿⣿⣿⣮⣢⢼⡷⢄⠀⠀⠀⠀⠀⠀⠀⠀
⠀⢰⣿⠁⣴⣿⣿⣿⣿⣿⣀⣸⣿⢸⠀⡨⡇⠀⠀⢀⣀⠠⣀⠀
⠀⢸⣿⢸⣿⠿⠿⠛⠿⢿⣿⣷⣿⡮⣳⡤⣃⠴⡊⠁⠀⠀⠀⡇
⠀⣨⢻⠁⠀⠀⠀⠀⠀⣠⣿⣿⣿⣷⣱⠋⠀⠀⠳⡀⠀⣠⠞⠀
⢠⠃⠘⢄⣀⢤⣐⣦⣵⣿⣿⣿⣿⣿⠃⣀⠀⣀⢠⡽⠚⠁⠀⠀
⠘⣆⡀⠀⠙⠻⢻⠿⠿⠯⢗⡻⠕⠁⠠⢔⢲⢎⠁⢳⡀⠀⠀⠀
⠀⠈⠙⠲⠦⠬⢆⠔⠗⠒⠒⠒⡖⣆⣀⠼⠾⠪⣦⠔⢣⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣿⡄⠠⡄⣯⡿⡟⢦⠶⠶⠼⠛⡵⣦⣸⠀⠀⠀
⠀⠀⠀⠀⢀⡴⠚⠯⡭⢥⡭⠴⠓⠺⠀⠀⠀⠀⠹⡤⠊⠀⠀⠀
⠀⠀⠀⢠⠛⠠⠤⣀⠒⢘⣱⠤⢤⣒⡡⠤⠄⠀⠀⢱⠀⠀⠀⠀
⠀⠀⠀⢸⠀⠀⠀⠀⢹⠃⠀⠀⠀⠀⠙⢦⡤⠔⠒⠁⢇⠀⠀⠀
⠀⠀⡤⠚⠒⠒⠀⢀⣸⠀⠀⠀⠀⠀⠀⠈⣶⡀⠐⠊⠉⠓⢦⠀
⠀⠀⠫⢖⣂⣀⡰⠮⠃⠀⠀⠀⠀⠀⠀⠀⠘⠮⠶⠄⠠⠤⠞⠀
          ]],
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":FzfLua files" },
            { icon = " ", key = "e", desc = "File Explorer", action = ":lua Snacks.explorer()" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":FzfLua live_grep" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":FzfLua oldfiles" },
            { icon = " ", key = "c", desc = "Config", action = ":FzfLua files cwd=" .. vim.fn.stdpath("config") },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          {
            pane = 1,
            section = "header",
            indent = 15,
            height = 20,
          },
          {
            section = "startup",
            padding = 1,
          },
          {
            pane = 2,
            icon = " ",
            section = "keys",
            title = "Keymaps",
            indent = 2,
            padding = 1,
          },
          {
            pane = 2,
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          {
            pane = 2,
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = 1,
          },
          {
            pane = 2,
            icon = " ",
            title = "Projects",
            section = "projects",
            indent = 2,
            padding = 1,
          },
        },
      },
    },
  },
}
