" Show cursor line on active window only
" Add InsertLeave / InsertEnter to disable in insert mode

augroup ToggleCursorline
  autocmd!
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END
