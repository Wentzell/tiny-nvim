return {
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>ct", group = "test" },
      },
    },
  },
  {
    "vim-test/vim-test",
    vscode = true,
    cmd = { "TestNearest", "TestFile", "TestSuite" },
    keys = {
      { "<leader>cjt", "<cmd>TestNearest<cr>", desc = "Run Test Nearest" },
      { "<leader>cjT", "<cmd>TestFile<cr>", desc = "Run Test File" },
      { "<leader>cjS", "<cmd>TestSuite<cr>", desc = "Run Test Suite" },
    },
    config = function()
      if vim.g.vscode then
        vim.g["test#strategy"] = "neovim_vscode"
      else
        vim.g["test#strategy"] = "neovim"

        -- Change to toggle term if that is enable
        local has_toggleterm, _ = pcall(require, "toggleterm")
        if has_toggleterm then
          local tt = require "toggleterm"
          local ttt = require "toggleterm.terminal"

          vim.g["test#custom_strategies"] = {
            tterm = function(cmd)
              tt.exec(cmd)
            end,

            tterm_close = function(cmd)
              local term_id = 0
              tt.exec(cmd, term_id)
              ttt.get_or_create_term(term_id):close()
            end,
          }

          vim.g["test#strategy"] = "tterm"
        end
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/nvim-nio", { "nvim-neotest/neotest-plenary" } },
    opts = {
      -- Can be a list of adapters like what neotest expects,
      -- or a list of adapter names,
      -- or a table of adapter names, mapped to adapter configs.
      -- The adapter will then be automatically loaded with the config.
      adapters = {},
      -- Example for loading neotest-go with a custom config
      -- adapters = {
      --   ["neotest-go"] = {
      --     args = { "-tags=integration" },
      --   },
      -- },
      status = { virtual_text = true },
      output = { open_on_run = true },
    },
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter = adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
    end,
    keys = {
      {
        "<leader>ctt",
        function()
          require("neotest").run.run(vim.fn.expand "%")
        end,
        desc = "Run File",
      },
      {
        "<leader>ctT",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Run All Test Files",
      },
      {
        "<leader>ctr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>ctl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>cts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>cto",
        function()
          require("neotest").output.open { enter = true, auto_close = true }
        end,
        desc = "Show Output",
      },
      {
        "<leader>ctO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        "<leader>ctS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
      },
      {
        "<leader>ctw",
        function()
          require("neotest").watch.toggle(vim.fn.expand "%")
        end,
        desc = "Toggle Watch",
      },
    },
  },
}
