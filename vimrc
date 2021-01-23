"
"  Copyright 2021 Kaede Hoshikawa
"
"  Licensed under the Apache License, Version 2.0 (the "License");
"  you may not use this file except in compliance with the License.
"  You may obtain a copy of the License at
"
"      http://www.apache.org/licenses/LICENSE-2.0
"
"  Unless required by applicable law or agreed to in writing, software
"  distributed under the License is distributed on an "AS IS" BASIS,
"  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
"  See the License for the specific language governing permissions and
"  limitations under the License.

" Install vim-plug if it does not exist.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
" Colour Scheme
Plug 'sonph/onehalf', {'rtp': 'vim/'}

" Auto Format / Code Style / Linting / Indentation
Plug 'dense-analysis/ale'
Plug 'bronson/vim-trailing-whitespace'

" Auto Complete / Code Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-endwise'
Plug 'ervandew/supertab'
Plug 'tpope/vim-surround'

" Code Visibility / Navigation
Plug 'wfxr/minimap.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
Plug 'maximbaz/lightline-ale'

" Source Control
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Search
Plug 'mileszs/ack.vim'

" Rust
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'

" Python
Plug 'davidhalter/jedi-vim'

" Stylesheets
Plug 'ap/vim-css-color'

" Terraform
Plug 'hashivim/vim-terraform'

" Shortcuts
Plug 'tpope/vim-eunuch'

call plug#end()

" Install Plugins
autocmd VimEnter * if exists("*plug#begin") && len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" GVim / MacVim
if has("gui_running")
  set guifont=Monaco:h12
  if has("gui_macvim")
  " CtrlP OS-X Menu remapping
    macmenu &File.New\ Tab key=<D-S-t>

  endif

  if has("autocmd")
    " Automatically resize splits when resizing MacVim window
    autocmd VimResized * wincmd =
  endif
endif

" Global
set nocompatible
set clipboard^=unnamed,unnamedplus
if has('mouse')
  set mouse+=a
endif

set colorcolumn=80
set number
set ruler
syntax enable

if !isdirectory($HOME . '/.vim/_backup/')
  call mkdir($HOME . '/.vim/_backup/', 'p')
endif
set backupdir^=~/.vim/_backup//

if !isdirectory($HOME . '/.vim/_temp/')
  call mkdir($HOME . '/.vim/_temp/', 'p')
endif
set directory^=~/.vim/_temp//

" Saves when lost focus
au FocusLost * silent! wall

" Keymap
" upper/lower word
nmap <leader>u mQviwU`Q
nmap <leader>l mQviwu`Q

" upper/lower first char of word
nmap <leader>U mQgewvU`Q
nmap <leader>L mQgewvu`Q

" Map Command-[ and Command-] to indenting or outdenting
" while keeping the original selection in visual mode
if has("gui_macvim") && has("gui_running")
  vmap <D-]> >gv
  vmap <D-[> <gv

  nmap <D-]> >>
  nmap <D-[> <<

  omap <D-]> >>
  omap <D-[> <<

  imap <D-]> <Esc>>>i
  imap <D-[> <Esc><<i
endif

" Status Line
set laststatus=2  " always show the status bar

" [git: master]
function g:VimRcGitBranch()
  if !exists("*FugitiveHead")
    return ""
  endif

  let l:branch = FugitiveHead()
  if l:branch == ""
    return ""
  endif

  return "[git: " . l:branch . "]"
endfunction

let g:lightline = {
      \   'colorscheme': 'one',
      \   'active': {
      \     'left': [
      \       [ 'mode', 'paste' ],
      \       [ 'gitbranch' ],
      \       [ 'readonly', 'relativepath', 'modified' ]
      \     ],
      \     'right': [
      \       [ 'linter_checking', 'linter_errors', 'linter_warnings',
      \         'linter_infos', 'linter_ok' ],
      \       [ 'lineinfo' ],
      \       [ 'percent' ],
      \       [ 'fileformat', 'fileencoding', 'filetype' ]
      \     ]
      \   },
      \   'component_function': {
      \     'gitbranch': 'g:VimRcGitBranch'
      \   },
      \ }

let g:lightline.component_expand = {
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_infos': 'lightline#ale#infos',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \   'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component_type = {
      \   'linter_checking': 'right',
      \   'linter_infos': 'right',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'right',
      \ }

" Don't show Insert / View / Normal anymore
set noshowmode

function g:VimRcUpdateStatusLine()
  if exists("*lightline#init")
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
  endif
endfunction

" Search Settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" Remember Last Cursor Position
au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
  \| exe "normal! g`\"" | endif

" Colour Scheme
" Switch to Light Theme
function g:VimRcSwitchToLightScheme()
  try
    colorscheme onehalflight
  catch /^Vim\%((\a\+)\)\=:E185/
    " Color Scheme onehalflight is not installed.
    return
  endtry

  set background=light
  let g:lightline.colorscheme='one'
  call g:VimRcUpdateStatusLine()
endfunction

" Switch to Dark Theme
function g:VimRcSwitchToDarkScheme()
  colorscheme onehalfdark
  set background=dark
  let g:lightline.colorscheme='onehalfdark'
  call g:VimRcUpdateStatusLine()
endfunction

function g:VimRcDetectDarkModeCallback(channel, msg)
  if a:msg =~ "on"
    if &background != 'dark'
      call g:VimRcSwitchToDarkScheme()
    endif
  elseif &background != 'light'
    call g:VimRcSwitchToLightScheme()
  endif
endfunction

" If system("dark-mode status") is used Vim may get sluggish / laggy.
function g:VimRcDetectDarkMode(timer)
  call job_start(["dark-mode", "status"], {'out_cb': 'g:VimRcDetectDarkModeCallback'})
endfunction

" Default is Light Theme
call g:VimRcSwitchToLightScheme()

" Dark Mode detection
" To use this feature, you need to `brew install dark-mode`
if executable("dark-mode")
  " Checking every 0.5 seconds provides a relatively smooth transitioning
  " experience between light and dark theme when system theme changes.
  let s:dark_mode_timer = timer_start(500, 'g:VimRcDetectDarkMode', {'repeat': -1})
  call g:VimRcDetectDarkMode(s:dark_mode_timer)
endif

" Spacing
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode

" List chars
set listchars=""                  " Reset the listchars
set listchars=tab:\|\             " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
                                  " off and the line continues beyond the left of the screen

" Ignore Certain Files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*/tmp/librarian/*,*/.vagrant/*,*/.kitchen/*,*/vendor/cookbooks/*
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*
set wildignore+=*.swp,*~,._*

" NERDTree
autocmd VimEnter * if exists("*NERDTreeFocus") | NERDTree | wincmd p | endif
let NERDTreeShowHidden = 1
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" Map Command-D to Toggle Between NerdTree and Center Buffer
if has("gui_macvim") && has("gui_running")
  function g:VimRcToggleBufNerdTree()
    if g:NERDTree.GetWinNum() != winnr()
      call NERDTreeFocus()
    else
      wincmd p
    endif
  endfunction

  nmap <silent> <D-d> :call g:VimRcToggleBufNerdTree()<Enter>
  vmap <silent> <D-d> :call g:VimRcToggleBufNerdTree()<Enter>
  imap <silent> <D-d> <Esc>:call g:VimRcToggleBufNerdTree()<Enter>
endif

" Minimap
" You need to `brew install wfxr/code-minimap/code-minimap`
let g:minimap_auto_start = 1
let g:minimap_width = 20

function g:VimRcAutoExitMinimap()
  if exists("*minimap#vim#MinimapClose")
    if winnr("$") == 2 && g:NERDTree.IsOpen()
      call minimap#vim#MinimapClose()
    endif
  endif
endfunction

autocmd BufEnter * call g:VimRcAutoExitMinimap()

" ALE
let g:ale_fixers = {
\   '*': [ 'remove_trailing_lines', 'trim_whitespace' ],
\}

let g:ale_linters = {}
let g:ale_fix_on_save = 1

" Markdown
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown
au FileType markdown setlocal wrap linebreak textwidth=72 nolist

" Python
let g:jedi#force_py_version = 3
let g:jedi#completions_command = ""
au FileType python setlocal tabstop=4 shiftwidth=4
let g:ale_linters.python = [ 'flake8', 'mypy' ]
let g:ale_fixers.python = ['black', 'isort', 'autoimport']

" Rust
let g:rustfmt_autosave = 1  " Temporary Fix until rustfmt works with ALE again.
let g:ale_rust_cargo_use_clippy = 1
let g:ale_linters.rust = [ 'cargo', 'rls' ]
let g:ale_fixers.rust = [ 'rustfmt' ]

" CSS
autocmd Filetype css setlocal tabstop=4 shiftwidth=4

" Terraform
let g:terraform_align = 1
let g:terraform_fmt_on_save = 1
