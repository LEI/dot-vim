-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/colorscheme.lua

local sidebars = {
  'Outline',
  'dapui_*',
  'dbui', -- 'dbout',
  'help',
  'qf',
  -- 'tsplayground',
  'vim',
}

return {
  {
    'folke/tokyonight.nvim',
    -- enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      local tokyonight = require('tokyonight')
      vim.o.background = vim.fn['time#IsDay']() and 'light' or 'dark'
      tokyonight.setup({
        -- style = 'moon', -- storm, moon, nigh, day
        -- styles = {
        --   -- Style to be applied to different syntax groups
        --   -- Value is any valid attr-list value for `:help nvim_set_hl`
        --   comments = { italic = true },
        --   keywords = { italic = true },
        --   functions = {},
        --   variables = {},
        --   -- Background styles. Can be "dark", "transparent" or "normal"
        --   sidebars = 'dark', -- style for sidebars, see below
        --   floats = 'dark', -- style for floating windows
        -- },
        sidebars = sidebars,
        -- day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
        dim_inactive = false,
        on_highlights = function(highlights, colors)
          highlights.DiagnosticStatusError = { bg = highlights.DiagnosticError.fg, fg = is_day and colors.bg or nil }
          -- highlights.DiagnosticStatusWarn = { bg = highlights.DiagnosticWarn.fg, fg = colors.bg }
          -- highlights.DiagnosticStatusInfo = highlights.DiagnosticInfo
          -- highlights.DiagnosticStatusHint = highlights.DiagnosticHint
          highlights.WinSeparator.fg = colors.comment -- colors.none
        end,
      })
      tokyonight.load()
    end,
  },

  {
    'catppuccin/nvim',
    enabled = false,
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = false,
        show_end_of_buffer = false, -- show the '~' characters after the end of buffers
        term_colors = false,
        dim_inactive = {
          -- enabled = true,
          shade = 'dark',
          percentage = 0.15,
        },
        styles = {
          comments = { 'italic' },
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = function(colors)
          return {
            DiagnosticStatusError = { bg = colors.red, fg = colors.base },
          }
        end,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = false,
          mini = false,
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      })

      -- setup must be called before loading
      vim.cmd.colorscheme('catppuccin')
    end,
  },

  -- {
  --   'rebelot/kanagawa.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd('colorscheme kanagawa')
  --   end,
  -- },
}
