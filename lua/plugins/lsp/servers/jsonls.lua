local capabilities = require('plugins.lsp.capabilities').completion()

return {
  capabilities = capabilities,
  init_options = {
    -- Use prettier instead to keep new lines and inline arrays
    provideFormatter = false,
  },
  settings = {
    json = { -- allowComments, trailingCommas...
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}
