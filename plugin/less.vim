" Use "$VIMRUNTIME/macros/less.{sh,vim}" to simulate less support (:h less)
function! LessInitFunc()
  set nocursorcolumn nocursorline
  set statusline=
  if exists('+relativenumber')
    set norelativenumber
  endif
  " set nofoldenable
  " set nomodeline modelines=0
  " augroup LessInitGroup
  "   autocmd!
  "   autocmd BufWinEnter * set nofoldenable
  "   autocmd BufWinEnter * highlight! Cursor
  " augroup END
endfunction
