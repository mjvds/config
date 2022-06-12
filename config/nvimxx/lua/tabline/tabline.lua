local utils = require 'utils'
local fn = vim.fn
local cmd = vim.cmd

local sep_left_sym = ''
local sep_right_sym = ''
local sep_group_sym = ''

local fg_color = 16
local bg_color = 33

cmd('hi TabLineSel ctermbg=' .. bg_color .. ' ctermfg=' .. fg_color)
cmd('hi TabLineSelSep ctermbg=none ctermfg=' .. bg_color)

local function get_tab_label(index)
  local buflist = fn.tabpagebuflist(index)
  local winnr = fn.tabpagewinnr(index)
  local bufnr = buflist[winnr]
  local buftype = fn.getbufvar(bufnr, '&filetype')

  if buftype == 'help' then
    return ' Help '
  elseif buftype == 'quickfix' then
    return ' Quickfix '
  elseif buftype == 'netrw' then
    return ' Netrw '
  end

  local bufname = fn.bufname(bufnr)
  if bufname == "" then
    return ' [No Name] '
  elseif utils.starts_with(bufname, 'term') then
    local _, fzf bufname:match("(.+)#(.+)")
    return ' Fzf '
  end

  return ' ' .. fn.fnamemodify(bufname, ':t') .. ' '
end

local function render_tabline()
  local tabline = ""

  local tab_count = fn.tabpagenr('$')
  local current_tab = fn.tabpagenr()
  local i = 1

  while i <= tab_count do

    local tab_is_active = i == current_tab

    if tab_is_active then
      if i ~= 1 then
        tabline = tabline .. "%#TabLineSelSep#" .. sep_left_sym
      end
      tabline = tabline .. "%#TabLineSel#"
    else
      tabline = tabline .. "%#TabLine#"
    end

    tabline = tabline .. get_tab_label(i)

    if tab_is_active then
      tabline = tabline .. "%#TabLineSelSep#" .. sep_right_sym
    end

    if (i + 1) ~= current_tab and not tab_is_active then
      tabline = tabline .. sep_group_sym
    end

    i = i + 1
  end

  tabline = tabline .. '%T%#TabLineFill#%='
  return tabline
end

function _G.my_tabline()
  return render_tabline()
end
vim.o.tabline = "%!v:lua.my_tabline()"
