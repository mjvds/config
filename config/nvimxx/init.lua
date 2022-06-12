vim.cmd('set rtp+=/home/mark/.mark/config/nvim')

local function startup()
  -- plugins to load by default
  use 'tpope/vim-surround' 
  use 'tpope/vim-repeat'
  use 'tpope/vim-commentary'
  use 'tpope/vim-fugitive'
  use {
    'kyazdani42/nvim-tree.lua',
    opt = false,
    config = function()
      require'nvim-tree'.setup {}
      require 'configs.nvim-tree';
    end
  }

  use {
    'folke/tokyonight.nvim',
    setup = function()
      vim.g.tokyonight_style = "night"
    end,
    config = function()
      vim.cmd('colorscheme tokyonight')
      require 'configs.highlights'
    end,
  }

  use {
    'raimondi/delimitmate',
    setup = function() require 'configs.delimitmate' end
  }
  use {
    'junegunn/fzf',
    rtp = '~/.fzf/',
    run = './install --all',
    cond = function() return not vim.wo.diff end,
    setup = function()
      if not vim.wo.diff then
        require 'configs.fzf'
      end
    end,
  }
  use {
    'prettier/vim-prettier',
    ft = { 'javascript', 'typescript', 'css', 'scss', 'html', 'json' },
    config = function() require 'configs.prettier' end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run =  {
      ':TSUpdate',
      ':TSInstall javascript',
      ':TSInstall typescript',
      ':TSInstall html',
      ':TSInstall scss',
      ':TSInstall css',
      ':TSInstall c_sharp',
    },
    ft = { 'javascript', 'typescript', 'css', 'scss', 'cs', 'lua' },
    config = function() require 'configs.nvim-tree-sitter' end
  }

  -- lazy loaded plugins
  use {
    'othree/html5.vim',
    opt = true,
    ft = { 'html' },
  }

  use {
    'leafgarland/typescript-vim',
    opt = true,
    ft = { 'javascript', 'typescript' },
    setup = function()
      if not vim.wo.diff then
        require 'configs.typescript-vim'
      end
    end,
  }

  use {
    'pangloss/vim-javascript',
    opt = true,
    ft = { 'javascript', 'typescript' },
  }

  use {
    'mattn/emmet-vim',
    opt = true,
    ft = { 'html', 'scss', 'css' },
    setup = function()
      if not vim.wo.diff then
        require 'configs.emmet'
      end
    end,
    cond = function() return not vim.wo.diff end,
  }

  use {
    'tbastos/vim-lua',
    opt = true,
    ft = { 'lua' }
  }

  use {
    'neovim/nvim-lsp',
    opt = true,
    ft = { 'typescript', 'javascript', 'dart', 'json', 'cs', 'sh' , 'lua', 'html' },
    config = function()
      if not vim.wo.diff then
        require 'lsp.config'.configure()
      end
    end
  }

  use {
    'mfussenegger/nvim-dap',
    opt = true,
    ft = { "cs", "javascript" },
    config = function()
      if not vim.wo.diff then
        -- require('dap.ext.vscode').load_launchjs()
        require 'plugins.nvim-dap.nvim-dap'.configure()
      end
    end
  }

  use {
    'APZelos/blamer.nvim',
    opt = true,
    ft = { "typescript", "scss", "css", "javascript", "json", "lua" },
    config = function()
      vim.g.blamer_enabled = 1
    end
  }

end

require 'packer'.startup(startup)
require 'configs.main'

local lsp_group = vim.api.nvim_create_augroup("MyMainGroup", { clear = true })
-- auto compile nvim init file when modified
vim.api.nvim_create_autocmd("BufWritePost", {
  command = "PackerCompile",
  group = lsp_group,
  pattern = "init.lua"
})
-- vim.cmd('autocmd BufWritePost init.lua PackerCompile')
-- auto reload Xresource when modified
vim.api.nvim_create_autocmd("BufWritePost", {
  command = ":!xrdb %:p",
  group = lsp_group,
  pattern = ".Xresources"
})
-- vim.cmd('autocmd BufWritePost .Xresources silent! :!xrdb %:p')
