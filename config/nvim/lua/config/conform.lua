require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    yaml = { "prettierd", "prettier", stop_after_first = true },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
    toml = { "taplo" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    cmake = { "gersemi" },
    python = { "ruff_format" },
  },

  -- Format on save
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

local keymap = vim.keymap.set

keymap({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
