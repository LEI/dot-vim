local settings = require('core.settings')

return {
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
        neededFileStatus = {
          ['codestyle-check'] = 'Any', -- Opened
          -- ['spell-check'] = 'Any',
        },
      },
      format = {
        enable = false, -- stylua
        defaultConfig = {
          -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/README_EN.md
          -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/lua.template.editorconfig
          -- align_table_field_to_first_field = 'true',
          -- align_call_args = 'keep', -- TODO: force
          -- end_of_line = 'lf',
          indent_size = tostring(settings.style.lua.indent_width),
          indent_style = settings.style.lua.indent_style,
          max_line_length = tostring(settings.style.lua.max_line_length),
          quote_style = settings.style.lua.quote_style,
          -- table_separator_style = '', -- none, comma, semicolon
          trailing_table_separator = 'smart', -- keep, never, always, smart
        },
      },
      hint = {
        enable = true,
      },
      hover = {
        enable = true,
      },
      completion = {
        callSnippet = 'Replace',
        displayContext = 1,
      },
      signatureHelp = {
        enable = true,
      },
      telemetry = {
        enable = false,
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}
