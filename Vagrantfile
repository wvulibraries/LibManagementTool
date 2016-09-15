# -*- mode: ruby -*-
# vi: set ft=ruby :

PROJECT_NAME = "LibraryManagementTool"
API_VERSION  = "2"

Vagrant.configure(API_VERSION) do |config|
    config.vm.define PROJECT_NAME, primary: true do |config|
        config.vm.provider :virtualbox do |vb|
            vb.name = PROJECT_NAME
        end

        config.vm.box = "bento/centos-7.2"
        config.vm.network :forwarded_port, guest: 3000, host: 3000
        # config.vm.network "private_network", ip: "127.0.0.1"
        config.vm.provision "shell", path: "bootstrap.sh"
        config.ssh.insert_key = false
    end
end
