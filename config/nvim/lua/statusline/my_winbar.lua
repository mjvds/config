local C = vim.cmd
local U = require 'utils'

function my_winbar(inactive)
  if inactive then
    return ""
  else
    return "%#MyStatusItem# %y %F %*" ..
           "%#MyStatusItem#%*"
  end
end

vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
  pattern = "*",
  callback = function()
    if vim.api.nvim_win_get_config(0).relative ~= "" then return end
    vim.opt_local.winbar = my_winbar(true)
  end
})
vim.api.nvim_create_autocmd({"WinLeave", "BufLeave"}, {
  pattern = "*",
  callback = function()
    if vim.api.nvim_win_get_config(0).relative ~= "" then return end
    vim.opt_local.winbar = my_winbar(false)
  end
})
