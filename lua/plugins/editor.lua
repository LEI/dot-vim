-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/editor.lua
-- local util = require('lazyvim.util')
local settings = require('core.settings')

return {
  -- rmagatti/auto-session
  -- rmagatti/session-lens

  -- UI -- file explorer --- jarun/nnn
  {
    'nvim-tree/nvim-tree.lua',
    enabled = false,
    dependencies = {
      'nvim-web-devicons',
    },
    cmd = { 'NvimTreeFocus', 'NvimTreeOpen' },
    event = 'VeryLazy',
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {},
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    enabled = false,
    version = 'v2.x',
    dependencies = {
      'plenary.nvim',
      'nvim-web-devicons',
      'nui.nvim', -- _with_window_picker
    },
    cmd = 'Neotree',
    keys = {
      {
        '<Leader>tt',
        function()
          require('neo-tree.command').execute({ toggle = true, dir = require('lazyvim.util').get_root() })
        end,
        desc = 'NeoTree (root dir)',
      },
      { '<Leader>tT', '<cmd>Neotree toggle<CR>', desc = 'NeoTree (cwd)' },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    opts = {
      buffers = {
        follow_current_file = true,
        -- show_unloaded = true,
        -- window = {
        --   mappings = {
        --     ['bd'] = 'buffer_delete',
        --     ['<bs>'] = 'navigate_up',
        --     ['.'] = 'set_root',
        --   },
        -- },
      },
      -- close_if_last_window = true,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            'node_modules',
          },
        },
        follow_current_file = true,
        hijack_netrw_behavior = 'disabled', -- 'open_current', 'open_default', 'disabled'
        -- window = {
        --   mappings = {
        --     ["<bs>"] = "navigate_up",
        --     ["."] = "set_root",
        --     ["H"] = "toggle_hidden",
        --     ["/"] = "fuzzy_finder",
        --     ["D"] = "fuzzy_finder_directory",
        --     ["f"] = "filter_on_submit",
        --     ["<c-x>"] = "clear_filter",
        --     ["[g"] = "prev_git_modified",
        --     ["]g"] = "next_git_modified",
        --   }
        -- }
      },
      -- git_status = {
      --   window = {
      --     position = 'float',
      --     mappings = {
      --       ['A'] = 'git_add_all',
      --       ['gu'] = 'git_unstage_file',
      --       ['ga'] = 'git_add_file',
      --       ['gr'] = 'git_revert_file',
      --       ['gc'] = 'git_commit',
      --       ['gp'] = 'git_push',
      --       ['gg'] = 'git_commit_and_push',
      --     },
      --   },
      -- },
      -- popup_border_style = 'none',
      source_selector = {
        winbar = false,
        statusline = true,
      },
    },
  },

  -- -- search/replace in multiple files
  -- {
  --   'windwp/nvim-spectre',
  --   keys = {
  --     { '<leader>sr', function() require('spectre').open() end, desc = 'Replace in files (Spectre)' },
  --   },
  -- },

  -- Fuzzy finding
  -- ojroques/nvim-lspfuzzy
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'plenary.nvim',

      -- Optional dependencies
      -- 'BurntSushi/ripgrep',
      -- 'sharkdp/fd',
      'nvim-treesitter',
      'nvim-web-devicons',

      -- Plugins
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'barrett-ruth/telescope-http.nvim', -- :Telescope http list
      -- 'chip/telescope-software-licenses.nvim', -- :Telescope software-licenses find
      -- nvim-telescope/telescope-project.nvim
      'nvim-telescope/telescope-ghq.nvim',
      -- cljoly/telescope-repo.nvim
      -- nvim-telescope/telescope-node-modules.nvim
      -- 'gbrlsnchs/telescope-lsp-handlers.nvim',
      -- dhruvmanila/telescope-bookmarks.nvim
      -- crispgm/telescope-heading.nvim
      -- edolphin-ydf/goimpl.nvim
      -- camgraff/telescope-tmux.nvim -- norcalli/nvim-terminal.lua
      -- jvgrootveld/telescope-zoxide -- ajeetdsouza/zoxide
    },
    cmd = 'Telescope',
    -- stylua: ignore
    keys = {
      -- https://github.com/nvim-telescope/telescope.nvim#pickers
      { '<Leader>f', function() require('telescope.builtin').find_files() end, desc = 'File picker' },
      { '<Leader>F', function() require('telescope.builtin').find_files({ cwd = false }) end, desc = 'File picker (cwd)' },
      { '<Leader>b', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
      { '<leader>s', function() require('telescope.builtin').lsp_document_symbols() end, desc = 'Document Symbols' },
      { '<leader>Sd', function() require('telescope.builtin').diagnostics() end, desc = 'Search Diagnostics' }, -- <Leader>d/D
      { '<Leader>/', function() require('telescope.builtin').live_grep({ cwd = false }) end, desc = 'Global search' },
      { '<leader>?', function() require('telescope.builtin').help_tags() end, desc = 'Search Help tags' },
      -- { '<Leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent' },
      { '<Leader>gc', '<cmd>Telescope git_commits<CR>', desc = 'commits' },
      { '<Leader>gs', '<cmd>Telescope git_status<CR>', desc = 'status' },
      { '<Leader>ha', '<cmd>Telescope autocommands<cr>', desc = 'Auto Commands' },
      { '<Leader>hc', '<cmd>Telescope commands<cr>', desc = 'Commands' },
      { '<Leader>hf', '<cmd>Telescope filetypes<cr>', desc = 'File Types' },
      { '<Leader>hh', '<cmd>Telescope help_tags<cr>', desc = 'Help Pages' },
      { '<Leader>hH', '<cmd>Telescope http list<cr>', desc = 'HTTP status codes' },
      { '<Leader>hk', '<cmd>Telescope keymaps<cr>', desc = 'Key Maps' },
      { '<Leader>hm', '<cmd>Telescope man_pages<cr>', desc = 'Man Pages' },
      { '<Leader>ho', '<cmd>Telescope vim_options<cr>', desc = 'Options' },
      { '<Leader>hq', '<cmd>Telescope ghq list<CR>', desc = 'List remote repositories (ghq)' },
      { '<Leader>hs', '<cmd>Telescope highlights<cr>', desc = 'Search Highlight Groups' },
      { '<Leader>ht', '<cmd>Telescope builtin<cr>', desc = 'Telescope' },
      -- { '<leader>Sg', function() require('telescope.builtin').live_grep() end, desc = 'Search by Grep (root dir)' },
      -- { '<leader>SG', function() require('telescope.builtin').live_grep({ cwd = false }) end, desc = 'Search by Grep (cwd)', },
      { '<leader>,', '<cmd>Telescope buffers show_all_buffers=true<cr>', desc = 'Switch Buffer' },
      { '<leader>:', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
      { '<leader>Sb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Buffer' },
      { '<leader>Sm', '<cmd>Telescope marks<cr>', desc = 'Jump to Mark' },
      { '<leader>Sw', function() require('telescope.builtin').lsp_workspace_symbols() end, desc = 'Workspace Symbols' },
      { '<leader>Sd', function() require('telescope.builtin').lsp_document_symbols({ symbols = { 'Class', 'Function', 'Method', 'Constructor', 'Interface', 'Module', 'Struct', 'Trait', 'Field', 'Property', }, }) end, desc = 'Goto Symbol' },
    },
    defaults = {
      -- prompt_prefix = ' ',
      -- selection_caret = ' ',
      mappings = {
        i = {
          ['<C-t>'] = function(...)
            return require('trouble.providers.telescope').open_with_trouble(...)
          end,
          -- ['<C-i>'] = function()
          --   util.telescope('find_files', { no_ignore = true })()
          -- end,
          -- ['<C-h>'] = function()
          --   util.telescope('find_files', { hidden = true })()
          -- end,
          -- ['<C-Down>'] = function(...)
          --   return require('telescope.actions').cycle_history_next(...)
          -- end,
          -- ['<C-Up>'] = function(...)
          --   return require('telescope.actions').cycle_history_prev(...)
          -- end,
        },
        n = {
          ['<C-t>'] = function(...)
            return require('trouble.providers.telescope').open_with_trouble(...)
          end,
        },
      },
    },
    config = function(plugin)
      local telescope = require('telescope')
      telescope.setup({
        defaults = plugin.defaults,
        -- https://github.com/nvim-telescope/telescope.nvim/issues/938#issuecomment-877539724
        -- defaults = require('telescope.themes').get_dropdown(plugin.defaults),
        pickers = {
          find_files = {
            theme = 'dropdown',
            hidden = true,
          },
          -- git_status = {
          --   theme = 'dropdown',
          -- },
        },
        extensions = {
          fzf = {
            -- fuzzy = true,
            -- override_generic_sorter = true,
            -- override_file_sorter = true,
            -- case_mode = 'smart_case',
          },
          http = {
            -- How the mozilla url is opened. By default: xdg-open %s
            open_url = 'open %s', -- FIXME
          },
        },
      })
      telescope.load_extension('fzf')
      telescope.load_extension('http')
      telescope.load_extension('ghq')
    end,
  },

  -- GitHub issues and pull requests
  -- pwntester/octo.nvim, nvim-telescope/telescope-github.nvim

  -- Symbol sources
  -- nvim-telescope/telescope-symbols.nvim

  -- Cheat sheets
  -- https://github.com/sudormrfbin/cheatsheet.nvim/issues/26
  -- {
  --   'sudormrfbin/cheatsheet.nvim',
  --   dependencies = {
  --     -- 'nvim-lua/popup.nvim',
  --     'plenary.nvim',
  --     'telescope.nvim',
  --   },
  --   cmd = 'Cheatsheet',
  --   keys = {
  --     { '<Leader>?', desc = 'Cheatsheet' },
  --   },
  -- },

  -- Alternate between common files
  -- otavioschwanck/telescope-alternate

  -- -- easily jump to any location and enhanced f/t motions for Leap
  -- {
  --   'ggandor/leap.nvim',
  --   event = 'VeryLazy',
  --   dependencies = { { 'ggandor/flit.nvim', opts = { labeled_modes = 'nv' } } },
  --   config = function()
  --     require('leap').add_default_mappings(true)
  --   end,
  -- },

  -- which-key
  {
    'folke/which-key.nvim',
    -- enabled = false,
    -- cmd = 'WhichKey',
    event = 'VeryLazy',
    config = function()
      local wk = require('which-key')

      vim.o.timeout = true
      vim.o.timeoutlen = 300

      wk.setup({
        plugins = { spelling = true },
        -- operators = { gc = 'Comments' },
        key_labels = {
          -- ['<leader>'] = 'SPC'
          -- ["<space>"] = "SPC",
          -- ["<cr>"] = "RET",
          -- ["<tab>"] = "TAB",
        },
        -- icons = {
        --   breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
        --   separator = '➜', -- symbol used between a key and it's label
        --   group = '+', -- symbol prepended to a group
        -- },
        -- popup_mappings = {
        --   scroll_down = '<c-d>', -- binding to scroll down inside the popup
        --   scroll_up = '<c-u>', -- binding to scroll up inside the popup
        -- },
        window = {
          border = settings.border,
          -- position = 'bottom', -- bottom, top
          -- margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
          -- padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
          -- winblend = 0,
        },
        -- layout = {
        --   height = { min = 4, max = 25 }, -- min and max height of the columns
        --   width = { min = 20, max = 50 }, -- min and max width of the columns
        --   spacing = 3, -- spacing between columns
        --   align = 'left', -- align columns left, center or right
        -- },
        -- ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
        hidden = { '<Plug>', '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' }, -- hide mapping boilerplate
        -- show_help = true, -- show help message on the command line when the popup is visible
        -- show_keys = true, -- show the currently pressed key and its label as a message in the command line
        -- triggers = 'auto', -- automatically setup triggers
        -- triggers = {
        --   '<Leader>',
        --   'g',
        -- },
        triggers_blacklist = {
          c = { '%', 'w' }, -- FIXME: cmp %
          i = { 'j', 'k' },
          v = { 'j', 'k' },
        },
        disable = {
          buftypes = {},
          filetypes = { 'TelescopePrompt', 'dbout' },
        },
      })
      wk.register({
        mode = { 'n', 'v' },
        ['g'] = { name = '+goto' },
        [')'] = { name = '+next' },
        ['('] = { name = '+prev' },
        ['<Leader>c'] = { name = '+code' }, -- change
        ['<Leader>g'] = { name = '+git' },
        ['<Leader>S'] = { name = '+search' },
        ['<Leader>t'] = { name = '+toggle', mode = 'n' }, -- TODO: option mode
        ['<Leader>T'] = { name = '+test', mode = 'n' },
        ['<Leader>x'] = { name = '+diagnostics/quickfix', mode = 'n' },
        -- ['<Leader><Tab>'] = { name = '+tabs' },
      })

      local function remap(mode, left, right, keymap)
        -- keymap = keymap or {}
        if keymap and keymap.lhs and keymap.lhs ~= right and keymap.lhs:match('^%' .. right) then
          local lhs = keymap.lhs:gsub('^%' .. right, left)
          local rhs = keymap.lhs
          local callback = keymap.callback
          local desc = keymap.desc and keymap.desc
            or keymap.rhs and keymap.rhs:gsub('^<%w+>%(([%w-]+)%)', '%1'):gsub('-', ' ') -- :gsub('^unimpaired ', '')
            or rhs
          vim.api.nvim_set_keymap(mode, lhs, rhs, { callback = callback, desc = desc })
        end
      end

      -- Copy mappings prefixed with [ and ] to ( and ) and add desc
      for _, mode in ipairs({ 'n', 'o', 'x' }) do
        local keymaps = vim.api.nvim_get_keymap(mode)
        for _, keymap in ipairs(keymaps) do
          remap(mode, '(', '[', keymap)
          remap(mode, ')', ']', keymap)
        end
      end
    end,
  },

  -- References
  -- Resolve document highlights for the current text document position
  -- https://neovim.io/doc/user/lsp.html#vim.lsp.buf.document_highlight()
  {
    'RRethy/vim-illuminate',
    -- enabled = false,
    -- dependencies = 'nvim-treesitter',
    event = 'CursorHold', -- BufReadPost
    config = function()
      require('illuminate').configure({
        delay = 200,
        filetypes_denylist = {
          'dbui',
          'dirvish',
          'fugitive',
          'mason', -- buftype: nofile
        },
        under_cursor = false,
        large_file_cutoff = 300,
      })
    end,
    -- stylua: ignore
    keys = {
      { '))', function() require('illuminate').goto_next_reference(false) end, desc = 'Next Reference', },
      { '((', function() require('illuminate').goto_prev_reference(false) end, desc = 'Previous Reference', },
    },
  },

  -- -- buffer remove
  -- {
  --   'echasnovski/mini.bufremove',
  --   keys = {
  --     { '<leader>bd', function() require('mini.bufremove').delete(0, false) end, desc = 'Delete Buffer' },
  --     { '<leader>bD', function() require('mini.bufremove').delete(0, true) end, desc = 'Delete Buffer (Force)' },
  --   },
  -- },

  -- better diagnostics list and others
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble' },
    event = { 'BufReadPost' }, -- TODO LspDiagnosticsChanged
    -- stylua: ignore
    keys = {
      { '<Leader>xx', '<cmd>TroubleToggle<cr>', desc = 'Open Trouble', noremap = true },
      { '<Leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace diagnostics', noremap = true },
      { '<Leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Document diagnostics', noremap = true },
      { '<Leader>xl', '<cmd>TroubleToggle loclist<cr>', desc = 'Diagnostics to Quickfix list', noremap = true },
      { '<Leader>xq', '<cmd>TroubleToggle quickfix<cr>', desc = 'Diagnostics to Location list', noremap = true },
      { '<Leader>xr', '<cmd>TroubleToggle lsp_references<cr>', desc = 'LSP references under the cursor', noremap = true },
      { '<Leader>xD', '<cmd>TroubleToggle lsp_definitions<cr>', desc = 'LSP definitions under the cursor', noremap = true },
      { '<Leader>xt', '<cmd>TroubleToggle lsp_type_definitions<cr>', desc = 'LSP type definitions under the cursor',
        noremap = true },
    },
    opts = {
      -- position = 'bottom', -- position of the list can be: bottom, top, left, right
      -- height = 10, -- height of the trouble list when position is top or bottom
      -- width = 50, -- width of the list when position is left or right
      -- icons = true, -- use devicons for filenames
      -- mode = 'document_diagnostics', -- workspace_diagnostics, document_diagnostics, quickfix, lsp_references, loclist
      -- fold_open = '', -- icon used for open folds
      -- fold_closed = '', -- icon used for closed folds
      -- group = true, -- group results by file
      padding = false,
      -- action_keys = { -- key mappings for actions in the trouble list
      --   -- map to {} to remove a mapping, for example: close = {},
      --   close = 'q', -- close the list
      --   cancel = '<esc>', -- cancel the preview and get back to your last window / buffer / cursor
      --   refresh = 'r', -- manually refresh
      --   jump = { '<cr>', '<tab>' }, -- jump to the diagnostic or open / close folds
      --   open_split = { '<c-x>' }, -- open buffer in new split
      --   open_vsplit = { '<c-v>' }, -- open buffer in new vsplit
      --   open_tab = { '<c-t>' }, -- open buffer in new tab
      --   jump_close = { 'o' }, -- jump to the diagnostic and close the list
      --   toggle_mode = 'm', -- toggle between "workspace" and "document" diagnostics mode
      --   toggle_preview = 'P', -- toggle auto_preview
      --   hover = 'K', -- opens a small popup with the full multiline message
      --   preview = 'p', -- preview the diagnostic location
      --   close_folds = { 'zM', 'zm' }, -- close all folds
      --   open_folds = { 'zR', 'zr' }, -- open all folds
      --   toggle_fold = { 'zA', 'za' }, -- toggle fold of current file
      --   previous = 'k', -- previous item
      --   next = 'j', -- next item
      -- },
      indent_lines = false,
      -- auto_open = true,
      -- auto_close = true,
      auto_preview = false,
      -- auto_fold = false, -- automatically fold a file trouble list at creation
      -- auto_jump = { 'lsp_definitions' }, -- for the given modes, automatically jump if there is only a single result
      -- signs = {
      --   error = '',
      --   warning = '',
      --   hint = '',
      --   information = '',
      --   other = '﫠',
      -- },
      use_diagnostic_signs = true,
    },
  },

  -- emileferreira/nvim-strict

  -- TODO comments
  {
    'folke/todo-comments.nvim',
    dependencies = {
      'plenary.nvim',
    },
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = 'BufReadPost',
    -- stylua: ignore
    keys = {
      { ']c', function() require('todo-comments').jump_next() end, desc = 'Next Todo Comment', },
      { '[c', function() require('todo-comments').jump_prev() end, desc = 'Previous Todo Comment', },
      { '<leader>xt', '<cmd>TodoTrouble<cr>', desc = 'Todo Trouble' },
      -- { '<leader>xtt', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>', desc = 'Todo Trouble' },
      { '<leader>xT', '<cmd>TodoTelescope<cr>', desc = 'Todo Telescope' },
    },
    opts = {
      -- signs = true, -- show icons in the signs column
      -- sign_priority = 8, -- sign priority
      -- -- keywords recognized as todo comments
      -- keywords = {
      --   FIX = {
      --     icon = ' ', -- icon used for the sign, and in search results
      --     color = 'error', -- can be a hex color, or a named color (see below)
      --     alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
      --     -- signs = false, -- configure signs for some keywords individually
      --   },
      --   TODO = { icon = ' ', color = 'info' },
      --   HACK = { icon = ' ', color = 'warning' },
      --   WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
      --   PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      --   NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
      --   TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
      -- },
      -- gui_style = {
      --   fg = 'NONE', -- The gui style to use for the fg highlight group.
      --   bg = 'BOLD', -- The gui style to use for the bg highlight group.
      -- },
      -- merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- -- highlighting of the line containing the todo comment
      -- -- * before: highlights before the keyword (typically comment characters)
      -- -- * keyword: highlights of the keyword
      -- -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = false,
        -- multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
        -- multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        -- before = '', -- "fg" or "bg" or empty
        -- keyword = 'wide', -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        -- after = 'fg', -- "fg" or "bg" or empty
        -- pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
        -- comments_only = true, -- uses treesitter to match keywords in comments only
        -- max_line_len = 400, -- ignore lines longer than this
        -- exclude = {}, -- list of file types to exclude highlighting
      },
      -- -- list of named colors where we try to extract the guifg from the
      -- -- list of highlight groups or use the hex color if hl not found as a fallback
      -- colors = {
      --   error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
      --   warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
      --   info = { 'DiagnosticInfo', '#2563EB' },
      --   hint = { 'DiagnosticHint', '#10B981' },
      --   default = { 'Identifier', '#7C3AED' },
      --   test = { 'Identifier', '#FF00FF' },
      -- },
      -- search = {
      --   command = 'rg',
      --   args = {
      --     '--color=never',
      --     '--no-heading',
      --     '--with-filename',
      --     '--line-number',
      --     '--column',
      --   },
      --   -- regex that will be used to match keywords.
      --   -- don't replace the (KEYWORDS) placeholder
      --   pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      --   -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      -- },
    },
  },

  -- Translation
  {
    'potamides/pantran.nvim',
    -- local opts = {noremap = true, silent = true, expr = true}
    -- vim.keymap.set("n", "<leader>tr", pantran.motion_translate, opts)
    -- vim.keymap.set("n", "<leader>trr", function() return pantran.motion_translate() .. "_" end, opts)
    -- vim.keymap.set("x", "<leader>tr", pantran.motion_translate, opts)
    cmd = 'Pantran',
    opts = {
      default_engine = 'argos',
      engines = {
        apertium = {
          -- default_source = 'auto',
          -- default_target = 'eng',
          fallback_source = 'fra',
          -- url = 'https://beta.apertium.org/apy',
          -- markUnknown = 'no',
          -- format = 'txt', -- html, txt, rtf
        },
        argos = {
          -- default_source = 'auto',
          -- default_target = 'en',
          -- url = 'https://translate.argosopentech.com',
          -- api_key = vim.NIL,
        },
      },
      -- controls = {},
    },
  },

  -- Markdown preview
  -- davidgranstrom/nvim-markdown-preview (pandoc + live-server)
  {
    'iamcco/markdown-preview.nvim',
    -- build = function()
    --   vim.fn['mkdp#util#install']()
    -- end,
    build = 'cd app && yarn install',
    -- cmd = 'MarkdownPreview',
    ft = { 'markdown' },
    keys = {
      {
        '<Leader>mp',
        function()
          vim.cmd.MarkdownPreview()
        end,
        desc = 'Markdown Preview',
      },
    },
    -- vim.g.mkdp_filetypes = { 'markdown' }
    -- https://github.com/iamcco/markdown-preview.nvim#markdownpreview-config
  },

  -- Offline documentation
  -- KabbAmine/zeavim.vim
  -- keith/investigate.vim

  -- Devcontainer
  {
    'https://codeberg.org/esensar/nvim-dev-container',
    cmd = {
      'DevcontainerBuild', -- builds image from nearest devcontainer.json
      'DevcontainerImageRun', -- runs image from nearest devcontainer.json
      'DevcontainerBuildAndRun', -- builds image from nearest devcontainer.json and then runs it
      'DevcontainerBuildRunAndAttach', -- builds image from nearest devcontainer.json (with neovim added), runs it and attaches to neovim in it - currently using `terminal_handler`, but in the future with Neovim 0.8.0 maybe directly (https://codeberg.org/esensar/nvim-dev-container/issues/30)
      'DevcontainerComposeUp', -- run docker-compose up based on devcontainer.json
      'DevcontainerComposeDown', -- run docker-compose down based on devcontainer.json
      'DevcontainerComposeRm', -- run docker-compose rm based on devcontainer.json
      'DevcontainerStartAuto', -- start whatever is defined in devcontainer.json
      'DevcontainerStartAutoAndAttach', -- start and attach to whatever is defined in devcontainer.json
      'DevcontainerAttachAuto', -- attach to whatever is defined in devcontainer.json
      'DevcontainerStopAuto', -- stop whatever was started based on devcontainer.json
      'DevcontainerStopAll', -- stop everything started with this plugin (in current session)
      'DevcontainerRemoveAll', -- remove everything started with this plugin (in current session)
      'DevcontainerLogs', -- open plugin log file
      'DevcontainerOpenNearestConfig', -- opens nearest devcontainer.json file if it exists
      'DevcontainerEditNearestConfig', -- opens nearest devcontainer.json file if it exists, or creates a new one if it does not
    },
    keys = {
      { '<Leader>dcb', '<cmd>DevcontainerBuild<CR>', desc = 'Build devcontainer' },
      { '<Leader>dci', '<cmd>DevcontainerImageRun<CR>', desc = 'Run devcontainer image' },
      { '<Leader>dcr', '<cmd>DevcontainerBuildAndRun<CR>', desc = 'Build and run devcontainer' },
      { '<Leader>dca', '<cmd>DevcontainerBuildRunAndAttach<CR>', desc = 'Build, run and attach to devcontainer' },
      { '<Leader>dcu', '<cmd>DevcontainerComposeUp<CR>', desc = 'Run docker-compose up' },
      { '<Leader>dcd', '<cmd>DevcontainerComposeDown<CR>', desc = 'Run docker-compose down' },
      -- { '<Leader>dcR', '<cmd>DevcontainerComposeRm<CR>', desc = 'Run docker-compose down' },
      { '<Leader>dcs', '<cmd>DevcontainerStartAuto<CR>', desc = 'Start devcontainer' },
      { '<Leader>dct', '<cmd>DevcontainerStartAutoAndAttach<CR>', desc = 'Start and attach to devcontainer' },
      { '<Leader>dca', '<cmd>DevcontainerAttachAuto<CR>', desc = 'Attach to devcontainer' },
      { '<Leader>dcx', '<cmd>DevcontainerStopAuto<CR>', desc = 'Stop devcontainer' },
      { '<Leader>dcX', '<cmd>DevcontainerStopAll<CR>', desc = 'Stop all devcontainers' },
      { '<Leader>dcR', '<cmd>DevcontainerRemoveAll<CR>', desc = 'Remove all devcontainers' },
      { '<Leader>dcl', '<cmd>DevcontainerLogs<CR>', desc = 'Devcontainer logs' },
      { '<Leader>dco', '<cmd>DevcontainerOpenNearestConfig<CR>', desc = 'Open devcontainer.json' },
      { '<Leader>dce', '<cmd>DevcontainerEditNearestConfig<CR>', desc = 'Edit devcontainer.json' },
    },
    dependencies = 'nvim-treesitter', -- With jsonc parser
    opts = {
      -- config_search_start = function()
      --   -- By default this function uses vim.loop.cwd()
      --   -- This is used to find a starting point for .devcontainer.json file search
      --   -- Since by default, it is searched for recursively
      --   -- That behavior can also be disabled
      -- end,
      -- workspace_folder_provider = function()
      --   -- By default this function uses first workspace folder for integrated lsp if available and vim.loop.cwd() as a fallback
      --   -- This is used to replace `${localWorkspaceFolder}` in devcontainer.json
      --   -- Also used for creating default .devcontainer.json file
      -- end,
      -- terminal_handler = function(command)
      --   -- By default this function creates a terminal in a new tab using :terminal command
      --   -- It also removes statusline when that tab is active, to prevent double statusline
      --   -- It can be overridden to provide custom terminal handling
      -- end,
      -- nvim_dockerfile_template = function(base_image)
      --   -- Takes base_image and returns string, which should be used as a Dockerfile
      --   -- This is used when adding neovim to existing images
      --   -- Check out default implementation in lua/devcontainer/config.lua
      --   -- It installs neovim version based on current version
      -- end,
      -- devcontainer_json_template = function()
      --   -- Returns table - list of lines to set when creating new devcontainer.json files
      --   -- As a template
      --   -- Used only when using functions from commands module or created commands
      -- end,
      -- -- Can be set to false to prevent generating default commands
      -- -- Default commands are listed below
      -- generate_commands = true,
      -- -- By default no autocommands are generated
      -- -- This option can be used to configure automatic starting and cleaning of containers
      -- autocommands = {
      --   -- can be set to true to automatically start containers when devcontainer.json is available
      --   init = false,
      --   -- can be set to true to automatically remove any started containers and any built images when exiting vim
      --   clean = false,
      --   -- can be set to true to automatically restart containers when devcontainer.json file is updated
      --   update = false,
      -- },
      -- -- can be changed to increase or decrease logging from library
      -- log_level = 'info',
      -- -- can be set to true to disable recursive search
      -- -- in that case only .devcontainer.json and .devcontainer/devcontainer.json files will be checked relative
      -- -- to the directory provided by config_search_start
      -- disable_recursive_config_search = false,
      -- -- By default all mounts are added (config, data and state)
      -- -- This can be changed to disable mounts or change their options
      -- -- This can be useful to mount local configuration
      -- -- And any other mounts when attaching to containers with this plugin
      -- attach_mounts = {
      --   -- Can be set to true to always mount items defined below
      --   -- And not only when directly attaching
      --   -- This can be useful if executing attach command separately
      --   always = false,
      --   neovim_config = {
      --     -- enables mounting local config to /root/.config/nvim in container
      --     enabled = false,
      --     -- makes mount readonly in container
      --     options = { 'readonly' },
      --   },
      --   neovim_data = {
      --     -- enables mounting local data to /root/.local/share/nvim in container
      --     enabled = false,
      --     -- no options by default
      --     options = {},
      --   },
      --   -- Only useful if using neovim 0.8.0+
      --   neovim_state = {
      --     -- enables mounting local state to /root/.local/state/nvim in container
      --     enabled = false,
      --     -- no options by default
      --     options = {},
      --   },
      --   -- This takes a list of mounts (strings) that should always be added whenever attaching to containers
      --   -- This is passed directly as --mount option to docker command
      --   -- Or multiple --mount options if there are multiple values
      --   custom_mounts = {},
      -- },
      -- -- This takes a list of mounts (strings) that should always be added to every run container
      -- -- This is passed directly as --mount option to docker command
      -- -- Or multiple --mount options if there are multiple values
      -- always_mount = {},
      -- -- This takes a string (usually either "podman" or "docker") representing container runtime
      -- -- That is the command that will be invoked for container operations
      -- -- If it is nil, plugin will use whatever is available (trying "podman" first)
      -- container_runtime = nil,
      -- -- This takes a string (usually either "podman-compose" or "docker-compose") representing compose command
      -- -- That is the command that will be invoked for compose operations
      -- -- If it is nil, plugin will use whatever is available (trying "podman-compose" first)
      -- compose_command = nil,
    },
    init = function()
      local group = vim.api.nvim_create_augroup('Devcontainer', { clear = true })

      vim.api.nvim_create_autocmd('BufRead', {
        group = group,
        pattern = 'devcontainer.json',
        callback = function()
          vim.cmd('set filetype=jsonc')
        end,
      })
    end,
  },
}
