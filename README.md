# terraform-kuberay

## Installation

1. Edit `variables.tf` with your GCP settings.

2. Run `terraform init`

3. Run `terraform apply`

## Using Ray

1. Run `kubectl get services -n <namespace>`

2. Copy the external IP

3. Open the external IP in a browser and login.

4. The Ray cluster is available at `ray://example-cluster-kuberay-head-svc:10001`.
