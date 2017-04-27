# == Class: influxdb::config
#
# Any configuration in the specified config hash is managed as an ini_setting.
#
# DO NO CALL DIRECTLY
#
# The influxdb config file is a pain in the arse.
# Firstly, it is strict on quoting, so strings must be quoted, other types must not
# Secondly, it uses two brackets ("[[") for module sections, which breaks section headings.
# To get around this, we install a "clean" copy of the original file, with comments 
# removed and the double-bracketed sections at the end of the file.
#
# If we did not do this, when we apply module settings ini_settings treats the other
# non-double bracket sections as entries and places them under the wrong sections.

class influxdb::config(
  $version = $::influxdb::version
){

  # defaults for all settings
  Ini_setting {
    ensure  => present,
    path    => $::influxdb::config_file,
    require => Exec['copy-config'],
  }

  # Copy our version of the config. This should be the vendor-supplied file,
  # with the module sections ("[[module]]") moved to the end
  # `sed -i influxdb.conf -r -e '/(^(\s)+?#+.*$|^$)/d'` will strip quotes
  $source_config_file = "influxdb_${version}.conf"
  $source_config_path = "/etc/influxdb/${source_config_file}"

  file { $source_config_path:
    source => "puppet:///modules/influxdb/${source_config_file}",
    notify => Exec["copy-config"],
  }

  exec {"copy-config":
    command     => "cp ${source_config_path} /etc/influxdb/influxdb.conf",
    path        => '/bin',
    refreshonly => true,
    require     => File[$source_config_path],
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
    $section[1].each |$setting| {
      # Go config files are picky on quoting. Strings should be quoted, ints and booleans should not.
      if $setting[1] =~ String {
        ini_setting { "${section[0]}_${setting[0]}":
          section      => $section[0],
          setting      => $setting[0],
          value        => $setting[1],
        }
      } else {
        ini_setting { "${section[0]}_${setting[0]}":
          section => $section[0],
          setting => $setting[0],
          value   => $setting[1],
        }
      }
    }
  }

  $::influxdb::module_settings.each |$section| {
    $section[1].each |$setting| {
      # Go config files are picky on quoting. Strings should be quoted, ints and booleans should not.
      if $setting[1] =~ String {
        ini_setting { "${section[0]}_${setting[0]}":
          section        => $section[0],
          setting        => $setting[0],
          value          => $setting[1],
          section_prefix => '[[',
          section_suffix => ']]',
        }
      } else {
        ini_setting { "${section[0]}_${setting[0]}":
          section        => $section[0],
          setting        => $setting[0],
          value          => $setting[1],
          section_prefix => '[[',
          section_suffix => ']]',
        }
      }
    }
  }
}

# vim: set sw=2 ts=2 et :
