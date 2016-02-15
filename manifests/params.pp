# == Class: influxdb::params
# DO NOT CALL DIRECTLY
class influxdb::params {
  $ensure                  = 'installed'
  $version                 = '0.9.2'
  $install_from_repository = true
  $config_file             = '/etc/opt/influxdb/influxdb.conf'

  $download_url            = undef

  # general section of influxdb.conf
  $reporting_disabled      = false

  # Configuration options defined in the module
  $module_settings = {
    'meta' => {
      'hostname' => 'localhost',
      'peers'    => undef,
    },
    'retention' => {
      'replication' => undef,
    }
  }

  # User settings, empty hash by default
  $settings = {}

}
