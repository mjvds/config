local util = require 'lspconfig.util'
local U = require 'utils'
local bin_path = 'typescript-language-server'
local npm_bin_path = vim.fn.exepath('npm')
return {
  cmd = {
    bin_path,
    "--stdio"
  },
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  trace = "verbose",
  init_options = {
    hostInfo = "neovim",
    npmLocation	= npm_bin_path,
    logVerbosity = "off",
    preferences = {
      allowIncompleteCompletions = false,
      disableSuggestions = false,
      includeCompletionsWithInsertText = false,
    },
    completions = {
      completeFunctionCalls = true
    }
  },
  filestypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  capabilities = {
    offsetEncoding = { "utf-8", "utf-16" },
    textDocument = {
      completion = {
        completionItem = {
          commitCharactersSupport = false,
          deprecatedSupport = false,
          documentationFormat = { "plaintext", "markdown" },
          preselectSupport = false,
          snippetSupport = false,
          insertReplaceSupport = true,
        },
        completionItemKind = {
          valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }
        },
        contextSupport = false,
        dynamicRegistration = false
      },
      documentHighlight = {
        dynamicRegistration = false
      },
      documentSymbol = {
        dynamicRegistration = false,
        hierarchicalDocumentSymbolSupport = true,
        symbolKind = {
          valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 }
        }
      },
      hover = {
        contentFormat = { "plaintext" },
        dynamicRegistration = false
      },
      references = {
        dynamicRegistration = false
      },
      signatureHelp = {
        dynamicRegistration = false,
        signatureInformation = {
          documentationFormat = { "plaintext" }
        }
      },
      synchronization = {
        didSave = true,
        dynamicRegistration = false,
        willSave = false,
        willSaveWaitUntil = false
      },
      publishDiagnostics = {
        relatedInformation = false
      },
      codeAction = {
        dynamicRegistration = false,
        codeActionLiteralSupport = {
          codeActionKind = {
            valueSet = {
              "quickfix",
              "refactor",
              "refactor.extract",
              "refactor.inline",
              "refactor.rewrite",
              "source",
              "source.organizeImports",
              "source.fixAll"
            }
          }
        }
      }
    }
  }
}
