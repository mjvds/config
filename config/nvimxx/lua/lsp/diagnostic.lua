local lsp_util = require 'vim.lsp.util'
local util = require 'lsp.utility'
local vim = vim
local api = vim.api
local fn = vim.fn
local var = require 'lsp.var'
local M = {}

do
  -- temp storage for diagnostics result when in insert mode
  local diagnostic_result = nil

  local function is_between(row, col, diag)
    if diag.lnum == diag.end_lnum then
      return ((row <= diag.lnum) and (row >= diag.end_lnum)) and
             ((col >= diag.col) and (col < diag.end_col))
    end

    if diag.end_lnum == row and col <= diag.end_col then
      return true
    end

    if diag.col == row and col >= diag.lnum then
      return true
    end

    return row > diag.lnum and row < diag.end_lnum
  end

  show_diagnostic_msg_timer = vim.loop.new_timer()
  function M.show_line_diagnostics()
    local preview_options = {
      focusable = false,
      wrap = true,
      max_width = 150,
      scope = "cursor",
      close_events = { "BufWinLeave", "BufLeave", "CursorMoved" },
      border = "single"
    }
    show_diagnostic_msg_timer:stop()
    show_diagnostic_msg_timer:start(250, 0, vim.schedule_wrap(function()
      vim.diagnostic.open_float(
        0,
        preview_options
      )
    end))
  end

  function M.get_hovered_diag()
    local bufnr = fn.bufnr()
    local row = fn.line('.') - 1
    local col = fn.col('.') - 1

    local diagnostics = vim.diagnostic.get(bufnr, {
      lnum = row
    })
    if not diagnostics or vim.tbl_isempty(diagnostics) then
      return
    end

    for _, diag in ipairs(diagnostics) do
      if is_between(row, col, diag) then
        return diag
      end
    end
    return nil
  end

  function M.close_qflist()
    fn.setqflist({}, "r")
    api.nvim_command('cclose')
  end

  function M.reset_qflist_var()
    api.nvim_set_var(var.qf_buf_target, 0)
    api.nvim_set_var(var.qf_severity, 0)
  end

  function M.show_quickfix_window(bufnr, severity)
    bufnr = util.ternary(bufnr == 0 or bufnr == nil, fn.bufnr(), bufnr)
    severity = severity or 1 -- 1 = error

    local buf_diags = vim.diagnostic.get(bufnr)
    if not buf_diags or vim.tbl_isempty(buf_diags) then
      return
    end
    local quickfix_items = {}
    local qflist_nr = 1
    local quickfix_item_type = util.ternary(severity == 1, "E", "W")
    for _, diag in ipairs(buf_diags) do
      if diag.severity == severity then
        table.insert(quickfix_items, {
          nr = qflist_nr;
          bufnr = bufnr;
          lnum = diag.range.start.line + 1;
          col = diag.range.start.character + 1;
          text = diag.message;
          type = quickfix_item_type
        })
        qflist_nr = qflist_nr + 1
      end
    end
    if #quickfix_items == 0 then
      print("no diagnostic found.")
      return
    end
    fn.setqflist(quickfix_items, "r")
    api.nvim_command("copen")
    api.nvim_set_var(var.qf_buf_target, bufnr)
    api.nvim_set_var(var.qf_severity, severity)

    api.nvim_buf_attach(0, false, {
      on_detach = function(bufnr)
        M.reset_qflist_var()
      end
    })

  end

  function M.update_quickfix_buf()
    local qf_target_bufnr = api.nvim_get_var(var.qf_buf_target)
    local bufnr = fn.bufnr()
    if qf_target_bufnr == bufnr then
      local buf_diags = vim.diagnostic.get(qf_target_bufnr)
      if not buf_diags or vim.tbl_isempty(buf_diags) then
        M.close_qflist()
        return
      end
      local quickfix_items = {}
      local error_nr = 1
      local severity = api.nvim_get_var(var.qf_severity)
      local quickfix_item_type = util.ternary(severity == 1, "E", "W")
      for _, diag in ipairs(buf_diags) do
        if diag.severity == severity then
          table.insert(quickfix_items, {
            nr = error_nr;
            bufnr = bufnr;
            lnum = diag.range.start.line + 1;
            col = diag.range.start.character + 1;
            text = diag.message;
            type = quickfix_item_type
          })
          error_nr = error_nr + 1
        end
      end
      if #quickfix_items == 0 or vim.tbl_isempty(quickfix_items) then
        M.close_qflist()
        return
      end
      fn.setqflist(quickfix_items, "r")
    end
  end

  function M.goto_next()
    if #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) ~= 0 then
      vim.diagnostic.goto_next({ float = false, severity = vim.diagnostic.severity.ERROR })
    else
      vim.diagnostic.goto_next({ float = false })
    end
  end

  function M.goto_prev()
    if #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) ~= 0 then
      vim.diagnostic.goto_prev({ float = false, severity = vim.diagnostic.severity.ERROR })
    else
      vim.diagnostic.goto_prev({ float = false })
    end
  end

end

return M
