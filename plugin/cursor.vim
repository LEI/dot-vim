" Cursor

function! s:RestoreCursor()
  if line("'\"") > 0 && line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

" Restore cursor position
augroup RestoreCursor
  autocmd!
  autocmd BufReadPost * call s:RestoreCursor()
augroup END

" Show cursor line on active window only
augroup ToggleCursorline
  autocmd!
  autocmd WinEnter * set cursorline " InsertLeave
  autocmd WinLeave * set nocursorline " InsertEnter
augroup END

" Change cursor style in iTerm2
try
  if empty($TMUX)
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  else
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
  endif
catch " /E355:/
endtry
