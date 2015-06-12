# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

script = <<SCRIPT
sudo apt-get update
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provision "shell", inline: script
  config.vm.hostname = "sinatra-ssl-spike"
  config.vm.box = "yuki-takei/ubuntu-trusty64-ja"

  config.vm.network "forwarded_port", guest: 9292, host: 9292

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true

    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--vram", "128"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
  end

  if Vagrant.has_plugin? 'vagrant-omnibus'
    config.omnibus.chef_version = 'latest'
  end
  config.berkshelf.enabled = true
  config.vm.provision "chef_zero" do |chef|
    chef.cookbooks_path = ["./", "./cookbooks", "./site-cookbooks"]
    chef.add_recipe "curl"
    chef.add_recipe "chef-dk"
    chef.add_recipe "docker"
    chef.add_recipe "python"
  end
end
