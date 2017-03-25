" Fugitive

if !executable('git')
  finish
endif

" gregsexton/gitv, mhinz/vim-signify
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'tpope/vim-git' " Latest git runtime files
" Plug 'shumphrey/fugitive-gitlab.vim' " Add Gitlab support

" if !exists('g:loaded_fugitive')
"   finish
" endif

augroup VimFugitive
  autocmd!
  " Auto-clean git objects buffers
  autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END
