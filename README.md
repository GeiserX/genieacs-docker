# Docker Compose and Dockerfile files for GenieACS

Recommended Host Machine: Debian 9 with 4GB of RAM or more.

### Install Docker-CE and Docker Compose

```bash
apt update
apt dist-upgrade -y
apt autoremove -y
apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common sudo openssh-server htop avahi-daemon tcpdump wget

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt install -y docker-ce

curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
curl -L https://raw.githubusercontent.com/docker/compose/1.23.2/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose ## In order to enable command-line completion of Compose
chmod +x /usr/local/bin/docker-compose

cd /opt && git clone https://github.com/DrumSergio/GenieACS-Docker && cd GenieACS-Docker
```

### Pull/Build Dockerfile

```bash
docker pull drumsergio/genieacs:1.1.3
```
or:
```bash
docker build -f GenieACS.dockerfile . -t drumsergio/genieacs:1.1.3
```

### Run Docker Compose

```bash
docker-compose up -d
```

Change manually `FS_HOSTNAME` to your local IP/hostname in `/opt/genieacs/config/config.json` and also change manually user/passwords in `/opt/genieacs/config/users.yml`

If you want a personalized version of GenieACS-GUI, you could change the Dockerfile and pull from your own repo. See my repo https://github.com/DrumSergio/genieacs-gui you could also change more things like enabling SSL in all the services. You have commented lines on the Dockerfile that can give you some clues. You can have more info also at the Wiki of the GenieACS project.

### Use of the Vagrantfile
If you want to use GenieACS inside a VM you have a Vagrantfile ready to be deployed in VirtualBox. Although the use of Vagrant alongside VirtualBox is more development-oriented, it can be used along with your private Hyper-V or VMware cluster too, if you change the Vagranfile accordingly.

For this setting to work, you need Vagrant installed on your computer https://www.vagrantup.com/docs/installation/ and of course, VirtualBox if you decide to use this provider with the Vagrantfile I provided https://www.virtualbox.org/wiki/Downloads

Then, you simply issue the command `vagrant up` in the directory where the Vagrantfile is.

##### This repo appears in the GenieACS Wiki: https://github.com/genieacs/genieacs/wiki/Docker-Installation-with-Docker-Compose
