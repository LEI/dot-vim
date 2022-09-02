" Testing

Pack 'vim-test/vim-test' " Test runner

" nmap <silent> <leader>t :TestNearest<CR>
" nmap <silent> <leader>T :TestFile<CR>
" nmap <silent> <leader>a :TestSuite<CR>
" nmap <silent> <leader>l :TestLast<CR>
" nmap <silent> <leader>g :TestVisit<CR>

" Strategies
" - basic: :! on Vim, and with :terminal on Neovim (default)
" - make, make_bank
" - neovim
" - vimterminal
" - dispatch, dispatch_background
" - terminal
" - iterm

" let test#strategy = 'dispatch'
" let g:test#preserve_screen = 1

" let test#strategy = {
"   \ 'nearest': 'neovim',
"   \ 'file':    'dispatch',
"   \ 'suite':   'basic',
" \}

" if has('nvim')
"   tmap <C-o> <C-\><C-n>
" endif

" " Run tests when a test file or its alternate application file is saved
" augroup test
"   autocmd!
"   autocmd BufWrite * if test#exists() |
"     \   TestFile |
"     \ endif
" augroup END

" let g:test#neovim#start_normal = 1 " If using neovim strategy
let g:test#basic#start_normal = 1 " If using basic strategy

let g:test#javascript#jasmine#file_pattern = '\v^(spec[\\/]|.*spec)\.(js|jsx|coffee|ts)$'
let test#javascript#jasmine#executable = 'npm run jasmine'

" ~/.vim/autoload/test
" let test#custom_runners = {
" \   'typescript': ['jasmine']
" \ }
