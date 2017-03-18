" Completion

" Next and previous completion with Tab and Shift-Tab
" if !get(g:, 'enable_youcompleteme', 0)
if !exists('g:loaded_youcompleteme')
  if maparg('<Tab>', 'i') ==# ''
    inoremap <expr> <Tab> ShouldComplete() ? "\<C-n>" : "\<Tab>"
  endif
  " <S-Tab> :exe 'set t_kB=' . nr2char(27) . '[Z'
  if maparg('<S-Tab>', 'i') ==# ''
    inoremap <S-Tab> <C-p>
  endif
  " inoremap <expr> <Tab> InsertTabWrapper("\<Tab>", 'NextComp')
  " inoremap <expr> <S-Tab> InsertTabWrapper("\<S-Tab>", 'PrevComp')
  " Close the popup menu (fix at your own risk)
  " inoremap <expr> <CR> pumvisible() ? AcceptComp() : "\<CR>"
  " inoremap <expr> <Esc> pumvisible() ? EndComp() : "\<Esc>"
endif

function! ShouldComplete() abort
  if pumvisible()
    return 1
  endif
  let l:col = col('.') - 1
  if !l:col || getline('.')[l:col - 1] !~# '\k'
    return 0
  endif
  return 1
endfunction

" function! InsertTabWrapper(input, fname) abort
"   if pumvisible()
"     return {a:fname}()
"   endif
"   " return strpart( getline('.'), 0, col('.')-1 ) =~# '^\s*$'
"   let l:col = col('.') - 1
"   if !l:col || getline('.')[l:col - 1] !~# '\k'
"     return a:input
"   else
"     return StartComp()
"   endif
" endfunction

function! StartComp() abort
  " (<C-x>)<C-p> nearest matching word
  return "\<C-n>"
endfunction

function! NextComp() abort
  return "\<C-n>"
endfunction

function! PrevComp() abort
  return "\<C-p>"
endfunction

function! AcceptComp() abort
  return "\<C-y>"
endfunction

function! EndComp() abort
  return "\<C-e>"
endfunction
