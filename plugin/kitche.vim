if exists('g:loaded_kitche')
    finish
endif
let g:loaded_kitche = 1

if get(g:, 'kitche_debug', v:false)
    command! -nargs=+ -range=0 Kitche lua require("kitche/cleanup")("kitche"); require("kitche/command").main(<count>, {<line1>, <line2>}, <f-args>)
else
    command! -nargs=+ -range=0 Kitche lua require("kitche/command").main(<count>, {<line1>, <line2>}, <f-args>)
endif

highlight default link KitcheCursorLine Search
