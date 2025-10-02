return {
  'nvim-neotest/neotest-python',
  {
    'linux-cultist/venv-selector.nvim',
    cmd = 'VenvSelect',
    opts = {
      options = {
        notify_user_on_venv_activation = true,
      },
    },
    --  Call config for Python files and load the cached venv automatically
    ft = 'python',
    keys = { { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv', ft = 'python' } },
  },
  --   {
  --     'mfussenegger/nvim-dap-python',
  --   -- stylua: ignore
  --   keys = {
  --     { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
  --     { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
  --   }
  -- ,
  --   },
}
