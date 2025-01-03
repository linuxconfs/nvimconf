return {
  "kristijanhusak/vim-dadbod-ui",
  lazy = true,
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_execute_on_save = 0
    vim.g.db_ui_disable_mappings_sql = true
    vim.g.db_ui_save_location = "~/Documents/projects/mylocalscripts/querys"
  end,
}
