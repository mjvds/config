local U = require 'utils'
local C = vim.cmd

vim.g.mapleader = ','

C('syntax on')
C('filetype plugin indent on')
C('set clipboard=unnamedplus')


-- U.set_opt('w', 't_Co', '256')
U.set_opt('o', 'background', 'dark')
U.set_opt('o', 'encoding', 'utf-8')
U.set_opt('o', 'tabstop', 2)
U.set_opt('b', 'shiftwidth', 2)
U.set_opt('b', 'softtabstop', 0)
U.set_opt('b', 'expandtab', true)
U.set_opt('o', 'smarttab', true)
U.set_opt('o', 'hlsearch', true)
-- U.set_opt('w', 'number', true)
-- U.set_opt('w', 'relativenumber', true)
U.set_opt('o', 'cursorline', true)
U.set_opt('o', 'incsearch', true)
U.set_opt('w', 'foldmethod', 'marker')
U.set_opt('w', 'foldmarker', '#region,#endregion')

-- require 'configs.netrw';
require 'configs.notes';
require 'configs.menu';
-- require 'configs.highlights';

C('set noswapfile')

U.map('n', '<Right>', ':vertical resize +5<cr>', { silent = true })
U.map('n', '<Left>', ':vertical resize -5<cr>', { silent = true })
U.map('n', '<Up>', ':5winc -<cr>', { silent = true })
U.map('n', '<Down>', ':5winc +<cr>', { silent = true })
U.map('n', '<leader>gb', ":lua require'git.blame'.blame()<cr>", { silent = true })
U.map('n', '<leaver>p', ":Prettier<cr>", { silent = true })

U.map('i', 'jj', '<Esc>')

local option = { expr = true, silent = true }
U.map('n', '<c-i>', "&diff?':wqall<cr>':':wall<cr>'", option)
U.map('n', '<c-j>', "&diff?']c':'<c-j>'", option)
U.map('n', '<c-k>', "&diff?'[c':'<c-j>'", option)

U.map('n', '<leader>l', "&relativenumber?':set norelativenumber<cr>':':set relativenumber<cr>'", option)
U.map('n', '<leader>n', "&number?':set nonumber<cr>':':set number<cr>'", option)

U.map('t', '<C-w>h', '<C-\\><C-N><C-w>h', option)
U.map('t', '<C-w>j', '<C-\\><C-n><C-j>', option)
U.map('t', '<C-w>k', '<C-\\><C-n><C-k>', option)
U.map('t', '<C-w>l', '<C-\\><C-n><C-l>', option)
