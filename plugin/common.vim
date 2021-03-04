let mapleader            = "\<Space>"
let s:filePathLastInsert = ""

function! s:setFilePathLastInsert(filePath)
    let s:filePathLastInsert = a:filePath
endfunction

function! s:getFilePathLastInsert()
    return s:filePathLastInsert
endfunction

function! s:putStrToLastInsertPoint(str)
    if <SID>getFilePathLastInsert() ==# ""
        return
    endif

    let currentFilePath = expand('%')
    if <SID>getFilePathLastInsert() !=# currentFilePath
        execute "e " . s:getFilePathLastInsert()
    endif

    let bak = @0
    let @0 = a:str
    execute "normal! gi\<C-R>0"
    let @0 = bak
endfunction

function! s:putStrToLastInsertPointInVmode(str, vmodeType)
    if <SID>getFilePathLastInsert() ==# ""
        return
    endif

    let currentFilePath = expand('%')
    if <SID>getFilePathLastInsert() !=# currentFilePath
        execute "e " . s:getFilePathLastInsert()
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

function! s:openLastInsertPoint()
    if <SID>getFilePathLastInsert() ==# ""
        return
    endif

    let currentFilePath = expand('%')
    if <SID>getFilePathLastInsert() !=# currentFilePath
        execute "e " . s:getFilePathLastInsert()
    endif
endfunction

function! s:moveToLastInsertPoint(markSymbol)
    if <SID>getFilePathLastInsert() ==# ""
        return
    endif

    let bak = @0
    let currentFilePath = expand('%')
    if <SID>getFilePathLastInsert() !=# currentFilePath
        execute "normal! yiw"
        execute "normal! \"_diw"
        execute "e " . s:getFilePathLastInsert()
        call <SID>putStrToLastInsertPoint(@0)
        let @0 = bak
        return
    endif

    execute "normal! yiw"
    let currentRow = line('.')
    let currentCol = col('.')
    execute "normal! gi"
    call <SID>shiftBasedDel('right')
    let targetRow = line('.')
    let targetCol = col('.')
    if currentRow !=# targetRow
        call <SID>putStrToLastInsertPoint(@0)
        call cursor(currentRow, currentCol)
        execute "normal! \"_diw"
        execute "normal! m" . a:markSymbol
        call cursor(targetRow, targetCol)
    elseif currentCol < targetCol
        call <SID>putStrToLastInsertPoint(@0)
        call cursor(currentRow, currentCol)
        execute "normal! \"_diw"
        execute "normal! m" . a:markSymbol
        call cursor(targetRow, (targetCol - len(@0)))
    elseif currentCol > targetCol
        call <SID>putStrToLastInsertPoint(@0)
        call cursor(currentRow, (currentCol + len(@0)))
        execute "normal! \"_diw"
        execute "normal! m" . a:markSymbol
        call cursor(targetRow, targetCol)
    endif

    let @0 = bak
endfunction

function! s:moveToLastInsertPointInVmode(markSymbol, vmodeType)
    if a:vmodeType ==# 'v'
        call <SID>moveToLastInsertPointInVmodeCharWise(a:markSymbol)
    elseif a:vmodeType ==# 'V'
        call <SID>moveToLastInsertPointInVmodeLineWise(a:markSymbol)
    endif
endfunction

function! s:moveToLastInsertPointInVmodeCharWise(markSymbol)
    if <SID>getFilePathLastInsert() ==# ""
        return
    endif

    let bak = @0
    let currentFilePath = expand('%')
    if <SID>getFilePathLastInsert() !=# currentFilePath
        execute "normal! gv\"0y"
        execute "normal! gv\"_d"
        execute "e " . s:getFilePathLastInsert()
        call <SID>putStrToLastInsertPoint(@0)
        let @0 = bak
        return
    endif

    execute "normal! gv\"0y"
    let currentRow = line('.')
    let currentCol = col('.')
    execute "normal! gi"
    call <SID>shiftBasedDel('right')
    let targetRow = line('.')
    let targetCol = col('.')
    if currentRow !=# targetRow
        call <SID>putStrToLastInsertPoint(@0)
        call cursor(currentRow, currentCol)
        execute "normal! gv\"_d"
        execute "normal! m" . a:markSymbol
        call cursor(targetRow, targetCol)
    elseif currentCol < targetCol
        call <SID>putStrToLastInsertPoint(@0)
        call cursor(currentRow, currentCol)
        execute "normal! gv\"_d"
        execute "normal! m" . a:markSymbol
        call cursor(targetRow, (targetCol - len(@0)))
    elseif currentCol > targetCol
        call <SID>putStrToLastInsertPoint(@0)
        call cursor(currentRow, (currentCol + len(@0)))
        execute "normal! v" . (len(@0) - 1) . "l" . "\"_d"
        execute "normal! m" . a:markSymbol
        call cursor(targetRow, targetCol)
    endif

    let @0 = bak
endfunction

function! s:moveToLastInsertPointInVmodeLineWise(markSymbol)
    if <SID>getFilePathLastInsert() ==# ""
        return
    endif

    let bak = @0
    let currentFilePath = expand('%')
    if <SID>getFilePathLastInsert() !=# currentFilePath
        execute "normal! gv\"0y"
        execute "normal! gv\"_d"
        execute "e " . s:getFilePathLastInsert()
        execute "normal! gi\<C-R>\<C-P>0"
        execute "normal! ddk\$"
        execute "normal! m" . a:markSymbol
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
    call <SID>shiftBasedDel('right')
    let targetRow = line('.')
    let targetCol = col('.')

    execute "normal! gi\<C-R>\<C-P>0"
    execute "normal! ddk\$"
    execute "normal! gv\"_d"
    execute "normal! m" . a:markSymbol

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
        call <SID>shiftBasedDel('right')
    elseif a:vmodeType ==# 'V'
        execute "normal! `<V`>\"_c\<Esc>dd"
        execute "normal! \<S-^>i"
        call <SID>shiftBasedDel('right')
    endif
endfunction

function! s:shiftBasedDel(dirction)
    if a:dirction ==# 'right'
        if col('.') !=# 1
            execute "normal! l"
        endif
    endif
endfunction

function! s:attachAltKeyNotation(keyNotation)
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

runtime   macros/matchit.vim
filetype  plugin indent on
syntax    enable
" highlight incsearch                                   ctermbg=Black
" highlight Search                                      ctermbg=Yellow
highlight CursorColumn cterm=NONE      ctermfg=NONE   ctermbg=238
highlight CursorLine   cterm=underline ctermfg=NONE   ctermbg=NONE
highlight incsearch                    ctermfg=Yellow ctermbg=Black
highlight Search                       ctermfg=Black  ctermbg=Yellow
set autoindent
set autoread
set cursorcolumn
set cursorline
set expandtab
set fileencodings=utf-8,sjis,euc-jp,latin1
set fileformats=unix,dos,mac
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:>-,trail:-,nbsp:%
set matchtime=1
set nobackup
set nocompatible
set number
set pastetoggle=<f5>
set ruler
set shiftwidth=4
set showcmd
set showmatch
set smartcase
set tabstop=4
set title
set wildmenu
set wildmode=full
set statusline=%f\ [%l/%L]
set hidden
set completeopt=menuone
nnoremap i :call <SID>setFilePathLastInsert(expand('%'))<CR>i
nnoremap I :call <SID>setFilePathLastInsert(expand('%'))<CR>I
nnoremap a :call <SID>setFilePathLastInsert(expand('%'))<CR>a
nnoremap A :call <SID>setFilePathLastInsert(expand('%'))<CR>A
nnoremap gi :call <SID>setFilePathLastInsert(expand('%'))<CR>gi
nnoremap cv :call <SID>setFilePathLastInsert(expand('%'))<CR>ciw
nnoremap cw :call <SID>setFilePathLastInsert(expand('%'))<CR>cw
nnoremap ciw :call <SID>setFilePathLastInsert(expand('%'))<CR>ciw
nnoremap cc :call <SID>setFilePathLastInsert(expand('%'))<CR>cc
nnoremap C :call <SID>setFilePathLastInsert(expand('%'))<CR>C
vnoremap c :<C-U>call <SID>setFilePathLastInsert(expand('%'))<CR>gvc
nnoremap s :call <SID>setFilePathLastInsert(expand('%'))<CR>s
nnoremap S :call <SID>setFilePathLastInsert(expand('%'))<CR>S
vnoremap s :<C-U>call <SID>setFilePathLastInsert(expand('%'))<CR>gvs
nnoremap o :call <SID>setFilePathLastInsert(expand('%'))<CR>o
nnoremap O :call <SID>setFilePathLastInsert(expand('%'))<CR>O
nnoremap dw "_cw<Esc>:call <SID>setFilePathLastInsert(expand('%')) \| call <SID>shiftBasedDel('right')<CR>
nnoremap diw "_ciw<Esc>:call <SID>setFilePathLastInsert(expand('%')) \| call <SID>shiftBasedDel('right')<CR>
nnoremap df "_ciw<Esc>:call <SID>setFilePathLastInsert(expand('%')) \| call <SID>shiftBasedDel('right')<CR>
nnoremap D :call <SID>setFilePathLastInsert(expand('%'))<CR>"_C<Esc>
vnoremap d :<C-U>call <SID>setFilePathLastInsert(expand('%')) \| call <SID>delInVmode(visualmode())<CR>
nnoremap X :call <SID>setFilePathLastInsert(expand('%'))<CR>V"0di<Esc>`<
vnoremap x :<C-U>call <SID>setFilePathLastInsert(expand('%'))<CR>gv"0di<Esc>`<
nnoremap <leader>p "0yiwmO:call <SID>putStrToLastInsertPoint(@0)<CR>
vnoremap <leader>p "0ymO:call <SID>putStrToLastInsertPointInVmode(@0, visualmode())<CR>
nnoremap <leader>i "0yiwmO:call <SID>putStrToLastInsertPoint(@0)<CR>a
vnoremap <leader>i "0ymO:call <SID>putStrToLastInsertPointInVmode(@0, visualmode())<CR>a
nnoremap <leader>j "_ciw<Esc>:call <SID>setFilePathLastInsert(expand('%'))<CR>`O
vnoremap <leader>j "_c<Esc>:call <SID>setFilePathLastInsert(expand('%'))<CR>`O
nnoremap <leader>c :call <SID>moveToLastInsertPoint('O')<CR>
vnoremap <leader>c :<C-U>call <SID>moveToLastInsertPointInVmode('O', visualmode())<CR>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
nnoremap / /\v
nnoremap * mL*N/<C-R>=@/ . '\C'<CR><CR>N
nnoremap # mL#N?<C-R>=@/ . '\C'<CR><CR>N
nnoremap <C-P> "0p
vnoremap <C-P> "0p
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <leader>y <S-j>
nnoremap <leader>f :find *
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
nnoremap <leader>n g<S-$>F
vnoremap <leader>n g<S-$><Left>F
nnoremap ml mL
nnoremap <leader>l `L
nnoremap <leader>o `O
nnoremap <leader>w :w<CR>
nnoremap <leader>W :Explore<CR>
nnoremap <leader>E :e!<CR>
nnoremap <leader>Q :qall!<CR>
nnoremap <silent> <C-L> :<C-U>nohlsearch<CR><C-L>
xnoremap * mL:<C-U>call <SID>searchInVmode()<CR>/<C-R>=@/<CR><CR>N
xnoremap # :<C-U>call <SID>searchInVmode()<CR>?<C-R>=@/<CR><CR>N
nnoremap <leader>r :call <SID>replaceToRegister()<CR>
vnoremap <leader>r :<C-U>call <SID>replaceToRegisterInLastSelected()<CR>
nnoremap <leader>s :%s///g<Left><Left>
vnoremap <leader>s :s///g<Left><Left>
nnoremap <leader>a gv:s///g<Left><Left>
nnoremap <leader>e gv:<C-U>call <SID>replaceToRegisterInLastSelected()<CR>
nnoremap <leader>q :normal! @q<CR>
vnoremap <leader>q :normal! @q<CR>
nnoremap <C-^> <C-^>`"
" for abbreviation
inoremap jk <C-]><C-]><Space><C-H><Esc>
vnoremap <leader>; <Esc>
nnoremap <Del> :bdelete<CR>
nnoremap <leader>; <C-^>`"
nnoremap <leader>k gv
nnoremap <leader>u <Nop>
nnoremap <leader>t <Nop>
nnoremap <leader>h <Nop>
nnoremap <leader>z <Nop>
nnoremap <leader>x <Nop>
nnoremap <leader>v <Nop>
nnoremap <leader>' <Nop>
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
execute "cnoremap " . s:attachAltKeyNotation('b') . " <C-Left>"
execute "cnoremap " . s:attachAltKeyNotation('f') . " <C-Right>"
cnoremap <C-O> <C-F>
" buf control map
execute "nnoremap <silent>" . s:attachAltKeyNotation('k') . " :bprevious\<CR>"
execute "nnoremap <silent>" . s:attachAltKeyNotation('j') . " :bnext\<CR>"
execute "nnoremap <silent>" . s:attachAltKeyNotation('h') . " :bfirst\<CR>"
execute "nnoremap <silent>" . s:attachAltKeyNotation('n') . " :blast\<CR>"
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
    execute "nnoremap '" . l . " `" . u . "`\"m" . u
endfor
" for abbreiviation.(conflict with autocomplete)
inoremap <CR> <C-]><C-]><CR>

