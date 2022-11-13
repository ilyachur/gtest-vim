# gtest-vim - GTest integration with Vim/Neovim

<p>
<a href="#"><img src="https://github.com/ilyachur/gtest-vim/workflows/CI/badge.svg" alt="Build Status"/></a>
<a href="https://codecov.io/gh/ilyachur/gtest-vim"><img src="https://codecov.io/gh/ilyachur/gtest-vim/branch/master/graph/badge.svg" alt="Code coverage"/></a>
<a href="https://github.com/ilyachur/gtest-vim/issues"><img src="https://img.shields.io/github/issues/ilyachur/gtest-vim" alt="Issues"/></a>
<a href="https://github.com/ilyachur/gtest-vim/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License"/></a>
<a href="https://github.com/ilyachur/gtest-vim/commits/master"><img src="https://img.shields.io/github/last-commit/ilyachur/gtest-vim" alt="Latest commit"/></a>
<a href="https://github.com/ilyachur/gtest-vim/stargazers"><img src="https://img.shields.io/github/stars/ilyachur/gtest-vim" alt="Repository's starts"/></a>
</p>

This plugin provides gtest integration to Vim/Neovim.
The plugin depends on [cmake4vim](https://github.com/ilyachur/cmake4vim) what allows to use information from cmake target in order to switch between different gtest executables.

## Installation

You can use VimPlug for installation:
```vim
Plug 'ilyachur/cmake4vim'
Plug 'ilyachur/gtest-vim'
```

## Commands

The current version of the plugin supports next commands:

### Basic

- **`:GTest`** runs gtest executable. Information from CMake target is used for cmake projects, in other case the path to gtest executable should be defined by `g:gtest_executable` variable.
- **`:GTest!`** runs gtest executable, but ignore arguments from **`g:gtest_usr_args`**.
- **`:GTestRunThis`** runs gtest test case under the cursor.


## `<Plug>` mappings

| `<Plug>` mapping          | Command                   |
|:--------------------------|:--------------------------|
| `(GTest)`                 | `:GTest`                  |
| `(GTestRunThis)`          | `:GTestRunThis`           |

## Variables

Plugin supports special global variables which are allow to change behaviour of commands (you can change them in your **.vimrc**):

- **`g:gtest_executable`** the path to gtest executable. Default is empty, in case of using gtest with cmake project this variable isn't used.
- **`g:gtest_usr_args`** allows to specify user arguments for gtest.

## Variables from [cmake4vim](https://github.com/ilyachur/cmake4vim) plugin

Some variables from [cmake4vim](https://github.com/ilyachur/cmake4vim) work also in case of using with non-cmake project:

- **`g:cmake_vimspector_support`**
- **`g:cmake_vimspector_default_configuration`**
- **`g:cmake_build_executor`**
- **`g:cmake_build_executor_height`**

Please read [cmake4vim README](https://github.com/ilyachur/cmake4vim/blob/master/README.md) to get more information about these variables.

## Contributing

Bug reports, feedback, feature and other pull requests are appreciated. Check the [Contributing Guidelines](CONTRIBUTING.md) for how to
create a feature request, submit a pull request or post an issue.

## References

### Author

Ilya Churaev ilyachur@gmail.com

### Licence

MIT
