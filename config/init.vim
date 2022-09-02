" Plugins configuration

" Setting g:enable_<name> = 1 looks for config/<name>.vim

" Appearance:
let g:enable_colorscheme = 1
let g:enable_statusline = 1
let g:enable_tabline = 1

" Movements: goldfeld/vim-seek, tommcdo/vim-exchange
" Pack 'justinmk/vim-sneak'
" Pack 'terryma/vim-expand-region' " Visually select increasingly larger regions
Pack 'tpope/vim-commentary' " Comments (alt: tomtom/tcomment_vim)
Pack 'tpope/vim-surround' " Quoting/parenthesizing
" Pack 'tpope/vim-rsi' " Readline key bindings

" Improvements: haya14busa/incsearch.vim, vim-scripts/YankRing.vim
let g:enable_qf = 1
" let g:enable_textobj = 1
let g:enable_unimpaired = 1
Pack 'keith/investigate.vim' " Look up documentation with gK
" Pugg 'romainl/vim-qlist' " Persist 'include-search' and 'definition-search'
Pack 'tpope/vim-abolish' " Search, substitute and abbreviate variants
" Pack 'tpope/vim-characterize' " Unicode character metadata (ga)
Pack 'tpope/vim-endwise' " Automatic end keywords
" Pack 'tpope/vim-obsession' " Continuously updated session files (alt: xolox/vim-session)
Pack 'tpope/vim-repeat' " Enable repeating supported plugin maps

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

" https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim
let g:enable_coc = 1 " Language server completion and diagnostics

" Search:
let g:enable_ctags = 1
" let g:enable_ctrlp = 1
let g:enable_fzf = 1
if has('nvim')
  Pack 'kristijanhusak/vim-js-file-import', {'do': 'npm install'}
  let g:js_file_import_use_fzf = 1
endif

" Syntax Check:
let g:enable_ale = 1
" let g:enable_neomake = 1
" scrooloose/syntastic, maralla/validator.vim, tomtom/checksyntax_vim
" google/vim-codefmt, vim-scripts/LanguageTool

" Languages:
Pack 'sheerun/vim-polyglot' " Syntax and indentation language pack
" let g:polyglot_disabled = ['csv', 'graphql', 'tmux']
let g:jsx_ext_required = 1

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
let g:enable_ternjs = !get(g:, 'enable_youcompleteme', 0)
" Pack 'jelera/vim-javascript-syntax', {'for': 'javascript'}
" Pack 'othree/javascript-libraries-syntax.vim', {'for': 'javascript'}
Pack 'posva/vim-vue' ", {'for': 'vue.*'} & npm i -g eslint eslint-plugin-vue
Pack 'burnettk/vim-angular'

" PHP:
" Pack 'spf13/PIV', {'for': 'php'}
Pack 'shawncplus/phpcomplete.vim', {'for': 'php'}

" Project:
Pack 'tpope/vim-dispatch'
"Pack 'tpope/vim-projectionist'
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
Pack 'tmux-plugins/vim-tmux', {'for': 'tmux'}
if executable('tmux') " len($TMUX)
  " Fixes autoread in terminal running tmux
  Pack 'tmux-plugins/vim-tmux-focus-events'
endif

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
let g:enable_db = 1
let g:enable_test = 1

" Extras: wikitopian/hardmode, takac/vim-hardtime
" Pack 'chrisbra/csv.vim' " CSV files
" Pack 'chrisbra/unicode.vim' " Unicode glyphs
" Pack 'diepm/vim-rest-console' " REST console
" Pack 'itchyny/calendar.vim' " Calendar application (alt: mattn/calendar-vim)
" Pack 'koron/minimap-vim' " GUI only
" Pack 'metakirby5/codi.vim' " Interactive scratchpad
" Pack 'mhinz/vim-startify' " Start screen
" Pack 'vim-scripts/dbext.vim' " Database access
" Pack 'ap/vim-css-color' " Color preview

" Pack 'github/copilot.vim' " GitHub Copilot
