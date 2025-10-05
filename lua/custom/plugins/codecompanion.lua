return {
  'olimorris/codecompanion.nvim',
  opts = {},
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  enabled = false,
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = {
          adapter = 'gemini_cli',
        },
        inline = {
          adapter = 'gemini_cli',
        },
        cmd = {
          adapter = 'gemini_cli',
        },
      },
      adapters = {
        acp = {
          gemini_cli = function()
            return require('codecompanion.adapters').extend('gemini_cli', {
              commands = {
                default = {
                  '/opt/homebrew/bin/gemini',
                  '--experimental-acp',
                },
              },
            })
          end,
        },
      },
    }
  end,
}
