-- local mason_packages = vim.fn.stdpath('data') .. '/mason/packages'

return {
  -- DAP
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'cmp-dap',
      -- 'jbyuki/one-small-step-for-vimkind',
      'mason.nvim',
      'jayp0521/mason-nvim-dap.nvim',
      {
        'nvim-telescope/telescope-dap.nvim',
        dependencies = {
          'nvim-treesitter', -- optional
          'telescope.nvim',
        },
        config = function()
          require('telescope').load_extension('dap')
        end,
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        dependencies = {
          'nvim-treesitter',
        },
        opts = { show_stop_reason = false },
      },
      'lua-json5',
      -- 'nvim-dap-vscode-js',
    },
    keys = {
      { '<Leader>B', '<cmd>BreakpointToggle<CR>', desc = 'Debug toggle Breakpoint' },
      { '<Leader>C', '<cmd>Debug<CR>', desc = 'Debug Continue' },
      { '<Leader>R', '<cmd>DapREPL<CR>', desc = 'Debug open REPL' },
      -- nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
      -- nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
      -- nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
      -- nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
      -- nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
      -- nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
      -- nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
      -- nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
      -- nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>
    },
    init = function()
      local map = vim.api.nvim_set_keymap
      local create_cmd = vim.api.nvim_create_user_command

      create_cmd('BreakpointToggle', function()
        require('dap').toggle_breakpoint()
      end, {})
      create_cmd('Debug', function()
        require('dap').continue()
      end, {})
      create_cmd('DapREPL', function()
        require('dap').repl.open()
      end, {})

      map('n', '<F5>', '', {
        callback = function()
          require('dap').continue()
        end,
        noremap = true,
      })
      map('n', '<F10>', '', {
        callback = function()
          require('dap').step_over()
        end,
        noremap = true,
      })
      map('n', '<F11>', '', {
        callback = function()
          require('dap').step_into()
        end,
        noremap = true,
      })
      map('n', '<F12>', '', {
        callback = function()
          require('dap').step_out()
        end,
        noremap = true,
      })

      local group = vim.api.nvim_create_augroup('VSCode', { clear = true })
      vim.api.nvim_create_autocmd('BufRead', {
        group = group,
        pattern = '.vscode/*.json',
        callback = function()
          vim.cmd('set filetype=jsonc')
        end,
      })
    end,
    config = function()
      local dap = require('dap')
      local adapters = LoadDir('plugins/dap/adapters')
      local setup_handlers = {
        function(source_name)
          -- Keep original functionality of `automatic_setup = true`
          require('mason-nvim-dap.automatic_setup')(source_name)
        end,
        -- python = function(source_name)
        --   dap.adapters.python = {
        --     type = 'executable',
        --     command = '/usr/bin/python3',
        --     args = {
        --       '-m',
        --       'debugpy.adapter',
        --     },
        --   }

        --   dap.configurations.python = {
        --     {
        --       type = 'python',
        --       request = 'launch',
        --       name = 'Launch file',
        --       program = '${file}', -- This configuration will launch the current file if used.
        --     },
        --   }
        -- end,
      }

      for name, adapter in pairs(adapters) do
        if adapter.setup then
          setup_handlers[name] = adapter.setup
        end
      end

      dap.set_log_level('TRACE')

      local signs = {
        DapBreakpoint = 'B',
        DapBreakpointCondition = 'C',
        DapLogPoint = 'L',
        DapStopped = '→',
        DapBreakpointRejected = 'R',
      }
      for name, icon in pairs(signs) do
        vim.fn.sign_define(name, { text = icon, texthl = '', linehl = '', numhl = '' })
      end

      -- https://github.com/mfussenegger/nvim-dap/wiki/Cookbook
      local keymap_restore = {}
      dap.listeners.after['event_initialized']['me'] = function()
        for _, buf in pairs(vim.api.nvim_list_bufs()) do
          local keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')
          for _, keymap in pairs(keymaps) do
            if keymap.lhs == 'K' then
              table.insert(keymap_restore, keymap)
              vim.api.nvim_buf_del_keymap(buf, 'n', 'K')
            end
          end
        end
        vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
      end

      dap.listeners.after['event_terminated']['me'] = function()
        for _, keymap in pairs(keymap_restore) do
          vim.api.nvim_buf_set_keymap(
            keymap.buffer,
            keymap.mode,
            keymap.lhs,
            keymap.rhs or '',
            { callback = keymap.callback, silent = keymap.silent == 1 }
          )
        end
        keymap_restore = {}
      end

      -- vim.pretty_print('configurations', vim.tbl_keys(dap.configurations))
      -- vim.pretty_print('adapters', vim.tbl_keys(adapters))

      local dap_mason = require('mason-nvim-dap')
      dap_mason.setup({
        ensure_installed = vim.tbl_keys(adapters),
        automatic_setup = {
          -- adapters = { ADAPTER = {} },
          -- configurations = { ADAPTER = {} },
        },
      })
      dap_mason.setup_handlers(setup_handlers)
    end,
  },
  {
    'Joakker/lua-json5',
    build = './install.sh', -- osx: rustup update, cp ./lua/json5.{dylib,so}
    -- event = 'VeryLazy',
    -- https://github.com/Joakker/lua-json5/issues/1#issuecomment-913065942
    config = function()
      local dap = require('dap')
      local filetypes = { 'javascript', 'typescript' }
      -- https://github.com/mfussenegger/nvim-dap/pull/48
      require('dap.ext.vscode').json_decode = require('json5').parse
      -- Load configuration from .vscode/launch.json
      require('dap.ext.vscode').load_launchjs(nil, {
        node = filetypes,
      })
      for _, language in ipairs(filetypes) do
        if dap.configurations[language] then
          for index in ipairs(dap.configurations[language]) do
            if dap.configurations[language][index].type == 'node' then
              dap.configurations[language][index].type = 'node2' -- pwa-node
            end
          end
        end
      end
    end,
  },

  -- Debug adapters
  -- {
  --   'mxsdev/nvim-dap-vscode-js',
  --   dependencies = {
  --     -- 'nvim-dap',
  --     'vscode-js-debug',
  --   },
  --   config = function()
  --     local utils = require('dap-vscode-js.utils')

  --     require('dap-vscode-js').setup({
  --       -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  --       -- debugger_path = '(runtimedir)/site/lazy/vscode-js-debug', -- Path to vscode-js-debug installation.
  --       debugger_path = utils.join_paths(utils.get_runtime_dir(), 'lazy', 'vscode-js-debug'),
  --       -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  --       adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  --       -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  --       -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  --       -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
  --     })

  --     -- for _, language in ipairs({ 'typescript', 'javascript' }) do
  --     --   -- https://github.com/microsoft/vscode-js-debug/blob/main/OPTIONS.md
  --     --   require('dap').configurations[language] = {
  --     --     {
  --     --       type = 'pwa-node',
  --     --       request = 'launch',
  --     --       name = 'Launch file',
  --     --       program = '${file}',
  --     --       cwd = '${workspaceFolder}',
  --     --     },
  --     --     {
  --     --       type = 'pwa-node',
  --     --       request = 'attach',
  --     --       name = 'Attach',
  --     --       processId = require('dap.utils').pick_process,
  --     --       cwd = '${workspaceFolder}',
  --     --     },
  --     --     -- jest, mocha
  --     --   }
  --     -- end
  --   end,
  -- },
  -- {
  --   'microsoft/vscode-js-debug',
  --   -- https://github.com/mxsdev/nvim-dap-vscode-js/issues/23
  --   version = 'v1.74.1',
  --   build = 'npm install --legacy-peer-deps && npm run compile',
  -- },

  -- UI
  {
    'rcarriga/nvim-dap-ui',
    dependencies = 'nvim-dap',
    keys = {
      -- stylua: ignore
      {
        '<Leader>D', function() require('dapui').toggle() end, desc = 'Debug Adapter Protocol UI',
      },
    },
    opts = {
      icons = { expanded = '', collapsed = '', current_frame = '' },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { '<CR>', '<2-LeftMouse>' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
        toggle = 't',
      },
      -- Use this to override mappings for specific elements
      element_mappings = {
        -- Example:
        -- stacks = {
        --   open = "<CR>",
        --   expand = "o",
        -- }
      },
      -- Expand lines larger than the window
      -- Requires >= 0.7
      expand_lines = vim.fn.has('nvim-0.7') == 1,
      -- Layouts define sections of the screen to place windows.
      -- The position can be "left", "right", "top" or "bottom".
      -- The size specifies the height/width depending on position. It can be an Int
      -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
      -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
      -- Elements are the elements shown in the layout (in order).
      -- Layouts are opened in order so that earlier layouts take priority in window sizing.
      layouts = {
        {
          elements = {
            -- Elements can be strings or table with id and size keys.
            { id = 'scopes', size = 0.25 },
            'breakpoints',
            'stacks',
            'watches',
          },
          size = 40, -- 40 columns
          position = 'left',
        },
        {
          elements = {
            'repl',
            'console',
          },
          size = 0.25, -- 25% of total lines
          position = 'bottom',
        },
      },
      controls = {
        -- Requires Neovim nightly (or 0.8 when released)
        enabled = true,
        -- Display controls in this element
        element = 'repl',
        icons = {
          pause = '',
          play = '',
          step_into = '',
          step_over = '',
          step_out = '',
          step_back = '',
          run_last = '',
          terminate = '',
        },
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = 'single', -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil, -- Can be integer or nil.
        max_value_lines = 100, -- Can be integer or nil.
      },
    },
  },
}
