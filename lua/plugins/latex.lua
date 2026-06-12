-- \ll 编译，\lv 打开 PDF，\lk 停止
-- \lc 清理辅助文件
-- 正向/反向跳转（SyncTeX）
-- 智能的 % 跳转（在 \begin/\end 间）
-- dse / cse 删除/修改环境，dsc 删除命令
-- LSP：texlab :MasonInstall texlab

return {
  {
    "lervag/vimtex",
    -- ft = "tex", -- NOTE: cancel comment if no lazy load needed to improve perf
    init = function()
      vim.g.vimtex_view_method = "skim" -- 或 "skim" (macOS, 需要安装, ctrl+click跳转)
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_progname = "nvr"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = ".aux",
        out_dir = ".out",
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              build = {
                executable = "latexmk",
                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                onSave = true,
              },
              forwardSearch = {
                executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
                args = { "-b", "-g", "%l", "%p", "%f" },
              },
            },
          },
        },
      },
    },
  },
}
