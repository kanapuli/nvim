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
vim.opt.wrap = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- show tabs nicer
vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'

-----------------------------------------------------------------------------
--------------------- KEYMAPS
-----------------------------------------------------------------------------
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', {})
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
    {
      'wincent/base16-nvim',
      lazy = false, -- load at start
      priority = 1000, -- load first
      config = function()
        vim.cmd [[colorscheme gruvbox-dark-hard]]
        vim.o.background = 'dark'
        vim.cmd [[hi Normal ctermbg=NONE]]
        -- Less visible window separator
        vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 1250067 })
        -- Make comments more prominent -- they are important.
        local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
        vim.api.nvim_set_hl(0, 'Comment', bools)
        -- Make it clearly visible which argument we're at.
        local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
        vim.api.nvim_set_hl(
          0,
          'LspSignatureActiveParameter',
          { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true }
        )
        -- XXX
        -- Would be nice to customize the highlighting of warnings and the like to make
        -- them less glaring. But alas
        -- https://github.com/nvim-lua/lsp_extensions.nvim/issues/21
        -- call Base16hi("CocHintSign", g:base16_gui03, "", g:base16_cterm03, "", "", "")
      end,
    },
    -- nice bar at the bottom
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
      'ggandor/leap.nvim',
      config = function()
        require('leap').create_default_mappings()
      end,
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
      'hrsh7th/nvim-cmp',
      -- load cmp on InsertEnter
      event = 'InsertEnter',
      -- these dependencies will only be loaded when cmp loads
      -- dependencies are always lazy-loaded unless specified otherwise
      dependencies = {
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
      },
      config = function()
        local cmp = require 'cmp'
        cmp.setup {
          snippet = {
            -- REQUIRED by nvim-cmp. get rid of it once we can
            expand = function(args)
              vim.snippet.expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert {
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            -- Accept currently selected item.
            -- Set `select` to `false` to only confirm explicitly selected items.
            ['<CR>'] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },
          },
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
          }, {
            { name = 'path' },
          }),
          experimental = {
            ghost_text = true,
          },
        }

        -- Enable completing paths in :
        cmp.setup.cmdline(':', {
          sources = cmp.config.sources {
            { name = 'path' },
          },
        })
      end,
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
            'black',
            'clangd',
            'delve',
            'dockerls',
            'gopls',
            'gotests',
            'isort',
            'goimports',
            'gofumpt',
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
      opts = { ensure_installed = { 'go', 'gomod', 'gowork', 'gosum' } },
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- automatically check for plugin updates
  checker = { enabled = true },
}
