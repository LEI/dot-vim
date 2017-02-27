" Cursor enhancements

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

" Show cursor line on active window only
" Add InsertLeave / InsertEnter to disable in insert mode
augroup ToggleCursorline
  autocmd!
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END
