# == Class: influxdb::params
# DO NOT CALL DIRECTLY
class influxdb::params {
  $ensure                  = 'installed'
  $version                 = '0.13.0-1'
  $install_from_repository = true
  $config_file             = '/etc/influxdb/influxdb.conf'

  $download_url            = undef

  # general section of influxdb.conf
  $reporting_disabled      = false

  # User settings
  $settings = {
    meta => {
      hostname => 'localhost',
      peers    => undef,
    },
    retention => {
      replication => undef,
    }
  }

  # Module config. Separate, as the title is a different format.
  $module_settings = {}

}
