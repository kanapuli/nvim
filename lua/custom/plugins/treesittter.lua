return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      install_dir = vim.fn.stdpath 'data' .. '/site',
    }
    require('nvim-treesitter').install {
      'rust',
      'javascript',
      'zig',
      'go',
      'gomod',
      'gowork',
      'gotmpl',
      'gosum',
      'python',
      'markdown',
      'rego',
      'c',
      'clojure',
      'gitcommit',
      'gitignore',
      'json',
      'kotlin',
      'lua',
      'luadoc',
      'yaml',
      'toml',
      'tmux',
      'typescript',
    }
  end,
}
