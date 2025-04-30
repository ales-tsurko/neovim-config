-- Markdown list folding function for neovim
-- Folds markdown lists with sublists, similar to how orgmode folds headers
-- Works with both regular lists and checkbox lists
-- Handles indented text within list items (paragraphs within a list item)

function MdListFoldExpr()
  local line = vim.fn.getline(vim.v.lnum)

  -- Function to check if a line has a list marker and get its indentation
  local function get_list_info(str)
    -- Check for various list patterns
    local patterns = {
      "^(%s*)[-*+]%s+",             -- Unordered list
      "^(%s*)%d+%.%s+",             -- Ordered list
      "^(%s*)[-*+]%s+%[[ xX]%]%s+", -- Unordered checkbox
      "^(%s*)%d+%.%s+%[[ xX]%]%s+"  -- Ordered checkbox
    }

    for _, pattern in ipairs(patterns) do
      local indent = str:match(pattern)
      if indent then
        return true, indent
      end
    end

    return false, nil
  end

  -- Function to get indentation of any line
  local function get_indent(str)
    return str:match("^(%s*)")
  end

  -- Function to convert indentation to fold level
  local function indent_to_level(indent)
    return math.floor(#indent / 2) + 1
  end

  -- Check if current line is a list item
  local is_list, list_indent = get_list_info(line)

  if is_list then
    -- This is a list item, return fold level based on indentation
    return ">" .. indent_to_level(list_indent)
  else
    -- Not a list item, check if it belongs to one

    -- Handle empty lines
    if line:match("^%s*$") then
      -- For empty lines, we need to check if there are any list items ahead
      -- that this line might be separating
      local next_lnum = vim.v.lnum + 1
      local max_lines = vim.fn.line('$')
      local prev_lnum = vim.v.lnum - 1

      if prev_lnum > 0 then
        local prev_line = vim.fn.getline(prev_lnum)
        local prev_is_list, prev_list_indent = get_list_info(prev_line)

        -- If previous line is a list item
        if prev_is_list then
          local prev_indent_len = #prev_list_indent

          -- Check if there are any future list items with the same or deeper indent
          local has_future_list_items = false
          while next_lnum <= max_lines do
            local next_line = vim.fn.getline(next_lnum)
            local next_is_list, next_list_indent = get_list_info(next_line)

            -- Skip empty lines
            if next_line:match("^%s*$") then
              next_lnum = next_lnum + 1
            elseif next_is_list then
              -- Found a list item
              local next_indent_len = #next_list_indent

              -- If next list item has same or deeper indent, include this empty line
              if next_indent_len >= prev_indent_len then
                has_future_list_items = true
                break
              else
                -- Next list item has less indent, don't include this empty line
                break
              end
            else
              -- Non-empty, non-list line, don't include empty line in fold
              break
            end
          end

          if has_future_list_items then
            return "="
          else
            return 0 -- Don't fold this empty line
          end
        end
      end

      if vim.v.lnum > 1 then
        return "="
      else
        return 0
      end
    end

    -- Get indentation of current line
    local current_indent = get_indent(line)
    local current_indent_len = #current_indent

    -- Search backward for a list item this might belong to
    local prev_lnum = vim.v.lnum - 1
    while prev_lnum > 0 do
      local prev_line = vim.fn.getline(prev_lnum)
      local prev_is_list, prev_list_indent = get_list_info(prev_line)

      if prev_is_list then
        -- Found a list item
        local prev_indent_len = #prev_list_indent

        -- If current line is indented more than the list marker,
        -- it belongs to that list item
        if current_indent_len > prev_indent_len then
          return indent_to_level(prev_list_indent)
        else
          -- Not indented enough to be part of this list
          break
        end
      end

      -- Skip blank lines
      if prev_line:match("^%s*$") then
        prev_lnum = prev_lnum - 1
      else
        -- If previous non-list, non-blank line has same indentation,
        -- keep looking upward
        local prev_indent = get_indent(prev_line)
        if #prev_indent == current_indent_len then
          prev_lnum = prev_lnum - 1
        else
          -- Indentation mismatch, not part of a list
          break
        end
      end
    end

    -- Not part of a list
    return 0
  end
end

-- Make the function available globally for v:lua
_G.MdListFoldExpr = MdListFoldExpr

-- Simple fold text function that preserves conceals
function MdListFoldText()
  local line = vim.fn.getline(vim.v.foldstart)
  return line .. " ..."
end

-- Make the function available globally for v:lua
_G.MdListFoldText = MdListFoldText

-- Set fold options (add this to your init.lua or wrap in an autocmd for markdown files)
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown", "md" },
  callback = function()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'v:lua.MdListFoldExpr()'
    vim.opt_local.foldtext = 'v:lua.MdListFoldText()'

    -- Create a custom highlight group for folded lines using a brighter version of the current background
    local function get_brighter_bg()
      -- Get the current background color
      local bg = vim.fn.synIDattr(vim.fn.hlID('Normal'), 'bg#')

      if bg == "" then
        -- Fallback if we couldn't get background color
        return 'highlight MdListFold guibg=#E8E8E8 ctermbg=254'
      end

      -- Function to convert hex to RGB
      local function hex_to_rgb(hex)
        hex = hex:gsub("#", "")
        return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
      end

      -- Function to convert RGB to hex
      local function rgb_to_hex(r, g, b)
        return string.format("#%02X%02X%02X", r, g, b)
      end

      -- Function to make color brighter
      local function brighten(r, g, b, amount)
        amount = amount or 20 -- default brightening amount
        r = math.min(255, r + amount)
        g = math.min(255, g + amount)
        b = math.min(255, b + amount)
        return r, g, b
      end

      -- Process the color
      local r, g, b = hex_to_rgb(bg)
      r, g, b = brighten(r, g, b)
      local brighter_bg = rgb_to_hex(r, g, b)

      return 'highlight MdListFold guibg=' .. brighter_bg
    end

    vim.api.nvim_command(get_brighter_bg())
    vim.opt_local.foldenable = true

    -- Link the Folded highlight group to our custom group
    vim.api.nvim_command('highlight! link Folded MdListFold')

    -- Remove fill characters
    vim.opt_local.fillchars:append { fold = " " }
  end
})
