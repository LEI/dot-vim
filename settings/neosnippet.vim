" Neosnippet

if !exists('g:loaded_neosnippet')
  finish
endif

" Conceal snippet markers
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Enter to close popup, or expand if a snippet is selected
" imap <expr><CR> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-y>" : "\<CR>")

" Expand snippet or jump to next placeholder
" imap <expr><Tab> pumvisible() ? "\<C-n>" : neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
" imap <expr><C-l> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-y>" : "\<C-l>")
imap <expr><C-l> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? ClosePopupMenu() : "\<C-n>")
smap <expr><C-l> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-l>"
xmap <C-l> <Plug>(neosnippet_expand_target)

imap <expr><C-j> neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : "\<C-j>"
smap <expr><C-j> neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : "\<C-j>"
" xmap <C-j> <Plug>(neosnippet_register_oneshot_snippet)

" imap <C-k> <Plug>(neosnippet_expand_or_jump)
" smap <C-k> <Plug>(neosnippet_expand_or_jump)
