" CtrlP

" Make sure ctrlp is installed and loaded
" if !exists('g:loaded_ctrlp') || (exists('g:loaded_ctrlp') && !g:loaded_ctrlp)
" if !get(g:, 'loaded_ctrlp', 0)
"   finish
" endif

" function! status#ctrlp#Enable() abort
"   " Both functions must be global and return a full statusline
"   let g:ctrlp_status_func = {'main': 'status#ctrlp#Main', 'prog': 'status#ctrlp#Prog'}
" endfunction

" Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
"            a:1    a:2      a:3       a:4  a:5   a:6  a:7
function! statusline#ctrlp#Main(...) abort
  " let focus = '%#LineNr# '.a:1.' %*'
  " let byfname = '%#Character# '.a:2.' %*'
  " let regex = a:3 ? '%#LineNr# regex %*' : ''
  " let prv = ' <'.a:4.'>='
  " let item = '{%#Character# '.a:5.' %*}'
  " let nxt = '=<'.a:6.'>'
  " let marked = ' '.a:7.' '
  " let dir = ' %=%<%#LineNr# '.getcwd().' %*'
  let l:regex = a:3 ? '%1* regex %*' : ' '
  let l:prv = a:4 . ' '
  let l:item = '%1* ' . a:5 . ' %* '
  let l:nxt = a:6 . ' '
  let l:marked = a:7 . ' '
  let l:focus = a:1 . ' ' " g:statusline.symbols.sep
  let l:byfname = '%1* ' . a:2 . ' %* ' " g:statusline.symbols.sep
  let l:dir = getcwd() . ' '
  return l:regex . l:prv . l:item . l:nxt . l:marked . '%=' . '%<' . l:focus . l:byfname . l:dir
endfunction

" Argument: len
"           a:1
function! statusline#ctrlp#Prog(...) abort
  let l:len = a:1
  let l:dir = getcwd()
  return ' ' . l:len . '%=%<' . l:dir . ' '
endfunction
