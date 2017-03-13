" Ctags
" https://github.com/thoughtbot/dotfiles/blob/master/vim/plugin/ctags.vim

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
" let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
function! ReindexCtags()
  let l:ctags_hook = '$(git rev-parse --show-toplevel)/.git/hooks/ctags'

  if exists(l:ctags_hook)
    exec '!'. l:ctags_hook
  else
    exec '!ctags -R .'
  endif
endfunction

nmap <Leader>ct :call ReindexCtags()<CR>

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
