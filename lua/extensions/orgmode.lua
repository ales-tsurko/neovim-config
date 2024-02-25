--[[
  File: orgmode.lua
  Description: orgmode plugin configuration
  See: https://github.com/nvim-orgmode/orgmode
  ]]


-- Load treesitter grammar for org
require('orgmode').setup_ts_grammar()

-- Setup treesitter
require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
    },
    ensure_installed = { 'org' },
})

-- Setup orgmode
require('orgmode').setup({
    org_agenda_files = '~/org/**/*',
    org_default_notes_file = '~/org/index.org',
})
