local oil = require('oil')
local oil_util = require('oil.util')

-- {{{
-- Create custom command for toggling oil in a horizontal split
local original_win = nil

local function find_oil_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'oil' then
      return win
    end
  end
end

local function oil_try_close()
  local oil_winid = find_oil_win()

  if oil_winid then
    -- If oil window exists, close it
    -- we should call this as well, because simple window close (i.e. via api) 
    -- closes only preview sometimes
    oil.close()
    vim.api.nvim_win_close(oil_winid, false)
    return true
  end

  return false
end

-- make OilToggle command which will toggle oil at the top split
local function oil_toggle()
  if oil_try_close() then
    return
  end

  original_win = vim.api.nvim_get_current_win()

  -- If oil window doesn't exist, create it at the top
  vim.cmd('topleft split')
  oil.open()
  vim.wait(1000, function()
    return oil.get_cursor_entry() ~= nil
  end)
  if oil.get_cursor_entry() then
    oil.open_preview()
  end
  -- this doesn't work for parent dirs ¯\_(ツ)_/¯
  -- require('oil.util').run_after_load(0, function()
  --     oil.open_preview()
  -- end)

  -- Resize the window to a smaller height (e.g., 15 lines)
  vim.cmd('resize 20')
end

local function close_all_oil_wins()
  local windows_to_close = {}

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'oil' then
      table.insert(windows_to_close, win)
    end
  end

  for _, win in ipairs(windows_to_close) do
    vim.api.nvim_win_close(win, false)
  end
end

local function select_item()
  oil.select({ close = false }, function()
    local new_bufnr = vim.api.nvim_get_current_buf()

    -- do nothing with folders
    if vim.bo[new_bufnr].filetype == 'oil' then
      return
    end

    local current_win = vim.api.nvim_get_current_win()

    -- Switch to the original window and set its buffer to the newly
    -- opened file
    if original_win and vim.api.nvim_win_is_valid(original_win) then
      vim.api.nvim_win_set_buf(original_win, new_bufnr)
      vim.api.nvim_win_close(current_win, false)
      vim.api.nvim_set_current_win(original_win)
      -- FIXME this doesn't work. in case you open a folder in a preview window
      -- and then open a file in it, only the preview window is closed, but the
      -- main oil window remains open
      close_all_oil_wins()
    else
      print("Unexpectedly got invalid target window")
    end
  end)
end

vim.api.nvim_create_user_command('OilToggle', oil_toggle, {})
-- }}}

oil.setup({
  default_file_explorer = true,
  -- Id is automatically added at the beginning, and name at the end
  -- See :help oil-columns
  columns = {
    "icon",
    -- { "icon", add_padding = false },
    "permissions",
    "mtime",
    "size",
  },
  -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
  delete_to_trash = true,
  -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
  skip_confirm_for_simple_edits = true,
  -- Set to true to watch the filesystem for changes and reload oil
  -- disabled, because it's buggy
  watch_for_changes = false,
  -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
  -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
  -- Additionally, if it is a string that matches "actions.<name>",
  -- it will use the mapping at require("oil.actions").<name>
  -- Set to `false` to remove a keymap
  -- See :help oil-actions for a list of all available actions
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = select_item,
    ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
    ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
    ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
    ["<C-p>"] = "actions.preview",
    ["q"] = oil_try_close,
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
  -- Set to false to disable all of the above keymaps
  use_default_keymaps = true,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
  },
})

-- vim:tabstop=2 shiftwidth=2 expandtab syntax=lua foldmethod=marker foldlevelstart=0
