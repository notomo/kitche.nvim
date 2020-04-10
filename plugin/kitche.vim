if exists('g:loaded_kitche')
    finish
endif
let g:loaded_kitche = 1

command! -nargs=1 KitcheOpen call kitche#open(<q-args>)
command! KitcheServe call kitche#serve()
command! KitcheLook call kitche#look()

highlight default link KitcheCursorLine Search
