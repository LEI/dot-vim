" Statusline

set laststatus=2 " Always show statusline

set display+=lastline " Display as much as possible of the last line

set noshowmode " Do not display current mode

set showcmd " Display incomplete commands

set ruler " Always show current position

" set rulerformat=%l,%c%V%=%P

" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" set statusline=%!StatusLine()

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

let s:ep = ' '
if has('multi_byte') && &encoding ==# 'utf-8'
  let s:ep = nr2char(0x2502)
endif

function! StatusLine() abort
  let l:stl = ''
  let l:stl.= '%( %{&modifiable ? StatusLineMode() . (&paste ?" PASTE":"") : ""} ' . s:ep . '%)'
  " Git branch
  let l:stl.= '%( %{!exists("w:quickfix_title") && winwidth(0) > 60 && exists("*fugitive#head") ? fugitive#head(7) : ""} ' . s:ep . '%)'
  " Buffer
  let l:stl.= '%< %f'

  let l:stl.= '%(%{exists("w:quickfix_title") ? w:quickfix_title : " "}%)'
  " Flags [%W%H%R%M]
  let l:stl.= '%( [%{!exists("w:quickfix_title") ? StatusLineFlags() : ""}]%)'
  let l:stl.= ' %=' " Break
  " Warnings
  let l:stl.= '%#WarningMsg#'
  let l:stl.= '%( %{StatusLineWarnings()} %)'
  " Errors
  let l:stl.= '%#ErrorMsg#'
  let l:stl.= '%( %{StatusLineErrors()} %)'
  " Reset highlight group
  let l:stl.= '%0*'
  " File type
  let l:stl.= '%( %{winwidth(0) > 40 ? StatusLineFileType() : ""} ' . s:ep . '%)'
  " Netrw plugin
  " let l:stl.= '%{g:netrw_sort_by}[%{(g:netrw_sort_direction =~ "n") ? "+" : "-"}]'
  " File encoding
  let l:stl.= '%( %{winwidth(0) > 80 && &buftype != "help" ? StatusLineFileInfo() : ""} ' . s:ep . '%)'
  " Default ruler
  let l:stl.= ' %-14.(%l,%c%V/%L%) %P'
  let l:stl.= ' '
  return l:stl
endfunction

function! StatusLineFlags() abort
  if &filetype =~# 'netrw\|vim-plug'
    return ''
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

function! StatusLineFileType() abort
  if strlen(&filetype) == 0
    return 'no ft'
  endif
  if &filetype =~# 'netrw'
    if get(b:, 'netrw_browser_active', 0) == 1
      return &filetype . '[' . g:netrw_sort_by . (g:netrw_sort_direction =~# 'n' ? '+' : '-') . ']'
    endif
  endif
  return &filetype
endfunction

function! StatusLineFileInfo() abort
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

function! StatusLineWarnings() abort
  let l:indent = StatusLineIndent()
  let l:trailing = StatusLineTrailing()
  if !empty(l:indent) && !empty(l:trailing)
    return l:indent . ',' . l:trailing
  elseif !empty(l:indent)
    return l:indent
  elseif !empty(l:trailing)
    return l:trailing
  endif
  return ''
endfunction

function! StatusLineIndent() abort
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
      let b:statusline_indent = 'mixed-indent'
    elseif l:spaces != 0 && !&expandtab
      let b:statusline_indent = 'spaces' " line nr: l:spaces
    elseif l:tabs != 0 && &expandtab
      let b:statusline_indent = 'tabs' " line nr: l:tabs
    endif
  endif
  return b:statusline_indent
endfunction

function! StatusLineTrailing() abort
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

function! StatusLineErrors() abort
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

function! StatusLineColors() abort
  highlight link StatusLineBranch StatusLine
  " Reverse: cterm=NONE gui=NONE | ctermfg=bg ctermbg=fg
  if &background ==# 'dark'
    " highlight User1 term=reverse ctermfg=10 ctermbg=7
    " highlight StatusLineNormal ctermfg=0 ctermbg=4
    "term=reverse cterm=reverse ctermfg=14 ctermbg=0 gui=bold,reverse
    highlight StatusLineInsert cterm=NONE ctermfg=0 ctermbg=2 gui=NONE guifg=#073642 guibg=#859900
    highlight StatusLineReplace cterm=NONE ctermfg=0 ctermbg=9 gui=NONE guifg=#073642 guibg=#cb4b16
    highlight StatusLineVisual cterm=NONE ctermfg=0 ctermbg=3 gui=NONE guifg=#073642 guibg=#b58900
  else
    " highlight User1 term=reverse ctermfg=14 ctermbg=0
    " highlight StatusLineNormal ctermfg=7 ctermbg=4
    "term=reverse cterm=reverse ctermfg=10 ctermbg=7 gui=bold,reverse
    highlight StatusLineInsert cterm=NONE ctermfg=7 ctermbg=2 gui=NONE guifg=#eee8d5 guibg=#859900
    highlight StatusLineReplace cterm=NONE ctermfg=7 ctermbg=9 gui=NONE guifg=#eee8d5 guibg=#cb4b16
    highlight StatusLineVisual cterm=NONE ctermfg=7 ctermbg=3 gui=NONE guifg=#eee8d5 guibg=#b58900
  endif
endfunction

function! StatusLineInsertMode(...) abort
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

function! StatusLineMode(...) abort
  let l:mode = a:0 ? a:1 : mode()
  if exists('g:statusline_insertmode') && strlen(g:statusline_insertmode) > 0
    call StatusLineInsertMode(g:statusline_insertmode)
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

" autocmd VimEnter *
let &statusline = StatusLine()
augroup StatusLine
  autocmd!
  autocmd VimEnter,ColorScheme * call StatusLineColors() | redrawstatus
  " autocmd CmdWinEnter,CmdWinLeave * redrawstatus
  autocmd InsertEnter * let g:statusline_insertmode = v:insertmode | call StatusLineMode()
  autocmd InsertChange * let g:statusline_insertmode = v:insertmode | call StatusLineMode()
  autocmd InsertLeave * unlet g:statusline_insertmode | call StatusLineMode()
  " Update whitespace warnings
  autocmd BufWritePost,InsertLeave * unlet! b:statusline_indent | unlet! b:statusline_trailing
  " | redrawstatus
  " autocmd CmdWinEnter * let b:is_command_window = true
  " autocmd CmdWinLeave * unlet b:is_command_window
  autocmd FileType qf let &l:statusline = StatusLine()
augroup END
