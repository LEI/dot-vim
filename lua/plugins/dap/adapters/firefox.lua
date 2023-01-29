-- firefox-debug-adapter

-- dap.adapters.firefox = {
--   type = 'executable',
--   command = 'node',
--   args = { mason_packages .. '/firefox-debug-adapter/dist/adapter.bundle.js' },
-- }

-- dap.configurations.typescript = {
--   {
--     name = 'Debug with Firefox',
--     type = 'firefox',
--     request = 'launch',
--     reAttach = true,
--     url = 'http://localhost:3000',
--     webRoot = '${workspaceFolder}',
--     -- firefoxExecutable = '/usr/bin/firefox',
--     firefoxExecutable = 'stable',
--   },
-- }

return {
  enabled = false,
}
