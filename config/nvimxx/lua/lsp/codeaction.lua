local vim = vim
local util = require 'utils'
local diag = require 'lsp.diagnostic'
local M = {}

function M.import_module()
  local hovered_diag = diag.get_hovered_diag()
  if hovered_diag == nil or vim.tbl_isempty(hovered_diag) then
    return
  end
  local function callback(...)
    local _, _, result = ...
    if vim.tbl_isempty(result) or vim.tbl_isempty(result[1]) then return end
    -- this will check if the codeAction is not import
    -- this may not be accurate
    if string.match(result[1].title, "Remove declaration for") then
      return
    end
    vim.lsp.util.apply_text_document_edit(result[1].arguments[1].documentChanges[1])
    hovered_diag = nil
  end
  local params = M.diagnostic_to_codeaction_req(hovered_diag)
  vim.lsp.buf_request(0, 'textDocument/codeAction', params, callback)
end

function M.get_fixes()
  local diag = diag.get_hovered_diag()
  if diag == nil then return end
  local diagnostics = {}
  table.insert(diagnostics, {
    range = {
      start = {
        line = diag.lnum,
        character = diag.col
      },
      ["end"] = {
        line = diag.end_lnum,
        character = diag.end_col
      }
    },
    message = diag.message,
    severity = diag.severity,
    source = diag.source
  })
  local params = vim.lsp.util.make_range_params();
  params.context = { ['diagnostics'] = diagnostics }
  vim.lsp.buf.code_action(params)
end

function M.set_fixes_result(result, winnr)
  vim.g.fixes_result = result
  vim.g.fixes_result_winnr = winnr
end

function M.fix_result()
  if vim.g.fixes_result ~= nil then
    local index = vim.fn.line('.')
    local results = vim.g.fixes_result;
    if results[index] and not vim.tbl_isempty(results[index]) then
      local result = results[index]
      local bufnr = nil
      if result.command ~= nil and util.ends_with(result.command.command, "executeCodeAction") then
        -- vim.lsp.buf.execute_command(result.command)
        bufnr = vim.uri_to_bufnr(result.command.arguments[1].Uri)
        vim.lsp.buf_request(bufnr, "workspace/executeCommand", result.command)
      elseif result.command ~= nil and util.ends_with(result.command.command, "applyWorkspaceEdit") then
        -- for ts lsp
        local code_changes = result.command.arguments[1].documentChanges[1]
        vim.lsp.util.apply_text_document_edit(code_changes)
        bufnr = vim.uri_to_bufnr(code_changes.textDocument.uri)
        -- focus on fixed window
        vim.fn.win_gotoid(vim.fn.get(vim.fn.win_findbuf(bufnr), 0))
      else
        print("response is not handle " .. result.command)
      end
      -- close window
      vim.fn.win_gotoid(vim.fn.get(vim.fn.win_findbuf(bufnr), 0))
    end
  else
  end
  vim.g.fixes_result = nil
  vim.g.fixes_result_winnr = nil
end

function M.organize_imports()
  local commandName = ""
  local filetype = vim.bo.filetype
  if filetype == "cs" then
    commandName = "omnisharp"
  elseif filetype == "typescript" then
    commandName = "_typescript"
  end
  local params = {
    command = commandName .. ".organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

return M
