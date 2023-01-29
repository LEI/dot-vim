-- bash-debug-adapter

-- dap.adapters.bashdb = {
--   type = 'executable',
--   command = mason_packages .. '/bash-debug-adapter/bash-debug-adapter',
--   name = 'bashdb',
-- }

-- dap.configurations.sh = {
--   {
--     type = 'bashdb',
--     request = 'launch',
--     name = 'Launch file',
--     showDebugOutput = true,
--     pathBashdb = mason_packages .. '/bash-debug-adapter/extension/bashdb_dir/bashdb',
--     pathBashdbLib = mason_packages .. '/bash-debug-adapter/extension/bashdb_dir',
--     trace = true,
--     file = '${file}',
--     program = '${file}',
--     cwd = '${workspaceFolder}',
--     pathCat = 'cat',
--     pathBash = '/bin/bash',
--     pathMkfifo = 'mkfifo',
--     pathPkill = 'pkill',
--     args = {},
--     env = {},
--     terminalKind = 'integrated',
--   },
-- }

return {}
