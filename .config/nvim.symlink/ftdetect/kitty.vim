augroup kittysymlink
  autocmd! BufNewFile,BufRead kitty.conf,*/kitty.symlink/*.conf setfiletype kitty
  autocmd! BufNewFile,BufRead */kitty.symlink/*.session setfiletype kitty-session
augroup END
