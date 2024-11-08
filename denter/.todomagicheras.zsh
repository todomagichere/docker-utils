# Custom denter function
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

# Completion for denter
_denter() {
    local state
    _arguments \
        '1: :->containers' \
        '2: :->root_option'

    case $state in
        containers)
            local containers
            containers=(${(f)"$(docker ps --format '{{.Names}}')"})
            _describe -t containers 'containers' containers
        ;;
        root_option)
            local options
            options=('root:Run as root user')
            _describe -t options 'options' options
        ;;
    esac
}
compdef _denter denter
