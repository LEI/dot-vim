" Statusline

function! statusline#StatusLine()
  return StatusLine()
endfunction

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

function! StatusLine(...) abort
  let l:name = a:0 ? a:1 : '%f'
  let l:s = ''
  let l:s.= '%1*%( %{&paste ? "PASTE" : ""} %)%0*'
  let l:s.= '%( %{winwidth(0) > 40 && &modifiable ? StatusLineMode() : ""} ' . s:sep . '%)'
  let l:s.= '%<'
  " Git branch &bt !~ 'nofile\|quickfix'
  let l:s.= '%( %{winwidth(0) > 80 ? StatusLineBranch() : ""} ' . s:sep . '%)'
  " Buffer name
  let l:s.= ' ' . l:name
  " let l:s.= '%( %{exists("w:quickfix_title") ? w:quickfix_title : ""}%)'
  " Flags [%W%H%R%M]
  let l:s.= '%( [%{StatusLineFlags()}]%)'

  let l:s.= ' %='

  " Warnings
  let l:s.= '%#StatusLineWarn#%('
  let l:s.= '%( %{StatusLineIndent()}%)' " &bt nofile, nowrite
  let l:s.= '%( %{empty(&bt) ? StatusLineTrailing() : ""}%)'
  let l:s.= ' %)%0*'
  " Errors
  let l:s.= '%#StatusLineError#'
  let l:s.= '%( %{StatusLineErrors()} %)'
  let l:s.= '%0*'
  " File type
  let l:s.= '%( %{winwidth(0) > 40 ? StatusLineFileType() : ""} ' . s:sep . '%)'
  " File encoding
  let l:s.= '%( %{winwidth(0) > 80 ? StatusLineFileInfo() : ""} ' . s:sep . '%)'
  " Default ruler
  let l:s.= ' %-14.(%l,%c%V/%L%) %P'
  let l:s.= ' '
  return l:s
endfunction

function! StatusLineBranch() abort
  if !exists('*fugitive#head') || &buftype ==# 'quickfix'
    return ''
  endif
  if exists('b:branch_hidden') && b:branch_hidden == 1
    return ''
  endif
  return fugitive#head(7)
endfunction

function! StatusLineFlags() abort
  if &filetype =~# 'netrw\|vim-plug' || &buftype ==# 'quickfix'
    return ''
  endif
  if &filetype ==# '' && &buftype ==# 'nofile'
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
  if &filetype ==# ''
    if &buftype !=# 'nofile'
      return &buftype
    endif
    return ''
  endif
  if &filetype ==# 'qf'
    return &buftype
  endif
  if &filetype ==# 'netrw' && get(b:, 'netrw_browser_active', 0) == 1
    let l:netrw_direction = (g:netrw_sort_direction =~# 'n' ? '+' : '-')
    return g:netrw_sort_by . '['. l:netrw_direction . '] ' . &filetype
  " elseif &filetype ==# 'qf'
  "   return 'quickfix'
  endif
  return &filetype
endfunction

function! StatusLineFileInfo() abort
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

" autocmd VimEnter * let &statusline = StatusLine()
" set statusline=%!StatusLine()
augroup StatusLine
  autocmd!
  autocmd VimEnter,ColorScheme * call StatusLineColors() | redrawstatus
  autocmd InsertEnter * let g:statusline_insertmode = v:insertmode | call StatusLineMode()
  autocmd InsertChange * let g:statusline_insertmode = v:insertmode | call StatusLineMode()
  autocmd InsertLeave * unlet g:statusline_insertmode | call StatusLineMode()
  " | redrawstatus

  " Update whitespace warnings
  autocmd BufWritePost,CursorHold,InsertLeave * unlet! b:statusline_indent | unlet! b:statusline_trailing

  autocmd CmdWinEnter * let b:branch_hidden = 1 | let &l:statusline = StatusLine('Command Line')
  " autocmd CmdWinLeave * unlet b:is_command_window

  " Quickfix or location list title
  autocmd FileType qf let &l:statusline = StatusLine('%f' . (exists('w:quickfix_title') ? ' ' . w:quickfix_title : ''))
  autocmd FileType vim-plug let &l:statusline = StatusLine('Plugins')
augroup END

if !has('vim_starting') " v:vim_did_enter
  call StatusLineColors() 
endif
