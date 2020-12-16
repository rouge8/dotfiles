if status --is-login
  eval (brew shellenv)
  for py_version in 3.9 3.8 3.7
    set PATH $PATH $HOMEBREW_PREFIX/opt/python@$py_version/bin
  end

  # Volta <https://volta.sh>
  set -x VOLTA_HOME $HOME/.volta
  set PATH $VOLTA_HOME/bin $PATH

  # Cargo
  set PATH $HOME/.cargo/bin $PATH

  # shivs
  set PATH $HOME/.local/bin $PATH

  # scripts
  set PATH $PATH $HOME/bin

  set -x PATH $PATH
end
