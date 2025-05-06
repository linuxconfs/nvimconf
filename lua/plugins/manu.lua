return {
  "bassamsdata/namu.nvim",
  config = function()
    require("namu").setup({
      -- Enable the modules you want
      namu_symbols = {
        enable = true,
        options = {}, -- here you can configure namu
      },
      -- Optional: Enable other modules if needed
      ui_select = { enable = false }, -- vim.ui.select() wrapper
    })
    -- === Suggested Keymaps: ===
    vim.keymap.set("n", "<leader>sf", ":Namu watchtower<cr>", {
      desc = "Jump to LSP symbol",
      silent = true,
    })
    vim.keymap.set("n", "<leader>sw", ":Namu workspace<cr>", {
      desc = "LSP Symbols - Workspace",
      silent = true,
    })
    vim.keymap.set("n", "<leader>ci", ":Namu call in<cr>", {
      desc = "Call by functions",
      silent = true,
    })
    vim.keymap.set("n", "<leader>co", ":Namu call out<cr>", {
      desc = "Function calls",
      silent = true,
    })
  end,
}
