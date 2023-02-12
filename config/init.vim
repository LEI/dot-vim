" Plugins configuration

" Setting g:enable_<name> = 1 looks for config/<name>.vim

" Appearance:
if !has('nvim')
  let g:enable_colorscheme = 1
  let g:enable_lightline = 0
  let g:enable_statusline = 1
  let g:enable_tabline = 0
endif

" Movements: goldfeld/vim-seek, tommcdo/vim-exchange
" Pack 'justinmk/vim-sneak'
" Pack 'terryma/vim-expand-region' " Visually select increasingly larger regions

Pack 'tpope/vim-commentary' " Comments (alt: tomtom/tcomment_vim)
" nnoremap <C-c> :Commentary<CR>
" vnoremap <C-c> :Commentary<CR>

Pack 'tpope/vim-surround' " Quoting/parenthesizing
" Pack 'tpope/vim-rsi' " Readline key bindings

" Improvements: haya14busa/incsearch.vim, vim-scripts/YankRing.vim
" let g:enable_textobj = 1
let g:enable_unimpaired = 1
if !has('nvim')
  let g:enable_qf = 1
  Pack 'keith/investigate.vim' " Look up documentation with gK
  Pack 'tpope/vim-endwise' " Automatic end keywords
endif
" Pack 'romainl/vim-qlist' " Persist 'include-search' and 'definition-search'
Pack 'tpope/vim-abolish' " Search, substitute and abbreviate variants
" Pack 'tpope/vim-characterize' " Unicode character metadata (ga)
" Pack 'tpope/vim-obsession' " Continuously updated session files (alt: xolox/vim-session)
Pack 'tpope/vim-repeat' " Enable repeating supported plugin maps
Pack 'mhinz/vim-sayonara', { 'on': 'Sayonara' }

" Toggle values with C-x
let g:enable_alternate = 1

" Development:
if has('nvim')
  let g:enable_lsp = 1
else
  let g:enable_coc = 0
endif

" File Explorer: Shougo/vimfiler.vim
let g:enable_dirvish = 1
" Pack 'tpope/vim-vinegar' " Improved netrw directory browser

" Undo History: sjl/gundo.vim, simnalamburt/vim-mundo
Pack 'mbbill/undotree', {'on': 'UndotreeToggle'}

" Editing: mattn/emmet-vim
" Pack 'tommcdo/vim-lion' " Align by charactef
" Pack 'AndrewRadev/sideways.vim'
" Pack 'AndrewRadev/splitjoin.vim'
" Pack 'tommcdo/vim-lion' " Align by charactef
Pack 'tpope/vim-eunuch' " Better UNIX shell commands
let g:enable_pass = 1 " Password store editing

" Completion:
" let g:enable_youcompleteme = 1
" let g:enable_ultisnips = g:enable_youcompleteme
" let g:enable_deoplete = has('nvim')
" let g:enable_neocomplete = !has('nvim')
" let g:enable_neosnippet = g:enable_deoplete || g:enable_neocomplete

" https://robots.thoughtbot.com/vim-you-complete-me
" Pack 'ajh17/VimCompletesMe'

" Search:
let g:enable_ctags = 0
" let g:enable_ctrlp = 1
let g:enable_fzf = 1

" Syntax Check:
let g:enable_ale = 0
" let g:enable_neomake = 1
" scrooloose/syntastic, maralla/validator.vim, tomtom/checksyntax_vim
" google/vim-codefmt, vim-scripts/LanguageTool

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has('nvim')
  set signcolumn=yes:1
" if has("nvim-0.5.0") || has("patch-8.1.1564")
"   " Recently vim can merge signcolumn and number column into one
"   set signcolumn=number
else
  set signcolumn=yes
endif

" Languages:
Pack 'sheerun/vim-polyglot' " Syntax and indentation language pack
" let g:polyglot_disabled = ['csv', 'graphql', 'tmux']
if has('nvim')
  let g:polyglot_disabled = ['go']
endif
let g:jsx_ext_required = 1

" if g:enable_ctags
"   " https://github.com/sheerun/vim-polyglot/issues/730
"   augroup FixTagBarWithPolyglot
"     autocmd!
"     autocmd FileType typescript unlet g:tagbar_type_typescript
"   augroup END
" endif

" SQL:
" Pack 'vim-scripts/SQLUtilities'

" Golang:
" Pack 'fatih/vim-go', {'do': 'GoInstallBinaries', 'for': 'go'}
" if exists('$GOPATH') && !empty($GOPATH)
"   let g:golint = $GOPATH . '/src/golang.org/x/lint/misc/vim'
"   if isdirectory(g:golint) && executable('golint')
"     Pack g:golint, {'as': 'golint', 'for': 'go'}
"   endif
" endif

" JavaScript:
" let g:enable_ternjs = !get(g:, 'enable_youcompleteme', 0)
" Pack 'jelera/vim-javascript-syntax', {'for': 'javascript'}
" Pack 'othree/javascript-libraries-syntax.vim', {'for': 'javascript'}
" Pack 'posva/vim-vue' ", {'for': 'vue.*'} & npm i -g eslint eslint-plugin-vue
" Pack 'burnettk/vim-angular' " let g:angular_skip_alternate_mappings = 1
" Pack 'mracos/mermaid.vim'

" PHP:
" Pack 'spf13/PIV', {'for': 'php'}
Pack 'shawncplus/phpcomplete.vim', {'for': 'php'}

" Project:
Pack 'tpope/vim-dispatch' " autocmd FileType java let b:dispatch = 'javac %'
Pack 'tpope/vim-dotenv'

let g:enable_dadbod = 1
let g:enable_project = 1
let g:enable_test = 1

if executable('composer')
   " Use :Dispatch to run composer dump-autoload
  Pack 'noahfrederick/vim-composer' " :Composer
endif
if executable('laravel')
  " Vim dispatch enables :Console for artisan tinker
  Pack 'noahfrederick/vim-laravel' " :Artisan
endif

" Runtime:
let g:enable_fugitive = 1
if exists(':terminal')
  let g:enable_neoterm = 1
end
Pack 'tmux-plugins/vim-tmux', {'for': 'tmux'}
" " Obsolete since version 8.2.2345
" if executable('tmux') " len($TMUX)
"   " Fixes autoread in terminal running tmux
"   Pack 'tmux-plugins/vim-tmux-focus-events'
" endif

" Beancount
if executable('bean-check')
  Pack 'nathangrigg/vim-beancount'
endif

" Settings: ciaranm/detectindent
" let g:enable_editorconfig = 1
Pack 'tpope/vim-sleuth' " Automatic indentation detection

" Utilities: tomtom/tlib_vim, LucHermitte/lh-vim-lib, vim-jp/vital.vim
" Pack 'jamessan/vim-gnupg' " Transparent editing of *.gpg, *.pgp and *.asc
" Pack 'xolox/vim-misc' " Auto-load scripts

" Extras: wikitopian/hardmode, takac/vim-hardtime
" Pack 'chrisbra/csv.vim' " CSV files
" Pack 'chrisbra/unicode.vim' " Unicode glyphs
" Pack 'diepm/vim-rest-console' " REST console
" Pack 'itchyny/calendar.vim' " Calendar application (alt: mattn/calendar-vim)
" Pack 'koron/minimap-vim' " GUI only
" Pack 'metakirby5/codi.vim' " Interactive scratchpad
" Pack 'mhinz/vim-startify' " Start screen
" Pack 'vim-scripts/dbext.vim' " Database access

let g:enable_copilot = 1
