" Status line

" set statusline=%!statusline#Build()

if exists('g:loaded_statusline')
  finish
endif

let g:loaded_statusline = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" Variables {{{1

let g:statusline_winnr = winnr()

let g:statusline#enable_at_startup = get(g:, 'statusline#enable_at_startup', 1)

let g:statusline#sep = '|'
if has('multi_byte') && &encoding ==# 'utf-8'
  let g:statusline#sep = nr2char(0x2502)
endif

" Build {{{1

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

function! statusline#Build(...) abort
  let l:name = a:0 && strlen(a:1) > 0 ? a:1 : '%f'
  " Mode
  let l:paste = '%1*%( %{&paste ? "PASTE" : ""} %)%*'
  let l:mode = '%( %{winwidth(0) > 40 && &modifiable ? statusline#Mode() : ""} ' . g:statusline#sep . '%)'
  " Git branch
  let l:branch = '%( %{winwidth(0) > 80 ? statusline#Branch() : ""} ' . g:statusline#sep . '%)'
  " Buffer name
  let l:buffer = ' ' . l:name
  " Flags [%W%H%R%M]
  let l:flags = '%( [%{statusline#Flags()}]%)'
  " Warnings
  let l:warn = '%#StatusLineWarn#%('
  let l:warn.= '%( %{statusline#Indent()}%)' " &bt nofile, nowrite
  let l:warn.= '%( %{empty(&bt) ? statusline#Trailing() : ""}%)'
  let l:warn.= ' %)%*'
  " Errors
  let l:err = '%#StatusLineError#%('
  let l:err.= '%( %{exists("g:loaded_syntastic_plugin") ? SyntasticStatuslineFlag() : ""}%)'
  let l:err.= '%( %{exists("*neomake#Make") ? neomake#statusline#QflistStatus("qf: ") : ""}%)'
  let l:err.= '%( %{exists("*neomake#Make") ? neomake#statusline#LoclistStatus() : ""}%)'
  let l:err.= '%( %{exists("g:loaded_ale") ? ALEGetStatusLine() : ""}%)'
  let l:err.= ' %)%*'
  " File type
  let l:type = '%( %{winwidth(0) > 40 ? statusline#FileType() : ""} ' . g:statusline#sep . '%)'
  " File encoding
  let l:info = '%( %{winwidth(0) > 80 ? statusline#FileInfo() : ""} ' . g:statusline#sep . '%)'
  " Default ruler
  let l:ruler = ' %-14.(%l,%c%V/%L%) %P '

  let l:left = l:paste . l:mode . '%<' . l:branch . l:buffer . l:flags
  let l:right = l:warn . l:err . l:type . l:info . l:ruler
  return l:left . '%=' . l:right
endfunction

" Functions {{{1

" Get the current mode and update SatusLine highlight group {{{2

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
let g:statusline_modes = {
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
\ }

function! statusline#Mode(...) abort
  let l:mode =  a:0 ? a:1 :mode()
  " if l:mode ==# 'n'
  "   highlight! link StatusLine StatusLineNormal
  " elseif l:mode ==# 'i'
  "   highlight! link StatusLine StatusLineInsert
  " elseif l:mode ==# 'R'
  "   highlight! link StatusLine StatusLineReplace
  " elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# '^V'
  "   highlight! link StatusLine StatusLineVisual
  " endif
  if g:statusline_winnr != winnr()
    let l:mode = 'nc'
  endif
  return get(g:statusline_modes, l:mode, l:mode)
endfunction

" Display the branch of the cwd if applicable {{{2

function! statusline#Branch() abort
  " &bt !~ 'nofile\|quickfix'
  if !exists('*fugitive#head') || &buftype ==# 'quickfix'
    return ''
  endif
  if exists('b:branch_hidden') && b:branch_hidden == 1
    return ''
  endif
  return fugitive#head(7)
endfunction

" Buffer flags {{{2

function! statusline#Flags() abort
  if &filetype ==# 'netrw' && get(b:, 'netrw_browser_active', 0) == 1
    let l:netrw_direction = (g:netrw_sort_direction =~# 'n' ? '+' : '-')
    return g:netrw_sort_by . l:netrw_direction
  endif
  if &filetype =~# 'netrw\|vim-plug' || &buftype ==# 'quickfix'
    return ''
  endif
  if &filetype ==# '' && &buftype ==# 'nofile'
    return '' " NetrwMessage
  endif
  if &buftype ==# 'help'
    return 'H'
  endif
  let l:flags = []
  if &previewwindow
    call add(l:flags, 'PRV')
  endif
  if &readonly
    call add(l:flags, 'RO')
  endif
  if &modified
    call add(l:flags, '+')
  elseif !&modifiable
    call add(l:flags, '-')
  endif
  return join(l:flags, ',')
endfunction

" File or buffer type {{{2

function! statusline#FileType() abort
  if &filetype ==# ''
    if &buftype !=# 'nofile'
      return &buftype
    endif
    return ''
  endif
  " if &filetype ==# 'qf'
  "   return &buftype
  " endif
  return &filetype
endfunction

" File encoding and format {{{2

function! statusline#FileInfo() abort
  if &filetype ==# '' && &buftype !=# 'nofile'
    return ''
  endif
  if &filetype =~# 'netrw' || &buftype =~# 'help\|quickfix'
    return ''
  endif
  if strlen(&fileencoding) > 0
    let l:enc = &fileencoding
  else
    let l:enc = &encoding
  endif
  if exists('+bomb') && &bomb
    let l:enc.= ',B'
  endif
  if l:enc ==# 'utf-8'
    return ''
  endif
  if &fileformat !=# 'unix'
    let l:enc.= '[' . &fileformat . ']'
  endif
  return l:enc
endfunction

" Whitespace warnings {{{2

function! statusline#Indent() abort
  if !exists('b:statusline_indent')
    let b:statusline_indent = ''
    if !&modifiable
      return b:statusline_indent
    endif
    " Find spaces that arent used as alignment in the first indent column
    let l:spaces = search('^ \{' . &tabstop . ',}[^\t]', 'nw')
    let l:tabs = search('^\t', 'nw')
    if l:tabs != 0 && l:spaces != 0
      " Spaces and tabs are used to indent
      let b:statusline_indent = 'mixed-'
      if !&expandtab
        let b:statusline_indent.= 'spaces:' . l:spaces
      else
        let b:statusline_indent.= 'tabs:' . l:tabs
      endif
    elseif l:spaces != 0 && !&expandtab
      let b:statusline_indent = 'spaces:' . l:spaces
    elseif l:tabs != 0 && &expandtab
      let b:statusline_indent = 'tabs:' .l:tabs
    endif
  endif
  return b:statusline_indent
endfunction

function! statusline#Trailing() abort
  if !exists('b:statusline_trailing')
    let l:msg = ''
    let l:match = search('\s\+$', 'nw')
    if l:match != 0
      let l:msg = 'trailing:' . l:match " '\s$'
    endif
    let b:statusline_trailing = l:msg
  endif
  return b:statusline_trailing
endfunction

" Colors {{{1

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
  highlight StatusLineError cterm=NONE ctermfg=bg ctermbg=1 gui=NONE guifg=bg guibg=#cb4b16
  highlight StatusLineWarn cterm=NONE ctermfg=bg ctermbg=9 gui=NONE guifg=bg guibg=#dc322f
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

" Autocommands {{{1

augroup StatusLine
  autocmd!
  autocmd ColorScheme * call statusline#Colors() | redrawstatus
  autocmd InsertEnter * call statusline#Highlight(v:insertmode)
  autocmd InsertChange * call statusline#Highlight(v:insertmode)
  autocmd InsertLeave * call statusline#Highlight()

  autocmd BufAdd,BufEnter,WinEnter * let g:statusline_winnr = winnr()

  " Update whitespace warnings (add InsertLeave?)
  autocmd BufWritePost,CursorHold * unlet! b:statusline_indent | unlet! b:statusline_trailing

  autocmd CmdWinEnter * let b:branch_hidden = 1 | let &l:statusline = statusline#Build('Command Line')
  " autocmd CmdWinLeave * unlet b:is_command_window

  autocmd FileType qf let &l:statusline = statusline#Build(s:quickfix_title())
  autocmd FileType vim-plug let &l:statusline = statusline#Build('Plugins')
augroup END

" Quickfix or location list title
function! s:quickfix_title() abort
  let l:title = '%f'
  " if get(g:, 'loaded_neomake', 0)
  "   let l:title = 'Location List ' . g:statusline#sep
  " endif
  let l:qf = get(w:, 'quickfix_title', '')
  if strlen(l:qf)
    let l:title.= ' ' . l:qf
  endif
  return l:title
endfunction

" }}}

function! statusline#Enable() abort
  " Apply colors
  call statusline#Colors()
  " Enable customized CtrlP status line
  if get(g:, 'loaded_ctrlp', 0)
    call statusline#ctrlp#Enable()
  endif
endfunction

" v:vim_did_enter |!has('vim_starting')
if g:statusline#enable_at_startup
  call statusline#Enable()
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim: foldenable foldmethod=marker et sts=2 sw=2 ts=2
