# Create an influxdb user
#
# Note that once a user has been created, it will not be updated. So presently if you
# change a user, you must first delete it for the change to happen.

define influxdb::user(
    Enum["absent", "present"]    $ensure = "present",
    String                       $password = "",
    Enum["all", "read", "write"] $privilege = "all",
){
    require influxdb

    if $ensure == "present" {
        exec { "create_user_$name":
            command => "/usr/bin/influx -database _internal -execute \"CREATE USER \\\"${name}\\\" WITH PASSWORD '${password}'\"",
            onlyif  => "/bin/bash -c \"! /usr/bin/influx -database _internal -execute 'SHOW USERS' | grep -P '^${name}\t'\"",
        }
    }
    else {
        exec { "drop_user_$name":
            command => "/usr/bin/influx -database _internal -execute 'DROP USER \"${name}\"'",
            onlyif  => "/bin/bash -c \"/usr/bin/influx -database _internal -execute 'SHOW USERS' | grep -P '^${name}\t'\"",
        }
    }
}
