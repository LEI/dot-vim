local settings = require('core.settings')

return {
  -- LSP, DAP, linters and formatters installer
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    keys = {
      { '<Leader>M', vim.cmd.Mason, desc = 'Mason' },
      { '<Leader>cm', '<cmd>Mason<cr>', desc = 'Mason' },
    },
    ensure_installed = {},
    init = function()
      vim.cmd('highlight default link MasonHighlight Special')
    end,
    config = function(plugin)
      require('mason').setup({
        -- install_root_dir = path.concat { vim.fn.stdpath "data", "mason" },
        -- PATH = 'prepend', -- prepend, append, skip
        -- pip = { upgrade_pip = false },
        -- log_level = vim.log.levels.INFO,
        -- max_concurrent_installers = 4,
        providers = {
          'mason.providers.client', -- uses only client-side tooling to resolve metadata
          'mason.providers.registry-api', -- uses the https://api.mason-registry.dev API
        },
        ui = {
          check_outdated_packages_on_open = false,
          border = settings.border,
          width = settings.float.size.width,
          height = settings.float.size.height,
          icons = settings.icons.mason,
        },
      })
      local mr = require('mason-registry')
      for _, tool in ipairs(plugin.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  -- Linters (replaced by null-ls)
  {
    'mfussenegger/nvim-lint',
    enabled = false,
    -- TODO: use InsertLeave or TextChanged only for linters supporting stdin
    -- https://github.com/mfussenegger/nvim-lint/issues/22
    -- https://github.com/mfussenegger/nvim-lint/issues/171#issuecomment-1027012701
    dependencies = {
      'mason.nvim',
    },
    event = { 'BufRead', 'BufWritePost', 'TextChanged' },
    ensure_installed = {
      'codespell', -- cspell?
      -- 'eslint_d', -- Replaced by eslint-lsp in ./lsp/init.lua
      -- 'flake8',
      'jsonlint',
      'luacheck', -- Requires luarocks
      'markdownlint',
      -- 'phpcs',
      'proselint',
      'shellcheck',
      'sqlfluff',
      'vale', -- AsciiDoc, Org, reStructuredText
      'yamllint',
    },
    linters_all_ft = { 'codespell' },
    linters_by_ft = {
      -- ansible = { 'ansible-lint' },
      html = { 'tidy', 'vale' },
      javascript = {}, -- 'eslint_d'
      json = { 'jsonlint' },
      -- jsonc = { 'jsonlint' },
      lua = { 'luacheck' },
      markdown = { 'markdownlint', 'vale' },
      php = { 'phpcs' },
      -- python = { 'flake8' },
      sh = { 'shellcheck' },
      sql = { 'sqlfluff' },
      typescript = {}, -- 'eslint_d'
      vim = { 'vint' },
      xml = { 'tidy', 'vale' },
      yaml = { 'yamllint' },
      -- ['yaml.docker-compose'] = { 'yamllint' },
    },
    config = function(plugin)
      local mr = require('mason-registry')
      for _, tool in ipairs(plugin.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end

      local lint = require('lint')

      -- Configure luacheck
      if lint.linters.luacheck then
        if settings.lint and settings.lint.luacheck then
          for _, a in ipairs(settings.lint.luacheck.args or {}) do
            table.insert(lint.linters.luacheck.args, a)
          end
        end
      end

      -- Set linters by filetype
      lint.linters_by_ft = plugin.linters_by_ft
      for _, linter in ipairs(plugin.linters_all_ft) do
        -- local p = mr.get_package(tool)
        -- if not p:is_installed() then
        --   p:install()
        -- end
        for _, l in pairs(lint.linters_by_ft) do
          if not vim.tbl_contains(l, linter) then
            table.insert(l, linter)
          end
        end
      end
      -- Run when configured since it's lazy-loaded
      -- lint.try_lint()
    end,
    init = function(plugin)
      local lint = require('lint')
      -- Setup auto command
      local lint_group = vim.api.nvim_create_augroup('LintGroup', { clear = true })
      -- Try to lint on read and write
      vim.api.nvim_create_autocmd(plugin.event, {
        callback = function()
          lint.try_lint()
        end,
        group = lint_group,
      })
    end,
  },

  -- Formatters (replaced by null-ls)
  {
    'mhartington/formatter.nvim',
    enabled = false,
    dependencies = {
      'mason.nvim',
    },
    event = { 'BufWritePost' },
    cmd = 'Format',
    keys = {
      { '<leader>f', ':FormatLock<CR>', desc = 'Format file' },
      { '<leader>F', ':FormatWriteLock<CR>', desc = 'Format and write file' },
    },
    ensure_installed = {
      -- TODO: Fallback to native LSP formatter
      -- https://github.com/mhartington/formatter.nvim/issues/192
      'eslint_d',
      'prettier',
      'shfmt',
      -- 'stylua',
      -- 'yamlfmt',
    },
    formatters = {
      css = function()
        return require('formatter.filetypes.css').prettier -- eslint_d, stylefmt...
      end,
      -- go = function()
      --   return require('formatter.filetypes.go').goimports
      -- end,
      html = function()
        return require('formatter.filetypes.html').tidy -- prettier, htmlbeautify
      end,
      -- javascript = function()
      --   return require('formatter.filetypes.javascript').eslint_d
      -- end,
      -- javascriptreact = function()
      --   return require('formatter.filetypes.javascriptreact').eslint_d
      -- end,
      -- [{ 'json', 'jsonc' }]
      json = function()
        return require('formatter.filetypes.json').prettier -- jq, fixjson...
      end,
      lua = {
        function()
          -- if util.get_current_buffer_file_name() == 'special.lua' then
          --   return nil
          -- end

          -- local stylua_args = settings.format and settings.format.stylua and vim.deepcopy(settings.format.stylua.args) or {}
          -- local stylua_defaults = require('formatter.filetypes.lua').stylua()
          -- for _, arg in ipairs(stylua_defaults.args) do
          --   table.insert(stylua_args, arg)
          -- end
          -- stylua_defaults.args = stylua_args
          -- return stylua_defaults

          -- FIXME: Use built-in LSP formatter
          vim.lsp.buf.format({ async = false })
        end,
      },
      markdown = {
        function()
          -- https://github.com/mhartington/formatter.nvim/blob/master/lua/formatter/defaults/prettier.lua
          local prettier_args = settings.format
              and settings.format.prettier
              and vim.deepcopy(settings.format.prettier.args)
            or {}
          local prettier_defaults = require('formatter.filetypes.markdown').prettier()
          for _, arg in ipairs(prettier_defaults.args) do
            table.insert(prettier_args, arg)
          end
          prettier_defaults.args = prettier_args
          return prettier_defaults
        end,
      },
      -- php = function()
      --   return {
      --     require('formatter.filetypes.php').phpcbf,
      --     require('formatter.filetypes.php').php_cs_fixer,
      --   }
      -- end,
      -- rustfmt = function()
      --   return require('formatter.filetypes.rustfmt').rustfmt
      -- end,
      sh = function()
        return require('formatter.filetypes.sh').shfmt
      end,
      -- sql = function()
      --   return require('formatter.filetypes.sql').pgformat -- requires pgformatter
      -- end,
      -- typescript = function()
      --   return require('formatter.filetypes.typescript').eslint_d
      -- end,
      -- typescriptreact = function()
      --   return require('formatter.filetypes.typescriptreact').eslint_d
      -- end,

      -- YAML filetypes
      -- Configuration: ~/.config/yamlfmt/.yamlfmt
      -- formatter:
      --   max_line_length: -1
      --   retain_line_breaks: true
      -- TODO: array indent
      -- [{ 'yaml', 'yaml.docker-compose' }] = function()
      --   return require('formatter.filetypes.yaml').yamlfmt
      -- end,

      -- Use the special "*" filetype for defining formatters on any filetype
      -- ['*'] = function()
      --   -- local capabilities = vim.lsp.buf_get_clients(0)[1].resolved_capabilities
      --   -- print(vim.inspect(capabilities))
      --   return require('formatter.filetypes.any').remove_trailing_whitespace
      -- end,
    },
    config = function(plugin)
      local mr = require('mason-registry')
      for _, tool in ipairs(plugin.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end

      -- Utilities for creating configurations
      -- local util = require('formatter.util')

      local filetype = {}
      for ft, fmt in pairs(plugin.formatters) do
        fmt = type(fmt) == 'function' and fmt() or fmt
        if type(ft) ~= 'table' then
          filetype[ft] = fmt
        else
          for _, key in ipairs(ft) do
            filetype[key] = fmt
          end
        end
      end
      -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
      require('formatter').setup({
        logging = true,
        -- Set the log level
        log_level = settings.format.log_level,
        -- All formatter configurations are opt-in
        filetype = filetype,
      })
    end,
    init = function(plugin)
      local format_group = vim.api.nvim_create_augroup('FormatGroup', { clear = true })
      vim.api.nvim_create_autocmd(plugin.event, {
        callback = function()
          -- Do not format if the file is empty
          -- https://github.com/mhartington/formatter.nvim/issues/147
          local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
          if #content == 1 and content[1] == '' then
            vim.notify('File is empty', vim.log.levels.INFO, {
              title = 'Formatter',
            })
            return
          end
          if vim.g.format_on_save ~= 0 then
            vim.cmd('FormatWriteLock')
          end
        end,
        group = format_group,
      })
      -- autocmd User FormatterPre lua print "This will print before formatting"
      -- autocmd User FormatterPost lua vim.diagnostic.hide()
    end,
  },
}
