local vim = vim
local api = vim.api
local fn = vim.fn
local M = {}
local var = require 'lsp.var'

function M.ternary(cond, trueValue, falseValue)
  if cond then
    return trueValue
  else
    return falseValue
  end
end

return M
