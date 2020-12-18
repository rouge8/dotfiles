if status --is-login
    set -gx HOMEBREW_PREFIX (brew --prefix)

    for py_version in 3.9 3.8 3.7
        fish_add_path --append $HOMEBREW_PREFIX/opt/python@$py_version/bin
    end

    # Volta <https://volta.sh>
    set -x VOLTA_HOME $HOME/.volta
    fish_add_path --prepend $VOLTA_HOME/bin

    # Cargo
    fish_add_path --prepend $HOME/.cargo/bin

    # shivs
    fish_add_path --prepend $HOME/.local/bin

    # scripts
    fish_add_path --append $HOME/bin
end
