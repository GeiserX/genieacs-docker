<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [GenieACS Deployment Tools](#genieacs-deployment-tools)
    - [Install in Kubernetes cluster](#install-in-kubernetes-cluster)
    - [Install Docker-CE and Docker Compose (Only for Debian 10)](#install-docker-ce-and-docker-compose-only-for-debian-10)
    - [Install Docker-CE and Docker Compose (Only for CentOS 7)](#install-docker-ce-and-docker-compose-only-for-centos-7)
    - [Pull/Build Dockerfile](#pullbuild-dockerfile)
    - [Run Docker Compose](#run-docker-compose)
    - [Use of the Vagrantfile](#use-of-the-vagrantfile)
        - [This repo appears in the GenieACS Wiki: https://github.com/genieacs/genieacs/wiki/Docker-Installation-with-Docker-Compose](#this-repo-appears-in-the-genieacs-wiki-httpsgithubcomgenieacsgenieacswikidocker-installation-with-docker-compose)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# GenieACS Deployment Tools

GenieACS is a complex software stack that can be installed in many ways, and this repository contains the basic deployment tools to make your GenieACS installation a successful one.

Please, I ask you to contribute to the repository through Pull Requests (PRs). Together we can improve any of the different deployment processes described here.

## Instalation methods

Using any of the installation methods, please bear in mind that I have always found that 4GB is the minimium amount of RAM that the software needs for its processesm, otherwise you may happen to fall into random errors..

### Deployment on Kubernetes

In the `genieacs-deploy-helmfile/` folder there is an example deployment leveraging [Helmfile](https://github.com/roboll/helmfile), but you will for sure need someone who is knowledgeable of Kubernetes. So skip this part if you don't.

Modify the values files accordingly to make it work inside your cluster.
Tested in a K3s cluster with MetalLB Load Balancer.

Installation process:

```bash
helmfile -f `genieacs-deploy-helmfile/helmfile.yaml` apply
```

### Deployment on Bare Metal using Docker-Compose

The easier option is to install it using Docker Compose, as it needs less know-how. Here down you have two options: Instructions for Debian 10, and the instructions for CentOS 7.

#### Preparation steps for Debian 10

```bash
apt update
apt dist-upgrade -y
apt autoremove -y
apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common sudo openssh-server htop avahi-daemon tcpdump wget

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt install -y docker-ce

curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
curl -L https://raw.githubusercontent.com/docker/compose/1.24.1/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose ## In order to enable command-line completion of Compose
chmod +x /usr/local/bin/docker-compose

cd /opt && git clone https://github.com/DrumSergio/GenieACS-Docker && cd GenieACS-Docker
```

#### Preparation steps for CentOS 7

```
yum update -y
yum install yum-utils device-mapper-persistent-data lvm2 git -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce -y
systemctl start docker
systemctl enable docker

curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose

cd /opt && git clone https://github.com/DrumSergio/GenieACS-Docker && cd GenieACS-Docker
```

#### Pull container or Build Dockerfile step (both for Debian 10 and CentOS 7)

```bash
docker pull drumsergio/genieacs:1.2.8
```
or:
```bash
docker build -f GenieACS.dockerfile . -t drumsergio/genieacs:1.2.8
```

If you decide to build the Dockerfile, do not change its name (tag). If you wish to modify it, change docker-compose.yml accordingly.

#### Run Docker Compose (both for Debian 10 and CentOS 7)

Modify the `docker-compose.yml` file accordingly if you plan to deploy into production. Comment out the `volumes:` directive if you encounter problems in the installation.

```bash
docker-compose up -d
```

To log into the container, issue the command `docker exec -it genieacs /bin/bash`. If you happen to be managing this setting in your company, it's better to have some knowledge of Docker.

The UI will be available at port `3000`. You will see a wizard where you can configure GenieACS according to your needs.

### Deployment by means of a Vagrantfile
There is a last method for bare-metal installations. If you want to use GenieACS inside a VM you have a Vagrantfile ready to be deployed in VirtualBox. Although the use of Vagrant alongside VirtualBox is more development-oriented, it can be used along with your private Hyper-V or VMware cluster too, if you change the Vagranfile accordingly.

For this setting to work, you need Vagrant installed on your computer https://www.vagrantup.com/docs/installation/ and of course, VirtualBox if you decide to use this provider with the Vagrantfile I provided https://www.virtualbox.org/wiki/Downloads

Then, you simply issue the command `vagrant up` in the directory where the Vagrantfile is.

##### This repo appears in the GenieACS Wiki: https://github.com/genieacs/genieacs/wiki/Docker-Installation-with-Docker-Compose
