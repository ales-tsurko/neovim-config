require("twilight").setup({
    dimming = { alpha = 0.33 },
    expand = {   -- for treesitter, we we always try to expand to the top-most ancestor with these types
        "function",
        "method",
        "table",
        "if_statement",
        "struct",
        "enum",
    },
    exclude = { "startify" },
})
