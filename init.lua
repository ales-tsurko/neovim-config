--[[
  File: init.lua
  Description: Entry point file for neovim
]]

-- Bootsraping plugin manager
require "lazy-bootstrap"

-- Plugin management {{{
local lazy = require("lazy")
lazy.setup("plugins")
-- }}}

-- Settings
require "settings/settings"
require "keybindings/keybindings"

-- vim:tabstop=2 shiftwidth=2 expandtab syntax=lua foldmethod=marker foldlevelstart=0 foldlevel=0