" UltiSnips

" Note: this should be loaded before UltiSnips

if !get(g:, 'vim_completion', 0) || !exists('g:UltiSnipsSnippetDirectories')
" if !exists('g:did_plugin_ultisnips')
  finish
endif

" let g:UltiSnipsSnippetsDir = '~/.vim/snippets/'

" Snippet search path
" let g:UltiSnipsSnippetDirectories = ['UltiSnips'] " 'snippets', 'neosnippets']

" Use <C-j> to expand selected snippet, <Tab> conflicts with YouCompleteMe
let g:UltiSnipsExpandTrigger = '<C-j>'

" Use <C-j> and <C-k> to jump between placeholders
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

" Interferes with the built-in complete function i_CTRL-X_CTRL-K
inoremap <C-x><C-k> <C-x><C-k>

" Note: some terminal emulators don't send <C-Tab> to the running program
" let g:UltiSnipsListSnippets = '<C-l>'

" Open :UltiSnipsEdit in a split
let g:UltiSnipsEditSplit = 'vertical'

call plug#load('ultisnips')
