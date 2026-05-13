-- Install: pip install cmake-language-server (or via uv)
local Lsp = require "utils.lsp"

return {
  filetypes = { "cmake" },
  cmd = { "cmake-language-server" },
  init_options = {
    buildDirectory = "build",
  },
  root_markers = { ".git" },
  on_attach = Lsp.on_attach,
}
