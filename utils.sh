#!/bin/bash

get_env_var_name() {
    echo "UTILS_PATH"
}

fok() {
    read -p "$1 (y/N): " && [[ $REPLY =~ ^([yY][eE][sS]|[yY])$ ]]
}

iterate_version() {
    echo $(echo ${version} | awk -F. -v OFS=. '{$NF=$NF+1;print}')
}

iterate_version_toml() {
    
    version=false
    prefix="version = "
    
    # cat $1 | while read line; do 
    while IFS= read -r line; do 
        # echo "Text read from file: $line"
        if [[ ${line:0:10} == $prefix ]]; then
            version=${line#*=}
            version=$(echo ${version#*=} | tr -d ' ')
            version=$(echo ${version#*=} | tr -d '"')
            next=$(iterate_version $version);
            break              
        fi
        done < "$1"
    
    if [[ $version != false ]]; then
        echo; echo "Found package version: $version"
        if (fok "Do you wish to iterate it?"); then
            echo; echo "New package version: $next"
            if (fok "Do you confirm?"); then
                newline=${line/$version/$next}
                sed -i s/"$line".*/"$newline"/ $1
                echo; echo "OK - Version iteration finished!"
            else
                echo; echo "INFO - Package version iteration not confirmed!"
                echo; echo "INFO - Proceeding without version iteration!"
            fi
        fi
    else
        echo; echo "ERROR - Package version not found!"
        exit 1
    fi
}

get_current_path() {
    echo "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
}

get_current_path() {
    echo $(pwd)
}

get_script_path() {
    echo "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
}

get_utils_env_var_expr() {
    echo "export $(get_env_var_name)=\"$(get_script_path)\""
}

get_utils_env_var_fallback_expr() {
    echo "export $(get_env_var_name)=\"$1\""
}

setup_utils_expr() {
    cat << 'EOF'
        if [[ -n "$UTILS_PATH" ]]; then
            echo "INFO - Using default utils path from enviroment variable UTILS_PATH."
            source $UTILS_PATH
        else
            echo "INFO - Default utils path not present in enviroment variables. Trying to use fallback."
            
            if ! [ -n "$UTILS_PATH_FALLBACK" ]; then
                echo "ABORT - Fallback utils is not initialized!"
                echo "ABORT - UTILS_PATH_FALLBACK is not present!"
                exit 1;
            fi

            if ! [ -e $UTILS_PATH_FALLBACK ]; then
                echo "ABORT - Fallback utils were not found!"
                echo "ABORT - $UTILS_PATH_FALLBACK is not present!"
                exit 1;
            fi

            source $UTILS_PATH_FALLBACK
            echo "INFO - Using fallback utils."
        fi
EOF
}

reset_env_var() {
    echo "unset $(get_env_var_name) $(get_env_var_name)_FALLBACK"
}

usage() {
 echo; echo "Usage local utils [OPTIONS]"
 echo "Current loaded location: $(get_script_path)"
 echo
 echo "  Options:"
 echo "    -h, --help           Display this help message"
 echo "    -l, --location       Returns the current utils.sh file location"
 echo "    -c, --current        Returns the the path of the current running script."
 echo "    -e, --enviroment     Returns the expression for the enviroment variable setup."
 echo "    -f, --fallback       Returns the expression for the fallback enviroment variable setup."
 echo "    -s, --setup          Returns the expression for the enviroment setup procedure."
 echo "    -r, --reset          Returns the expression to reset the enviroment variables."
}


while getopts "hlcefsr" flag; do
    case $flag in
        h)
            usage
        ;;
        l)
            get_script_path
        ;;
        c)
            get_current_path
        ;;
        e)
            get_utils_env_var_expr
        ;;
        f)
            get_utils_env_var_fallback_expr $2
        ;;
        s)
            setup_utils_expr
        ;;
        r)
            reset_env_var
        ;;
        \?)
            echo "ABORT - Invalid option!"
        ;;
    esac
done