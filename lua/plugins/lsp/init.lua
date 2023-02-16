-- https://github.com/wbthomason/dotfiles/blob/main/dot_config/nvim/lua/config/lsp.lua
-- https://github.com/roginfarrer/dotfiles/blob/main/nvim/.config/nvim/lua/plugins/lsp/init.lua
-- https://github.com/junnplus/lsp-setup.nvim
local settings = require('core.settings')

---@alias Command string | string[]
---@alias Source table null-ls source
---@alias Tool table { version?: string }

local function executable(name)
  return vim.fn.executable(name) == 1
end

-- Execute shell commands
---@param commands { [string]: Command }
local function execute_install(commands)
  for name, cmd in pairs(commands) do
    local is_installed = executable(name)
    if not is_installed then
      vim.notify(string.format('Installing %s', name), 'INFO', {
        title = name,
      })
      local Job = require('plenary.job')
      local is_table = type(cmd) == 'table'
      local opts = {
        command = is_table and cmd[1] or 'sh',
        args = is_table and { unpack(cmd, 2) } or #cmd and { cmd } or {},
        -- on_exit = function(j, return_val)
        --   vim.pretty_print(j:result())
        -- end,
      }
      -- vim.pretty_print(opts)
      Job:new(opts):start() -- or :sync(10000)
    end
  end
end

-- Ensure tools are installed
-- Skip if no version is provided and the tool is available globally
---@param tools { [string]: Tool }
local function mason_install(tools)
  local mr = require('mason-registry')
  for name, opts in pairs(tools) do
    if not vim.tbl_isempty(opts) or not executable(name) then
      local p = mr.get_package(name)
      if not p:is_installed() then
        p:install(opts)
      end
    end
  end
end

---@param config { install: { [string]: Command }, tools?: { [string]: Tool }, sources: Source[] }
local function null_ls_register(config)
  local null_ls = require('null-ls')
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1373#issuecomment-1407433597
  -- if name and not null_ls.is_registered(?) then
  --   return false
  -- end
  if config.install then
    execute_install(config.install)
  end
  if config.tools then
    mason_install(config.tools)
  end
  null_ls.register(config.sources)
end

-- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/util.lua#L1351
-- local max_width = 80
-- local line_separator = function()
--   local width = math.min(vim.fn.winwidth(0) - 2, max_width) -- vim.lsp.buf.util.width
--   return string.rep('─', width)
-- end

-- Alternative? https://github.com/neovim/neovim/issues/17757#issuecomment-1073266618
local format_diagnostic = function(diagnostic)
  local msg = diagnostic.message
  local user_data = diagnostic.user_data

  -- Add LSP diagnostic code (e.g. eslint rule)
  if diagnostic.code then
    msg = string.format('%s (%s)', msg, diagnostic.code)
  end

  if user_data then
    if user_data.lsp and user_data.lsp.codeDescription then
      -- TODO no highlight msg = string.format('%s\n', msg)
      for key, value in pairs(user_data.lsp.codeDescription) do
        -- Add codeDescription.href (eslint documentation link)
        if key == 'href' then
          msg = string.format('%s\n%s', msg, value)
        else
          msg = string.format('%s\n%s: %s', msg, key, type(value) == 'string' and value or vim.inspect(value))
        end
      end
    end
    if user_data.lsp then
      if user_data.lsp.relatedInformation then
        for _, related in ipairs(user_data.lsp.relatedInformation) do
          msg = string.format(
            '%s\n[%d-%d] %s',
            msg,
            related.location.range.start.character,
            related.location.range['end'].character,
            related.message
            -- related.location.uri
          )
        end
      end
      if user_data.lsp.data then
        if user_data.lsp.data.rendered then
          msg = string.format('%s\n%s', msg, user_data.lsp.data.rendered)
        end
        for key, value in pairs(user_data.lsp.data) do
          if key ~= 'rendered' then
            msg = string.format('%s\n%s: %s', msg, key, type(value) == 'string' and value or vim.inspect(value))
          end
        end
      end
      for key, value in pairs(user_data.lsp) do
        if
          key ~= 'code'
          and key ~= 'codeDescription'
          and key ~= 'data'
          and key ~= 'relatedInformation'
          and (diagnostic.source ~= 'typescript' or key ~= 'tags')
        then
          msg = string.format('%s\nLSP %s: %s', msg, key, type(value) == 'string' and value or vim.inspect(value))
        end
      end
    else
      for key, value in pairs(user_data) do
        msg = string.format('%s\n%s: %s', msg, key, type(value) == 'string' and value or vim.inspect(value))
      end
    end
  end

  -- -- TODO: Get documentation URL from eslint-ls code action
  -- local code_actions = vim.lsp.buf.code_action({
  --   context = {
  --     diagnostics = { diagnostic },
  --   },
  --   -- only = { 'source...eslint' },
  -- })
  -- print(vim.inspect(code_actions))
  -- local url = code_actions[1].edit.documentChanges[1].textDocument.text
  -- local url = url:match('https://eslint.org/docs/rules/[%w-]+')
  -- if url then
  --   msg = string.format('%s [%s]', msg, url)
  -- end
  return string.format('%s\n', msg)
end

if settings.diagnostic.float == nil then
  settings.diagnostic.float = {}
end
-- if settings.diagnostic.float.border == nil then
--   settings.diagnostic.float.border = 'none'
-- end
if settings.diagnostic.float.header == nil then
  settings.diagnostic.float.header = ''
end
-- settings.diagnostic.float.max_width = max_width
-- close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
-- close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'TextChanged' }, -- DiagnosticChanged
if settings.diagnostic.float.close_events == nil then
  settings.diagnostic.float.close_events = { 'CursorMoved', 'DiagnosticChanged', 'BufHidden', 'InsertEnter' }
end
if settings.diagnostic.float.format == nil then
  settings.diagnostic.float.format = format_diagnostic
end
-- FIXME: this adds extra new lines (more than 1 on second open?)
-- function(_, i)
--   local sep = i == 1 and '' or line_separator()
--   return sep, 'Comment'
-- end
if settings.diagnostic.float.source == nil then
  settings.diagnostic.float.source = 'always'
end

vim.diagnostic.config(settings.diagnostic)

-- FIXME: overriding handlers breaks syntax highlighting
-- TODO: move to ./handlers.lua
-- https://github.com/Issafalcon/lsp-overloads.nvim

-- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
--   border = settings.border,
-- })
-- https://github.com/askfiy/nvim/blob/master/lua/utils/aid/lspconfig.lua
local function lsp_hover(_, result, ctx, config)
  local bufnr, winnr = vim.lsp.handlers.hover(_, result, ctx, config)
  if bufnr and winnr then
    vim.api.nvim_buf_set_name(bufnr, config.name)
  end
  return bufnr, winnr
end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(lsp_hover, {
  name = 'lsp-hover',
  -- border = 'none',
})

-- Configure signature help handler
-- https://www.reddit.com/r/neovim/comments/vbsryc/show_lsp_signature_help_window_above_cursor/
-- https://github.com/askfiy/nvim/commit/395fb842ea3441fd69d6cb1e96c6f78d9bc19edb
--
local function lsp_signature_help(_, result, ctx, config)
  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/handlers.lua
  config = config or {}
  config.silent = config.silent ~= nil and config.silent or true
  local bufnr, winnr = vim.lsp.handlers.signature_help(_, result, ctx, config)
  -- if bufnr and winnr then
  --   -- Put the signature floating window above the cursor
  --   local current_cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  --   if current_cursor_line > 3 then
  --     vim.api.nvim_win_set_config(winnr, {
  --       anchor = 'SW',
  --       relative = 'cursor',
  --       row = 0,
  --       col = -1,
  --     })
  --   end
  --   vim.api.nvim_buf_set_name(bufnr, config.name)
  -- end
  return bufnr, winnr
end

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(lsp_signature_help, {
  name = 'lsp-signature-help',
  -- border = 'none',
  -- close_events = { 'CursorMoved', 'BufHidden', 'InsertEnter' },
  -- close_events = { 'CursorMoved', 'BufHidden', 'InsertChange' },
  -- close_events = { 'CursorMovedI', 'BufHidden', 'InsertLeave', 'TextChangedI' },
  -- close_events = { 'BufHidden', 'InsertLeave' },
  focusable = false, -- Still focusable with: nvim_set_current_win({window})
  -- noautocmd = true,
  -- zindex = 1001, -- Above cmp
})

vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  vim.notify(result.message, lvl, {
    title = 'LSP | ' .. client.name,
    -- timeout = 3000,
    -- keep = function()
    --   return lvl == 'ERROR' or lvl == 'WARN'
    -- end,
  })
end

-- documentFormatting
-- hover
-- documentSymbol
-- codeAction
-- completion

return {
  -- lspconfig
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
      { 'folke/neodev.nvim', config = true }, -- Replaces hrsh7th/cmp-nvim-lua
      'mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp', -- 'hrsh7th/nvim-cmp',
      -- 'lsp_signature.nvim', -- Alternative hrsh7th/cmp-nvim-lsp-signature-help
      'b0o/schemastore.nvim', -- jsonls
      'null-ls.nvim',
    },
    event = 'BufReadPre',
    -- Return true to skip setup with lspconfig
    setup_server = function(server, opts)
      if server == 'docker_compose_language_service' then
        -- FIXME
        return true
      end
      if server == 'lua_ls' then
        require('lspconfig').sumneko_lua.setup(opts)
        return true
      end
      return vim.tbl_contains({ 'rust_analyzer', 'tsserver' }, server)
    end,
    config = function(plugin)
      local lspconfig = require('lspconfig')
      local configs = require('lspconfig.configs')

      -- vim.api.nvim_set_hl(0, 'LspCodeLens', { default = true, link = 'Comment' })

      for name, config in pairs(LoadDir('plugins/lsp/available')) do
        configs[name] = config
      end

      -- clangd
      -- spectral
      --   https://github.com/williamboman/mason.nvim/issues/863
      --   https://github.com/yarnpkg/yarn/issues/6152
      -- pyright
      -- vuels

      local servers = LoadDir('plugins/lsp/servers')

      -- setup formatting and keymaps
      local attached = {}
      require('lazyvim.util').on_attach(function(client, bufnr)
        if not attached[bufnr] then
          -- vim.notify('Attached to ' .. client.name, vim.log.levels.INFO, { title = 'LSP' })
          -- vim.inspect(client.server_capabilities)
          require('plugins.lsp.keymaps').once_on_attach(client, bufnr)
          attached[bufnr] = true
        end

        -- Enable completion triggered by <c-x><c-o>
        -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Show signature help automatically in hover window (normal mode)
        if client.server_capabilities.signatureHelpProvider then
          -- print('Signature help enabled with ' .. client.name)
          -- 'TextChangedI', 'TextChangedP'
          vim.api.nvim_create_autocmd({ 'CursorHoldI' }, {
            buffer = bufnr,
            group = vim.api.nvim_create_augroup('LspSignatureHelp', { clear = true }), -- lsp_group
            callback = function()
              if not settings.signature_help then
                return
              end
              for _, winnr in pairs(vim.api.nvim_tabpage_list_wins(0)) do
                local config = vim.api.nvim_win_get_config(winnr)
                if config.zindex then
                  local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(winnr))
                  local kind = 'lsp-signature-help'
                  if name ~= '' and name:sub(-#kind) == kind then
                    -- Skip if a another signature window is already open
                    -- to avoid focus on second call
                    return
                  end
                end
              end
              vim.lsp.buf.signature_help()
            end,
          })
        end

        require('plugins.lsp.format').on_attach(client, bufnr)
        require('plugins.lsp.keymaps').on_attach(client, bufnr)
      end)

      -- client.server_capabilities.diagnosticProvider

      require('lspconfig.ui.windows').default_options.border = settings.border

      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lsp_mason = require('mason-lspconfig')
      lsp_mason.setup({
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      })
      lsp_mason.setup_handlers({
        function(server)
          local opts = servers[server] or {}
          -- opts.autostart = false
          opts.capabilities = vim.tbl_deep_extend('force', opts.capabilities or {}, capabilities)
          if not plugin.setup_server(server, opts) then
            -- vim.notify('Setup ' .. server, vim.log.levels.INFO, { title = 'LSP' })
            lspconfig[server].setup(opts)
          end
        end,
      })

      -- https://github.com/RishabhRD/nvim-lsputils#setup

      local lsp_group = vim.api.nvim_create_augroup('LspGroup', { clear = true })

      -- Show line diagnostics automatically in hover window

      -- FIXME: use native hover feature?
      -- or do not overwrite last notification message
      -- and check if another floating window is open
      -- and allow click or copy without focus?

      local function on_hover()
        if not settings.diagnostic_hover then
          return
        end
        -- Check if insert mode is active
        if vim.api.nvim_get_mode().mode == 'i' then
          return
        end
        -- Check if completion menu is open
        if vim.fn.pumvisible() == 1 then
          return
        end
        -- Check window height
        if vim.api.nvim_win_get_height(0) < 3 then
          return
        end
        -- Check if diagnostic changed for the current line
        -- local diagnostics = args.data and args.data.diagnostics or {}
        -- if #diagnostics == 0 then
        -- end

        -- print(args.event)
        -- if args.event ~= 'DiagnosticChanged' then
        -- end
        -- https://www.reddit.com/r/neovim/comments/tvy18v/check_if_floating_window_exists/
        for _, winnr in pairs(vim.api.nvim_tabpage_list_wins(0)) do
          local config = vim.api.nvim_win_get_config(winnr)
          if config.zindex then
            local bufnr = vim.api.nvim_win_get_buf(winnr)
            local name = vim.api.nvim_buf_get_name(bufnr)
            local kind = 'lsp-hover'
            if name ~= '' and name:sub(-#kind) == kind then
              -- Skip if another hover window is already open
              return
            end
          end
        end
        -- FIXME: hides last vim message
        vim.diagnostic.open_float(nil, { focusable = false, scope = 'line' })
      end

      -- You will likely want to reduce updatetime which affects CursorHold
      -- note: this setting is global and should be set only once
      vim.api.nvim_create_autocmd({ 'CursorHold', 'DiagnosticChanged' }, {
        group = lsp_group,
        callback = on_hover,
      })

      local setup_filetypes = {
        markdown = {
          servers = {
            marksman = {},
          },
        },
        php = {
          install = {
            phan = false, -- 'composer require phan/phan',
            psalm = false, -- 'composer require vimeo/psalm',
          },
          servers = {
            -- intelephense = {},
            -- phan = {},
            -- phpactor = {}, -- $(php -r "echo PHP_VERSION;" | cut -d. -f1) -ge 8
            -- psalm = {},
          },
        },
      }
      for ft, config in pairs(setup_filetypes) do
        local manual_install = {}
        local auto_install = {}
        for server, opts in pairs(config.servers) do
          if config.install and config.install[server] then
            manual_install[server] = config.install[server]
          elseif not config.install or config.install[server] == nil then
            table.insert(auto_install, server)
          end
          opts.capabilities = vim.tbl_deep_extend('force', opts.capabilities or {}, capabilities)
          servers[server] = opts
        end
        if #manual_install then
          execute_install(manual_install)
        end
        vim.api.nvim_create_autocmd('FileType', {
          -- desc = 'Install and register LSP servers',
          pattern = ft,
          group = lsp_group,
          callback = function()
            if config.install then
              for server, opts in pairs(config.servers) do
                vim.notify('Setup ' .. server, vim.log.levels.INFO, { title = 'LSP' })
                lspconfig[server].setup(opts)
              end
            else
              lsp_mason.setup({
                ensure_installed = auto_install,
                automatic_installation = true,
              })
            end
          end,
        })
      end
    end,
  },

  {
    'adoyle-h/lsp-toggle.nvim',
    dependencies = {
      'nvim-lspconfig',
      'telescope.nvim',
      'null-ls.nvim',
    },
    cmd = { 'ToggleLSP', 'ToggleNullLSP' },
    opts = {
      create_cmds = true,
      telescope = true,
    },
  },

  -- {
  --   'ray-x/lsp_signature.nvim',
  --   config = function()
  --     -- Setup custom LSP signature
  --     local lsp_signature = require('lsp_signature')
  --     -- https://github.com/ray-x/lsp_signature.nvim#full-configuration-with-default-values
  --     local signature_setup = {
  --       bind = true, -- This is mandatory, otherwise border config won't get registered.
  --       floating_window = true,
  --       hint_enable = false,
  --       hint_prefix = '',
  --       handler_opts = { border = settings.border },
  --       -- transparency = 20,
  --     }
  --     lsp_signature.setup(signature_setup)
  --   end,
  -- },

  -- Commands: nanotee/nvim-lsp-basics

  -- Linters (c.f. ../tools.lua)
  -- {
  --   'brymer-meneses/grammar-guard.nvim', -- Requires ltex-ls
  --   dependencies = {
  --     'mason.nvim',
  --     'nvim-lspconfig',
  --   },
  --   config = function()
  --     -- Hook to nvim-lspconfig
  --     require('grammar-guard').init()
  --     -- Setup LSP config
  --     require('lspconfig').grammar_guard.setup({
  --       settings = {
  --         ltex = {
  --           enabled = { 'latex', 'tex', 'bib', 'markdown' },
  --           language = 'en',
  --           diagnosticSeverity = 'information',
  --           setenceCacheSize = 2000,
  --           additionalRules = {
  --             enablePickyRules = true,
  --             motherTongue = 'fr',
  --           },
  --           -- trace = { server = 'verbose' },
  --           dictionary = {},
  --           disabledRules = {},
  --           hiddenFalsePositives = {},
  --         },
  --       },
  --     })
  --   end,
  -- },

  -- Formatters
  {
    'lukas-reineke/lsp-format.nvim', -- Wrapper around native LSP formatting
    -- enabled = false,
    opts = {
      exclude = require('plugins.lsp.format').list_excluded(),
      -- exclude = { 'lua_ls', 'tsserver', 'yamlls' },
      -- order = {},
      -- FIX: format_options = vim.tbl_deep_extend('force', {}, M.format_options or {}, format_options)
      sync = true, -- Synchronous formatting
      -- https://github.com/lukas-reineke/lsp-format.nvim#how-do-i-use-format-options
      -- lua = { tab_width = 2 },
    },
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    -- enabled = false,
    -- event = 'BufReadPre',
    dependencies = {
      'mason.nvim',
      -- 'jay-babu/mason-null-ls.nvim',
      'jose-elias-alvarez/typescript.nvim',
      -- {
      --   -- https://github.com/ThePrimeagen/refactoring.nvim#configuration-for-refactoring-operations
      --   'ThePrimeagen/refactoring.nvim',
      --   dependencies = {
      --     'plenary.nvim',
      --     'nvim-treesitter',
      --   },
      --   opts = {
      --     -- prompt_func_return_type = {},
      --     -- prompt_func_param_type = {},
      --   },
      -- },
    },
    config = function()
      mason_install({
        codespell = {},
        -- cspell = {},
        -- misspell = {},
      })

      local null_ls = require('null-ls')

      local map_severity = function(map)
        return function(diagnostic)
          if map[diagnostic.severity] ~= nil then
            diagnostic.severity = map[diagnostic.severity]
          end
        end
      end

      -- local cspell = {
      --   diagnostics_postprocess = map_severity({ [vim.diagnostic.severity.ERROR] = vim.diagnostic.severity.INFO }),
      --   extra_args = {
      --     -- https://github.com/jose-elias-alvarez/null-ls.nvim/pull/1329/files
      --     -- FIX: ln -s ~/.config/cspell/cspell.json .cspell.json
      --     -- '--config', '~/.config/cspell/cspell.json',
      --     -- '--locale', 'en,fr'
      --   },
      -- }

      local sources = {
        -- null_ls.builtins.code_actions.cspell.with(cspell),
        null_ls.builtins.code_actions.gitsigns,
        -- null_ls.builtins.code_actions.refactoring, -- go, javascript, lua, python, typescript

        -- null_ls.builtins.completion.spell,
        -- null_ls.builtins.completion.tags,

        -- null_ls.builtins.diagnostics.ansiblelint,
        -- null_ls.builtins.diagnostics.buf,
        -- null_ls.builtins.diagnostics.checkmake,
        null_ls.builtins.diagnostics.codespell.with({
          diagnostics_postprocess = map_severity({
            [vim.diagnostic.severity.WARN] = vim.diagnostic.severity.INFO,
          }),
        }),
        -- null_ls.builtins.diagnostics.cspell.with(cspell),
        -- null_ls.builtins.diagnostics.editorconfig_checker,
        -- null_ls.builtins.diagnostics.flake8,
        -- null_ls.builtins.diagnostics.misspell,
        -- null_ls.builtins.diagnostics.protolint,
        -- null_ls.builtins.diagnostics.psalm,
        -- null_ls.builtins.diagnostics.puglint,
        -- null_ls.builtins.diagnostics.stylelint,
        -- null_ls.builtins.diagnostics.stylint,
        -- null_ls.builtins.diagnostics.textlint,
        -- null_ls.builtins.diagnostics.todo_comments, -- TODO Comments
        -- null_ls.builtins.diagnostics.trail_space,

        -- null_ls.builtins.formatting.bean_format,

        -- null_ls.builtins.hover.dictionary,
      }

      null_ls.setup({
        border = settings.border,
        -- cmd = { 'nvim' },
        -- debounce = 250,
        -- debug = false,
        -- default_timeout = 5000,
        -- diagnostic_config = nil,
        -- diagnostics_format = '[#{c}] #{m} (#{s})',
        -- fallback_severity = vim.diagnostic.severity.ERROR,
        log_level = 'info', -- warn',
        -- notify_format = '[null-ls] %s',
        -- https://github.com/lukas-reineke/lsp-format.nvim/issues/70
        -- on_attach = function(client, _)
        --   require('lsp-format').on_attach(client)
        -- end,
        -- on_exit = nil,
        -- on_init = nil,
        -- root_dir = require('null-ls.utils').root_pattern('.null-ls-root', 'Makefile', '.git'),
        -- should_attach = nil,
        sources = sources,
        -- temp_dir = nil,
        -- update_in_insert = false,
      })

      local prettier_filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        -- 'vue',
        -- 'css',
        -- 'scss',
        'less',
        -- 'html', -- htmlls
        'json',
        'jsonc',
        -- 'yaml',
        'markdown',
        'markdown.mdx',
        'graphql',
        'handlebars',
      }
      local register_filetypes = {
        dockerfile = {
          -- https://github.com/hadolint/hadolint/issues/897
          tools = { hadolint = { version = 'v2.12.1-beta' } },
          sources = { null_ls.builtins.diagnostics.hadolint },
        },
        gitcommit = {
          tools = {
            commitlint = {},
            gitlint = {},
          },
          sources = {
            -- https://github.com/jose-elias-alvarez/null-ls.nvim/pull/1107
            null_ls.builtins.diagnostics.commitlint,
            null_ls.builtins.diagnostics.gitlint,
          },
        },
        -- gitrebase = { sources = { null_ls.builtins.code_actions.gitrebase } },
        -- [{ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' }] = {
        --   tools = {
        --     eslint_d = {},
        --   },
        --   sources = {
        --     null_ls.builtins.code_actions.eslint_d,
        --     null_ls.builtins.diagnostics.eslint_d,
        --     null_ls.builtins.formatting.eslint_d,
        --   },
        -- },
        -- xml = { -- [{ 'html', 'xml' }]
        --   install = {
        --     -- tidy = 'brew install tidy-html5',
        --   },
        --   sources = {
        --     null_ls.builtins.diagnostics.tidy,
        --     null_ls.builtins.formatting.tidy,
        --   },
        -- },
        json = {
          tools = { jsonlint = {} },
          sources = { null_ls.builtins.diagnostics.jsonlint },
        },
        -- [{ 'json', 'yaml' }] = {
        --   sources = { null_ls.builtins.diagnostics.vacuum },
        -- },
        lua = {
          tools = {
            luacheck = {},
            stylua = {},
          },
          sources = {
            -- null_ls.builtins.completion.luasnip,
            null_ls.builtins.diagnostics.luacheck.with({
              extra_args = { '--globals', 'vim' },
            }),
            null_ls.builtins.formatting.stylua.with({
              extra_args = settings.format
                  and settings.format.stylua
                  and vim.deepcopy(settings.format.stylua.args)
                or {},
            }),
          },
        },
        -- [{ 'lua', 'luau' }] = {
        --   tools = {
        --     selene = {},
        --   },
        --   sources = {
        --     null_ls.builtins.diagnostics.selene, -- https://github.com/Kampfkarren/selene/issues/284
        --   },
        -- },
        markdown = {
          tools = {
            markdownlint = {},
            -- ['write-good'] = {},
          },
          sources = {
            null_ls.builtins.diagnostics.markdownlint,
            -- null_ls.builtins.formatting.markdownlint,
            -- null_ls.builtins.diagnostics.write_good.with({
            --   -- diagnostics_postprocess = function(diagnostic)
            --   --   diagnostic.severity = diagnostic.message:find('really') and vim.diagnostic.severity['ERROR']
            --   --       or vim.diagnostic.severity['WARN']
            --   -- end,
            --   extra_filetypes = { 'txt' },
            -- }),
          },
        },
        -- [{ 'markdown', 'tex' }] = {
        --   tools = { proselint = {} },
        --   sources = {
        --     null_ls.builtins.code_actions.proselint,
        --     null_ls.builtins.diagnostics.proselint,
        --   },
        -- },
        [{ 'markdown', 'txt' }] = {
          tools = {
            alex = {},
          },
          sources = {
            null_ls.builtins.diagnostics.alex.with({
              extra_filetypes = { 'txt' },
            }),
          },
        },
        [{ 'markdown', 'tex', 'asciidoc' }] = {
          tools = { vale = {} },
          sources = {
            -- ~/.vale.ini
            null_ls.builtins.diagnostics.vale.with({
              -- diagnostics_postprocess = function(diagnostic)
              --   diagnostic.severity = diagnostic.message:find('really')
              --     and vim.diagnostic.severity['HINT']
              --     or diagnostic.severity
              -- end,
              -- extra_filetypes = { 'html', 'typescript', 'xml' },
            }),
          },
        },
        nginx = {
          install = {
            nginxbeautifier = 'npm install --global nginxbeautifier',
          },
          sources = {
            null_ls.builtins.formatting.nginx_beautifier.with({
              extra_args = { '--space', 2 },
            }),
          },
        },
        php = {
          tools = {
            -- ['php-cs-fixer'] = {},
            -- phpcbf = {},
            -- phpcs = {},
            -- phpmd = {},
            -- phpstan = {},
            -- pint = {}, -- PHP 8
          },
          sources = {
            null_ls.builtins.diagnostics.php,
            null_ls.builtins.diagnostics.phpcs,
            -- null_ls.builtins.diagnostics.phpmd,
            null_ls.builtins.diagnostics.phpstan,
            -- null_ls.builtins.diagnostics.psalm,
            null_ls.builtins.formatting.phpcbf,
            -- null_ls.builtins.formatting.phpcsfixer,
            -- null_ls.builtins.formatting.pint.with(),
          },
        },
        sh = {
          tools = {
            shfmt = {},
            shellcheck = {}, -- Used by bashls
            shellharden = {},
          },
          sources = {
            -- null_ls.builtins.code_actions.shellcheck,
            -- null_ls.builtins.diagnostics.dotenv_linter,
            -- null_ls.builtins.diagnostics.shellcheck,
            -- null_ls.builtins.diagnostics.zsh,
            null_ls.builtins.formatting.shfmt,
            -- null_ls.builtins.formatting.shellharden,
          },
        },
        [{ 'sql', 'pgsql' }] = {
          tools = {
            -- ['sql-formatter'] = {},
            sqlfluff = {},
          },
          sources = {
            null_ls.builtins.diagnostics.sqlfluff.with({
              -- '--processes', '-1',
              extra_args = { '--dialect', 'postgres' },
              extra_filetypes = { 'pgsql' },
            }),
            -- null_ls.builtins.formatting.pg_format,
            null_ls.builtins.formatting.sqlfluff.with({
              extra_args = { '--dialect', 'postgres' },
              extra_filetypes = { 'pgsql' },
            }),
            -- null_ls.builtins.formatting.sql_formatter.with({
            --   extra_args = { '--language', 'postgresql' },
            --   extra_filetypes = { 'pgsql' },
            -- }),
          },
        },
        toml = {
          tools = { taplo = {} },
          sources = { null_ls.builtins.formatting.taplo },
        },
        -- vim = {
        --   tools = { vint = {} }, -- Segmentation fault: 11
        --   sources = { null_ls.builtins.diagnostics.vint },
        -- },
        yaml = {
          tools = {
            -- yamlfmt = {},
            yamllint = {},
          },
          sources = {
            -- null_ls.builtins.formatting.yamlfmt.with({
            --   -- extra_args = { '--conf', '~/.config/yamlfmt/.yamlfmt' },
            -- }),
            null_ls.builtins.diagnostics.yamllint.with({
              extra_args = { '--config-data', '{ rules: { comments: { min-spaces-from-content: 1 } } }' },
            }),
          },
        },
        -- [{ 'typescript', 'typescriptreact', 'ruby', 'python', 'java', 'go' }] = {
        --   tools = { semgrep = {} },
        --   sources = {
        --     null_ls.builtins.diagnostics.semgrep.with({
        --       extra_args = {
        --         '--config=auto',
        --         -- '--metrics=off',
        --         -- '--timeout=0',
        --         -- '--timeout-threshold=0',
        --       },
        --       -- method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        --       timeout = 30000,
        --     }),
        --   },
        -- },
        -- [{
        --   'dockerfile',
        --   -- 'javascript',
        --   -- 'javascriptreact',
        --   -- 'typescript',
        --   -- 'typescriptreact',
        --   -- 'json',
        --   -- 'markdown',
        --   'toml',
        --   -- 'rust',
        --   -- 'roslyn',
        -- }] = {
        --   tools = {
        --     dprint = {},
        --   },
        --   sources = {
        --     null_ls.builtins.formatting.dprint,
        --   },
        -- },
        [prettier_filetypes] = {
          tools = {
            prettier = {},
          },
          sources = {
            null_ls.builtins.formatting.prettier.with({
              -- disabled_filetypes = {},
              -- extra_filetypes = {},
              filetypes = prettier_filetypes,
            }),
          },
        },
      }

      -- local group = vim.api.nvim_create_augroup('NullLsFt', { clear = true })
      for ft, config in pairs(register_filetypes) do
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/596
        null_ls_register(config)
        -- vim.api.nvim_create_autocmd('FileType', {
        --   -- desc = 'Install and register tools',
        --   pattern = ft,
        --   group = group,
        --   callback = function()
        --     null_ls_register(config)
        --   end,
        -- })
      end
    end,
  },

  -- Languages
  {
    'ray-x/go.nvim',
    dependencies = {
      'nvim-lspconfig',
      'nvim-treesitter',
      -- 'ray-x/guihua.lua',
    },
    ft = { 'go' },
    opts = {
      lsp_cfg = false,
      -- trouble = true,
    },
    config = function()
      -- go = {
      --   tools = {},
      --   sources = {
      --     -- null_ls.builtins.code_actions.gomodifytags,
      --   },
      -- },
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    dependencies = 'nvim-lspconfig',
    ft = { 'rust' },
    config = function()
      local opts = require('plugins.lsp.servers.rust_analyzer')
      require('rust-tools').setup({
        -- tools = { on_initialized = vim.pretty_print },
        server = opts,
      })
      local null_ls = require('null-ls')
      null_ls_register({ tools = { rustfmt = {} }, sources = { null_ls.builtins.formatting.rustfmt } })
    end,
  },
  {
    'jose-elias-alvarez/typescript.nvim',
    ft = { 'typescript', 'typescriptreact' },
    config = function()
      local opts = require('plugins.lsp.servers.tsserver')
      require('typescript').setup({
        disable_commands = false, -- prevent the plugin from creating Vim commands
        debug = true, -- enable debug logging for commands
        go_to_source_definition = {
          fallback = true, -- fall back to standard LSP definition on failure
        },
        server = opts,
      })
      local sources = {
        -- https://github.com/jose-elias-alvarez/typescript.nvim/issues/21#is5725105
        require('typescript.extensions.null-ls.code-actions'),
        -- null_ls.builtins.diagnostics.tsc,
      }
      require('null-ls').register(sources)
    end,
  },
  {
    'joeveiga/ng.nvim',
    ft = { 'html', 'typescript' },
    cond = function()
      return vim.fn.filereadable('angular.json') == 1
    end,
    -- stylua: ignore
    keys = {
      { '<leader>at', function() require('ng').goto_template_for_component() end, desc = 'Go to template for component' },
      { '<leader>ac', function() require('ng').goto_component_with_template_file() end, desc = 'Go to component with template file' },
      { '<leader>aT', function() require('ng').get_template_tcb() end, desc = 'Get template TCB' },
    },
  },

  require('plugins.lsp.ui'),
}
