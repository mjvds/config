local bin_path = vim.fn.exepath('vscode-json-language-server')
local cmd = {
  bin_path,
  "--stdio"
}
return {
  cmd = cmd,
  init_options = { provideFormatter = true },
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true
        }
      }
    }
  },
  single_file_support = true,
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { "angular.json" },
          url = "https://raw.githubusercontent.com/angular/angular-cli/master/packages/angular/cli/lib/config/workspace-schema.json"
        },
        {
          fileMatch = { ".prettierrc.json" },
          url = "http://json.schemastore.org/prettierrc"
        },
        {
          fileMatch = { "tsconfig.json", "tsconfig.*.json" },
          url = "http://json.schemastore.org/tsconfig"
        },
        {
          fileMatch = { "package.json" },
          url = "http://json.schemastore.org/package"
        },
        {
          fileMatch = { "tslint.json" },
          url = "http://json.schemastore.org/tslint"
        },
        -- {
        --   fileMatch = { "launch.json" },
        --   url = "https://raw.githubusercontent.com/microsoft/vscode/main/.vscode/launch.json"
        -- },
        -- {
        --   fileMatch = { "tasks.json" },
        --   url = "https://raw.githubusercontent.com/microsoft/vscode/main/.vscode/tasks.json"
        -- },
        {
          fileMatch = { "manifest.json" },
          url = "https://json.schemastore.org/chrome-manifest"
        }
      }
    }
  }
}
