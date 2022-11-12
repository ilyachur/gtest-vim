" gtest-vim.vim - Vim plugin for gtest integration
" Maintainer:   Ilya Churaev <https://github.com/ilyachur>

" Public functions {{{ "
function! gtest#Run(bang, ...) abort
    let l:args = []
    if !a:bang && !empty(g:gtest_test_filter)
        let l:args += [printf('--gtest_filter=%s', g:gtest_test_filter)]
    endif
    if !empty(g:cmake_build_target)
        let l:exec_path = utils#cmake#getBinaryPath(0) " Disable warning
        if !empty(l:exec_path) && utils#gtest#isGTestExecutable(l:exec_path)
            let l:args += a:000
            let l:args = [a:bang] + l:args
            call call('cmake4vim#RunTarget', l:args)
            return
        endif
    endif

    if !empty(g:gtest_executable) && utils#gtest#isGTestExecutable(g:gtest_executable)
        let l:conf = { g:gtest_executable : { 'app': g:gtest_executable, 'args': l:args } }
        call utils#common#executeCommand(join([utils#fs#fnameescape(g:gtest_executable)] + l:args), 1)
        call utils#config#vimspector#updateConfig(l:conf)
        return
    endif

    call utils#common#Warning('Please select gtest executable first!')
endfunction
" }}} Public functions "
