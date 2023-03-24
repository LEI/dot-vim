local capabilities = require('plugins.lsp.capabilities').completion()

return {
  capabilities = capabilities,
  init_options = {
    -- configurationSection = { 'html', 'css', 'javascript' },
    -- embeddedLanguages = {
    --   css = true,
    --   javascript = true
    -- },
    provideFormatter = false,
  },
  -- settings = {},
}
