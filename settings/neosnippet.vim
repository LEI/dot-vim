" Neosnippet

if !has('lua')
  finish
endif

imap <expr><CR> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<CR>"
smap <expr><CR> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<CR>"
xmap <expr><CR> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_target)" : "\<CR>"

" Conceal markers
" if has('conceal')
"   set conceallevel=2 concealcursor=niv
" endif
