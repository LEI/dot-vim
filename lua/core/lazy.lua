local config_dir = "core"
local settings = require("core.settings")

-- https://github.com/LazyVim/starter/blob/main/lua/config/lazy.lua
local lazypath = vim.env.LAZY or vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable',
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Required to lazy load with keys
vim.g.mapleader = " "

require("lazy").setup({
  spec = {
    -- import LazyVim plugins
    -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  checker = {
    -- automatically check for plugin updates
    enabled = true,
    concurrency = nil, ---@type number? set to 1 to check for updates very slowly
    notify = false, -- get a notification when new updates are found
    frequency = 3600 * 24, -- check for updates every day
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = false,
    notify = true, -- get a notification when changes are found
  },
  defaults = {
    lazy = true, -- every plugin is lazy-loaded by default
    version = "*", -- try installing the latest stable version for plugins that support semver
  },
  dev = {
    path = "~/src/github.com/LEI",
  },
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "tokyonight" },
  },
  performance = {
    -- reset = false,
    reset_packpath = false,
    rtp = {
      reset = false,
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = settings.border,
    icons = settings.icons.lazy,
    size = settings.float.size,
  },
})

-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/config.lua
local function load(name)
  local Util = require("lazy.core.util")

  -- FIXME: always load lazyvim, then user file
  -- ipairs({ 'lazyvim.config.' .. name, config_dir .. '.' .. name })

  for _, mod in ipairs({ config_dir .. "." .. name }) do
    Util.try(function()
      require(mod)
    end, {
      msg = "Failed loading " .. mod,
      on_error = function(msg)
        local modpath = require("lazy.core.cache").find(mod)
        if modpath then
          Util.error(msg)
        end
      end,
    })
  end
end

-- load options here, before lazy init while sourcing plugin modules
-- this is needed to make sure options will be correctly applied
-- after installing missing plugins
load("options")

-- autocmds and keymaps can wait to load
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    load("autocmds")
    load("keymaps")
  end,
})
