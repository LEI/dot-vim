" Commands

" command! -nargs=0 -bar Install PlugInstall --sync | source $MYVIMRC
" command! -nargs=0 -bar Update PlugUpdate --sync | source $MYVIMRC
" command! -nargs=0 -bar Upgrade PlugUpdate! --sync | PlugUpgrade | source $MYVIMRC

" Enable soft wrap (break lines without breaking words)
" command! -nargs=* Wrap setlocal wrap linebreak nolist

" command! -nargs=0 HexDump :%!xxd
" command! -nargs=0 HexRestore :%!xxd -r
