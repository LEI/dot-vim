" Init

function! source#File(path)
  return s:source(a:path)
endfunction

function! source#If(path, func)
  if !exists('*' . a:func)
    echoerr 'Unknown function:' a:func
    return 0
  endif
  if {a:func}(a:path)
    call s:source(a:path)
  endif
endfunction

function! source#Dir(path)
  for l:path in s:glob(a:path)
    call s:source(l:path)
  endfor
endfunction

function! source#DirIf(path, func)
  for l:path in s:glob(a:path)
    call source#If(l:path, a:func)
  endfor
endfunction

function! s:glob(path)
  let l:files = globpath(expand(a:path), '*.vim')
  return split(l:files, '\n')
endfunction

function! s:source(path)
  if filereadable(expand(a:path))
    execute 'source' a:path
  endif
endfunction
