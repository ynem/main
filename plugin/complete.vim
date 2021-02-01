set completeopt=menuone,noinsert
inoremap <expr> <Tab> pumvisible() ? '<Down>' : '<Tab>'
for k in split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_', '\zs')
    let t = string(k)
    let f = string(k . "\<C-p>\<C-n>")
    execute "inoremap <expr> " . k . " pumvisible() ? " . t . " : " . f
endfor

