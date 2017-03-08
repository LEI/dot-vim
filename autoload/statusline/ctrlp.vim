" CtrlP

function! statusline#ctrlp#Load()
  return get(g:, 'loaded_ctrlp', 0)
endfunction

" Make sure ctrlp is installed and loaded
if !exists('g:loaded_ctrlp') || (exists('g:loaded_ctrlp') && !g:loaded_ctrlp)
  finish
endif

" Both functions must be global and return a full statusline
let g:ctrlp_status_func = {'main': 'StatusLine_CtrlP_Main', 'prog': 'StatusLine_CtrlP_Prog'}

" Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
"            a:1    a:2      a:3       a:4  a:5   a:6  a:7
function! StatusLine_CtrlP_Main(...)
  " let focus = '%#LineNr# '.a:1.' %*'
  " let byfname = '%#Character# '.a:2.' %*'
  " let regex = a:3 ? '%#LineNr# regex %*' : ''
  " let prv = ' <'.a:4.'>='
  " let item = '{%#Character# '.a:5.' %*}'
  " let nxt = '=<'.a:6.'>'
  " let marked = ' '.a:7.' '
  " let dir = ' %=%<%#LineNr# '.getcwd().' %*'
  let regex = a:3 ? ' regex ' : ''
  let prv = ' ' . a:4 . ' ' . s:sep
  let item = '%0* ' . a:5 . ' %*' . s:sep
  let nxt = ' ' . a:6 . ' '
  let marked = ' ' . a:7 . ' '
  let mid = '%='
  let focus = ' ' . a:1 . ' ' . s:sep
  let byfname = ' ' . a:2 . ' ' . s:sep
  let dir = '%<%0* ' . getcwd() . ' %*'
  " Return the full statusline
  return regex.prv.item.nxt.marked.mid.focus.byfname.dir
endfunction

" Argument: len
"           a:1
function! StatusLine_CtrlP_Prog(...)
  let len = '%0* ' . a:1 . ' '
  let dir = '%=' . s:sep . '%<%0* ' . getcwd() . ' %*'
  " Return the full statusline
  return len.dir
endfunction
