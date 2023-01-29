" Status line

if !has('statusline')
  finish
endif

Pack 'itchyny/lightline.vim'

set noshowmode

augroup StatusLine
  autocmd!
  autocmd VimEnter,ColorScheme * call s:lightline_update()
  " autocmd User CocStatusChange redrawstatus
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
augroup END

" let g:coc_status_error_sign = 'x '
" let g:coc_status_warning_sign = '! '
"       \ 'component_function': {
"       \   'cocstatus': 'coc#status',
"       \   'currentfunction': 'CocCurrentFunction',
" function! CocCurrentFunction()
"     return get(b:, 'coc_current_function', '')
" endfunction

" :h lightline-problem-13
" augroup LightlineColorscheme
"   autocmd!
"   autocmd ColorScheme * call s:lightline_update()
" augroup END
function! s:lightline_update()
  if !exists('g:loaded_lightline')
    return
  endif
  try
    if g:colors_name =~# 'wombat\|solarized\|landscape\|jellybeans\|seoul256\|Tomorrow'
      let l:str = substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '')

      " Quickfix solarized8
      if l:str ==# 'solarized8'
        let l:str = substitute(l:str, '8$', '', '')
        " https://github.com/itchyny/lightline.vim/issues/548#issuecomment-777255645
        execute 'source' globpath(&rtp, 'autoload/lightline/colorscheme/solarized.vim')
      endif

      let g:lightline.colorscheme = l:str
      call lightline#init()
      call lightline#colorscheme()
      call lightline#update()

      if &background ==# 'dark'
        " let g:lightline#colorscheme#solarized#palette.normal.error = [['#002b36', '#dc322f', '234', '124']]
        " let g:lightline#colorscheme#solarized#palette.normal.error = [['#dc322f', '#002b36', '124', '234' ]]
        let g:lightline#colorscheme#solarized#palette.normal.error = [['#fdf6e3', '#dc322f', '230', '124']]
      " else
      "   let g:lightline#colorscheme#solarized#palette.normal.error = [['#fdf6e3', '#dc322f', '230', '124']]
      endif
    endif
  catch
  endtry
endfunction

" :h g:lightline.component
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'head', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'tags', 'fileformat', 'fileencoding', 'filetype' ], ['coc_error', 'coc_warning', 'coc_hint', 'coc_info' ] ],
      \ },
      \ 'colorscheme': 'solarized',
      \ 'component': {
      \   'git': '%{FugitiveStatusline()}',
      \   'head': '%{FugitiveHead()}',
      \   'hex': '0x%B',
      \ },
      \ 'component_expand': {
      \   'coc_error': 'LightlineCocErrors',
      \   'coc_warning': 'LightlineCocWarnings',
      \   'coc_info': 'LightlineCocInfos',
      \   'coc_hint': 'LightlineCocHints',
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_function': {
      \   'fileencoding': 'LightlineFileencoding',
      \   'fileformat': 'LightlineFileformat',
      \   'filename': 'LightlineFilename',
      \   'filetype': 'LightlineFiletype',
      \   'fugitive': 'LightlineFugitive',
      \   'mode': 'LightlineMode',
      \   'tags': 'gutentags#statusline',
      \ },
      \ 'component_type': {
      \ },
      \ 'enable': {
      \   'statusline': 1,
      \   'tabline': 1,
      \ },
      \ }

" https://github.com/neoclide/coc.nvim/issues/401#issuecomment-469051524
      " \   'coc_fix': 'middle',
let g:lightline.component_type = {
      \   'coc_error': 'error',
      \   'coc_hint': 'middle',
      \   'coc_info': 'tabsel',
      \   'coc_warning': 'warning',
      \   'syntastic': 'error',
      \ }

function! s:lightline_coc_diagnostic(kind, sign) abort
  let info = get(b:, 'coc_diagnostic_info', 0)
  if empty(info) || get(info, a:kind, 0) == 0
    return ''
  endif
  try
    let s = g:coc_user_config['diagnostic'][a:sign . 'Sign']
  catch
    let s = ''
  endtry
  return printf('%s %d', s, info[a:kind])
endfunction

function! LightlineCocErrors() abort
  return s:lightline_coc_diagnostic('error', 'error')
endfunction

function! LightlineCocWarnings() abort
  return s:lightline_coc_diagnostic('warning', 'warning')
endfunction

function! LightlineCocInfos() abort
  return s:lightline_coc_diagnostic('information', 'info')
endfunction

function! LightlineCocHints() abort
  return s:lightline_coc_diagnostic('hints', 'hint')
endfunction

let g:lightline.mode_map = {
      \ 'n' : 'NORMAL',
      \ 'i' : 'INSERT',
      \ 'R' : 'REPLACE',
      \ 'v' : 'VISUAL',
      \ 'V' : 'V-LINE',
      \ "\<C-v>": 'V-BLOCK',
      \ 'c' : 'COMMAND',
      \ 's' : 'SELECT',
      \ 'S' : 'S-LINE',
      \ "\<C-s>": 'S-BLOCK',
      \ 't': 'TERMINAL',
      \ }

let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '|', 'right': '' }

function! LightlineModified()
  return &ft ==# 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightlineFilename()
  let fname = expand('%:t')
  return fname ==# 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname =~# '^__Tagbar__\|__Gundo\|NERD_tree' ? '' :
        \ &ft ==# 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft ==# 'unite' ? unite#get_status_string() :
        \ &ft ==# 'vimshell' ? vimshell#get_status_string() :
        \ (LightlineReadonly() !=# '' ? LightlineReadonly() . ' ' : '') .
        \ (fname !=# '' ? fname : '[No Name]') .
        \ (LightlineModified() !=# '' ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*FugitiveHead')
      let mark = ''  " edit here for cool mark
      let branch = FugitiveHead()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  " let fname = expand('%:t')
  " return fname =~# '^__Tagbar__' ? 'Tagbar' :
  "       \ fname ==# 'ControlP' ? 'CtrlP' :
  "       \ fname ==# '__Gundo__' ? 'Gundo' :
  "       \ fname ==# '__Gundo_Preview__' ? 'Gundo Preview' :
  "       \ fname =~# 'NERD_tree' ? 'NERDTree' :
  "       \ &ft ==# 'unite' ? 'Unite' :
  "       \ &ft ==# 'vimfiler' ? 'VimFiler' :
  "       \ &ft ==# 'vimshell' ? 'VimShell' :
  "       \ winwidth(0) > 60 ? lightline#mode() : ''
  return lightline#mode()
endfunction

" function! CtrlPMark()
"   if expand('%:t') ==# 'ControlP' && has_key(g:lightline, 'ctrlp_item')
"     call lightline#link('iR'[g:lightline.ctrlp_regex])
"     return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
"           \ , g:lightline.ctrlp_next], 0)
"   else
"     return ''
"   endif
" endfunction

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
  return lightline#statusline(0)
endfunction

" Syntastic can call a post-check hook, let's update lightline there
" For more information: :help syntastic-loclist-callback
function! SyntasticCheckHook(errors)
  call lightline#update()
endfunction

" let g:unite_force_overwrite_statusline = 0
" let g:vimfiler_force_overwrite_statusline = 0
" let g:vimshell_force_overwrite_statusline = 0
