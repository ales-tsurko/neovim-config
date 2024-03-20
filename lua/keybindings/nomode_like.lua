-- bindings for insert mode

cmd [[
    " to move in insert mode
    " move cursour word left
    inoremap <A-Left> <C-o>b
    " move cursour word right
    inoremap <A-Right> <Esc>ea
    " delete word left
    inoremap <A-Bs> <C-w>
    " delete word right
    inoremap <A-S-Bs> <C-o>dw
    " move cursor left
    inoremap <C-h> <Left>
    " move cursor left
    inoremap <C-l> <Right>
    " move cursor down
    inoremap <C-j> <Down>
    " move cursor up
    inoremap <C-k> <Up>
    " scroll up/down
    inoremap <C-u> <C-o><C-u>
    inoremap <C-d> <C-o><C-d>
]]

local function map_key(key, command)
    vim.api.nvim_set_keymap('i', key, '<cmd>' .. command .. '<CR>', { noremap = true, silent = true })
end

local function remap_key(key, other)
    vim.api.nvim_set_keymap('i', key, '<C-\\><C-o>' .. other, { noremap = true, silent = true })
end

-- -- show commands
-- vim.api.nvim_set_keymap('i', '<C-Space>', '<Esc>:',
--     { noremap = true, silent = false })

-- fuzzy finder
map_key('<D-p>', 'Telescope find_files theme=ivy')

-- Buffers

-- save
map_key("<D-s>", "w")
-- undo/redo
map_key("<D-z>", "undo")
map_key("<D-Z>", "redo")


-- new empty buffer
vim.api.nvim_create_user_command('NewBufSameType', function()
    local current_filetype = vim.bo.filetype
    vim.cmd('enew')
    vim.schedule(function()
        vim.bo.filetype = current_filetype
    end)
end, {})

map_key('<D-n>', 'NewBufSameType')
-- close buffer
map_key('<D-w>', 'BufDel')
-- switch to the left buffer
map_key('<D-A-Right>', 'BufferLineCycleNext')
-- switch to the right buffer
map_key('<D-A-Left>', 'BufferLineCyclePrev')


-- Tabs
-- new tab
map_key('<D-t>', 'tabnew')
-- switch to the right tab
map_key('<D-A-S-Right>', 'tabnext')
-- switch to the left tab
map_key('<D-A-S-Left>', 'tabprevious')
-- close tab/window
map_key('<D-W>', 'q')


-- Editing
-- cut
map_key('<D-x>', 'delete')
vim.api.nvim_set_keymap('x', '<D-x>', 'x', { noremap = true, silent = true })
-- copy
map_key('<D-c>', 'yank')
vim.api.nvim_set_keymap('x', '<D-c>', 'y', { noremap = true, silent = true })
-- paste
remap_key('<D-v>', 'P')
vim.api.nvim_set_keymap('x', '<D-v>', 'p', { noremap = true, silent = true })
-- wrap in selected text
function _G.wrap_text(open_char, close_char)
    local save_reg = vim.fn.getreg('a')
    local save_regtype = vim.fn.getregtype('a')
    vim.api.nvim_command('normal! "ay')
    local yanked_text = vim.fn.getreg('a')
    vim.fn.setreg('a', save_reg, save_regtype)
    vim.api.nvim_command('normal! gv"ad')
    vim.api.nvim_put({ open_char .. yanked_text .. close_char }, 'c', false, true)
end

vim.api.nvim_set_keymap('x', '}', '<cmd>lua wrap_text("{", "}")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', ']', '<cmd>lua wrap_text("[", "]")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', ')', '<cmd>lua wrap_text("(", ")")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '"', '<cmd>lua wrap_text(\'"\', \'"\')<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', "'", '<cmd>lua wrap_text("\'", "\'")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '`', '<cmd>lua wrap_text("`", "`")<CR>', { noremap = true, silent = true })

-- Moving
-- move to start/end of the line
remap_key('<D-Left>', '^')
remap_key('<D-Right>', '$')
-- remove to the start/end of the line

function DeleteToStartOfLineOrPrevious()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    if col == 0 then
        -- If at the start of the line, delete the previous line
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<BS>', true, false, true), 'i', false)
    else
        -- If not at the start, delete to the start of the current line
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>v0c', true, false, true), 'i', false)
    end
end

vim.api.nvim_set_keymap('i', '<D-Backspace>', '<cmd>lua DeleteToStartOfLineOrPrevious()<CR>',
    { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<D-Delete>', '<Esc>vEc', { noremap = true, silent = true })
-- indent/outdent line
vim.api.nvim_set_keymap('i', '<D-]>', '<C-t>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<D-[>', '<Esc><<c', { noremap = true, silent = true })
-- jump to matching bracket
remap_key('<D-0>', '%')
vim.api.nvim_set_keymap('x', '<D-0>', '%', { noremap = true, silent = true })


-- Selection

-- show keyboard shortcuts
map_key('<D-k><D-s>', 'Telescope keymaps')


cmd [[
        " move line down/up
        inoremap <A-Down> <C-o>dd<C-o>p
        inoremap <A-Up> <C-o>dd<C-o>k<C-o>P
        " copy line down/up
        inoremap <A-S-Down> <C-o>yy<C-o>p
        inoremap <A-S-Up> <C-o>yy<C-o>P
        " go to the start of the file
        inoremap <D-Up> <C-o>gg
        " go to the end of the file
        inoremap <D-Down> <C-o>G
        " toggle comment
        inoremap <D-/> <C-o>:lua require('Comment.api').toggle.linewise.current()<CR>
        " select current line
        inoremap <D-l> <C-o>V
        " split vertically
        " inoremap <D-Bslash> <C-o>:vsplit<CR><C-o><C-w>l
    ]]
