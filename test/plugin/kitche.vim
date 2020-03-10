
let s:helper = KitcheTestHelper()
let s:suite = s:helper.suite('plugin.kitche')
let s:assert = s:helper.assert

function! s:suite.open_and_serve()
    KitcheOpen makefile

    call s:assert.window_count(2)
    call s:assert.filetype('kitche-makefile')
    call s:assert.file_name('Makefile')
    call s:assert.current_line('make -f Makefile start')
    call s:assert.not_found('make -f Makefile invalid')
    call s:assert.not_found('make -f Makefile .PHONY')

    KitcheServe

    call s:assert.window_count(1)
    call s:assert.buftype('terminal')
endfunction

function! s:suite.file_option()
    edit ./test.mk

    KitcheOpen makefile

    call s:assert.current_line('make -f test.mk build')
endfunction

function! s:suite.open_many_times()
    KitcheOpen makefile
    KitcheOpen makefile

    call s:assert.window_count(2)
    call s:assert.filetype('kitche-makefile')
    call s:assert.current_line('make -f Makefile start')

    call s:helper.search('make -f Makefile test')

    quit
    KitcheOpen makefile

    call s:assert.current_line('make -f Makefile test')
endfunction

function! s:suite.reload()
    KitcheOpen makefile

    call s:assert.current_line('make -f Makefile start')

    edit!

    call s:assert.current_line('make -f Makefile start')
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
