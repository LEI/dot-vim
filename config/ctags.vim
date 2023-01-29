" Ctags

if !executable('ctags')
  finish
endif

Pack 'ludovicchabant/vim-gutentags'
" Pack 'tomtom/ttags_vim' | Pack 'tomtom/tlib_vim'

nmap <Leader>t :call ReindexCtags()<CR>

" http://tbaggery.com/2011/08/08/effortless-ctags-with-git.html
" https://github.com/thoughtbot/dotfiles/blob/master/vim/plugin/ctags.vim
function! ReindexCtags()
  let l:ctags_hook = '$(git rev-parse --show-toplevel)/.git/hooks/ctags'
  if exists(l:ctags_hook)
    let l:cmd = '!'. l:ctags_hook
  else
    let l:cmd = '!ctags -R .'
  endif
  execute l:cmd
  " ~/.git_template/hooks/ctags:
  " $ .git/hooks/ctags >/dev/null 2>&1 &

  " #!/bin/sh

  " set -e

  " PATH="/usr/local/bin:$PATH"
  " dir="$(git rev-parse --git-dir)"
  " trap 'rm -f "$dir/$$.tags"' EXIT
  " git ls-files | \
  "   "${CTAGS:-ctags}" --tag-relative -L - -f"$dir/$$.tags" --languages=-javascript,sql
  " mv "$dir/$$.tags" "$dir/tags"
endfunction

Pack 'preservim/tagbar'
nnoremap <silent> <F8> :TagbarToggle<CR>
" ['<Leader>'] = { t = { t = { '<cmd>TagbarToggle<CR>', 'Toggle Tagbar' } } },
" set tags=tags;/
" " Proportions
" let g:tagbar_left = 0
" let g:tagbar_width = 30
" " Used in lightline.vim
" let g:tagbar_status_func = 'TagbarStatusFunc'

" Pack 'vim-scripts/taglist.vim'
" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
" let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"
