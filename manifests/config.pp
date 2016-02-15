# == Class: influxdb::config
#
# Any configuration in the specified config hash is managed as an ini_setting.
#
# DO NO CALL DIRECTLY
class influxdb::config {

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

  # Merge config hashes
  $merged_settings = merge($::influxdb::params::module_settings, $::influxdb::settings)

  $merged_settings.each |$section| {
    $section.each |$setting| {

      if $setting[0] != undef {
        ini_setting { "${section}_${setting}":
          section => $section,
          setting => $setting,
          value   => $setting[0],
        }
      }

    }
  }

}
