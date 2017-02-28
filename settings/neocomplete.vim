" Neocomplete

if !has('lua')
  finish
endif

let g:neocomplete#enable_at_startup = 1
" let g:neocomplete#enable_auto_select = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Key mappings
" inoremap <expr><C-g> neocomplete#undo_completion()
" inoremap <expr><C-l> neocomplete#complete_common_string()

" Tab: Next completion, or jump to next snippet placeholder
inoremap <expr><Tab> neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : (pumvisible() ? "\<C-n>" : "\<Tab>")
snoremap <expr><Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"

" Shift Tab: Previous completion
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"

" Enter: close popup and expand snippet if applicable
inoremap <expr><CR> puvisible() ? (neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : "\<C-y>") : "\<CR>"

" Close popup and delete backword char
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" Enable omni completion
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Conceal snippet markers
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
