local M = {}

function M.blame()
  local file_full_path = vim.fn.expand('%:p')
  local linenr = vim.fn.line('.')
  local blame = vim.fn.system('git blame -L' .. linenr .. ',+1 ' .. file_full_path .. " -e | awk -F '[()]' '{print $2}' | awk '{print $1\" \" $2\" \" $3\" \" \"ago\"}' | tr '\n' ' '")
  vim.lsp.util.open_floating_preview({"Change made by " .. blame}, nil, { })
end

return M
