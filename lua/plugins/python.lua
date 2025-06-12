return {
  {
    "voldikss/vim-floaterm",
    ft = "python", -- 只在 Python 文件类型加载
    keys = {
      { "<leader>py", "<cmd>FloatermReplSendNewlineOrStart<CR>", mode = "n", desc = "Python REPL Start" },
      { "<leader>pe", "<cmd>FloatermReplSend<CR>", mode = "n", desc = "Execute Line" },
      { "<leader>pe", "<cmd>FloatermReplSendVisual<CR>", mode = "x", desc = "Execute Selection" },
      { "<leader>pq", "<cmd>FloatermReplSendExit<CR>", mode = "n", desc = "Quit REPL" },
      { "<leader>pt", "<cmd>FloatermReplSendBlock<CR>", mode = "n", desc = "Execute Block" },
      { "<leader>pc", "<cmd>FloatermReplSendClear<CR>", mode = "n", desc = "Clear REPL" },
    },
  },
  { "leoatchina/vim-floaterm-repl" },
}
