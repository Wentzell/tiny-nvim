-- NOTE: npm i -g vscode-langservers-extracted
local Lsp = require "utils.lsp"

return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
  root_markers = { ".git" },
  on_attach = Lsp.on_attach,
}
