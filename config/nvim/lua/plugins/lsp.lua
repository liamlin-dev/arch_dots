return {
  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      -- Default diagnostics config
      diagnostics = {
        underline = true,
        update_in_insert = false,
        -- virtual_text = {
        --   spacing = 4,
        --   source = "if_many",
        --   prefix = "●",
        -- },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
      },
      -- Servers are merged from other plugins (e.g., lang/cpp.lua)
      servers = {},
    },
    config = function(_, opts)
      -- Configure diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- LspAttach event for keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local bufnr = ev.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
          end

          -- Navigation (gd, gr, gi, gt handled by fzf-lua in core.lua)
          map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")

          -- Documentation
          map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
          map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

          -- Actions
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("v", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename Symbol")

          -- Server specific keymaps
          -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
          -- local server_opts = opts.servers[client.name]
        end,
      })

      -- Build capabilities
      local servers = opts.servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Add blink.cmp capabilities
      capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

      -- Server setup function
      local function setup(server)
        local server_opts = servers[server] or {}

        local final_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, server_opts)

        require("lspconfig")[server].setup(final_opts)
      end

      -- Mason-lspconfig integration
      local mlsp = require("mason-lspconfig")
      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          table.insert(ensure_installed, server)
        end
      end

      mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
    end,
  },
  { "williamboman/mason.nvim", cmd = "Mason", build = ":MasonUpdate", opts = {} },
  { "williamboman/mason-lspconfig.nvim" },
}
