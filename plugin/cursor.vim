" Cursor

if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
elseif empty($TMUX)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  if v:version >= 800
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  endif
else
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  if v:version >= 800
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
  endif
endif

" Show cursor line on active window only (or use InsertLeave/InsertEnter)
augroup ToggleCursorLine
  autocmd!
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END

" Restore cursor position and toggle cursor line
" Not needed with mkview/loadview
" https://github.com/farmergreg/vim-lastplace
" function! RestoreCursorPosition()
"   if &filetype ==# 'gitcommit'
"     return 0
"   endif
"   if line("'\"") > 0 && line("'\"") <= line('$')
"     normal! g`"
"     return 1
"   endif
" endfunction
" augroup RestoreCursorPosition
"   autocmd!
"   autocmd BufReadPost * call RestoreCursorPosition()
" augroup END
