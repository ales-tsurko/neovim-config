--[[
  File: treesitter.lua
  Description: Configuration of tree-sitter
  See: https://github.com/tree-sitter/tree-sitter
]]
require'nvim-treesitter.configs'.setup {

  -- Needed parsers
  ensure_installed = {
      "c",
      "comment",
      "cpp",
      "css",
      "diff",
      "dockerfile",
      "git_rebase",
      "git_rebase",
      "gitcommit",
      "gitignore",
      "go",
      "html",
      "javascript",
      "json",
      "julia",
      "lua",
      "markdown",
      "markdown_inline",
      -- "nu",
      -- "org",
      "python",
      "regex",
      "rust",
      "supercollider",
      "toml",
      "typescript",
      "vimdoc",
      "wgsl",
      "yaml",
  },

  -- Install all parsers synchronously
  sync_install = false,

  highlight = {
    -- Enabling highlight for all files
    enable = true,
    disable = {},
  },

  indent = {
    -- Disabling indentation for all files
    enable = false,
    disable = {},
  }
}
