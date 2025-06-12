--[[
  File: lualine.lua
  Description: lualine plugin configuration
  See: https://github.com/nvim-lualine/lualine.nvim
]]

local function toggle_background()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end
end

-- Lualine component for background toggle
local background_component = {
  function()
    local icon = vim.o.background == 'dark' and '󰌶' or '󰌵'
    return icon
  end,
  color = { gui = 'bold' },
  on_click = function()
    toggle_background()
    require('lualine').refresh()
  end,
}

-- LSP toggle component
local lsp_toggle_component = {
  function()
    local on   = vim.g.__lsp_toggle_enabled ~= false -- default ON if nil
    local icon = on and '' or '' -- Nerd‑font toggle icons
    return icon .. ' LSP'
  end,
  color = { gui = 'bold' },
  on_click = function()
    vim.cmd('LspToggle') -- flip global flag
    require('lualine').refresh()
  end,
}

local function cwd()
  local current_directory = vim.fn.getcwd()
  return vim.fn.fnamemodify(current_directory, ":t")
end

require('lualine').setup({
  sections = {
    lualine_a = {
      { 'mode', fmt = function(str) return str:sub(1, 1) end }
    },
    lualine_b = {
      {
        'branch',
        on_click = function()
          cmd [[Telescope git_branches]]
        end
      },
      {
        'diagnostics',
        on_click = function()
          cmd [[Trouble]]
        end
      },
    },
    lualine_c = {
      {
        cwd,
        color = {
          gui = 'bold',
        },
        separator = ''
      },
      {
        'filename',
        path = 1,
        on_click = function()
          cmd [[Telescope find_files]]
        end,
        padding = { left = 1, right = 0 },
      },
    },
    lualine_x = {
      { require('NeoComposer.ui').status_recording },
    },
    lualine_y = {
      {
        'filetype',
        on_click = function()
          cmd [[Telescope filetypes]]
        end,
        fmt = function(text)
          if text == '' or text == nil then
            return 'NOT SET'
          else
            return text
          end
        end
      },
    },
    lualine_z = {
      "location",
      background_component,
      lsp_toggle_component,
    }
  },
  options = {
    globalstatus = true,
    component_separators = { '', '' },
    section_separators = { '', '' }
  },
})

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "background",
  callback = function()
    require('lualine').refresh()
  end,
})
