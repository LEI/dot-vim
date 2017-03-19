" Plugin configuration

" Improvements:
let g:enable_unimpaired = 1
" Plug 'jamessan/vim-gnupg' " Transparent editing of *.gpg, *.pgp and *.asc
" Plug 'justinmk/vim-sneak' " Jjumps to any location specified by two characters
Plug 'keith/investigate.vim' " Look up documentation with gK
" Plug 'mattn/emmet-vim' " Emmet
" Plug 'tpope/vim-abolish' " Search, substitute and abbreviate variants
Plug 'tpope/vim-commentary' " Comments
Plug 'tpope/vim-endwise' " Automatic end keywords
Plug 'tpope/vim-eunuch' " Helpers for UNIX shell commands
" Plug 'tpope/vim-obsession' " Continuously updated session files
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps
Plug 'tpope/vim-sleuth' " Automatic indentation detection (alt: ciaranm/detectindent)
Plug 'tpope/vim-surround' " Quoting/parenthesizing
Plug 'tpope/vim-vinegar' " Improved netrw directory browser (alt: justinmk/vim-dirvish)

" Editor Config: " google/vim-codefmt
Plug 'dahu/EditorConfig'
" Plug 'editorconfig/editorconfig-vim' " Official, python required
" Plug 'sgur/vim-editorconfig' " Breaks vim-sleuth (auto indent detection)

" Text Objects:
" Plug 'kana/vim-textobj-user'
" Plug 'jceb/vim-textobj-uri'
" Plug 'kana/vim-textobj-indent'
" Plug 'kana/vim-textobj-line'
" Plug 'lucapette/vim-textobj-underscore'
" Plug 'wellle/targets.vim'

" Undo Tree:
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
" Plug 'simnalamburt/vim-mundo'
" Plug 'sjl/gundo.vim'

" Utility Functions:
" Plug 'tomtom/tlib_vim'
" Plug 'LucHermitte/lh-vim-lib'

" Extras:
" Plug 'itchyny/calendar.vim'
" Plug 'metakirby5/codi.vim' " Interactive scratchpad
" Plug 'mhinz/vim-signify' " Sign column diff
" Plug 'mhinz/vim-startify' " Start screen

" Editing:
let g:enable_commentary = 1
let g:enable_splitjoin = 1
" let g:enable_tabular = 1

" Versioning:
let g:enable_fugitive = 1
" Plug 'gregsexton/gitv' " gitk

" Appearance:
let g:enable_colorscheme = 1
let g:enable_statusline = 1
let g:enable_tabline = 1

" Navigation:
let g:enable_ctags = 1
let g:enable_ctrlp = 1

" Languages:
let g:enable_polyglot = 1
let g:enable_tern = 1

" Syntax Checkers:
let g:enable_ale = 1
" let g:enable_neomake = 1
" scrooloose/syntastic, maralla/validator.vim, tomtom/checksyntax_vim...

" Auto Completion:
" let g:enable_youcompleteme = 1
" let g:enable_ultisnips = g:enable_youcompleteme
let g:enable_deoplete = has('nvim')
let g:enable_neocomplete = !has('nvim')
let g:enable_neosnippet = g:enable_deoplete || g:enable_neocomplete
