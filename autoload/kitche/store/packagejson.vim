
function! kitche#store#packagejson#new() abort
    let store = {'name': 'packagejson'}

    let path = kitche#util#search_parent_recursive('package.json', './')
    if empty(path)
        return v:null
    endif
    let store.id = path

    function! store.load() abort
        let loaded = json_decode(readfile(self.id))
        if !has_key(loaded, 'scripts')
            return []
        endif

        let lines = []
        for name in keys(loaded['scripts'])
            let cmd = printf('npm run %s', name)
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
        let target = matchstr(a:line, '\vnpm\s+run\s+\zs\S+\ze\s*')
        if empty(target)
            return
        endif
        let pattern = printf('"%s":', target)
        call search(pattern, 'w')
    endfunction

    return store
endfunction
