" Whitespaces

" http://vimcasts.org/episodes/tidying-whitespace/
" https://github.com/bronson/vim-trailing-whitespace

" Error detected while processing BufWritePre Auto commands for "*.js":
" E488: Trailing characters
function! s:Preserve(command)
  " Save last search and cursor position
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business
  execute a:command
  " Clean up: restore previous search history and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

nmap _$ :call s:Preserve("%s/\\s\\+$//e")<CR>
nmap _= :call s:Preserve("normal gg=G")<CR>

augroup Witespaces
  autocmd!
  autocmd BufWritePre *.js,*.php,*.py call s:Preserve("%s/\\s\\+$//e")
augroup END
