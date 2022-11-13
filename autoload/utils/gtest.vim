" gtest.vim - Utilities to detect gtest related things
" Maintainer:   Ilya Churaev <https://github.com/ilyachur>

let s:common_gtest_matcher = '\C^\s*\(\<\S*TEST\S*\>\)\s*(\s*\(\<\S*\>\)\s*,\s*\(\<\S*\>\).*).*$'
let s:typed_test_suite_matcher = '\C^\s*\(\<TYPED_TEST_SUITE\>\)\s*(\s*\(\<\S*\>\).*).*$'
let s:find_gtest_pattern = '\C^\s*\(\<\S*TEST\S*\>\).*$'

function! s:check_empty(list, size) abort
    let l:i = 0
    for l:elem in a:list
        if l:i > a:size
            break
        endif
        if empty(l:elem)
            return 1
        endif
        let l:i += 1
    endfor
    return 0
endfunction

" Detect GTest executable
function! utils#gtest#isGTestExecutable(exec_path) abort
    let l:help_out = system(utils#fs#fnameescape(a:exec_path) . ' --help')
    return l:help_out
    " return !empty(matchstr(l:help_out, 'This program contains tests written using Google Test'))
endfunction

" WARNING: At the current moment multi line test declaration is not supported
function! utils#gtest#hasGTestInLine(line) abort
    let l:parsed_line = matchlist(a:line, s:common_gtest_matcher)

    " l:parsed_line is emply if matcher doesn't work in other case check that
    " all test names were found
    if s:check_empty(l:parsed_line, 3)
        return 0
    endif

    if empty(l:parsed_line)
        let l:parsed_line = matchlist(a:line, s:typed_test_suite_matcher)
    endif

    if s:check_empty(l:parsed_line, 2)
        return 0
    endif

    return len(l:parsed_line) > 2
endfunction

function! utils#gtest#getGTestFilterFromLine(line) abort
    if !utils#gtest#hasGTestInLine(a:line)
        call utils#common#Warning('Cannot find GTest filter in current line.')
        return ''
    endif
    let l:parsed_line = matchlist(a:line, s:common_gtest_matcher)
    if !len(l:parsed_line)
        " typed_test_suite_matcher
        let l:parsed_line = matchlist(a:line, s:typed_test_suite_matcher)
        return printf('*%s.*', l:parsed_line[2])
    endif
    let l:gtest_filter = printf('%s.%s', l:parsed_line[2], l:parsed_line[3])
    if !empty(matchstr(l:parsed_line[1], '^.*_P$'))
        let l:gtest_filter = printf('*%s*', l:gtest_filter)
    endif
    return l:gtest_filter
endfunction

function! utils#gtest#findPreviousGTestDeclaration() abort
    silent call search(s:find_gtest_pattern, 'b')
endfunction
