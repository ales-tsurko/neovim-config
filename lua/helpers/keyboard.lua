-- Alias for function, that set new keybindings
local map = vim.api.nvim_set_keymap

-- Normal mode keybinding setter
function nm(key, command, desc)
    map('n', key, command, { noremap = true, silent = true, desc = desc })
end

-- Input mode keybinding setter
function im(key, command, desc)
    map('i', key, command, { noremap = true, silent = true, desc = desc })
end

-- Visual mode keybinding setter
function vm(key, command, desc)
    map('v', key, command, { noremap = true, silent = true, desc = desc })
end

-- Terminal mode keybinding setter
function tm(key, command, desc)
    map('t', key, command, { noremap = true, silent = true, desc = desc })
end
