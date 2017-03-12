" Omni completion

set complete+=kspell " Autocompete with dictionnary words when spell check is on

set completeopt+=longest,menuone " Only insert the longest common text for matches

function! NextComp() abort
  return "\<C-p>" " Nearest matching word
endfunction

function! PrevComp() abort
  return "\<C-n>"
endfunction

function! AcceptComp() abort
  return "\<C-y>"
endfunction

function! EndComp() abort
  return "\<C-e>"
endfunction

" function! CheckBackSpace() abort
"   return strpart( getline('.'), 0, col('.')-1 ) =~# '^\s*$'
" endfunction

" function! OnlyWS() abort
"   " let l:col = col('.') - 1
"   " " !col || getline('.')[col - 1] !~ '\k'
"   " return !l:col || getline('.')[l:col - 1] =~# '\s'
"   return strpart( getline('.'), 0, col('.')-1 ) =~# '^\s*$'
" endfunction

function! OpenPopupMenu() abort
  if pumvisible()
    return ''
  endif
  let l:line = getline('.') " Current line
  " From the start of the current line to one character right of the cursor
  let l:substr = strpart(l:line, -1, col('.')+1)
  let l:substr = matchstr(l:substr, "[^ \t]*$") " word till cursor
  if (strlen(l:substr) == 0) " nothing to match on empty string
    return '0'
  endif
  " CTRL-L whole line
  " TODO CTRL-] tags
  " CTRL-D definitions or macros
  " CTRL-V vim commands
  " CTRL-U user defined completon
  let l:has_period = match(l:substr, '\.') != -1 " position of period
  let l:has_slash = match(l:substr, '\/') != -1 " position of slash
  if !l:has_period && !l:has_slash
    return "\<C-x>\<C-p>" " existing text matching (keywords in current file)
  elseif l:has_slash
    return "\<C-x>\<C-f>" " file names matching
  elseif exists('&omnifunc') && &omnifunc !=# ''
    " TODO: fallback to generic completion C-p
    " when catch /Pattern not found/ " E486
    return "\<C-x>\<C-o>" " omni completion
  " elseif &dictionary !=# ''
  "   return "\<C-x>\<C-k>"
  " elseif has('spell') && (check_spell)
  "   return "\<C-x>\<C-s>" " spelling suggestions
  endif
  " echom 'No completion type found for: ' . l:substr
  return ''
endfunction

function! Complete(input, fname) abort
  " Return early if the popup menu is visible
  let l:open = OpenPopupMenu()
  if l:open ==# '0'
    " Line should not be completed, send original input
    return a:input
  elseif l:open ==# ''
    " Already visible or completion type not detected, use next/previous mapping
    return {a:fname}()
  endif
  return l:open
endfunction

" Next and previous completion Tab and Shift-Tab
inoremap <expr> <Tab> Complete("\<Tab>", 'NextComp')
" <S-Tab> :exe 'set t_kB=' . nr2char(27) . '[Z'
inoremap <expr> <S-Tab> Complete("\<S-Tab>", 'PrevComp')

" Close the popup menu (fix at your own risk)
" inoremap <expr> <CR> pumvisible() ? AcceptComp() : "\<CR>"
" inoremap <expr> <Esc> pumvisible() ? EndComp() : "\<Esc>"

"let s:save_cr = maparg('<CR>', 'i')
"(s:save_cr !=# '' ? s:save_cr : "\<CR>")

" inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
" imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" \<PageDown>\<C-p>\<C-n>

" autocmd CompleteDone -> expand snippet?

augroup OmniCompletion
  autocmd!
  autocmd Filetype * if exists("+omnifunc") && &omnifunc ==# "" | setlocal omnifunc=syntaxcomplete#Complete | endif
augroup END
