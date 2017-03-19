" Init

" Check g:enable_{name}
function! config#Enabled(path)
  let l:name = fnamemodify(a:path, ':t:r')
  " !exists('g:enable_' . l:name) || g:enable_{l:name} == 0
  let l:enabled = get(g:, 'enable_' . l:name, 0) == 1
  " for l:pattern in get(g:, 'plugins_enable', [])
  "   if matchstr(l:name, l:pattern)
  "     let l:enabled = 1
  "     break
  "   endif
  " endfor
  " echom l:name . ' is ' . (l:enabled ? 'enabled' : 'disabled')
  return l:enabled
endfunction

function! config#Source(...)
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

function! config#SourceDir(...)
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
      call config#Source(l:path, l:fun)
    else
      call config#Source(l:path)
    endif
  endfor
endfunction

function! s:source(path)
  if !filereadable(expand(a:path))
    return 0
  endif
  execute 'source' a:path
endfunction
