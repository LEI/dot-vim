" Key bindings

" Change leader
let g:mapleader = "\<Space>"

" Yank from the cursor to the end of the line
map Y y$

" Visually select the text that was last edited/pasted
nmap gV `[v`]

" Move vertically on wrapped lines
nnoremap j gj
nnoremap k gk

" Split navigation shortcuts
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Clear highlighted search results (vim-sensible: Ctrl-L)
" nnoremap <Space> :nohlsearch<CR>

" Repeat latest f, t, F or T [count] times
noremap <Tab> ;

" Repeat last command on next match
noremap ; :normal n.<CR>

" Edit in the same directory as the current file
" cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

" Use <Left> and <Right> keys to move the cursor
" instead of selecting a different match:
" cnoremap <Left> <Space><BS><Left>
" cnoremap <Right> <Space><BS><Right>

" Quicker quit
noremap <Leader>q :q<CR>
" Save a file
noremap <Leader>w :w<CR>
" Save as root (or use :SudoWrite)
noremap <Leader>W :w !sudo tee % > /dev/null<CR>

" Bubble single or multiple lines
if get(g:, 'loaded_unimpaired', 0)
  nmap <C-Up> [e
  nmap <C-Down> ]e
  vmap <C-Up> [egv
  vmap <C-Down> ]egv
else
  nmap <C-Up> ddkP
  nmap <C-Down> ddp
  vmap <C-Up> xkP`[V`]
  vmap <C-Down> xp`[V`]
endif

" Insert tab at beginning of line, or use completion if not at beginning
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<Tab>"
  else
    return "\<C-n>"
  endif
endfunction

inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-p>
