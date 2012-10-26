class virtualbox::install_guest_tools {
  exec { "virtualbox::exec_vbox_install":
    command => "/media/cdrom/VBoxLinuxAdditions.run",
    onlyif => "test -f /media/cdrom/VBoxLinuxAdditions.run && test -f /usr/bin/VBoxControl",
    require => [ Package['build-essential'] ]
  } 
}

class virtualbox::setup_interfaces {
  
  include networking
  
  file { "/etc/network/interfaces" :
    source => "puppet:///virtualbox/etc/network/interfaces",
    mode => 644,
    group => root,
    notify => [ Class['networking::service'] ]
  }
  
  exec { "virtualbox::exec_ifup_eth1" :
    command => "/sbin/ifup eth1",
    require => [ File['/etc/network/interfaces'] ]
  }
}

class virtualbox {
  include basic, virtualbox::install_guest_tools, virtualbox::setup_interfaces, virtualbox::setup_users 
}

class virtualbox::setup_users {
  user { "www-data" :
      groups => ["vboxsf", 'www-data']
    
  }
  
  user { "ubuntu" :
     groups => ["vboxsf", "ubuntu"]
  }
}