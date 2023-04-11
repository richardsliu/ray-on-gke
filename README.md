# Ray on GKE

The solution is split into `platform` and `user` resources. 

Platform resources (deployed once):
* GKE Cluster
* Nvidia GPU drivers
* Kuberay operator and CRDs

User resources (deployed once per user):
* User namespace
* Kubernetes service accounts
* Kuberay cluster
* Prometheus monitoring
* Logging container
* Jupyter notebook

## Installation

### Platform

1. `cd platform`

2. Edit `variables.tf` with your GCP settings.

3. Run `terraform init`

4. Run `terraform apply`

### User

1. `cd user`

2. Edit `variables.tf` with your GCP settings.

3. Run `terraform init`

4. Run `terraform apply`

## Using Ray

1. Run `kubectl get services -n <namespace>`

2. Copy the external IP for the notebook.

3. Open the external IP in a browser and login.

4. The Ray cluster is available at `ray://example-cluster-kuberay-head-svc:10001`. To access the cluster, you can open one of the sample notebooks under `example_notebooks` (via `File` -> `Open from URL` in the Jupyter notebook window) and run through the example.
