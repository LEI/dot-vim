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
  let l:stl.= '%( %{winwidth(0) > 60 && exists("*fugitive#head") ? fugitive#head(7) : ""} ' . s:ep . '%)'
  " Buffer
  let l:stl.= '%< %f'
  " Flags [%W%H%R%M]
  let l:stl.= '%( [%{StatusLineFlags()}] %)'
  let l:stl.= '%=' " Break
  " Errors and warnings
  let l:stl.= '%#ErrorMsg#'
  let l:stl.= '%( %{exists("*neomake#Make") ? neomake#statusline#QflistStatus("qf: ") : ""} %)'
  let l:stl.= '%( %{exists("*neomake#Make") ? neomake#statusline#LoclistStatus() : ""} %)'
  let l:stl.= '%( %{exists("g:loaded_syntastic") ? SyntasticStatuslineFlag() : ""} %)'
  " Reset highlight group
  let l:stl.= '%0*'
  " File type
  let l:stl.= '%( %{winwidth(0) > 40 ? StatusLineFileType() : ""} ' . s:ep . '%)'
  " Netrw plugin
  " let l:stl.= '%{g:netrw_sort_by}[%{(g:netrw_sort_direction =~ "n") ? "+" : "-"}]'
  " File encoding
  let l:stl.= '%( %{winwidth(0) > 80 && &buftype != "help" ? StatusLineFileInfo() : ""} ' . s:ep . '%)'
  " Default ruler
  let l:stl.= '%-14.(%l,%c%V/%L%) %P'
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

function! StatusLineColors() abort
  highlight link StatusLineBranch StatusLine
  " Reverse: cterm=NONE gui=NONE
  if &background ==# 'dark'
    " highlight User1 term=reverse ctermfg=10 ctermbg=7
    " highlight StatusLineNormal ctermfg=0 ctermbg=4
    "term=reverse cterm=reverse ctermfg=14 ctermbg=0 gui=bold,reverse
    highlight StatusLineInsert ctermfg=0 ctermbg=2
    highlight StatusLineReplace ctermfg=0 ctermbg=9
    highlight StatusLineVisual ctermfg=0 ctermbg=3
  else
    " highlight User1 term=reverse ctermfg=14 ctermbg=0
    " highlight StatusLineNormal ctermfg=7 ctermbg=4
    "term=reverse cterm=reverse ctermfg=10 ctermbg=7 gui=bold,reverse
    highlight StatusLineInsert ctermfg=7 ctermbg=2
    highlight StatusLineReplace ctermfg=7 ctermbg=9
    highlight StatusLineVisual ctermfg=7 ctermbg=3
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
  " elseif l:mode == 'v' || l:mode == 'V' || l:mode == '^V'
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
  " | redrawstatus
augroup END
