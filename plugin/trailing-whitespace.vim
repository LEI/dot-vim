" Trailing whitespace
" TODO: read .editorconfig trailing_whitespace setting

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

" Remove trailing spaces in the current file
nnoremap <Leader>St :call StripTrailingWhitespace()<CR>

if !has('nvim')
  augroup TrailingWhitespace
    autocmd!
    autocmd BufWritePre *.js,*.ts,*.php,*.py :call StripTrailingWhitespace()
  augroup END
endif
