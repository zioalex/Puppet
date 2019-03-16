class mopidy (
  $rescan = 'false',
  $soundcloudtoken = $::soundcloudtoken
) {
	exec { 
	'mopidy_gpg':
	  command => 'wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -',
	  path    => ['/usr/bin', '/bin'],
	  unless  => "apt-key finger|grep -i mopidy.com";

	'mopidy_repo':
	  command => 'sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/stretch.list',
	  path    => '/usr/bin',
	  require => Exec['mopidy_gpg'],
	  unless  => "test -e /etc/apt/sources.list.d/mopidy.list";
	}

	file { '/etc/pulse/default.pa':
	  source  => 'puppet:///modules/mopidy/default.pa',
	  ensure  => 'file',
	  group   => '0',
	  mode    => '0644',
	  owner   => '0',
	}

	user { 'mopidy':
	  ensure           => 'present',
	  gid              => '29',
	  groups           => ['audio', 'video'],
	  home             => '/var/lib/mopidy',
	  password         => '*',
	  password_max_age => '99999',
	  password_min_age => '0',
	  shell            => '/bin/false',
	  uid              => '116',
	}

	package { 
	'gstreamer1.0-plugins-bad':
	  ensure => 'present';
	'mopidy':
	  ensure => 'present',
	  require => [ User['mopidy'], Exec['mopidy_repo'], Package['gstreamer1.0-plugins-bad'] ];
	'mopidy-local-sqlite':
	  ensure => 'present',
	  require => Package['mopidy'];
	'mopidy-alsamixer':
	  ensure => 'present',
	  require => Package['mopidy'];
	'mopidy-soundcloud':
	  ensure => 'present',
	  require => Package['mopidy'];
	'mopidy-tunein':
	  ensure => 'present',
	  require => Package['mopidy'];
	'mopidy-internetarchive':
	  ensure => 'present',
	  require => Package['mopidy'];
	'mopidy-podcast':
	  ensure => 'present',
	  require => Package['mopidy'];
	'mopidy-podcast-itunes':
	  ensure => 'present',
	  require => Package['mopidy'];
	'python-pip':
	  ensure => 'present';
	'Mopidy-Iris':
         ensure   => present,
         provider => 'pip',
         require  => [ Package['python-pip'] ];
	'Mopidy-Scrobbler':
         ensure   => present,
         provider => 'pip',
         require  => [ Package['python-pip'] ];
	}

	file { '/etc/mopidy/mopidy.conf':
	  ensure  => 'file',
	  #source  => 'puppet:///modules/mopidy/mopidy.conf',
	  content => template('mopidy/mopidy.conf.erb'), 
	  group   => '0',
	  mode    => '0640',
	  owner   => '116',
	  notify  => Service['mopidy'];
	}

	if ( $rescan == 'true' ) {
		exec { 'mopidy_local_scan':
		  command => '/usr/bin/mopidy --config /etc/mopidy/mopidy.conf  local scan',
		  require => [ Package['mopidy'], File['/etc/mopidy/mopidy.conf'] ];
		}
	}

	service { 'mopidy':
	  ensure => 'running',
	  enable => 'true',
	  require => Package['mopidy'];
	}

}
