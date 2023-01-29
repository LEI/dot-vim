local util = require('lspconfig.util')

-- Add extra server mapping
local server_mapping = require('mason-lspconfig.mappings.server')
server_mapping.lspconfig_to_package.nginx = 'nginx-language-server'
server_mapping.package_to_lspconfig['nginx-language-server'] = 'nginx'

-- FIXME: https://github.com/pappasam/nginx-language-server/issues/15#issue-918308356
vim.cmd([[augroup custom_nginx
  autocmd!
  autocmd FileType nginx setlocal iskeyword+=$
  autocmd FileType nginx let b:coc_additional_keywords = ['$']
augroup end]])

return {
  default_config = {
    cmd = { 'nginx-language-server' },
    filetypes = { 'nginx' },
    -- root_dir = function(fname)
    --   return util.root_pattern('nginx.conf', '.git')(fname) or vim.loop.os_homedir()
    -- end,
    root_dir = util.root_pattern('.git', 'nginx.conf'),
    settings = {},
    -- single_file_support = true,
  },
}
