local null_ls = require('null-ls')

-- code action sources
local code_actions = null_ls.builtins.code_actions

-- diagnostic sources
local diagnostics = null_ls.builtins.diagnostics

-- hover sources
local hover = null_ls.builtins.hover

-- completion sources
--local completion = null_ls.builtins.completion

local sources = {
    hover.dictionary,
    hover.printenv,
    diagnostics.write_good,
    diagnostics.selene,
}

null_ls.setup {
    sources = sources,
}
