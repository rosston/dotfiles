let g:fzf_layout = { 'down': '33%' }
let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-/']

if exists(':Files')
    nnoremap <silent> <leader>pf :exe 'Files ' . projectroot#guess()<CR>
    nnoremap <silent> <leader>bb :Buffers<CR>
endif
