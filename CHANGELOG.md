# Changelog

All notable changes to this project will be documented in this file.

## Helm Chart [0.2.0] - 2026-02-22

### Added
- **MongoDB subchart** (Bitnami 18.6.0) as an optional dependency, enabled by default (#33)
- **`ingressClassName`** support for clusters with multiple ingress controllers (#33)
- **`envFrom`** support for injecting env vars from Kubernetes Secrets/ConfigMaps (#33)
- **`extraEnvVars`** support for env vars with `valueFrom` (e.g. secretKeyRef) (#33)
- **`externalMongodb.url`** for bring-your-own MongoDB deployments (#33)

### Fixed
- Ingress backend now references the correct service name (`*-http`) (#33)
- `appVersion` in Chart.yaml now matches the image tag (1.2.13.4)

### Changed
- Removed redundant `restartPolicy: Always` from Deployment template

### Contributors
- Thanks to [@ggiesen](https://github.com/ggiesen) for reporting and proposing fixes (#33)

## [1.2.13.5] - 2026-02-23

### Fixed
- **Helm chart**: Fixed `capabilities.drop: ALL` preventing supervisord/gosu from switching users - now adds SETUID/SETGID (#34)
- **Helm chart**: Fixed PVC mount masking entrypoint by changing mount from `/opt` to `/opt/genieacs/ext` (#35)
- **Docker image**: Moved entrypoint.sh from `/opt/` to `/usr/local/bin/` to avoid volume mount conflicts

### Changed
- Helm chart version bumped to 0.2.1
- Persistence volume now mounts at `/opt/genieacs/ext` (extensions only) instead of entire `/opt` directory

### Migration Notes (Helm chart 0.2.0 → 0.2.1)

**Breaking change**: The persistence mount path changed from `/opt` to `/opt/genieacs/ext`.

If you have an existing deployment with `persistence.enabled: true` and custom extensions:

1. Backup your extensions:
   ```bash
   kubectl cp <namespace>/<pod-name>:/opt/genieacs/ext ./extensions-backup
   ```
2. Upgrade the Helm chart to 0.2.1
3. Restore extensions to the new mount:
   ```bash
   kubectl cp ./extensions-backup/. <namespace>/<pod-name>:/opt/genieacs/ext/
   ```

**Note**: Chart 0.2.0 with image 1.2.13.4 was non-functional due to #35, so most users won't have data to migrate.

### Contributors
- Thanks to [@ggiesen](https://github.com/ggiesen) for the detailed bug reports (#34, #35)

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

