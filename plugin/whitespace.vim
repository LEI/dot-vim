" Whitespace functions

" http://vimcasts.org/episodes/tidying-whitespace/
" https://github.com/bronson/vim-trailing-whitespace
" https://github.com/csexton/trailertrash.vim
" https://github.com/ntpeters/vim-better-whitespace
" aserebryakov/filestyle
function! StripTrailingWhitespaces()
  call Preserve("%s/\\s\\+$//e")
endfunction
