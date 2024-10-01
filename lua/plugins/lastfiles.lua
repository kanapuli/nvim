return {
  dir = '/Users/athavankanapuli/plugins/lastfiles',
  dev = true,
  event = 'VeryLazy',
  config = function()
    require 'lastfiles'
  end,
  keys = {
    {
      '<localleader>a',
      ":lua require('lastfiles').Add()<CR>",
      desc = 'Add bookmark',
    },
    {
      '<C-e>',
      ":lua require('lastfiles').List()<CR>",
      desc = 'List bookmark',
      silent = true,
    },
  },
}
