local nvim_lsp = require'lspconfig'
local api = vim.api
local var = require'lsp.var'
local U = require 'utils'
local M = {}

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

  api.nvim_command [[command! LspNextDiagnostic lua require'lsp.diagnostic'.goto_next()]]
  api.nvim_command [[command! LspPreviousDiagnostic lua require'lsp.diagnostic'.goto_prev()]]
  api.nvim_command [[command! LspShowFixes lua require'lsp.codeaction'.get_fixes()]]
  api.nvim_command [[command! LspQuickFixWindowError lua require'lsp.diagnostic'.show_quickfix_window()]]
  api.nvim_command [[command! LspQuickFixWindowHint lua require'lsp.diagnostic'.show_quickfix_window(0, 4)]]
  api.nvim_command [[command! LspRename lua vim.lsp.buf.rename()]]
  api.nvim_command [[command! LspSignatureHelp lua vim.lsp.buf.signature_help()]]
  api.nvim_command [[command! LspDefinition lua vim.lsp.buf.definition()]]
  api.nvim_command [[command! LspHover lua vim.lsp.buf.hover()]]
  api.nvim_command [[command! LspImplementation lua vim.lsp.buf.implementation()]]
  api.nvim_command [[command! LspTypeDefinition lua vim.lsp.buf.type_definition()]]
  api.nvim_command [[command! LspReferences lua vim.lsp.buf.references()]]
  api.nvim_command [[command! LspDocumentSymbol lua vim.lsp.buf.document_symbol()]]
  api.nvim_command [[command! LspCompleteItemImport "lua require'lsp.completion'.resolve_completed_item()"]]
  api.nvim_command [[command! LspOrganizeImports lua require'lsp.codeaction'.organize_imports()]]
  api.nvim_command [[autocmd CursorMoved <buffer> lua require'lsp.diagnostic'.show_line_diagnostics()]]
  api.nvim_command [[autocmd! User DiagnosticsChanged lua require'lsp.diagnostic'.update_quickfix_buf()]]

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

local SERVERS = { "jsonls", "omnisharp", "tsserver" }
function M.configure()
  -- vim.lsp.set_log_level 'trace'
  for _, server in ipairs(SERVERS) do
    local config = require('lsp.servers.' .. server)
    config.on_attach = on_attach
    nvim_lsp[server].setup(config)
  end
end

return M
