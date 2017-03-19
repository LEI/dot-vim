" Key bindings

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break
inoremap <C-U> <C-G>u<C-U>

" Yank from the cursor to the end of the line
noremap Y y$

" Visually select the text that was last edited/pasted
noremap gV `[v`]

" Move on wrapped lines unless a count is specified
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
" nnoremap 0 g0
" nnoremap $ g$ " FIXME :set wrap

" Restore visual selection after indent (breaks '.' dot repeat)
" vnoremap < <gv
" vnoremap > >gv

" Split navigation shortcuts
nnoremap <C-H> <C-w>h
nnoremap <C-J> <C-w>j
nnoremap <C-K> <C-w>k
nnoremap <C-L> <C-w>l

" Bubble single or multiple lines
noremap <C-Up> ddkP
noremap <C-Down> ddp
vnoremap <C-Up> xkP`[V`]
vnoremap <C-Down> xp`[V`]

" Repeat latest f, t, F or T [count] times
noremap <Tab> ;

" Repeat last command on next match
noremap ; :normal n.<CR>

" Make 'dot' work as expected in visual mode
" vnoremap . :norm.<CR>

" Paragraph reflow according to textwidth?
" vnoremap Q gv
" noremap Q gqap

" if maparg('<C-L>', 'n') ==# ''
"   nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
" endif

" Stop the highlighting for the 'hlsearch' option
nnoremap <silent> <Space> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" Edit in the same directory as the current file :e %%
cnoremap <expr> %% getcmdtype() == ':' ? fnameescape(expand('%:h')) . '/' : '%%'

" Use <Left> and <Right> keys to move the cursor in ':' command mode
" instead of selecting a different match, as <Tab> / <S-Tab> does
cnoremap <expr> <Left> getcmdtype() == ':' ? "\<Space>\<BS>\<Left>" : "\<Left>"
cnoremap <expr> <Right> getcmdtype() == ':' ? "\<Space>\<BS>\<Right>" : "\<Right>"

" Save as root with :w!!
"cnoremap <expr> w!! (exists(':SudoWrite') == 2 ? "SudoWrite" : "w !sudo tee % >/dev/null") . "\<CR>"
cnoremap w!! w !sudo tee % > /dev/null
" command W w !sudo tee % > /dev/null

" Remove trailing spaces
noremap _$ :call StripTrailingWhitespaces()<CR>

" Indent the whole file
noremap _= :call Preserve("normal gg=G")<CR>
