if &compatible
  set nocompatible
endif

call plug#begin('~/.vim/plugged')

" general editing
Plug 'cakebaker/scss-syntax.vim' " scss
Plug 'ervandew/supertab' "tab completion
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "fuzzy finder
Plug 'junegunn/fzf.vim' "finder vim bindings
Plug 'junegunn/vim-xmark', { 'do': 'make' } " markdown
Plug 'leafgarland/typescript-vim' " typescript
Plug 'nviennot/molokai' "colors
Plug 'scrooloose/nerdcommenter' "easy commenting
Plug 'scrooloose/nerdtree' "filesystem explorer
Plug 'tpope/vim-endwise' "end blocks
Plug 'tpope/vim-fugitive'  "git
Plug 'tpope/vim-rails', { 'for': 'ruby' } " ruby
Plug 'tpope/vim-repeat'  "repeat custom commands
Plug 'vim-airline/vim-airline' "status bar
Plug 'Xuyuanp/nerdtree-git-plugin' "git status for NERDTree

call plug#end()

" Display options
colorscheme molokai

filetype plugin indent on
syntax on
set shell=/usr/bin/zsh
set t_Co=256
set number
set nowrap
set lazyredraw
set nocursorline

runtime macros/matchit.vim

set backspace=eol,start,indent  " Allow backspacing over indent, eol, & start
set smarttab                    " Make <tab> and <backspace> smarter
set expandtab
set tabstop=2
set shiftwidth=2
set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.

au BufRead,BufNewFile *.md setf markdown
au BufRead,BufNewFile *.rake,*.rabl,*.jbuilder setf ruby

set laststatus=2

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Misc
set noswapfile
set nobackup

" Search settings
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch
map <space> :nohlsearch<cr>

set wildmenu
set wildmode=list:longest,full

" Show me where 80 chars is
set colorcolumn=80
hi ColorColumn ctermbg=235 guibg=#2c2d27

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

"""""""""""""""""""""""""
" Keybindings
"""""""""""""""""""""""""
let mapleader=','
let localmapleader=','

map <Leader>w :set invwrap<cr>
map <Leader>p :set invpaste<cr>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize window splits
nnoremap <Up>    3<C-w>-
nnoremap <Down>  3<C-w>+
nnoremap <Left>  3<C-w><
nnoremap <Right> 3<C-w>>

nnoremap <S-l> gt
nnoremap <S-h> gT

noremap k gk
noremap j gj
nnoremap <leader>pi :source ~/.vimrc<cr>:PlugInstall<cr>

" json
nnoremap <silent> <leader>jj :%!python -m json.tool<cr>

" fzf shortcuts
let g:fzf_history_dir = '~/.local/share/fzf-history'
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <Leader>h :History<cr>

nnoremap <Leader>a :Ag<cr>

" open netrw
nnoremap <silent> <Leader>v :Vexplore<cr>
nnoremap <silent> <Leader>s :Sexplore<cr>

" NERDTree
nnoremap <C-g> :NERDTreeToggle<cr>
nnoremap <C-f> :NERDTreeFind<cr>

vnoremap s :!sort<CR>

" go to previous file in buffer
nnoremap ,, <C-^>

"  goto method definition
map gm <C-]>

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
nnoremap <Leader>n :call RenameFile()<cr>

function! StripWhitespace()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  :%s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

if filereadable(expand("~/.custom.vim"))
  source ~/.custom.vim
endif

" from https://github.com/garybernhardt/dotfiles
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
"
" Test running here is contextual in two different ways:
"
" 1. It will guess at how to run the tests. E.g., if there's a Gemfile
"    present, it will `bundle exec rspec` so the gems are respected.
"
" 2. It remembers which tests have been run. E.g., if I'm editing user_spec.rb
"    and hit enter, it will run rspec on user_spec.rb. If I then navigate to a
"    non-test file, like routes.rb, and hit return again, it will re-run
"    user_spec.rb. It will continue using user_spec.rb as my 'default' test
"    until I hit enter in some other test file, at which point that test file
"    is run immediately and becomes the default. This is complex to describe
"    fully, but simple to use in practice: always hit enter to run tests. It
"    will run either the test file you're in or the last test file you hit
"    enter in.
"
" 3. Sometimes you want to run just one test. For that, there's <leader>T,
"    which passes the current line number to the test runner. RSpec knows what
"    to do with this (it will run the first test it finds at or below the
"    given line number). It probably won't work with other test runners.
"    'Focusing' on a single test in this way will be remembered if you hit
"    enter from non-test files, as described above.
"
" 4. Sometimes you don't want contextual test running. In that case, there's
"    <leader>a, which runs everything.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MapCR()
  nnoremap <cr> :call RunTestFile()<cr>
endfunction
call MapCR()
nnoremap <leader>r :call RunNearestTest()<cr>
"nnoremap <leader>a :call RunTests('')<cr>
" run the test on current line
" nnoremap <leader>r :execute "!bundle exec rspec %:" . line(".")<cr>


function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Are we in a test file?
    let in_test_file = match(expand("%"), '\(_spec.rb\|_test.rb\|test_.*\.py\|_test.py\)$') != -1

    " Run the tests for the previously-marked file (or the current file if
    " it's a test).
    if in_test_file
        call SetTestFile(command_suffix)
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile(command_suffix)
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@% . a:command_suffix
endfunction

function! RunTests(filename)
    let test_runner = system('pgrep -fl test_commands.sh')

    if !test_runner
      exec ":silent !tmux split-window -p 30 './.test_commands.sh'"
    end

    " Write the file and run tests for the given filename
    if expand("%") != ""
      :w
    end

    let cmd = 'bundle exec rspec'
    exec ":silent !echo 'echo running tests...' > .test_commands"
    exec ":silent !echo " . cmd . " " . a:filename . " > .test_commands"

    redraw!
endfunction
