# Custom denter function para Bash
denter() {
    local container=""
    local shell="/bin/bash"
    local as_root=false

    # Parse arguments
    if [[ $# -eq 2 && "$2" == "root" ]]; then
        container="$1"
        as_root=true
    elif [[ $# -eq 1 ]]; then
        container="$1"
    else
        echo "Usage: denter <container-name> [root]"
        return 1
    fi

    # Construct the docker exec command
    local cmd="docker exec -it"
    if $as_root; then
        cmd+=" -u root"
    fi
    cmd+=" $container $shell"

    # Execute the command
    eval $cmd
}

# Autocompletion for denter in Bash
_denter_completion() {
    local current prev opts
    current="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Get list of running containers
    local containers=$(docker ps --format '{{.Names}}')
    local options="root"

    if [[ $COMP_CWORD -eq 1 ]]; then
        # Complete with container names
        COMPREPLY=( $(compgen -W "$containers" -- "$current") )
    elif [[ $COMP_CWORD -eq 2 ]]; then
        # Complete with 'root' option
        COMPREPLY=( $(compgen -W "$options" -- "$current") )
    fi
}

# Register the completion function for denter
complete -F _denter_completion denter
