local util = require('lspconfig.util')

return {
  enabled = false, -- https://github.com/joe-re/sql-language-server/issues/128
  root_pattern = util.root_pattern('.git', '.sqllsrc.json'),
}
