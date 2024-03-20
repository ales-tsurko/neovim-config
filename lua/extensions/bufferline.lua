require("bufferline").setup({
    options = {
        diagnostics = "nvim_lsp",
        color_icons = false,
        show_close_icon = false,
        hover = {
            enabled = true,
            delay = 50,
            reveal = {'close'}
        }
    }
})