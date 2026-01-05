return {
  {
    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          ["c"] = { "clang_format" },
          ["cpp"] = { "clang_format" },
          ["c++"] = { "clang_format" },
          ["cmake"] = { "gersemi" },
          ["zsh"] = { "shfmt" },
          ["sh"] = { "shfmt" },
          ["bash"] = { "shfmt" },
        },
      },
    },
  },
}
