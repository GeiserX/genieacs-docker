# GenieACS Deployment Examples

This directory contains example deployment configurations for GenieACS using the current Helm chart (v0.3.x).

## Helmfile Example

The `helmfile.yaml` demonstrates how to deploy GenieACS on Kubernetes using [Helmfile](https://github.com/helmfile/helmfile) with the bundled MongoDB subchart.

### Prerequisites

- Kubernetes cluster access
- `helm` CLI installed
- `helmfile` CLI installed ([installation guide](https://helmfile.readthedocs.io/en/latest/#installation))

### Files

| File | Description |
|------|-------------|
| `helmfile.yaml` | Main Helmfile configuration (chart repo + release) |
| `genieacs.yaml` | GenieACS chart values (MongoDB auth enabled) |
| `genieacs-secrets.yaml` | MongoDB root password — do NOT commit real values (use [helm-secrets](https://github.com/jkroepke/helm-secrets) for encryption in production) |

### Usage

1. Review and customize the configuration files.

2. Set your MongoDB root password in `genieacs-secrets.yaml`.

3. Deploy:

```bash
helmfile -f helmfile.yaml apply
```

4. Check deployment status:

```bash
kubectl get pods -n genieacs
kubectl get services -n genieacs
```

5. Access GenieACS UI:

```bash
kubectl port-forward -n genieacs svc/genieacs-http 3000:3000
```

Then open http://localhost:3000 in your browser.

### External MongoDB

To use your own MongoDB instead of the bundled subchart, set in `genieacs.yaml`:

```yaml
mongodb:
  enabled: false

externalMongodb:
  url: "mongodb://user:password@your-mongo-host:27017/genieacs?authSource=admin"
```
