# == Class: influxdb
class influxdb (
  $ensure                   = $influxdb::params::ensure,
  $version                  = $influxdb::params::version,
  $install_from_repository  = $influxdb::params::install_from_repository,
  $config_file              = $influxdb::params::config_file,
  $reporting_disabled       = $influxdb::params::reporting_disabled,
  $download_url             = $influxdb::params::download_url,
  $settings                 = $influxdb::params::settings,
  $module_settings          = $influxdb::params::module_settings,
) inherits influxdb::params {

  class { 'influxdb::install': } ->
  class { 'influxdb::config': }  ~>
  class { 'influxdb::service': } ->
  Class['influxdb']
}
