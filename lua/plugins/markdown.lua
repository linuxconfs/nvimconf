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
  {
    "zhangddjs/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
      processor = "magick_cli",
      max_height_window_percentage = 90,
      scale_factor = 1.0,
    },
  },
  {
    "3rd/diagram.nvim",
    dependencies = {
      "3rd/image.nvim",
    },
    -- lazy = true, -- 设置为延迟加载
    opts = {
      events = {
        render_buffer = {},
        clear_buffer = { "BufLeave" },
      },
      renderer_options = {
        mermaid = {
          -- theme = "dark",
          scale = 2, -- nil | 1 (default) | 2  | 3 | ...
        },
      },
    },
    keys = {
      {
        "K",
        function()
          require("diagram").show_diagram_hover()
        end,
        mode = "n",
        ft = { "markdown", "norg" }, -- Only in these filetypes
        desc = "Show diagram in new tab",
      },
    },
  },
}
