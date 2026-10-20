function azp --description "Switch the Azure CLI profile for this shell"
    set -l root (set -q AZ_PROFILE_ROOT; and echo $AZ_PROFILE_ROOT; or echo $HOME/.config/az-profiles)
    set -l name $argv[1]

    if test -z "$name"
        set name status
    end

    switch $name
        case status
            echo "AZURE_CONFIG_DIR = $AZURE_CONFIG_DIR"
            _azp_show
            return 0
        case list
            for d in $root/*/
                test -f $d/azureProfile.json; and echo (basename $d)
            end
            return 0
        case '-h' '--help'
            echo "usage: azp [dev|ado|private|<name>|status|list]"
            return 0
    end

    set -gx AZURE_CONFIG_DIR $root/$name
    if not test -d $AZURE_CONFIG_DIR
        mkdir -p $AZURE_CONFIG_DIR
        echo "Created new profile '$name' — run: az login --tenant <tenant-id>"
    end
    echo "AZURE_CONFIG_DIR = $AZURE_CONFIG_DIR"
    _azp_show
end

function _azp_show --description "Print the active subscription/tenant, if signed in"
    set -l info (az account show --query "[name, tenantId]" -o tsv 2>/dev/null)
    if test -n "$info"
        echo "  $info"
    else
        echo "  (not signed in — run: az login --tenant <tenant-id>)"
    end
end

complete -c azp -f -a "dev ado private status list"
