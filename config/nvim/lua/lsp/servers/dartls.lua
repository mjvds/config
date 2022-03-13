local os = require 'os'
local user = os.getenv('USER')
local dartls_cmd = {
  "dart",
  "/home/" .. user .. "/.flutter/bin/cache/dart-sdk/bin/snapshots/analysis_server.dart.snapshot",
  "--lsp"
}
return {
  cmd = dartls_cmd
}
