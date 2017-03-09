" CtrlP

" Make sure ctrlp is installed and loaded
if !exists('g:loaded_ctrlp') || (exists('g:loaded_ctrlp') && !g:loaded_ctrlp)
  finish
endif

function! statusline#ctrlp#enable() abort
  " Both functions must be global and return a full statusline
  let g:ctrlp_status_func = {'main': 'statusline#ctrlp#main', 'prog': 'statusline#ctrlp#prog'}
endfunction

" Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
"            a:1    a:2      a:3       a:4  a:5   a:6  a:7
function! statusline#ctrlp#main(...) abort
  " let focus = '%#LineNr# '.a:1.' %*'
  " let byfname = '%#Character# '.a:2.' %*'
  " let regex = a:3 ? '%#LineNr# regex %*' : ''
  " let prv = ' <'.a:4.'>='
  " let item = '{%#Character# '.a:5.' %*}'
  " let nxt = '=<'.a:6.'>'
  " let marked = ' '.a:7.' '
  " let dir = ' %=%<%#LineNr# '.getcwd().' %*'
  let l:regex = a:3 ? ' regex ' : ''
  let l:prv = ' ' . a:4 . ' ' . g:statusline_sep
  let l:item = '%0* ' . a:5 . ' %*' . g:statusline_sep
  let l:nxt = ' ' . a:6 . ' '
  let l:marked = ' ' . a:7 . ' '
  let l:mid = '%='
  let l:focus = ' ' . a:1 . ' ' . g:statusline_sep
  let l:byfname = ' ' . a:2 . ' ' . g:statusline_sep
  let l:dir = '%<%0* ' . getcwd() . ' %*'
  return l:regex . l:prv . l:item . l:nxt . l:marked . l:mid . l:focus . l:byfname . l:dir
endfunction

" Argument: len
"           a:1
function! statusline#ctrlp#prog(...) abort
  let l:len = '%0* ' . a:1 . ' '
  let l:dir = '%=' . g:statusline_sep . '%<%0* ' . getcwd() . ' %*'
  return l:len . l:dir
endfunction
