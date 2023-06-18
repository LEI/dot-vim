local diagnostic_signs = {
  error = vim.fn.sign_getdefined('DiagnosticSignError')[1].text:gsub('%s+', ''),
  warn = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text:gsub('%s+', ''),
  info = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text:gsub('%s+', ''),
  hint = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text:gsub('%s+', ''),
  ok = vim.fn.sign_getdefined('DiagnosticSignOk')[1].text:gsub('%s+', ''),
}

-- Common icons
local icons = {
  absent = '󰝦', -- ○
  pending = '󱎫', -- ◌
  present = '󰄳', -- ●
  outdated = '󰚰',
  unwanted = '󰋚',
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
  -- error = "󰅚",
  -- warning = "󰀪",
  -- hint = "󰌶",
  -- information = "",
  -- other = "󰗡"
  -- icons = {
  --   diagnostics = {
  --     Error = ' ',
  --     Warn = ' ',
  --     Hint = '󰌶 ',
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
  --     Folder = "󰉋 ",
  --     Function = " ",
  --     Interface = " ",
  --     Key = " ",
  --     Keyword = " ",
  --     Method = " ",
  --     Module = " ",
  --     Namespace = " ",
  --     Null = "󰟢 ",
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
    Text = '󰉿', --  
    -- Method = '󰆧',
    Function = '󰊕', -- ƒ
    -- Constructor = '', --   󰌗
    -- Field = '󰆨', -- 󰜢 󰄶  󰇽 
    -- Variable = '󰟍', -- 󰀫 󰂡  
    -- Class = '󰠱', -- 𝓒 
    -- Interface = '', --  
    -- Module = '', -- 󰜬
    -- Property = '', -- 󰜢  
    -- Unit = '󰑭',
    -- Value = '󰎠', -- 
    -- Enum = '', -- 󰕘 ℰ
    -- Keyword = '',
    Snippet = '󰃅', -- 
    -- Color = '󰏘',
    File = '', -- 󰈙
    -- Reference = '', -- 󰈇
    Folder = '󰉋', -- 
    -- EnumMember = '',
    -- Constant = '󰏿', -- 󰞂 
    -- Struct = '󰙅', -- 󰘍 𝓢  
    -- Event = '', -- 
    -- Operator = '󰆕', -- 
    -- TypeParameter = '󰊄', -- 𝙏 

    -- symbols-outline
    Namespace = '󰅲', -- 
    Package = '',
    String = '󰀬', -- 𝓐 
    Number = '󰎠', -- # 
    Boolean = '◩', -- ⊨ 
    Array = '󰅪', -- 
    Object = '󰅩',
    Key = '󰌋',
    Null = '󰟢',

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
    sql = { icon = '󰆼', name = 'SQL' },
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
      ft = '󰉋',
      init = '⚙',
      keys = '󰌋',
      lazy = '󰒲', -- 💤
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
}

return settings
