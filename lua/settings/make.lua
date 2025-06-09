-- make.lua – compact build helper for Neovim (no external plugins)
--
-- Features
--   * :Make {args…}    – run &makeprg with the given arguments, remember them
--   * :Make            – re‑run the **exact** previous shell line
--   * :MakeAgain       – same as a bare :Make but errors if you never ran it
--   * Live output      – bottom split that shows the last 2 lines while the
--                        build is running (non‑blocking)
--   * Quick‑fix list   – parsed with current &errorformat; opens 8‑line split
--                        only when there are entries
--
-- No dependencies beyond Neovim 0.8 (jobstart API).
-------------------------------------------------------------------------------

local M = {}

-- configurable ----------------------------------------------------------------
local HEIGHT_LOG = 3   -- lines shown while the command runs
local HEIGHT_QF  = 8   -- quick‑fix split height after the run

-------------------------------------------------------------------------------
-- internal state --------------------------------------------------------------
-------------------------------------------------------------------------------
local last_cmd = nil   ---@type string|nil  -- full shell command to repeat

-------------------------------------------------------------------------------
-- helpers ---------------------------------------------------------------------
-------------------------------------------------------------------------------
---Open a real bottom split (not a float) and return {buf, win}.
local function open_log_window()
  vim.cmd(('botright %dsplit'):format(HEIGHT_LOG))
  local win = vim.api.nvim_get_current_win()
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = 'no'
  vim.wo[win].wrap = false
  vim.wo[win].winfixheight = true

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)
  return buf, win
end

---Keep only the last N lines in the buffer.
---@param buf integer
---@param ring table<string>
---@param n integer
local function push_line(buf, ring, n, line)
  if line == '' then return end
  table.insert(ring, line)
  if #ring > n then table.remove(ring, 1) end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, ring)
end

---Run the given shell command asynchronously.
---@param cmd string
local function run_build(cmd)
  local buf, win = open_log_window()
  local ring = {}
  local errfile = vim.fn.tempname()

  vim.fn.jobstart({ 'sh', '-c', cmd }, {
    stdout_buffered = false,
    stderr_buffered = false,

    on_stdout = function(_, data)
      for _, l in ipairs(data) do
        push_line(buf, ring, HEIGHT_LOG, l)
      end
      vim.fn.writefile(data, errfile, 'a')
    end,

    on_stderr = function(_, data)
      for _, l in ipairs(data) do
        push_line(buf, ring, HEIGHT_LOG, l)
      end
      vim.fn.writefile(data, errfile, 'a')
    end,

    on_exit = function(_, code)
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end

        if vim.fn.getfsize(errfile) > 0 then
          vim.cmd('cfile ' .. vim.fn.fnameescape(errfile))
          if #vim.fn.getqflist() > 0 then
            vim.cmd(('botright copen %d'):format(HEIGHT_QF))
            vim.wo.winfixheight = true
          end
        else
          vim.fn.delete(errfile)
        end

        local msg = code == 0 and 'Build succeeded' or 'Build failed'
        local lvl = code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
        vim.notify(msg, lvl)
      end)
    end,
  })
end

-------------------------------------------------------------------------------
-- user commands ----------------------------------------------------------------
-------------------------------------------------------------------------------

---Build the shell command from &makeprg and an argument list.
local function build_command(args)
  local base = (vim.o.makeprg ~= '' and vim.o.makeprg) or 'make'
  if #args == 0 then
    return last_cmd or base
  end
  -- record full command for next repeat
  last_cmd = base .. ' ' .. table.concat(args, ' ')
  return last_cmd
end

vim.api.nvim_create_user_command('Make', function(opts)
  local cmd = build_command(opts.fargs)
  run_build(cmd)
end, {
  nargs = '*',
  complete = 'shellcmd',
})

vim.api.nvim_create_user_command('MakeAgain', function()
  if not last_cmd then
    vim.notify('No previous :Make command', vim.log.levels.WARN)
    return
  end
  run_build(last_cmd)
end, {})

return M
