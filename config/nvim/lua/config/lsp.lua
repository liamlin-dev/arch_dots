-- Diagnostic
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  float = { border = "single" },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
vim.lsp.config["*"] = {
  capabilities = capabilities,
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    local keymap = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    -- stylua: ignore start
    -- Navigation (gd, gr, gi, gt handled by fzf-lua in core.lua)
    keymap("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")

    -- Documentation
    -- 只在 normal mode 下不然會影響打字
    keymap("n", "K", function() vim.lsp.buf.hover({ border = "single" }) end, "Hover Documentation")
    -- 只在 insert mode 下不然會影響窗口移動
    keymap({"i"}, "<C-k>", function() vim.lsp.buf.signature_help({ border = "single" }) end, "Signature Help")

    -- Actions
    keymap({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    keymap("n", "<leader>cr", vim.lsp.buf.rename, "Rename Symbol")

    -- Diagnostics
    keymap("n", "<leader>cl", function() vim.disagnostic.open_float({ scope = "line" }) end, "Diagnostic show float")
    -- stylua: ignore end

    -- Client-specific keymaps
    if client and client.name == "clangd" then
      keymap("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", "Switch Header/Source")
    end
  end,
})

vim.lsp.config["lua_ls"] = {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
}

-- Enable LSP servers
vim.lsp.enable({ "clangd", "basedpyright", "bashls", "neocmake", "lua_ls", "jsonls" })
