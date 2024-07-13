#!/bin/bash

# Configs
file_db="./db.sqlite"
create_sql="./create.sql"

source $UTILS_PATH
cd $(get_script_path)

{
    echo; echo "...Database preparation..."
    if [[ -e $file_db ]]; then
        if (fok "Do you whish to reset the local database?"); then
            rm $file_db && echo "OK - Database erased!"
        else
            echo "INFO - Exiting now." && exit 1
        fi
    fi
} && {
    echo; echo "...Database creation..."
    {
        sqlite3 $file_db < $create_sql
    } && {
        echo "OK - Reset sucessfull."
    }
}