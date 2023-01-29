local capabilities = require('plugins.lsp.capabilities').completion()

return {
  capabilities = capabilities,
  init_options = {
    provideFormatter = false, -- prettier
  },
  settings = {
    json = { -- allowComments, trailingCommas...
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}
