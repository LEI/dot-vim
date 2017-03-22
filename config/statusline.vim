" Status line

if !has('statusline')
  finish
endif

" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" set statusline=%!status#Line()

function! StatusLine(...)
  let l:name = a:0 && strlen(a:1) > 0 ? a:1 : '%f'
  let l:info = a:0 > 1 ? a:2 : get(g:statusline, 'right', '')
  let l:s = ''
  " Paste
  let l:s.= '%#StatusLineReverse#%( %{&paste && g:statusline.winnr == winnr() ? "PASTE" : ""} %)%*'
  " Space
  let l:s = ' '
  " Mode
  let l:s.= '%(%{winwidth(0) > 60 ? status#mode#name() : ""}' . g:statusline.symbols.sep . '%)'
  " Truncate here
  let l:s.= '%<'
  " Git branch
  let l:s.= '%(%{winwidth(0) > 70 ? status#branch#name() : ""}' . g:statusline.symbols.sep . '%)'
  " Buffer name
  let l:s.= l:name
  " Flags [%W%H%R%M]
  let l:s.= '%( [%{status#flag#line()}]%)'
  " Break
  let l:s.= '%='
  " Extra markers
  let l:s.= l:info
  " Warnings
  let l:s.= '%#StatusLineWarn#%(' " WarningMsg
  let l:s.= '%( %{status#warn#indent()}%)' " &bt nofile, nowrite
  let l:s.= '%( %{empty(&bt) ? status#warn#trailing() : ""}%)'
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
  let l:s.= '%(%{winwidth(0) > 40 ? status#file#type() : ""}' . g:statusline.symbols.sep . '%)'
  " File encoding
  let l:s.= '%(%{winwidth(0) > 50 ? status#file#format() : ""}' . g:statusline.symbols.sep . '%)'
  " Default ruler
  let l:s.= '%-14.(%l,%c%V/%L%) %P '
  return l:s
endfunction

let g:statusline_func = 'StatusLine'
let &g:statusline = status#Line()
set noshowmode

" set statusline=%{&paste?'PASTE\ ':''}
" set statusline+=%<%f\ %m%r%w
" set statusline+=%{fugitive#statusline()}
" set statusline+=%=
" set statusline+=%#ErrorMsg#%(\ %{ale#statusline#Status()}\ %)%*
" set statusline+=%(\ %{FileInfo()}%)
" set statusline+=%(\ %{strlen(&ft)?&ft:&bt}%)
" set statusline+=\ %-14.(%l,%c%V/%L%)\ %P

" function! FileInfo() abort
"   let l:str = ''
"   let l:ft = &filetype
"   let l:bt = &buftype
"   if !(strlen(l:ft) && l:ft !=# 'netrw' && l:bt !=# 'help')
"     return l:str
"   endif
"   let l:fe = strlen(&fileencoding) ? &fileencoding : &encoding
"   let l:ff = &fileformat
"   if has('+bomb') && &bomb
"     let l:fe.= '-bom'
"   endif
"   if l:fe !=# 'utf-8' | let l:str.= l:fe | endif
"   if l:ff !=# 'unix' | let l:str.= '[' . l:ff . ']' | endif
"   return l:str
" endfunction

" Reverse: cterm=NONE gui=NONE | ctermfg=bg ctermbg=fg
function! HighlightStatusLine() abort
  if &background ==# 'dark'
    highlight StatusLineReverse term=reverse ctermfg=14 ctermbg=0
    " highlight StatusLineNormal ctermfg=0 ctermbg=4
    "term=reverse cterm=reverse ctermfg=14 ctermbg=0 gui=bold,reverse
    highlight StatusLineInsert cterm=NONE ctermfg=0 ctermbg=2 gui=NONE guifg=#073642 guibg=#859900
    highlight StatusLineReplace cterm=NONE ctermfg=0 ctermbg=9 gui=NONE guifg=#073642 guibg=#cb4b16
    highlight StatusLineVisual cterm=NONE ctermfg=0 ctermbg=3 gui=NONE guifg=#073642 guibg=#b58900
  elseif &background ==# 'light'
    highlight StatusLineReverse term=reverse ctermfg=10 ctermbg=7
    " highlight StatusLineNormal ctermfg=7 ctermbg=4
    "term=reverse cterm=reverse ctermfg=10 ctermbg=7 gui=bold,reverse
    highlight StatusLineInsert cterm=NONE ctermfg=7 ctermbg=2 gui=NONE guifg=#eee8d5 guibg=#859900
    highlight StatusLineReplace cterm=NONE ctermfg=7 ctermbg=9 gui=NONE guifg=#eee8d5 guibg=#cb4b16
    highlight StatusLineVisual cterm=NONE ctermfg=7 ctermbg=3 gui=NONE guifg=#eee8d5 guibg=#b58900
  endif
  " highlight StatusLineError cterm=NONE ctermfg=7 ctermbg=1 gui=NONE guifg=#eee8d5 guibg=#cb4b16
  highlight StatusLineError cterm=reverse ctermfg=1 gui=reverse guifg=#dc322f
  " highlight StatusLineWarn cterm=NONE ctermfg=7 ctermbg=9 gui=NONE guifg=#eee8d5 guibg=#dc322f
  highlight StatusLineWarn cterm=NONE ctermfg=9 gui=NONE guifg=#cb4b16
endfunction

augroup StatusLine
  autocmd!
  " Override cursor and status line highlight groups when color scheme changes
  autocmd User Config :call HighlightStatusLine()
  autocmd ColorScheme * :call HighlightStatusLine()
augroup END
