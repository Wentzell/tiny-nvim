return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  opts = {
    linters_by_ft = {
      -- codespell: uv tool install codespell
      ["*"] = { "codespell" },
      -- ruff: uv tool install ruff
      python = { "ruff" },
    },
    linters = {},
  },
  config = function(_, opts)
    local lint = require "lint"
    lint.linters_by_ft = opts.linters_by_ft

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        -- Create a copy of the names table to avoid modifying the original.
        names = vim.list_extend({}, names)

        -- Add fallback linters.
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end

        -- Add global linters.
        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        -- Run linters.
        if #names > 0 then
          for _, name in ipairs(names) do
            if vim.fn.executable(name) == 0 then
              vim.notify("Linter " .. name .. " is not available", vim.log.levels.INFO)
              return
            else
              lint.try_lint(name)
            end
          end
        end
      end,
    })
  end,
}
