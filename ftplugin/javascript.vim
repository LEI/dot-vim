" JavaScript

setlocal omnifunc=javascriptcomplete#CompleteJS

iabbrev cl! console.log()<Left><C-r>=Eatchar('\s')<CR>
iabbrev cl;! console.log();<Left><Left><C-r>=Eatchar('\s')<CR>

" Simple re-format for minified Javascript
command! UnMinify call UnMinify()
function! UnMinify()
    %s/{\ze[^\r\n]/{\r/g
    %s/){/) {/g
    %s/};\?\ze[^\r\n]/\0\r/g
    %s/;\ze[^\r\n]/;\r/g
    %s/[^\s]\zs[=&|]\+\ze[^\s]/ \0 /g
    normal ggVG=
endfunction
