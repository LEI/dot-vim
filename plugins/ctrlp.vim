" CtrlP

" if exists('g:loaded_ctrlp')
"   finish
" endif

Plug 'ctrlpvim/ctrlp.vim' " Fuzzy finder (alt: junegunn/fzf.vim)

" https://github.com/skwp/dotfiles/blob/master/vim/settings/ctrlp.vim
" https://github.com/thoughtbot/dotfiles/blob/master/vimrc
" https://github.com/ggreer/the_silver_searcher

" if !exists('g:loaded_ctrlp')
"   finish
" endif

let g:ctrlp_status_func = {'main': 'status#ctrlp#Main', 'prog': 'status#ctrlp#Prog'}

" let g:ctrlp_map = '<leader>f'
" let g:ctrlp_match_window = 'bottom,order:ttb'
" let g:ctrlp_working_path_mode = ''

if executable('ag')
  " Use The Silver Searcher in CtrlP for listing files
  " Respect .gitignore and .agignore, ignores hidden files by default
  let g:ctrlp_user_command = 'ag --nogroup --nocolor --files-with-matches --hidden --ignore .git -g "" --literal %s'
  " Disable per-session caching
  let g:ctrlp_use_caching = 0
else
  " Exclude .gitignore patterns
  let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
endif