#! /usr/bin/bash
# create pod
podman pod create --name postgrespod -p 9876:80 -p 5432:5432

# ubuntu - postgresql.con and pg_hba.conf https://stackoverflow.com/questions/38466190/cant-connect-to-postgresql-on-port-5432#38466547

# add pgadmin container
podman run --pod=postgrespod --name pgadmin12 -e 'PGADMIN_DEFAULT_EMAIL=postgres@postgres.me' -e --replace 'PGADMIN_DEFAULT_PASSWORD=postgres' -d docker.io/dpage/pgadmin4:latest
# run below line only once
# podman pull docker.io/library/postgres:latest
# add postgres container
# mkdir /home/ron/src/db/dev
podman run --pod=postgrespod --name db -v /home/ron/src/db/dev:/var/lib/postgresql/data:Z -d -e --replace POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres docker.io/library/postgres:latest

# test psql
psql -h localhost -p 5432 -U postgres

# browse  this url to test pgadmin:
# http://localhost:9876/

# useful commands
#podman pod pause postgrespod
#podman pod unpause postgrespod

#podman pod start postgrespod
#podman pod stop postgrespod

# generate yaml
podman generate kube postgrespod > postgrespod-conf.yml
