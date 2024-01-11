--[[
  File: lualine.lua
  Description: lualine plugin configuration
  See: https://github.com/nvim-lualine/lualine.nvim
]]

local function cwd()
    local current_directory = vim.fn.getcwd()
    return vim.fn.fnamemodify(current_directory, ":t")
end

require('lualine').setup({
    sections = {
        lualine_b = {
            {
                'branch',
                on_click = function()
                    cmd [[Telescope git_branches]]
                end
            },
            {
                'diff',
                on_click = function()
                    cmd [[DiffviewOpen]]
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
                on_click = function()
                    cmd [[Telescope persisted]]
                end,
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
                separator = '@',
                padding = { left = 1, right = 0 },
            },
            {
                "location",
                padding = 0,
            },
        },
        lualine_x = {

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
            "progress",
        }
    },
    options = {
        globalstatus = true,
        component_separators = { '', '' },
        section_separators = { '', '' }
    },
})
