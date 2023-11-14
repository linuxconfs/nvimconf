return {
  { "rcarriga/nvim-notify", enabled = false },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = function(_, opts)
      opts.autoformat = false
    end,
  },
}
