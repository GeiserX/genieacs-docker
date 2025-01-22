![img](https://github.com/GeiserX/genieacs-docker/blob/extra/logo.jpg?raw=true)
# Deployment tools for GenieACS

[![genieacs compliant](https://img.shields.io/github/license/GeiserX/genieacs-docker)](https://github.com/GeiserX/genieacs-docker/blob/main/LICENSE)

This project contains two methods to deploy GenieACS in your environment: 
1. Docker compose method
2. Helm chart (Helmfile) method

## Table of Contents

- [Background](#background)
- [Install](#install)
- [Maintainers](#maintainers)
- [Contributing](#contributing)

## Background

This project was conceived long time ago with the idea of easing the deploment of GenieACS, and especially enabling it to run in Red Hat Linux. The project evolved and now it is the default method to install GenieACS (community version).

## Install

This project uses a [Docker container](https://hub.docker.com/repository/docker/drumsergio/genieacs) to deploy GenieACS. Use docker compose to deploy it seamlessly.

```sh
$ docker compose up -d
```

As an alternative, for Kubernetes clusters, there is the option to deploy it via Helm chart. The example from the repository uses Helmfile:

```bash
helmfile -f genieacs-deploy-helmfile/helmfile.yaml -i apply
```

## Maintainers

[@GeiserX](https://github.com/GeiserX).

## Contributing

Feel free to dive in! [Open an issue](https://github.com/GeiserX/genieacs-docker/issues/new) or submit PRs.

GenieACS-Docker follows the [Contributor Covenant](http://contributor-covenant.org/version/2/1/) Code of Conduct.

### Contributors

This project exists thanks to all the people who contribute. 
<a href="https://github.com/GeiserX/genieacs-docker/graphs/contributors"><img src="https://opencollective.com/genieacs-docker/contributors.svg?width=890&button=false" /></a>