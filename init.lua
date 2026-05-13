require "config.options"

-- Load project setting if available, e.g: .nvim-config.lua
-- This file is not tracked by git
-- It can be used to set project specific settings
local project_setting = vim.fn.getcwd() .. "/.nvim-config.lua"
-- Check if the file exists and load it
if vim.loop.fs_stat(project_setting) then
  -- Read the file and run it with pcall to catch any errors
  local ok, err = pcall(dofile, project_setting)
  if not ok then
    vim.notify("Error loading project setting: " .. err, vim.log.levels.ERROR)
  end
end

require "config.autocmds"
require "config.lazy"
require "config.keymaps"
require "config.project"

-- Only load the theme if not in VSCode
if vim.g.vscode then
  -- Trigger vscode keymap
  local pattern = "NvimIdeKeymaps"
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
else
  -- Load the theme
  local theme = require "config.theme"
  theme.setup()
  theme.apply()

  -- Enable LSP servers per filetype (Neovim 0.11+)
  local lsp_by_ft = {
    lua = { "lua_ls" },
    json = { "json" },
    jsonc = { "json" },
    json5 = { "json" },
    python = { "basedpyright", "ruff" },
  }

  local enabled_lsp = {}

  local function enable_lsp(servers)
    if not servers or #servers == 0 then
      return
    end
    for _, server in ipairs(servers) do
      if not enabled_lsp[server] then
        enabled_lsp[server] = true
        vim.lsp.enable(server)
      end
    end
  end

  if vim.g.lsp_on_demands then
    enable_lsp(vim.g.lsp_on_demands)
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("my_nvim_lsp_by_ft", { clear = true }),
    callback = function(event)
      enable_lsp(lsp_by_ft[vim.bo[event.buf].filetype])
    end,
  })
end
