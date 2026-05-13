local Lsp = require "utils.lsp"

local function switch_source_header(bufnr)
  bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]
  if not client then
    vim.notify("clangd is not active on the current buffer", vim.log.levels.WARN)
    return
  end
  local params = vim.lsp.util.make_text_document_params(bufnr)
  client.request("textDocument/switchSourceHeader", params, function(err, result)
    if err then
      vim.notify("Error: " .. tostring(err), vim.log.levels.ERROR)
      return
    end
    if not result then
      vim.notify("Corresponding file cannot be determined", vim.log.levels.WARN)
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

vim.api.nvim_create_user_command("ClangdSwitchSourceHeader", function()
  switch_source_header(0)
end, { desc = "Switch between source and header" })

return {
  filetypes = { "c", "cpp", "cuda" },
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
  on_attach = Lsp.on_attach,
}
