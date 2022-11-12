" gtest.vim - Utilities to detect gtest related things
" Maintainer:   Ilya Churaev <https://github.com/ilyachur>

" Detect GTest executable
function! utils#gtest#isGTestExecutable(exec_path) abort
    let l:help_out = system(a:exec_path . ' --help')
    return !empty(matchstr(l:help_out, 'This program contains tests written using Google Test'))
endfunction
