return {
  dir = '/Users/athavankanapuli/plugins/kuri',
  dev = true,
  event = 'VeryLazy',
  enabled = false,
  config = function()
    require 'kuri'
  end,
  keys = {
    {
      '<localleader>a',
      ":lua require('kuri').Add()<CR>",
      desc = 'Add bookmark',
    },
    {
      '<C-e>',
      ":lua require('kuri').List()<CR>",
      desc = 'List bookmark',
      silent = true,
    },
  },
}
