define influxdb::grant(
    String $user,
    String $database,
    Enum["all", "read", "write"] $privilege = "all",
){
    $priv_map = {
        "all"   => "ALL PRIVILEGES",
        "read"  => "READ",
        "write" => "WRITE",
    }

    $priv = $priv_map[$privilege]

    exec { "revoke_${database}_${user}":
        command     => "/usr/bin/influx -database ${database} -execute 'REVOKE ALL PRIVILEGES ON \"${database}\" FROM \"${user}\"'",
        onlyif      => "/bin/bash -c \"! /usr/bin/influx -database ${database} -execute 'SHOW GRANTS FOR ${user}' | grep -P '^${database}\t*${priv}$'\"",
    }

    -> exec { "grant_${database}_${user}":
        command     => "/usr/bin/influx -database ${database} -execute 'GRANT ${priv} ON \"${database}\" TO \"${user}\"'",
        onlyif      => "/bin/bash -c \"! /usr/bin/influx -database ${database} -execute 'SHOW GRANTS FOR ${user}' | grep -P '^${database}\t*${priv}$'\"",
    }

}
