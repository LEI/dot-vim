" Utility functions

" Consume the space typed after an abbreviation
function! Eatchar(pat)
  let l:c = nr2char(getchar(0))
  return (l:c =~ a:pat) ? '' : l:c
endfunc

" Restore cursor position and search register
function! Preserve(command)
  let l:cur = getpos('.')
  let l:reg = getreg('/')
  " let l:_s=@/ | let l:l = line('.') | let l:c = col('.')
  execute a:command
  " let @/=l:_s | call cursor(l:l, l:c)
  call setpos('.', l:cur)
  call setreg('/', l:reg)
endfunction

function! Uname()
  " let l:sr = &shellredir
  " set shellredir=>%s\ 2>/dev/null
  let l:uname = system('uname -o')
  if v:shell_error
    let l:uname = system('uname -s')
  endif
  " let &shellredir = l:sr
  return substitute(l:uname, "\n$", '', '')
endfunction
