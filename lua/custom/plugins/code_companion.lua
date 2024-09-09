return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
    'nvim-telescope/telescope.nvim', -- Optional: For working with files with slash commands
    {
      'stevearc/dressing.nvim', -- Optional: Improves the default Neovim UI
      opts = {},
    },
  },
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
        agent = {
          adapter = 'copilot',
        },
      },

      vim.keymap.set('n', '<C-b>', '<cmd>CodeCompanionActions<CR>', { noremap = true, silent = true }),
      vim.keymap.set('v', '<C-b>', '<cmd>CodeCompanionActions<CR>', { noremap = true, silent = true }),
      vim.keymap.set('n', '<localleader>g', '<cmd>CodeCompanionToggle<CR>', { noremap = true, silent = true }),
      vim.keymap.set('v', '<localleader>g', '<cmd>CodeCompanionToggle<CR>', { noremap = true, silent = true }),
    }
  end,
}
