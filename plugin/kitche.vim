if exists('g:loaded_kitche')
    finish
endif
let g:loaded_kitche = 1

if get(g:, 'kitche_debug', v:false)
    command! -nargs=+ Kitche lua require("kitche/cleanup")("kitche"); require("kitche/command").main(<f-args>)
else
    command! -nargs=+ Kitche lua require("kitche/command").main(<f-args>)
endif

highlight default link KitcheCursorLine Search
