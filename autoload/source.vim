" Init

function! source#File(...)
  let l:path = a:0 > 0 ? a:1 : ''
  let l:func = a:0 > 1 ? a:2 : ''
  if strlen(l:path) == 0
    echoerr 'Invalid argument: missing file path'
    return 0
  endif
  if strlen(l:func) > 0
    if !exists('*' . l:func)
      echoerr 'Unknown function:' l:func
      return 0
    endif
    if {l:func}(l:path) " call(l:Func, [l:path])
      return s:source(l:path)
    endif
    return 0
  endif
  return s:source(l:path)
endfunction

function! source#Dir(...)
  let l:dir = a:1
  let l:fun = a:0 > 1 ? a:2 : ''
  let l:pat = a:0 > 2 ? a:3 : '*.vim'
  if strlen(l:dir) == 0
    echoerr 'Invalid argument: missing directory path'
    return 0
  endif
  if !isdirectory(l:dir)
    echoerr 'Invalid directory:' l:dir
    return 0
  endif
  let l:files = globpath(expand(l:dir), l:pat)
  for l:path in split(l:files, '\n')
    if strlen(l:fun) > 0
      call source#File(l:path, l:fun)
    else
      call source#File(l:path)
    endif
  endfor
endfunction

function! s:source(path)
  if !filereadable(expand(a:path))
    return 0
  endif
  execute 'source' a:path
endfunction
