# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = false

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    #unzip
    sudo apt-get install -y unzip
    # rpmbuild
    sudo apt-get install -y rpm
    # ruby
    sudo apt-get install -y ruby-dev
    # fpm
    sudo gem install fpm
  SHELL
end
