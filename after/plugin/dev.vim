" vim
set history=100

" web
augroup format-unix
    autocmd!
    autocmd BufNewFile,BufRead *.php,*.js,*.html,*.htm e ++ff=unix ++enc=euc-jp | syntax enable
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
nnoremap <leader>f :Files<CR>

" https://github.com/rhysd/vim-clang-format
" https://clang.llvm.org/docs/ClangFormatStyleOptions.html
" https://stackoverflow.com/questions/56881048/how-to-get-clang-format-to-break-on-and
let g:clang_format#style_options = {
            \"AccessModifierOffset"                : -4,
            \"AllowShortIfStatementsOnASingleLine" : "true",
            \"AlwaysBreakTemplateDeclarations"     : "true",
            \"Standard"                            : "C++11",
            \"BreakBeforeBraces"                   : "Custom",
            \"BraceWrapping"                       : {
                                                         \"AfterFunction" : "true",
                                                     \},
            \"BreakBeforeBinaryOperators"          : "All",
            \"ColumnLimit"                         : "0",
            \"IndentCaseLabels"                    : "false",
            \"AlignConsecutiveAssignments"         : "true",
\}

