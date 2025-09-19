return {
  "klepp0/nvim-baml-syntax",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  enabled = false,
  config = function()
    -- This ensures lua/baml_syntax/init.lua is run,
    -- which registers the "baml" parser and configures Tree-sitter:
    require("baml_syntax").setup()
  end,
}
