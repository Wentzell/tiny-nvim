return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "c", "cpp", "cmake", "ninja", "make" } },
  },
  {
    "bfrg/vim-c-cpp-modern",
    ft = { "c", "cpp" },
  },
}
