" Trailing

" http://vimcasts.org/episodes/tidying-whitespace/
" https://github.com/bronson/vim-trailing-whitespace
" https://github.com/csexton/trailertrash.vim
" https://github.com/ntpeters/vim-better-whitespace
function! StripTrailingWhitespaces()
  call Preserve("%s/\\s\\+$//e")
endfunction

augroup Trailing
  autocmd!
  autocmd BufWritePre *.js,*.php,*.py :call StripTrailingWhitespaces()
augroup END
