" Vundle and bundles configuration
source $HOME/.bundles.vim

" Enable Go support in an inteligent way
if !empty($GOROOT)
    set rtp+=$GOROOT/misc/vim
endif

" File/Syntax settings
au BufNewFile,BufRead *.less set filetype=less
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.wiki set filetype=creole
au BufNewFile,BufRead *.json      set ft=javascript
au FileType css     setlocal sw=4 sts=4
au FileType html    setlocal sw=2 sts=2
au FileType htmldjango  setlocal sw=2 sts=2
au FileType python  setlocal formatoptions-=t
au FileType yaml    setlocal sw=2 sts=2

syntax on

set modeline
set modelines=0

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2

" make searching not suck
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
noremap <leader><space> :noh<cr>:call clearmatches()<cr>
nnoremap <tab> %
vnoremap <tab> %

"makes j and k go by screen lines
nnoremap j gj
nnoremap k gk

"enable omnicomplete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascript#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" change the mapleader from \ to ,
let mapleader=","
"let maplocalleader="\"

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Mouse settings
set mouse=nv

" Map CTRL-N to create a new tab
:map <C-n> <ESC>:tabnew<RETURN>
" Map Tab and CTRL-Tab to move between tabs
:map <Tab> <ESC>:tabn<RETURN>
:map <C-Tab> <ESC>:tabp<RETURN>

" http://spin.atomicobject.com/2011/08/07/atomic-vim-config/
"set smartindent
set smarttab

" http://lucumr.pocoo.org/2010/7/29/sharing-vim-tricks/
set autochdir
set title

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_enable_signs=1
let g:syntastic_check_on_open=1
let g:syntastic_loc_list_number=1

" toggle paste mode
nmap <LocalLeader>pp :set paste!<cr>

" Add dashes to the list of 'word characters' for CSS files:
au Filetype css setlocal iskeyword+=-

" YES YES YES YES set autoread
set autoread

" Make [d work for local definitions in Python files.
au FileType python setlocal define=^\s*\\(def\\\\|class\\)

" Enable soft-wrapping for text files
autocmd FileType text,markdown,html,xhtml,eruby setlocal wrap linebreak nolist

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

" vim-powerline
let g:Powerline_symbols = 'fancy'
set laststatus=2 " Always show the statusline

" color
set t_Co=256 " Explicitly tell vim that the terminal has 256 colors
set background=dark
colorscheme badwolf

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Easy buffer navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l
noremap <leader>v <C-w>v

" open browser!
noremap <leader>b :!~/bin/open-browser<cr><cr>

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" DEATH TO F1
map <F1> <Esc>
imap <F1> <Esc>

" make ctrlp ignore shit
set wildignore+=*.so,*.pyc,*.un~,*.swp~,*/_site/*
" make fugitive work
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'

" Django
au BufNewFile,BufRead admin.py     setlocal filetype=python.django
au BufNewFile,BufRead urls.py      setlocal filetype=python.django
au BufNewFile,BufRead models.py    setlocal filetype=python.django
au BufNewFile,BufRead views.py     setlocal filetype=python.django
au BufNewFile,BufRead settings.py  setlocal filetype=python.django
au BufNewFile,BufRead forms.py     setlocal filetype=python.django

nnoremap _dt :set ft=htmldjango<CR>
nnoremap _pd :set ft=python.django<CR>

"force saving files that require root permission
cmap w!! %!sudo tee > /dev/null %

"" MAKE .swp~ AND .un~ FILES LESS ANNOYING
"" FROM <http://stackoverflow.com/a/9528322/609144>
" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim-backup or . if all else fails.
if isdirectory($HOME . '/.vim-backup') == 0
  :silent !mkdir -p ~/.vim-backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim-backup/
set backupdir^=./.vim-backup/
set backup

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim-swap, ~/tmp or .
if isdirectory($HOME . '/.vim-swap') == 0
  :silent !mkdir -p ~/.vim-swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim-swap//
set directory+=~/tmp//
set directory+=.

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim-undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim-undo') == 0
    :silent !mkdir -p ~/.vim-undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim-undo//
  set undofile
endif

" clam.vim
nnoremap ! :Clam<space>

" Unfuck my screen
noremap U :syntax sync fromstart<cr>:redraw!<cr>

" Scrollbinding
set scrollopt+=hor
nmap <LocalLeader>s :set scrollbind<cr>

" Change-inside-surroundings.vim
nmap <leader>cis :ChangeInsideSurrounding<cr>

" scratch.vim
nmap <leader><tab> :Scratch<cr>

" vim-commentary
nmap <leader>cc \\\
xmap <leader>cc \\

" color column at 80 characters
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" formd Markdown shortcuts
nmap <leader>fr :%! formd -r<CR>
nmap <leader>fi :%! formd -i<CR>

" Rainbow Parentheses
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" Treat underscore as word delimiter
set iskeyword-=_

" esckeys
" http://ksjoberg.com/vim-esckeys.html
set timeout timeoutlen=1000 ttimeoutlen=100

" find merge conflict markers
nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>
