
function! kitche#util#search_parent_recursive(file_name_pattern, start_path) abort
    let path = fnamemodify(a:start_path, ':p')
    while path !=? '//'
        let files = glob(path . a:file_name_pattern, v:false, v:true)
        if !empty(files)
            let file = files[0]
            return isdirectory(file) ? file . '/' : file
        endif
        let path = fnamemodify(path, ':h:h') . '/'
    endwhile
    return ''
endfunction
