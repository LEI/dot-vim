" Init

function! source#File(...)
  let l:path = a:0 ? a:1 : ''
  let l:func = a:0 > 1 ? a:2 : ''
  if !strlen(l:path)
    echoerr 'Not enough arguments for function: source#File'
    return 0
  endif
  if strlen(l:func)
    if !exists('*' . l:func)
      echoerr 'Unknown function:' l:func
      return 0
    endif
    if {l:func}(l:path)
      return s:source(l:path)
    endif
    return 0
  endif
  return s:source(l:path)
endfunction

function! source#Dir(...)
  let l:dir = a:0 ? a:1 : ''
  let l:func = a:0 > 1 ? a:2 : ''
  let l:pat = a:0 > 2 ? a:3 : '*.vim'
  if !strlen(l:dir)
    echoerr 'Not enough arguments for function: source#Dir'
    return 0
  endif
  let l:files = globpath(expand(l:dir), l:pat)
  for l:path in split(l:files, '\n')
    if strlen(l:func)
      call source#File(l:path, l:func)
    else
      call source#File(l:path)
    endif
  endfor
endfunction

function! s:source(path)
  if filereadable(expand(a:path))
    execute 'source' a:path
  endif
endfunction
