# GenieACS Deployment Examples

This directory contains example deployment configurations for GenieACS.

## Helmfile Example

The `helmfile.yaml` demonstrates how to deploy GenieACS on Kubernetes using Helmfile with:

- Bitnami MongoDB chart
- GenieACS Helm chart from the official repository

### Prerequisites

- Kubernetes cluster access
- `helm` CLI installed
- `helmfile` CLI installed ([installation guide](https://helmfile.readthedocs.io/en/latest/#installation))

### Usage

1. Review and customize the configuration files:
   - `helmfile.yaml` - Main Helmfile configuration
   - `genieacs.yaml` - GenieACS chart values
   - `mongo.yaml` - MongoDB chart values
   - `mongo-secret.yaml` - MongoDB credentials (create this file)

2. Create the MongoDB secret (if using authentication):

```bash
kubectl create namespace genieacs
kubectl create secret generic mongodb-secret \
  --from-literal=username=admin \
  --from-literal=password=your-secure-password \
  -n genieacs
```

3. Deploy using Helmfile:

```bash
helmfile -f helmfile.yaml apply
```

4. Check deployment status:

```bash
kubectl get pods -n genieacs
kubectl get services -n genieacs
```

5. Access GenieACS UI (using port-forward):

```bash
kubectl port-forward -n genieacs svc/genieacs-http 3000:3000
```

Then open http://localhost:3000 in your browser.

### Configuration

The example uses the official GenieACS Helm chart repository:

```yaml
repositories:
  - name: genieacs
    url: https://geiserx.github.io/genieacs-docker
```

To use a local chart, modify the `helmfile.yaml` to point to the local chart path:

```yaml
releases:
  - name: genieacs
    chart: ../../charts/genieacs
```

