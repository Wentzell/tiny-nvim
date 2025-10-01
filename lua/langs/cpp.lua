return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c", "cpp", "cmake", "ninja", "make" } },
  },
  {
    "bfrg/vim-c-cpp-modern",
    ft = { "c", "cpp" },
    -- init = function()
    --   vim.g.cpp_function_highlight = 0
    --   vim.g.cpp_attributes_highlight = 1
    --   vim.g.cpp_member_highlight = 1
    --   vim.g.cpp_type_name_highlight = 0
    --   vim.g.cpp_operator_highlight = 1
    --   vim.g.cpp_simple_highlight = 1
    -- end,
  },
}
