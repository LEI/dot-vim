" Plugins configuration

" Appearance:
let g:enable_colorscheme = 1
let g:enable_statusline = 1
let g:enable_tabline = 1

" File Explorer: Shougo/vimfiler.vim
Plug 'justinmk/vim-dirvish' " Path navigator
" Plug 'tpope/vim-vinegar' " Improved netrw directory browser

" Undo History: sjl/gundo.vim, simnalamburt/vim-mundo
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}

" Movements: goldfeld/vim-seek, tommcdo/vim-exchange
" Plug 'justinmk/vim-sneak'
" Plug 'terryma/vim-expand-region' " Visually select increasingly larger regions
Plug 'tpope/vim-commentary' " Comments (alt: tomtom/tcomment_vim)
Plug 'tpope/vim-surround' " Quoting/parenthesizing
" Plug 'tpope/vim-rsi' " Readline key bindings

" Improvements: haya14busa/incsearch.vim, vim-scripts/YankRing.vim
let g:enable_textobj = 1
let g:enable_unimpaired = 1
Plug 'keith/investigate.vim' " Look up documentation with gK
" Plug 'romainl/vim-qf' " Quickfix window commands, settings and mappings
" Pugg 'romainl/vim-qlist' " Persist 'include-search' and 'definition-search'
" Plug 'tpope/vim-abolish' " Search, substitute and abbreviate variants
" Plug 'tpope/vim-characterize' " Unicode character metadata (ga)
Plug 'tpope/vim-endwise' " Automatic end keywords
" Plug 'tpope/vim-obsession' " Continuously updated session files (alt: xolox/vim-session)
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps

" Editing: mattn/emmet-vim
let g:enable_commentary = 1
" Plug 'AndrewRadev/sideways.vim'
" Plug 'AndrewRadev/splitjoin.vim'
" plug 'tommcdo/vim-lion' " Align by charactef
Plug 'tpope/vim-eunuch' " Better UNIX shell commands

" Settings: ciaranm/detectindent, tpope/vim-projectionist
" let g:enable_editorconfig = 1
Plug 'tpope/vim-sleuth' " Automatic indentation detection

" Completion:
" let g:enable_youcompleteme = 1
" let g:enable_ultisnips = g:enable_youcompleteme
" let g:enable_deoplete = has('nvim')
" let g:enable_neocomplete = !has('nvim')
" let g:enable_neosnippet = g:enable_deoplete || g:enable_neocomplete
Plug 'ajh17/VimCompletesMe'

" Search:
let g:enable_ctags = 1
let g:enable_ctrlp = 1
" Plug 'junegunn/fzf.vim'

" Syntax Check:
let g:enable_ale = 1
" let g:enable_neomake = 1
" scrooloose/syntastic, maralla/validator.vim, tomtom/checksyntax_vim
" google/vim-codefmt, vim-scripts/LanguageTool

" Languages:
Plug 'sheerun/vim-polyglot' " Syntax and indentation language pack
let g:polyglot_disabled = ['tmux']
let g:jsx_ext_required = 1

" Runtime:
let g:enable_git = 1
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}

" Golang:
" Plug 'fatih/vim-go', {'for': 'go'}

" JavaScript:
let g:enable_tern = !get(g:, 'enable_youcompleteme', 0)
" Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
" Plug 'othree/javascript-libraries-syntax.vim', {'for': 'javascript'}

" PHP:
" Plug 'spf13/PIV', {'for': 'php'}

" Utilities: tomtom/tlib_vim, LucHermitte/lh-vim-lib, vim-jp/vital.vim
" Plug 'jamessan/vim-gnupg' " Transparent editing of *.gpg, *.pgp and *.asc
" Plug 'xolox/vim-misc' " Auto-load scripts

" Extras: wikitopian/hardmode, takac/vim-hardtime
" Plug 'chrisbra/csv.vim' " CSV files
" Plug 'chrisbra/unicode.vim' " Unicode glyphs
" Plug 'diepm/vim-rest-console' " REST console
" Plug 'itchyny/calendar.vim' " Calendar application (alt: mattn/calendar-vim)
" Plug 'koron/minimap-vim' " GUI only
" Plug 'metakirby5/codi.vim' " Interactive scratchpad
" Plug 'mhinz/vim-startify' " Start screen
" Plug 'vim-scripts/dbext.vim' " Database access
