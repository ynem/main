function! s:isCwdInProjectList(projectList)
	let currentDir = getcwd()
	for projectDir in a:projectList
		" if projectDir ==# currentDir
		if match(currentDir, projectDir) !=# -1
			return 1
		endif
	endfor

	return 0
endfunction

function! s:indentCheckConfig()
	highlight WhiteSpaceBol ctermbg=red
	let extension = expand('%:e')
	if extension ==# 'htm' || extension ==# 'html' || extension ==# 'css'
		match WhiteSpaceBol /^ *\zs\t\+\ze *\|[^\t]*\zs \+\ze$/
	else
		match WhiteSpaceBol /^\t*\zs \+\ze\t*\|[^ ]*\zs \+\ze$/
	endif
endfunction

" vim
set history=200

" web
let euc_projects = [
\]

" https://stackoverflow.com/questions/39635841/vim-use-if-in-augroup
augroup format-unix
	autocmd!
	if <SID>isCwdInProjectList(euc_projects)
		autocmd BufNewFile,BufRead *.php,*.js,*.html,*.htm e ++ff=unix ++enc=euc-jp
	else
		autocmd BufNewFile,BufRead *.php,*.js,*.html,*.htm e ++ff=unix ++enc=utf-8
	endif
augroup END

autocmd BufEnter * call <SID>indentCheckConfig()

" vba
autocmd BufNewFile,BufRead *.bas,*.cls,*.frm e ++ff=dos ++enc=sjis

" grep
nnoremap S :call grep#do('', '.')<Left><Left><Left><Left><Left><Left><Left>
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
nnoremap F :Files<CR>

" https://github.com/rhysd/vim-clang-format
" https://clang.llvm.org/docs/ClangFormatStyleOptions.html
" https://stackoverflow.com/questions/56881048/how-to-get-clang-format-to-break-on-and
let g:clang_format#style_options = {
\"AccessModifierOffset"			: -4,
\"AllowShortIfStatementsOnASingleLine"	: "true",
\"AlwaysBreakTemplateDeclarations"	: "true",
\"Standard"				: "C++11",
\"BreakBeforeBraces"			: "Custom",
\"BraceWrapping"			: {
						\"AfterFunction" : "true",
						\"AfterClass"	 : "true",
					\},
\"BreakBeforeBinaryOperators"		: "All",
\"ColumnLimit"				: "120",
\"IndentCaseLabels"			: "false",
\"AlignConsecutiveAssignments"		: "true",
\}

" for google-vim-codefmt(css, html)
Glaive codefmt js_beautify_executable='js-beautify --indent-size 2'

