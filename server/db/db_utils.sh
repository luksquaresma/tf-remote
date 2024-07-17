#!/bin/bash

# Configs
file_db="./db.sqlite"
sql_creator="./scripts/create.sql"
sql_tester="./scripts/test.sql"

source_wrapper() { source $UTILS_PATH; }
source_wrapper; cd $(get_script_path)

delete() {
    if ! [ $# -eq 0 ]; then echo; echo $1; fi   
    if ! [[ -e $file_db ]]; then
        echo "ABORT - No database file found. Exiting now." && exit 1
    fi
    echo "INFO - Proceeding to database deletion."
    if ! (fok "Do you whish to delete the current local database?"); then
        echo "ABORT - Fail to confirm deletion. Exiting now." && exit 1
    fi
    rm $file_db && echo "OK - Database deleted!"
}

create() {
    if ! [ $# -eq 0 ]; then echo; echo $1; fi
    if [[ -e $file_db ]]; then
        echo "ABORT - Database already exists." && exit 1
    fi
    sqlite3 $file_db < $sql_creator && echo "OK - Database creation sucessfull."
}

reset() {
    if ! [ $# -eq 0 ]; then echo; echo $1; fi
    delete
    create "INFO - Proceeding to database creation."
}

test () {
    echo "TODO - Tests."
}

db_usage() {
 echo; echo "Usage local utils [OPTIONS]"
 echo
 echo "  Options:"
 echo "    -h, --help           Display this help message"
 echo "    -c, --create         Creates the local database."
 echo "    -d, --delete         Deletes the local database."
 echo "    -r, --reset          Reset the local database."
 echo "    -t, --test           Tests the local database."
}

if ! [ $# -eq 0 ]; then
    while getopts "hcdrt" flag; do
        case $flag in
            h)
                db_usage
            ;;
            c)
                create "...Database creation..."
            ;;
            d)
                delete "...Database deletion..."
            ;;
            r)
                reset "...Database reset..."
            ;;
            t)
                test
            ;;
            \?)
                echo "ABORT - Invalid option!"
            ;;
        esac
    done
fi