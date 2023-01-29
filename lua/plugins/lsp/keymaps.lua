-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/keymaps.lua
local settings = require('core.settings')

local M = {}

local function toggle_signature_help()
  settings.signature_help = not settings.signature_help
  -- if not settings.signature_help then
  --   -- TODO: close floating window if opened
  -- end
end

-- TODO https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#peek-definition
local function preview_location_callback(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  vim.lsp.util.preview_location(result[1])
end

function PeekDefinition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

-- M.capabilities = {
--   codeLensProvider = function(client, bufnr)
--     -- autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
--     -- api.nvim_command [[autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]]
--     -- api.nvim_buf_set_keymap(bufnr, "n", "<leader>l", "<Cmd>lua vim.lsp.codelens.run()<CR>", {silent = true;})
--     vim.notify(client.name .. ' supports CodeLens', 'INFO', { title = 'LSP Keymaps' })
--     self:map('<Leader>rl', vim.lsp.codelens.refresh, { desc = 'Refresh CodeLens' })
--     self:map('<Leader>cl', vim.lsp.codelens.run, { desc = 'Run CodeLens' })
--   end,
-- }

-- Editor keymaps
function M.once_on_attach(client, bufnr)
  local self = M.new(client, bufnr)

  self:map('<Leader>I', 'LspInfo', { desc = 'LSP Info' })

  -- Diagnostic keymaps (TODO: register earlier to auto map brackets to parenthesis)
  self:map('(d', M.diagnostic_goto(true), { desc = 'Next Diagnostic' })
  self:map(')d', M.diagnostic_goto(false), { desc = 'Previous Diagnostic' })
  -- self:map(']e', M.diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
  -- self:map('[e', M.diagnostic_goto(false, 'ERROR'), { desc = 'Previous Error' })
  -- self:map(']w', M.diagnostic_goto(true, 'WARNING'), { desc = 'Next Warning' })
  -- self:map('[w', M.diagnostic_goto(false, 'WARNING'), { desc = 'Previous Warning' })

  self:map('<Leader>e', vim.diagnostic.open_float, { desc = 'Show line diagnostics' })
  self:map('<Leader>te', function()
    settings.diagnostic_hover = not settings.diagnostic_hover
  end, { desc = 'Toggle line diagnostics on hover' })
  self:map('<Leader>dq', vim.diagnostic.setqflist, { desc = 'Diagnostics to Quickfix list' })
  self:map('<Leader>dl', vim.diagnostic.setloclist, { desc = 'Diagnostics to Location list' })

  -- Toggle
  -- self:map('<leader>xd', 'Telescope diagnostics', { desc = 'Telescope Diagnostics' })
  vim.keymap.set('n', '<Leader>td', require('lazyvim.util').toggle_diagnostics, { desc = 'Toggle Diagnostics' })
  vim.keymap.set('n', '<Leader>tf', require('plugins.lsp.format').toggle, { desc = 'Toggle Format on save' })
  vim.keymap.set('n', '<Leader>ts', toggle_signature_help, { desc = 'Toggle auto Signature help' })
end

---@param client any
---@param bufnr any
function M.on_attach(client, bufnr)
  local self = M.new(client, bufnr)

  -- client.supports_method('textDocument/codeLens')
  if client.server_capabilities.codeLensProvider then
    -- vim.notify(client.name .. ' supports CodeLens', 'INFO', { title = 'LSP Keymaps' })
    -- autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
    -- api.nvim_command [[autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]]
    -- api.nvim_buf_set_keymap(bufnr, "n", "<leader>l", "<Cmd>lua vim.lsp.codelens.run()<CR>", {silent = true;})
    self:map('<Leader>cr', vim.lsp.codelens.refresh, { desc = 'Refresh CodeLens' })
    self:map('<Leader>cl', vim.lsp.codelens.run, { desc = 'Run CodeLens' })
  end

  -- LSP buffer keymaps
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  if client.server_capabilities.codeActionProvider then
    self:map('<Leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action', mode = { 'n', 'v' }, has = 'codeAction' })
  end
  if client.server_capabilities.definitionProvider then
    self:map('gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
    self:map('gD', vim.lsp.buf.declaration, { desc = 'Go to Declaration' })
    self:map('gtd', vim.lsp.buf.type_definition, { desc = 'Go to Type Definition' })
    -- self:map('gd', 'Telescope lsp_definitions', { desc = 'Go to Definition' })
    -- self:map('gD', 'Telescope lsp_declarations', { desc = 'Go to Declaration' })
    self:map('gt', 'Telescope lsp_type_definitions', { desc = 'Go to Type Definition' })
    self:map('<Leader>p', PeekDefinition, { desc = 'Peek Definition' })
  end
  if client.server_capabilities.hoverProvider then
    self:map('K', vim.lsp.buf.hover, { desc = 'Hover' })
  end
  if client.server_capabilities.implementationProvider then
    self:map('gi', vim.lsp.buf.implementation, { desc = 'Go to Implementation' })
    self:map('gI', 'Telescope lsp_implementations', { desc = 'Go to Implementation' })
  end
  if client.server_capabilities.referencesProvider then
    self:map('gr', vim.lsp.buf.references, { desc = 'Go to References' })
    self:map('gR', 'Telescope lsp_references', { desc = 'References' })
  end
  if client.server_capabilities.renameProvider then
    self:map('<Leader>rn', vim.lsp.buf.rename, { desc = 'Rename', has = 'rename' })
    -- self:map('<leader>cr', M.rename, { expr = true, desc = 'Rename (inc)', has = 'rename' })
  end
  if client.server_capabilities.signatureHelpProvider then
    -- self:map('gK', vim.lsp.buf.signature_help, { desc = 'Signature Help', has = 'signatureHelp' })
    self:map('<C-s>', vim.lsp.buf.signature_help, { desc = 'Signature Help', has = 'signatureHelp', mode = 'i' })
  end

  -- local format = require('plugins.lsp.format').format
  -- self:map('<Leader>cf', format, { desc = 'Format Document', has = 'documentFormatting' })
  -- self:map('<Leader>cf', format, { desc = 'Format Range', mode = 'v', has = 'documentRangeFormatting' })

  -- self:map('K', vim.lsp.buf.hover, bufopts)
  -- -- self:map('<C-k>', vim.lsp.buf.signature_help, bufopts)
  -- self:map('<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- self:map('<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  -- self:map('<space>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
  -- self:map('<space>rn', vim.lsp.buf.rename, bufopts)
  -- self:map('<space>ca', vim.lsp.buf.code_action, bufopts)
  -- self:map('<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

  if client.name == 'tsserver' and pcall(require, 'typescript') then
    -- TypescriptAddMissingImports
    -- TypescriptFixAll
    -- TypescriptGoToSourceDefinition
    self:map('<Leader>cO', 'TypescriptOrganizeImports', { desc = 'Organize Imports' })
    -- TypescriptRemoveUnused
    self:map('<Leader>rf', 'TypescriptRenameFile', { desc = 'Rename File' })
  end

  -- https://github.com/mhartington/formatter.nvim/issues/192
  -- https://github.com/coffebar/dotfiles/blob/master/.config/nvim/after/plugin/lspconfig.lua
  -- local force_formatter = true -- client.name == 'sumneko_lua' or client.name == 'tsserver'
  -- if client.server_capabilities.documentFormattingProvider and not force_formatter then
  --   self:map('=', function()
  --     vim.lsp.buf.format({})
  --   end, { mode = 'v', silent = false })
  --   self:map('=', function()
  --     vim.lsp.buf.format({
  --       async = false,
  --       range = nil,
  --     })
  --   end, { silent = false })
  --   -- else
  --   --   self:map('=', ':Format<CR>', { desc = 'Format' })
  --   --   self:map('=', ':Format<CR>', { mode = 'v', desc = 'Format range' })
  -- end
end

function M.new(client, bufnr)
  return setmetatable({ client = client, buffer = bufnr }, { __index = M })
end

function M:has(cap)
  return self.client.server_capabilities[cap .. 'Provider']
end

-- nmap
function M:map(lhs, rhs, opts)
  opts = opts or {}
  if opts.has and not self:has(opts.has) then
    return
  end
  vim.keymap.set(
    opts.mode or 'n',
    lhs,
    type(rhs) == 'string' and ('<cmd>%s<cr>'):format(rhs) or rhs,
    ---@diagnostic disable-next-line: no-unknown
    { noremap = true, silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
  )
end

function M.rename()
  if pcall(require, 'inc_rename') then
    return ':IncRename ' .. vim.fn.expand('<cword>')
  else
    vim.lsp.buf.rename()
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return M
