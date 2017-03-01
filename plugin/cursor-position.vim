" Restore cursor position and toggle cursor line
" https://github.com/farmergreg/vim-lastplace

function! s:RestoreCursorPosition()
  if line("'\"") > 0 && line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup RestoreCursorPosition
  autocmd!
  autocmd BufReadPost * call s:RestoreCursorPosition()
augroup END
