-- bindings for insert mode
require "../helpers/globals"
require "../helpers/keyboard"

-- Movement in insert mode
im('<A-Left>', '<C-o>b', "Move cursor word left")
im('<A-Right>', '<Esc>ea', "Move cursor word right")
im('<A-BS>', '<C-w>', "Delete word left")
im('<A-S-BS>', '<C-o>dw', "Delete word right")
im('<C-h>', '<Left>', "Move cursor left")
im('<C-l>', '<Right>', "Move cursor right")
im('<C-j>', '<Down>', "Move cursor down")
im('<C-k>', '<Up>', "Move cursor up")
im('<C-u>', '<C-o><C-u>', "Scroll half page up")
im('<C-d>', '<C-o><C-d>', "Scroll half page down")

-- Use the im function defined in helpers/keyboard.lua instead
local function map_key(key, command, desc)
  im(key, '<cmd>' .. command .. '<CR>', desc)
end

local function remap_key(key, other, desc)
  im(key, '<C-\\><C-o>' .. other, desc)
end

-- -- show commands
-- vim.api.nvim_set_keymap('i', '<C-Space>', '<Esc>:',
--     { noremap = true, silent = false })

-- fuzzy finder
map_key('<D-p>', 'Telescope find_files theme=ivy', "Find files")

-- Buffers

-- save
map_key("<D-s>", "w", "Save file")
-- undo/redo
map_key("<D-z>", "undo", "Undo")
map_key("<D-Z>", "redo", "Redo")


-- new empty buffer
vim.api.nvim_create_user_command('NewBufSameType', function()
  local current_filetype = vim.bo.filetype
  vim.cmd('enew')
  vim.schedule(function()
    vim.bo.filetype = current_filetype
  end)
end, {})

map_key('<D-n>', 'NewBufSameType', "New buffer of same type")
-- close buffer
map_key('<D-w>', 'BufDel', "Close buffer")
-- switch to the next buffer
map_key('<D-A-Right>', 'BufferLineCycleNext', "Next buffer")
-- switch to the previous buffer
map_key('<D-A-Left>', 'BufferLineCyclePrev', "Previous buffer")


-- Tabs
-- new tab
map_key('<D-t>', 'tabnew', "New tab")
-- switch to the right tab
map_key('<D-A-S-Right>', 'tabnext', "Next tab")
-- switch to the left tab
map_key('<D-A-S-Left>', 'tabprevious', "Previous tab")
-- close tab/window
map_key('<D-W>', 'q', "Close tab/window")


-- Editing
-- cut
map_key('<D-x>', 'delete', "Cut")
vm('<D-x>', 'x', "Cut selection")
-- copy
map_key('<D-c>', 'yank', "Copy")
vm('<D-c>', 'y', "Copy selection")
-- paste
remap_key('<D-v>', 'P', "Paste before cursor")
vm('<D-v>', 'p', "Paste over selection")

-- Moving
-- move to start/end of the line
remap_key('<D-Left>', '^', "Move to start of line")
remap_key('<D-Right>', '$', "Move to end of line")
-- delete to the start/end of the line

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

-- Function to delete to end of line in insert mode
function DeleteToEndOfLine()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  if col >= #line then
    -- If at the end of the line, delete the newline
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Del>', true, false, true), 'i', false)
  else
    -- If not at the end, delete to the end of the current line
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>v$c', true, false, true), 'i', false)
  end
end

im('<D-Backspace>', '<cmd>lua DeleteToStartOfLineOrPrevious()<CR>', "Delete to start of line")
im('<D-Delete>', '<cmd>lua DeleteToEndOfLine()<CR>', "Delete to end of line")
-- indent/outdent line
im('<D-]>', '<C-t>', "Indent line")
im('<D-[>', '<Esc><<c', "Outdent line")
-- jump to matching bracket
remap_key('<D-0>', '%', "Jump to matching bracket")
vm('<D-0>', '%', "Jump to matching bracket")


-- Selection
-- select all text
im('<D-a>', '<Esc>ggVG', "Select all")

-- show keyboard shortcuts
map_key('<D-k><D-s>', 'Telescope keymaps', "Show keyboard shortcuts")


-- Line operations
-- move line down/up
im('<A-Down>', '<C-o>dd<C-o>p', "Move line down")
im('<A-Up>', '<C-o>dd<C-o>k<C-o>P', "Move line up")
-- copy line down/up (duplicate)
im('<A-S-Down>', '<C-o>yy<C-o>p', "Duplicate line below")
im('<A-S-Up>', '<C-o>yy<C-o>P', "Duplicate line above")

-- File navigation
-- go to the start of the file
im('<D-Up>', '<C-o>gg', "Go to start of file")
-- go to the end of the file
im('<D-Down>', '<C-o>G', "Go to end of file")

-- Editing
-- toggle comment
im('<D-/>', '<C-o>:lua require("Comment.api").toggle.linewise.current()<CR>', "Toggle comment")
-- select current line
im('<D-l>', '<C-o>V', "Select current line")

-- Window management
-- split vertically
im('<D-Bslash>', '<C-o>:vsplit<CR><C-o><C-w>l', "Split window vertically")
