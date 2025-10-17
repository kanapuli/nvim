return {
  {
    'nvim-neotest/neotest',
    event = 'VeryLazy',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',

      'nvim-neotest/neotest-plenary',
      'nvim-neotest/neotest-vim-test',

      {
        'fredrikaverpil/neotest-golang',
        version = '*',
        dependencies = {
          {
            'leoluz/nvim-dap-go',
            opts = {},
          },
        },
      },
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      opts.adapters['neotest-golang'] = {
        runner = 'gotestsum',
        dap_go_enabled = true,
        go_test_args = {
          '-v',
          '-coverprofile=' .. vim.fn.getcwd() .. '/coverage.out',
        },
      }
    end,
    config = function(_, opts)
      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == 'number' then
            if type(config) == 'string' then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == 'table' and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter(config)
              else
                error('Adapter ' .. name .. ' does not support setup')
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require('neotest').setup(opts)
    end,
    keys = {
      {
        '<leader>ta',
        function()
          require('neotest').run.attach()
        end,
        desc = '[t]est [a]ttach',
      },
      {
        '<leader>tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = '[t]est run [f]ile',
      },
      {
        '<leader>tA',
        function()
          require('neotest').run.run(vim.uv.cwd())
        end,
        desc = '[t]est [A]ll files',
      },
      {
        '<leader>tS',
        function()
          require('neotest').run.run { suite = true }
        end,
        desc = '[t]est [S]uite',
      },
      {
        '<leader>tn',
        function()
          require('neotest').run.run()
        end,
        desc = '[t]est [n]earest',
      },
      {
        '<leader>tl',
        function()
          require('neotest').run.run_last()
        end,
        desc = '[t]est [l]ast',
      },
      {
        '<leader>ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = '[t]est [s]ummary',
      },
      {
        '<leader>to',
        function()
          require('neotest').output.open { enter = true, auto_close = true }
        end,
        desc = '[t]est [o]utput',
      },
      {
        '<leader>tO',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = '[t]est [O]utput panel',
      },
      {
        '<leader>tt',
        function()
          require('neotest').run.stop()
        end,
        desc = '[t]est [t]erminate',
      },
      {
        '<leader>td',
        function()
          require('neotest').run.run { suite = false, strategy = 'dap' }
        end,
        desc = 'Debug nearest test',
      },
      {
        '<leader>tD',
        function()
          require('neotest').run.run { vim.fn.expand '%', strategy = 'dap', suite = false }
        end,
        desc = 'Debug current file',
      },
    },
  },

  {
    'theHamsta/nvim-dap-virtual-text',
    opts = {},
    config = function()
      require('nvim-dap-virtual-text').setup {
        enabled = true,
        enabled_commands = true,
        show_stop_reason = true,
        commented = false,
        all_references = false,
        clear_on_continue = false,
        only_first_definition = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        --- A callback that determines how a variable is displayed or whether it should be omitted
        --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
        --- @param buf number
        --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
        --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
        --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
        --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
        display_callback = function(variable, buf, stackframe, node, options)
          -- by default, strip out new line characters
          if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value:gsub('%s+', ' ')
          else
            return variable.name .. ' = ' .. variable.value:gsub('%s+', ' ')
          end
        end,
        -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
        -- virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
        virt_text_pos = 'eol',

        -- experimental features:
        all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      }
    end,
  },
}
