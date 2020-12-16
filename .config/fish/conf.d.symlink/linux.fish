if test (uname -s) != 'Darwin'
  alias pbcopy 'xsel --clipboard --input'
  alias pbpaste 'xsel --clipboard --output'

  alias open 'xdg-open'
end
