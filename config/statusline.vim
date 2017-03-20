" Status line

" set statusline=%!status#Line()
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
endfunction

augroup StatusLine
  autocmd!
  " Override cursor and status line highlight groups when color scheme changes
  autocmd VimEnter,ColorScheme * :call HighlightStatusLine()
augroup END
