-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

--require("nvim-treesitter.configs").setup({
--  ensure_installed = "all",
--  highlight = {
--    enable = true,
--  },
--})

-- vim.cmd.colorscheme("darcula")
-- vim.cmd.colorscheme("dracula")
-- vim.o.termguicolors = true
vim.cmd.colorscheme("darcula-dark")
-- vim.cmd.colorscheme("base16-tender")

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimport()
  end,
  group = format_sync_grp,
})
-- vim.defer_fn(function()
--   vim.api.nvim_set_hl(0, "TSVariable", { link = "Normal" })
-- end, 10000)

vim.api.nvim_set_keymap("v", "p", '"0p', { noremap = true })
vim.api.nvim_set_keymap("n", "<space>ge", "<cmd>Lspsaga diagnostic_jump_next<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<space>db", "<cmd>DBUI<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "gf", "<cmd>GoFillStruct<CR>", { noremap = true })
vim.api.nvim_set_hl(0, "@comment", { fg = "green" })

-- vim.o.tabstop = 4
vim.api.nvim_exec([[
  autocmd FileType php setlocal tabstop=4 shiftwidth=4 expandtab
]], false)
