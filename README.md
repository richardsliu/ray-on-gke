# Ray on GKE

This repository contains a Terraform template for running [Ray](https://www.ray.io/) on Google Kubernetes Engine.
We've also included some example notebooks, including one that serves a GPT-J-6B model with Ray AIR (see
[here](https://docs.ray.io/en/master/ray-air/examples/gptj_serving.html) for the original notebook).

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

4. The Ray cluster is available at `ray://example-cluster-kuberay-head-svc:10001`. To access the cluster, you can open one of the sample notebooks under `example_notebooks` (via `File` -> `Open from URL` in the Jupyter notebook window and use the raw file URL from GitHub) and run through the example. Ex url: https://raw.githubusercontent.com/richardsliu/ray-on-gke/main/example_notebooks/gpt-j-online.ipynb

## Securing Your Cluster Endpoints

For demo purposes, this repo creates a public IP for the Ray head node and the
Jupyter notebook. To secure your cluster, it is *strong recommended* to replace
this with your own secure endpoints. 

For more information, please take a look at the following links:
* https://cloud.google.com/iap/docs/enabling-kubernetes-howto
* https://cloud.google.com/endpoints/docs/openapi/get-started-kubernetes-engine


## Running GPT-J-6B

This example is adapted from Ray AIR's examples [here](https://docs.ray.io/en/master/ray-air/examples/gptj_serving.html).

1. Open the `gpt-j-online.ipynb` notebook.

2. Open a terminal in the Jupyter session and install Ray AIR:
```
pip install ray[air]
```

3. Run through the notebook cells. You can change the prompt in the last cell:
```
prompt = (
     ## Input your own prompt here
)
```

4. This should output a generated text response.
