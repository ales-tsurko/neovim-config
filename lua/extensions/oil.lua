local oil = require('oil')

-- {{{
-- Create custom command for toggling oil in a horizontal split
local original_win = nil

local function find_oil_win()
  local oil_winid = nil

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'oil' then
      oil_winid = win
      break
    end
  end

  return oil_winid
end

-- make OilToggle command which will toggle oil at the top split
local function oil_toggle()
  local oil_winid = find_oil_win()

  if oil_winid then
    -- If oil window exists, close it
    vim.api.nvim_win_close(oil_winid, true)
  else
    original_win = vim.api.nvim_get_current_win()

    -- If oil window doesn't exist, create it at the top
    vim.cmd('topleft split')
    oil.open()
    require('oil.util').run_after_load(0, function()
      oil.open_preview()
    end)

    -- Resize the window to a smaller height (e.g., 15 lines)
    vim.cmd('resize 20')
  end
end

local function select_file()
  oil.select({ close = true }, function()
    local new_bufnr = vim.api.nvim_get_current_buf()
    local current_win = vim.api.nvim_get_current_win()

    -- Switch to the original window and set its buffer to the newly
    -- opened file
    if original_win and vim.api.nvim_win_is_valid(original_win) then
      vim.api.nvim_win_set_buf(original_win, new_bufnr)
      vim.api.nvim_win_close(current_win, true)
      vim.api.nvim_set_current_win(original_win)
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
  watch_for_changes = true,
  -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
  -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
  -- Additionally, if it is a string that matches "actions.<name>",
  -- it will use the mapping at require("oil.actions").<name>
  -- Set to `false` to remove a keymap
  -- See :help oil-actions for a list of all available actions
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = select_file,
    ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
    ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
    ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
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
