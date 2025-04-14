-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local opts = { noremap = true, unique = true, silent = true }

map("v", "p", '"0p', opts)
map("x", "q", [[:<C-u>lua MiniSurround.add('visual')<CR>]], opts)
map("x", "<leader>gl", ":Gllog<CR>", { noremap = true, silent = true })
map("n", "<space>db", "<cmd>DBUI<CR>", opts)
map("n", "gf", "<cmd>GoFillStruct<CR>", opts)
map("n", "g<S-r>", "<cmd>GoRun<CR>", opts)
map("n", "gt", "<cmd>GoTestFunc -v<CR>", opts)
map("n", "gi", "<cmd>GoImports<CR>", opts)
map("n", "g<S-s>", "<cmd>GoStop<CR>", opts)
map("i", "<c-a>", "<c-o>^", opts)
map("i", "<c-e>", "<c-o>$", opts)
map("i", "<c-j>", "<c-o>o", opts)
-- map("n", "<leader>gb", ":Git blame<CR>", opts)
-- map("n", "<leader>gl", ":Git log --graph --oneline<CR>", { noremap = true, silent = true })
map("x", "<Leader>fc", "<cmd>FzfLua git_bcommits<CR>", opts)
map("n", "gp", "`[v`]", opts)
map("n", "<leader>m", ":MaximizerToggle<CR>", opts)
map("n", "<leader>ss", ":SessionSearch<CR>", { noremap = true, silent = true })
map("n", "<leader>hs", 'q:i%g//lua vim.api.nvim_buf_add_highlight(0, 0, "Search", vim.fn.line(".")-1, 0, -1)<esc>0fgla')

-- DBUI settings
map("n", "<leader>X", ":normal vip<CR><PLUG>(DBUI_ExecuteQuery)")
map("n", "<leader>W", "<PLUG>(DBUI_SaveQuery)")
-- Snacks.toggle.zoom():map("<c-x>"):map("<leader>wm"):map("<leader>uZ")
require("config.accordion").maximize():map("<leader>wm")

-- treesitter switch argument
map("i", "<c-l>", "<ESC>:normal ]avia<c-g><CR>", opts)
-- map("n", "<tab><tab>", ":normal ]avia<c-g><CR>", { noremap = true, silent = true }) -- will conflict with <c-i>
map("s", "<c-l>", "<ESC>:normal ]avia<c-g><CR>", opts)
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
