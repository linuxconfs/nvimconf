return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- ["af"] = "@function.outer",
            -- ["aF"] = "@function.outercustome",
          },
        },
      },
    },
  },
}
