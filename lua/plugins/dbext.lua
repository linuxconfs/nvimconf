return {
  'vim-scripts/dbext.vim',
  init = function()
    -- Your DBUI configuration
    vim.g.dbext_default_profile_mysql_local = 'type=MYSQL:user=root:passwd=123456:host=127.0.0.1:port=13307'
    vim.g.dbext_default_profile = 'mysql_local'
  end,
}
