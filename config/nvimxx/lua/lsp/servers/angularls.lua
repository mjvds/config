local util = require 'lspconfig.util'

-- Angular requires a node_modules directory to probe for @angular/language-service and typescript
-- in order to use your projects configured versions.
-- This defaults to the vim cwd, but will get overwritten by the resolved root of the file.
local function get_probe_dir(root_dir)
  local project_root = util.find_node_modules_ancestor(root_dir)

  return project_root and (project_root .. '/node_modules') or ''
end

local default_probe_dir = get_probe_dir(vim.fn.getcwd())

local bin_name = 'ngserver'
local args = {
  '--stdio',
  '--tsProbeLocations',
  default_probe_dir,
  '--ngProbeLocations',
  default_probe_dir,
}

local cmd = { bin_name, unpack(args) }

print(vim.inspect(cmd))

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'html' },
    -- Check for angular.json or .git first since that is the root of the project.
    -- Don't check for tsconfig.json or package.json since there are multiple of these
    -- in an angular monorepo setup.
    root_dir = util.root_pattern('angular.json', '.git'),
  },
  on_new_config = function(new_config, new_root_dir)
    local new_probe_dir = get_probe_dir(new_root_dir)

    -- We need to check our probe directories because they may have changed.
    new_config.cmd = {
      'ngserver',
      '--stdio',
      '--tsProbeLocations',
      new_probe_dir,
      '--ngProbeLocations',
      new_probe_dir,
    }
  end
}
