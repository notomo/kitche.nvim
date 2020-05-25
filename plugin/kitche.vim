if exists('g:loaded_kitche')
    finish
endif
let g:loaded_kitche = 1

command! -nargs=+ KitcheOpen lua require 'kitche/command'.open(<f-args>)
command! KitcheServe lua require 'kitche/command'.serve()
command! KitcheLook lua require 'kitche/command'.look()

highlight default link KitcheCursorLine Search
