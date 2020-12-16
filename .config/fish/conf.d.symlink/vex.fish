function workon
  vex $argv
end

function mkvirtualenv
  vex -m $argv
end

function lsvirtualenv
  \ls ~/.virtualenvs/
end

function rmvirtualenv
  rm -rf ~/.virtualenvs/$argv
end

function mktmpenv
  vex -rm $argv tmp-(date +%s)
end
