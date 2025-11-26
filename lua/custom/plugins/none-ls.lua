return {
  'nvimtools/none-ls.nvim',
  enabled = true,
  dependencies = {
    {
      'mason-org/mason.nvim',
      opts = { ensure_installed = { 'gomodifytags', 'impl' } },
    },
    {
      'ThePrimeagen/refactoring.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
      },
      lazy = false,
      opts = {},
      config = function()
        require('refactoring').setup {}
      end,
    },
  },
  opts = function(_, opts)
    local nls = require 'null-ls'
    opts.sources = vim.list_extend(opts.sources or {}, {
      nls.builtins.code_actions.gomodifytags,
      nls.builtins.code_actions.impl,
      -- nls.builtins.formatting.goimports_reviser.with {
      --   -- extra_args = { '-rm-unused' },
      -- },
      nls.builtins.code_actions.gitsigns,
      nls.builtins.code_actions.refactoring,
      nls.builtins.completion.tags,
      -- nls.builtins.diagnostics.mypy,
    })
  end,
}
