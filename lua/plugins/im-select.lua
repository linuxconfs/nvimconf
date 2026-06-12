return {
  "keaising/im-select.nvim",
  enabled = false,
  config = function()
    require("im_select").setup({
      default_im_select = "com.apple.keylayout.ABC",
      default_command = "macism",
    })
  end,
}
