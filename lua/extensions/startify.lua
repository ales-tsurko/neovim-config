vim.g.startify_session_persistence = 1
vim.g.startify_session_autoload = 1
vim.g.startify_change_to_vcs_root = 1
vim.g.startify_change_cmd = 'cd'
vim.g.startify_change_to_dir = 1
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_session_sort = 1


function make_startify_menu()
    local center = math.floor(vim.api.nvim_win_get_width(0)/2)

    -- I don't know why, but the center is not a center... 
    -- making additional offset by eye...
    local padding = center + 20

    local string_padding = string.rep(" ", padding)

    vim.g.startify_padding_left = padding + 10
    vim.g.startify_list_order = {
        { string_padding .. ' Settings:' },
        'commands',
        { string_padding .. '󰚝 Sessions:' },
        'sessions',
        { string_padding .. '󰈢 Recently used:' },
        'files'
    }
end

make_startify_menu()

vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    callback = make_startify_menu,
})

vim.g.startify_fortune_use_unicode = 1
vim.g.startify_session_autoload = 1
vim.g.startify_files_number = 4

vim.g.startify_commands = {
    { p = { 'Lazy (Plugin Manager)', 'Lazy' } },
    { m = { 'Mason', 'Mason' } },
    { s = { 'Settings', 'SLoad config' } },
}

-- Set keybinding for closing current session
nm('<Leader>sc', ':SClose<CR>')
