
function! kitche#store#find(target) abort
    let pattern = printf('autoload/kitche/store/%s.vim', a:target)
    let paths = globpath(&runtimepath, pattern, v:true, v:true)
    call map(paths, { _, p -> fnamemodify(p, ':gs?\?/?:s?^.*\/autoload\/kitche\/store\/??:r')})
    for path in paths
        let F = function(printf('kitche#store#%s#new', substitute(path, '\/', '#', 'g')))
        return F()
    endfor
endfunction
