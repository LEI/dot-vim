" Plugins configuration

" Appearance:
let g:enable_colorscheme = 1
let g:enable_statusline = 1
let g:enable_tabline = 1

" Editing:
let g:enable_commentary = 1
let g:enable_editorconfig = 1
let g:enable_splitjoin = 1
let g:enable_tabular = 1
Plug 'tpope/vim-sleuth' " Automatic indentation detection
" ciaranm/detectindent, tpope/vim-projectionist...
" Plug 'AndrewRadev/sideways.vim'
" Plug 'mattn/emmet-vim' " Emmet

" Versioning: tpope/vim-git
let g:enable_fugitive = 1
" Plug 'gregsexton/gitv' " gitk
" Plug 'mhinz/vim-signify' " Sign column

" Navigation: spolu/dwm.vim
let g:enable_ctags = 1
let g:enable_ctrlp = 1

" Languages:
let g:enable_tern = 1
Plug 'sheerun/vim-polyglot' " Syntax and indentation language pack
let g:jsx_ext_required = 1

" Plug 'fatih/vim-go', {'for': 'go'}
" Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
" Plug 'othree/javascript-libraries-syntax.vim', {'for': 'javascript'}
" Plug 'spf13/PIV', {'for': 'php'}

" Checkers:
let g:enable_ale = 1
" let g:enable_neomake = 1
" scrooloose/syntastic, maralla/validator.vim, tomtom/checksyntax_vim
" google/vim-codefmt, vim-scripts/LanguageTool

" Completion:
" let g:enable_youcompleteme = 1
" let g:enable_ultisnips = g:enable_youcompleteme
let g:enable_deoplete = has('nvim')
let g:enable_neocomplete = !has('nvim')
let g:enable_neosnippet = g:enable_deoplete || g:enable_neocomplete

" File Explorer: justinmk/vim-dirvish, Shougo/vimfiler.vim
Plug 'tpope/vim-vinegar' " Improved netrw directory browser

" File Type:
" Plug 'chrisbra/csv.vim' " CSV files

" Undo History: sjl/gundo.vim, simnalamburt/vim-mundo
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}

" Movements: justinmk/vim-sneak, goldfeld/vim-seek, tommcdo/vim-exchange
" Plug 'terryma/vim-expand-region' " Visually select increasingly larger regions
Plug 'tpope/vim-commentary' " Comments (alt: tomtom/tcomment_vim)
Plug 'tpope/vim-surround' " Quoting/parenthesizing

" Improvements: haya14busa/incsearch.vim, vim-scripts/YankRing.vim
let g:enable_textobj = 1
let g:enable_unimpaired = 1
Plug 'keith/investigate.vim' " Look up documentation with gK
" Plug 'tpope/vim-abolish' " Search, substitute and abbreviate variants
Plug 'tpope/vim-endwise' " Automatic end keywords
" Plug 'tpope/vim-obsession' " Continuously updated session files (alt: xolox/vim-session)
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps

" Utilities: tomtom/tlib_vim, LucHermitte/lh-vim-lib, vim-jp/vital.vim
" Plug 'jamessan/vim-gnupg' " Transparent editing of *.gpg, *.pgp and *.asc
Plug 'tpope/vim-eunuch' " Helpers for UNIX shell commands
" Plug 'xolox/vim-misc' " Auto-load scripts

" Extras: wikitopian/hardmode, takac/vim-hardtime
" Plug 'chrisbra/unicode.vim' " Unicode glyphs
" Plug 'diepm/vim-rest-console' " REST console
" Plug 'itchyny/calendar.vim' " Calendar application (alt: mattn/calendar-vim)
" Plug 'koron/minimap-vim' " GUI only
" Plug 'metakirby5/codi.vim' " Interactive scratchpad
" Plug 'mhinz/vim-startify' " Start screen
" Plug 'vim-scripts/dbext.vim' " Database access
