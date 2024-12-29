return {
  {
    "glepnir/lspsaga.nvim",
    -- commit = "b7b4777",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
    },
    keys = {
      { "<space>ge", "<cmd>Lspsaga diagnostic_jump_next<CR>", { noremap = true, silent = true } },
    },
    config = function()
      require("lspsaga").setup({})
    end,
  },
}
