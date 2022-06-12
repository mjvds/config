local U = require 'utils'
local C = vim.cmd

local function get_lsp_diag_count(daig_name)
  return #vim.diagnostic.get(0, { severity = daig_name })
end

local function get_error()
  local err = get_lsp_diag_count(vim.diagnostic.severity.ERROR)
  if err == 0 then
    return ""
  end
  return " Error: " .. err .. " "
end

local function get_warn()
  local warn = get_lsp_diag_count(vim.diagnostic.severity.WARN)
  if warn == 0 then
    return ""
  end
  return " Warning: " .. warn .. " "
end

local function get_info()
  local info = get_lsp_diag_count(vim.diagnostic.severity.INFO)
  if info == 0 then
    return ""
  end
  return " Info: " .. info .. " "
end

local function get_hint()
  local hint = get_lsp_diag_count(vim.diagnostic.severity.HINT)
  if hint == 0 then
    return ""
  end
  return " Hint: " .. hint .. " "
end

local function get_hi_value(group, term, defaultValue)
  return vim.fn.matchstr(vim.fn.execute('hi ' .. group), term .. "=\\zs\\S*")
end

local function get_right_separator_hl()
    if get_lsp_diag_count(vim.diagnostic.severity.ERROR) ~= 0 then
      return "MyStatusItemDiagError"
    elseif get_lsp_diag_count(vim.diagnostic.severity.WARN) ~= 0 then
      return "MyStatusItemDiagWarn"
    elseif get_lsp_diag_count(vim.diagnostic.severity.INFO) ~= 0 then
      return "MyStatusItemDiagInfo"
    elseif get_lsp_diag_count(vim.diagnostic.severity.HINT) ~= 0 then
      return "MyStatusItemDiagHint"
    else
      return nil
    end
end

local item_bg = get_hi_value("Keyword", "guifg")
local item_fg = get_hi_value("Normal", "guibg")
local err_fg = get_hi_value("DiagnosticError", "guifg")
local warn_fg = get_hi_value("DiagnosticWarn", "guifg")
local info_fg = get_hi_value("DiagnosticInfo", "guifg")
local hint_fg = get_hi_value("DiagnosticHint", "guifg")

C("hi! MyStatusItem guibg=" .. item_bg .. " guifg=" .. item_fg)
C('hi! MyStatusItemDiagError guibg=' .. err_fg .. ' guifg=' .. item_fg)
C('hi! MyStatusItemDiagWarn guibg=' .. warn_fg .. ' guifg=' .. item_fg)
C('hi! MyStatusItemDiagInfo guibg=' .. info_fg .. ' guifg=' .. item_fg)
C('hi! MyStatusItemDiagHint guibg=' .. hint_fg .. ' guifg=' .. item_fg)
C('hi StatusLineNC guibg=' .. item_fg .. ' cterm=NONE')
C('hi StatusLine guibg=NONE cterm=NONE')
C('hi StatusLine guibg=none')

function my_statusline(inactive)
  if inactive then
    return "%#MyStatusItem# %y %f%*"
  else
    local diagnostics = ""
    if #vim.diagnostic.get() >= 1 then
      local diag_separator_hl = get_right_separator_hl()
      if diag_separator_hl ~= nil then
        diagnostics = "%#" .. get_right_separator_hl() .. "#%*"
      end
      diagnostics = diagnostics ..
                    "%#MyStatusItemDiagError#" .. get_error() ..
                    "%#MyStatusItemDiagWarn#" .. get_warn() ..
                    "%#MyStatusItemDiagInfo#" .. get_info() ..
                    "%#MyStatusItemDiagHint#" .. get_hint()
    end
    return "%#MyStatusItem# %y %F %*" ..
           "%#MyStatusItem# %p%% %*" ..
           "%#MyStatusItem# %l/%c %*" ..
           "%#MyStatusItem#%*" ..
           "%=" ..
           diagnostics
  end
end

C('set laststatus=3')
local pattern = "*"
vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
  pattern = pattern,
  callback = function()
    vim.opt_local.statusline = my_statusline(false)
  end
})
vim.api.nvim_create_autocmd({"WinLeave", "BufLeave"}, {
  pattern = pattern,
  callback = function()
    vim.opt_local.statusline = my_statusline(true)
  end
})
