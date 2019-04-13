# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/stretch64"
#  config.vm.network "forwarded_port", guest: 80, host: 80, id: 'GenieACS-GUI'
#  config.vm.network "forwarded_port", guest: 7547, host: 7547, id: 'GenieACS-CWMP'
#  config.vm.network "forwarded_port", guest: 7557, host: 7557, id: 'GenieACS-NBI'
#  config.vm.network "forwarded_port", guest: 7567, host: 7567, id: 'GenieACS-FS'
  config.vm.network "public_network"
#  config.vm.synced_folder "/opt", "/opt"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = 4096
    vb.cpus = 2
    vb.name = "GenieACS_Vagrant_Docker"
  end

#  config.vm.provision "docker" do |d|
#    d.run "mongo:4.0",
#      args: "--name 'mongo' -v '/data/db:/data/db' -v '/data/configdb:/data/configdb' --expose 27017 --env 'MONGO_DATA_DIR=/data/db' --env 'MONGO_LOG_DIR=/var/log/mongodb'"
#    d.run "mongo-express", ## Delete this on production
#      args: "--name 'mongo-express' -p 8081:8081 --env 'ME_CONFIG_MONGODB_SERVER=mongo' --env 'ME_CONFIG_BASICAUTH_USERNAME=admin' --env 'ME_CONFIG_BASICAUTH_PASSWORD=mongo2018'"
#    d.run "drumsergio/genieacs:1.1.3",
#      args: "--name 'genieacs' -p 80:80 -p 7547:7547 -p 7557:7557 -p 7567:7567 -v '/opt_genieacs:/opt'"
#  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get dist-upgrade -y
    apt-get autoremove -y
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common sudo openssh-server htop avahi-daemon tcpdump wget

    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce

    curl -sL "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    curl -sL https://raw.githubusercontent.com/docker/compose/1.23.2/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
    chmod +x /usr/local/bin/docker-compose
    cd /opt && git clone https://github.com/DrumSergio/GenieACS-Docker && cd GenieACS-Docker
    docker-compose up -d
  SHELL
end
