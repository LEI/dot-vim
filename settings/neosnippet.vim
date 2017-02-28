" Neosnippet

if !has('lua')
  finish
endif

" Expand selected snippet with Enter
imap <expr><CR> neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : "\<CR>"

" Jump to next snippet placeholder
imap <expr><Tab> neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : (pumvisible() ? "\<C-n>" : "\<Tab>")
smap <expr><Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"

" xmap <expr><C-k> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_target)" : "\<C-k>"

" Conceal markers
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
