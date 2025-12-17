return {
  'guns/vim-sexp',
  'tpope/vim-sexp-mappings-for-regular-people',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
  'hrsh7th/cmp-buffer', -- Buffer completions
  'hrsh7th/cmp-path', -- Path completions
  'hrsh7th/cmp-cmdline', -- Command line completions
  'L3MON4D3/LuaSnip', -- Snippet engine
  'saadparwaiz1/cmp_luasnip',
  {
    'Olical/conjure',
    ft = { 'clojure', 'python', 'fennel', 'lua' },
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      vim.g['conjure#mapping#doc_word'] = false
      vim.g['conjure#mapping#doc_word'] = 'k'
      vim.g['conjure#extract#tree_sitter#enabled'] = true
      vim.g['conjure#client#clojure#nrepl#connection#auto_repl#enabled'] = false
      vim.g['conjure#log#hud#enabled'] = true
      vim.keymap.set('n', '<localleader>ls', '<cmd>ConjureLogSplit<CR>')
    end,
  },
  {
    'PaterJason/cmp-conjure',
    lazy = true,
    config = function()
      require('cmp').setup {
        sources = {
          { name = 'conjure' },
        },
      }
    end,
  },
}
