" CtrlP

" if exists('g:loaded_ctrlp')
"   finish
" endif

Pack 'ctrlpvim/ctrlp.vim' ", {'on': 'CtrlP'}
" Pack 'tacahiroy/ctrlp-funky'

" https://github.com/skwp/dotfiles/blob/master/vim/settings/ctrlp.vim
" https://github.com/thoughtbot/dotfiles/blob/master/vimrc
" https://github.com/ggreer/the_silver_searcher

let g:ctrlp_status_func = {'main': 'statusline#ctrlp#Main', 'prog': 'statusline#ctrlp#Prog'}

" let g:ctrlp_line_prefix = '> '
" if has('multi_byte') && &encoding ==# 'utf-8'
"   let g:ctrlp_line_prefix = nr2char(9654) . ' '
" endif
" let g:ctrlp_map = '<leader>f'
" let g:ctrlp_match_window = 'bottom,order:ttb'
" let g:ctrlp_show_hidden = 1
" let g:ctrlp_working_path_mode = ''

if executable('ag')
  " Use The Silver Searcher in CtrlP for listing files
  " Respect .gitignore and .agignore, ignores hidden files by default
  " --nogroup --nocolor --files-with-matches
  let g:ctrlp_user_command = 'ag --hidden --ignore .git -g "" --literal %s'
  " Disable per-session caching
  let g:ctrlp_use_caching = 0
else
  " Exclude .gitignore patterns
  let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -co --exclude-standard']
endif

" " Fix broken CtrlP shortcut (done in config/dirvish.vim)
" autocmd FileType dirvish nnoremap <buffer><silent> <C-p> :CtrlP<CR>

" augroup CtrlP
"   autocmd!
"   " autocmd User Config :call s:CtrlPHL()
" augroup END

" function! s:CtrlPHL() abort
"   highlight CtrlPLinePre ...
" endfunction
