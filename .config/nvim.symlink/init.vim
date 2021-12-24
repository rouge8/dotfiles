" change the mapleader from \ to ,
let mapleader=','

if &shell =~# 'fish$'
  set shell=bash
endif

" vim-plug configuration
exec 'source ' . stdpath('config') . '/plugins.vim'

" Highlight fenced code blocks
" ref: https://github.com/tpope/vim-markdown/commit/b2697b0adfe5428b86c8470a5f9d8da667bb2785
let g:markdown_fenced_languages = ['python', 'rust', 'dockerfile']

" Enable soft-wrapping for text files
augroup softwrap
  au!
  au FileType text,markdown,html,xhtml,eruby setlocal wrap linebreak nolist
augroup END

" Terraform
let g:terraform_fmt_on_save=1

" Rust
let g:rustfmt_autosave=1

" Fish
" Set up :make to use fish for syntax checking.
augroup fish
  au!
  au FileType fish compiler fish
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

" Indent Blankline
lua <<EOF
require'indent_blankline'.setup {}
EOF

" Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = {
      "rust",
      "python",
      "yaml",
    },
  },
  matchup = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
  },
}
EOF

" Autocomplete
set completeopt=menu,menuone,noinsert

lua <<EOF
local cmp = require('cmp')

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'calc' },
    { name = 'nvim_lua' },
  },
  mapping = {
    ['<C-x><C-o>'] = cmp.mapping.complete(), --- Manually trigger completion
    ['<Right>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        })
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      else
        fallback()
      end
    end,
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
})
EOF

" LSP
lua <<EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }

  --- Nav between diagnostic results
  buf_set_keymap('n', '<up>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<down>', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  --- Use 'K' to show LSP hover info
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  --- Go-to definition
  buf_set_keymap('n', '<leader>j', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  --- References
  buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  --- Formatting
  buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("v", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

--- Rust
nvim_lsp.rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
      checkOnSave = {
        command = "clippy",
        enable = true,
      },
    }
  }
})

--- Python
nvim_lsp.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    python = {
      --- pyright only accepts absolute paths
      venvPath = vim.api.nvim_call_function("fnamemodify", {"~", ":p"}) .. ".virtualenvs",
    }
  }
})

--- null-ls
null_ls = require('null-ls')
null_ls.setup({
  diagnostics_format = "[#{c}] #{m} (#{s})",
  sources = {
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.vint,
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.djhtml.with({
      extra_args = { "--tabwidth", "2" },
    }),
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.formatting.isort,
  },
  on_attach = on_attach,
})

--- Go-to definition in a split window
--- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#go-to-definition-in-a-split-window
local function goto_definition(split_cmd)
  local util = vim.lsp.util
  local log = require("vim.lsp.log")
  local api = vim.api

  local handler = function(_, result, ctx)
    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info() and log.info(ctx.method, "No location found")
      return nil
    end

    if split_cmd then
      vim.cmd(split_cmd)
    end

    if vim.tbl_islist(result) then
      util.jump_to_location(result[1])

      if #result > 1 then
        util.set_qflist(util.locations_to_items(result))
        api.nvim_command("copen")
        api.nvim_command("wincmd p")
      end
    else
      util.jump_to_location(result)
    end
  end

  return handler
end

vim.lsp.handlers["textDocument/definition"] = goto_definition('split')
EOF

" List all LSP diagnostic errors
command! Errors lua vim.diagnostic.setloclist()

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

" vim-airline
if $TERM ==# 'xterm-kitty'
  " kitty is smart and will find the Nerd Font symbols from
  " 'font-fira-code-nerd-font'
  let g:airline_powerline_fonts=1
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
" git commit
nmap <Leader>gc :Git commit<CR>

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
      \ call fzf#vim#files(FugitiveWorkTree(), fzf#vim#with_preview({'source': 'fd --type f'}), <bang>0)
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
noremap U :syntax sync fromstart<cr>:redraw!<cr>:LspRestart<cr>

" Scrollbinding
set scrollopt+=hor
nmap <LocalLeader>s :set scrollbind<cr>

" Change-inside-surroundings.vim
nmap <leader>cis :ChangeInsideSurrounding<cr>

" vim-commentary
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
