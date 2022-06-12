local cmd = vim.cmd
local U = require 'utils'
local M = {}

function M.init_settings(bufnr)
  U.map('i', '<c-i>', "pumvisible() == 1 ? '<cmd>:LspCompleteItemImport<cr><c-y>' : '<tab>'", {
    expr = true,
    silent = true
  })

  U.map('n', '<c-j>', ':LspNextDiagnostic<cr>', { silent = true })
  U.map('n', '<c-k>', ':LspPreviousDiagnostic<cr>', { silent = true })
  U.map('i', '<c-k>', '<cmd>:LspSignatureHelp<cr>', { silent = true })
  U.map('n', '<c-h>', ':LspImport<cr>', { silent = true })
  U.map('n', '<leader>rn', ':LspRename<cr>', { silent = true })
  U.map('n', 'gd', ':LspDefinition<cr>', { silent = true })
  U.map('n', 'K', ':LspHover<cr>', { silent = true })
  U.map('n', 'gi', ':LspImplementation<cr>', { silent = true })
  U.map('n', 'gr', ':LspReferences<cr>', { silent = true })
  U.map('n', 'gs', ':LspDocumentSymbol<cr>', { silent = true })
  U.map('n', '<leader>qe', ':LspQuickFixWindowError<cr>', { silent = true })
  U.map('n', '<leader>qh', ':LspQuickFixWindowHint<cr>', { silent = true })
  U.map('n', '<leader>s', ':LspShowFixes<cr>', { silent = true })
  U.map('n', '<leader>o', ':LspOrganizeImports<cr>', { silent = true })

  U.set_opt('o', 'pumheight', 15)
  U.set_opt('o', 'completeopt', 'menu,menuone')
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

return M
