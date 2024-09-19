return {
  'easymotion/vim-easymotion',
  enabled = false,
  config = function()
    -- I want the default 'f' functionality
    -- vim.keymap.set('n', 'f', '<Plug>(easymotion-overwin-f)', { desc = '[S]earch [O]ne [L]etter' })
    vim.keymap.set('n', 's', '<Plug>(easymotion-s2)', { desc = '[S]earch [T]wo [C]har' })
    -- vim.keymap.set('n', 't', '<Plug>(easymotion-t2)', { desc = '[S]earch [T]wo [C]har' })
    vim.keymap.set('n', '/', '<Plug>(easymotion-sn)', { desc = '[S]earch [N] [C]har' })
    vim.keymap.set('n', '<localleader>l', '<Plug>(easymotion-overwin-line)', { desc = '[M]ove to [L]ine' })
    vim.keymap.set('n', '<localleader>w', '<Plug>(easymotion-overwin-w)', { desc = '[M]ove to [W]ord' })
    vim.keymap.set('n', 'n', '<Plug>(easymotion-next)', { desc = '[M]ove to [N]ext' })
    vim.keymap.set('n', 'N', '<Plug>(easymotion-prev)', { desc = '[M]ove to [N]ext' })
    vim.g.EasyMotion_smartcase = 1
  end,
}
