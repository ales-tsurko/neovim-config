require("dropbar").setup({
    bar = {
        enable = function(buf, win)
            return vim.fn.win_gettype(win) == ''
                and vim.wo[win].winbar == ''
                and vim.bo[buf].bt == ''
                and (
                    vim.bo[buf].ft == 'markdown'
                    or (
                        buf
                        and vim.api.nvim_buf_is_valid(buf)
                        and (pcall(vim.treesitter.get_parser, buf, vim.bo[buf].ft))
                        and true
                        or false
                    )
                )
                -- disabled fyletypes (the rest is defaults)
                and vim.bo[buf].ft ~= 'org'
                and vim.bo[buf].ft ~= 'json'
        end
    }
})
