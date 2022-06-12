local U = require 'utils'

U.map('n', '<Leader>fo', ":call fzf#run({ 'down': '30%', 'sink': 'e' })<cr>", { silent = true })
-- Open files in horizontal split
U.map('n', '<Leader>fh', ":call fzf#run({ 'down': '30%', 'sink': 'split' })<cr>", { silent = true })
-- Open files in vertical horizontal split
U.map('n', '<Leader>fv', ":call fzf#run({ 'down': '30%', 'sink':  'vsplit' })<cr>", { silent = true })
-- Open files in vertical horizontal split
U.map('n', '<Leader>ft', ":call fzf#run({ 'down': '30%', 'sink':  'tabedit' })<cr>", { silent = true })

