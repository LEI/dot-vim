" Testing

Pack 'vim-test/vim-test' " Test runner

if has('nvim')
  let g:test#strategy = 'neovim'
  let g:test#neovim#start_normal = 1
  " tmap <C-o> <C-\><C-n>
elseif exists('vim8')
  let g:test#strategy = 'vimterminal'
else
  let g:test#strategy = 'dispatch'
end

" let g:test#strategy = 'dispatch'
" let g:test#preserve_screen = 1

" let g:test#strategy = {
"   \ 'nearest': 'neovim',
"   \ 'file':    'dispatch',
"   \ 'suite':   'basic',
" \}

nmap <silent> <Leader>Tf :TestFile<CR>
nmap <silent> <Leader>Tl :TestLast<CR>
nmap <silent> <Leader>Tn :TestNearest<CR>
nmap <silent> <Leader>Ts :TestSuite<CR>
nmap <silent> <Leader>Tv :TestVisit<CR>

" Run tests when a test file or its alternate application file is saved
let g:enable_test_on_save = 0
augroup test
  autocmd!
  autocmd BufWrite *
    \ if get(g:, 'enable_test_on_save') && test#exists() |
    \   TestFile |
    \ endif
augroup END


" Default runners: https://github.com/vim-test/vim-test/blob/master/plugin/test.vim
" let g:test#enabled_runners = ['mylanguage#myrunner', 'ruby#rspec']
let g:test#runner_commands = []

" JS/TS
" let g:test#javascript#jasmine#executable = 'npm run -- jasmine'
" let g:test#javascript#jasmine#file_pattern = '\v^(spec[\\/]|.*spec)\.(js|jsx|coffee|ts)$'
" let g:test#javascript#jasmine#file_pattern = '\v^(spec[\\/].*spec|.*\.spec)\.(coffee|js|jsx|ts)$'
let g:test#runner_commands = g:test#runner_commands +
      \ ['Ava', 'CucumberJS', 'DenoTest', 'Intern', 'TAP', 'Teenytest', 'Karma', 'Lab', 'Mocha',  'NgTest', 'Nx', 'Jasmine', 'Jest', 'ReactScripts', 'WebdriverIO', 'Cypress', 'VueTestUtils', 'Playwright', 'Vitest']

" PHP
" let g:test#php#phpunit#executable = 'php artisan test'
let g:test#runner_commands = g:test#runner_commands +
      \ ['Codeception', 'Dusk', 'Pest', 'PHPUnit', 'Behat', 'PHPSpec', 'Kahlan', 'Peridot']

" ~/.vim/autoload/test
" let g:test#custom_runners = {
" \   'typescript': ['jasmine']
" \ }
