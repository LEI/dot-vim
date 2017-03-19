" Highlight groups

function! HighlightCursor() abort
  if &background ==# 'dark'
    " highlight Cursor ctermfg=8 ctermbg=4 guifg=#002b36 guibg=#268bd2
    highlight Cursor ctermfg=0 ctermbg=15 guifg=#002b36 guibg=#fdf6e3
  elseif &background ==# 'light'
    " highlight Cursor ctermfg=15 ctermbg=4 guifg=#fdf6e3 guibg=#268bd2
    highlight Cursor ctermfg=15 ctermbg=0 guifg=#fdf6e3 guibg=#002b36
  endif
endfunction

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

augroup Highlight
  autocmd!
  " Override cursor and status line highlight groups when color scheme changes
  autocmd VimEnter,ColorScheme * :call HighlightCursor() | :call HighlightStatusLine()
augroup END
