-- Always keep cursor vertically centered
local api = vim.api
local opt = vim.opt

-- Set initial large scrolloff
opt.scrolloff = 999

-- Function to create virtual lines for smaller documents
local function CenterCursor()
  -- Get window and buffer info
  local win_height = api.nvim_win_get_height(0)
  local buf_line_count = api.nvim_buf_line_count(0)
  local current_pos = api.nvim_win_get_cursor(0)
  local half_screen = math.floor(win_height / 2)
  
  -- Create "virtual padding" through scrolloff adjustment
  if buf_line_count <= win_height then
    -- Keep cursor in the middle regardless of document size
    local scroll_amount = half_screen
    vim.wo.scrolloff = scroll_amount
    
    -- Create extra visual space by inserting and then removing a line when at EOF
    -- Only do this when cursor is near the end of the document
    if current_pos[1] >= buf_line_count - half_screen then
      -- We need to move the document "up" to keep cursor centered
      -- Store current view state
      local view = vim.fn.winsaveview()
      
      -- Add temp line at the end and restore view exactly
      local lazyredraw = vim.o.lazyredraw
      vim.o.lazyredraw = true
      
      -- Adjust the view to keep cursor in the center
      view.topline = math.max(1, current_pos[1] - half_screen)
      vim.fn.winrestview(view)
      
      -- Reset lazyredraw
      vim.o.lazyredraw = lazyredraw
    end
  else
    -- For normal documents, use the default large scrolloff
    vim.wo.scrolloff = 999
  end
end

-- Create autocommand group
local group = api.nvim_create_augroup("AlwaysCenterCursor", { clear = true })

-- Apply centering behavior on relevant events
api.nvim_create_autocmd({
  "BufEnter", "WinEnter", "WinScrolled", "CursorMoved", "CursorMovedI", "VimResized"
}, {
  group = group,
  callback = CenterCursor
})

-- Export function for use in keymaps
return {
  CenterCursor = CenterCursor
}