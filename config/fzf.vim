" fzf
" https://github.com/junegunn/fzf/blob/master/README-VIM.md

if isdirectory('/usr/local/opt/fzf')
  " If installed using Homebrew
  Pack '/usr/local/opt/fzf'
elseif isdirectory('~/.fzf')
  " If installed using git
  Pack '~/.fzf'
else " install --xdg?
  Pack 'junegunn/fzf', { 'dir': '~/.fzf', 'do': '!./install --all' }
endif

Pack 'junegunn/fzf.vim'

if executable('ag')
  " let s:ag_args = '--hidden --ignore .git'
  " --nogroup --nocolor " --files-with-matches
  " command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, s:ag_args, <bang>0)
  command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%', '?'),
    \   <bang>0)
  " right:50%:hidden
  " command! -bang Colors
  "   \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'}, <bang>0)
  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
  " GitFiles
endif

" Use the correct file source, based on context
" https://github.com/junegunn/fzf/wiki/Examples-(vim)
function! ContextualFZF()
    " Determine if inside a git repo
    silent exec "!git rev-parse --show-toplevel"
    redraw!

    if v:shell_error
        " Search in current directory
        call fzf#run({
          \'sink': 'e',
          \'down': '40%',
        \})
    else
        " Search in entire git repo
        call fzf#run({
          \'sink': 'e',
          \'down': '40%',
          \'source': 'git ls-tree --full-tree --name-only -r HEAD',
        \})
    endif
endfunction

" map <C-p> :call ContextualFZF()<CR> :Files?
map <C-p> :FZF<CR>

" Customize fzf colors to match your color scheme
" Defaults:
" hl -> Comment
" hl+ -> Statement
" promp -> Conditional
" pointer -> Exception
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Function'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Function'],
  \ 'info':    ['fg', 'Label'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Function'],
  \ 'pointer': ['fg', 'Normal'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'PreProc'],
  \ 'header':  ['fg', 'Comment'] }

" Hide statusline
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" " Custom statusline
" function! s:fzf_statusline()
"   highlight fzf1 ctermfg=161 ctermbg=251
"   highlight fzf2 ctermfg=23 ctermbg=251
"   highlight fzf3 ctermfg=237 ctermbg=251
"   setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
" endfunction

" autocmd! User FzfStatusLine call <SID>fzf_statusline()
