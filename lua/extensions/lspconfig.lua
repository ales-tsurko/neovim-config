local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason").setup()

mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",        -- LSP for Lua language
    -- "pyright",       -- LSP for Python
    "rust_analyzer", -- LSP for Rust
    "taplo",         -- LSP for TOML
    "wgsl_analyzer", -- LSP for WebGPU Shading Language
    "ts_ls",         -- LSP for TypeScript/JavaScript
    "efm",           -- general purpose LSP
  }
});

-- Setup every needed language server in lspconfig
-- mason_lspconfig.setup_handlers { function(server_name)
--   lspconfig[server_name].setup {
--     capabilities = capabilities
--   }
-- end }

-- Initialize slint LSP
lspconfig.slint_lsp.setup {}

-- Configure JavaScript
lspconfig.ts_ls.setup {
  settings = {
    javascript = {
      format = {
        tabSize = 2,
        indentSize = 2,
        insertSpaces = true,
      },
    },
  },
}

-- configs scheme is frequently changing. in case of issues, check they are
-- still correct:
-- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
lspconfig.rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = {
      completion = {
        autoimport = {
          enable = false
        }
      },
      diagnostics = {
        warningsAsHint = { "missing_docs" },
        enableExperimental = true -- needed for style lints
      },
      check = {
        command = "clippy", -- added to enable style lints
        -- invocationStrategy = "once",
      },
      cargo = {
        -- avoid constant workspace reloads
        autoreload = false,
        targetDir = "target/analyzer"
      }
    }
  },
}

-- https://github.com/neovim/neovim/issues/30985
-- for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
--     local default_diagnostic_handler = vim.lsp.handlers[method]
--     vim.lsp.handlers[method] = function(err, result, context, config)
--         if err ~= nil and err.code == -32802 then
--             return
--         end
--         return default_diagnostic_handler(err, result, context, config)
--     end
-- end
local icons = {
  [vim.diagnostic.severity.ERROR] = "",
  [vim.diagnostic.severity.WARN]  = "",
  [vim.diagnostic.severity.HINT]  = "",
  [vim.diagnostic.severity.INFO]  = "",
}

vim.diagnostic.config({
  signs            = {
    text  = icons, -- glyphs in the sign column
    -- optional: highlight the number column the same way
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
    },
  },
  virtual_text     = true,
  underline        = true,
  severity_sort    = true,
  -- update_in_insert = false, -- keep them until InsertLeave
})
