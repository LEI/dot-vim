" Status line

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

let s:sep = '|'
if has('multi_byte') && &encoding ==# 'utf-8'
  let s:sep = nr2char(0x2502)
endif

function! statusline#Build(...) abort
  let l:name = a:0 ? a:1 : ''
  " Mode
  let l:paste = '%1*%( %{&paste ? "PASTE" : ""} %)%0*'
  let l:mode = '%( %{winwidth(0) > 40 && &modifiable ? statusline#Mode() : ""} ' . s:sep . '%)'
  " Git branch
  let l:branch = '%( %{winwidth(0) > 80 ? statusline#Branch() : ""} ' . s:sep . '%)'
  " Buffer name
  let l:buffer = ' ' . (len(l:name) > 0 ? l:name : '%f')
  " Flags [%W%H%R%M]
  let l:flags = '%( [%{statusline#Flags()}]%)'
  " Warnings
  let l:warn = '%#StatusLineWarn#%('
  let l:warn.= '%( %{statusline#Indent()}%)' " &bt nofile, nowrite
  let l:warn.= '%( %{empty(&bt) ? statusline#Trailing() : ""}%)'
  let l:warn.= ' %)%0*'
  " Errors
  let l:err = '%#StatusLineError#'
  let l:err.= '%( %{statusline#Errors()} %)'
  let l:err.= '%0*'
  " File type
  let l:type = '%( %{winwidth(0) > 40 ? statusline#FileType() : ""} ' . s:sep . '%)'
  " File encoding
  let l:info = '%( %{winwidth(0) > 80 ? statusline#FileInfo() : ""} ' . s:sep . '%)'
  " Default ruler
  let l:ruler = ' %-14.(%l,%c%V/%L%) %P '

  let l:left = l:paste . l:mode . '%<' . l:branch . l:buffer . l:flags
  let l:right = l:warn . l:err . l:type . l:info . l:ruler
  return l:left . ' %=' . l:right
endfunction

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

function! statusline#Flags() abort
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
  if &filetype ==# 'netrw' && get(b:, 'netrw_browser_active', 0) == 1
    let l:netrw_direction = (g:netrw_sort_direction =~# 'n' ? '+' : '-')
    return g:netrw_sort_by . '['. l:netrw_direction . '] ' . &filetype
  endif
  return &filetype
endfunction

function! statusline#FileInfo() abort
  if &filetype ==# '' && &buftype !=# 'nofile'
    return ''
  endif
  if &filetype =~# 'netrw' || &buftype =~# 'help\|quickfix'
    return ''
  endif
  let l:str = ''
  if strlen(&fileencoding) > 0
    let l:str.= &fileencoding
  else
    let l:str.= &encoding
  endif
  if exists('+bomb') && &bomb
    let l:str.= ',B'
  endif
  if &fileformat !=# 'unix'
    let l:str.= '[' . &fileformat . ']'
  endif
  return l:str
endfunction

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

function! statusline#Errors() abort
  let l:str = ''
  if exists('*neomake#Make')
    if !empty(neomake#statusline#QflistCounts())
      let l:str.= neomake#statusline#QflistStatus('qf: ')
    endif
    if !empty(neomake#statusline#LoclistCounts())
      let l:str.= neomake#statusline#LoclistStatus()
    endif
  endif
  if exists('g:loaded_syntastic_plugin')
    let l:str.= SyntasticStatuslineFlag()
  endif
  return l:str
endfunction

function! statusline#Colors() abort
  highlight link StatusLineBranch StatusLine
  highlight StatusLineError cterm=NONE ctermfg=7 ctermbg=1 gui=NONE guifg=#eee8d5 guibg=#cb4b16
  highlight StatusLineWarn cterm=NONE ctermfg=7 ctermbg=9 gui=NONE guifg=#eee8d5 guibg=#dc322f
  " Reverse: cterm=NONE gui=NONE | ctermfg=bg ctermbg=fg
  if &background ==# 'dark'
    highlight User1 term=reverse ctermfg=14 ctermbg=0
    " highlight StatusLineNormal ctermfg=0 ctermbg=4
    "term=reverse cterm=reverse ctermfg=14 ctermbg=0 gui=bold,reverse
    highlight StatusLineInsert cterm=NONE ctermfg=0 ctermbg=2 gui=NONE guifg=#073642 guibg=#859900
    highlight StatusLineReplace cterm=NONE ctermfg=0 ctermbg=9 gui=NONE guifg=#073642 guibg=#cb4b16
    highlight StatusLineVisual cterm=NONE ctermfg=0 ctermbg=3 gui=NONE guifg=#073642 guibg=#b58900
  else
    highlight User1 term=reverse ctermfg=10 ctermbg=7
    " highlight StatusLineNormal ctermfg=7 ctermbg=4
    "term=reverse cterm=reverse ctermfg=10 ctermbg=7 gui=bold,reverse
    highlight StatusLineInsert cterm=NONE ctermfg=7 ctermbg=2 gui=NONE guifg=#eee8d5 guibg=#859900
    highlight StatusLineReplace cterm=NONE ctermfg=7 ctermbg=9 gui=NONE guifg=#eee8d5 guibg=#cb4b16
    highlight StatusLineVisual cterm=NONE ctermfg=7 ctermbg=3 gui=NONE guifg=#eee8d5 guibg=#b58900
  endif
endfunction

function! statusline#InsertMode(...) abort
  let l:insertmode = a:0 ? a:1 : v:insertmode
  if l:insertmode ==# 'i' " Insert mode
    highlight! link StatusLine StatusLineInsert
  elseif l:insertmode ==# 'r' " Replace mode
    highlight! link StatusLine StatusLineReplace
  elseif l:insertmode ==# 'v' " Virtual replace mode
    highlight! link StatusLine StatusLineReplace
  elseif strlen(l:insertmode) > 0
    echoerr 'Unknown mode: ' . l:insertmode
  else
    highlight link StatusLine NONE
  endif
endfunction

function! statusline#Mode(...) abort
  let l:mode = a:0 ? a:1 : mode()
  if exists('g:statusline_insertmode') && strlen(g:statusline_insertmode) > 0
    call statusline#InsertMode(g:statusline_insertmode)
  " elseif l:mode ==# 'n'
  "   highlight! link StatusLine StatusLineNormal
  elseif l:mode ==# 'i'
    highlight! link StatusLine StatusLineInsert
  elseif l:mode ==# 'R'
    highlight! link StatusLine StatusLineReplace
  " elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# '^V'
  "   highlight! link StatusLine StatusLineVisual
  else
    highlight link StatusLine NONE
  endif
  return get(g:statusline_modes, l:mode, l:mode)
endfunction

" autocmd VimEnter * let &statusline = statusline#Build()
" set statusline=%!statusline#Build()
augroup StatusLine
  autocmd!
  autocmd VimEnter,ColorScheme * call statusline#Colors() | redrawstatus
  autocmd InsertEnter * let g:statusline_insertmode = v:insertmode | call statusline#Mode()
  autocmd InsertChange * let g:statusline_insertmode = v:insertmode | call statusline#Mode()
  autocmd InsertLeave * unlet g:statusline_insertmode | call statusline#Mode()
  " | redrawstatus

  " Update whitespace warnings
  autocmd BufWritePost,CursorHold,InsertLeave * unlet! b:statusline_indent | unlet! b:statusline_trailing

  autocmd CmdWinEnter * let b:branch_hidden = 1 | let &l:statusline = statusline#Build('Command Line')
  " autocmd CmdWinLeave * unlet b:is_command_window

  " Quickfix or location list title
  autocmd FileType qf let &l:statusline = statusline#Build('%f' . (exists('w:quickfix_title') ? ' ' . w:quickfix_title : ''))
  autocmd FileType vim-plug let &l:statusline = statusline#Build('Plugins')
augroup END

if !has('vim_starting') " v:vim_did_enter
  call statusline#Colors()
endif

 " Make sure ctrlp is installed and loaded
if !exists('g:loaded_ctrlp') || (exists('g:loaded_ctrlp') && !g:loaded_ctrlp)
  finish
endif

" Both functions must be global and return a full statusline
let g:ctrlp_status_func = {'main': 'StatusLine_CtrlP_Main', 'prog': 'StatusLine_CtrlP_Prog'}

" Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
"            a:1    a:2      a:3       a:4  a:5   a:6  a:7
function! StatusLine_CtrlP_Main(...) abort
  " let focus = '%#LineNr# '.a:1.' %*'
  " let byfname = '%#Character# '.a:2.' %*'
  " let regex = a:3 ? '%#LineNr# regex %*' : ''
  " let prv = ' <'.a:4.'>='
  " let item = '{%#Character# '.a:5.' %*}'
  " let nxt = '=<'.a:6.'>'
  " let marked = ' '.a:7.' '
  " let dir = ' %=%<%#LineNr# '.getcwd().' %*'
  let l:regex = a:3 ? ' regex ' : ''
  let l:prv = ' ' . a:4 . ' ' . s:sep
  let l:item = '%0* ' . a:5 . ' %*' . s:sep
  let l:nxt = ' ' . a:6 . ' '
  let l:marked = ' ' . a:7 . ' '
  let l:mid = '%='
  let l:focus = ' ' . a:1 . ' ' . s:sep
  let l:byfname = ' ' . a:2 . ' ' . s:sep
  let l:dir = '%<%0* ' . getcwd() . ' %*'
  " Return the full statusline
  return l:regex . l:prv . l:item . l:nxt . l:marked . l:mid . l:focus . l:byfname . l:dir
endfunction

" Argument: len
"           a:1
function! StatusLine_CtrlP_Prog(...) abort
  let l:len = '%0* ' . a:1 . ' '
  let l:dir = '%=' . s:sep . '%<%0* ' . getcwd() . ' %*'
  " Return the full statusline
  return l:len . l:dir
endfunction
