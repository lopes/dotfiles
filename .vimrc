syntax on
set encoding=utf-8
set ruler
set number
set showmatch
set laststatus=2
set nojoinspaces

set wildmode=longest,list:full

set autoindent expandtab tabstop=4 shiftwidth=0
retab

set incsearch hlsearch ignorecase smartcase magic

inoremap <c-s> <c-o>:w<cr>
noremap  <c-s> <c-o>:w<cr>

set viminfo='10,\"30,:40,%,n~/.viminfo
au BufReadPost * if line("'\"")|execute("normal `\"")|endif

set nobackup noswapfile nowritebackup
