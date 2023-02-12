-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- local util = require('lazyvim.util')

vim.keymap.set('n', '<Leader>L', '<cmd>:Lazy<cr>', { desc = 'Lazy' })

-- local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
-- vim.keymap.set('n', '<Leader>Tc',
--   function() util.toggle('conceallevel', false, { 0, conceallevel }) end, { desc = 'Toggle Conceal' })
-- vim.keymap.set('n', '<Leader>Tn',
--   function() util.toggle('relativenumber', true) util.toggle('number') end, { desc = 'Toggle Line Numbers' })
-- vim.keymap.set('n', '<Leader>Ts', function() util.toggle('spell') end, { desc = 'Toggle Spelling' })
-- vim.keymap.set('n', '<Leader>Tw', function() util.toggle('wrap') end, { desc = 'Toggle Word Wrap' })

vim.api.nvim_set_keymap('n', '<Leader>db', ':DBUI<CR>', { desc = 'Open Database UI' })
-- noremap = true, silent = true

-- local function show_documentation()
--     local filetype = vim.bo.filetype
--     if vim.tbl_contains({ 'vim','help' }, filetype) then
--         vim.cmd('h '..vim.fn.expand('<cword>'))
--     elseif vim.tbl_contains({ 'man' }, filetype) then
--         vim.cmd('Man '..vim.fn.expand('<cword>'))
--     elseif vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
--         require('crates').show_popup()
--     else
--         vim.lsp.buf.hover()
--     end
-- end

-- vim.keymap.set('n', 'K', show_documentation, { noremap = true, silent = true })
