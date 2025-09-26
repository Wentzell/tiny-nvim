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
    require("kanagawa").load "wave"

    -- Enable LSP servers for Neovim 0.11+
    vim.lsp.enable {
        "lua_ls",      -- Lua
        "json",        -- JSON
        "pyright",     -- Python
    }

    -- Load Lsp on-demand
    if vim.g.lsp_on_demands then
        vim.lsp.enable(vim.g.lsp_on_demands)
    end
end
