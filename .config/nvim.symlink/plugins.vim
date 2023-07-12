call plug#begin(stdpath('data') . '/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'briandoll/change-inside-surroundings.vim'
Plug 'sjl/clam.vim'
Plug 'tpope/vim-commentary'
Plug 'myusuf3/numbers.vim'
Plug 'mbbill/undotree'
Plug 'andymass/vim-matchup'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-rsi'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'rhysd/git-messenger.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-sleuth'
Plug 'dstein64/vim-startuptime'
Plug 'unblevable/quick-scope'

" Autocomplete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-calc'
Plug 'hrsh7th/cmp-nvim-lua'

" Appearance
Plug 'nvim-lualine/lualine.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

" Language/Syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'raimon49/requirements.txt.vim'
Plug 'vim-scripts/groovy.vim'
Plug 'rust-lang/rust.vim'
Plug 'blankname/vim-fish'
Plug 'fladson/vim-kitty'
Plug 'hashivim/vim-terraform'

" Testing
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-python'
if isdirectory($HOME . '/projects/neotest-rust')
  Plug '~/projects/neotest-rust'
else
  Plug 'rouge8/neotest-rust'
endif
Plug 'nvim-neotest/neotest-plenary'

" Color Schemes
Plug 'gruvbox-community/gruvbox'

" Done
call plug#end()
