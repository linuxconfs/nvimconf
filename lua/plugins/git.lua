return {
  {
    "tpope/vim-fugitive",
    lazy = false,
    cmd = "Git",
    config = function()
      vim.cmd.cnoreabbrev([[git Git]])
    end,
  },
  {
    "tpope/vim-rhubarb",
  },
  {
    "shumphrey/fugitive-gitlab.vim",
  },
  {
    "sindrets/diffview.nvim",
  },
}
