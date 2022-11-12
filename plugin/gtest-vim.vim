" gtest-vim.vim - Vim plugin for gtest integration
" Maintainer:   Ilya Churaev <https://github.com/ilyachur>

" Initialization {{{ "

" Plugin depends on https://github.com/ilyachur/cmake4vim
if exists('g:loaded_gtest_vim_plugin') || !exists('g:loaded_cmake4vim_plugin')
    finish
endif

let g:loaded_gtest_vim_plugin = 1

" }}} Initialization "

" Options {{{ "
if !exists('g:gtest_test_filter')
    let g:gtest_test_filter = ''
endif

" Gtest executable, for cmake project is not needed
if !exists('g:gtest_executable')
    let g:gtest_executable = ''
endif
" }}} Options "

" Commands {{{ "
command! -bang -nargs=? -complete=custom,gtest#CompleteTestFilter GTest call gtest#Run(<bang>0, <f-args>)
command! GTestRunThis call gtest#RunThis()
" }}} Commands "

" Mappings {{{
nnoremap <silent> <Plug>(GTest) :call gtestvim#Run(0)<CR>
nnoremap <silent> <Plug>(GTestRunThis) :call gtestvim#RunThis()<CR>
" }}} Mappings
