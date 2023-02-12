local diagnostic_signs = {
  error = vim.fn.sign_getdefined('DiagnosticSignError')[1].text:gsub('%s+', ''),
  warn = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text:gsub('%s+', ''),
  info = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text:gsub('%s+', ''),
  hint = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text:gsub('%s+', ''),
  ok = vim.fn.sign_getdefined('DiagnosticSignOk')[1].text:gsub('%s+', ''),
}

local style = {
  lua = {
    indent_style = 'spaces',
    indent_width = 2,
    max_line_length = 120,
    quote_style = 'single',
  },
}

-- Common icons
local icons = {
  absent = '', -- ○
  pending = '祥', -- ◌
  present = '', -- ●
  outdated = 'ﮮ',
  unwanted = '',
}

local settings = {
  -- border = 'single',
  border = 'solid',
  diagnostic = { -- config
    float = {
      prefix = '',
    },
    severity_sort = true,
    signs = true,
    underline = {
      -- severity = { min = vim.diagnostic.severity.WARN },
    },
    update_in_insert = false,
    virtual_text = false,
    -- virtual_text: {
    --   -- format = format_diagnotic,
    --   prefix = ' ■',
    --   -- source = 'always',
    --   spacing = 1,
    -- },
  },
  diagnostic_hover = false,
  signature_help = false,

  float = {
    size = { width = 0.8, height = 0.8 },
  },

  -- Trouble:
  -- error = "",
  -- warning = "",
  -- hint = "",
  -- information = "",
  -- other = "﫠"
  -- icons = {
  --   diagnostics = {
  --     Error = ' ',
  --     Warn = ' ',
  --     Hint = ' ',
  --     Info = ' ',
  --   },
  --   git = {
  --     added = ' ',
  --     modified = ' ',
  --     removed = ' ',
  --   },
  --   kinds = {
  --     Array = " ",
  --     Boolean = " ",
  --     Class = " ",
  --     Color = " ",
  --     Constant = " ",
  --     Constructor = " ",
  --     Enum = " ",
  --     EnumMember = " ",
  --     Event = " ",
  --     Field = " ",
  --     File = " ",
  --     Folder = " ",
  --     Function = " ",
  --     Interface = " ",
  --     Key = " ",
  --     Keyword = " ",
  --     Method = " ",
  --     Module = " ",
  --     Namespace = " ",
  --     Null = "ﳠ ",
  --     Number = " ",
  --     Object = " ",
  --     Operator = " ",
  --     Package = " ",
  --     Property = " ",
  --     Reference = " ",
  --     Snippet = " ",
  --     String = " ",
  --     Struct = " ",
  --     Text = " ",
  --     TypeParameter = " ",
  --     Unit = " ",
  --     Value = " ",
  --     Variable = " ",
  --   },
  -- },

  -- LSP kind
  kinds = {
    -- Codicons
    Text = '', --  
    -- Method = '',
    Function = '', -- ƒ
    -- Constructor = '', --   
    -- Field = '', -- ﰠ    
    -- Variable = 'ﳋ', --    
    -- Class = 'ﴯ', -- 𝓒 
    -- Interface = '', --  
    -- Module = '', -- ﰪ
    -- Property = '', -- ﰠ  
    -- Unit = '塞',
    -- Value = '', -- 
    -- Enum = '', -- 練 ℰ
    -- Keyword = '',
    Snippet = '', -- 
    -- Color = '',
    File = '', -- 
    -- Reference = '', -- 
    Folder = '', -- 
    -- EnumMember = '',
    -- Constant = '', -- ﲀ 
    -- Struct = 'פּ', -- ﬌ 𝓢  
    -- Event = '', -- 
    -- Operator = '', -- 
    -- TypeParameter = '', -- 𝙏 

    -- symbols-outline
    Namespace = '', -- 
    Package = '',
    String = '', -- 𝓐 
    Number = '', -- # 
    Boolean = '◩', -- ⊨ 
    Array = '', -- 
    Object = '',
    Key = '',
    Null = 'ﳠ',

    -- Copilot = '',

    -- Database
    Column = '',
    Table = '',
  },

  -- Extra devicons
  -- color, cterm_color
  devicons = {
    dbout = { icon = '󰥞', name = 'Output' },
    dbui = { icon = '󱙋', name = 'DBUI' },
    sql = { icon = '', name = 'SQL' },
    tags = { icon = '', name = 'Tags' },
    -- terminal = { icon = '>' },
    -- toggleterm = { icon = '' },
    -- txt = { icon = '󰈚' }, -- 󰊄 󱄽 󰧭 󰦪 󰦨 󰦩
  },

  chars = {
    ellipsis = '…',
  },
  icons = {
    lazy = {
      cmd = '⌘',
      config = '',
      event = '',
      ft = '',
      init = '⚙',
      keys = '',
      lazy = '鈴', -- 💤
      loaded = icons.present, -- ●
      not_loaded = icons.absent, -- ○
      plugin = '',
      runtime = '',
      source = '',
      start = '',
      task = icons.pending, -- 
      -- list = { '●', '➜', '★', '‒' },
    },
    mason = {
      package_installed = icons.present, -- ◍
      package_pending = icons.pending,
      package_uninstalled = icons.absent,
    },
    package = {
      up_to_date = ' ' .. icons.present .. ' ',
      outdated = ' ' .. icons.outdated .. ' ',
      unwanted = ' ' .. icons.unwanted .. ' ',
    },
  },

  -- LSP
  signs = {
    diagnostic = diagnostic_signs,
    git = {
      added = '+',
      modified = '~',
      removed = '-',
    },
  },
  spinner = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
  style = style,
  lint = {
    luacheck = {
      -- stylua: ignore
      args = {
        '--globals', 'vim',
        '--max-line-length', style.lua.max_line_length,
      },
    },
  },
  format = {
    -- log_level = vim.log.levels.WARN,
    -- stylua = {
    --   -- https://github.com/JohnnyMorganz/StyLua/issues/75
    --   -- stylua: ignore
    --   args = {
    --     '--column-width', style.lua.max_line_length, -- tostring?
    --     '--indent-type', style.lua.indent_style, -- Uppercase?
    --     '--indent-width', style.lua.indent_width,
    --     '--quote-style', 'AutoPreferSingle',
    --   },
    -- },
  },
}

return settings
