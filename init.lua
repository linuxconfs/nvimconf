-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require('mini.surround').setup()
require('mini.files').setup()
-- require('mini.animate').setup()
-- require('dbee').setup()

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
vim.api.nvim_set_keymap('x', 'q', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<leader>gl", ":Gllog<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>ge", "<cmd>Lspsaga diagnostic_jump_next<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>db", "<cmd>DBUI<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gf", "<cmd>GoFillStruct<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "g<S-r>", "<cmd>GoGenReturn<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<c-a>", "<c-o>^", { noremap = true })
vim.api.nvim_set_keymap("i", "<c-e>", "<c-o>$", { noremap = true })
vim.api.nvim_set_keymap("i", "<c-j>", "<c-o>o", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>gb", ":Git blame<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gl", ":Git log --graph --oneline<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gp", "`[v`]", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>m", ":MaximizerToggle<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_hl(0, "@comment", { fg = "green" })

-- some useful keymaps: 
-- cina: edit next text obj, can use dot to repeat
-- cia: edit text obj (argument)
-- vafaf: expand text block

-- DBUI
local keymap = vim.keymap
keymap.set('n', '<localleader>S', ':normal vip<CR><PLUG>(DBUI_ExecuteQuery)', { buffer = true })
-- keymap.set('n', '<leader>F', ':%!sql-formatter-cli .<CR>', { buffer = true })
-- keymap.set('n', '<leader>f', ':normal vip<CR>:!sql-formatter-cli<CR>', { buffer = true })

-- vim.o.tabstop = 4
--  autocmd FileType * nmap s <Plug>(your-minisurround-mapping)
vim.api.nvim_exec([[
  autocmd FileType php setlocal tabstop=4 shiftwidth=4 expandtab
]], false)
