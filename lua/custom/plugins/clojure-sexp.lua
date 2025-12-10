return {
  'guns/vim-sexp',
  'tpope/vim-sexp-mappings-for-regular-people',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  {
    'Olical/conjure',
    ft = { 'clojure', 'python', 'fennel', 'lua' },
    dependencies = { 'PaterJason/cmp-conjure', 'hrsh7th/nvim-cmp' },
    config = function()
      vim.g['conjure#mapping#doc_word'] = false
      vim.g['conjure#mapping#doc_word'] = 'gk'
      vim.g['conjure#extract#tree_sitter#enabled'] = true
    end,
  },
  {
    'PaterJason/cmp-conjure',
    lazy = true,
    config = function()
      local cmp = require 'cmp'
      local config = cmp.get_config()
      table.insert(config.sources, { name = 'conjure' })
      return cmp.setup(config)
    end,
  },
}
