if vim.g.loaded_aoc then
  return
end
vim.g.loaded_aoc = true

local function cmd(name, fn, opts)
  vim.api.nvim_create_user_command(name, function(o)
    fn(o.fargs, o)
  end, vim.tbl_extend('force', { nargs = '*', desc = 'aoc: ' .. name }, opts or {}))
end

local aoc = function()
  return require 'aoc'
end

local subcommands = { 'read', 'code', 'next', 'test', 'run', 'submit', 'puzzle', 'examples', 'lang', 'status', 'verify', 'watch', 'gallery' }

cmd('Aoc', function(args)
  local sub = args[1]
  local rest = vim.list_slice(args, 2)
  local m = aoc()
  if sub == nil or sub:match '^%d' then return m.open(args) end
  if sub == 'next' then return m.open(args) end
  if sub == 'puzzle' then return m.puzzle(rest[1] == '-f') end
  if sub == 'read' then return m.read() end
  if sub == 'code' then return m.code() end
  if sub == 'examples' then return m.examples() end
  if sub == 'watch' then return m.watch() end
  if m[sub] then return m[sub](rest) end
  vim.notify('aoc: unknown subcommand ' .. sub, vim.log.levels.ERROR)
end, {
  complete = function(lead, line)
    if #vim.split(line, '%s+') > 2 then
      return {}
    end
    return vim.tbl_filter(function(s) return vim.startswith(s, lead) end, subcommands)
  end,
})
cmd('AocTest', function(a) aoc().test(a) end)
cmd('AocRun', function(a) aoc().run(a) end)
cmd('AocSubmit', function(a) aoc().submit(a) end)
cmd('AocPuzzle', function(a) aoc().puzzle(a[1] == '-f') end)
cmd('AocRead', function() aoc().read() end, { nargs = 0 })
cmd('AocCode', function() aoc().code() end, { nargs = 0 })
cmd('AocMode', function() aoc().toggle() end, { nargs = 0 })
cmd('AocNext', function(a) aoc().open(vim.list_extend({ 'next' }, a)) end)
cmd('AocStatus', function(a) aoc().status(a) end)
cmd('AocLang', function(a) aoc().lang(a) end, { complete = function() return { 'repick', 'ts', 'python', 'rust', 'go', 'haskell', 'kotlin' } end })
cmd('AocWatch', function() aoc().watch() end, { nargs = 0 })
cmd('AocGallery', function(a) aoc().gallery(a) end)
cmd('AocVerify', function(a) aoc().verify(a) end)
