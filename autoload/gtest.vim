" gtest-vim.vim - Vim plugin for gtest integration
" Maintainer:   Ilya Churaev <https://github.com/ilyachur>

" Private functions {{{ "
" Path to executable (empty if no gtest executable) and
" 1 if cmake target executable, 0 in other case
function! s:getGTestExecutable() abort
    if !empty(g:cmake_build_target)
        let l:exec_path = utils#cmake#getBinaryPath(0) " Disable warning
        if !empty(l:exec_path) && utils#gtest#isGTestExecutable(l:exec_path)
            return [l:exec_path, 1]
        endif
    endif
    if !empty(g:gtest_executable) && utils#gtest#isGTestExecutable(g:gtest_executable)
        return [g:gtest_executable, 0]
    endif
    return ['', 0]
endfunction

function! s:getListTests() abort
    let [l:gtest_executable, l:is_cmake] = s:getGTestExecutable()
    if empty(l:gtest_executable)
        return ''
    endif
    " Get list tests and remove the first line
    return substitute(system(utils#fs#fnameescape(l:gtest_executable) . ' --gtest_list_tests'), '\v^Running.{-}\n(.*)', '\1', '')
endfunction
" }}} Private functions "

" Public functions {{{ "
" Run GTest
function! gtest#Run(bang, ...) abort
    let [l:gtest_executable, l:is_cmake] = s:getGTestExecutable()
    if empty(l:gtest_executable)
        call utils#common#Warning('Please select gtest executable first!')
        return
    endif
    let l:args = []
    let l:args += a:000
    for l:elem in l:args
        let l:gtest_filter = substitute(l:elem, '\v^--gtest_filter\=(.*)', '\1', '')
        if !empty(l:gtest_filter)
            let g:gtest_test_filter = l:gtest_filter
            let l:has_gtest_filter = 1
        endif
    endfor
    if !a:bang && !empty(g:gtest_test_filter) && !exists('l:has_gtest_filter')
        let l:args += [printf('--gtest_filter=%s', g:gtest_test_filter)]
    endif
    if l:is_cmake
        let l:args = [a:bang] + l:args
        silent call call('cmake4vim#RunTarget', l:args)
    else
        let l:conf = { l:gtest_executable : { 'app': l:gtest_executable, 'args': l:args } }
        silent call utils#common#executeCommand(join([utils#fs#fnameescape(l:gtest_executable)] + l:args), 1)
        silent call utils#config#vimspector#updateConfig(l:conf)
    endif
endfunction

" Run GTest under cursor
function! gtest#RunThis() abort
    if !utils#gtest#hasGTestInLine(getline('.'))
        call utils#gtest#findPreviousGTestDeclaration()
    endif
    let l:gtest_filter = utils#gtest#getGTestFilterFromLine(getline('.'))
    if !empty(l:gtest_filter)
        let g:gtest_test_filter = l:gtest_filter
        call gtest#Run(0)
    endif
endfunction

" Returns all tests
function! gtest#GetAllTests() abort
    let l:list_tests = split(s:getListTests(), '\n')
    let l:result_list = ['*']
    for l:test_line in l:list_tests
        if l:test_line[0] !=# ' '
            let l:test_case = l:test_line
            " Allow to run all test cases for suite
            call add(l:result_list, l:test_case . '*')
        else
            " Combine test case and test suite
            call add(l:result_list, substitute(l:test_line, '\v^\s*', l:test_case, ''))
        endif
    endfor
    return l:result_list
endfunction

function! gtest#CompleteTestFilter(arg_lead, cmd_line, cursor_pos) abort
    let l:tests_list = gtest#GetAllTests()
    let l:tests_list[0] = '--gtest_filter=' . l:tests_list[0]
    return join(l:tests_list, "\n--gtest_filter=")
endfunction
" }}} Public functions "
