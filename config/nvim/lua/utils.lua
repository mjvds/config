local M = {}

function M.starts_with(str, start)
  if str == nil then return false end
  return str:sub(1, #start) == start
end

function M.get_table_keys(tbl)
  local keys = {}
  for k,v in pairs(tbl) do
    table.insert(keys, k)
  end
  return keys
end

function M.ternary(cond, t, f)
  if cond then
    return t
  else
    return f
  end
end

function M.tbl_iter(tbl, cb)
  local keys = M.get_table_keys(tbl)
  for i, v in ipairs(keys) do
    local prev = nil
    local next = nil
    if i ~= 1 then
      prev = tbl[keys[i - 1]]
    end
    if i ~= #keys then
      next = tbl[keys[i + 1]]
    end
    cb(tbl[keys[i]], next, prev, i, i == 1, i == #keys)
  end
end

-- this is for debugging only
function M.append_to_file(tbl)
  local file = io.open("sample.json", "a")
  io.output(file)
  local content = vim.inspect(tbl)
  io.write(content)
  io.close(file)
end

function M.find_index_by_value(tbl, value)
  for i,v in ipairs(tbl) do
    if v == value then
      return i
    end
  end
  return 0
end

local scopes = {
  o = vim.o,    -- global options
  b = vim.bo,   -- buffer options
  w = vim.wo    -- window options
}
function M.set_opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
  if scopes[scope] == nil then
    print('Invalid option: ' .. key ' ' .. value)
    return
  end

  if scope == 'o' then
    vim.api.nvim_set_option(key, value)
  elseif scope == 'w' then
    vim.api.nvim_win_set_option(0, key, value)
  elseif scope == 'b' then
    vim.api.nvim_buf_set_option(0, key, value)
  end
end

function M.map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.ends_with(str, ending)
  if str == nil then return false end
  return ending == "" or str:sub(-#ending) == ending
end

return M
