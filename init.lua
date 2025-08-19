local vim = vim
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------------------------
--------------------- OPTIONS
-----------------------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- show tabs nicer
vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'

-----------------------------------------------------------------------------
--------------------- KEYMAPS
-----------------------------------------------------------------------------
vim.keymap.set('n', '<C-s>', ':w<cr>', {})
vim.keymap.set('i', '<C-s>', '<esc>:w<cr>', {})
-- localleader localleader - toggle between buffers
vim.keymap.set('n', '<localleader><localleader>', '<c-^>')

-- always center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })
-- "very magic" (less escaping needed) regexes by default
vim.keymap.set('n', '?', '?\\v')
vim.keymap.set('n', '/', '/\\v')
vim.keymap.set('c', '%s/', '%sm/')

-- previous and next buffers
vim.keymap.set('n', '<leader>n', '<cmd>bn<cr>')
vim.keymap.set('n', '<leader>p', '<cmd>bp<cr>')

-- Allow virtual text
vim.diagnostic.config { virtual_text = true, virtual_lines = false }

-----------------------------------------------------------------------------
--------------------- AUTOCMDS
-----------------------------------------------------------------------------

-- autocmd to update Lazyvim updates when entering vim
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    require('lazy').update { show = false }
  end,
})

-- highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  command = 'silent! lua vim.highlight.on_yank({ timeout = 500 })',
})

-- jump to last edit position on opening file
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function(ev)
    if vim.fn.line '\'"' > 1 and vim.fn.line '\'"' <= vim.fn.line '$' then
      -- except for in git commit messages
      -- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
      if not vim.fn.expand('%:p'):find('.git', 1, true) then
        vim.cmd 'exe "normal! g\'\\""'
      end
    end
  end,
})

-----------------------------------------------------------------------------
--------------------- LAZYVIM PLUGINS
-----------------------------------------------------------------------------
-- Setup lazy.nvim
require('lazy').setup {
  spec = {
    -- add your plugins here
    -- MAIN COLOR SCHEME
    -- nice bar at the bottom
    {
      'ellisonleao/gruvbox.nvim',
      priority = 1000,
      config = function()
        vim.cmd [[colorscheme gruvbox]]
        vim.o.background = 'dark'
      end,
    },
    {
      'folke/tokyonight.nvim',
      -- lazy = true,
      opts = { style = 'night' },
      config = function()
        -- vim.cmd [[colorscheme tokyonight]]
      end,
    },
    {
      'itchyny/lightline.vim',
      lazy = false, -- also load at start since it's UI
      config = function()
        -- no need to also show mode in cmd line when we have bar
        vim.o.showmode = false
        vim.g.lightline = {
          active = {
            left = {
              { 'mode', 'paste' },
              { 'readonly', 'filename', 'modified' },
            },
            right = {
              { 'lineinfo' },
              { 'percent' },
              { 'fileencoding', 'filetype' },
            },
          },
          component_function = {
            filename = 'LightlineFilename',
          },
        }
        function LightlineFilenameInLua(opts)
          if vim.fn.expand '%:t' == '' then
            return '[No Name]'
          else
            return vim.fn.getreg '%'
          end
        end
        -- https://github.com/itchyny/lightline.vim/issues/657
        vim.api.nvim_exec(
          [[
				function! g:LightlineFilename()
					return v:lua.LightlineFilenameInLua()
				endfunction
				]],
          true
        )
      end,
    },
    -- quick navigation
    {
      'folke/flash.nvim',
      event = 'VeryLazy',
      opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
    },
    -- better %
    {
      'andymass/vim-matchup',
      config = function()
        vim.g.matchup_matchparen_offscreen = { method = 'popup' }
      end,
    },
    -- option to center the editor
    {
      'shortcuts/no-neck-pain.nvim',
      version = '*',
      opts = {
        mappings = {
          enabled = true,
          toggle = '<leader>t',
          toggleLeftSide = false,
          toggleRightSide = false,
          widthUp = false,
          widthDown = false,
          scratchPad = false,
        },
      },
    },
    -- auto-cd to root of git project
    -- 'airblade/vim-rooter'
    {
      'notjedi/nvim-rooter.lua',
      config = function()
        require('nvim-rooter').setup()
      end,
    },
    -- markdown
    {
      'plasticboy/vim-markdown',
      ft = { 'markdown' },
      dependencies = {
        'godlygeek/tabular',
      },
      config = function()
        -- never ever fold!
        vim.g.vim_markdown_folding_disabled = 1
        -- support front-matter in .md files
        vim.g.vim_markdown_frontmatter = 1
        -- 'o' on a list item should insert at same level
        vim.g.vim_markdown_new_list_item_indent = 0
        -- don't add bullets when wrapping:
        -- https://github.com/preservim/vim-markdown/issues/232
        vim.g.vim_markdown_auto_insert_bullets = 0
      end,
    },
    {
      'ibhagwan/fzf-lua',
      -- optional for icon support
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      -- or if using mini.icons/mini.nvim
      -- dependencies = { "echasnovski/mini.icons" },
      opts = {},
      config = function()
        vim.keymap.set('n', '<leader><leader>', ':FzfLua<CR>')
        vim.keymap.set('n', '<C-p>', ':FzfLua files<CR>')
        vim.keymap.set('n', '<C-f>', ':FzfLua grep<CR>')
        vim.keymap.set('n', '<leader>sg', ':FzfLua live_grep<CR>')
        vim.keymap.set('n', '<leader>sr', ':FzfLua resume<CR>')
      end,
    },
    {
      'neovim/nvim-lspconfig',
      config = function()
        vim.lsp.config('rust-analyzer', {})
        vim.lsp.enable 'rust-analyzer'
        vim.lsp.config('gopls', {
          cmd = { 'gopls' },
          filetypes = { 'go' },
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
          gofumpt = true,
        })
        vim.lsp.enable 'gopls'

        vim.lsp.config('clangd', {
          cmd = { 'clangd' },
          filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
          root_markers = { '.clangd', '.git' },
          capabilities = {
            offsetEncoding = { 'utf-8', 'utf-16' },
            textDocument = {
              completion = {
                editsNearCursor = true,
              },
            },
          },
        })
        vim.lsp.enable 'clangd'

        -- Global mappings.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

        -- Use LspAttach autocommand to only map the following keys
        -- after the language server attaches to the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<leader>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>f', function()
              vim.lsp.buf.format { async = true }
            end, opts)

            local client = vim.lsp.get_client_by_id(ev.data.client_id)

            -- TODO: find some way to make this only apply to the current line.
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            end

            -- None of this semantics tokens business.
            -- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
            client.server_capabilities.semanticTokensProvider = nil
          end,
        })
      end,
    },
    -- LSP-based code-completion
    {
      'saghen/blink.cmp',
      -- optional: provides snippets for the snippet source
      dependencies = { 'rafamadriz/friendly-snippets' },

      -- use a release tag to download pre-built binaries
      version = '1.*',
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
          preset = 'default',
          ['<CR>'] = { 'accept', 'fallback' },
        },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono',
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = false } },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = 'prefer_rust_with_warning' },
      },
      opts_extend = { 'sources.default' },
    },
    {
      'olimorris/codecompanion.nvim',
      opts = {
        strategies = {
          chat = {
            adapter = 'anthropic',
          },
          inline = {
            adapter = 'anthropic',
          },
        },
      },
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
      },
    },
    -- yaml
    {
      'cuducos/yaml.nvim',
      ft = { 'yaml' },
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
      },
    },
    -- Lightweight formatter
    {
      'stevearc/conform.nvim',
      opts = {},
      config = function()
        require('conform').setup {
          formatters_by_ft = {
            lua = { 'stylua' },
            -- Conform will run multiple formatters sequentially
            go = { 'goimports', 'gofmt' },
            -- You can also customize some of the format options for the filetype
            rust = { 'rustfmt', lsp_format = 'fallback' },
            -- You can use a function here to determine the formatters dynamically
            python = function(bufnr)
              if require('conform').get_formatter_info('ruff_format', bufnr).available then
                return { 'ruff_format' }
              else
                return { 'isort', 'black' }
              end
            end,
            -- Use the "*" filetype to run formatters on all filetypes.
            ['*'] = { 'codespell' },
            -- Use the "_" filetype to run formatters on filetypes that don't
            -- have other formatters configured.
            ['_'] = { 'trim_whitespace' },
          },
          -- Set this to change the default values when calling conform.format()
          -- This will also affect the default values for format_on_save/format_after_save
          default_format_opts = {
            lsp_format = 'fallback',
          },
          notify_on_error = true,
          -- Conform will notify you when no formatters are available for the buffer
          notify_no_formatters = true,
          -- Custom formatters and overrides for built-in formatters
          format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            lsp_format = 'fallback',
          },
        }
      end,
    },
    {
      'mason-org/mason-lspconfig.nvim',
      opts = {},
      dependencies = {
        { 'mason-org/mason.nvim', opts = {} },
        'neovim/nvim-lspconfig',
      },
      config = function()
        require('mason-lspconfig').setup {
          ensure_installed = {
            'bashls',
            -- 'clangd',
            'dockerls',
            'gopls',
            'jsonls',
            'pyright',
            'lua_ls',
            'ruff',
            'rust_analyzer',
            'yamlls',
          },
        }
      end,
    },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      config = function()
        require('mason-tool-installer').setup {
          'black',
          'delve',
          'isort',
          'gotests',
          'goimports',
          'gofumpt',
          'ruff',
        }
      end,
    },
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      config = true,
      -- use opts = {} for passing setup options
      -- this is equivalent to setup({}) function
    },
    -- Debug support for nvim
    {
      'mfussenegger/nvim-dap',
      recommended = true,
      desc = 'Debugging support. Requires language specific adapters to be configured. (see lang extras)',

      dependencies = {
        'rcarriga/nvim-dap-ui',
        -- virtual text for the debugger
        {
          'theHamsta/nvim-dap-virtual-text',
          opts = {},
        },
      },

  -- stylua: ignore
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },
    },
    {
      'rcarriga/nvim-dap-ui',
      dependencies = { 'nvim-neotest/nvim-nio' },
  -- stylua: ignore
  keys = {
    { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
  },
      opts = {},
      config = function(_, opts)
        local dap = require 'dap'
        local dapui = require 'dapui'
        dapui.setup(opts)
        dap.listeners.after.event_initialized['dapui_config'] = function()
          dapui.open {}
        end
        dap.listeners.before.event_terminated['dapui_config'] = function()
          dapui.close {}
        end
        dap.listeners.before.event_exited['dapui_config'] = function()
          dapui.close {}
        end
      end,
    },
    {
      'jay-babu/mason-nvim-dap.nvim',
      dependencies = 'mason.nvim',
      cmd = { 'DapInstall', 'DapUninstall' },
      opts = {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
        },
      },
      -- mason-nvim-dap is loaded when nvim-dap loads
      config = function() end,
    },
    -- Debug support for go
    {
      'leoluz/nvim-dap-go',
      opts = {},
      config = function()
        require('dap-go').setup {
          dap_configurations = {
            {
              type = 'go',
              name = 'Debug (Build Flags & Arguments)',
              request = 'launch',
              program = '${file}',
              args = require('dap-go').get_arguments,
              buildFlags = require('dap-go').get_build_flags,
            },
          },
        }
      end,
    },
    {
      'fredrikaverpil/neotest-golang',
    },
    {
      'nvim-treesitter/nvim-treesitter',
      opts = { ensure_installed = { 'go', 'gomod', 'gowork', 'gosum', 'c', 'lua', 'vim', 'vimdoc', 'rust' } },
    },

    -- file explorer setup
    {
      'stevearc/oil.nvim',
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {},
      -- Optional dependencies
      dependencies = { { 'echasnovski/mini.icons', opts = {} } },
      -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      lazy = false,
      config = function()
        require('oil').setup()
        vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      end,
    },
    -- Git integration
    {
      'kdheepak/lazygit.nvim',
      lazy = true,
      cmd = {
        'LazyGit',
        'LazyGitConfig',
        'LazyGitCurrentFile',
        'LazyGitFilter',
        'LazyGitFilterCurrentFile',
      },
      -- optional for floating window border decoration
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
      -- setting the keybinding for LazyGit with 'keys' is recommended in
      -- order to load the plugin when the command is run for the first time
      keys = {
        { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
      },
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- automatically check for plugin updates
  checker = { enabled = true },
}
