return {
  'tingey21/telescope-colorscheme-persist.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  lazy = false,
  config = function()
    require('telescope-colorscheme-persist').setup {}
  end,
}
