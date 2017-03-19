" Preserve cursor position

" Error detected while processing BufWritePre Auto commands for "*.js":
" E488: Trailing characters
function! Preserve(command)
  " Save last search and cursor position
  let l:_s=@/
  let l:l = line('.')
  let l:c = col('.')
  " let save_cursor = getpos(".")
  " let old_query = getreg('/')
  " Do the business
  execute a:command
  " Clean up: restore previous search history and cursor position
  let @/=l:_s
  call cursor(l:l, l:c)
  " call setpos('.', save_cursor)
  " call setreg('/', old_query)
endfunction
