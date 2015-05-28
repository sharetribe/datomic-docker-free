# Dockerized datomic free

## Preparations

A startup.sh script is required for dynamically generating the datomic transactor.properties file. A default one for running the Datomic container in ECS is provided under `files/`, and that is copied when building the image to `/opt/datomic/startup/startup.sh` inside the image.

That can be overridden by providing a modified one. An example of the file is in `dev_startup`. This file currently enbales passing in the `HOST` and `ALT_HOST` env variables which will be used to create configuration for Datomic. The default configuration is then overriden by providing the local folder containing the scirpt to the container as volume with `-v dev_startup/:/opt/datomic/startup/`.

## To build the image
    docker build -t sharetribe/datomic-free .

## To start the dev environment:

On OS X, the paths need to be under /User/, for boot2docker access.

    docker run -d --name db-persistence -v </User/path/>/dev_startup/:/opt/datomic/startup/ -v </User/path/to/data>:/var/datomic/data -v </User/path/to/logs>:/var/datomic/logs sharetribe/datomic-free /bin/true
    docker run -d --expose 4334 --expose 4335 --expose 4336 -p 4334:4334 -p 4335:4335 -p 4336:4336 -e "HOST=0.0.0.0" -e "ALT_HOST=$(boot2docker ip)" -e "XMX=-Xmx256m" -e "XMS=-Xms255m" --name db --volumes-from db-persistence sharetribe/datomic-free

## Removing the containers
    docker rm -v db-persistence
    docker rm db

    docker run -d --name db-persistence -v ~/dev/projects/sharetribe/datomic-docker-free/dev_startup/:/opt/datomic/startup/ -v ~/dev/projects/sharetribe/datomic-docker-free/data:/var/datomic/data -v ~/dev/projects/sharetribe/datomic-docker-free/logs:/var/datomic/logs sharetribe/datomic-free /bin/true
