-- return {
--   'navarasu/onedark.nvim',
--   config = function()
--     require('onedark').setup {
--       style = 'dark',
--     }
--     require('onedark').load()
--   end,
-- }

return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd [[ colorscheme tokyonight ]]
  end,
}
