return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "ninja", "rst", "go", "baml" },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outercustome",
            ["aF"] = "@function.outer",
          },
        },
      },
    },
  },
}
