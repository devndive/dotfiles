function azado --wraps az --description "Run a single az command against the ADO tenant profile"
    set -l root (set -q AZ_PROFILE_ROOT; and echo $AZ_PROFILE_ROOT; or echo $HOME/.config/az-profiles)
    env AZURE_CONFIG_DIR=$root/ado AZURE_EXTENSION_DIR=$HOME/.azure/cliextensions az $argv
end
