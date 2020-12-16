if test (uname -s) = 'Darwin'
    alias kill-dns-cache 'sudo killall -HUP mDNSResponder'
end

alias unquarantine 'xattr -d com.apple.quarantine'
