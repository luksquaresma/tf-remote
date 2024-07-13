#!/bin/bash

cd $SCRIPTPATH;
cd ..;
source ./../utils.sh;

pwd=tfr_db

{
    dockerd-rootless
} && {
    docker pull postgres
} && {
    docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=$pwd -d postgres
} && {
    export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
}