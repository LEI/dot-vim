" Statusline

set display+=lastline " Display as much as possible of the last line

set noshowmode " Do not display current mode

set showcmd " Display incomplete commands

set ruler " Always show current position

" set rulerformat=%l,%c%V%=%P

" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

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

let s:ep = nr2char(0x2502)
" '&paste ? " PASTE" : ""'
let &statusline = ' %{StatusLineMode()} '
let &statusline.= s:ep
" Git branch
let &statusline.= '%( %{exists("*fugitive#head") ? fugitive#head(7) : ""} ' . s:ep . '%)'
let &statusline.= '%< '
" Buffer
let &statusline.= '%f '
" Flags
let &statusline.= '%w%h%r%m'
let &statusline.= '%=' " Break
" Errors and warnings
let &statusline.= '%#ErrorMsg#'
let &statusline.= '%( %{exists("g:loaded_neomake") ? neomake#statusline#QflistStatus("qf: ") : ""} %)'
let &statusline.= '%( %{exists("g:loaded_neomake") ? neomake#statusline#LoclistStatus() : ""} %)'
let &statusline.= '%( %{exists("g:loaded_syntastic") ? SyntasticStatuslineFlag() : ""} %)'
" Reset highlight group
let &statusline.= '%0* '
" File type
let &statusline.= '%{strlen(&filetype) ? &filetype : "no ft"}'
" Netrw plugin
let &statusline.= '%([%{get(b:, "netrw_browser_active", 0) == 1 ? g:netrw_sort_by.(g:netrw_sort_direction =~ "n" ? "+" : "-") : ""}]%)'
" let &statusline.= '%{g:netrw_sort_by}[%{(g:netrw_sort_direction =~ "n") ? "+" : "-"}]'
let &statusline.= ' ' . s:ep . ' '
" File encoding
let &statusline.= '%{strlen(&fileencoding) ? &fileencoding : &encoding}'
let &statusline.= '%{exists("+bomb") && &bomb ? ",B" : ""}[%{&fileformat}]'
let &statusline.= ' ' . s:ep . ' '
" Default ruler
let &statusline.= '%-14.(%l,%c%V%) %P'

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

function! StatusLineColors()
  highlight! link StatusLineNormal StatusLine
  if &background ==# 'dark'
    " highlight StatusLineNormal ctermfg=0 ctermbg=4
    "term=reverse cterm=reverse ctermfg=14 ctermbg=0 gui=bold,reverse
    highlight StatusLineInsert ctermfg=0 ctermbg=2
    highlight StatusLineReplace ctermfg=0 ctermbg=9
    highlight StatusLineVisual ctermfg=0 ctermbg=3
  else
    " highlight StatusLineNormal ctermfg=7 ctermbg=4
    "erm=reverse cterm=reverse ctermfg=10 ctermbg=7 gui=bold,reverse
    highlight StatusLineInsert ctermfg=7 ctermbg=2
    highlight StatusLineReplace ctermfg=7 ctermbg=9
    highlight StatusLineVisual ctermfg=7 ctermbg=5
  endif
endfunction

function! StatusLineInsertMode(...)
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

function! StatusLineMode(...)
  let l:mode = a:0 ? a:1 : mode()
  if exists('g:statusline_insertmode') && strlen(g:statusline_insertmode) > 0
    call StatusLineInsertMode(g:statusline_insertmode)
  elseif l:mode == 'n'
    highlight! link StatusLine StatusLineNormal
  elseif l:mode == 'i'
    highlight! link StatusLine StatusLineInsert
  elseif l:mode == 'R'
    highlight! link StatusLine StatusLineReplace
  " elseif l:mode == 'v' || l:mode == 'V' || l:mode == '^V'
  "   highlight! link StatusLine StatusLineVisual
  else
    highlight link StatusLine NONE
  endif
  return get(g:statusline_modes, l:mode, l:mode)
endfunction

augroup StatusLine
  autocmd!
  autocmd VimEnter,ColorScheme * call StatusLineColors() | redrawstatus
  autocmd InsertEnter * let g:statusline_insertmode = v:insertmode | call StatusLineMode() | redrawstatus
  autocmd InsertChange * let g:statusline_insertmode = v:insertmode | call StatusLineMode() | redrawstatus
  autocmd InsertLeave * unlet g:statusline_insertmode | call StatusLineMode() | redrawstatus
augroup END
