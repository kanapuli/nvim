return {
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' }, -- harpoon depends on plenary.nvim
    config = function()
      require('harpoon').setup {
        -- Example settings
        global_settings = {
          save_on_toggle = true,
          save_on_change = true,
          enter_on_sendcmd = false,
          tmux_autoclose_windows = false,
          excluded_filetypes = { 'harpoon' },
          mark_branch = false,
        },
      }

      -- Keybindings for Harpoon functionality
      vim.api.nvim_set_keymap('n', '<leader>a', ':lua require("harpoon.mark").add_file()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>hm', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<C-e>', ':Telescope harpoon marks<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>1', ':lua require("harpoon.ui").nav_file(1)<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>2', ':lua require("harpoon.ui").nav_file(2)<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>3', ':lua require("harpoon.ui").nav_file(3)<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>4', ':lua require("harpoon.ui").nav_file(4)<CR>', { noremap = true, silent = true })

      -- terminal specific keymaps
      vim.api.nvim_set_keymap('n', '<leader>ht', ':lua require("harpoon.term").gotoTerminal(1)<CR>', { noremap = true, silent = true }) -- Open terminal 1
      vim.api.nvim_set_keymap('n', '<leader>hT', ':lua require("harpoon.term").sendCommand(1, "ls -la<CR>")<CR>', { noremap = true, silent = true }) -- Send command to terminal 1
    end,
  },
}
