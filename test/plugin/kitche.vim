
let s:helper = KitcheTestHelper()
let s:suite = s:helper.suite('plugin.kitche')
let s:assert = s:helper.assert

function! s:suite.open_and_serve()
    KitcheOpen makefile

    call s:assert.window_count(2)
    call s:assert.filetype('kitche-makefile')
    call s:assert.file_name('Makefile')
    call s:assert.current_line('make -f Makefile start')
    call s:assert.found('make -f test.mk build')
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
    call s:assert.not_found('make -f Makefile start')
    call s:assert.line_count(1)
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
    call s:helper.search('make -f Makefile test')

    KitcheLook

    call s:assert.window_count(1)
    call s:assert.tab_count(1)
    call s:assert.file_name('Makefile')
    call s:assert.current_line('test:')

    KitcheOpen makefile
    KitcheLook

    call s:assert.tab_count(1)
    call s:assert.current_line('test:')
endfunction

function! s:suite.open_package_json()
    KitcheOpen packagejson

    call s:assert.filetype('kitche-packagejson')
    call s:assert.file_name('package.json')
    call s:assert.found('npm run start')
    call s:assert.found('npm run build')

    KitcheServe

    call s:assert.window_count(1)
    call s:assert.buftype('terminal')
endfunction

function! s:suite.look_package_json()
    KitcheOpen packagejson
    call s:helper.search('npm run start')

    KitcheLook

    call s:assert.window_count(1)
    call s:assert.tab_count(1)
    call s:assert.file_name('package.json')
    call s:assert.current_line('    "start": "echo start",')

    KitcheOpen packagejson
    KitcheLook

    call s:assert.tab_count(1)
    call s:assert.current_line('    "start": "echo start",')
endfunction

function! s:suite.more_targets()
    KitcheOpen notfound packagejson
    call s:assert.file_name('package.json')
endfunction
