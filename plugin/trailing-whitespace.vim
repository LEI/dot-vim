" Trailing whitespace

" http://vimcasts.org/episodes/tidying-whitespace/
" https://github.com/bronson/vim-trailing-whitespace
" https://github.com/csexton/trailertrash.vim
" https://github.com/ntpeters/vim-better-whitespace
" aserebryakov/filestyle
function! StripTrailingWhitespace()
  call Preserve("%s/\\s\\+$//e")
endfunction

" command! -range=% RemoveTrailing call <SID>StripTrailingWhitespaceRange(<line1>,<line2>)

augroup TrailingWhitespace
  autocmd!
  autocmd BufWritePre *.js,*.php,*.py :call StripTrailingWhitespace()
augroup END
