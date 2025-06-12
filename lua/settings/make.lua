-- make.lua – floating coloured :Make helper for Neovim ≥ 0.10
-------------------------------------------------------------------------------
-- Dual‑job architecture (final):
--   • **termopen** PTY job for the popup → coloured live output (may show
--     progress bars, fine). No capture.
--   • **jobstart** (non‑PTY) shadow job for quick‑fix → exact raw output as if
--     run in a pipe (no Cargo progress lines). Stdout/stderr are written
--     verbatim to a temp file (newline‑terminated) and passed to :cfile.
--
--   This restores the original quick‑fix behaviour while preserving coloured
--   popup output.
-------------------------------------------------------------------------------

local M                                             = {}

-- user options ---------------------------------------------------------------
local LOG_HEIGHT_FRAC, LOG_MIN_LINES, LOG_MAX_LINES = 0.25, 3, 15
local LOG_WIDTH_FRAC, LOG_MAX_COLS                  = 0.8, 110
local HEIGHT_QF                                     = 8

local last_cmd ---@type string|nil

-------------------------------------------------------------------------------
-- sizing helpers -------------------------------------------------------------
-------------------------------------------------------------------------------
local function calc_height()
  return math.max(LOG_MIN_LINES, math.min(LOG_MAX_LINES,
    math.floor(vim.fn.winheight(0) * LOG_HEIGHT_FRAC)))
end
local function calc_width()
  local w = math.floor(vim.o.columns * LOG_WIDTH_FRAC)
  return math.max(20, math.min(LOG_MAX_COLS, w))
end

-------------------------------------------------------------------------------
-- popup ----------------------------------------------------------------------
-------------------------------------------------------------------------------
local function popup(cmd)
  local w, h = calc_width(), calc_height()
  local row, col = math.floor((vim.o.lines - h) / 2), math.floor((vim.o.columns - w) / 2)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    style = 'minimal',
    border = 'rounded',
    title = ' ' .. cmd .. ' ',
    title_pos = 'center',
    row = row,
    col = col,
    width = w,
    height = h
  })
  vim.wo[win].number = false; vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = 'no'; vim.wo[win].wrap = false; vim.wo[win].winfixheight = true
  return win, buf
end

-------------------------------------------------------------------------------
-- command builder ------------------------------------------------------------
-------------------------------------------------------------------------------
local function build_command(args)
  local base = (vim.o.makeprg ~= '' and vim.o.makeprg) or 'make'
  local function splice(a)
    if base:find('%$%*') then
      return (base:gsub('%$%*', a)):gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
    elseif a ~= '' then
      return base .. ' ' .. a
    else
      return base
    end
  end
  if #args == 0 then return last_cmd or splice('') end
  last_cmd = splice(table.concat(args, ' ')); return last_cmd
end

-------------------------------------------------------------------------------
-- main runner ----------------------------------------------------------------
-------------------------------------------------------------------------------
local function run(cmd)
  local win, buf = popup(cmd)
  local errfile = vim.fn.tempname()

  -- Shadow capture job (no PTY) ---------------------------------------------
  local capture_id = vim.fn.jobstart({ 'sh', '-c', cmd }, {
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = function(_, data)
      if type(data) == 'table' then
        for _, l in ipairs(data) do
          if l ~= '' then
            vim.fn.writefile({ l .. '\n' }, errfile,
              'a')
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if type(data) == 'table' then
        for _, l in ipairs(data) do
          if l ~= '' then
            vim.fn.writefile({ l .. '\n' }, errfile,
              'a')
          end
        end
      end
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        local ok = false; if vim.fn.getfsize(errfile) > 0 then
          ok = pcall(vim.cmd,
            'cfile ' .. vim.fn.fnamemodify(errfile, ':p'))
        end
        vim.fn.delete(errfile)
        if ok and #vim.fn.getqflist() > 0 then
          vim.cmd(('botright copen %d'):format(HEIGHT_QF)); vim.cmd('wincmd J')
        end
        if not vim.api.nvim_win_is_valid(win) then return end -- popup may close later
        vim.notify(code == 0 and 'Build succeeded' or 'Build failed',
          code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR)
      end)
    end,
  })

  -- Display job (PTY) --------------------------------------------------------
  vim.fn.termopen({ 'sh', '-c', cmd }, {
    on_exit = function() if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end end,
  })

  vim.cmd('startinsert')
end

-------------------------------------------------------------------------------
-- commands -------------------------------------------------------------------
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command('Make', function(opts) run(build_command(opts.fargs)) end,
  { nargs = '*', complete = 'shellcmd' })
vim.api.nvim_create_user_command('MakeAgain',
  function() if last_cmd then run(last_cmd) else vim.notify('No previous :Make command', vim.log.levels.WARN) end end, {})

return M
