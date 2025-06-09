require("origami").setup {
  keepFoldsAcrossSessions = false,
  pauseFoldsOnSearch = true,
  autoFold = {
    enabled = false,
    kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
  },
  foldKeymaps = {
    setup = true
  },
  hOnlyOpensOnFirstColumn = false,
}
