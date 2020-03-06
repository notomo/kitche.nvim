
let s:helper = KitcheTestHelper()
let s:suite = s:helper.suite('plugin.kitche')
let s:assert = s:helper.assert

function! s:suite.open_and_serve()
    KitcheOpen makefile

    call s:assert.window_count(2)
    call s:assert.filetype('kitche-makefile')
    call s:assert.file_name('Makefile')
    call s:assert.current_line('make start')
    call s:assert.not_found('make invalid')
    call s:assert.not_found('make .PHONY')

    KitcheServe

    call s:assert.window_count(1)
    call s:assert.buftype('terminal')
endfunction

function! s:suite.open_many_times()
    KitcheOpen makefile
    KitcheOpen makefile

    call s:assert.window_count(2)
    call s:assert.filetype('kitche-makefile')
    call s:assert.current_line('make start')

    call s:helper.search('make test')

    quit
    KitcheOpen makefile

    call s:assert.current_line('make test')
endfunction

function! s:suite.reload()
    KitcheOpen makefile

    call s:assert.current_line('make start')

    edit!

    call s:assert.current_line('make start')
endfunction

function! s:suite.look()
    KitcheOpen makefile
    KitcheLook

    call s:assert.window_count(1)
    call s:assert.tab_count(1)
    call s:assert.file_name('Makefile')

    KitcheOpen makefile
    KitcheLook

    call s:assert.tab_count(1)
endfunction
