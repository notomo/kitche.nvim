
function! kitche#open(target) abort
    let store = kitche#store#find(a:target)
    if empty(store)
        return kitche#messenger#new().warn('not found store for target: ' . a:target)
    endif

    call kitche#window#close()

    let buffer = kitche#buffer#get_or_create(store)
    call buffer.render()

    call kitche#window#open(buffer.bufnr)
endfunction

function! kitche#serve() abort
    let bufnr = bufnr('%')
    let buffer = kitche#buffer#find(bufnr)
    if empty(buffer)
        return kitche#messenger#new().warn('not kitche buffer')
    endif

    let line = getline('.')

    let store = buffer.store
    call kitche#window#close()

    return store.serve(line)
endfunction
