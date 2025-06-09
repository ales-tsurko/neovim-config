-- lspconfig.lua  (patched with global LSP toggle + flag for lualine)

local lspconfig       = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
local capabilities    = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup()

mason_lspconfig.setup({
  ensure_installed = {
    'lua_ls',
    -- 'pyright',
    'rust_analyzer',
    'taplo',
    'wgsl_analyzer',
    'ts_ls',
    'efm',
    'slint_lsp',
  },
  automatic_enable = true, -- keep Mason-lspconfig default behaviour
})

------------------------------------------------------------------------
-- ▶  Individual server setups
------------------------------------------------------------------------

lspconfig.lua_ls.setup({ capabilities = capabilities })

lspconfig.ts_ls.setup({ capabilities = capabilities })

lspconfig.rust_analyzer.setup({ capabilities = capabilities })

lspconfig.taplo.setup({ capabilities = capabilities })

lspconfig.wgsl_analyzer.setup({ capabilities = capabilities })

lspconfig.efm.setup({ capabilities = capabilities })

lspconfig.slint_lsp.setup({ capabilities = capabilities })

------------------------------------------------------------------------
-- ▶  Diagnostics UI
------------------------------------------------------------------------

local icons = {
  [vim.diagnostic.severity.ERROR] = '',
  [vim.diagnostic.severity.WARN]  = '',
  [vim.diagnostic.severity.HINT]  = '',
  [vim.diagnostic.severity.INFO]  = '',
}

vim.diagnostic.config({
  signs         = { text = icons },
  virtual_text  = true,
  underline     = true,
  severity_sort = true,
})

------------------------------------------------------------------------
-- ▶  Global LSP master switch
------------------------------------------------------------------------

local _lsp_enabled = true ---@type boolean
vim.g.__lsp_toggle_enabled = _lsp_enabled -- expose state for lualine

local function stop_all_clients()
  for _, c in ipairs(vim.lsp.get_clients()) do
    vim.lsp.stop_client(c.id, true)
  end
end

local function _set(on)
  if on == _lsp_enabled then return end
  _lsp_enabled = on
  vim.g.__lsp_toggle_enabled = on -- update flag for lualine
  if not on then stop_all_clients() end
  vim.notify(('LSP is now %s'):format(on and 'ON' or 'OFF'))
end

vim.api.nvim_create_user_command('LspOn', function() _set(true) end, { desc = 'Enable all LSP' })
vim.api.nvim_create_user_command('LspOff', function() _set(false) end, { desc = 'Disable all LSP' })
vim.api.nvim_create_user_command('LspToggle', function() _set(not _lsp_enabled) end,
  { desc = 'Toggle global LSP' })

vim.api.nvim_create_user_command('LspStatus', function()
  print(('Global LSP: %s'):format(_lsp_enabled and 'ON' or 'OFF'))
  local clients = vim.lsp.get_clients()
  if vim.tbl_isempty(clients) then
    print('  (no active clients)')
    return
  end
  for _, c in ipairs(clients) do
    local bufs = {}
    for b in pairs(c.attached_buffers) do
      bufs[#bufs + 1] = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ':t')
    end
    print(('  • %-14s [%s]'):format(c.name, table.concat(bufs, ',')))
  end
end, { desc = 'Show global LSP state and active clients' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(a)
    if not _lsp_enabled then
      local c = vim.lsp.get_client_by_id(a.data.client_id)
      if c then vim.defer_fn(function() vim.lsp.stop_client(c.id, true) end, 0) end
    end
  end,
})
