-- https://github.com/lukas-reineke/lsp-format.nvim/blob/master/lua/lsp-format/init.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/format.lua
-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
local M = {}

-- M.autoformat = true

-- Force enable or disable formatting
M.servers = {
  copilot = false,
  eslint = true, -- Force formatting with eslint-ls
  -- ['null-ls'] = false,

  sumneko_lua = false, -- Replaced by stylua
  lua_ls = false,

  tsserver = false, -- Replaced by eslint-ls
  yamlls = false, -- TODO: fallback to yamlls if there is no prettier config
}

function M.should_force(client)
  return M.servers[client.name] == true
end

function M.list_excluded()
  local ret = {}
  for name, enabled in pairs(M.servers) do
    if not enabled then
      table.insert(ret, name)
    end
  end
  return ret
end

-- Force formatting event if the support is not reported by the server
function M.toggle_capabilities(client, toggle)
  -- local msg = 'Force ' .. (toggle and 'enable ' or 'disable ') .. client.name .. ' formatting'
  -- vim.notify(msg, 'TRACE', { title = 'LSP Format' })
  client.server_capabilities.documentFormattingProvider = toggle
  client.server_capabilities.documentRangeFormattingProvider = toggle
end

-- Check if the client should format
function M.should_format(client)
  -- client.supports_method('textDocument/formatting')
  -- print(
  --   client.name,
  --   client.server_capabilities.documentFormattingProvider,
  --   client.server_capabilities.documentRangeFormattingProvider
  -- )
  if
    not client.server_capabilities.documentFormattingProvider
    and not client.server_capabilities.documentRangeFormattingProvider
  then
    return false
  end

  -- Ensure formatting is disabled
  -- FIXME: disable tsserver from config
  if M.servers[client.name] == false then
    M.toggle_capabilities(client, false)
  end

  return M.servers[client.name] ~= false
end

function M.toggle()
  -- M.autoformat = not M.autoformat
  -- vim.notify(M.autoformat and 'Enabled format on save' or 'Disabled format on save')
  local ok, lsp_format = pcall(require, 'lsp-format')
  if not ok then
    vim.notify('LSP formatter plugin unavailable', 'ERROR', {
      title = 'LSP Format',
    })
    return
  end
  lsp_format.toggle({ args = '' })
  local msg = not lsp_format.disabled and 'Enabled format on save' or 'Disabled format on save'
  vim.notify(msg, 'INFO', {
    title = 'LSP Format',
  })
end

-- function M.format(bufnr)
--   bufnr = bufnr or vim.api.nvim_get_current_buf()
--   -- local ft = vim.bo[bufnr].filetype
--   -- local null_ls_sources = require('null-ls.sources').get_available(ft, 'NULL_LS_FORMATTING')
--   -- local available_sources = vim.tbl_map(function(source)
--   --   return source.name
--   -- end, null_ls_sources)
--   -- vim.pretty_print(available_sources)
--   -- local have_nls = #available_sources > 0
--   local timeout = nil -- ft == 'sql' and 5000 or nil

--   -- -- Do not format is the file is empty
--   -- local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
--   -- if #content == 1 and content[1] == '' then
--   --   return
--   -- end

--   vim.lsp.buf.format({
--     bufnr = bufnr,
--     filter = function(client)
--       -- if client.name == 'prettier' then
--       --   return not eslint-ls w/ prettier
--       -- end

--       -- if have_nls then
--       --   return client.name == 'null-ls'
--       -- end
--       -- return client.name ~= 'null-ls'
--       vim.notify('Request format', 'DEBUG', { title = client.name })
--       return true
--     end,
--     timeout = timeout,
--   })
-- end

-- FIXME: only one formatter on save? client.name ~= 'tsserver'
-- https://github.com/lukas-reineke/lsp-format.nvim/issues/39#issuecomment-1107906110
function M.on_attach(client, bufnr)
  if M.should_force(client) then
    -- Ensure formatting is enabled
    M.toggle_capabilities(client, true)
  end
  if not M.should_format(client) then
    if M.verbose then
      vim.notify('Skip ' .. client.name, 'WARN', { title = 'LSP Format' })
    end
    return
  end
  if M.verbose then
    vim.notify('Attach ' .. client.name, 'INFO', { title = 'LSP Format' })
    -- .. '\n' .. vim.inspect(client.server_capabilities)
  end
  local lsp_format = require('lsp-format')
  lsp_format.on_attach(client, bufnr)

  -- vim.api.nvim_buf_create_user_command(bufnr, 'LspFormat', function()
  --   M.format(bufnr)
  -- end, {})
  -- vim.api.nvim_create_autocmd('BufWritePre', {
  --   buffer = bufnr,
  --   group = vim.api.nvim_create_augroup('LspFormat.' .. bufnr, { clear = true }),
  --   callback = function()
  --     if M.autoformat then
  --       M.format(bufnr)
  --     end
  --   end,
  -- })

  -- -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/879#issuecomment-1345440978
  -- vim.api.nvim_create_autocmd('BufWritePre', {
  --   group = vim.api.nvim_create_augroup('LspFormat.' .. bufnr, { clear = true }),
  --   buffer = bufnr,
  --   command = 'LspFormat', -- 'undojoin | LspFormat',
  -- })
  -- end
end

return M
