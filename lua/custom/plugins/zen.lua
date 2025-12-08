return {
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      window = {
        backdrop = 0.95, -- shade the backdrop of the Zen window
        width = 0.50, -- width will be 85% of the editor width
        height = 1.0, -- height will be 90% of the editor height
        options = {
          signcolumn = 'no',
          number = true,
          relativenumber = true,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = '0',
          list = false,
        },
      },
      plugins = {
        -- disable some global vim options
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = true }, -- disables git signs
        tmux = { enabled = false }, -- disables the tmux statusline
        -- this will change the font size on kitty when in zen mode
        kitty = {
          enabled = false,
          font = '+4',
        },
        -- this will change the font size on alacritty when in zen mode
        alacritty = {
          enabled = false,
          font = '14',
        },
      },
      on_open = function(win)
        -- Custom code when Zen mode opens
      end,
      on_close = function()
        -- Custom code when Zen mode closes
      end,
    },
    keys = {
      { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen Mode' },
      {
        '<leader>Z',
        function()
          require('zen-mode').toggle {
            window = {
              width = 0.85,
              options = {},
            },
          }
        end,
        desc = 'Zen Mode (Wide)',
      },
    },
  },
}
