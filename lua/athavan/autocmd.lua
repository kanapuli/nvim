-- always enter terminal with insert mode
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  desc = 'Always enter terminal with insert mode',
  callback = function()
    if vim.bo.buftype == 'terminal' then
      vim.cmd 'startinsert'
    end
  end,
})

local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})

vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = 'CodeCompanionInline*',
  group = group,
  callback = function(request)
    if request.match == 'CodeCompanionInlineFinished' then
      -- Format the buffer after the inline request has completed
      require('conform').format { bufnr = request.buf }
    end
  end,
})
-- autocmd to attach LSP signature
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil and vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
      return
    end
    require('lsp_signature').on_attach({
      -- ... setup options here ...
      bind = true,
      handler_opts = {
        border = 'rounded',
      },
    }, bufnr)
  end,
})

-- vim.api.nvim_create_autocmd('BufWritePre', {
--   pattern = '*.go',
--   desc = 'run go imports',
--   callback = function()
--     local params = vim.lsp.util.make_range_params()
--     params.context = { only = { 'source.organizeImports' } }
--     -- buf_request_sync defaults to a 1000ms timeout. Depending on your
--     -- machine and codebase, you may want longer. Add an additional
--     -- argument after params if you find that you have to write the file
--     -- twice for changes to be saved.
--     -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
--     local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
--     for cid, res in pairs(result or {}) do
--       for _, r in pairs(res.result or {}) do
--         if r.edit then
--           local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
--           vim.lsp.util.apply_workspace_edit(r.edit, enc)
--         end
--       end
--     end
--     vim.lsp.buf.format { async = false }
--   end,
-- })

-- Open files at the last position when reopened
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    local last_pos = vim.fn.line '\'"'
    if last_pos > 1 and last_pos <= vim.fn.line '$' then
      vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
    end
  end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
