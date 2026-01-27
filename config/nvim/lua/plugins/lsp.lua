-- 啟用 LSP Server 步驟
-- 1. 在下方 vim.lsp.enable 添加 Server (啟用)
-- 2. 因為有設定 nvim-lspconfig 故會抓取 default lsp 設置
-- 3. (Opt) 自行設定的話先去 nvim-lspconfig repo 中找到 lsp/ 裡面對應的設置，複製到 after/lsp 中後進行修改

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Configure diagnostics
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
      })

      -- Set global capabilities for all LSP servers
      -- This ensures blink.cmp completion works with all servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- LspAttach event for keymaps and buffer-local configuration
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
          end

          -- stylua: ignore start
          -- Navigation (gd, gr, gi, gt handled by fzf-lua in core.lua)
          map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")

          -- Documentation
          -- 只在 normal mode 下不然會影響打字
          map("n", "K", function() vim.lsp.buf.hover({ border = "single" }) end, "Hover Documentation")
          -- 只在 insert mode 下不然會影響窗口移動
          map({"i"}, "<C-k>", function() vim.lsp.buf.signature_help({ border = "single" }) end, "Signature Help")

          -- Actions
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("v", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
          -- stylua: ignore end

          -- Client-specific keymaps
          if client and client.name == "clangd" then
            map("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", "Switch Header/Source")
          end
        end,
      })

      -- Enable LSP servers
      vim.lsp.enable({ "clangd", "basedpyright", "bashls", "neocmake", "lua_ls" })
    end,
  },

  { "williamboman/mason.nvim", cmd = "Mason", build = ":MasonUpdate", config = true },
}
