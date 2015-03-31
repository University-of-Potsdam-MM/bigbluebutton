# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.box = "ubuntu/trusty64"
  # config.vm.box_url = "http://files.vagrantup.com/ubuntu/trusty64.box"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant-root", "1"]
    vb.memory = 2048
    vb.cpus = 2
    #vb.gui = true
  end
   
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
#  config.vm.network "public_network"
  
  # the following doesn't work properly due to vagrant limitations:
  config.vm.network "private_network", type: "dhcp" #, ip: "192.168.33.10", virtualbox__intnet: true 
 
  config.ssh.forward_agent = true
  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.provision :shell, :path => "bootstrap.sh"
  
  config.vm.provision :shell, :privileged => false, :path => "devEnv.sh"
  config.vm.provision :shell, :privileged => false, :path => "testBuild.sh"
  
end
