-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'shortcuts/no-neck-pain.nvim',
    version = '*',
    opts = {
      mappings = {
        enabled = true,
        toggle = false,
        toggleLeftSide = false,
        toggleRightSide = false,
        widthUp = false,
        widthDown = false,
        scratchPad = false,
      },
    },
    config = function()
      require('no-neck-pain').setup {
        vim.keymap.set('n', '<leader>np', '<cmd>NoNeckPain<CR>', { desc = '[N]o [N]eck [P]ain' }),
      }
    end,
  },
}
