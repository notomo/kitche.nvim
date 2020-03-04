
let s:windows = {}

function! kitche#window#close() abort
    let ids = nvim_tabpage_list_wins(0)
    call filter(ids, { _, id -> has_key(s:windows, id) })
    for id in ids
        let window = s:windows[id]
        call window.close()
        call remove(s:windows, id)
    endfor
endfunction

function! kitche#window#open(bufnr) abort
    let window = {
        \ 'bufnr': a:bufnr,
        \ 'width': 80,
        \ 'height': 20,
    \ }

    function! window._open() abort
        let self.id =  nvim_open_win(self.bufnr, v:true, {
            \ 'relative': 'editor',
            \ 'width': self.width,
            \ 'height': self.height,
            \ 'row': &lines / 2 - (self.height / 2),
            \ 'col': &columns / 2 - (self.width / 2),
            \ 'anchor': 'NW',
            \ 'focusable': v:true,
            \ 'external': v:false,
        \ })
    endfunction

    function! window.close() abort
        if !empty(self.id) && nvim_win_is_valid(self.id)
            call nvim_win_close(self.id, v:true)
        endif
    endfunction

    call window._open()
    let s:windows[window.id] = window

    return window
endfunction
