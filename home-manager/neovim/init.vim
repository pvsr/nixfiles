let mapleader=" "
nnoremap <space> <nop>

filetype plugin indent on
syntax enable

set background=dark

" tmux, not sure if this is still necessary
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum

" transparency
if !has("gui_running")
    highlight Normal ctermbg=NONE guibg=NONE
    highlight NonText ctermbg=NONE guibg=NONE
endif

set termguicolors
set lazyredraw

set number
set relativenumber

set expandtab
set tabstop=2
set shiftwidth=2
set shiftround
set smartindent
set textwidth=80
set colorcolumn=+1
set fo+=l
set list

set hidden

set scrolloff=2
set sidescrolloff=5

set splitbelow
set splitright
set equalalways

set confirm
set undofile

set ignorecase
set smartcase

set wildignore=*.o,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set wildmode=longest,full
set wildignorecase

set inccommand=nosplit

set shortmess+=c

set mouse=a

noremap j gj
noremap k gk

inoremap <C-b> <C-o>h
inoremap <C-f> <C-o>l
inoremap <A-b> <C-o>ge
inoremap <A-f> <C-o>w
inoremap <A-d> <C-o>dw

nnoremap Y y$

nnoremap Q <nop>

cnoremap <C-A> <Home>
cnoremap <C-E> <End>

vnoremap < <gv
vnoremap > >gv

nnoremap <silent> <Leader>c :nohlsearch<CR>

nnoremap <Leader>bd :bdelete<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bp :bprev<CR>

" window management
nnoremap <A--> <C-W>S
nnoremap <silent> <A-_> :botright split<CR>
nnoremap <A-bar> <C-W>v
nnoremap <silent> <A-\> :vertical botright split<CR>

nnoremap <A-h> <C-W>h
nnoremap <A-j> <C-W>j
nnoremap <A-k> <C-W>k
nnoremap <A-l> <C-W>l
nnoremap <A-c> <C-W>c

" resume position
augroup LastPosition
    autocmd! BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
    autocmd! BufReadPost COMMIT_EDITMSG normal! gg
augroup END

autocmd FileType mail setl tw=72
autocmd FileType netrc setl noundofile noswapfile

autocmd VimResized * wincmd =
