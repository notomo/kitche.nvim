
function! kitche#store#makefile#new() abort
    let store = {'name': 'makefile'}

    let makefile_path = s:search_makefile()
    if empty(makefile_path)
        return v:null
    endif
    let store.id = makefile_path

    function! store.load() abort
        let lines = []
        let file_name = fnamemodify(self.id, ':t')
        for line in readfile(self.id)
            let target = matchstr(line, '\v^\zs\S*\ze:')
            if empty(target) || target ==# '.PHONY'
                continue
            endif
            let cmd = printf('make -f %s %s', file_name, target)
            call add(lines, cmd)
        endfor
        return lines
    endfunction

    function! store.serve(line) abort
        tabedit
        call termopen(a:line, {'cwd': fnamemodify(self.id, ':h')})
    endfunction

    function! store.look(line) abort
        execute 'tab drop' self.id
    endfunction

    return store
endfunction

function! s:search_makefile() abort
    if &filetype ==? 'make'
        return expand('%:p')
    endif
    return kitche#util#search_parent_recursive('Makefile', './')
endfunction
