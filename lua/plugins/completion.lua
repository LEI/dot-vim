-- https://github.com/seblj/dotfiles/blob/master/nvim/lua/config/lspconfig/init.lua
-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-completion.md
local settings = require('core.settings')

local max_buffer_size = 1024 * 1024 -- 1 Mb
local function buffer_size(bufnr)
  bufnr = bufnr ~= nil and bufnr or vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_get_offset(bufnr, vim.api.nvim_buf_line_count(bufnr))
end

local function file_exists(path)
  -- local f = io.open(path, 'r')
  -- if f ~= nil then
  --   io.close(f)
  --   return true
  -- else
  --   return false
  -- end
  path = path:gsub('^~', vim.fn.expand('$HOME'))
  return vim.fn.filereadable(path) == 1
end

local function function_exists(name)
  return name:match('^[%w+]+$') and vim.fn.exists('*' .. name)
end

return {
  -- Completion

  -- Autocompletion and signature help plugin (LSP + fallback)
  --[==[ {
    'echasnovski/mini.nvim',
    branch = 'stable',
    config = function()
      -- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-completion.txt#L92
      local keys = {
        ['cr']        = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
        ['ctrl-y']    = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
        ['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
      }
      _G.cr_action = function()
        if vim.fn.pumvisible() ~= 0 then
          -- If popup is visible, confirm selected item or add new line otherwise
          local item_selected = vim.fn.complete_info()['selected'] ~= -1
          return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
        else
          -- If popup is not visible, use plain `<CR>`. You might want to customize
          -- according to other plugins. For example, to use 'mini.pairs', replace
          -- next line with `return require('mini.pairs').cr()`
          return keys['cr']
        end
      end
      vim.api.nvim_set_keymap('i', '<CR>', 'v:lua._G.cr_action()', { noremap = true, expr = true })
      vim.api.nvim_set_keymap('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { noremap = true, expr = true })
      vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { noremap = true, expr = true })

      require('mini.completion').setup({
        -- LSP completion setup on attach
        auto_setup = false,

        lsp_completion = {
          -- source_func = 'completefunc',
          source_func = 'omnifunc',
        },

        -- Module mappings. Use `''` (empty string) to disable one. Some of them
        -- might conflict with system mappings.
        mappings = {
          force_twostep = '<C-Space>', -- Force two-step completion
          force_fallback = '<A-Space>', -- Force fallback completion
        },

        -- Whether to set Vim's settings for better experience (modifies
        -- `shortmess` and `completeopt`)
        set_vim_settings = true,
      })
    end,
    event = 'InsertEnter',
  }, ]==]
  --

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
      config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
      -- region_check_events = 'InsertInter',
    },
    -- stylua: ignore
    keys = {
      -- {
      --   '<Tab>',
      --   function()
      --     return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<Tab>'
      --   end,
      --   expr = true, remap = true, silent = true, mode = 'i',
      -- },
      -- { '<Tab>', function() require('luasnip').jump(1) end, mode = 's' },
      -- { '<S-Tab>', function() require('luasnip').jump(-1) end, mode = { 'i', 's' } },
    },
    config = function()
      local luasnip = require('luasnip')
      luasnip.setup({ region_check_events = 'InsertEnter', delete_check_events = 'InsertEnter' })
    end,
  },

  -- Auto completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'nvim-lspconfig',
      'lspkind.nvim', -- NOTE: must be in the same file

      -- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources

      -- Snippets
      'saadparwaiz1/cmp_luasnip',

      -- Built-in
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-calc',
      'uga-rosa/cmp-dictionary',
      'f3fora/cmp-spell', -- or z=
      -- buffer-lines digraphs, omni

      -- LSP
      'hrsh7th/cmp-nvim-lsp',
      -- 'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-nvim-lsp-signature-help',

      -- File system
      'hrsh7th/cmp-path',

      -- Git
      { 'petertriho/cmp-git', dependencies = 'plenary.nvim' },

      -- Command line
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',

      -- Fuzzy finding

      -- Shell
      'andersevenrud/cmp-tmux',

      -- Dependencies
      -- { 'David-Kunz/cmp-npm', dependencies = 'plenary.nvim' },

      -- Copilot
      -- 'copilot-cmp',

      -- 'crispgm/cmp-beancount',
      'quangnguyen30192/cmp-nvim-tags',
      -- 'hrsh7th/cmp-nvim-lua', -- Replaced by neodev
      -- 'KadoBOT/cmp-plugins',
      -- 'ray-x/cmp-treesitter',
      'kristijanhusak/vim-dadbod-completion',

      -- Icons
      'nvim-web-devicons',
      'chrisgrieser/cmp-nerdfont',

      'nvim-autopairs',
    },
    event = { 'CmdlineEnter', 'InsertEnter' },
    -- keys = {},
    config = function()
      -- https://github.com/wbthomason/dotfiles/blob/linux/neovim/.config/nvim/lua/config/cmp.lua
      local cmp = require('cmp')
      local cmp_buffer = require('cmp_buffer')
      local luasnip = require('luasnip')

      -- https://github.com/nvim-tree/nvim-web-devicons/blob/master/lua/nvim-web-devicons.lua#L1718
      local devicons = require('nvim-web-devicons')
      -- local default_icon = devicons.get_default_icon()
      -- local icons = devicons.get_icons()
      -- local function get_icon(name, ext, use_default_icon)
      --   ext = ext or name:match('^.*%.(.*)$') or ''
      --   local icon_data = nil
      --   local kind = nil
      --   if icons[name] then
      --     icon_data = icons[name]
      --     kind = name
      --   elseif icons[ext] then
      --     icon_data = icons[ext]
      --     kind = ext
      --   else
      --     icon_data = use_default_icon and default_icon
      --     kind = 'File'
      --   end
      --   if not icon_data then
      --     return
      --   end
      --   -- return symbol_text and icon_data.icon .. ' ' .. kind or icon_data.icon,
      --   --   icon_data.name and 'DevIcon' .. icon_data.name
      --   return icon_data.icon, kind, icon_data.name and 'DevIcon' .. icon_data.name
      -- end

      -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
      -- local has_words_before = function()
      --   unpack = unpack or table.unpack
      --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
      -- end
      -- https://github.com/zbirenbaum/copilot-cmp#tab-completion-configuration-highly-recommended
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
          return false
        end
        ---@diagnostic disable-next-line: deprecated
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match('^%s*$') == nil
      end

      -- local enable_copilot = vim.g.enable_copilot
      -- if enable_copilot == 1 then
      --   vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })
      -- end

      require('cmp_dictionary').setup({
        dic = {
          ['*'] = { '/usr/share/dict/words' },
          -- ["lua"] = "path/to/lua.dic",
          -- ["javascript,typescript"] = { "path/to/js.dic", "path/to/js2.dic" },
          -- filename = {
          --   ["xmake.lua"] = { "path/to/xmake.dic", "path/to/lua.dic" },
          -- },
          -- filepath = {
          --   ["%.tmux.*%.conf"] = "path/to/tmux.dic"
          -- },
          -- spelllang = {
          --   en = "path/to/english.dic",
          -- },
        },
        -- exact = 2,
        -- first_case_insensitive = false,
        -- document = false,
        -- document_command = "wn %s -over",
        async = true,
        -- max_items = -1,
        -- capacity = 5,
        -- debug = true,
      })

      local source_names = {
        buffer = '[Buffer]',
        calc = '[Calc]',
        cmdline = '[Cmdline]',
        cmdline_history = '[History]',
        copilot = '[Copilot]',
        dap = '[DAP]',
        dictionary = '[Dict]', -- Replaced by completion item
        git = '[Git]',
        luasnip = '[LuaSnip]',
        nvim_lsp = '[LSP]',
        -- nvim_lsp_document_symbol = '[Symbol]',
        nvim_lsp_signature_help = '[Signature]',
        -- nvim_lua = '[Lua]',
        path = '[Path]',
        spell = '[Spell]',
        tags = '[Tags]',
        tmux = '[tmux]',
        -- ['vim-dadbod-completion'] = '[dadbod]', -- Replaced by completion item
      }

      local buffer_source = {
        name = 'buffer',
        option = {
          -- https://github.com/hrsh7th/cmp-buffer#performance-on-large-text-files
          get_bufnrs = function()
            local visible_buffers = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local bufnr = vim.api.nvim_win_get_buf(win)
              if buffer_size(bufnr) < max_buffer_size then
                table.insert(visible_buffers, bufnr)
              end
            end
            return visible_buffers
          end,
        },
      }
      local lsp_sources = {
        {
          -- vim.opt.spell = true
          -- vim.opt.spelllang = { 'en_us' }
          name = 'spell',
          option = {
            keyword_length = 2,
            -- keep_all_entries = false,
            enable_in_context = function()
              return require('cmp.config.context').in_treesitter_capture('spell')
            end,
          },
        },
        { name = 'path' },
        -- { name = 'copilot' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        -- { name = 'nvim_lua' },
        { name = 'luasnip' },
        buffer_source,
        { name = 'tmux', option = { all_panes = false } },
        { name = 'nerdfont', option = { trigger_characters = { ':' } } },
      }
      -- Second group index only visible if none of the above source is available
      local fallback_sources = {
        { name = 'calc', option = { keyword_length = 3 } },
        { name = 'tags', option = { keyword_length = 3 } },
        { name = 'dictionary', option = { keyword_length = 3 } },
      }

      local select_behavior = cmp.SelectBehavior.Replace
      -- local select_behavior = cmp.SelectBehavior.Select
      cmp.setup({
        -- completion = { completeopt = 'menu,menuone,noinsert' }, -- menu,preview,longest

        -- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/issues/17
        preselect = cmp.PreselectMode.None,

        sorting = {
          -- priority_weight = 2,
          comparators = {
            -- https://github.com/hrsh7th/cmp-buffer#locality-bonus-comparator-distance-based-sorting
            function(...)
              return cmp_buffer:compare_locality(...)
            end,

            -- function(entry1, entry2)
            --   local score1 = entry1.completion_item.score
            --   local score2 = entry2.completion_item.score
            --   if score1 and score2 then
            --     return (score1 - score2) < 0
            --   end
            -- end,

            -- -- The built-in comparators:
            -- cmp.config.compare.offset,
            -- cmp.config.compare.exact,
            -- cmp.config.compare.score,
            -- require('cmp-under-comparator').under,
            -- cmp.config.compare.kind,
            -- cmp.config.compare.sort_text,
            -- cmp.config.compare.length,
            -- cmp.config.compare.order,

            -- https://github.com/zbirenbaum/copilot-cmp#comparators
            -- require('copilot_cmp.comparators').prioritize,
            -- require('copilot_cmp.comparators').score,

            -- Below is the default list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- window = {
        --   completion = {
        --     winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
        --     col_offset = -3,
        --     side_padding = 0,
        --   },
        -- },
        -- formatting = {
        --   fields = { 'kind', 'abbr', 'menu' },
        --   format = function(entry, vim_item)
        --     local kind = require('lspkind').cmp_format { mode = 'symbol_text', maxwidth = 50 }(entry, vim_item)
        --     local strings = vim.split(kind.kind, '%s', { trimempty = true })
        --     kind.kind = ' ' .. strings[1] .. ' '
        --     kind.menu = '    (' .. strings[2] .. ')'
        --     return kind
        --   end,
        -- },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort({}),
          -- Accept currently selected item
          -- Set `select` to `false` to only confirm explicitly selected items.
          ['<CR>'] = cmp.mapping.confirm({
            -- behavior = cmp.ConfirmBehavior.Replace, select = true,
            select = false,
          }),
          -- vim.schedule_wrap?

          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = select_behavior })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = select_behavior })
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),

          -- ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          -- ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
          -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          -- ['<C-y>'] = cmp.config.disable,
          -- ['<C-e>'] = cmp.mapping {
          --   i = cmp.mapping.abort(),
          --   c = cmp.mapping.close(),
          -- },
          -- ['<cr>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
          -- ['<tab>'] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_next_item()
          --   elseif luasnip.expand_or_jumpable() then
          --     luasnip.expand_or_jump()
          --   elseif has_words_before() then
          --     cmp.complete()
          --   else
          --     fallback()
          --   end
          -- end, { 'i', 's' }),
          -- ['<s-tab>'] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_prev_item()
          --   elseif luasnip.jumpable(-1) then
          --     luasnip.jump(-1)
          --   else
          --     fallback()
          --   end
          -- end, { 'i', 's' }),
        }),
        -- The order of the sources determines their order in the completion results
        sources = cmp.config.sources(lsp_sources, fallback_sources),
        formatting = {
          -- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#show-devicons-as-kind
          format = require('lspkind').cmp_format({
            mode = 'symbol_text',
            -- menu = source_names,
            -- symbol_map = settings.kinds,
            before = function(entry, vim_item)
              if entry.source.name == 'cmdline' and vim_item.kind == 'Variable' then
                -- local label = vim_item.word -- abbr -- entry:get_completion_item().label
                -- if label ~= '' then
                --   local is_directory = label:sub(-1) == '/'
                --   P(vim_item)
                --   local is_file = not is_directory and file_exists(vim_item.abbr)
                --   local is_command = not (is_directory or is_file)
                --     and (label:sub(1, 1) == ':' or function_exists(vim_item.abbr))
                --   vim_item.kind = is_directory and 'Folder' or is_command and 'Function' or is_file and 'File' or ''
                --   vim_item.kind_hl_group = 'CmpItemKind' .. vim_item.kind
                -- end
                vim_item.kind = '' -- TODO: 'Command'
                vim_item.menu = '' -- string.format('[%s]', entry.source.name)
              elseif entry.source.name == 'vim-dadbod-completion' then
                local item = entry:get_completion_item()
                if item.documentation == 'SQL reserved word' then
                  vim_item.kind = 'Keyword'
                  -- vim_item.menu = '[SQL]'
                elseif item.documentation == 'table' then
                  vim_item.kind = 'Table'
                elseif item.documentation:sub(-13) == ' table column' then
                  local table = item.documentation:sub(1, -14)
                  -- vim_item.abbr = table .. '.' .. vim_item.abbr
                  vim_item.kind = 'Column'
                  vim_item.menu = string.format('[%s]', table)
                else
                  vim_item.kind = item.documentation
                  -- vim_item.menu = item.labelDetails.description
                end
              elseif not vim_item.menu then
                vim_item.menu = source_names[entry.source.name]
              end

              -- -- https://github.com/hrsh7th/nvim-cmp/discussions/609#discussioncomment-1844480
              local label = vim_item.abbr
              local max_label_width = math.max(0, vim.o.columns - 25) -- # entry.source.name or vim.item.menu
              local truncated_label = vim.fn.strcharpart(label, 0, max_label_width)
              if truncated_label ~= label then
                vim_item.abbr = truncated_label .. settings.chars.ellipsis
              end

              -- if
              --   (entry.source.name == 'cmdline' and vim_item.kind == 'Variable')
              --   or vim.tbl_contains({ 'path' }, entry.source.name)
              -- then
              --   local file = entry:get_completion_item().label
              --   local is_directory = file ~= '' and file:sub(-1) == '/'
              --   -- if is_directory then
              --   --   vim_item.kind = settings.kinds.Folder
              --   --   vim_item.kind_hl_group = 'Comment'
              --   --   -- vim_item.menu = 'Directory'
              --   --   return vim_item
              --   -- end
              --   -- TODO: exclude commands (e.g. cc)
              --   -- local _, kind = get_icon(file, nil, entry.source.name == 'path')
              --   -- if kind then
              --   --   vim_item.kind = kind
              --   --   -- vim_item.kind_hl_group = hl_group
              --   --   return vim_item
              --   -- end
              --   -- local icon, kind, hl_group = get_icon(file, nil, entry.source.name == 'path')
              --   -- if kind then
              --   --   vim_item.kind = icon
              --   --   vim_item.kind_hl_group = hl_group
              --   --   -- vim_item.menu = kind
              --   --   return vim_item
              --   -- end
              --   -- if entry.source.name == 'cmdline' then
              --   --   vim_item.kind = ''
              --   --   return vim_item
              --   -- end
              -- end

              if entry.source.name == 'dictionary' then
                local item = entry:get_completion_item()
                -- https://github.com/hrsh7th/nvim-cmp/issues/388#issuecomment-949274984
                -- vim_item.menu = item.detail

                -- Detect dictionary source
                -- Check if item.detail matches "belongs to `<source>`"
                local dict_source = item.detail:match('belong to `(%w+)`') or item.detail
                vim_item.kind = dict_source
              end
              -- if not source_names[entry.source.name] then
              --   vim.notify('Unknown completion source: ' .. entry.source.name)
              --   source_names[entry.source.name] = string.format('[%s]', entry.source.name)
              -- end
              return vim_item
            end,
          }),
        },
        view = {
          entries = {
            name = 'custom',
            native = true,
            selection_order = 'near_cursor',
          },
        },
        window = {
          completion = {
            -- border = settings.border,
            -- winhighlight,
            -- zindex,
            -- side_padding = 1,
          },
          documentation = {
            -- border = settings.border,
            -- winhighlight,
            zindex = 51, -- Above signature help
          },
        },
        experimental = {
          ghost_text = false, -- { hl_group = 'LspCodeLens' }, -- Conflicts with copilot
        },
      })

      -- for _, cmd_type in ipairs({ '/', '?', '@' }) do
      --   cmp.setup.cmdline(cmd_type, {
      --     mapping = cmp.mapping.preset.cmdline(),
      --     sources = cmp.config.sources({
      --       -- { name = 'nvim_lsp_document_symbol' },
      --       buffer_source,
      --       { name = 'cmdline_history', options = { history_type = cmd_type } },
      --     }),
      --   })
      -- end

      -- https://github.com/hrsh7th/nvim-cmp/issues/875#issuecomment-1214416687
      cmp.setup.cmdline(':', {
        -- fields = { 'abbr' },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { '!', '%', 'Man' },
            },
          },
        }, {
          { name = 'cmdline_history', options = { history_type = ':' } },
        }),
      })

      -- Setup buffer-specific configuration

      local git_filetypes = { 'gitcommit', 'octo' }

      -- :commit, @mention, #issue (ang github pr), !mr (gitlab)
      require('cmp_git').setup({
        -- filetypes = git_filetypes,
        -- In order of most to least prioritized
        -- remotes = { 'upstream', 'origin' },
        -- https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtinsteadOf
        -- enableRemoteUrlRewrites = false,
      })

      cmp.setup.filetype(git_filetypes, {
        sources = cmp.config.sources({
          { name = 'git' },
          { name = 'luasnip' },
        }, {
          buffer_source,
          { name = 'tmux', option = { all_panes = false } },
        }),
      })

      -- Markdown
      cmp.setup.filetype({ 'markdown', 'help', 'txt' }, {
        sources = cmp.config.sources(lsp_sources, fallback_sources),
        -- window = {
        --   documentation = cmp.config.disable,
        -- },
      })

      -- SQL
      cmp.setup.filetype({ 'sql', 'mysql', 'plsql' }, {
        sources = cmp.config.sources({
          { name = 'vim-dadbod-completion' },
          { name = 'luasnip' },
          buffer_source, -- Not working?
          { name = 'tmux', option = { all_panes = false } },
        }, fallback_sources),
      })

      -- -- https://github.com/zbirenbaum/copilot.lua#suggestion
      -- cmp.event:on('menu_opened', function()
      --   vim.b.copilot_suggestion_hidden = true
      -- end)

      -- cmp.event:on('menu_closed', function()
      --   vim.b.copilot_suggestion_hidden = false
      -- end)

      -- -- https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#add-parentheses-after-selecting-function-or-method-item
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'rcarriga/cmp-dap',
    dependencies = {
      'nvim-cmp',
    },
    config = function()
      local cmp = require('cmp')
      -- require('dap').session().capabilities.supportsCompletionsRequest
      cmp.setup({
        enabled = function()
          return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
        end,
      })
      cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
        sources = cmp.config.sources({
          { name = 'dap' },
        }),
      })
    end,
  },
  {
    'onsails/lspkind.nvim',
    config = function()
      require('lspkind').init({
        mode = 'symbol_text', -- text, text_symbol, symbol_text, symbol (default)
        -- maxwidth = 50, -- prevent the popup from showing more than provided characters
        -- ellipsis_char = settings.chars.ellipsis, -- when popup menu exceed maxwidth (must define maxwidth first)
        preset = 'codicons',
        symbol_map = settings.kinds,
      })
    end,
  },

  -- AI
  {
    -- TODO: Ignore .env, *.local
    'zbirenbaum/copilot.lua', -- :Copilot auth
    enabled = false, -- FIXME: breaks LSP signature completion
    cmd = 'Copilot',
    -- event = 'InsertEnter',
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = '((',
          jump_next = '))',
          -- accept = '<CR>',
          -- refresh = 'gr',
          -- open = '<M-CR>',
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true, -- :Copilot suggestion toggle_auto_trigger
        -- debounce = 75,
        keymap = {
          accept = '<C-j>', -- '<M-l>',
          -- accept_word = false,
          -- accept_line = false,
          next = '<Right>', -- '<M-]>',
          prev = '<Left>', -- '<M-[>',
          dismiss = '<C-e>', -- '<C-]>',
        },
      },
      filetypes = {
        -- yaml = false,
        -- markdown = false,
        -- help = false,
        -- gitcommit = false,
        -- gitrebase = false,
        -- hgcommit = false,
        -- svn = false,
        -- cvs = false,
        -- ['.'] = false,
      },
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    enabled = false,
    dependencies = 'copilot.lua',
    opts = {
      -- method = 'getCompletionsCycling',
      -- formatters = {
      --   label = require('copilot_cmp.format').format_label_text,
      --   insert_text = require('copilot_cmp.format').format_insert_text,
      --   preview = require('copilot_cmp.format').deindent,
      -- },
    },
  },
  {
    'jackMort/ChatGPT.nvim',
    enabled = false,
    dependencies = {
      'nui.nvim',
      'plenary.nvim',
      'telescope.nvim',
    },
    cmd = { 'ChatGPT' },
    opts = {
      -- https://github.com/jackMort/ChatGPT.nvim#configuration
    },
  },
}
