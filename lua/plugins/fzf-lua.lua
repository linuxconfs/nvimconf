return {
  "ibhagwan/fzf-lua",
  config = function()
    local actions = require("fzf-lua.actions")
    require("fzf-lua").setup({
      git = {
        bcommits = {
          actions = {
            ["ctrl-q"] = function(...)
              actions.git_buf_vsplit(...)
              vim.cmd("windo diffthis")
            end,
          },
        },
      },
    })
  end,
}
