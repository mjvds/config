require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = { "html" }
  },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
}
