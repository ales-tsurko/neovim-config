require("telescope").setup({
    defaults = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
            width = 0.5,
            prompt_position = "top",
            vertical = {
                prompt_position = "top",
                mirror = true
            }
        },
        windblend = 30,
        prompt_prefix = "🔍 ",
        selection_caret = "▊ ",
        -- borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        borderchars = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
        dynamic_preview_title = true,
    },
    pickers = {
        find_files = {
            hidden = true
        }
    },
    extensions = {
        helpgrep = {
            ignore_paths = {
                vim.fn.stdpath("state") .. "/lazy/readme",
            },
        }
    }
})

require("telescope").load_extension("frecency")
-- require("telescope").load_extension('cmdline')
require("telescope").load_extension("ui-select")
require("telescope").load_extension("helpgrep")
