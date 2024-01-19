local function ensure_nvim_directory()
    local nvim_dir = vim.fn.getcwd() .. '/.nvim'
    if vim.fn.isdirectory(nvim_dir) == 0 then
        vim.fn.mkdir(nvim_dir, "p")
        vim.fn.mkdir(nvim_dir .. '/view/', "p")
    end
    return nvim_dir
end

local function update_view_dir()
    local nvim_dir = ensure_nvim_directory()
    local view_dir = nvim_dir .. "/view"
    if vim.fn.isdirectory(view_dir) == 0 then
        vim.fn.mkdir(view_dir, "p")
    end
    vim.o.viewdir = view_dir
    vim.cmd("silent! loadview")
end

vim.api.nvim_create_augroup("RememberFolds", { clear = true })

vim.api.nvim_create_autocmd("BufWinLeave", {
    group = "RememberFolds",
    pattern = "*.*",
    command = "mkview"
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = "RememberFolds",
    pattern = "*.*",
    command = "silent! loadview"
})

vim.api.nvim_create_autocmd("DirChanged", {
    pattern = "*",
    callback = update_view_dir,
})
