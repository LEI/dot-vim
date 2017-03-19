" Abbreviations

function! Eatchar(pat)
  let l:c = nr2char(getchar(0))
  return (l:c =~ a:pat) ? '' : l:c
endfunc

iabbrev pyhton python
