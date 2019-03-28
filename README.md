# GenieACS-Docker

Recommended Host Machine: Debian 9

Machine preferably with 4GB or more. The rest can change

## Install - (Just copy-paste this section)

```bash
apt update
apt dist-upgrade -y
apt autoremove -y
apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common sudo openssh-server htop avahi-daemon tcpdump wget

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt update
apt install -y docker-ce

sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.23.2/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose ## In order to enable command-line completion of Compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Pull/Build Dockerfile - (You choose!)

```bash
docker pull drumsergio/genieacs
```
or:
```bash
docker build -f GenieACS.dockerfile . -t drumsergio/genieacs
```

## Run Docker Compose - (You need to have in the same directory the docker-compose.yml)

```bash
docker-compose up -d
```
If you need to stop it: docker-compose down


Then: Change manually FS_HOSTNAME to your local IP/hostname in /opt/genieacs/config/config.json
Also: Change manually user/passwords in /opt/genieacs/config/users.yml
