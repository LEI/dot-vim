" Mkdir

" Create directory
function! mkdir#Mkdir(...)
  let l:dir = a:0 ? a:1 : expand('%:p:h')
  if a:0 > 1
    echoerr 'Too many arguments'
    return 1
  endif
  if isdirectory(l:dir)
    return l:dir
  endif
  if exists('*mkdir')
    call mkdir(l:dir, 'p')
  else
    execute '!mkdir' l:dir
  endif
  echo 'Created non-existing directory: ' . l:dir
  return l:dir
endfunction

" Confirm directory creation
function mkdir#Ask(...)
  let l:dir = a:0 ? a:1 : expand('%:p:h')
  if a:0 > 1
    echoerr 'Too many arguments'
    return
  endif
  if isdirectory(l:dir)
    return l:dir
  endif
  if confirm("Directory '" . l:dir . "' doesn't exists.", '&Create it?') == 0
    return ''
  endif
  return mkdir#Mkdir(l:dir)
endfunction

" Set global variable and create directory
function! mkdir#Var(name, path)
  if !exists('g:' . a:name) || g:{a:name} ==# '' " !isdirectory(g:{a:name})
    let g:{a:name} = a:path
  endif
  let l:dir = g:{a:name}
  return mkdir#Mkdir(l:dir)
endfunction
