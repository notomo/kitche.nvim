
let s:buffers = {}

function! kitche#buffer#get_or_create(store) abort
    let id = a:store.id
    if has_key(s:buffers, id)
        return s:buffers[id]
    endif

    let bufnr = nvim_create_buf(v:false, v:true)
    let filetype = printf('kitche-%s', a:store.name)
    let name = printf('%s://%s', filetype, a:store.id)
    call nvim_buf_set_name(bufnr, name)
    call nvim_buf_set_option(bufnr, 'filetype', filetype)

    let buffer = {
        \ 'store': a:store,
        \ 'bufnr': bufnr,
    \ }

    function! buffer.render() abort
        let lines = self.store.load()
        call nvim_buf_set_lines(self.bufnr, 0, -1, v:true, lines)
    endfunction

    let s:buffers[a:store.id] = buffer
    execute printf('autocmd BufWipeout <buffer=%s> call s:on_wipe("%s")', bufnr, a:store.id)

    return buffer
endfunction

function! kitche#buffer#find(bufnr) abort
    for buffer in values(s:buffers)
        if buffer.bufnr == a:bufnr
            return buffer
        endif
    endfor

    return v:null
endfunction

function! s:on_wipe(id) abort
    if !has_key(s:buffers, a:id)
        return
    endif
    call remove(s:buffers, a:id)
endfunction
