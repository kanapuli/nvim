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
      adapters = {
        mistralnemo = function()
          return require('codecompanion.adapters').extend('ollama', {
            name = 'mistralnemo', -- Ensure this adapter is differentiated from Ollama
            schema = {
              model = {
                default = 'mistral-nemo:latest',
              },
              num_ctx = {
                default = 16384,
              },
              num_predict = {
                default = -1,
              },
            },
          })
        end,
        llama3 = function()
          return require('codecompanion.adapters').extend('ollama', {
            name = 'llama3.1', -- Ensure this adapter is differentiated from Ollama
            schema = {
              model = {
                default = 'llama3.1:latest',
              },
              num_ctx = {
                default = 16384,
              },
              num_predict = {
                default = -1,
              },
            },
          })
        end,
      },

      vim.keymap.set('n', '<C-b>', '<cmd>CodeCompanionActions<CR>', { noremap = true, silent = true }),
      vim.keymap.set('v', '<C-b>', '<cmd>CodeCompanionActions<CR>', { noremap = true, silent = true }),
      vim.keymap.set('n', '<localleader>g', '<cmd>CodeCompanionToggle<CR>', { noremap = true, silent = true }),
      vim.keymap.set('v', '<localleader>g', '<cmd>CodeCompanionToggle<CR>', { noremap = true, silent = true }),
    }
  end,
}
