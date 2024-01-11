require "helpers/globals"
require "helpers/keyboard"
require "insert_bindings"

g.mapleader = ' ' -- Use Space, like key for alternative hotkeys

-- prevent moving cursor when yanking (copying)
vm('y', 'ygv<Esc>')

-- Telescope {{{
nm('<Leader><Leader>', '<cmd>Telescope find_files theme=ivy<CR>')
nm('<Leader>s', '<cmd>Telescope persisted<CR>')
nm('<Leader>ff', '<cmd>Telescope live_grep theme=ivy<CR>')
nm('<Leader>l', '<cmd>Telescope current_buffer_fuzzy_find<CR>')
nm('<leader>gd', '<cmd>Telescope lsp_definitions theme=cursor<CR>')
nm('<leader>gi', '<cmd>Telescope lsp_implementations theme=cursor<CR>')
nm('<leader>gr', '<cmd>Telescope lsp_references theme=cursor<CR>')
nm('<leader>xx', '<cmd>Telescope diagnostics theme=ivy<CR>')
nm('<leader>j', '<cmd>Telescope<CR>')
nm('<leader>k', '<cmd>Telescope keymaps<CR>')
nm('<leader>t', '<cmd>Telescope lsp_document_symbols<CR>')
-- }}}

-- Trouble {{{
nm('<leader>x', '<cmd>TroubleToggle<CR>') -- Show all problems in project (with help of LSP)
-- }}}

-- sorting {{{
nm('gs', '<Cmd>Sort<CR>')
vm('gs', '<Esc><Cmd>Sort<CR>')
-- }}}

-- git {{{
nm("<leader>hu", "<cmd>Gitsigns reset_hunk<CR>")
nm("<leader>hp", "<cmd>Gitsigns preview_hunk<CR>")
-- }}}

-- session {{{
nm('<leader>sc', '<cmd>SessionClose<CR><cmd>Dashboard<CR>') -- Close session
-- }}}

-- nvim-tree {{{
nm('<Tab>', '<cmd>NvimTreeToggle<CR>') -- Toggle file explorer
-- }}}

-- bufferline {{{
nm('<C-l>', '<cmd>BufferLineCycleNext<CR>')
nm('<C-h>', '<cmd>BufferLineCyclePrev<CR>')
nm('<C-t>o', '<cmd>BufferLineCloseLeft<CR><cmd>BufferLineCloseRight<CR>')
-- }}}

-- bufdel {{{
nm('<C-t>c', '<cmd>BufDel<CR>')
-- }}}

-- terminal {{{
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
-- line
vim.keymap.set("n", "<leader>/", function()
  require('Comment.api').toggle.linewise.current()
end)

-- selection
local esc = vim.api.nvim_replace_termcodes(
  '<ESC>', true, false, true
)

vim.keymap.set('x', '<leader>/', function()
  vim.api.nvim_feedkeys(esc, 'nx', false)
  require('Comment.api').toggle.linewise(vim.fn.visualmode())
end)
-- }}}

-- vimwiki {{{
nm('<leader>tt', '<cmd>VimwikiToggleListItem<CR>')
-- }}}

-- LSP {{{
nm('[d', 'vim.diagnostic.goto_prev')
nm(']d', 'vim.diagnostic.goto_next')

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
      buffer = bufnr
    }
    local opts = {
      buffer = ev.buf
    }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  end
})
-- }}}

-- Other {{{
cmd [[
nnoremap <CR> a
nnoremap <S-CR> o
]]
-- }}}

-- vim:tabstop=2 shiftwidth=2 expandtab syntax=lua foldmethod=marker foldlevelstart=0
