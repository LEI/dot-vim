" Cursor enhancements

function! s:RestoreCursorPos()
  if line("'\"") > 0 && line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup RestoreCursorPos
  autocmd!
  autocmd BufReadPost * call s:RestoreCursor()
augroup END

" Show cursor line on active window only
" Add InsertLeave / InsertEnter to disable in insert mode
augroup ToggleCursorline
  autocmd!
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END
