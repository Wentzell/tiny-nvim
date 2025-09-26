local Lsp = require "utils.lsp"

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    { "<leader>cn", "<cmd>ConformInfo<cr>", desc = "Conform Info" },
  },
  opts = {
    -- Define your formatters
    -- Conform will run multiple formatters sequentially
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      json = { "dprint" },
    },
    formatters = {
      dprint = {
        condition = function()
          return Lsp.dprint_config_exist()
        end,
      },
    },

    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Set up format-on-save
    format_on_save = { lsp_format = "fallback", timeout_ms = 500 },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
