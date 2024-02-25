require "../helpers/globals"
require "../helpers/keyboard"
require "keybindings/nomode_like"

g.mapleader = ' ' -- Use Space, like key for alternative hotkeys

-- prevent moving cursor when yanking (copying)
vm('y', 'ygv<Esc>', "yank")

-- Open Telescope.
nm('<leader><leader>', '<cmd>Telescope<CR>', 'Open Telescope.')

-- command-line {{{ 
-- nm(':', '<cmd>Telescope cmdline theme=dropdown<CR>', 'Open command line.')
-- }}}

-- files {{{
nm('<Leader>fo', '<cmd>Telescope frecency workspace=CWD<CR>', 'Find files.')
nm('<Leader>ff', '<cmd>Telescope live_grep <CR>', 'Find string (live grep preview).')
nm('<Leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'Find string in the current buffer.')
nm('<Tab>', '<cmd>NvimTreeToggle<CR>', 'Toggle file explorer.') -- Toggle file explorer
-- }}}

-- buffers {{{
nm('<C-l>', '<cmd>BufferLineCycleNext<CR>', 'Switch to the next buffer.')
nm('<C-h>', '<cmd>BufferLineCyclePrev<CR>', 'Switch to the previous buffer.')
nm('<C-t>o', '<cmd>BufferLineCloseLeft<CR><cmd>BufferLineCloseRight<CR>', 'Close all but this buffer.')
nm('<C-t>c', '<cmd>BufDel<CR>', 'Close buffer.')
-- }}}

-- Go to {{{
nm('<leader>gd', '<cmd>Telescope lsp_definitions theme=cursor<CR>', 'Go to definition.')
nm('<leader>gi', '<cmd>Telescope lsp_implementations theme=cursor<CR>', 'Go to implementations')
nm('<leader>gr', '<cmd>Telescope lsp_references theme=cursor<CR>', 'Go to reference.')
nm('<leader>gt', '<cmd>Telescope lsp_document_symbols<CR>', 'Go to symbol.')
vim.api.nvim_set_keymap('n', '<C-j>', 'zj', { noremap = true, silent = true, desc = 'Go to next fold' })
vim.api.nvim_set_keymap('n', '<C-k>', 'zk', { noremap = true, silent = true, desc = 'Go to previous fold' })
-- }}}

-- Help {{{
nm('<leader>wk', '<cmd>Telescope keymaps<CR>', 'Show keymaps.')
-- }}}

-- giagnostics {{{
nm('<leader>xx', '<cmd>TroubleToggle<CR>', 'Show diagnostics.') -- Show all problems in project (with help of LSP)
nm('<Leader>xn', 'vim.diagnostic.goto_prev', 'Go to previous error or warning.')
nm('<Leader>xp', 'vim.diagnostic.goto_next', 'Go to next error or warning.')
-- }}}

-- sorting {{{
nm('<Leader>s', '<Cmd>Sort<CR>', 'Sort.')
vm('<Leader>s', '<Esc><Cmd>Sort<CR>', 'Sort.')
-- }}}

-- Git {{{
nm("<leader>hu", "<cmd>Gitsigns reset_hunk<CR>", 'Git: reset change.')
nm("<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", 'Git: preview change.')
-- }}}

-- sessions/projects {{{
nm('<Leader>pc', ':SClose<CR>', 'Close current session and open dashboard.')

-- }}}

-- terminal {{{
local esc = vim.api.nvim_replace_termcodes(
  '<ESC>', true, false, true
)

cmd [[
    " exit from terminal mode with Esc
    tnoremap <Esc> <C-\><C-n>
    " navigate windows with alt+h/j/k/l
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l
]]
-- }}}

-- comments {{{
vim.keymap.set("n", "<leader>/", function()
  require('Comment.api').toggle.linewise.current()
end, { noremap = true, silent = true, desc = 'Toggle comment.' })


vim.keymap.set('x', '<leader>/', function()
  vim.api.nvim_feedkeys(esc, 'nx', false)
  require('Comment.api').toggle.linewise(vim.fn.visualmode())
end, { noremap = true, silent = true, desc = 'Toggle comment.' })
-- }}}

-- vimwiki {{{
nm('<leader>tt', '<cmd>VimwikiToggleListItem<CR>', 'Vimwiki: toggle todo list item.')
-- }}}

-- other {{{
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
api.nvim_create_autocmd('LspAttach', {
  group = api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = {
      noremap = true,
      silent = true,
      buffer = ev.buf
    }

    bufopts.desc = 'Show documentation for item under cursor.'
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    bufopts.desc = 'Rename item under cursor.'
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    bufopts.desc = 'Format file.'
    vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, bufopts)
    bufopts.desc = 'Show code actions.'
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts, 'Show code actions.')
  end
})

cmd [[
nnoremap <CR> a
nnoremap <S-CR> o
]]
-- }}}

-- vim:tabstop=2 shiftwidth=2 expandtab syntax=lua foldmethod=marker foldlevelstart=0
