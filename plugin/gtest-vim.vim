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
" Gtest executable, for cmake project is not needed
let g:gtest_executable = get(g:, 'gtest_executable', '')
" Option allows to specify gtest arguments
let g:gtest_usr_args =   get(g:, 'gtest_usr_args',   '')
" }}} Options "

" Commands {{{ "
command! -bang -nargs=? -complete=custom,gtest#CompleteTestFilter GTest call gtest#Run(<bang>0, <f-args>)
command! GTestRunThis call gtest#RunThis()
" }}} Commands "

" Mappings {{{
nnoremap <silent> <Plug>(GTest) :call gtestvim#Run(0)<CR>
nnoremap <silent> <Plug>(GTestRunThis) :call gtestvim#RunThis()<CR>
" }}} Mappings
