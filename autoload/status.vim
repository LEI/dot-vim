" Status line

" set statusline=%!status#Line()

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

function! status#Line(...) abort
  let l:name = a:0 && strlen(a:1) > 0 ? a:1 : '%f'
  let l:info = a:0 > 1 ? a:2 : get(g:statusline, 'right', '')
  let l:s = ''
  " Mode
  let l:s.= '%#StatusLineReverse#%( %{&paste && g:statusline.winnr == winnr() ? "PASTE" : ""} %)%*'
  let l:s.= ' '
  let l:s.= '%(%{winwidth(0) > 60 ? status#line#Mode() : ""}' . g:statusline.symbols.sep . '%)'
  let l:s.= '%<'
  " Git branch
  let l:s.= '%(%{winwidth(0) > 90 ? status#line#Branch() : ""}' . g:statusline.symbols.sep . '%)'
  " Buffer name
  let l:s.= l:name
  " Flags [%W%H%R%M]
  let l:s.= '%( [%{status#line#Flags()}]%)'
  " Break
  let l:s.= ' %='
  " Extra markers
  let l:s.= l:info
  " Warnings
  let l:s.= '%#StatusLineWarn#%(' " WarningMsg
  let l:s.= '%( %{status#line#Indent()}%)' " &bt nofile, nowrite
  let l:s.= '%( %{empty(&bt) ? status#line#Trailing() : ""}%)'
  let l:s.= ' %)%*'
  " Errors
  let l:s.= '%#StatusLineError#%(' " ErrorMsg
  let l:s.= '%( %{exists("g:loaded_syntastic_plugin") ? SyntasticStatuslineFlag() : ""}%)'
  let l:s.= '%( %{exists("*neomake#Make") ? neomake#status#line#QflistStatus("qf: ") : ""}%)'
  let l:s.= '%( %{exists("*neomake#Make") ? neomake#status#line#LoclistStatus() : ""}%)'
  let l:s.= '%( %{exists("g:loaded_ale") ? ALEGetStatusLine() : ""}%)'
  let l:s.= ' %)%*'
  " Plugins
  let l:s.= '%( %{exists("ObsessionStatus") ? ObsessionStatus() : ""}%)'
  " Space
  let l:s.= ' '
  " File type
  let l:s.= '%(%{winwidth(0) > 30 ? status#line#FileType() : ""}' . g:statusline.symbols.sep . '%)'
  " File encoding
  let l:s.= '%(%{winwidth(0) > 60 ? status#line#FileInfo() : ""}' . g:statusline.symbols.sep . '%)'
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

highlight link StatusLineReverse StatusLine
highlight link StatusLineInsert StatusLine
highlight link StatusLineReplace StatusLine
highlight link StatusLineVisual StatusLine
" highlight link StatusLineBranch StatusLine
" highlight link StatusLineError ErrorMsg
" highlight link StatusLineWarn WarningMsg

" Reverse: cterm=NONE gui=NONE | ctermfg=bg ctermbg=fg
function! status#Colors() abort
" highlight StatusLineError cterm=NONE ctermfg=7 ctermbg=1 gui=NONE guifg=#eee8d5 guibg=#cb4b16
  highlight StatusLineError cterm=reverse ctermfg=1 gui=reverse guifg=#dc322f
" highlight StatusLineWarn cterm=NONE ctermfg=7 ctermbg=9 gui=NONE guifg=#eee8d5 guibg=#dc322f
  highlight StatusLineWarn cterm=NONE ctermfg=9 gui=NONE guifg=#cb4b16
endfunction

function! status#Highlight(...) abort
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
" let s:enable = get(g:, 'status#enable_at_startup', 1)
" if s:enable
"   call status#Colors()
"   " call status#ctrlp#Enable()
" endif

" Initialize active window number
let g:statusline.winnr = winnr()

augroup StatusGroup
  autocmd!
  autocmd VimEnter,ColorScheme * call status#Colors()
  autocmd InsertEnter * call status#Highlight(v:insertmode)
  autocmd InsertChange * call status#Highlight(v:insertmode)
  autocmd InsertLeave * call status#Highlight()

  " autocmd WinEnter,FileType,BufWinEnter * let &l:statusline = status#Line()
  autocmd BufAdd,BufEnter,WinEnter * let g:statusline.winnr = winnr()

  " Update whitespace warnings (add InsertLeave?)
  autocmd BufWritePost,CursorHold * unlet! b:statusline_indent | unlet! b:statusline_trailing

  autocmd CmdWinEnter * let b:branch_hidden = 1 | let &l:statusline = status#Line('Command Line')
  " autocmd CmdWinLeave * unlet b:is_command_window

  autocmd FileType qf let &l:statusline = status#Line('%f%( %{status#line#QuickFixTitle()}%)')
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
