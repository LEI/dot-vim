" Vim Plug

Plug 'mbbill/undotree', {'on': 'UndotreeToggle'} " (alt: gundo)
" Plug 'metakirby5/codi.vim' " Interactive scratchpad
" Plug 'tpope/vim-abolish' " Search, substitute and abbreviate variants
Plug 'tpope/vim-endwise' " Automatic end keywords
Plug 'tpope/vim-eunuch' " Helpers for UNIX shell commands
" Plug 'tpope/vim-obsession' " Continuously updated session files
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps
Plug 'tpope/vim-sleuth' " Automatic indentation detection (alt: ciaranm/detectindent)
Plug 'tpope/vim-surround' " Quoting/parenthesizing
Plug 'tpope/vim-vinegar' " Improved netrw directory browser (alt: justinmk/vim-dirvish)

let g:package#colorscheme_enabled = 1
let g:package#statusline_enabled = 1

" Improvements:
let g:package#commentary_enabled = 1
let g:package#fugitive_enabled = 1
let g:package#splitjoin_enabled = 1
" let g:package#tabular_enabled = 1
let g:package#unimpaired_enabled = 1

" Languages:
let g:package#polyglot_enabled = 1
" let g:package#tern_enabled = 1

" Search:
let g:package#ctrlp_enabled = 1

" Text Objects: kana/vim-textobj-user

" Formatting: google/vim-codefmt
" let g:package#editorconfig_enabled = 1 " Breaks &et

" Syntax Checkers: scrooloose/syntastic, maralla/validator.vim
let g:package#neomake_enabled = 0 " has('nvim') || v:version > 704 || v:version == 704 && has('patch503')
let g:package#ale_enabled = has('nvim') || v:version >= 800

" Auto Completion:
let g:package#omnicomplete_enabled = 1 " Custom <Tab> remap
let g:package#youcompleteme_enabled = 0 " has('python') || has('python3')
let g:package#ultisnips_enabled = g:package#youcompleteme_enabled
let g:package#deoplete_enabled = 0 " has('nvim') && has('python3')
let g:package#neocomplete_enabled = 0 " !has('nvim') && has('lua')
let g:package#neosnippet_enabled = g:package#deoplete_enabled || g:package#neocomplete_enabled
