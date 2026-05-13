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
        require("conform").format { async = true, lsp_format = "fallback" }
      end,
      mode = { "n", "v" },
      desc = "Format buffer (Conform)",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_organize_imports", "ruff_format" },
      cpp = { "clang-format" },
      c = { "clang-format" },
      cuda = { "clang-format" },
      cmake = { "cmake_format" },
      json = { "dprint" },
      markdown = { "dprint" },
    },
    formatters = {
      dprint = {
        condition = function()
          return Lsp.dprint_config_exist()
        end,
      },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Format-on-save is intentionally disabled; use == on demand.
    format_on_save = false,
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
