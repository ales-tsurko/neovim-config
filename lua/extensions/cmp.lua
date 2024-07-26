--[[
  File: cmp.lua
  Description: CMP plugin configuration (with lspconfig)
  See: https://github.com/hrsh7th/nvim-cmp
]]

local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup {
    snippet = {
        expand = function(args)
            require 'luasnip'.lsp_expand(args.body) -- Luasnip expand
        end,
    },

    -- Mappings for cmp
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<C-c>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),

    preselect = cmp.PreselectMode.Item,

    completion = {
        keyword_length = 1,
        completeopt = 'menuone,popup' },

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },                -- LSP
        -- { name = 'copilot' },                 -- Copilot
        { name = 'codeium' },                 -- Codeium
        { name = 'nvim_lsp_signature_help' }, -- LSP for parameters in functions
        { name = 'nvim_lua' },                -- Lua Neovim API
        { name = 'luasnip' },                 -- Luasnip
        { name = 'buffer' },                  -- Buffers
        { name = 'path' },                    -- Paths
        { name = "emoji" },                   -- Emoji
    }, {
    }),
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,            -- Prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default
            ellipsis_char = '...',
            symbol_map = {
                Codeium = "",
                -- Copilot = '󰚩',
            }
        })
    },
    window = {
        completion = {
            border = 'solid',
            -- side_padding = 3, -- hides icons
            scrollbar = true,
        },
        documentation = {
            border = 'solid',
        },
    },
    experimental = {
        ghost_text = true,
    }
}

-- command line completions
cmp.setup.cmdline({ '/', '?' }, {
    completion = { completeopt = 'menuone,popup,noselect' },
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    completion = { completeopt = 'menuone,popup,noselect' },
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        }
    })
})

-- require("copilot").setup()
-- require("copilot_cmp").setup()

-- Add snippets from Friendly Snippets
require("luasnip/loaders/from_vscode").lazy_load()
