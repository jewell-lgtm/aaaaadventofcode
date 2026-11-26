-- aoc.nvim: drive the `aoc` CLI without leaving Neovim.
-- Every call shells out to `aoc … --json` asynchronously; the CLI owns all state.
local M = {}

M.config = {
  cmd = 'aoc',
  root = vim.fn.expand '~/Code/jewell-lgtm/aaaaadventofcode',
  test_on_save = false, -- toggle with :AocWatch
  open_puzzle = true, -- :Aoc opens puzzle.md in a vsplit next to the solution
  keys = true,
}

local state = { info = nil, running = false, watch = false }

-- ── helpers ────────────────────────────────────────────────────────────────

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = 'aoc' })
end

--- cwd for the CLI: the current buffer's dir when it's inside the repo (target = that day), else repo root.
local function cwd()
  local dir = vim.fn.expand '%:p:h'
  if dir ~= '' and vim.startswith(dir, M.config.root) then
    return dir
  end
  return M.config.root
end

--- Run `aoc <args> --json`, decode the result, call cb(data) on the main loop.
function M.cli(args, cb, opts)
  opts = opts or {}
  local cmd = vim.list_extend({ M.config.cmd }, args)
  table.insert(cmd, '--json')
  if not opts.silent then
    state.running = true
    vim.cmd.redrawstatus()
  end
  vim.system(cmd, { cwd = opts.cwd or cwd(), text = true }, function(res)
    vim.schedule(function()
      state.running = false
      vim.cmd.redrawstatus()
      local lines = vim.split(vim.trim(res.stdout or ''), '\n')
      local ok, data = pcall(vim.json.decode, lines[#lines] or '')
      if not ok or type(data) ~= 'table' then
        notify(('aoc %s failed:\n%s%s'):format(table.concat(args, ' '), res.stdout or '', res.stderr or ''), vim.log.levels.ERROR)
        return
      end
      if data.error then
        notify(data.error, vim.log.levels.ERROR)
        return
      end
      for _, w in ipairs(data.warnings or {}) do
        notify(w.warning, vim.log.levels.WARN)
      end
      cb(data)
    end)
  end)
end

local function float(lines, title, hl)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].modifiable = false
  local width = 20
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  width = math.min(width + 2, math.floor(vim.o.columns * 0.8))
  local height = math.min(#lines, math.floor(vim.o.lines * 0.7))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    title = ' ' .. title .. ' ',
    title_pos = 'center',
  })
  if hl then
    vim.wo[win].winhighlight = 'FloatBorder:' .. hl
  end
  for _, key in ipairs { 'q', '<Esc>', '<CR>' } do
    vim.keymap.set('n', key, '<cmd>close<cr>', { buffer = buf, nowait = true })
  end
  return buf
end

local function ms(n)
  return n < 1000 and ('%dms'):format(n) or ('%.2fs'):format(n / 1000)
end

local function log_lines(log, out)
  for _, l in ipairs(vim.split(vim.trim(log or ''), '\n')) do
    if l ~= '' then
      table.insert(out, '  │ ' .. l)
    end
    if #out > 200 then
      break
    end
  end
end

--- Line of the n-th [[example]] in examples.toml, for quickfix jumps.
local function example_line(file, n)
  local i, count = 0, 0
  for line in io.lines(file) do
    i = i + 1
    if line:match '^%[%[example%]%]' then
      count = count + 1
      if count == n then
        return i
      end
    end
  end
  return 1
end

-- ── commands ───────────────────────────────────────────────────────────────

local function target_args(fargs)
  return fargs or {}
end

--- :Aoc [target]: start/resume a day, open its solution (and puzzle).
function M.open(fargs)
  local args = vim.list_extend({ 'info' }, target_args(fargs))
  M.cli(args, function(info)
    state.info = info
    vim.cmd.edit(vim.fn.fnameescape(info.solution[tostring(info.part)]))
    if M.config.open_puzzle and vim.fn.filereadable(info.puzzle) == 1 then
      M.puzzle(true)
    end
    notify(('%d day %d%s · part %d · %s%s'):format(info.year, info.day, info.title and (': ' .. info.title) or '', info.part, info.langName, info.langReason and ('\n' .. info.langReason) or ''))
  end)
end

--- Refresh cached info for the statusline (silent).
function M.refresh()
  M.cli({ 'info' }, function(info)
    state.info = info
    vim.cmd.redrawstatus()
  end, { silent = true })
end

function M.test(fargs)
  M.cli(vim.list_extend({ 'test' }, fargs or {}), function(r)
    local lines = {}
    local qf = {}
    if not r.examples or #r.examples == 0 then
      notify(('No part %d examples with expected answers. Edit examples.toml (:AocExamples)'):format(r.part), vim.log.levels.WARN)
      return
    end
    for _, e in ipairs(r.examples) do
      table.insert(lines, ('%s example %d  want %s  got %s  %s%s'):format(e.pass and '✓' or '✗', e.index, e.expected, e.answer or 'error', ms(e.ms), e.auto and '  (auto)' or ''))
      if not e.pass or vim.trim(e.log or '') ~= '' then
        log_lines(e.log, lines)
      end
      if not e.pass and state.info then
        table.insert(qf, {
          filename = state.info.examples,
          lnum = example_line(state.info.examples, e.index),
          text = ('example %d: want %s got %s'):format(e.index, e.expected, e.answer or 'error'),
        })
      end
    end
    vim.fn.setqflist(qf, 'r')
    vim.fn.setqflist({}, 'a', { title = 'aoc test' })
    local title = ('%d/%d · part %d · %s'):format(r.year, r.day, r.part, r.lang)
    if r.pass then
      if M.config.quiet_pass then
        notify('✓ all examples pass · ' .. title)
      else
        float(lines, '✓ ' .. title, 'DiagnosticOk')
      end
    else
      float(lines, '✗ ' .. title, 'DiagnosticError')
    end
  end)
end

function M.run(fargs)
  M.cli(vim.list_extend({ 'run' }, fargs or {}), function(r)
    local lines = {}
    log_lines(r.log, lines)
    local verdict = r.match == true and '✓ matches accepted answer' or r.match == false and ('✗ accepted answer is ' .. r.accepted) or 'unsubmitted, :AocSubmit'
    table.insert(lines, 1, ('⭐ %s   %s   %s'):format(r.answer or ('exit ' .. r.code), ms(r.ms or 0), verdict))
    vim.fn.setreg('+', r.answer or '')
    float(lines, ('%d/%d part %d · input.txt'):format(r.year, r.day, r.part), r.match == false and 'DiagnosticError' or nil)
  end)
end

function M.submit(fargs)
  -- Dry run first (refuses known-wrong answers, failing examples), then confirm.
  M.cli(vim.list_extend({ 'run' }, fargs or {}), function(r)
    if not r.answer then
      return notify('solution failed: exit ' .. tostring(r.code), vim.log.levels.ERROR)
    end
    if r.match == true then
      return notify('already accepted: ' .. r.answer)
    end
    vim.ui.select({ 'Submit ' .. r.answer, 'Cancel' }, { prompt = ('%d day %d part %d → %s?'):format(r.year, r.day, r.part, r.answer) }, function(choice)
      if not choice or choice == 'Cancel' then
        return
      end
      M.cli(vim.list_extend({ 'submit', '-y' }, fargs or {}), function(s)
        local msgs = {
          correct = '⭐ correct!' .. (s.part == 1 and ' Part 2 is unlocked (:AocPuzzle)' or ''),
          done = 'already solved on the site',
          high = '✗ too high',
          low = '✗ too low',
          wrong = '✗ wrong',
          wait = '⏳ too soon',
        }
        local msg = (msgs[s.verdict] or s.message or s.verdict) .. (s.waitSeconds and (' (wait ' .. s.waitSeconds .. 's)') or '')
        notify(msg, (s.verdict == 'correct' or s.verdict == 'done') and vim.log.levels.INFO or vim.log.levels.WARN)
        if s.verdict == 'correct' then
          M.refresh()
          if s.part == 1 then
            M.puzzle(true, true)
          end
        end
      end)
    end)
  end)
end

--- puzzle.md in a vsplit (reused if already open). `refresh` refetches (part 2 after solving).
function M.puzzle(keep_focus, refresh)
  M.cli(refresh and { 'puzzle', '-f' } or { 'puzzle' }, function(p)
    local from = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)) == p.file then
        vim.api.nvim_set_current_win(win)
        vim.cmd 'edit!'
        if keep_focus then
          vim.api.nvim_set_current_win(from)
        end
        return
      end
    end
    vim.cmd('botright vsplit ' .. vim.fn.fnameescape(p.file))
    vim.bo.readonly = true
    vim.wo.wrap = true
    vim.wo.linebreak = true
    if keep_focus then
      vim.api.nvim_set_current_win(from)
    end
  end)
end

function M.examples()
  M.cli({ 'info' }, function(info)
    vim.cmd('split ' .. vim.fn.fnameescape(info.examples))
  end)
end

function M.lang(fargs)
  M.cli(vim.list_extend({ 'lang' }, fargs or {}), function(r)
    if fargs and #fargs > 0 then
      M.open {}
    else
      notify((r.lang or 'none') .. (r.reason and (': ' .. r.reason) or ''))
    end
  end)
end

function M.status(fargs)
  M.cli(vim.list_extend({ 'status' }, fargs or {}), function(r)
    local lines = {}
    for _, y in ipairs(r.years) do
      local cells = {}
      for _, d in ipairs(y.days) do
        table.insert(cells, d.stars == 2 and '★' or d.stars == 1 and '☆' or d.attempted and '·' or ' ')
      end
      table.insert(lines, ('%d  %s  %2d★'):format(y.year, table.concat(cells), y.stars))
    end
    float(lines, 'stars')
  end)
end

function M.verify(fargs)
  notify 'verifying… (this reruns every solved part)'
  M.cli(vim.list_extend({ 'verify' }, fargs or {}), function(r)
    local lines, qf = {}, {}
    for _, row in ipairs(r.rows) do
      if not row.pass and not row.todo then
        table.insert(lines, ('✗ %d %2d p%d %-10s want %s got %s'):format(row.year, row.day, row.part, row.lang, row.expected, row.answer or 'error'))
        table.insert(qf, { filename = ('%s/solutions/%d/day%02d/%s'):format(M.config.root, row.year, row.day, row.lang), text = lines[#lines] })
      end
    end
    vim.fn.setqflist(qf, 'r')
    table.insert(lines, 1, ('%d/%d pass'):format(#r.rows - #qf, #r.rows))
    float(lines, 'verify', r.pass and 'DiagnosticOk' or 'DiagnosticError')
  end)
end

--- Toggle: run :AocTest on every save inside a solutions day dir.
function M.watch()
  state.watch = not state.watch
  notify('test on save ' .. (state.watch and 'on' or 'off'))
end

-- ── gallery ────────────────────────────────────────────────────────────────

--- Telescope picker over machine-gallery/YYYY/dayDD/<lang>/<solution>. <CR> opens, <C-v> vsplits (compare languages).
function M.gallery(fargs)
  local root = M.config.root .. '/machine-gallery'
  local langs_dir = M.config.root .. '/langs'
  local entries = {}
  for _, day in ipairs(vim.fn.glob(root .. '/*/day*', false, true)) do
    local meta = vim.fn.filereadable(day .. '/day.json') == 1 and vim.json.decode(table.concat(vim.fn.readfile(day .. '/day.json'), '\n')) or {}
    for _, langdir in ipairs(vim.fn.glob(day .. '/*/', false, true)) do
      local lang = vim.fn.fnamemodify(langdir:gsub('/$', ''), ':t')
      local spec = langs_dir .. '/' .. lang .. '/lang.json'
      if vim.fn.filereadable(spec) == 1 then
        local l = vim.json.decode(table.concat(vim.fn.readfile(spec), '\n'))
        local filter = fargs and fargs[1]
        if not filter or filter == lang or (meta.title or ''):lower():find(filter:lower(), 1, true) then
          local y, d = day:match '(%d+)/day(%d+)$'
          table.insert(entries, {
            display = ('%s/%s %-26s %s'):format(y, d, meta.title or '', lang),
            file = langdir .. l.solution['1'],
            file2 = langdir .. l.solution['2'],
          })
        end
      end
    end
  end
  local ok, pickers = pcall(require, 'telescope.pickers')
  if not ok then
    return vim.ui.select(entries, { prompt = 'gallery', format_item = function(e) return e.display end }, function(e)
      if e then vim.cmd.edit(e.file) end
    end)
  end
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  pickers
    .new({}, {
      prompt_title = 'AoC gallery: <CR> part 1 · <C-t> part 2 · <C-v> vsplit to compare',
      finder = finders.new_table {
        results = entries,
        entry_maker = function(e)
          return { value = e, display = e.display, ordinal = e.display, path = e.file }
        end,
      },
      sorter = conf.generic_sorter {},
      previewer = conf.file_previewer {},
      attach_mappings = function(buf, map)
        actions.select_default:replace(function()
          actions.close(buf)
          vim.cmd.edit(action_state.get_selected_entry().value.file)
        end)
        map('i', '<C-t>', function()
          actions.close(buf)
          vim.cmd.edit(action_state.get_selected_entry().value.file2)
        end)
        return true
      end,
    })
    :find()
end

-- ── statusline ─────────────────────────────────────────────────────────────

--- `2026·d03·rust ★☆` for the day of the current buffer. Empty outside solutions/.
function M.status_component()
  local i = state.info
  if not i or not vim.startswith(vim.fn.expand '%:p', ('%s/solutions/%d/day%02d'):format(M.config.root, i.year, i.day)) then
    return ''
  end
  local s = ({ [0] = '☆☆', [1] = '★☆', [2] = '★★' })[i.stars] or ''
  return ('%s%d·d%02d·%s %s'):format(state.running and '⏳ ' or '', i.year, i.day, i.lang, s)
end

-- ── setup ──────────────────────────────────────────────────────────────────

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
  -- Local `dir` plugins get no helptags from lazy; build them so :help aoc works.
  local doc = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':h:h:h') .. '/doc'
  if vim.fn.filereadable(doc .. '/tags') == 0 or vim.fn.getftime(doc .. '/aoc.txt') > vim.fn.getftime(doc .. '/tags') then
    pcall(vim.cmd.helptags, doc)
  end
  state.watch = M.config.test_on_save

  local group = vim.api.nvim_create_augroup('aoc', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    pattern = M.config.root .. '/solutions/*',
    callback = function()
      if state.watch and not state.running then
        M.test {}
      end
    end,
  })
  -- Agent-written reference code: read-only, labelled, never mistaken for yours.
  vim.api.nvim_create_autocmd('BufReadPost', {
    group = group,
    pattern = M.config.root .. '/machine-gallery/*',
    callback = function(ev)
      vim.bo[ev.buf].readonly = true
      vim.bo[ev.buf].modifiable = false
      vim.api.nvim_create_autocmd('BufWinEnter', {
        buffer = ev.buf,
        callback = function()
          vim.wo.winbar = '%#DiagnosticWarn# 🤖 machine-gallery: agent-written reference, not yours %*'
        end,
      })
      vim.wo.winbar = '%#DiagnosticWarn# 🤖 machine-gallery: agent-written reference, not yours %*'
    end,
  })
  vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    pattern = M.config.root .. '/solutions/*/day*/*',
    callback = function()
      local i = state.info
      local here = vim.fn.expand '%:p'
      if not i or not vim.startswith(here, ('%s/solutions/%d/day%02d'):format(M.config.root, i.year, i.day)) then
        M.refresh()
      end
    end,
  })

  if M.config.keys then
    local map = function(lhs, fn, desc)
      vim.keymap.set('n', lhs, fn, { desc = desc })
    end
    map('<leader>aa', function() M.open {} end, '[A]oC: open today / current')
    map('<leader>an', function() M.open { 'next' } end, '[A]oC: [n]ext unattempted')
    map('<leader>at', function() M.test {} end, '[A]oC: [t]est examples')
    map('<leader>ar', function() M.run {} end, '[A]oC: [r]un real input')
    map('<leader>as', function() M.submit {} end, '[A]oC: [s]ubmit')
    map('<leader>ap', function() M.puzzle(false) end, '[A]oC: [p]uzzle')
    map('<leader>ae', M.examples, '[A]oC: [e]xamples.toml')
    map('<leader>aw', M.watch, '[A]oC: toggle test on save ([w]atch)')
    map('<leader>al', function() M.lang { 'repick' } end, '[A]oC: re-pick [l]anguage')
    map('<leader>ag', function() M.gallery() end, '[A]oC: [g]allery')
    map('<leader>a*', function() M.status() end, '[A]oC: stars')
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add { { '<leader>a', group = '[A]dvent of Code' } }
    end
  end
end

return M
