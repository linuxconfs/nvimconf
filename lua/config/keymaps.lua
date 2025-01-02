-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("v", "p", '"0p', { noremap = true })
map("x", "q", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { noremap = true, silent = true })
map("x", "<leader>gl", ":Gllog<CR>", { noremap = true, silent = true })
map("n", "<space>db", "<cmd>DBUI<CR>", { noremap = true, silent = true })
map("n", "gf", "<cmd>GoFillStruct<CR>", { noremap = true, silent = true })
map("n", "g<S-r>", "<cmd>GoGenReturn<CR>", { noremap = true, silent = true })
map("i", "<c-a>", "<c-o>^", { noremap = true })
map("i", "<c-e>", "<c-o>$", { noremap = true })
map("i", "<c-j>", "<c-o>o", { noremap = true })
map("n", "<leader>gb", ":Git blame<CR>", { noremap = true, silent = true })
map("n", "<leader>gl", ":Git log --graph --oneline<CR>", { noremap = true, silent = true })
map("n", "gp", "`[v`]", { noremap = true, silent = true })
map("n", "<leader>m", ":MaximizerToggle<CR>", { noremap = true, silent = true })
map("n", "<leader>ss", ":SearchSession<CR>", { noremap = true, silent = true })
map("n", "<leader>hs", 'q:i%g//lua vim.api.nvim_buf_add_highlight(0, 0, "Search", vim.fn.line(".")-1, 0, -1)<esc>0fgla')
-- Snacks.toggle.zoom():map("<c-m>"):map("<leader>wm"):map("<leader>uZ")

-- treesitter switch argument
map("i", "<tab><tab>", "<ESC>:normal ]avia<c-g><CR>", { noremap = true, silent = true })
-- map("n", "<tab><tab>", ":normal ]avia<c-g><CR>", { noremap = true, silent = true }) -- will conflict with <c-i>
map("s", "<tab><tab>", "<ESC>:normal ]avia<c-g><CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("i", "<tab><tab>", ':normal ]avia<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<tab><tab>", ':normal ]avia<CR>', { noremap = true, silent = true })

-- tmux
local keymaps = require("tmux.keymaps")
keymaps.register("n", {
  ["<C-h>"] = [[<cmd>lua require('tmux').move_left()<cr>]],
  ["<C-j>"] = [[<cmd>lua require('tmux').move_bottom()<cr>]],
  ["<C-k>"] = [[<cmd>lua require('tmux').move_top()<cr>]],
  ["<C-l>"] = [[<cmd>lua require('tmux').move_right()<cr>]],
})
