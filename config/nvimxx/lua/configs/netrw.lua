local U = require 'utils'
local g = vim.g

U.map('n', '<C-n>', ':Explore<cr>', { silent = true })

g.netrw_banner = 0
g.netrw_liststyle = 0
g.netrw_winsize = 20
g.netrw_altv = 1
g.netrw_winsize = 80
g.netrw_home='/tmp/'
g.netrw_localcopycmd = "cp"
g.netrw_localmovecmd = "mv"
g.netrw_keepdir = 0


