function npm-exec
    begin
        set -lx PATH (npm bin) $PATH
        $argv
    end
end
