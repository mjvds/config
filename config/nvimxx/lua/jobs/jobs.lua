local M = {}

vim.g.jobs = {
  {
    title = "sample ls",
    pwd = ".",
    cmd = "ls"
  },
  {
    title = "sample cd",
    pwd = ".",
    cmd = "cd"
  }
}
vim.g.jobs_menu_winnr = nil
vim.g.jobs_preview_winnr = nil
vim.g.jobs_checkbox_sym_on = ''
vim.g.jobs_checkbox_sym_off = ''

function M.draw_menu()
  local content = {}
  for index, job in ipairs(vim.g.jobs) do
    table.insert(content, " " .. vim.g.jobs_checkbox_sym_off .. " " .. job.title)
  end
  local bufnr = vim.api.nvim_create_buf(false, true)
  local winnr = vim.api.nvim_open_win(bufnr, false, {
    width = vim.o.columns,
    row = vim.o.lines / 2,
    col = vim.o.columns,
    height = vim.o.lines / 2,
    relative = "win",
    focusable = true,
    border = "single"
  })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, content)
  vim.api.nvim_set_current_win(winnr)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'h', '<nop>', { silent = true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'l', '<nop>', { silent = true })
  vim.fn.setpos('.', { bufnr, 1, 2, 0 })
end

return M
