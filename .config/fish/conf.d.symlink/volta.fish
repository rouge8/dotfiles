# Volta <https://volta.sh>
set -x VOLTA_HOME $HOME/.volta
set -x PATH $VOLTA_HOME/bin $PATH

# npm
function npm-exec
  begin
    set -lx PATH (npm bin) $PATH
    $argv
  end
end
