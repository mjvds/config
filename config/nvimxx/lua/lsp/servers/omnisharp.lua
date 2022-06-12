local pid = vim.fn.getpid()
local os = require 'os'
local user = os.getenv('USER')
local omnisharp_bin = "/home/" .. user .. "/.mark/lsp/omnisharp/run"
local cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid), "--verbose", "Debug" };
return {
  cmd = cmd;
  on_new_config = function(new_config,new_root_dir)
    print("new configuration loaded: " .. new_root_dir)
    new_config.cmd = cmd
  end,
  flags = {
    -- This will be the default in neovim 0.7+
    debounce_text_changes = 500,
  },
  capabilities = {
    offsetEncoding = { "utf-8", "utf-16" },
    textDocument = {
      completion = {
        completionItem = {
          commitCharactersSupport = false,
          deprecatedSupport = false,
          documentationFormat = { "plaintext" },
          preselectSupport = false,
          snippetSupport = false
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
      documentFormattingProvider = {
        dynamicRegistration = false,
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
              "source.organizeImports"
            }
          }
        }
      }
    },
    workspace = {
      executeCommand = {
        dynamicRegistration = false
      }
    }
  }
}
