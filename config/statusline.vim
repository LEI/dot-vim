" Status line

if !has('statusline')
  finish
endif

Plug 'LEI/vim-statusline'

" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" set statusline=%!statusline#Build()

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

function! StatusLineLeft(...) abort
  let l:name = a:0 && strlen(a:1) > 0 ? a:1 : '%f'
  let l:s = '' " Start
  let l:s.= '%#StatusLineReverse#%( %{&paste && g:statusline.winnr == winnr() ? "PASTE" : ""} %)%*' " Paste
  let l:s.= ' ' " Space
  let l:s.= '%(%{winwidth(0) > 60 ? statusline#core#Mode() : ""}' . g:statusline.symbols.sep . '%)' " Mode
  let l:s.= '%<' " Truncate here
  let l:s.= '%(%{winwidth(0) > 70 ? statusline#branch#Name() : ""}' . g:statusline.symbols.sep . '%)' " Git branch
  let l:s.= l:name " Buffer name
  let l:s.= '%( [%{statusline#core#Flags()}]%)' " Flags [%W%H%R%M]
  " let l:s.= '%=' " Break
  return l:s
endfunction

function! StatusLineRight(...) abort
  let l:info = a:0 > 1 ? a:2 : '' " get(g:statusline, 'right', '')
  let l:s = l:info " Extra markers
  let l:s.= '%#StatusLineWarn#%(' " WarningMsg
  let l:s.= '%( %{statusline#warn#Indent()}%)' " &bt nofile, nowrite
  let l:s.= '%( %{empty(&bt) ? statusline#warn#Trailing() : ""}%)'
  let l:s.= ' %)%*'
  let l:s.= '%#StatusLineError#%(' " ErrorMsg
  let l:s.= '%( %{exists("g:loaded_syntastic_plugin") ? SyntasticStatuslineFlag() : ""}%)'
  let l:s.= '%( %{exists("*neomake#Make") ? neomake#statusline#line#QflistStatus("qf: ") : ""}%)'
  let l:s.= '%( %{exists("*neomake#Make") ? neomake#statusline#line#LoclistStatus() : ""}%)'
  let l:s.= '%( %{exists("g:loaded_ale") ? ALEGetStatusLine() : ""}%)'
  let l:s.= ' %)%*'
  let l:s.= '%( %{exists("ObsessionStatus") ? ObsessionStatus() : ""}%)'
  let l:s.= ' ' " Space
  let l:s.= '%(%{winwidth(0) > 40 ? statusline#core#Type() : ""}' . g:statusline.symbols.sep . '%)' " File type
  let l:s.= '%(%{winwidth(0) > 50 ? statusline#core#Format() : ""}' . g:statusline.symbols.sep . '%)' " File encoding
  let l:s.= '%-14.(%l,%c%V/%L%) %P ' " Default ruler
  return l:s
endfunction

" Reverse: cterm=NONE gui=NONE | ctermfg=bg ctermbg=fg
function! StatusLineHighlight() abort
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
  " Override status line highlight groups when color scheme changes
  autocmd ColorScheme * :call StatusLineHighlight()
  autocmd User Config :call StatusLineHighlight()
  " Build status line on startup
  autocmd User Config :StatusLineBuild | set noshowmode
augroup END

let g:statusline = get(g:, 'statusline', {})
let g:statusline = {'left': function('StatusLineLeft'), 'right': function('StatusLineRight')}
