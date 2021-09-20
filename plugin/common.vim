" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
	set nocompatible
endif

let mapleader            = "\<Space>"
let s:filePathInsertedAtLast = ""
let s:filePathSelectedAtLast = ""

function! s:setFilePathInsertedAtLast(filePath)
	let s:filePathInsertedAtLast = a:filePath
endfunction

function! s:getFilePathInsertedAtLast()
	return s:filePathInsertedAtLast
endfunction

function! s:setFilePathSelectedAtLast(filePath)
	let s:filePathSelectedAtLast = a:filePath
endfunction

function! s:getFilePathSelectedAtLast()
	return s:filePathSelectedAtLast
endfunction

function! s:openFileSelectedAtLast()
	if <SID>getFilePathSelectedAtLast() ==# ""
		return
	endif

	let currentFilePath = expand('%')
	if <SID>getFilePathSelectedAtLast() !=# currentFilePath
		execute "e " . s:getFilePathSelectedAtLast()
	endif
endfunction

function! s:putStrToLastInserted(str)
	if <SID>getFilePathInsertedAtLast() ==# ""
		return
	endif

	let currentFilePath = expand('%')
	if <SID>getFilePathInsertedAtLast() !=# currentFilePath
		execute "e " . s:getFilePathInsertedAtLast()
	endif

	let bak = @0
	let @0 = a:str
	execute "normal! gi\<C-R>0"
	let @0 = bak
endfunction

function! s:putStrToLastInsertedInVmode(str, vmodeType)
	if <SID>getFilePathInsertedAtLast() ==# ""
		return
	endif

	let currentFilePath = expand('%')
	if <SID>getFilePathInsertedAtLast() !=# currentFilePath
		execute "e " . s:getFilePathInsertedAtLast()
	endif

	let bak = @0
	let @0 = a:str
	if a:vmodeType ==# 'V'
		execute "normal! gi\<C-R>\<C-P>0"
		execute "normal! ddk\$"
	elseif a:vmodeType ==# 'v'
		execute "normal! gi\<C-R>0"
	endif

	let @0 = bak
endfunction

function! s:moveToLastInserted(markSymbol)
	if <SID>getFilePathInsertedAtLast() ==# ""
		return
	endif

	let bak = @0
	let currentFilePath = expand('%')
	if <SID>getFilePathInsertedAtLast() !=# currentFilePath
		execute "normal! yiw"
		execute "normal! \"_diw"
		execute "e " . s:getFilePathInsertedAtLast()
		call <SID>putStrToLastInserted(@0)
		let @0 = bak
		return
	endif

	execute "normal! yiw"
	let currentRow = line('.')
	let currentCol = col('.')
	execute "normal! gi"
	call <SID>adjustColPositionBasedDel('right')
	let targetRow = line('.')
	let targetCol = col('.')
	if currentRow !=# targetRow
		call <SID>putStrToLastInserted(@0)
		call cursor(currentRow, currentCol)
		execute "normal! \"_diw"
		execute "normal! m" . a:markSymbol
		execute "normal! i"
		call cursor(targetRow, targetCol)
	elseif currentCol < targetCol
		call <SID>putStrToLastInserted(@0)
		call cursor(currentRow, currentCol)
		execute "normal! \"_diw"
		execute "normal! m" . a:markSymbol
		call cursor(currentRow, currentCol)
		execute "normal! i"
		call cursor(targetRow, (targetCol - len(@0)))
	elseif currentCol > targetCol
		call <SID>putStrToLastInserted(@0)
		call cursor(currentRow, (currentCol + len(@0)))
		execute "normal! \"_diw"
		execute "normal! m" . a:markSymbol
		execute "normal! i"
		call cursor(targetRow, targetCol)
	endif

	let @0 = bak
endfunction

function! s:moveToLastInsertedInVmode(markSymbol, vmodeType)
	if a:vmodeType ==# 'v'
		call <SID>moveToLastInseredInVmodeCharWise(a:markSymbol)
	elseif a:vmodeType ==# 'V'
		call <SID>moveToLastInsertedInVmodeLineWise(a:markSymbol)
	endif
endfunction

function! s:moveToLastInseredInVmodeCharWise(markSymbol)
	if <SID>getFilePathInsertedAtLast() ==# ""
		return
	endif

	let bak = @0
	let currentFilePath = expand('%')
	if <SID>getFilePathInsertedAtLast() !=# currentFilePath
		execute "normal! gv\"0y"
		execute "normal! gv\"_d"
		execute "e " . s:getFilePathInsertedAtLast()
		call <SID>putStrToLastInserted(@0)
		let @0 = bak
		return
	endif

	execute "normal! gv\"0y"
	let currentRow = line('.')
	let currentCol = col('.')
	execute "normal! gi"
	call <SID>adjustColPositionBasedDel('right')
	let targetRow = line('.')
	let targetCol = col('.')
	if currentRow !=# targetRow
		call <SID>putStrToLastInserted(@0)
		call cursor(currentRow, currentCol)
		execute "normal! gv\"_d"
		execute "normal! m" . a:markSymbol
		execute "normal! i"
		call cursor(targetRow, targetCol)
	elseif currentCol < targetCol
		call <SID>putStrToLastInserted(@0)
		call cursor(currentRow, currentCol)
		execute "normal! gv\"_d"
		execute "normal! m" . a:markSymbol
		execute "normal! i"
		call cursor(targetRow, (targetCol - len(@0)))
	elseif currentCol > targetCol
		call <SID>putStrToLastInserted(@0)
		call cursor(currentRow, (currentCol + len(@0)))
		execute "normal! v" . (len(@0) - 1) . "l" . "\"_d"
		execute "normal! m" . a:markSymbol
		execute "normal! i"
		call cursor(targetRow, targetCol)
	endif

	let @0 = bak
endfunction

function! s:moveToLastInsertedInVmodeLineWise(markSymbol)
	if <SID>getFilePathInsertedAtLast() ==# ""
		return
	endif

	let bak = @0
	let currentFilePath = expand('%')
	if <SID>getFilePathInsertedAtLast() !=# currentFilePath
		execute "normal! gv\"0y"
		execute "normal! gv\"_d"
		execute "normal! i"
		call <SID>adjustColPositionBasedDel('right')
		execute "normal! m" . a:markSymbol
		execute "e " . s:getFilePathInsertedAtLast()
		call <SID>setFilePathInsertedAtLast(currentFilePath)
		execute "normal! gi\<C-R>\<C-P>0"
		execute "normal! ddk\$"
		let @0 = bak
		return
	endif

	execute "normal! `<"
	let currentRow = line('.')
	let currentCol = col('.')
	execute "normal! gv\"0y"
	let rowFirst = currentRow
	execute "normal! `>"
	let rowLast  = line('.')
	let rowCnt   = (rowLast - rowFirst + 1)
	call cursor(currentRow, currentCol)

	execute "normal! gi"
	call <SID>adjustColPositionBasedDel('right')
	let targetRow = line('.')
	let targetCol = col('.')

	execute "normal! gi\<C-R>\<C-P>0"
	execute "normal! ddk\$"
	execute "normal! gv\"_d"
	execute "normal! m" . a:markSymbol
	execute "normal! i"

	if currentRow < targetRow
		call cursor((targetRow - rowCnt), targetCol)
	elseif targetRow < currentRow
		call cursor(targetRow, targetCol)
	endif

	let @0 = bak
endfunction

function! s:delInVmode(vmodeType)
	if a:vmodeType ==# 'v'
		execute "normal! `<v`>\"_c"
		call <SID>adjustColPositionBasedDel('right')
	elseif a:vmodeType ==# 'V'
		execute "normal! `<V`>\"_c\<Esc>dd"
		execute "normal! \<S-^>i"
		call <SID>adjustColPositionBasedDel('right')
	endif
endfunction

function! s:adjustColPositionBasedDel(dirction)
	if a:dirction ==# 'right'
		if col('.') !=# 1
			execute "normal! l"
		endif
	endif
endfunction

function! s:createKeyNotationWithAlt(keyNotation)
	if has('unix')
		" check what key is alt by [Ctrl+V] and [Alt+f]
		return "" . a:keyNotation
	elseif has('win32')
		return '<M-' . a:keyNotation . '>'
	endif
endfunction

function! s:searchInVmode()
	let temp = @s
	norm! gv"sy
	let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
	let @s = temp
endfunction

function! s:replaceToRegister()
	execute "%s//" . escape(@0, '/\') . "/g"
endfunction

function! s:replaceToRegisterInLastSelected()
	execute "'<,'>s//" . escape(@0, '/\') . "/g"
endfunction

function! s:identifySID()
	return matchstr(expand('<sfile>'), '.\+<SNR>\zs\d\+\ze.\+SID$')
endfunction

function! s:jumpToUpperMark(markSymbol)
	let currentFilePath = expand('%')
	let upperCase = toupper(a:markSymbol)
	execute 'normal! `' . upperCase
	let jumpedFilePath = expand('%')
	if jumpedFilePath !=# currentFilePath
		execute "normal! `\"m" . upperCase . "zz"
		return
	endif
endfunction

function! s:adjustRowPosition()
	if line('.') > 30
		execute "normal! 30\<C-E>"
		return
	endif
endfunction

runtime macros/matchit.vim
filetype plugin indent on
syntax enable
highlight CursorColumn cterm=NONE      ctermfg=NONE   ctermbg=238
highlight CursorLine   cterm=underline ctermfg=NONE   ctermbg=NONE
highlight incsearch                    ctermfg=Yellow ctermbg=Black
highlight Search                       ctermfg=Black  ctermbg=Yellow
set backspace=indent,eol,start
set autoindent
set autoread
set cursorcolumn
set cursorline
set fileencodings=utf-8,sjis,euc-jp,latin1
set fileformats=unix,dos,mac
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:\ \ ,nbsp:%
set matchtime=1
set nobackup
set number
set pastetoggle=<f5>
set ruler
set showcmd
set showmatch
set smartcase
set tabstop=8
set shiftwidth=8
set title
set wildmenu
set wildmode=full
set statusline=%f\ [%l/%L]
set hidden
set completeopt=menuone
set mouse=c
nnoremap i :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>i
nnoremap I :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>I
nnoremap a :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>a
nnoremap A :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>A
nnoremap gi :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>gi
nnoremap cv :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>ciw
nnoremap cw :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>cw
nnoremap ciw :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>ciw
nnoremap cc :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>cc
nnoremap C :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>C
vnoremap c :<C-U>call <SID>setFilePathInsertedAtLast(expand('%'))<CR>gvc
" nnoremap s :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>s
nnoremap S :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>S
vnoremap s :<C-U>call <SID>setFilePathInsertedAtLast(expand('%'))<CR>gvs
nnoremap o :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>o
nnoremap O :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>O
nnoremap dw "_cw<Esc>:call <SID>setFilePathInsertedAtLast(expand('%')) \| call <SID>adjustColPositionBasedDel('right')<CR>
nnoremap diw "_ciw<Esc>:call <SID>setFilePathInsertedAtLast(expand('%')) \| call <SID>adjustColPositionBasedDel('right')<CR>
nnoremap di( "_ci(<Esc>:call <SID>setFilePathInsertedAtLast(expand('%')) \| call <SID>adjustColPositionBasedDel('right')<CR>
nnoremap di) "_ci)<Esc>:call <SID>setFilePathInsertedAtLast(expand('%')) \| call <SID>adjustColPositionBasedDel('right')<CR>
nnoremap di[ "_ci[<Esc>:call <SID>setFilePathInsertedAtLast(expand('%')) \| call <SID>adjustColPositionBasedDel('right')<CR>
nnoremap di] "_ci]<Esc>:call <SID>setFilePathInsertedAtLast(expand('%')) \| call <SID>adjustColPositionBasedDel('right')<CR>
nnoremap di< "_ci<<Esc>:call <SID>setFilePathInsertedAtLast(expand('%')) \| call <SID>adjustColPositionBasedDel('right')<CR>
nnoremap di> "_ci><Esc>:call <SID>setFilePathInsertedAtLast(expand('%')) \| call <SID>adjustColPositionBasedDel('right')<CR>
nnoremap df "_ciw<Esc>:call <SID>setFilePathInsertedAtLast(expand('%')) \| call <SID>adjustColPositionBasedDel('right')<CR>
nnoremap D :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>"_C<Esc>
vnoremap d :<C-U>call <SID>setFilePathInsertedAtLast(expand('%')) \| call <SID>delInVmode(visualmode())<CR>
nnoremap X :call <SID>setFilePathInsertedAtLast(expand('%'))<CR>V"0di<Esc>`<
vnoremap x :<C-U>call <SID>setFilePathInsertedAtLast(expand('%'))<CR>gv"0di<Esc>`<
nnoremap v :call <SID>setFilePathSelectedAtLast(expand('%'))<CR>v
nnoremap V :call <SID>setFilePathSelectedAtLast(expand('%'))<CR>V
nnoremap s F
vnoremap s F
nnoremap <C-V> :call <SID>setFilePathSelectedAtLast(expand('%'))<CR><C-V>
nnoremap <leader>p "0yiwmO:call <SID>putStrToLastInserted(@0)<CR>
vnoremap <leader>p "0ymO:call <SID>putStrToLastInsertedInVmode(@0, visualmode())<CR>
nnoremap <leader>i "0yiwmO:call <SID>putStrToLastInserted(@0)<CR>a
vnoremap <leader>i "0ymO:call <SID>putStrToLastInsertedInVmode(@0, visualmode())<CR>a
nnoremap <leader>j "_ciw<Esc>:call <SID>setFilePathInsertedAtLast(expand('%'))<CR>`O
vnoremap <leader>j "_c<Esc>:call <SID>setFilePathInsertedAtLast(expand('%'))<CR>`O
nnoremap <leader>c :call <SID>moveToLastInserted('O')<CR>
vnoremap <leader>c :<C-U>call <SID>moveToLastInsertedInVmode('O', visualmode())<CR>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
nnoremap / /\v
nnoremap * mI*N/<C-R>=@/ . '\C'<CR><CR>N
xnoremap * mI:<C-U>call <SID>searchInVmode()<CR>/<C-R>=@/ . '\C'<CR><CR>N
nnoremap # mm#N?<C-R>=@/ . '\C'<CR><CR>N
xnoremap # mI:<C-U>call <SID>searchInVmode()<CR>?<C-R>=@/ . '\C'<CR><CR>N
nnoremap <C-P> "0p
vnoremap <C-P> "0p
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <leader>y <S-j>
nnoremap <S-F> :find *
nnoremap <S-j> 10gj
nnoremap <S-k> 10gk
vnoremap <S-j> 10gj
vnoremap <S-k> 10gk
nnoremap <C-J> 3gj
nnoremap <C-K> 3gk
vnoremap <C-J> 3gj
vnoremap <C-K> 3gk
nnoremap <C-E> 5<C-E>
nnoremap <C-Y> 5<C-Y>
vnoremap <C-E> 5<C-E>
vnoremap <C-Y> 5<C-Y>
nnoremap <C-H> g<S-^>
nnoremap <C-N> g<S-$>
vnoremap <C-H> g<S-^>
vnoremap <C-N> g<S-$><Left>
nnoremap <leader>f g<S-$>F
vnoremap <leader>f g<S-$><Left>F
nnoremap <leader>w :w<CR>
nnoremap <leader>W :Explore<CR>
nnoremap <leader>E :e!<CR>
nnoremap <leader>Q :qall!<CR>
nnoremap <silent> <C-L> :<C-U>nohlsearch<CR><C-L>
nnoremap <leader>r :call <SID>replaceToRegister()<CR>
vnoremap <leader>r :<C-U>call <SID>replaceToRegisterInLastSelected()<CR>
nnoremap <leader>s :%s///g<Left><Left>
vnoremap <leader>s :s///g<Left><Left>
nnoremap <leader>e gv:<C-U>call <SID>replaceToRegisterInLastSelected()<CR>
nnoremap <leader>q :normal! @q<CR>
vnoremap <leader>q :normal! @q<CR>
nnoremap <C-^> <C-^>`"
vnoremap b ge
nnoremap ml mL
nnoremap <leader>l `L
" need bash setting -> stty start(stop) undef
nnoremap <C-Q> %
vnoremap <C-Q> %
nnoremap <leader>, :
vnoremap <leader>, :
nnoremap : ,
vnoremap : ,
" disabled
nnoremap R <Nop>
nnoremap U <Nop>
nnoremap Y <Nop>
nnoremap Z <Nop>
"	 need bash setting -> stty start(stop) undef
nnoremap <C-S> <Nop>
vnoremap <C-S> <Nop>
nnoremap <leader>a <Nop>
nnoremap <leader>b <Nop>
nnoremap <leader>u <Nop>
nnoremap <leader>t <Nop>
nnoremap <leader>h <Nop>
nnoremap <leader>m <Nop>
nnoremap <leader>z <Nop>
nnoremap <leader>x <Nop>
nnoremap <leader>o <Nop>
nnoremap <leader>v <Nop>
nnoremap <leader>' <Nop>
" for abbreviation
inoremap jk <C-]><C-]><Space><C-H><Esc>
nnoremap <Del> :bdelete<CR>
nnoremap <leader>; <C-^>`"zz
nnoremap <leader>k :call <SID>openFileSelectedAtLast()<CR>gv
vnoremap <leader>k <Esc>
" https://stackoverflow.com/questions/58330034/unexpected-space-character-while-in-explore-when-hitting-minus-key-in-neovi
nmap - <Plug>NetrwBrowseUpDir
nnoremap <leader>/ @:
vnoremap <leader>/ @:
onoremap o iw
" emacs like
cnoremap <C-H> <BS>
cnoremap <C-D> <Del>
cnoremap <C-B> <Left>
cnoremap <C-F> <Right>
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
execute "cnoremap " . s:createKeyNotationWithAlt('b') . " <C-Left>"
execute "cnoremap " . s:createKeyNotationWithAlt('f') . " <C-Right>"
cnoremap <C-O> <C-F>
" buf control map
execute "nnoremap <silent>" . s:createKeyNotationWithAlt('k') . " :bprevious\<CR>"
execute "nnoremap <silent>" . s:createKeyNotationWithAlt('j') . " :bnext\<CR>"
execute "nnoremap <silent>" . s:createKeyNotationWithAlt('h') . " :bfirst\<CR>"
execute "nnoremap <silent>" . s:createKeyNotationWithAlt('n') . " :blast\<CR>"
" complete
inoremap <expr> <Tab>   pumvisible() ? '<C-N>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-P>' : '<Tab>'
inoremap <expr> <C-J>   pumvisible() ? '<C-N>' : '<C-J>'
inoremap <expr> <C-K>   pumvisible() ? '<C-P>' : '<C-K>'
inoremap <expr> <C-P>   pumvisible() ? '<C-P><C-P><C-P>' : '<C-P>'
inoremap <expr> <C-N>   pumvisible() ? '<C-N><C-N><C-N>' : '<C-N>'
for k in split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_', '\zs')
	let t = string(k)
	let f = string(k . "\<C-N>\<C-P>")
	execute "inoremap <expr> " . k . " pumvisible() ? " . t . " : " . f
endfor
for l in split('abcdefghijklmnopqrstuvwxyz', '\zs')
	let u = toupper(l)
	execut "nnoremap '" . l " :call " . "<SNR>" . s:identifySID() . "_" . "jumpToUpperMark(" . string(u) . ")" . "<CR>" . " " . "26\<C-E>"
endfor
for l in split('abcdefghijklmnopqrstuvwxyz', '\zs')
	execute "nnoremap ," . l . " `" . l . "zz" . ":call " . "<SNR>" . s:identifySID() . "_" . "adjustRowPosition()" . "<CR>"
	execute "vnoremap ," . l . " `" . l . "zz" . ":call " . "<SNR>" . s:identifySID() . "_" . "adjustRowPosition()" . "<CR>"
endfor
" for abbreiviation.(conflict with autocomplete)
inoremap <CR> <C-]><C-]><CR>

