" Trailing whitespace

" http://vimcasts.org/episodes/tidying-whitespace/
" bronson/vim-trailing-whitespace
" csexton/trailertrash.vim
" ntpeters/vim-better-whitespace
" aserebryakov/filestyle
function! StripTrailingWhitespace()
  if &binary || &filetype ==# 'diff'
    return
  endif
  call Preserve("%s/\\s\\+$//e")
  " normal mz
  " normal Hmy
  " %s/\s\+$//e
  " normal 'yz<CR>
  " normal `z
endfunction

" command! -range=% RemoveTrailing call <SID>StripTrailingWhitespaceRange(<line1>,<line2>)

augroup TrailingWhitespace
  autocmd!
  autocmd BufWritePre *.js,*.php,*.py :call StripTrailingWhitespace()
augroup END
