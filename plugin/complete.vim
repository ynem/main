set completeopt=menuone
inoremap <expr> <Tab>   pumvisible() ? '<C-n>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<Tab>'
inoremap <CR> <C-]><C-]><CR>
for k in split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_', '\zs')
    let t = string(k)
    let f = string(k . "\<C-x>\<C-p>\<C-n>")
    execute "inoremap <expr> " . k . " pumvisible() ? " . t . " : " . f
endfor

