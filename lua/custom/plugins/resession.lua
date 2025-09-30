return {
  'stevearc/resession.nvim',
  opts = {},
  config = function()
    local resession = require 'resession'
    resession.setup {}
    vim.keymap.set('n', '<leader>rs', resession.save, { desc = '[S]ave Vim Session' })
    vim.keymap.set('n', '<leader>rl', resession.load, { desc = '[L]oad Last Vim Session' })
    vim.keymap.set('n', '<leader>rd', resession.delete, { desc = '[Delete] Vim Session' })

    local function get_session_name()
      local name = vim.fn.getcwd()
      local branch = vim.trim(vim.fn.system 'git branch --show-current')
      if vim.v.shell_error == 0 then
        return name .. branch
      else
        return name
      end
    end

    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
          resession.load(get_session_name(), { dir = 'dirsession', silence_errors = true })
        end
      end,
    })

    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        resession.save(get_session_name(), { dir = 'dirsession', notify = false })
      end,
    })

    vim.api.nvim_create_autocmd('StdinReadPre', {
      callback = function()
        -- Store this for later
        vim.g.using_stdin = true
      end,
    })
  end,
}
