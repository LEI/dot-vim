" Auto completion with neocomplete + neosnippet

if !has('lua') " !exists('g:loaded_neocomplete')
  finish
endif

" if !exists('g:loaded_neocomplete')
"   finish
" endif

let g:neocomplete#enable_at_startup = 1
" let g:neocomplete#enable_auto_select = 1
" let g:neocomplete#enable_smart_case = 1
" let g:neocomplete#sources#syntax#min_keyword_length = 3

" Key mappings
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()

" Next and previous completion Tab and Shift-Tab
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" Fix Shift-Tab? :exe 'set t_kB=' . nr2char(27) . '[Z'
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<Tab>"

" Close popup and delete backword char
inoremap <expr><C-h> neocomplete#smart_close_popup() . "\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup() . "\<C-h>"

" Enter to close popup, or expand if a snippet is selected
imap <expr><CR> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
  \ (pumvisible() ? "\<C-y>" : "\<CR>")

" Expand snippet or jump to next snippet placeholder with Tab
imap <expr><Tab> pumvisible() ? "\<C-n>" : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : "\<Tab>")
smap <expr><Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
" xmap <C-k> <Plug>(neosnippet_expand_target)

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
