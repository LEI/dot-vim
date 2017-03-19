" Completion

set complete-=i " Do not scan current and included files
set complete+=kspell " Use the currently active spell checking
set completeopt+=longest " Only insert the longest common text of the matches

if exists('+omnifunc')
  augroup OmniCompletion
    autocmd!
    autocmd Filetype * if &omnifunc ==# "" | setlocal omnifunc=syntaxcomplete#Complete | endif
  augroup END
endif

" Nex completion with Tab
if maparg('<Tab>', 'i') ==# ''
  inoremap <expr> <Tab> <SID>Complete() ? "\<C-n>" : "\<Tab>"
endif

" Previous completion with Shift-Tab
if maparg('<S-Tab>', 'i') ==# ''
  " <S-Tab> :exe 'set t_kB=' . nr2char(27) . '[Z'
  inoremap <S-Tab> <C-p>
endif

" Check characters before the cursor
function! <SID>Complete() abort
  let l:col = col('.') - 1
  if !l:col || getline('.')[l:col - 1] !~# '\k'
    return 0
  endif
  return 1
endfunction
