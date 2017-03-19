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

function! HighlightCursor() abort
  if &background ==# 'dark'
    " highlight Cursor ctermfg=8 ctermbg=4 guifg=#002b36 guibg=#268bd2
    highlight Cursor ctermfg=0 ctermbg=15 guifg=#002b36 guibg=#fdf6e3
  elseif &background ==# 'light'
    " highlight Cursor ctermfg=15 ctermbg=4 guifg=#fdf6e3 guibg=#268bd2
    highlight Cursor ctermfg=15 ctermbg=0 guifg=#fdf6e3 guibg=#002b36
  endif
endfunction

" Show cursor line on active window only (or use InsertLeave/InsertEnter)
augroup Cursor
  autocmd!
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
  autocmd VimEnter,ColorScheme * :call HighlightCursor()
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
