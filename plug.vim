" Vim Plug

" Plug 'editorconfig/editorconfig-vim'
" Plug 'LEI/vim-statusline'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'} " Undo history visualizer
" Plug 'metakirby5/codi.vim' " Interactive scratchpad
" Plug 'tpope/vim-abolish' " Search, substitute and abbreviate variants
Plug 'tpope/vim-endwise' " Automatic end keywords
Plug 'tpope/vim-eunuch' " Helpers for UNIX shell commands
" Plug 'tpope/vim-obsession' " Continuously updated session files
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps
Plug 'tpope/vim-sleuth' " Automatic indentation detection (alt: ciaranm/detectindent)
Plug 'tpope/vim-surround' " Quoting/parenthesizing
Plug 'tpope/vim-vinegar' " Improved netrw directory browser (alt: justinmk/vim-dirvish)

" Text Objects: kana/vim-textobj-user

" Formatting: google/vim-codefmt

" Syntax Checkers: scrooloose/syntastic, maralla/validator.vim
let g:package#neomake_enabled = 0 " has('nvim') || v:version > 704 || v:version == 704 && has('patch503')
let g:package#ale_enabled = has('nvim') || v:version >= 800

" Auto Completion:
let g:package#omnicomplete_enabled = 1

let g:package#youcompleteme_enabled = 0 " has('python') || has('python3')
let g:package#ultisnips_enabled = g:package#youcompleteme_enabled

let g:package#deoplete_enabled = 0 " has('nvim') && has('python3')
let g:package#neocomplete_enabled = 0 " !has('nvim') && has('lua')
let g:package#neosnippet_enabled = g:package#deoplete_enabled || g:package#neocomplete_enabled

" TernJS for Vim
let g:package#tern_enabled = 0
