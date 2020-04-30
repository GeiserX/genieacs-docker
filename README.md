# Helm Chart, Docker Compose and Dockerfile files for GenieACS 1.2

GenieACS 1.2 tested against arm32-based K3s cluster, and with plain docker in Debian 10, CentOS 7 and QNAP QTS 4.3. Strongly recommended to install it in a machine with at least **4 GB of RAM** or more.



### Install in Kubernetes cluster

**Please**, modify `HelmChart/values.yaml` file accordingly to make it work inside your cluster. Tested in a K3s cluster with MetalLB Load Balancer.

Installation process:

```bash
kubectl create namespace genieacs
helm install genieacs . --values values.yaml --namespace genieacs
```

### Install Docker-CE and Docker Compose (Only for Debian 10)

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

### Install Docker-CE and Docker Compose (Only for CentOS 7)

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

### Pull/Build Dockerfile

```bash
docker pull drumsergio/genieacs:1.2.0
```
or:
```bash
docker build -f GenieACS.dockerfile . -t drumsergio/genieacs:1.2.0
```

If you decide to build the dockerfile, do not change its name (tag). If you wish to modify it, change docker-compose.yml accordingly.

### Run Docker Compose

**Please**, modify the `docker-compose.yml` file accordingly if you plan to deploy into production. Comment out the `volumes:` directive if you encounter problems in the installation.

If you deploy it in a QNAP's QTS then this is the only step needed after downloading `docker-compose.yml`:

```bash
docker-compose up -d
```

To log into the container, issue the command `docker exec -it genieacs /bin/bash`. If you happen to be managing this setting in your company, better to have some knowledge of Docker.

The UI will be available at port `3000`. You will see a wizard where you can configure GenieACS according to your needs.

### Use of the Vagrantfile
If you want to use GenieACS inside a VM you have a Vagrantfile ready to be deployed in VirtualBox. Although the use of Vagrant alongside VirtualBox is more development-oriented, it can be used along with your private Hyper-V or VMware cluster too, if you change the Vagranfile accordingly.

For this setting to work, you need Vagrant installed on your computer https://www.vagrantup.com/docs/installation/ and of course, VirtualBox if you decide to use this provider with the Vagrantfile I provided https://www.virtualbox.org/wiki/Downloads

Then, you simply issue the command `vagrant up` in the directory where the Vagrantfile is.

##### This repo appears in the GenieACS Wiki: https://github.com/genieacs/genieacs/wiki/Docker-Installation-with-Docker-Compose
