if exists(':Files')
    " Find root of project
    fun! s:fzf_root()
        let path = finddir(".git", expand("%:p:h").";")
        return fnamemodify(substitute(path, ".git", "", ""), ":p:h")
    endfun

    fun! s:jira_list_handler(lines)
        let issue_key = split(a:lines[0])[0]
        execute 'normal!a' . issue_key
    endfun

    command! Jira call fzf#run({
        \ 'source': 'gluejira my-issues',
        \ 'sink*': function('<SID>jira_list_handler'),
        \ 'window': 'belowright 10new'})

    nnoremap <silent> <leader><space> :exe 'Files ' . <SID>fzf_root()<CR>
    nnoremap <silent> <leader>ls :Buffers<CR>
endif
