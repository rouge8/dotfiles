# Don't install anything globally with pip
set -x PIP_REQUIRE_VIRTUALENV true

# Use 'gpip' to upgrade pip/virtualenv/etc.
function gpip
    PIP_REQUIRE_VIRTUALENV="" pip $argv
end
function gpip3
    PIP_REQUIRE_VIRTUALENV="" pip3 $argv
end
