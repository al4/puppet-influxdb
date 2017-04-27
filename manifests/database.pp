# Create an influxdb database

define influxdb::database {
    require influxdb

    exec { "create_database":
        command => "/usr/bin/influx -database _internal -execute 'CREATE DATABASE \"${name}\"'",
        onlyif  => "/bin/bash -c \"! /usr/bin/influx -database _internal -execute 'SHOW DATABASES' | grep -E '^${name}$'\"",
    }
}
