
function! kitche#messenger#clear() abort
    let f = {}
    function! f.default(message) abort
        echomsg a:message
    endfunction

    let s:func = { message -> f.default(message) }
endfunction

call kitche#messenger#clear()


function! kitche#messenger#set_func(func) abort
    let s:func = { message -> a:func(message) }
endfunction

function! kitche#messenger#new() abort
    let messenger = {
        \ 'func': s:func,
    \ }

    function! messenger.warn(message) abort
        echohl WarningMsg
        call self.func('[kitche] ' . a:message)
        echohl None
    endfunction

    return messenger
endfunction
