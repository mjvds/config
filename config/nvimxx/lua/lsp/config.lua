local nvim_lsp = require'lspconfig'
local api = vim.api
local var = require'lsp.var'
local U = require 'utils'
local lsp_codeaction = require 'lsp.codeaction'
local lsp_diag = require 'lsp.diagnostic'
local M = {}

local lsp_group = vim.api.nvim_create_augroup("MyLspGroup", { clear = true })
local function on_attach(client, bufnr)
  U.set_opt('o', 'pumheight', 15)
  U.set_opt('o', 'completeopt', 'menu,menuone')
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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

  local command_option = {
    bang = true
  }
  local nvim_lsp_buf = vim.lsp.buf

  vim.api.nvim_create_user_command("LspOrganizeImports", function(res)
    lsp_codeaction.organize_imports()
    print('mark')
  end, command_option)
  vim.api.nvim_create_user_command("LspShowFixes", function() lsp_codeaction.get_fixes() end, command_option)
  vim.api.nvim_create_user_command("LspDocumentSymbol", function() nvim_lsp_buf.document_symbol() end, command_option)
  vim.api.nvim_create_user_command("LspReferences", function() nvim_lsp_buf.references() end, command_option)
  vim.api.nvim_create_user_command("LspTypeDefinition", function() nvim_lsp_buf.type_definition() end, command_option)
  vim.api.nvim_create_user_command("LspImplementation", function() nvim_lsp_buf.implementation() end, command_option)
  vim.api.nvim_create_user_command("LspHover", function() nvim_lsp_buf.hover() end, command_option)
  vim.api.nvim_create_user_command("LspDefinition", function() nvim_lsp_buf.definition() end, command_option)
  vim.api.nvim_create_user_command("LspSignatureHelp", function() nvim_lsp_buf.signature_help() end, command_option)
  vim.api.nvim_create_user_command("LspQuickFixWindowHint", function() lsp_diag.show_quickfix_window(0, 4) end, command_option)
  vim.api.nvim_create_user_command("LspQuickFixWindowError", function() lsp_diag.show_quickfix_window() end, command_option)
  vim.api.nvim_create_user_command("LspPreviousDiagnostic", function() lsp_diag.goto_prev() end, command_option)
  vim.api.nvim_create_user_command("LspNextDiagnostic", function() lsp_diag.goto_next() end, command_option)
  vim.api.nvim_create_user_command("LspRename", function() nvim_lsp_buf.rename() end, command_option)

  vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
      require 'lsp.diagnostic'.show_line_diagnostics()
    end,
    group = lsp_group,
    buffer = 0
  })

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
