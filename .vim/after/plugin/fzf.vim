if exists(':Files')
    nnoremap <silent> <leader>pf :exe 'Files ' . projectroot#guess()<CR>
    nnoremap <silent> <leader>bb :Buffers<CR>
endif
