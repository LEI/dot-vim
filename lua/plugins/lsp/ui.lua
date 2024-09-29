local settings = require('core.settings')

return {
  -- RishabhRD/nvim-lsputils
  -- glepnir/lspsaga.nvim

  -- LSP symbol navigation
  {
    'SmiteshP/nvim-navic',
    dependencies = {
      'lspkind.nvim',
      'nvim-lspconfig',
    },
    init = function()
      -- vim.g.navic_silence = true
      require('lazyvim.util').on_attach(function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          require('nvim-navic').attach(client, bufnr)
        end
      end)
    end,
    config = function()
      local lspkind = require('lspkind')
      local icons = {}
      for kind, icon in pairs(lspkind.symbol_map) do
        icons[kind] = icon .. ' '
      end
      require('nvim-navic').setup({
        icons = icons,
        highlight = true,
        separator = ' ',
        depth_limit = 5,
        depth_limit_indicator = settings.chars.ellipsis,
        safe_output = true,
      })
      vim.api.nvim_set_hl(0, 'NavicText', { link = 'Conceal' })

      -- https://github.com/askfiy/nvim/blob/master/lua/config/lsp/nvim-navic.lua

      -- local function setup()
      --   -- require('nvim-navic').is_available()
      --   vim.opt_local.winbar = "%{%v:winheight(0) < 5 and '' or lua.require('nvim-navic').get_location()%}"
      -- end

      -- setup()

      -- local ignore_filetype = { '', 'dap-repl', 'markdown' }
      -- vim.api.nvim_create_autocmd(
      --   -- { 'DirChanged', 'CursorMoved', 'CursorMovedI', 'BufWinEnter', 'BufFilePost', 'BufNewFile' },
      --   { 'BufReadPost' },
      --   {
      --     callback = function()
      --       if not vim.bo.buflisted or vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
      --         vim.opt_local.winbar = ''
      --         return
      --       end
      --       setup()
      --     end,
      --   }
      -- )
    end,
  },

  {
    'iabdelkareem/symbols-outline.nvim',
    branch = 'fix/default-highlighting',
    -- 'simrat39/symbols-outline.nvim',
    dependencies = {
      'lspkind.nvim',
      'nvim-lspconfig',
      'nvim-treesitter',
    },
    cmd = 'SymbolsOutline',
    keys = {
      { '<leader>O', ':SymbolsOutline<CR>', desc = 'Symbols Outline' },
    },
    config = function()
      local symbols_outline = require('symbols-outline')
      local lspkind = require('lspkind')
      local default_symbols = require('symbols-outline.config').defaults.symbols
      local symbols = {}
      for kind, icon in pairs(lspkind.symbol_map) do
        symbols[kind] = { icon = icon, hl = default_symbols[kind] and default_symbols[kind].hl or 'Error' }
      end
      symbols_outline.setup({
        show_guides = true,
        auto_preview = false, -- https://github.com/simrat39/symbols-outline.nvim/issues/176
        auto_close = true,
        -- fold_markers = { '', '' },
        -- wrap = false,
        -- keymaps = {
        --   close = { '<Esc>', 'q' },
        --   goto_location = '<Cr>',
        --   focus_location = 'o',
        --   hover_symbol = '<C-space>',
        --   toggle_preview = 'K',
        --   rename_symbol = 'r',
        --   code_actions = 'a',
        --   fold = 'h',
        --   unfold = 'l',
        --   fold_all = 'W',
        --   unfold_all = 'E',
        --   fold_reset = 'R',
        -- },
        symbols = symbols,
      })
    end,
  },

  -- LSP Status Progress
  {
    'nvim-lua/lsp-status.nvim',
    branch = 'develop',
    dev = true, -- Disable signs
    dependencies = {
      'nvim-lspconfig',
    },
    --event = 'BufReadPre', -- VeryLazy',
    config = function()
      local lsp_status = require('lsp-status')
      lsp_status.config({
        kind_labels = nil,
        current_function = false,
        -- show_filename = false,
        diagnostics = true,
        indicator_separator = '',
        component_separator = ' ', -- ' | ',
        indicator_errors = settings.signs.diagnostic.error,
        indicator_warnings = settings.signs.diagnostic.warn,
        indicator_info = settings.signs.diagnostic.info,
        indicator_hint = settings.signs.diagnostic.hint,
        indicator_ok = settings.signs.diagnostic.ok,
        spinner_frames = settings.spinner,
        status_symbol = '', -- ' ',
        select_symbol = nil,
        update_interval = 300,
        signs = false,
      })
      require('lazyvim.util').on_attach(function(client, bufnr)
        require('lsp-status').on_attach(client, bufnr)
      end)
      -- lsp_status.register_progress()
    end,
  },

  -- Known compatible LSP servers: https://github.com/j-hui/fidget.nvim/issues/17
  {
    'j-hui/fidget.nvim',
    enabled = false, -- FIXME: hides last vim message
    event = 'BufReadPre',
    opts = {
      text = {
        spinner = 'dots', -- animation shown when tasks are ongoing
        done = settings.signs.diagnostic.ok, -- character shown when all tasks are complete
        -- commenced = 'Started', -- message shown when task starts
        -- completed = 'Completed', -- message shown when task completes
      },
      -- timer = {
      --   spinner_rate = 125, -- frame rate of spinner animation, in ms
      --   fidget_decay = 2000, -- how long to keep around empty fidget, in ms
      --   task_decay = 1000, -- how long to keep around completed task, in ms
      -- },
      window = {
        -- relative = 'win', -- where to anchor, either "win" or "editor"
        blend = 20, -- 100, -- &winblend for the window
        -- zindex = nil, -- the zindex value for the window
        -- border = settings.border, -- FIXME: overlap
      },
      fmt = {
        -- leftpad = true, -- right-justify text in fidget box
        -- stack_upwards = true, -- list of tasks grows upwards
        -- max_width = 0, -- maximum width of the fidget box
        task = function(task_name, message, percentage)
          local msg = string.format('%s%s', message, percentage and string.format(' (%s%%)', percentage) or '')
          return task_name and string.format('%s %s', msg, task_name) or msg
        end,
      },
      -- sources = { -- Sources to configure
      --   ['*'] = { -- Name of source
      --     ignore = false, -- Ignore notifications from this source
      --   },
      -- },
      -- debug = {
      --   logging = false, -- whether to enable logging, for debugging
      --   strict = false, -- whether to interpret LSP strictly
      -- },
    },
  },

  -- Tags: weilbith/nvim-lsp-smag
  -- {
  --   'weilbith/nvim-floating-tag-preview',
  --   cmd = { 'Ptag', 'Ptselect', 'Ptjump', 'Psearch', 'Pedit' },
  -- },

  -- Code actions
  {
    'weilbith/nvim-code-action-menu',
    -- enabled = false,
    cmd = 'CodeActionMenu', -- FIXME: No range allowed
    keys = {
      -- { '<Leader>a', ':CodeActionMenu<CR>', desc = 'Code action menu', mode = { 'n', 'v' } },
    },
    -- event = 'BufReadPost',
    init = function()
      -- vim.g.code_action_menu_show_action_kind = true
      -- vim.g.code_action_menu_show_details = true
      -- vim.g.code_action_menu_show_diff = true
      -- vim.g.code_action_menu_window_border = settings.border
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    enabled = false,
    event = 'BufReadPost',
    -- config = function()
    --   local format_group = vim.api.nvim_create_augroup('LightBulb', { clear = true })
    --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    --     pattern = '*',
    --     callback = function()
    --       require('nvim-lightbulb').update_lightbulb()
    --     end,
    --     group = format_group,
    --   })
    -- end,
    opts = {
      ignore = {
        clients = {
          'null-ls',
          -- 'lua_ls',
        },
      },
      sign = {
        enabled = true,
        -- priority = 5,
      },
      -- float = {
      --   enabled = true,
      --   text = '',
      -- },
      -- virtual_text = {
      --   enabled = false,
      -- },
      autocmd = {
        enabled = true,
        pattern = { '*' },
        events = { 'CursorHold', 'CursorHoldI' },
      },
      -- TODO: ignore null-ls gitsigns
    },
  },
}
