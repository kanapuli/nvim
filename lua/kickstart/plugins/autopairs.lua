-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {},
  config = function()
    require('nvim-autopairs').setup {
      enable_check_bracket_line = false,
    }
  end,
}
