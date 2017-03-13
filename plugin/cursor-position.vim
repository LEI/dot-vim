" Restore cursor position and toggle cursor line
" https://github.com/farmergreg/vim-lastplace

function! RestoreCursorPosition()
  if &filetype ==# 'gitcommit'
    return 0
  endif
  if line("'\"") > 0 && line("'\"") <= line('$')
    normal! g`"
    return 1
  endif
endfunction

" augroup RestoreCursorPosition
"   autocmd!
"   autocmd BufReadPost * call RestoreCursorPosition()
" augroup END

augroup RestoreCursorPosition
  autocmd!
  " Make vim save view (state) (folds, cursor, etc)
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview
augroup END
