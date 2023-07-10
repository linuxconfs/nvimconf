return {
  {
    "tpope/vim-fugitive",
    lazy = true,
    cmd = "Git",
    config = function()
      vim.cmd.cnoreabbrev([[git Git]])
    end,
  },
  {
    "tpope/vim-rhubarb",
  },
}
