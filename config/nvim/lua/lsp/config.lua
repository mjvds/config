local nvim_lsp = require'lspconfig'
local api = vim.api
local var = require'lsp.var'
local U = require 'utils'
local M = {}

local myGroupId = vim.api.nvim_create_augroup("MyGroup", {
  clear = false
})

local function on_attach(client, bufnr)
  U.set_opt('o', 'pumheight', 15)
  U.set_opt('o', 'completeopt', 'menu,menuone')
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', [[v:lua.require'lsp.omnifunc'.omnifunc]])

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = false,
    underline = true,
    update_in_insert = false,
    virtual_text = false
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single"
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single"
  })

  local opt = {}
  api.nvim_buf_create_user_command(bufnr, 'LspNextDiagnostic', function() require'lsp.diagnostic'.goto_next() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspPreviousDiagnostic', function() require'lsp.diagnostic'.goto_prev() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspShowFixes', function() require'lsp.codeaction'.get_fixes() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspQuickFixWindowError', function() require'lsp.diagnostic'.show_quickfix_window() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspQuickFixWindowHint', function() require'lsp.diagnostic'.show_quickfix_window(0, 4) end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspRename', function() vim.lsp.buf.rename() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspSignatureHelp', function() vim.lsp.buf.signature_help() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspDefinition', function() vim.lsp.buf.definition() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspHover', function() vim.lsp.buf.hover() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspImplementation', function() vim.lsp.buf.implementation() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspTypeDefinition', function() vim.lsp.buf.type_definition() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspReferences', function() vim.lsp.buf.references() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspDocumentSymbol', function() vim.lsp.buf.document_symbol() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspCompleteItemImport', function() require'lsp.completion'.resolve_completed_item() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspOrganizeImports', function() require'lsp.codeaction'.organize_imports() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspOrganizeImports', function() require'lsp.codeaction'.organize_imports() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspOrganizeImports', function() require'lsp.codeaction'.organize_imports() end, opt)
  api.nvim_buf_create_user_command(bufnr, 'LspOrganizeImports', function() require'lsp.codeaction'.organize_imports() end, opt)
  api.nvim_create_autocmd('CursorMoved', {
    pattern = "*",
    group = myGroupId,
    callback = function()
      require'lsp.diagnostic'.show_line_diagnostics()
    end,
  })
  -- api.nvim_create_autocmd('User', {
  --   pattern = "DiagnosticsChanged",
  --   group = myGroupId,
  --   callback = function()
  --     require'lsp.diagnostic'.update_quickfix_buf()
  --   end,
  -- })

  api.nvim_set_var(var.qf_buf_target, 0)
  api.nvim_set_var(var.qf_severity, 0)

  U.map('i', '<c-i>', "pumvisible() == 1 ? '<cmd>:LspCompleteItemImport<cr><c-y>' : '<tab>'", {
    expr = true,
    silent = true
  })

  local opts = { silent = true }
  U.map('n', '<c-j>', ':LspNextDiagnostic<cr>', opts)
  U.map('n', '<c-k>', ':LspPreviousDiagnostic<cr>', opts)
  U.map('i', '<c-k>', '<cmd>:LspSignatureHelp<cr>', opts)
  U.map('n', '<c-h>', ':LspImport<cr>', opts)
  U.map('n', '<leader>rn', ':LspRename<cr>', opts)
  U.map('n', 'gd', ':LspDefinition<cr>', opts)
  U.map('n', 'K', ':LspHover<cr>', opts)
  U.map('n', 'gi', ':LspImplementation<cr>', opts)
  U.map('n', 'gr', ':LspReferences<cr>', opts)
  U.map('n', 'gs', ':LspDocumentSymbol<cr>', opts)
  U.map('n', '<leader>qe', ':LspQuickFixWindowError<cr>', opts)
  U.map('n', '<leader>qh', ':LspQuickFixWindowHint<cr>', opts)
  U.map('n', '<leader>s', ':LspShowFixes<cr>', opts)
  U.map('n', '<leader>o', ':LspOrganizeImports<cr>', opts)

end

local SERVERS = { "jsonls", "omnisharp", "tsserver" } -- , "angularls" }
function M.configure()
  -- vim.lsp.set_log_level 'trace'
  for _, server in ipairs(SERVERS) do
    local config = require('lsp.servers.' .. server)
    local filetypes = vim.fn.get(config, 'filetypes', config.filestypes)
    config.on_attach = on_attach
    nvim_lsp[server].setup(config)
  end
end

return M
