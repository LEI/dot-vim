" Status line

" set statusline=%!stl#Build()

" if exists('g:loaded_statusline')
"   finish
" endif

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

function! stl#Build(...) abort
  let l:bufname = a:0 && strlen(a:1) > 0 ? a:1 : '%f'
  let l:s = ''
  " Mode
  let l:s.= '%1*%( %{&paste ? "PASTE" : ""} %)%*'
  let l:s.= '%< '
  let l:s.= '%(%{winwidth(0) > 60 && &modifiable ? stl#f#Mode() : ""}' . g:statusline.symbols.sep . '%)'
  " Git branch
  let l:s.= '%(%{winwidth(0) > 90 ? stl#f#Branch() : ""}' . g:statusline.symbols.sep . '%)'
  " Buffer name
  let l:s.= l:bufname
  " Flags [%W%H%R%M]
  let l:s.= '%( [%{stl#f#Flags()}]%)'
  " Break
  let l:s.= ' %='
  " Warnings
  let l:s.= '%#StatusLineWarn#%('
  let l:s.= '%( %{stl#f#Indent()}%)' " &bt nofile, nowrite
  let l:s.= '%( %{empty(&bt) ? stl#f#Trailing() : ""}%)'
  let l:s.= ' %)%*'
  " Errors
  let l:s.= '%#StatusLineError#%('
  let l:s.= '%( %{exists("g:loaded_syntastic_plugin") ? SyntasticStatuslineFlag() : ""}%)'
  let l:s.= '%( %{exists("*neomake#Make") ? neomake#stl#f#QflistStatus("qf: ") : ""}%)'
  let l:s.= '%( %{exists("*neomake#Make") ? neomake#stl#f#LoclistStatus() : ""}%)'
  let l:s.= '%( %{exists("g:loaded_ale") ? ALEGetStatusLine() : ""}%)'
  let l:s.= ' %)%*'
  " Plugins
  let l:s.= '%( %{exists("ObsessionStatus") ? ObsessionStatus() : ""}%)'
  " Space
  let l:s.= ' '
  " File type
  let l:s.= '%(%{winwidth(0) > 30 ? stl#f#FileType() : ""}' . g:statusline.symbols.sep . '%)'
  " File encoding
  let l:s.= '%(%{winwidth(0) > 60 ? stl#f#FileInfo() : ""}' . g:statusline.symbols.sep . '%)'
  " Default ruler
  let l:s.= '%-14.(%l,%c%V/%L%) %P '
  return l:s
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

highlight link User1 StatusLine
highlight link StatusLineInsert StatusLine
highlight link StatusLineReplace StatusLine
highlight link StatusLineVisual StatusLine

" Reverse: cterm=NONE gui=NONE | ctermfg=bg ctermbg=fg
" highlight link StatusLineBranch StatusLine
" highlight StatusLineError cterm=NONE ctermfg=7 ctermbg=1 gui=NONE guifg=#eee8d5 guibg=#cb4b16
" highlight StatusLineWarn cterm=NONE ctermfg=7 ctermbg=9 gui=NONE guifg=#eee8d5 guibg=#dc322f
highlight StatusLineError cterm=reverse ctermfg=1 gui=reverse guifg=#cb4b16
" highlight StatusLineWarn cterm=reverse ctermfg=9 gui=reverse guifg=#dc322f
highlight StatusLineWarn cterm=NONE ctermfg=9 gui=NONE guifg=#dc322f

function! stl#Highlight(...) abort
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

" v:vim_did_enter |!has('vim_starting')
let s:enable = get(g:, 'stl#enable_at_startup', 1)
if s:enable
  call stl#ctrlp#Enable()
endif

" Initialize active window number
let g:statusline.winnr = winnr()

augroup StatusLine
  autocmd!
  " autocmd ColorScheme * call stl#Colors() | redrawstatus
  autocmd InsertEnter * call stl#Highlight(v:insertmode)
  autocmd InsertChange * call stl#Highlight(v:insertmode)
  autocmd InsertLeave * call stl#Highlight()

  autocmd BufAdd,BufEnter,WinEnter * let g:statusline.winnr = winnr()

  " Update whitespace warnings (add InsertLeave?)
  autocmd BufWritePost,CursorHold * unlet! b:statusline_indent | unlet! b:statusline_trailing

  autocmd CmdWinEnter * let b:branch_hidden = 1 | let &l:statusline = stl#Build('Command Line')
  " autocmd CmdWinLeave * unlet b:is_command_window

  autocmd FileType qf let &l:statusline = stl#Build('%f%( %{stl#f#QuickFixTitle()}%)')
  autocmd FileType vim-plug let &l:statusline = stl#Build('Plugins')
  autocmd FileType taglist let &l:statusline = stl#Build(s:Replace_(expand('%')))
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

" %<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
command! -nargs=* -bar CursorStl let &g:statusline = stl#Build('%f %([%b 0x%B]%)')

let &cpoptions = s:save_cpo
unlet s:save_cpo
