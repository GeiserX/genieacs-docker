# Changelog

All notable changes to this project will be documented in this file.

## [1.2.13.4] - 2026-02-20

### Added
- **Working logrotate** with cron daemon for automatic log rotation
- **gosu** for proper privilege dropping after starting cron
- **entrypoint.sh** to manage cron startup before supervisord

### Changed
- Container now starts as root to run cron, then drops to genieacs via gosu
- Logrotate config updated with `missingok` and `su genieacs genieacs` directives
- Removed unnecessary cron.daily scripts (dpkg, apt-compat) that blocked processing

### Fixed
- Fixed logrotate syntax error with brace expansion (#31)
- Fixed logrotate not running due to missing cron daemon

### Contributors
- Thanks to [@Rocket78](https://github.com/Rocket78) for implementing the working logrotate solution (#32)

## [1.2.13.2] - 2025-12-05

### Added
- **Git CLI** installed in Docker container for enhanced functionality
- **ServiceAccount** support in Helm chart with configurable creation
- **PodSecurityContext** and **SecurityContext** configurations for enhanced security
- **Liveness and Readiness probes** for better health monitoring
- **PodDisruptionBudget** support for high availability deployments
- **NodeSelector, Tolerations, and Affinity** support for advanced scheduling
- **GitHub Actions workflow** for automated Helm chart releases
- **Comprehensive documentation** with improved README and examples
- **Health checks** in docker-compose.yml for both GenieACS and MongoDB
- **Service profiles** in docker-compose.yml for optional services

### Changed
- **Version updated** to 1.2.13.2 (Docker container release)
- **Helm chart version** bumped to 0.1.1
- **Logrotate configuration** moved to `config/` directory for better organization
- **Deployment examples** reorganized from `genieacs-deploy-helmfile/` to `examples/` directory
- **Docker Compose** improved with better restart policies and health checks
- **Helm chart** enhanced with security best practices and production-ready configurations

### Fixed
- Fixed ingress template syntax error
- Fixed PVC template YAML formatting
- Fixed test-connection.yaml to use correct service name and port
- Fixed volumeMounts to only appear when persistence is enabled

### Security
- Container runs as non-root user (genieacs)
- Security contexts configured with least privilege
- Capabilities dropped to minimum required
- Read-only root filesystem option available

