return {
  { "godlygeek/tabular", "preservim/vim-markdown" },
  {
    "junegunn/vim-easy-align",
    keys = {
      {
        "gaa",
        "<Plug>(EasyAlign)",
        mode = { "n", "x" },
        desc = "easy align column",
        { noremap = true, silent = true },
      },
      {
        "gat",
        "<cmd>set nowrap<cr>:normal! vip<cr>:EasyAlign *|<cr>",
        mode = { "n", "x" },
        desc = "Align Markdown table on |",
        { noremap = true, silent = true },
      },
    },
  },
}
