vim.keymap.set('n', '<localleader>so', ':so %<CR>', { desc = 'Source the current file' })
vim.keymap.set('n', '<localleader>pv', ':Ex<CR>', { desc = 'Open preview' })
-- Keymap to delete buffer
vim.keymap.set('n', '<leader>bd', '<cmd>bd!<CR>', { desc = 'Delete buffer' })

vim.keymap.set('n', '<localleader>a', ":lua require'bookmarks'.add_bookmarks(false)<CR>", { desc = 'Add bookmark' })
vim.keymap.set('n', '<localleader>A', ":lua require'bookmarks'.add_bookmarks(false)<CR>", { desc = 'Add global bookmark' })
-- open terminal (insert mode) in split
vim.keymap.set('n', '<localleader>tt', '<cmd>split term://$SHELL<CR>', { desc = 'Open terminal in split', noremap = true, silent = true })
-- Map cb to clear buffers
vim.keymap.set('n', '<leader>cb', '<cmd>bufdo bd<CR>', { desc = 'Close all buffers' })
-- Run :only to close other split windows
vim.keymap.set('n', '<leader>o', '<C-w>o', { desc = 'Close other windows' })
--  Remap C-s to save
vim.keymap.set('n', '<C-s>', ':w<CR>')
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>')

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<localleader><localleader>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('i', '<C-h>', '<Esc><C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('i', '<C-l>', '<Esc><C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('i', '<C-j>', '<Esc><C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('i', '<C-k>', '<Esc><C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w><C-k>', { desc = 'Move focus to the upper window' })

-- keymap to open vim fugitive
vim.keymap.set('n', '<localleader>g', '<cmd>Git<CR>', { desc = 'Open Git window' })

-- keymap to open file list
vim.keymap.set('n', '<C-p>', '<cmd>Files<CR>', { desc = 'Open file list' })

-- leader leader will toggle buffer
vim.keymap.set('n', '<localleader><localleader>', '<C-^>', { desc = 'Toggle buffer' })

-- always center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })

-- "very magic" (less escaping needed) regexes by default
vim.keymap.set('n', '?', '?\\v')
vim.keymap.set('n', '/', '/\\v')
vim.keymap.set('c', '%s/', '%sm/')

-- let the left and right arrows be useful: they can switch buffers
vim.keymap.set('n', '<left>', ':bp<cr>')
vim.keymap.set('n', '<right>', ':bn<cr>')

-- delete 1 char back in insert mode
vim.keymap.set('i', '<C-b>', '<BS>')
