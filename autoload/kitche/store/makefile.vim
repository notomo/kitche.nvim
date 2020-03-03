
function! kitche#store#makefile#new() abort
    let store = {'name': 'makefile'}

    let makefile_path = kitche#util#search_parent_recursive('Makefile', './')
    if empty(makefile_path)
        return v:null
    endif
    let store.id = makefile_path

    function! store.load() abort
        let lines = []
        for line in readfile(self.id)
            let target = matchstr(line, '\v^\zs\S*\ze:')
            if empty(target) || target ==# '.PHONY'
                continue
            endif
            call add(lines, 'make ' . target)
        endfor
        return lines
    endfunction

    function! store.serve(line) abort
        tabedit
        call termopen(a:line, {'cwd': fnamemodify(self.id, ':h')})
    endfunction

    return store
endfunction
