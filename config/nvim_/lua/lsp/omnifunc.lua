local U = require 'utils'
local M = {};

---@private
local function _str_byteindex_enc(line, index, encoding)
  if not encoding then encoding = 'utf-16' end
  if encoding == 'utf-8' then
    if index then return index else return #line end
  elseif encoding == 'utf-16' then
    return vim.str_byteindex(line, index, true)
  elseif encoding == 'utf-32' then
    return vim.str_byteindex(line, index)
  else
    error("Invalid encoding: " .. vim.inspect(encoding))
  end
end

---@private
local function adjust_start_col(lnum, line, items, encoding)
  local min_start_char = nil
  for _, item in pairs(items) do
    if item.textEdit and item.textEdit.range.start.line == lnum - 1 then
      if min_start_char and min_start_char ~= item.textEdit.range.start.character then
        return nil
      end
      min_start_char = item.textEdit.range.start.character
    end
  end
  if min_start_char then
    return _str_byteindex_enc(line, min_start_char, encoding)
  else
    return nil
  end
end

function M.omnifunc(findstart, base)
  -- local bufnr = resolve_bufnr()
  -- local has_buffer_clients = not tbl_isempty(all_buffer_active_clients[bufnr] or {})
  -- if not has_buffer_clients then
  --   if findstart == 1 then
  --     return -1
  --   else
  --     return {}
  --   end
  -- end

  local pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local line_to_cursor = line:sub(1, pos[2])

  -- Get the start position of the current keyword
  local textMatch = vim.fn.match(line_to_cursor, '\\k*$')

  local params = vim.lsp.util.make_position_params()

  local items = {}
  vim.lsp.buf_request(0, 'textDocument/completion', params, function(err, result, ctx)
    if err or not result or vim.fn.mode() ~= "i" then return end

    -- Completion response items may be relative to a position different than `textMatch`.
    -- Concrete example, with sumneko/lua-language-server:
    --
    -- require('plenary.asy|
    --         ▲       ▲   ▲
    --         │       │   └── cursor_pos: 20
    --         │       └────── textMatch: 17
    --         └────────────── textEdit.range.start.character: 9
    --                                 .newText = 'plenary.async'
    --                  ^^^
    --                  prefix (We'd remove everything not starting with `asy`,
    --                  so we'd eliminate the `plenary.async` result
    --
    -- `adjust_start_col` is used to prefer the language server boundary.
    --
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local encoding = client and client.offset_encoding or 'utf-16'
    U.append_to_file(result)
    local candidates = vim.lsp.util.extract_completion_items(result)
    local startbyte = adjust_start_col(pos[1], line, candidates, encoding) or textMatch
    local prefix = line:sub(startbyte + 1, pos[2])
    local matches = vim.lsp.util.text_document_completion_list_to_complete_items(result, prefix)
    -- TODO(ashkan): is this the best way to do this?
    vim.list_extend(items, matches)
    vim.fn.complete(startbyte + 1, items)
  end)

  -- Return -2 to signal that we should continue completion so that we can
  -- async complete.
  return -2
end

return M
