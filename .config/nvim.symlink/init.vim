" change the mapleader from \ to ,
let mapleader=','

if &shell =~# 'fish$'
  set shell=bash
endif

" vim-plug configuration
exec 'source ' . stdpath('config') . '/plugins.vim'

" Lua configuration
lua require('config')

" Enable soft-wrapping for text files
augroup softwrap
  au!
  au FileType text,markdown,html,xhtml,eruby setlocal wrap linebreak nolist
augroup END

function! MaybeLSPFormat()
  if exists('b:no_autoformat')
    return
  endif
  lua vim.lsp.buf.format()
endfunction

" ~/forks
augroup forks
  au!
  au BufNewFile,BufRead ~/forks/**/* let b:no_autoformat=1
augroup END

" Python
augroup python
  au!
  au FileType python au BufWritePre <buffer> call MaybeLSPFormat()
augroup END

" Rust
augroup rust
  au!
  au FileType rust au BufWritePre <buffer> lua vim.lsp.buf.format()
augroup END

" Lua
augroup lua
  au!
  au FileType lua au BufWritePre <buffer> call MaybeLSPFormat()
augroup END

" Go
augroup go
  au!
  au FileType go au BufWritePre <buffer> call MaybeLSPFormat()
augroup END

" Fish
augroup fish
  au!
  " Set up :make to use fish for syntax checking.
  au FileType fish compiler fish
  au FileType fish au BufWritePre <buffer> call MaybeLSPFormat()
augroup END

" Terraform
augroup terraform
  au!
  au FileType terraform au BufWritePre <buffer> call MaybeLSPFormat()
augroup END

" Brewfile
augroup Brewfile
  au!
  au BufNewFile,BufRead Brewfile,Brewfile.* setlocal filetype=ruby
augroup END

" hujson
augroup hujson
  au!
  au BufNewFile,BufRead *.hujson setlocal filetype=jsonc
augroup END

" Filetype detection for *.symlink files
" If a file begins with '#!/', let vim autodetect the filetype. Otherwise
" read 'linguist-language' from .gitattributes.
augroup symlink
  au!
  au BufRead,BufNewFile *.symlink
        \ if getline(1) !~ '#!/' |
        \ let &ft=split(system('cd '.shellescape(expand('%:p:h')).' && git check-attr linguist-language '.shellescape(expand('%:p'))))[-1] |
        \ endif
augroup END

set modeline
set modelines=0

set number

set scrolloff=3
set showcmd
set hidden
set wildmode=list:longest
set visualbell
" used by vim-gitgutter
set updatetime=100

" git-messenger
let g:git_messenger_include_diff = 'current'

" make searching not suck
nnoremap / /\v
xnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
noremap <leader><space> :noh<cr>:call clearmatches()<cr>

"makes j and k go by screen lines
nnoremap j gj
nnoremap k gk

" navigate the quickfix list
nnoremap <left>  :cprev<cr>zvzz
nnoremap <right> :cnext<cr>zvzz

" Mouse settings
set mouse=a

set title

" toggle paste mode
nmap <LocalLeader>pp :set paste!<cr>

" Resize splits when the window is resized
augroup resize_splits
  au!
  au VimResized * exe "normal! \<c-w>="
augroup END

" Splits open in reasonable places
set splitright
set splitbelow

" color
if $TERM ==# 'xterm-kitty'
  let g:gruvbox_italic=1
endif

if has('termcolors')
  set termguicolors
endif
set background=dark
colorscheme gruvbox

" gui
if has('gui_macvim')
  " TODO: find a good patched font
  set guifont=Menlo:h18
endif

set laststatus=2 " Always show the statusline

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" find merge conflict markers
nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>

" git status
nmap <Leader>g :Git<CR>gg)
" git add -p
nmap <Leader>ga :Git add -p<CR>
" git add -N
nmap <Leader>gn :Git add -N %<CR>
" git commit
nmap <Leader>gc :Git commit<CR>
nmap <Leader>gca :Git commit --amend<CR>

" pre-commit
nmap <Leader>pc :!pre-commit run --files %<CR>

" Remove any trailing whitespace that is in the file
augroup remove_trailing_whitespace
  au!
  au BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
augroup END

" DEATH TO F1
map <F1> <Esc>
imap <F1> <Esc>

" fzf
command! -bang -nargs=? -complete=dir GitFiles
      \ call fzf#vim#files(FugitiveWorkTree(), fzf#vim#with_preview({'source': 'git ls-files || fd --type f -E node_modules'}), <bang>0)
nnoremap <C-p> :GitFiles<Cr>

"" MAKE .swp~ AND .un~ FILES LESS ANNOYING
"" FROM <http://stackoverflow.com/a/9528322/609144>
" Save your backups to `~/.vim-backup` or `.` only if that fails.
if isdirectory($HOME . '/.vim-backup') == 0
  silent !mkdir -p ~/.vim-backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim-backup/
set backup

" Save your swp files to `~/.vim-swap` or `.` only if that fails.
if isdirectory($HOME . '/.vim-swap') == 0
  silent !mkdir -p ~/.vim-swap >/dev/null 2>&1
endif
set directory=~/.vim-swap//
set directory+=.

" undofile - This allows you to use undos after exiting and restarting
" :help undo-persistence
if isdirectory($HOME . '/.vim-undo') == 0
  silent !mkdir -p ~/.vim-undo > /dev/null 2>&1
endif
set undodir+=~/.vim-undo//
set undofile

" clam.vim
nnoremap ! :Clam<space>

" Unfuck everything by redrawing the screen and restarting all LSPs
noremap U :syntax sync fromstart<cr>:redraw!<cr>:LspRestart<cr>:lua vim.treesitter.get_parser(0):parse()<cr>

" Scrollbinding
set scrollopt+=hor
nmap <LocalLeader>s :set scrollbind<cr>

" Change-inside-surroundings.vim
nmap <leader>cis :ChangeInsideSurrounding<cr>

" Commenting
nmap <leader>cc gcc
xmap <leader>cc gc

" highlight column after 'textwidth' (e.g. 99 in Rust), but default to 80
function! ColorColumn()
  if !exists('+colorcolumn')
    return
  endif

  if &textwidth > 0
    set colorcolumn=+1
  else
    set colorcolumn=80
  endif
endfunction
" Set the color column whenever we enter a buffer. This let us do things like
" ':e newfile.rs' and get 'colorcolumn=100' and ':e newfile.py' and get
" 'colorcolumn=80' all in the same session!
augroup colorcolumn
  au!
  au BufEnter * call ColorColumn()
augroup END

" Treat underscore as word delimiter
set iskeyword-=_

" Undotree
nnoremap <F5> :UndotreeToggle<CR>
