# Dockerized datomic free

## Preparations

Copy transactor.properties.example to a path from where it will be mounted as volume to persistence container. Rename it to transactor.properties and configure as liked.

## To build the image
    docker build -t datomic-free .

## To start the dev environment:

On OS X, the paths need to be under /User/, for boot2docker access.

    docker run -d --name db-persistence -v <path_to_config>:/opt/datomic/config/ -v <path-to-data>:/var/datomic/data -v <path-to-logs>:/var/datomic/logs /bin/true
    docker run -t -i --name db --volumes-from db-persistence /bin/bash

## Removing the containers
    docker rm -v db-persistence
    docker rm db