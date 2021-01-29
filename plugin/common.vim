" can't use dot key -> dd
" can't swap in case(\*) -> git branch | grep -iE 'ms-' | sed -r 's/^\s+\*?(.+)/\1/g'
" can't use <leader>j when vmode
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
    execute "normal gi\<C-r>0"
    let @0 = bak
    return
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
        execute "normal gi\<C-r>\<C-p>0"
        execute "normal ddk\$"
    elseif a:vmodeType ==# 'v'
        execute "normal gi\<C-r>0"
    endif

    let @0 = bak
endfunction

function! s:moveLastInsertPoint(markSymbol)
    if <SID>getFilePathLastInsert() ==# ""
        return
    endif

    let currentFilePath = expand('%')
    if <SID>getFilePathLastInsert() !=# currentFilePath
        execute "e " . s:getFilePathLastInsert()
    endif

    let bak = @0
    execute "normal yiw"
    let currentRow = line('.')
    let currentCol = col('.')

    execute "normal gi"
    call <SID>shiftBasedDel('right')
    let targetRow = line('.')
    let targetCol = col('.')
    if currentRow !=# targetRow
        execute "normal gi\<C-r>0"
        call cursor(currentRow, currentCol)
        execute "normal \"_diw"
        execute "normal m" . a:markSymbol
        call cursor(targetRow, targetCol)
    elseif currentCol < targetCol
        execute "normal gi\<C-r>0"
        call cursor(currentRow, currentCol)
        execute "normal \"_diw"
        execute "normal m" . a:markSymbol
        call cursor(targetRow, (targetCol - len(@0)))
    elseif currentCol > targetCol
        execute "normal gi\<C-r>0"
        call cursor(currentRow, (currentCol + len(@0)))
        execute "normal \"_diw"
        execute "normal m" . a:markSymbol
        call cursor(targetRow, targetCol)
    endif

    let @0 = bak
    return
endfunction

function! s:shiftBasedDel(dirction)
    if a:dirction ==# 'right'
        if col('.') !=# 1
            execute "normal l"
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

function! s:replaceToBuf()
    execute "%s//" . escape(@0, '/\') . "/g"
endfunction

function! s:replaceToBufInVisual()
    execute "'<,'>s//" . escape(@0, '/\') . "/g"
endfunction

function! s:replaceToBufInLastSelected()
    execute "'<,'>s//" . escape(@0, '/\') . "/g"
endfunction

runtime   macros/matchit.vim
filetype  plugin indent on
syntax    enable
highlight cursorcolumn                                ctermbg=blue
highlight cursorcolumn                 ctermfg=green
highlight CursorColumn cterm=NONE                     ctermbg=239
highlight CursorLine   cterm=underline ctermfg=NONE   ctermbg=NONE
highlight incsearch                                   ctermbg=Black
highlight incsearch                    ctermfg=Yellow
highlight Search                                      ctermbg=Yellow
highlight Search                       ctermfg=Black
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
vnoremap c :<C-u>call <SID>setFilePathLastInsert(expand('%'))<CR>gvc
nnoremap s :call <SID>setFilePathLastInsert(expand('%'))<CR>s
nnoremap S :call <SID>setFilePathLastInsert(expand('%'))<CR>S
vnoremap s :<C-u>call <SID>setFilePathLastInsert(expand('%'))<CR>gvs
nnoremap o :call <SID>setFilePathLastInsert(expand('%'))<CR>o
nnoremap O :call <SID>setFilePathLastInsert(expand('%'))<CR>O
nnoremap dw "_cw<Esc>:call <SID>setFilePathLastInsert(expand('%')) \| call <SID>shiftBasedDel('right')<CR>
nnoremap diw "_ciw<Esc>:call <SID>setFilePathLastInsert(expand('%')) \| call <SID>shiftBasedDel('right')<CR>
nnoremap df "_ciw<Esc>:call <SID>setFilePathLastInsert(expand('%')) \| call <SID>shiftBasedDel('right')<CR>
nnoremap dd "_ddi<Esc>:call <SID>setFilePathLastInsert(expand('%'))<CR><S-^>
nnoremap D :call <SID>setFilePathLastInsert(expand('%'))<CR>"_C<Esc>
vnoremap d :<C-u>call <SID>setFilePathLastInsert(expand('%'))<CR>gv"_di<Esc>`<
nnoremap X :call <SID>setFilePathLastInsert(expand('%'))<CR>V"0di<Esc>`<
vnoremap x :<C-u>call <SID>setFilePathLastInsert(expand('%'))<CR>gv"0di<Esc>`<
nnoremap <leader>p "0yiwmO:call <SID>putStrToLastInsertPoint(@0)<CR>
vnoremap <leader>p "0ymO:call <SID>putStrToLastInsertPointInVmode(@0, visualmode())<CR>
nnoremap <leader>i "0yiwmO:call <SID>putStrToLastInsertPoint(@0)<CR>a
vnoremap <leader>i "0ymO:call <SID>putStrToLastInsertPointInVmode(@0, visualmode())<CR>a
nnoremap <leader>c :call <SID>moveLastInsertPoint('O')<CR>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
nnoremap / /\v
nnoremap * *N
nnoremap # #N
nnoremap <C-p> "0p
vnoremap <C-p> "0p
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <leader>y <S-j>
nnoremap <S-j> 10gj
nnoremap <S-k> 10gk
vnoremap <S-j> 10gj
vnoremap <S-k> 10gk
nnoremap <C-j> 3gj
nnoremap <C-k> 3gk
vnoremap <C-j> 3gj
vnoremap <C-k> 3gk
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>
vnoremap <C-e> 5<C-e>
vnoremap <C-y> 5<C-y>
nnoremap <C-h> g<S-^>
nnoremap <C-n> g<S-$>
vnoremap <C-h> g<S-^>
vnoremap <C-n> g<S-$><Left>
nnoremap <leader>n g<S-$>F
vnoremap <leader>n g<S-$><Left>F
nnoremap <leader>l `l
nnoremap <leader>L `L
nnoremap <leader>o `O
nnoremap <leader>j "_ciw<Esc>:call <SID>setFilePathLastInsert(expand('%'))<CR>`O
nnoremap <leader>w :w<CR>
nnoremap <leader>W :Explore<CR>
nnoremap <leader>E :e!<CR>
nnoremap <leader>Q :qall!<CR>
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
xnoremap * :<C-u>call <SID>searchInVmode()<CR>/<C-R>=@/<CR><CR>N
xnoremap # :<C-u>call <SID>searchInVmode()<CR>?<C-R>=@/<CR><CR>N
nnoremap <leader>r :call <SID>replaceToBuf()<CR>
vnoremap <leader>r :<C-u>call <SID>replaceToBufInVisual()<CR>
nnoremap <leader>s :%s///g<Left><Left>
vnoremap <leader>s :s///g<Left><Left>
nnoremap <leader>a gv:s///g<Left><Left>
nnoremap <leader>e gv:<C-u>call <SID>replaceToBufInLastSelected()<CR>
nnoremap <leader>q :normal @q<CR>
vnoremap <leader>q :normal @q<CR>
inoremap jk <Space><C-h><Esc>
nnoremap <Del> :bdelete<CR>
nnoremap <leader>u <Nop>
nnoremap <leader>; @:
vnoremap <leader>; @:
onoremap o iw
" emacs like
cnoremap <C-h> <BS>
cnoremap <C-d> <Del>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
execute "cnoremap " . s:attachAltKeyNotation('b') . " <C-Left>"
execute "cnoremap " . s:attachAltKeyNotation('f') . " <C-Right>"
cnoremap <C-o> <C-f>
" buf control map
execute "nnoremap <silent>" . s:attachAltKeyNotation('k') . " :bprevious\<CR>"
execute "nnoremap <silent>" . s:attachAltKeyNotation('j') . " :bnext\<CR>"
execute "nnoremap <silent>" . s:attachAltKeyNotation('h') . " :bfirst\<CR>"
execute "nnoremap <silent>" . s:attachAltKeyNotation('n') . " :blast\<CR>"

