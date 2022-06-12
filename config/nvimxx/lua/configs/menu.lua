local U = require 'utils'

vim.g.menu_commands = {
  {
    ['text'] = 'Run Mobile',
    ['cmd'] = 'npm run serve',
  },
  {
    ['text'] = 'Run API Server',
    ['cmd'] = 'dotnet build && dotnet bin/Debug/netcoreapp3.1/CyberMetrics.FaciliWorks.Web.API.dll',
    ['cwd'] = '../../CyberMetrics.FaciliWorks.NetCore.API'
  },
  { 
    ['text'] = 'Run IIS Server',
    ['cmd'] = 'dotnet build && dotnet bin/Debug/netcoreapp3.1/CyberMetrics.FaciliWorks.Web.IdentityServer.dll',
    ['cwd'] = '../../CyberMetrics.FaciliWorks.NetCore.IdentityServer'
  },
  {
    ['text'] = 'Run API Server(Mobile)',
    ['cmd'] = 'dotnet build && dotnet bin/Debug/netcoreapp3.1/CyberMetrics.FaciliWorks.Web.API.dll',
    ['cwd'] = '../CyberMetrics.FaciliWorks.NetCore.API'
  },
  { 
    ['text'] = 'Run IIS Server(Mobile)',
    ['cmd'] = 'dotnet build && dotnet bin/Debug/netcoreapp3.1/CyberMetrics.FaciliWorks.Web.IdentityServer.dll',
    ['cwd'] = '../CyberMetrics.FaciliWorks.NetCore.IdentityServer'
  },
  {
    ['text'] = 'Serve Site',
    ['cmd'] = 'npm run serve-site'
  },
  { 
    ['text'] = 'Serve Admin',
    ['cmd'] = 'npm run serve-admin'
  },
  {
    ['text'] = 'Serve Org Admin',
    ['cmd'] = 'npm run serve-orgadmin'
  },
  {
    ['text'] = 'Run Site',
    ['cmd'] = 'npm run serve'
  },
  {
    ['text'] = 'Open Terminal',
    ['cmd'] = 'urxvt &'
  },
  {
    ['text'] = 'Ng Serve',
    ['cmd'] = 'ng serve'
  },
}

vim.g.use_internal_term = 1

U.map('n', '<leader>fw', ':call menu#open()<cr>')

vim.cmd('autocmd VimResized * :call menu#repaint()<cr>')
