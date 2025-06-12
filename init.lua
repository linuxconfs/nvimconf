-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("mini.surround").setup()
require("mini.files").setup()
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
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.go",
--   callback = function()
--     require("go.format").goimport()
--   end,
--   group = format_sync_grp,
-- })
-- vim.defer_fn(function()
--   vim.api.nvim_set_hl(0, "TSVariable", { link = "Normal" })
-- end, 10000)

-- for line highlight related
-- leader p copy filepath to register
vim.cmd([[
  let g:vim_markdown_folding_disabled = 1
  highlight LineHighlight ctermbg=lightyellow guibg=lightyellow
  nnoremap <silent> <Leader>1 :call matchadd('LineHighlight', '\%'.line('.').'l')<CR>
  nnoremap <silent> <Leader>0 :call clearmatches()<CR>
  map <leader>p :let @*=fnamemodify(expand("%"), ":~:.") . ":" . line(".")<CR>
]])

-- vim.api.nvim_set_hl(0, "@comment", { fg = "green" })

-- some useful keymaps:
-- cina: edit next text obj, can use dot to repeat
-- cia: edit text obj (argument)
-- vafaf: expand text block

-- DBUI
-- local keymap = vim.keymap
-- keymap.set("n", "<localleader>S", ":normal vip<CR><PLUG>(DBUI_ExecuteQuery)", { buffer = true })
-- keymap.set('n', '<leader>F', ':%!sql-formatter-cli .<CR>', { buffer = true })
-- keymap.set('n', '<leader>f', ':normal vip<CR>:!sql-formatter-cli<CR>', { buffer = true })

-- vim.o.tabstop = 4
--  autocmd FileType * nmap s <Plug>(your-minisurround-mapping)

-- python vim-floaterm-repl plugin
vim.g.floaterm_repl_exit = { ["python"] = "exit()" }
vim.g.floaterm_repl_clear = { ["python"] = "import os; os.system('clear')" }

vim.api.nvim_exec(
  [[
  autocmd FileType php setlocal tabstop=2 shiftwidth=2 noexpandtab autoindent
]],
  false
)
