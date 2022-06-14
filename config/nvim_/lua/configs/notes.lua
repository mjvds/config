local U = require 'utils'

local file_path = require 'note.note'.file_path

local opt = { silent = true }
U.map('n', '<leader>ne', ':bo 15sp ' .. file_path .. '<cr>', opt)
U.map('n', '<leader>np', ":lua require'note.note'.preview()<cr>", opt)
U.map('n', '<leader>ng', ":lua require'note.note'.generate()<cr>", opt)
U.map('n', '<leader>na', ":lua require'note.note'.add()<cr>", opt)
U.map('n', '<leader>nab', ":lua require'note.note'.add_by_day()<cr>", opt)
