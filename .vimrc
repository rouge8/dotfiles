filetype off
call pathogen#infect()
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on
au BufNewFile,BufRead *.less set filetype=less
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.wiki set filetype=creole
syntax on

set nocompatible

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
"set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set relativenumber
set undofile

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

" toggle paste mode
nmap <LocalLeader>pp :set paste!<cr>

" Add dashes to the list of 'word characters' for CSS files:
au Filetype css setlocal iskeyword+=-

" Gundo!
" http://sjl.bitbucket.org/gundo.vim/
nnoremap <F5> :GundoToggle<CR>

" YES YES YES YES set autoread
set autoread


" Make [d work for local definitions in Python files.
au FileType python setlocal define=^\s*\\(def\\\\|class\\)

" Enable soft-wrapping for text files
autocmd FileType text,markdown,html,xhtml,eruby setlocal wrap linebreak nolist

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

" python-guide.org
"set textwidth=79
"set shiftwidth=4
"set tabstop=4
"set expandtab
"set softtabstop=4
"set shiftround
"autocmd BufWritePost *.py call Pep8()

" Send visual selection to gist.github.com " Requires gist (brew install gist)
vnoremap <leader>G :w !gist -p -t %:e \| pbcopy<cr>

" vim-powerline
if $TERM != 'xterm' && !has("macunix")
    let g:Powerline_symbols = 'fancy'
endif
set laststatus=2 " Always show the statusline
set t_Co=256 " Explicitly tell vim that the terminal has 256 colors

set background=dark
colorscheme badwolf

" Save when losing focus
au FocusLost * :wa

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

" Filetype specific handling {{{
" only do this part when compiled with support for autocommands
if has("autocmd")

    augroup html_files "{{{
        au!

        " This function detects, based on HTML content, whether this is a
        " Django template, or a plain HTML file, and sets filetype accordingly
        fun! s:DetectHTMLVariant()
            let n = 1
            while n < 50 && n < line("$")
                " check for django
                if getline(n) =~ '{%\s*\(extends\|load\|block\|if\|for\|include\|trans\)\>'
                    set ft=htmldjango.html
                    return
                endif
                let n = n + 1
            endwhile
            " go with html
            set ft=html
        endfun

        autocmd BufNewFile,BufRead *.html,*.htm call s:DetectHTMLVariant()

        " Auto-closing of HTML/XML tags
        let g:closetag_default_xml=1
        autocmd filetype html,htmldjango let b:closetag_html_style=1
        autocmd filetype html,xhtml,xml source ~/.vim/scripts/closetag.vim
    augroup end " }}}

    augroup python_files "{{{
        au!

        " This function detects, based on Python content, whether this is a
        " Django file, which may enabling snippet completion for it
        fun! s:DetectPythonVariant()
            let n = 1
            while n < 50 && n < line("$")
                " check for django
                if getline(n) =~ 'import\s\+\<django\>' || getline(n) =~ 'from\s\+\<django\>\s\+import'
                    set ft=python.django
                    "set syntax=python
                    return
                endif
                let n = n + 1
            endwhile
            " go with html
            set ft=python
        endfun
        autocmd BufNewFile,BufRead *.py call s:DetectPythonVariant()

        " PEP8 compliance (set 1 tab = 4 chars explicitly, even if set
        " earlier, as it is important)
        autocmd filetype python setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
        "autocmd filetype python setlocal textwidth=80
        "autocmd filetype python match ErrorMsg '\%>80v.\+'

        " But disable autowrapping as it is super annoying
        autocmd filetype python setlocal formatoptions-=t
    augroup end " }}}
endif

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
