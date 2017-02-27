" Restore cursor position

function! RestoreCursor()
  if line("'\"") > 0 && line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup RestoreCursor
  autocmd!
  autocmd BufReadPost * call RestoreCursor()
augroup END

" Show cursor line on active window only

augroup ToggleCursorline
  autocmd!
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END
