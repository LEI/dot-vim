" Preserve cursor position

" let l:_s=@/
" let l:l = line('.')
" let l:c = col('.')
" ...
" let @/=l:_s
" call cursor(l:l, l:c)

function! Preserve(command)
  " Save last search and cursor position
  let l:save_cursor = getpos('.')
  let l:old_query = getreg('/')
  " Do the business
  execute a:command
  " Clean up: restore previous search and position
  call setpos('.', l:save_cursor)
  call setreg('/', l:old_query)
endfunction
