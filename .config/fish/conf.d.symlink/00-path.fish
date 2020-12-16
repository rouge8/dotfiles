eval (brew shellenv)
for py_version in 3.9 3.8 3.7
  set PATH $PATH $HOMEBREW_PREFIX/opt/python@$py_version/bin
end

# shivs
set PATH $HOME/.local/bin $PATH

# scripts
set PATH $PATH $HOME/bin

set -x PATH $PATH
