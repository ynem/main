" vim
set history=100

" web
augroup format-unix
    autocmd!
    autocmd BufNewFile,BufRead *.php,*.js,*.html,*.htm e ++ff=unix | syntax enable
augroup END

" vba
autocmd BufNewFile,BufRead *.bas,*.cls,*.frm e ++ff=dos ++enc=sjis

" grep
nnoremap <leader>d :call grep#do('', '.')<Left><Left><Left><Left><Left><Left><Left>
nnoremap <leader>g :set operatorfunc=grep#doByOperator<cr>g@
vnoremap <leader>g :<c-u>call grep#doByOperator(visualmode())<cr>

" https://github.com/junegunn/vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" https://github.com/tpope/vim-commentary
augroup comment_string
    autocmd!
    autocmd FileType vba setlocal commentstring='\ %s
augroup END

" https://github.com/airblade/vim-gitgutter
set updatetime=100

" https://github.com/junegunn/fzf.vim
" nnoremap <leader>f :Files<CR>

