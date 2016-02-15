# == Class: influxdb::config
#
# Any configuration in the specified config hash is managed as an ini_setting.
#
# DO NO CALL DIRECTLY
class influxdb::config(
  $settings = {
    'meta' => {
      'hostname' => "${influxdb::meta_hostname}",
      'peers'    => "${influxdb::peers}",
    },
    'retention' => {
      'replication' => "${influxdb::retention_replication}",
    }
  }
){

  # defaults for all settings
  Ini_setting {
    ensure  => present,
    path    => $influxdb::config_file,
  }

  # specific changes
  ini_setting { 'reporting-disabled':
    # reporting-disabled is a special case as it's top-level
    section => '',
    setting => 'reporting-disabled',
    value   => $influxdb::reporting_disabled,
  }

  $settings.each |$section| {
    $section.each |$setting| {
      ini_setting { "${section}_${setting}":
        section => $section,
        setting => $setting,
        value   => $setting[0],
      }
    }
  }

}
