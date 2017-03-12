" Status line

" set statusline=%!statusline#Build()

if exists('g:loaded_statusline')
  finish
endif

let g:loaded_statusline = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Format Markers:
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
let g:statusline = get(g:, 'statusline', {})
call extend(g:statusline, {'modes': {}, 'symbols': {}}, 'keep')

function! statusline#Build(...) abort
  let l:bufname = a:0 && strlen(a:1) > 0 ? a:1 : '%f'
  " Mode
  let l:paste = '%1*%( %{&paste ? "PASTE" : ""} %)%*%< '
  let l:mode = '%(%{winwidth(0) > 60 && &modifiable ? statusline#f#Mode() : ""}' . g:statusline.symbols.sep . '%)'
  " Git branch
  let l:branch = '%(%{winwidth(0) > 90 ? statusline#f#Branch() : ""}' . g:statusline.symbols.sep . '%)'
  " Flags [%W%H%R%M]
  let l:flags = '%( [%{statusline#f#Flags()}]%)'
  " Warnings
  let l:warn = '%#StatusLineWarn#%('
  let l:warn.= '%( %{statusline#f#Indent()}%)' " &bt nofile, nowrite
  let l:warn.= '%( %{empty(&bt) ? statusline#f#Trailing() : ""}%)'
  let l:warn.= ' %)%*'
  " Errors
  let l:err = '%#StatusLineError#%('
  let l:err.= '%( %{exists("g:loaded_syntastic_plugin") ? SyntasticStatuslineFlag() : ""}%)'
  let l:err.= '%( %{exists("*neomake#Make") ? neomake#statusline#f#QflistStatus("qf: ") : ""}%)'
  let l:err.= '%( %{exists("*neomake#Make") ? neomake#statusline#f#LoclistStatus() : ""}%)'
  let l:err.= '%( %{exists("g:loaded_ale") ? ALEGetStatusLine() : ""}%)'
  let l:err.= ' %)%*'
  " File type
  let l:type = '%(%{winwidth(0) > 30 ? statusline#f#FileType() : ""}' . g:statusline.symbols.sep . '%)'
  " File encoding
  let l:info = '%(%{winwidth(0) > 60 ? statusline#f#FileInfo() : ""}' . g:statusline.symbols.sep . '%)'
  " Default ruler
  let l:ruler = '%-14.(%l,%c%V/%L%) %P '

  let l:left = l:paste . l:mode . l:branch . l:bufname . l:flags
  let l:right = l:warn . l:err . ' ' . l:type . l:info . l:ruler
  return l:left . '%= ' . l:right
endfunction

" Modes:
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

" Symbols: (key: 0x1F511)
let s:c = has('multi_byte') && &encoding ==# 'utf-8'
call extend(g:statusline.symbols, {
      \   'key': s:c ? nr2char(0x1F511) : '$',
      \   'sep': s:c ? ' ' . nr2char(0x2502) . ' ' : ' ',
      \   'lock': s:c ? nr2char(0x1F512) : '@',
      \   'nl': s:c ? nr2char(0x2424) : '\n',
      \   'ws': s:c ? nr2char(0x39E) : '\s',
      \ }, 'keep')

function! Statusline_dark() abort
    highlight User1 term=reverse ctermfg=14 ctermbg=0
    " highlight StatusLineNormal ctermfg=0 ctermbg=4
    "term=reverse cterm=reverse ctermfg=14 ctermbg=0 gui=bold,reverse
    highlight StatusLineInsert cterm=NONE ctermfg=0 ctermbg=2 gui=NONE guifg=#073642 guibg=#859900
    highlight StatusLineReplace cterm=NONE ctermfg=0 ctermbg=9 gui=NONE guifg=#073642 guibg=#cb4b16
    highlight StatusLineVisual cterm=NONE ctermfg=0 ctermbg=3 gui=NONE guifg=#073642 guibg=#b58900
endfunction

function! Statusline_light() abort
    highlight User1 term=reverse ctermfg=10 ctermbg=7
    " highlight StatusLineNormal ctermfg=7 ctermbg=4
    "term=reverse cterm=reverse ctermfg=10 ctermbg=7 gui=bold,reverse
    highlight StatusLineInsert cterm=NONE ctermfg=7 ctermbg=2 gui=NONE guifg=#eee8d5 guibg=#859900
    highlight StatusLineReplace cterm=NONE ctermfg=7 ctermbg=9 gui=NONE guifg=#eee8d5 guibg=#cb4b16
    highlight StatusLineVisual cterm=NONE ctermfg=7 ctermbg=3 gui=NONE guifg=#eee8d5 guibg=#b58900
endfunction

function! statusline#Colors() abort
  " Reverse: cterm=NONE gui=NONE | ctermfg=bg ctermbg=fg
  " highlight link StatusLineBranch StatusLine
  " highlight StatusLineError cterm=NONE ctermfg=7 ctermbg=1 gui=NONE guifg=#eee8d5 guibg=#cb4b16
  " highlight StatusLineWarn cterm=NONE ctermfg=7 ctermbg=9 gui=NONE guifg=#eee8d5 guibg=#dc322f
  highlight StatusLineError cterm=reverse ctermfg=1 gui=reverse guifg=#cb4b16
  highlight StatusLineWarn cterm=reverse ctermfg=9 gui=reverse guifg=#dc322f
  let l:f = 'Statusline_' . &background
  if exists('*' . l:f)
    call {l:f}()
  endif
endfunction

function! statusline#Highlight(...) abort
  let l:im = a:0 ? a:1 : ''
  " let l:im = a:0 ? a:1 : v:insertmode
  if l:im ==# 'i' " Insert mode
    highlight! link StatusLine StatusLineInsert
  elseif l:im ==# 'r' " Replace mode
    highlight! link StatusLine StatusLineReplace
  elseif l:im ==# 'v' " Virtual replace mode
    highlight! link StatusLine StatusLineReplace
  elseif strlen(l:im) > 0
    echoerr 'Unknown mode: ' . l:im
  else
    highlight link StatusLine NONE
  endif
endfunction

function! statusline#Enable() abort
  " Apply colors
  call statusline#Colors()
  " Enable customized CtrlP status line
  if get(g:, 'loaded_ctrlp', 0)
    call statusline#ctrlp#Enable()
  endif
endfunction

" v:vim_did_enter |!has('vim_starting')
let s:enable = get(g:, 'statusline#enable_at_startup', 1)
if s:enable
  call statusline#Enable()
endif

" Initialize active window number
let g:statusline.winnr = winnr()

augroup StatusLine
  autocmd!
  autocmd ColorScheme * call statusline#Colors() | redrawstatus
  autocmd InsertEnter * call statusline#Highlight(v:insertmode)
  autocmd InsertChange * call statusline#Highlight(v:insertmode)
  autocmd InsertLeave * call statusline#Highlight()

  autocmd BufAdd,BufEnter,WinEnter * let g:statusline.winnr = winnr()

  " Update whitespace warnings (add InsertLeave?)
  autocmd BufWritePost,CursorHold * unlet! b:statusline_indent | unlet! b:statusline_trailing

  autocmd CmdWinEnter * let b:branch_hidden = 1 | let &l:statusline = statusline#Build('Command Line')
  " autocmd CmdWinLeave * unlet b:is_command_window

  autocmd FileType qf let &l:statusline = statusline#Build('%f%( %{statusline#f#QuickFixTitle()}%)')
  autocmd FileType vim-plug let &l:statusline = statusline#Build(' Plugins')
augroup END

" %<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
command! -nargs=* -bar CursorStl let &g:statusline = statusline#Build('%f %([%b 0x%B]%)')

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim: foldenable foldmethod=marker et sts=2 sw=2 ts=2
