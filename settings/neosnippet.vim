" Neosnippet

if !exists('g:loaded_neosnippet')
  finish
endif

" honza/vim-snippets
" let g:neosnippet#snippets_directory = g:vim_plugins_path . '/vim-snippets/snippets'

" Enter to close popup, or expand if a snippet is selected
" imap <expr><CR> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-y>" : "\<CR>")
imap <expr><CR> neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : (pumvisible() ? "\<C-y>" : "\<CR>")

" Expand snippet or jump to next placeholder with Tab
imap <expr><Tab> pumvisible() ? "\<C-n>" : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : "\<Tab>")
smap <expr><Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
xmap <C-k> <Plug>(neosnippet_expand_target)

" Conceal snippet markers
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
