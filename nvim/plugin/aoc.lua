if vim.g.loaded_aoc then
  return
end
vim.g.loaded_aoc = true

-- One command. `:Aoc` alone opens today / the current day; `:Aoc <sub>` for everything else.
-- <leader>a opens the same actions as a picker.
local aoc = function()
  return require 'aoc'
end

local subs = {
  menu = function() aoc().menu() end,
  test = function(a) aoc().test(a) end, -- :Aoc test [p1|p2]
  run = function(a) aoc().run(a) end, -- real input
  submit = function(a) aoc().submit(a) end,
  read = function() aoc().read() end, -- tab 1: puzzle · example · input
  code = function() aoc().code() end, -- tab 2: solution
  exec = function() aoc().exec() end, -- tab 3: aoc watch terminal
  mode = function() aoc().toggle() end, -- cycle read → code → exec
  next = function(a) aoc().open(vim.list_extend({ 'next' }, a)) end,
  puzzle = function(a) aoc().puzzle(a[1] == '-f') end, -- -f refetches (part 2)
  examples = function() aoc().examples() end,
  lang = function(a) aoc().lang(a) end, -- [id|repick]
  watch = function() aoc().watch() end, -- toggle test on save
  status = function(a) aoc().status(a) end,
  verify = function(a) aoc().verify(a) end,
  gallery = function(a) aoc().gallery(a) end,
}

vim.api.nvim_create_user_command('Aoc', function(o)
  local sub, rest = o.fargs[1], vim.list_slice(o.fargs, 2)
  if sub == nil or sub:match '^%d' then
    return aoc().open(o.fargs) -- :Aoc · :Aoc 2017 3 · :Aoc 2026
  end
  if not subs[sub] then
    return vim.notify('aoc: unknown subcommand ' .. sub .. ' (try :Aoc <Tab>)', vim.log.levels.ERROR)
  end
  subs[sub](rest)
end, {
  nargs = '*',
  desc = 'Advent of Code',
  complete = function(lead, line)
    local words = vim.split(line, '%s+')
    if #words == 2 then
      return vim.tbl_filter(function(s) return vim.startswith(s, lead) end, vim.tbl_keys(subs))
    end
    if words[2] == 'lang' then
      return vim.tbl_filter(function(s) return vim.startswith(s, lead) end, { 'repick', 'ts', 'python', 'rust', 'go', 'haskell', 'kotlin', 'ocaml', 'elixir' })
    end
    if vim.tbl_contains({ 'test', 'run', 'submit' }, words[2]) then
      return { 'p1', 'p2' }
    end
    return {}
  end,
})
