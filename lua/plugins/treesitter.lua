-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua

-- NOTE: Highlight and indent plugins should be both enabled or disabled
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/1167#issuecomment-1268933971
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/2544#issuecomment-1320986775

return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- Download latest release
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'RRethy/nvim-treesitter-endwise', -- Replaces tpope/vim-endwise
      -- 'nvim-treesitter-context', -- Uncomment to autoload
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/playground',
      'windwp/nvim-autopairs',
      'windwp/nvim-ts-autotag',
    },
    build = ':TSUpdate',
    event = 'BufReadPost',
    config = function()
      require('nvim-treesitter.configs').setup({
        -- sync_install = false,
        ensure_installed = {
          'bash',
          'help',
          'html',
          'javascript',
          'json',
          'jsonc',
          'lua',
          'markdown',
          'markdown_inline',
          'python',
          'query',
          'regex',
          'tsx',
          'typescript',
          'vim',
          'yaml',
        },
        highlight = {
          enable = true,
          disable = 'python',
          -- disable = function()
          --   return vim.b.large_buffer
          -- end,
          -- is_supported = function()
          --   print(vim.b.size)
          --   return true
          -- end,
        },
        indent = { enable = true },
        autopairs = { enable = true }, -- https://github.com/windwp/nvim-autopairs
        autotag = { enable = true }, -- https://github.com/windwp/nvim-ts-autotag
        context_commentstring = { enable = true, enable_autocmd = false }, -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
        endwise = { enable = true }, -- https://github.com/RRethy/nvim-treesitter-endwise

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<C-Space>',
            node_incremental = '<C-Space>',
            scope_incremental = '<C-s>',
            node_decremental = '<c-backspace>',
          },
        },
        -- refactor = {
        -- },
        textobjects = {
          -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects#textobjects-lsp-interop
          lsp_interop = {
            enable = true,
            border = 'single',
            floating_preview_opts = {},
            peek_definition_code = {
              ['<leader>df'] = '@function.outer',
              ['<leader>dF'] = '@class.outer',
            },
          },
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<Leader>sn'] = '@parameter.inner',
            },
            swap_previous = {
              ['<Leader>sp'] = '@parameter.inner',
            },
          },
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    cmd = { 'TSContextEnable', 'TSContextToggle' },
    -- event = 'VeryLazy',
    opts = {},
  },

  -- Annotations
  {
    'danymat/neogen',
    dependencies = 'nvim-treesitter',
    -- config = function()
    --   require('config.neogen')
    -- end,
    cmd = 'Neogen',
    -- keys = { '<localleader>d', '<localleader>df', '<localleader>dc' },
    keys = {
      {
        '<Leader>dg',
        function()
          require('neogen').generate()
        end,
        desc = 'Generate documentation',
      },
    },
    opts = {
      -- input_after_comment = true,
      -- https://github.com/danymat/neogen#supported-languages
      -- languages = {
      --   lua = {
      --     template = {
      --       annotation_convention = 'emmylua',
      --     },
      --   },
      -- },
      snippet_engine = 'luasnip',
    },
  },
  -- Alternatives:
  -- nvim-treesitter/nvim-tree-docs
  -- kkoomen/vim-doge
}
