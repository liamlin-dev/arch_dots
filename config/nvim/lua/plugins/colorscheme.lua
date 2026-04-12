return {
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     local flavour = "mocha"
  --     local palette = require("catppuccin.palettes").get_palette(flavour)
  --     require("catppuccin").setup({
  --       flavour = flavour, -- latte, frappe, macchiato, mocha
  --       transparent_background = true,
  --       float = {
  --         transparent = true, -- enable transparent floating windows
  --         solid = false, -- use solid styling for floating windows, see |winborder|
  --       },
  --
  --       no_italic = true,
  --       no_bold = false,
  --       no_underline = false,
  --
  --       custom_highlights = {
  --         -- ref: https://www.reddit.com/r/neovim/comments/11l5p32/how_can_i_change_the_color_of_the_column_that/
  --         LineNr = { fg = "#9399b2", bg = "NONE", bold = false },
  --         CursorLineNr = { fg = "#f0f6fc", bg = "NONE", bold = true },
  --       },
  --     })
  --     -- Apply the colorscheme
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },

  {
    "sainnhe/gruvbox-material",
    name = "gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_transparent_background = 1
      -- Apply the colorscheme
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
}
