" Vim Plug

" Theme
Plug 'LEI/flattened' " altercation/vim-colors-solarized
" Plug 'LEI/vim-statusline'

" Improvments:
" Plug 'AndrewRadev/splitjoin.vim' " Line/multiline transitions
" Plug 'editorconfig/editorconfig-vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'} " Undo history visualizer
" Plug 'metakirby5/codi.vim' " Interactive scratchpad
" Plug 'tpope/vim-abolish' " Search, substitute and abbreviate variants
Plug 'tpope/vim-commentary' " Comment stuff out
Plug 'tpope/vim-endwise' " Automatic end keywords
Plug 'tpope/vim-eunuch' " Helpers for UNIX shell commands
" Plug 'tpope/vim-obsession' " Continuously updated session files
Plug 'tpope/vim-repeat' " Enable repeating supported plugin maps
Plug 'tpope/vim-sleuth' " Automatic indentation detection (alt: ciaranm/detectindent)
Plug 'tpope/vim-surround' " Quoting/parenthesizing
Plug 'tpope/vim-unimpaired' " Mappings
" Plug 'godlygeek/tabular' " Text aligning

" Navigation:
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy finder (alt: junegunn/fzf.vim)
Plug 'tpope/vim-vinegar' " Improved netrw directory browser (alt: justinmk/vim-dirvish)

" Version Control:
Plug 'tpope/vim-fugitive' " Git wrapper
" Plug 'shumphrey/fugitive-gitlab.vim' " Add Gitlab support

" Languages:
Plug 'sheerun/vim-polyglot' " Syntax and indentation language pack
" Plug 'ternjs/tern_for_vim' " Tern-based JavaScript support

" Text Objects: kana/vim-textobj-user

" Formatting: google/vim-codefmt

" Syntax Checkers:
" scrooloose/syntastic, maralla/validator.vim, w0rp/ale
if has('nvim') || v:version > 704 || v:version == 704 && has('patch503')
  Plug 'neomake/neomake'
endif

" Shell: bashate, shellcheck

" VimL: vim-vint
Plug 'syngan/vim-vimlint' | Plug 'ynkdir/vim-vimlparser'
