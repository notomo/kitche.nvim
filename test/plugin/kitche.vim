
let s:helper = KitcheTestHelper()
let s:suite = s:helper.suite('plugin.kitche')
let s:assert = s:helper.assert

function! s:suite.open_and_serve()
    KitcheOpen makefile

    call s:assert.window_count(2)
    call s:assert.filetype('kitche-makefile')
    call s:assert.current_line('make start')

    KitcheServe

    call s:assert.window_count(1)
    call s:assert.buftype('terminal')
endfunction

function! s:suite.open_twice()
    KitcheOpen makefile
    KitcheOpen makefile

    call s:assert.window_count(2)
    call s:assert.filetype('kitche-makefile')
    call s:assert.current_line('make start')
endfunction
