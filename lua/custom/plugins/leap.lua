return {
  'ggandor/leap.nvim',
  dependencies = {
    'tpope/vim-repeat',
  },
  config = function()
    require('leap.user').set_repeat_keys('<enter>', '<backspace>')
    vim.keymap.set('n', 's', '<Plug>(leap)')
  end,
}
