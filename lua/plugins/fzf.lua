-- return {
--   'junegunn/fzf.vim',
--   dependencies = {
--     'junegunn/fzf',
--   },
--   build = function()
--     vim.fn['fzf#install']()
--   end,
--   config = function()
--     -- stop putting a giant window over my editor
--     vim.g.fzf_layout = { down = '~20%' }
--     -- when using :Files, pass the file list through
--     --
--     --   https://github.com/jonhoo/proximity-sort
--     --
--     -- to prefer files closer to the current file.
--     function list_cmd()
--       local base = vim.fn.fnamemodify(vim.fn.expand '%', ':h:.:S')
--       if base == '.' then
--         -- if there is no current file,
--         -- proximity-sort can't do its thing
--         return 'fd --type file --follow'
--       else
--         return vim.fn.printf('fd --type file --follow | proximity-sort %s', vim.fn.shellescape(vim.fn.expand '%'))
--       end
--     end
--     vim.api.nvim_create_user_command('Files', function(arg)
--       vim.fn['fzf#vim#files'](arg.qargs, { source = list_cmd(), options = '--tiebreak=index' }, arg.bang)
--     end, { bang = true, nargs = '?', complete = 'dir' })
--   end,
-- }

return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    { 'junegunn/fzf', run = './install --bin' },
  },
  config = function()
    -- calling `setup` is optional for customization
    require('fzf-lua').setup { 'fzf-native' }
    local f = require 'fzf-lua'
    vim.keymap.set('n', '<c-e>', f.oldfiles, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>sg', f.live_grep, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>sb', f.buffers, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>sh', f.builtin, { noremap = true, silent = true })
  end,
}
