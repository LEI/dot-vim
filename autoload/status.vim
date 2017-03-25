" Status line

" set statusline=%!status#Line()

if exists('g:loaded_statusline')
  finish
endif

let g:loaded_statusline = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

let g:statusline = get(g:, 'statusline', {})
call extend(g:statusline, {'modes': {}, 'symbols': {}}, 'keep')

" Active window number
let g:statusline.winnr = winnr()

" Format Markers: {{{
" %< Where to truncate line if too long
" %n Buffer number
" %F Full path to the file in the buffed
" %f Relative path or as typed
" %t File name (tail)
" %m Modified flag [+] (modified), [-] (unmodifiable) or nothing
" %r Readonly flag [RO]
" %w Preview window flag
" %y Filetype [ruby]
" %= Separation point between left and right aligned items
" %l Current line number
" %L Number of lines in buffer
" %c Current column number
" %V Current virtual column number (-n), if different from %c
" %P Percentage through file of displayed window
" %( Start of item group (%-35. width and alignement of a section)
" %) End of item group
" }}}

" Modes: {{{
" n       Normal
" no      Operator-pending
" v       Visual by character
" V       Visual by line
" CTRL-V  Visual blockwise
" s       Select by character
" S       Select by line
" CTRL-S  Select blockwise
" i       Insert
" R       Replace |R|
" Rv      Virtual Replace |gR|
" c       Command-line
" cv      Vim Ex mode |gQ|
" ce      Normal Ex mode |Q|
" r       Hit-enter prompt
" rm      The -- more -- prompt
" r?      A confirm query of some sort
" !       Shell or external command is executing
call extend(g:statusline.modes, {
      \   'nc': '------',
      \   'n': 'NORMAL',
      \   'i': 'INSERT',
      \   'R': 'REPLACE',
      \   'v': 'VISUAL',
      \   'V': 'V-LINE',
      \   'c': 'COMMAND',
      \   '': 'V-BLOCK',
      \   's': 'SELECT',
      \   'S': 'S-LINE',
      \   '': 'S-BLOCK',
      \   't': 'TERMINAL',
      \ }, 'keep')
" }}}

" Symbols: {{{ (key: 0x1F511)
let s:c = has('multi_byte') && &encoding ==# 'utf-8'
call extend(g:statusline.symbols, {
      \   'key': s:c ? nr2char(0x1F511) : '$',
      \   'sep': s:c ? ' ' . nr2char(0x2502) . ' ' : ' ',
      \   'lock': s:c ? nr2char(0x1F512) : '@',
      \   'nl': s:c ? nr2char(0x2424) : '\n',
      \   'ws': s:c ? nr2char(0x39E) : '\s',
      \ }, 'keep')
" }}}

" Highlight Groups: {{{
highlight link StatusLineReverse StatusLine
highlight link StatusLineInsert StatusLine
highlight link StatusLineReplace StatusLine
highlight link StatusLineVisual StatusLine
" highlight link StatusLineBranch StatusLine
highlight link StatusLineError ErrorMsg
highlight link StatusLineWarn WarningMsg
" }}}

" Build status line
function! status#Line(...) abort
  let l:func = get(g:, 'statusline_func', '')
  " echom (l:func !=# '') . '/' . exists('*' . l:func)
  if l:func !=# '' && exists('*' . l:func)
    return call(l:func, a:000)
  endif
  " Default status line
  let l:name = a:0 && strlen(a:1) > 0 ? a:1 : '%f'
  let l:info = a:0 > 1 ? a:2 : get(g:statusline, 'right', '')
  return '%<' . l:name . ' %h%m%r%=' . l:info . '%-14.(%l,%c%V%) %P'
endfunction

function! status#QfTitle() abort
  return get(w:, 'quickfix_title', '')
endfunction

function! status#Hide(...) abort
  let l:bufvar = a:0 ? a:1 : ''
  let l:ignore_buftypes = 'help\|quickfix'
  let l:ignore_filetypes = 'dirvish\|netrw\|taglist\|qf\|vim-plug'
  " let l:buftypes = 'quickfix'
  if l:bufvar !=# '' && get(b:, l:bufvar . '_hidden', 0)
    return ''
  endif
  if l:bufvar ==# 'mode'
    if !&modifiable
      return ''
    endif
  elseif l:bufvar ==# 'branch'
    if &buftype =~# l:ignore_buftypes
      return ''
    endif
  elseif l:bufvar ==# 'flags'
    if &filetype =~# l:ignore_filetypes
      return ''
    endif
    " if &filetype ==# '' && &buftype ==# 'nofile'
    "   return '' " NetrwMessage
    " endif
  elseif l:bufvar ==# 'fileinfo'
    if &filetype ==# ''
      if &buftype !=# 'nofile'
        return &buftype
      endif
      return ''
    endif
  elseif l:bufvar ==# 'fileformat'
    if &filetype ==# '' && &buftype !=# '' && &buftype !=# 'nofile'
      return ''
    endif
    if &filetype =~# 'netrw' || &buftype =~# l:ignore_buftypes
      return ''
    endif
  endif
endfunction

" " v:vim_did_enter |!has('vim_starting')
" let s:enable = get(g:, 'status#enable_at_startup', 1)
" if s:enable
"   call status#Colors()
"   " call status#ctrlp#Enable()
" endif

augroup StatusGroup
  autocmd!
  " autocmd ColorScheme * call status#Colors()
  autocmd InsertEnter * call status#mode#highlight(v:insertmode)
  autocmd InsertChange * call status#mode#highlight(v:insertmode)
  autocmd InsertLeave * call status#mode#highlight()

  " autocmd WinEnter,FileType,BufWinEnter * let &l:statusline = status#Line()
  autocmd BufAdd,BufEnter,WinEnter * let g:statusline.winnr = winnr()

  " Update whitespace warnings (add InsertLeave?)
  autocmd BufWritePost,CursorHold * unlet! b:statusline_indent | unlet! b:statusline_trailing

  autocmd CmdWinEnter * let b:branch_hidden = 1 | let &l:statusline = status#Line('Command Line')
  " autocmd CmdWinLeave * unlet b:is_command_window

  autocmd FileType qf let &l:statusline = status#Line('%f%( %{status#QfTitle()}%)')
  autocmd FileType vim-plug let &l:statusline = status#Line('Plugins')
  autocmd FileType taglist let &l:statusline = status#Line(s:Replace_(expand('%')))
augroup END

function! s:Replace_(string) abort
  let l:str = a:string
  if matchstr(l:str, '__.*__') ==# ''
    return l:str
  endif
  let l:str = substitute(l:str, '__', '', 'g')
  let l:str = substitute(l:str, '_', ' ', 'g')
  return l:str
endfunction

" Default: %<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
command! -nargs=* -bar CursorStl let &g:statusline = status#Line('%f', '%([%b 0x%B]%)')

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim: et sts=2 sw=2 ts=2 foldenable foldmethod=marker
