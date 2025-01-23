--[[
  File: settings.lua
  Description: Base settings for neovim
]]

require "../helpers/globals"
-- require "settings/project_config"


-- Set associating between turned on plugins and filetype
cmd [[filetype plugin on]]

-- Tabs {{{
opt.expandtab = true   -- Use spaces by default
opt.shiftwidth = 4     -- Set amount of space characters, when we press "<" or ">"
opt.tabstop = 4        -- 1 tab equal 2 spaces
opt.smartindent = true -- Turn on smart indentation. See in the docs for more info
opt.autoindent = true  -- Copy indent from current line, over to the new one
opt.smarttab = true    -- Insert tabs on the start of the line according to shiftwidth
opt.softtabstop = 0    -- Set amount of space characters, when we press "<Tab>"
-- }}}

-- Editing {{{
opt.foldenable = true
opt.spelllang = "en_us,ru_ru"                     -- Set spell language
opt.wrap = false                                  -- Disable word wrap
opt.scrolloff = 999                               -- Keep cursor always in the middle
cmd [[ set completeopt="menuone,preview"]]
cmd [[ nnoremap * :keepjumps normal! mi*`i<CR> ]] -- prevent "super star" jumps
-- }}}

-- UI {{{
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.cursorline = true    -- Highlight current line
opt.startofline = true   -- move the cursor to the first non-blank of the line for specific commands
opt.number = true        -- line numbers
opt.laststatus = 3       -- Single status line
opt.signcolumn = "yes:2" -- Always show sign column
opt.guifont = "Iosevka Nerd Font Mono:13"
cmd [[set fillchars=eob:\ ]]
opt.foldnestmax = 3
opt.foldminlines = 1
cmd [[ set viewoptions=folds,cursor ]]
cmd [[set colorcolumn=+1]] -- Show vertical line width line
cmd [[ set mousescroll=ver:1,hor:1]]
opt.mouse = "a"
cmd [[ set mousemoveevent ]]
cmd [[ set splitkeep=screen ]] -- stabilize window behavior
-- custom statuscolumn to add more space after the line number
opt.statuscolumn = "%s%=%T%r%l   %T"
opt.background = "dark"
opt.conceallevel = 2
opt.winblend = 10 -- float window transparency
-- }}}

-- Optimizations {{{
-- opt.lazyredraw = true            -- Don't redraw while executing macros (good performance config)
opt.ttyfast = true   -- Faster redraw
opt.swapfile = false -- Disable swap files
opt.updatetime = 300 -- Faster completion
-- }}}

-- Clipboard {{{
opt.clipboard = 'unnamedplus' -- Use system clipboard
opt.fixeol = false            -- Turn off appending new line in the end of a file
-- }}}

-- Search {{{
opt.ignorecase = true  -- Ignore case if all characters in lower case
opt.joinspaces = false -- Join multiple spaces in search
opt.smartcase = true   -- When there is a one capital letter search for exact match
opt.showmatch = true   -- Highlight search instances
-- }}}

-- Window {{{
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new vertical splits to right
-- }}}

-- Wild Menu {{{
opt.wildmenu = true
opt.wildmode = "longest:full,full"
-- }}}

-- File Type Specific {{{
-- General
-- Disable comments on pressing Enter
cmd [[au FileType * setlocal formatoptions-=cro]]
-- sh
cmd [[au FileType sh setlocal tw=80]]
-- md
cmd [[au FileType markdown setlocal nonumber]]
cmd [[au FileType markdown setlocal spell]]
cmd [[au FileType markdown setlocal tw=80]]
cmd [[au FileType markdown setlocal wrap]]
-- wgsl
cmd [[au FileType wgsl setlocal tw=80]]
cmd [[au BufNewFile,BufRead *.wgsl set filetype=wgsl]]
-- vimwiki
cmd [[au FileType vimwiki setlocal nonumber]]
cmd [[au FileType vimwiki setlocal wrap]]
cmd [[au FileType vimwiki setlocal tw=80]]
cmd [[au FileType vimwiki setlocal spell]]
-- org
cmd [[au FileType org setlocal nonumber]]
cmd [[au FileType org setlocal wrap]]
cmd [[au FileType org setlocal tw=80]]
-- c/c++
cmd [[au FileType c setlocal tw=80]]
cmd [[au FileType cpp setlocal tw=80]]
-- js/jsx/ts/tsx
cmd [[au FileType javascript setlocal tw=100]]
cmd [[au FileType javascript setlocal shiftwidth=2]]
cmd [[au FileType javascript setlocal tabstop=2]]
cmd [[au FileType jsx setlocal shiftwidth=2]]
cmd [[au FileType jsx setlocal tabstop=2]]
cmd [[au FileType jsx setlocal tw=100]]
cmd [[au FileType ts setlocal tw=100]]
cmd [[au FileType tsx setlocal tw=100]]
cmd [[au FileType typescript setlocal tw=100]]

-- py
cmd [[au FileType py setlocal tw=80]]
cmd [[au FileType python setlocal tw=80]]
-- rust
cmd [[au FileType rust setlocal tw=100]]
cmd [[au FileType rust setlocal foldmethod=manual]]
-- cmd [[au FileType rust setlocal foldmethod=marker]]
-- cmd [[au FileType rust setlocal foldmarker={,}]]
cmd [[au FileType rust setlocal foldlevelstart=0]]
cmd [[au FileType rust setlocal foldenable]]
-- lua
cmd [[au FileType lua setlocal tw=80]]
cmd [[au FileType lua setlocal shiftwidth=2]]
cmd [[au FileType lua setlocal tabstop=2]]
-- yaml
cmd [[au FileType yaml setlocal tabstop=2]]
cmd [[au FileType yaml setlocal shiftwidth=2]]
-- git
cmd [[autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete]]
-- slint
cmd [[au FileType slint setlocal tw=0]]
-- oil (file browser)
cmd [[au FileType oil setlocal nonumber]]
-- }}}

-- neovide {{{
if g.neovide then
  g.neovide_padding_top = 0
  g.neovide_padding_bottom = 40
  g.neovide_padding_right = 60
  g.neovide_padding_left = 60
  g.neovide_scroll_animation_length = 0.6
  g.neovide_cursor_animation_length = 0.03
  g.neovide_cursor_animate_command_line = false
  g.neovide_fullscreen = true
  g.neovide_confirm_quit = true

  opt.linespace = 1
  opt.guifont = "Iosevka_NFM:h13"
end
-- }}}

-- Context Menu {{{
cmd [[aunmenu PopUp]]
cmd [[vnoremenu PopUp.Cut                         "+x]]
cmd [[vnoremenu PopUp.Copy                        "+y]]
cmd [[anoremenu PopUp.Paste                       "+gP]]
cmd [[vnoremenu PopUp.Paste                       "+P]]
cmd [[vnoremenu PopUp.Delete                      "_x]]
cmd [[nnoremenu PopUp.Select\ All                 ggVG]]
cmd [[vnoremenu PopUp.Select\ All                 gg0oG$]]
cmd [[inoremenu PopUp.Select\ All                 <C-Home><C-O>VG]]
cmd [[anoremenu PopUp.-1-                         <Nop>]]

-- crates.nvim menu entries - the plugin is disabled
-- cmd [[au FileType toml anoremenu PopUp.Crates\ Info <cmd>Crates show_popup<CR>]]
-- cmd [[au FileType toml anoremenu PopUp.Crates\ Features <cmd>Crates show_features_popup<CR>]]
-- cmd [[au FileType toml anoremenu PopUp.Crates\ Update <cmd>Crates update_crate<CR>]]
-- cmd [[au FileType toml anoremenu PopUp.Crates\ Upgrade <cmd>Crates upgrade_crate<CR>]]
-- cmd [[au FileType toml anoremenu PopUp.Crates\ Show\ Dependencies <cmd>Crates show_dependencies_popup<CR>]]
-- cmd [[au FileType toml anoremenu PopUp.Crates\ Open\ Documentation <cmd>Crates open_documentation<CR>]]
-- cmd [[au FileType toml anoremenu PopUp.Crates\ Update\ All <cmd>Crates update_all_crates<CR>]]
-- cmd [[au FileType toml anoremenu PopUp.Crates\ Upgrade\ All <cmd>Crates upgrade_all_crates<CR>]]
-- }}}

-- sessions {{{
vim.opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "globals",
  "help",
  "tabpages",
  "winsize",
}
-- }}}

-- Default Plugins {{{
local disabled_built_ins = {
  -- "netrw",
  -- "netrwPlugin",
  -- "netrwSettings",
  -- "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  -- "spellfile_plugin",
  "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end
-- }}}


-- vim: tabstop=2 shiftwidth=2 expandtab syntax=lua foldmethod=marker foldlevelstart=1
