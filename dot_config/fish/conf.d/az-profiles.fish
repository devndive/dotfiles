# Azure CLI multi-tenant profiles.
# Each profile is an isolated az config dir (own login + own default subscription),
# so the dev-subscription tenant and the Azure DevOps tenant never fight over
# a single global default.

set -gx AZ_PROFILE_ROOT $HOME/.config/az-profiles

# Extensions (azure-devops, etc.) are shared across profiles and stay in the
# original location, which is already populated. Without this, az would default
# to $AZURE_CONFIG_DIR/cliextensions and try to reinstall from the blocked
# public extension index.
set -gx AZURE_EXTENSION_DIR $HOME/.azure/cliextensions

# Default profile for a new shell; an inherited value wins (e.g. from `env`).
set -q AZURE_CONFIG_DIR; or set -gx AZURE_CONFIG_DIR $AZ_PROFILE_ROOT/dev
