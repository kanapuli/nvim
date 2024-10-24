require 'athavan.options'
require 'config.lazy'

-- include all keymaps
require 'athavan.keymaps'
-- import autocmds
require 'athavan.autocmd'
-- import globals
require 'athavan.globals'

if vim.g.neovide then
  vim.o.guifont = 'FiraCode Nerd Font Propo:h15'
  vim.o.linespace = 0
  vim.g.neovide_scale_factor = 1.0
  -- vim.g.neovide_cursor_animation_length = 0.01

  vim.g.neovide_cursor_animate_command_line = true
end
