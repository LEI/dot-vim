local dap = require('dap')

-- node-debug2-adapter
local filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }

return {
  -- enabled = false,
  setup = function(source_name)
    require('mason-nvim-dap.automatic_setup')(source_name)
    -- dap.adapters.node2.args
    -- vim.fn.stdpath('data') .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js'
    for _, language in ipairs(filetypes) do
      for _, config in ipairs(dap.configurations[language]) do
        -- FIXME: nodeDebug.js process keeps running after launch error
        if config.type == 'node2' and config.request == 'launch' and not config.outFiles then
          config.outFiles = { '${workspaceFolder}/dist/**/*.js' }
        end
      end
    end
  end,
}
