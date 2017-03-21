" Utility functions

" Consume the space typed after an abbreviation
function! Eatchar(pat)
  let l:c = nr2char(getchar(0))
  return (l:c =~ a:pat) ? '' : l:c
endfunc

" Restore cursor position and search query after a command
function! Preserve(command)
  " Save last search and cursor position
  " let l:_s=@/ | let l:l = line('.') | let l:c = col('.')
  let l:save_cursor = getpos('.')
  let l:old_query = getreg('/')
  " Do the business
  execute a:command
  " Clean up: restore previous search and position
  " let @/=l:_s | call cursor(l:l, l:c)
  call setpos('.', l:save_cursor)
  call setreg('/', l:old_query)
endfunction
