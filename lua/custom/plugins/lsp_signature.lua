return {
  'ray-x/lsp_signature.nvim',
  event = 'VeryLazy',
  opts = {},
  config = function(_, _)
    require('lsp_signature').setup {
      doc_lines = 0,
      handler_opts = {
        border = none,
      },
    }
  end,
}
