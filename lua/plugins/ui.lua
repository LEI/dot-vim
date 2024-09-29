-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/ui.lua
local settings = require('core.settings')

local globalstatus = false

local HOME = os.getenv('HOME')
local no_name = '[No Name]'
local filename_symbols = {
  -- modified = '+', -- [+]
  -- readonly = '-', -- [-] non-modifiable or readonly
  unnamed = no_name, -- Text to show for unnamed buffers.
  newfile = '[New]', -- Text to show for newly created file before first write
}

-- local winbar = {
--   lualine_a = {},
--   lualine_b = {},
--   lualine_c = {
--     {
--       function()
--         if
--           vim.tbl_contains({ 'markdown' }, vim.bo.filetype)
--           or vim.api.nvim_win_get_height(0) <= 3
--           or not package.loaded['nvim-navic']
--           or not require('nvim-navic').is_available()
--         then
--           return '%t'
--         end
--         local location = require('nvim-navic').get_location()
--         return '%t ' .. (location ~= '' and location or '')
--       end,
--     },
--   },
--   lualine_x = {},
--   lualine_y = {},
--   lualine_z = {},
-- }

local hide_filename = function()
  -- return not (vim.b.isUndotreeBuffer or vim.tbl_contains({ 'dbui' }, vim.bo.filetype))
  return vim.tbl_contains({
    'Outline',
    'Trouble',
    'dbui',
  }, vim.bo.filetype) -- or vim.tbl_contains({ 'nofile' }, vim.api.nvim_buf_get_option(0, 'buftype')) or vim.b.isUndotreeBuffer
end

local type_as_mode = function()
  return vim.tbl_contains({
    'Outline',
    'Trouble',
    'dbout',
    'dbui',
    'help',
  }, vim.bo.filetype) or vim.b.isUndotreeBuffer
end

local function is_modifiable()
  -- return not vim.tbl_contains({ 'help', 'nofile', 'nowrite' }, vim.api.nvim_buf_get_option(0, 'buftype'))
  --   and not vim.tbl_contains({ 'dbout' }, vim.api.nvim_buf_get_option(0, 'filetype'))
  return vim.api.nvim_buf_get_option(0, 'modifiable')
end

local function is_terminal()
  return vim.api.nvim_buf_get_option(0, 'buftype') == 'terminal'
end

local window_number = function()
  return vim.api.nvim_win_get_number(0)
end

local format_mode = function(active)
  local is_active = active == nil and true or active
  return function(name)
    if type_as_mode() or not (is_terminal() or is_modifiable()) then
      return vim.bo.filetype or vim.bo.buftype
    end
    if globalstatus then
      return name
    end
    if vim.api.nvim_win_get_width(0) < 80 then
      name = name:sub(1, 1)
    end
    if not is_active then
      local length = #name
      local window = window_number()
      local rep = string.rep('-', 4) -- length - 2
      return length == 1 and tostring(window) or window .. ' ' .. rep
    end
    return name
  end
end

local filetype_icon = {
  'filetype',
  -- cond = function()
  --   return vim.bo.filetype ~= 'help' -- and vim.api.nvim_win_get_width(0) > 80
  -- end,
  icon_only = true,
  -- separator = '',
  padding = { left = 1 },
}

local filetype_name = {
  'filetype',
  cond = function()
    return not type_as_mode() and vim.api.nvim_win_get_width(0) > 80
  end,
  icons_enabled = false,
  padding = { right = 1 },
}

local function set_filename(name)
  vim.b.filename = name
  return name
end

local function fg(name)
  return function()
    ---@type {foreground?:number}?
    local hl = vim.api.nvim_get_hl_by_name(name, true)
    return hl and hl.foreground and { fg = string.format('#%06x', hl.foreground) }
  end
end

local filename = {
  'filename',
  color = fg('Normal'),
  cond = function()
    return not hide_filename()
  end,
  fmt = function(name)
    if vim.bo.filetype == 'help' then
      return '%t'
    end
    if vim.bo.filetype == 'dirvish' and name == '[No Name]' then
      local cwd = vim.fn.getcwd()
      if cwd:sub(1, #HOME) == HOME then
        return set_filename('~' .. cwd:sub(#HOME + 1))
      end
      return set_filename(cwd) -- '%f'
    end
    return set_filename(name)
  end,
  -- file_status = true, -- Displays file status (readonly status, modified status)
  -- newfile_status = false, -- Display new file status (new file means no write after created)
  path = 1, -- 0: Just the filename, 1: Relative path, 2: Absolute path, 3: Absolute path with ~
  -- shorting_target = 40, -- Shortens path to leave 40 spaces in the window
  symbols = filename_symbols,
  padding = { left = 1 },
}

local db_ui = {
  function()
    -- if vim.b.db then
    --   return 'U:' .. vim.api.nvim_call_function('db#url#safe_format', { vim.b.db.db_url })
    -- end
    -- local status = vim.api.nvim_call_function('db_ui#statusline', {
    --   prefix = '', -- 'DBUI: ',
    --   separator = '.',
    --   show = { 'db_name', 'schema', 'table' },
    -- })
    -- return 'S:' .. status
    return '%{db_ui#statusline()}'
  end,
}

local inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {
    -- window_number,
    {
      'mode',
      -- cond = type_as_mode,
      fmt = format_mode(false),
      -- padding = { left = 1 },
    },
    filetype_icon, -- { 'filetype', icon_only = true },
    filename, -- { 'filename', cond = show_filename, symbols = filename_symbols, path = 1, padding = { left = 0 } },
  },
  lualine_x = {
    filetype_name, -- { 'filetype', icons_enabled = false },
    'progress',
    'location',
  },
  lualine_y = {},
  lualine_z = {},
}

-- local sidebar_filetype = { 'filetype', icon_only = true, padding = { left = 1 } }
-- local sidebar_filename = {
--   'filename',
--   cond = show_filename,
--   file_status = false,
--   padding = { left = 1 },
--   path = 1,
--   symbols = filename_symbols,
-- }
-- local sidebar = {
--   sections = {
--     -- lualine_a = { { 'filetype', icons_enabled = false } },
--     -- lualine_b = {},
--     lualine_c = {
--       { 'filetype', icon_only = true, padding = { left = 1 } },
--       sidebar_filename,
--       db_ui,
--     },
--     lualine_x = {},
--     lualine_y = { 'progress' },
--     lualine_z = { 'location' },
--   },
--   inactive_sections = {
--     lualine_a = {},
--     lualine_c = {
--       -- window_number,
--       -- { 'filetype', icons_enabled = false, padding = { left = 1 } },
--       { 'filetype', icon_only = true, padding = { left = 1 } },
--       sidebar_filename,
--     },
--     lualine_x = {
--       'location',
--     },
--   },
--   filetypes = {
--     'dbout',
--     'dbui',
--     -- 'diff',
--     -- 'help',
--     -- 'undotree',
--   },
-- }

local function trailing_whitespaces()
  local prefix = '' -- TW
  local sep = '' -- :
  local space = vim.fn.search([[\s\+$]], 'nwc')
  return space ~= 0 and prefix .. sep .. space or ''
end

local function mixed_indent()
  local prefix = ' ' -- MI
  local sep = '' -- :
  local space_pat = [[\v^ +]]
  local tab_pat = [[\v^\t+]]
  local space_indent = vim.fn.search(space_pat, 'nwc')
  local tab_indent = vim.fn.search(tab_pat, 'nwc')
  local mixed = (space_indent > 0 and tab_indent > 0)
  local mixed_same_line
  if not mixed then
    mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], 'nwc')
    mixed = mixed_same_line > 0
  end
  if not mixed then
    return ''
  end
  if mixed_same_line ~= nil and mixed_same_line > 0 then
    return prefix .. sep .. mixed_same_line
  end
  local space_indent_cnt = vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
  local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
  if space_indent_cnt > tab_indent_cnt then
    return prefix .. sep .. tab_indent
  else
    return prefix .. sep .. space_indent
  end
end

return {
  {
    'andythigpen/nvim-coverage',
    dependencies = {
      'plenary.nvim',
    },
    cmd = { 'Coverage', 'CoverageSummary', 'CoverageToggle' },
    keys = {
      { '<Leader>cc', ':Coverage<CR>', desc = 'Coverage' },
      { '<Leader>cs', ':CoverageSummary<CR>', desc = 'Coverage Summary' },
      { '<Leader>tc', ':CoverageToggle<CR>', desc = 'Toggle coverage' },
    },
    opts = {
      auto_reload = true,
      commands = true,
    },
  },

  -- Notifications
  {
    'rcarriga/nvim-notify',
    dependencies = {
      'telescope.nvim', -- optional
    },
    -- cmd = { 'Notifications' }, -- Telescope notify
    keys = {
      {
        '<Leader>nn',
        function()
          require('notify').dismiss({ silent = true, pending = true })
        end,
        desc = 'Delete all Notifications',
      },
    },
    opts = {
      -- background_colour = 'Normal',
      -- fps = 30,
      icons = {
        ERROR = settings.signs.diagnostic.error, -- '',
        WARN = settings.signs.diagnostic.warn, -- '',
        INFO = settings.signs.diagnostic.info, -- '',
        DEBUG = '',
        TRACE = '✎',
      },
      level = vim.log.levels.TRACE,
      -- minimum_width = 50,
      -- render = 'default', -- default, minimal, simple
      stages = 'static', -- 'fade_in_slide_out', -- fade_in_slide_out, fade, slide, static
      -- timeout = 3000, -- Default: 5000
      -- top_down = true,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      vim.notify = function(...)
        return require('notify').notify(...)
      end
    end,
    config = function(plugin)
      require('notify').setup(plugin.opts)
      require('telescope').load_extension('notify')
    end,
  },

  -- better vim.ui
  {
    'stevearc/dressing.nvim',
    opts = {
      select = {
        get_config = function(opts)
          if opts.kind == 'codeaction' then
            return {
              -- backend = 'telescope',
              -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/themes.lua#L75
              telescope = require('telescope.themes').get_cursor({
                -- layout_config = {
                --   -- width = 80,
                --   height = 14, -- 9
                -- },
              }),
            }
          end
        end,
      },
    },
    init = function()
      vim.ui.select = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.input(...)
      end
    end,
  },

  -- Bufferline
  {
    'akinsho/nvim-bufferline.lua',
    -- enabled = false,
    version = '*',
    dependencies = {
      'nvim-web-devicons',
    },
    event = 'VeryLazy',
    -- init = function()
    --   vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next Buffer' })
    --   vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Previous Buffer' })
    -- end,
    opts = {
      options = {
        diagnostics = 'nvim_lsp', -- FIXME
        always_show_bufferline = false,
        -- diagnostics_indicator = function(_, _, diag)
        --   local icons = require('lazyvim.config').icons.diagnostics
        --   local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
        --     .. (diag.warning and icons.Warn .. diag.warning or '')
        --   return vim.trim(ret)
        -- end,
        -- offsets = {
        --   {
        --     filetype = 'neo-tree',
        --     text = 'Neo-tree',
        --     highlight = 'Directory',
        --     text_align = 'left',
        --   },
        -- },
      },
    },
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    -- dev = true,
    dependencies = {
      -- 'arkav/lualine-lsp-progress',
      -- 'lsp-status.nvim',
      'nvim-web-devicons',
    },
    event = 'VeryLazy',
    -- override = function(config)
    --   return config
    -- end,
    config = function()
      local lualine = require('lualine')
      --local icons = require('lazyvim.config.settings').icons

      -- Default highlight groups
      vim.api.nvim_set_hl(0, 'DiagnosticStatusError', { default = true, link = 'NvimInternalError' })
      -- vim.api.nvim_set_hl(0, 'DiagnosticStatusWarn', { default = true, link = 'DiagnosticWarn' })
      -- vim.api.nvim_set_hl(0, 'DiagnosticStatusInfo', { default = true, link = 'DiagnosticInfo' })
      -- vim.api.nvim_set_hl(0, 'DiagnosticStatusHint', { default = true, link = 'DiagnosticHint' })

      -- https://codeberg.org/esensar/nvim-dev-container/wiki/Recipes#statusbar
      vim.api.nvim_create_autocmd('User', {
        pattern = 'DevcontainerBuildProgress',
        callback = function()
          vim.cmd('redrawstatus')
        end,
      })

      -- local theme = require('lualine.themes.auto')
      -- for _, mode in ipairs({ 'normal', 'insert', 'replace', 'visual', 'command' }) do
      --   if theme[mode].a.gui == 'bold' then
      --     theme[mode].a.gui = nil
      --   end
      -- end
      lualine.setup({
        options = {
          -- icons_enabled = false,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            -- globalstatus and { 'Trouble' }
            statusline = { 'dashboard', 'lazy', 'alpha' },
            winbar = {},
          },
          -- ignore_focus = {},
          -- always_divide_middle = true,
          globalstatus = globalstatus,
          -- refresh = {
          --   statusline = 1000,
          --   tabline = 1000,
          --   winbar = 1000,
          -- },
        },
        sections = {
          lualine_a = {
            -- { window, padding = { left = 1 } },
            {
              'mode',
              -- cond = function()
              --   return vim.bo.filetype == 'help' or is_modifiable()
              -- end,
              fmt = format_mode(true),
              -- padding = { left = 1 },
            },
          },
          lualine_b = {
            {
              'branch',
              cond = function()
                return is_terminal() or is_modifiable() and not hide_filename() and vim.api.nvim_win_get_width(0) > 80
              end,
              icons_enabled = false,
              -- on_click = function(_, button)
              --   if button == 'l' then
              --     vim.cmd('Git') -- :'Telescope git_status theme=dropdown'
              --   end
              -- end,
              -- padding = { left = 1 },
            },
            -- db_ui,
          },
          lualine_c = {
            {
              'diff',
              cond = function()
                return is_modifiable() and not hide_filename() and vim.api.nvim_win_get_width(0) > 80
              end,
              -- colored = false,
              -- diff_color = {
              --   added = 'DiffAdd',
              --   modified = 'DiffChange',
              --   removed = 'DiffDelete',
              -- },
              symbols = {
                added = settings.signs.git.added,
                modified = settings.signs.git.modified,
                removed = settings.signs.git.removed,
              },
              fmt = function(str)
                return str:gsub('%s+', '')
              end,
              padding = { left = 1 },
            },
            filetype_icon,
            filename,
            {
              function()
                return require('nvim-navic').get_location()
              end,
              cond = function()
                return vim.b.filename
                  and vim.api.nvim_win_get_width(0) > 160 + #vim.b.filename
                  and not vim.tbl_contains({ 'markdown' }, vim.bo.filetype)
                  and package.loaded['nvim-navic']
                  and require('nvim-navic').is_available()
              end,
              padding = { left = 1 },
            },
          },
          lualine_x = {
            {
              function()
                local status = require('package-info').get_status()
                return status and status:gsub('^| ', '') or ''
              end,
              cond = function()
                return vim.bo.filetype == 'json' -- package.json
              end,
            },
            -- {
            --   function()
            --     return '%{gutentags#statusline("[", "]")}'
            --   end,
            --   cond = function()
            --     return vim.fn.exists('*gutentags#statusline')
            --   end,
            -- },
            {
              function()
                return require('lsp-status').status()
              end,
              cond = function()
                return is_modifiable() and #vim.lsp.get_active_clients() > 0
              end,
              on_click = function(_, button)
                if button == 'l' then
                  vim.cmd('LspInfo')
                end
              end,
              padding = { right = 1 },
            },
            -- {
            --   'lsp_progress',
            --   -- TODO: keep client name https://github.com/arkav/lualine-lsp-progress/issues/21
            --   -- display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
            --   display_components = { 'lsp_client_name', { 'title', 'percentage', 'message' }, 'spinner' },
            --   -- display_components = { 'spinner', { 'title', 'percentage', 'message' } },
            --   separators = {
            --     lsp_client_name = { pre = '', post = '' },
            --     message = { pre = ' ', post = '' },
            --     progress = '', -- ' | ',
            --     title = { pre = '', post = '' },
            --   },
            --   -- timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
            --   message = {
            --     commenced = '', -- In Progress
            --     completed = '', -- Complete / Ready settings.signs.diagnostic.ok,
            --   },
            --   spinner_symbols = settings.spinner,
            -- },
            {
              'diagnostics',
              -- always_visible = true,
              cond = function()
                return is_modifiable() and #vim.lsp.get_active_clients() > 0 -- and not vim.b.large_buffer
              end,
              on_click = function(_, button)
                if button == 'l' then
                  vim.cmd('Trouble')
                end
              end,
              sources = {
                -- 'nvim_lsp',
                'nvim_diagnostic',
                -- 'nvim_workspace_diagnostic',
                -- 'coc',
                -- 'ale',
                -- 'vim_lsp'.
              },
              -- sections = { 'error', 'warn', 'info', 'hint' },
              diagnostics_color = {
                error = 'DiagnosticStatusError',
                -- warn = 'DiagnosticStatusWarn',
                -- info = 'DiagnosticStatusInfo',
                -- hint = 'DiagnosticStatusHint',
              },
              symbols = {
                error = settings.signs.diagnostic.error,
                warn = settings.signs.diagnostic.warn,
                info = settings.signs.diagnostic.info,
                hint = settings.signs.diagnostic.hint,
                -- ok = settings.signs.diagnostic.ok,
              },
              -- always_visible = true,
              fmt = function(str)
                return str:gsub('%#lualine_x_diagnostics_error#(.*%d+%s?)', '%#lualine_x_diagnostics_error# %1 %%*')
              end,
              padding = { right = 1 },
            },
            {
              trailing_whitespaces,
              cond = function()
                return is_modifiable()
              end,
              padding = { right = 1 },
            },
            {
              mixed_indent,
              cond = is_modifiable,
              padding = { right = 1 },
            },
            {
              function()
                local updates = #require('lazy.manage.checker').updated
                return updates > 0 and (settings.icons.lazy.plugin .. ' ' .. updates)
              end,
              cond = require('lazy.status').has_updates,
              color = fg('Special'),
              on_click = function(_, button)
                if button == 'l' then
                  vim.cmd('Lazy')
                end
              end,
              padding = { right = 1 },
            },
            {
              function()
                local status = require('devcontainer.status').find_build({ running = true })
                if not status then
                  return ''
                end
                return string.format(
                  'devc[%s/%s](%s%%%%)',
                  status.current_step or '',
                  status.step_count or '',
                  status.progress or 0
                )
              end,
            },
            {
              'encoding',
              cond = function()
                return not vim.tbl_contains({ 'help' }, vim.bo.filetype) and vim.api.nvim_win_get_width(0) > 80
              end,
              fmt = function(str)
                return str ~= 'utf-8' and str or ''
              end,
              padding = { right = 1 },
            },
            {
              'fileformat',
              cond = function()
                return not vim.tbl_contains({ 'dirvish', 'help' }, vim.bo.filetype)
                  and vim.bo.filetype ~= 'help'
                  and vim.api.nvim_win_get_width(0) > 80
              end,
              fmt = function(str)
                return str ~= 'LF' and str or ''
              end,
              icons_enabled = true,
              symbols = {
                unix = 'LF',
                dos = 'CRLF',
                mac = 'CR',
              },
              padding = { right = 1 },
            },
            filetype_name,
          },
          lualine_y = {
            'progress',
          },
          lualine_z = {
            'location',
          },
        },
        -- inactive_sections = global_status and {} or inactive_sections,
        inactive_sections = inactive_sections,
        -- tabline = {
        --   lualine_a = {
        --     {
        --       'buffers',
        --       show_filename_only = true, -- Shows shortened relative path when set to false.
        --       hide_filename_extension = false, -- Hide filename extension when set to true.
        --       show_modified_status = true, -- Shows indicator when the buffer is modified.

        --       mode = 0, -- 0: Shows buffer name
        --       -- 1: Shows buffer index
        --       -- 2: Shows buffer name + buffer index
        --       -- 3: Shows buffer number
        --       -- 4: Shows buffer name + buffer number

        --       max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
        --       -- it can also be a function that returns
        --       -- the value of `max_length` dynamically.
        --       filetype_names = {
        --         TelescopePrompt = 'Telescope',
        --         dashboard = 'Dashboard',
        --         packer = 'Packer',
        --         fzf = 'FZF',
        --         alpha = 'Alpha',
        --       }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

        --       -- buffers_color = {
        --       --   -- Same values as the general color option can be used here.
        --       --   active = 'lualine_{section}_normal', -- Color for active buffer.
        --       --   inactive = 'lualine_{section}_inactive', -- Color for inactive buffer.
        --       -- },

        --       symbols = {
        --         modified = ' +', --  ●
        --         alternate_file = '#',
        --         directory = '',
        --       },
        --     },
        --   },
        --   lualine_b = {}, -- branch
        --   lualine_c = {}, -- filename
        --   lualine_x = {},
        --   lualine_y = {},
        --   lualine_z = { 'tabs' },
        -- },
        -- winbar = winbar,
        -- inactive_winbar = global_status and inactive_sections or {},
        -- https://github.com/nvim-lualine/lualine.nvim#available-extensions
        extensions = {
          'fugitive',
          'fzf',
          'man',
          -- 'neo-tree',
          'nvim-dap-ui',
          -- 'nvim-tree',
          'quickfix',
          -- sidebar, -- 'symbols-outline',
        },
      })

      -- require('lualine').setup(plugin.override({
      --   options = {
      --     theme = 'auto',
      --     globalstatus = true,
      --     disabled_filetypes = { statusline = { 'dashboard', 'lazy', 'alpha' } },
      --   },
      --   sections = {
      --     lualine_a = { 'mode' },
      --     lualine_b = { 'branch' },
      --     lualine_c = {
      --       {
      --         'diagnostics',
      --         symbols = {
      --           error = icons.diagnostics.Error,
      --           warn = icons.diagnostics.Warn,
      --           info = icons.diagnostics.Info,
      --           hint = icons.diagnostics.Hint,
      --         },
      --       },
      --       { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
      --       { 'filename', path = 1, symbols = { modified = '  ', readonly = '', unnamed = '' } },
      --   -- stylua: ignore
      --   {
      --     function() return require('nvim-navic').get_location() end,
      --     cond = function() return package.loaded['nvim-navic'] and require('nvim-navic').is_available() end,
      --   },
      --     },
      --     lualine_x = {
      --   -- stylua: ignore
      --   -- {
      --   --   function() return require('noice').api.status.command.get() end,
      --   --   cond = function() return package.loaded['noice'] and require('noice').api.status.command.has() end,
      --   --   color = fg('Statement')
      --   -- },
      --   -- stylua: ignore
      --   -- {
      --   --   function() return require('noice').api.status.mode.get() end,
      --   --   cond = function() return package.loaded['noice'] and require('noice').api.status.mode.has() end,
      --   --   color = fg('Constant') ,
      --   -- },
      --       { require('lazy.status').updates, cond = require('lazy.status').has_updates, color = fg('Special') },
      --       {
      --         'diff',
      --         symbols = {
      --           added = icons.git.added,
      --           modified = icons.git.modified,
      --           removed = icons.git.removed,
      --         },
      --       },
      --     },
      --     lualine_y = {
      --       { 'progress', separator = '', padding = { left = 1, right = 0 } },
      --       { 'location', padding = { left = 0, right = 1 } },
      --     },
      --     lualine_z = {
      --       function()
      --         return ' ' .. os.date('%R')
      --       end,
      --     },
      --   },
      --   extensions = { 'nvim-tree' },
      -- }))
    end,
  },

  -- Tabline
  -- bagrat/vim-buffet
  -- tpope/vim-flagship
  -- ...

  -- indent guides for Neovim
  {
    'lukas-reineke/indent-blankline.nvim',
    enabled = false,
    event = 'BufReadPre',
    opts = {
      -- char = '▏',
      -- char = '│',
      filetype_exclude = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy' },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  -- -- active indent guide and indent text objects
  -- {
  --   'echasnovski/mini.indentscope',
  --   version = false, -- wait till new 0.7.0 release to put it back on semver
  --   event = 'BufReadPre',
  --   config = function()
  --     vim.api.nvim_create_autocmd('FileType', {
  --       pattern = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason' },
  --       callback = function()
  --         vim.b.miniindentscope_disable = true
  --       end,
  --     })
  --     require('mini.indentscope').setup({
  --       -- symbol = '▏',
  --       symbol = '│',
  --       options = { try_as_border = true },
  --     })
  --   end,
  -- },

  -- -- noicer ui
  -- {
  --   'folke/noice.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     lsp = {
  --       override = {
  --         ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
  --         ['vim.lsp.util.stylize_markdown'] = true,
  --       },
  --     },
  --     presets = {
  --       bottom_search = true,
  --       command_palette = true,
  --       long_message_to_split = true,
  --     },
  --   },
  --   -- stylua: ignore
  --   keys = {
  --     { '<S-Enter>', function() require('noice').redirect(vim.fn.getcmdline()) end, mode = 'c', desc = 'Redirect Cmdline' },
  --     { '<leader>nl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
  --     { '<leader>nh', function() require('noice').cmd('history') end, desc = 'Noice History' },
  --     { '<leader>na', function() require('noice').cmd('all') end, desc = 'Noice All' },
  --     { '<c-f>', function() if not require('noice.lsp').scroll(4) then return '<c-f>' end end, silent = true, expr = true, desc = 'Scroll forward' },
  --     { '<c-b>', function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end, silent = true, expr = true, desc = 'Scroll backward'},
  --   },
  -- },

  ---- start screen
  --{
  --  'echasnovski/mini.starter',
  --  enabled = false,
  --  version = false, -- wait till new 0.7.0 release to put it back on semver
  --  event = 'VimEnter',
  --  config = function()
  --    local logo = table.concat({
  --      '██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z',
  --      '██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z',
  --      '██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z',
  --      '██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z',
  --      '███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║',
  --      '╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝',
  --    }, '\n')
  --    local pad = string.rep(' ', 22)
  --    local new_section = function(name, action, section)
  --      return { name = name, action = action, section = pad .. section }
  --    end

  --    local starter = require('mini.starter')
  --    --stylua: ignore
  --    local opts = {
  --      evaluate_single = true,
  --      header = logo,
  --      items = {
  --        new_section('Find file', 'Telescope find_files', 'Telescope'),
  --        new_section('Recent files', 'Telescope oldfiles', 'Telescope'),
  --        new_section('Grep text', 'Telescope live_grep', 'Telescope'),
  --        new_section('init.lua', 'e $MYVIMRC', 'Config'),
  --        new_section('Lazy', 'Lazy', 'Config'),
  --        new_section('New file', 'ene | startinsert', 'Built-in'),
  --        new_section('Quit', 'qa', 'Built-in'),
  --      },
  --      content_hooks = {
  --        starter.gen_hook.adding_bullet(pad .. '░ ', false),
  --        starter.gen_hook.aligning('center', 'center'),
  --      },
  --    }

  --    -- close Lazy and re-open when starter is ready
  --    if vim.o.filetype == 'lazy' then
  --      vim.cmd.close()
  --      vim.api.nvim_create_autocmd('User', {
  --        pattern = 'MiniStarterOpened',
  --        callback = function()
  --          require('lazy').show()
  --        end,
  --      })
  --    end

  --    starter.setup(config)

  --    vim.api.nvim_create_autocmd('User', {
  --      pattern = 'LazyVimStarted',
  --      callback = function()
  --        local stats = require('lazy').stats()
  --        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
  --        local pad_footer = string.rep(' ', 8)
  --        MiniStarter.config.footer = pad_footer .. '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
  --        pcall(MiniStarter.refresh)
  --      end,
  --    })
  --  end,
  --},

  -- dashboard
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    opts = function()
      local dashboard = require('alpha.themes.dashboard')
      dashboard.section.header.val = 'nvim'
      dashboard.section.buttons.val = {
        dashboard.button('f', ' ' .. ' Find file', ':Telescope find_files <CR>'),
        dashboard.button('n', ' ' .. ' New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('r', ' ' .. ' Recent files', ':Telescope oldfiles <CR>'),
        dashboard.button('g', ' ' .. ' Find text', ':Telescope live_grep <CR>'),
        dashboard.button('c', ' ' .. ' Config', ':e $MYVIMRC <CR>'),
        dashboard.button('s', '勒' .. ' Restore Session', [[:lua require("persistence").load() <cr>]]),
        dashboard.button('l', '鈴' .. ' Lazy', ':Lazy<CR>'),
        dashboard.button('q', ' ' .. ' Quit', ':qa<CR>'),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = 'AlphaButtons'
        button.opts.hl_shortcut = 'AlphaShortcut'
      end
      dashboard.section.footer.opts.hl = 'Type'
      dashboard.section.header.opts.hl = 'AlphaHeader'
      dashboard.section.buttons.opts.hl = 'AlphaButtons'
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      vim.b.miniindentscope_disable = true

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'AlphaReady',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      require('alpha').setup(dashboard.opts)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyVimStarted',
        callback = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  -- Folding
  -- kevinhwang91/nvim-ufo

  -- Package managers
  {
    'vuki656/package-info.nvim',
    branch = 'develop',
    dev = true, -- version = false,
    dependencies = 'MunifTanjim/nui.nvim',
    ft = 'json',
    event = 'BufRead package.json',
    -- stylua: ignore
    keys = {
      { '<Leader>ns', function() require('package-info').show({ force = false }) end, desc = 'Show npm outdated' },
      { '<Leader>nc', function() require('package-info').hide() end, desc = 'Hide npm outdated' },
      { '<Leader>nt', function() require('package-info').toggle() end, desc = 'Toggle npm outdated' },
      { '<Leader>nu', function() require('package-info').update() end, desc = 'Update dependency' },
      { '<Leader>nd', function() require('package-info').delete() end, desc = 'Delete dependency' },
      { '<Leader>ni', function() require('package-info').install() end, desc = 'Install a new dependency' },
      { '<Leader>np', function() require('package-info').change_version() end, desc = 'Install a different version' },
    },
    opts = {
      diagnostic = {
        enable = true,
        severity = {
          outdated = vim.diagnostic.severity.ERROR,
          unwanted = vim.diagnostic.severity.WARN,
        },
      },
      icons = {
        enable = true,
        style = settings.icons.package,
      },
      -- autostart = false,
      hide_up_to_date = true,
      -- hide_unstable_versions = true,
    },
    config = function()
      vim.api.nvim_set_hl(0, 'PackageInfoOutdatedVersion', { default = true, link = 'Error' })
      vim.api.nvim_set_hl(0, 'PackageInfoUnwantedVersion', { default = true, link = 'WarningMsg' })
      vim.api.nvim_set_hl(0, 'PackageInfoUpToDateVersion', { default = true, link = 'LspCodeLens' })

      vim.api.nvim_create_autocmd('BufRead', {
        group = vim.api.nvim_create_augroup('PackageInfo', { clear = true }),
        pattern = 'package.json',
        callback = function() end,
      })
    end,
  },
  {
    'saecki/crates.nvim',
    ft = 'toml',
    dependencies = {
      'null-ls.nvim',
      'nvim-cmp',
      'plenary.nvim',
    },
    event = 'BufRead Cargo.toml',
    keys = {
      {
        '<Leader>ct',
        function()
          require('package-info').show({ force = false })
        end,
        desc = 'Show npm outdated',
      },
    },
    opts = {
      null_ls = {
        enabled = true,
        name = 'crates.nvim',
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('BufRead', {
        group = vim.api.nvim_create_augroup('CargoCrates', { clear = true }),
        pattern = 'Cargo.toml',
        callback = function(args)
          local cmp = require('cmp')
          local crates = require('crates')
          local wk = require('which-key')

          cmp.setup.buffer({
            sources = {
              -- { name = 'path' },
              -- { name = 'buffer' },
              -- { name = 'nvim_lsp' },
              { name = 'crates' },
            },
          })

          wk.register({
            cC = {
              name = '+Crates',
              t = { crates.toggle, 'Toggle Crates' },
              r = { crates.reload, 'Reload Crates' },

              v = { crates.show_versions_popup, 'Show Crates Versions' },
              f = { crates.show_features_popup, 'Show Crates Features' },
              d = { crates.show_dependencies_popup, 'Show Crates Dependencies' },

              u = { crates.update_crate, 'Update Crate' },
              a = { crates.update_all_crates, 'Update Crates' },
              U = { crates.upgrade_crates, 'Upgrade Crates' },
              A = { crates.upgrade_all_crates, 'Upgrade All Crates' },

              H = { crates.open_homepage, 'Open Homepage' },
              R = { crates.open_repository, 'Open Repository' },
              D = { crates.open_documentation, 'Open Documentation' },
              C = { crates.open_crates_io, 'Open Crates.io' },
            },
          }, { mode = 'n', prefix = '<Leader>', buffer = args.buf })

          wk.register({
            cC = {
              u = { crates.update_crates, 'Update selected Crates' },
              a = { crates.upgrade_crates, 'Upgrade selected Crates' },
            },
          }, { mode = 'v', prefix = '<Leader>', buffer = args.buf })
        end,
      })
    end,
  },

  -- Color highlighter
  {
    'NvChad/nvim-colorizer.lua',
    -- ft = { 'css', 'html', 'javascript', 'lua', 'vim', 'json' },
    -- opts = function(plugin)
    --   local filetypes = plugin.ft -- { '*' }
    --   filetypes.html = { mode = 'foreground' }
    --   return {
    --     filetypes = filetypes,
    --     -- user_default_options = {
    --     --   RGB = true, -- #RGB hex codes
    --     --   RRGGBB = true, -- #RRGGBB hex codes
    --     --   names = true, -- "Name" codes like Blue or blue
    --     --   RRGGBBAA = false, -- #RRGGBBAA hex codes
    --     --   AARRGGBB = false, -- 0xAARRGGBB hex codes
    --     --   rgb_fn = false, -- CSS rgb() and rgba() functions
    --     --   hsl_fn = false, -- CSS hsl() and hsla() functions
    --     --   css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    --     --   css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    --     --   -- Available modes for `mode`: foreground, background,  virtualtext
    --     --   mode = 'background', -- Set the display mode.
    --     --   -- Available methods are false / true / "normal" / "lsp" / "both"
    --     --   -- True is same as normal
    --     --   tailwind = false, -- Enable tailwind colors
    --     --   -- parsers can contain values used in |user_default_options|
    --     --   sass = { enable = false, parsers = { css } }, -- Enable sass colors
    --     --   virtualtext = '■',
    --     -- },
    --     -- all the sub-options of filetypes apply to buftypes
    --     -- buftypes = { '*', '!prompt', '!popup' },
    --   }
    -- end,
  },

  -- Icons
  {
    'nvim-tree/nvim-web-devicons',
    opts = {
      override = settings.devicons,
    },
  },

  -- UI components
  'MunifTanjim/nui.nvim',
}
