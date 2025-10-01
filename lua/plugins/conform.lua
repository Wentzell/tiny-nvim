local Lsp = require "utils.lsp"

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    { "<leader>cn", "<cmd>ConformInfo<cr>", desc = "Conform Info" },
    {
      "==",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "Format buffer (Conform)",
    },
  },
  opts = {
    -- Define your formatters
    -- Conform will run multiple formatters sequentially
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_organize_imports", "ruff_format" },
      json = { "dprint" },
      cpp = { "clang-format" },
      cmake = { "cmake_format" },
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
    -- Disable format-on-save by default
    format_on_save = false,
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
