-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/util.lua

function P(...)
  print(vim.inspect(...))
end

function PP(...)
  vim.pretty_print(...)
end

function Dir(path)
  local list = {}
  local cmd = string.format('find "$VIMHOME/lua/%s" -mindepth 1 -maxdepth 1', path)
  local lines = io.popen(cmd):lines()
  for file in lines do
    local name = file:match('([^/]+)%.lua$')
    -- local filename = line:match('^.+/(.+)$')
    -- local name = filename:match('(.+)%..+$')
    table.insert(list, name)
  end
  return list
end

function LoadDir(path)
  local map = {}
  for _, name in ipairs(Dir(path)) do
    local require_path = string.format('%s.%s', path:gsub('/', '.'), name)
    local ok, config = pcall(require, require_path)
    if not ok then
      config = {}
    end
    if config.enabled ~= false then
      map[name] = config
    end
  end
  return map
end

return {

  -- measure startuptime
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Session management
  {
    'folke/persistence.nvim',
    enabled = false,
    event = 'BufReadPre',
    opts = { options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help' } },
    -- stylua: ignore
    keys = {
      -- { '<leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
      -- { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restore Last Session' },
      -- { '<leader>qd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- Library used by other plugins
  'nvim-lua/plenary.nvim',
}
