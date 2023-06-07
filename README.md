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

Note: Terraform keeps state metadata in a local file called `terraform.tfstate`.
If you need to reinstall any resources, make sure to delete this file as well.

### Platform

1. `cd platform`

2. Edit `variables.tf` with your GCP settings.

3. Run `terraform init`

4. Get the GKE cluster name and location/region from `platform/variables.tf`. 
   Run `gcloud container clusters get-credentials %gke_cluster_name% --location=%location%`

5. Run `terraform apply`

### User

1. `cd user`

2. Edit `variables.tf` with your GCP settings.

3. Run `terraform init`

4. Get the GKE cluster name and location/region from `platform/variables.tf`.
   Run `gcloud container clusters get-credentials %gke_cluster_name% --location=%location%`

5. Run `terraform apply`

## Using Ray

1. Run `kubectl get services -n <namespace>`

2. Copy the external IP for the notebook.

3. Open the external IP in a browser and login. The default user names and
   passwords can be found in the [Jupyter
   settings](https://github.com/richardsliu/ray-on-gke/blob/main/user/modules/jupyterhub/jupyterhub-values.yaml) file.

4. The Ray cluster is available at `ray://example-cluster-kuberay-head-svc:10001`. To access the cluster, you can open one of the sample notebooks under `example_notebooks` (via `File` -> `Open from URL` in the Jupyter notebook window and use the raw file URL from GitHub) and run through the example. Ex url: https://raw.githubusercontent.com/richardsliu/ray-on-gke/main/example_notebooks/gpt-j-online.ipynb

5. To use the Ray dashboard, run the following command to port-forward:
```
kubectl port-forward -n ray service/example-cluster-kuberay-head-svc 8265:8265
```

And then open the dashboard using the following URL:
```
http://localhost:8265
```

## Securing Your Cluster Endpoints

For demo purposes, this repo creates a public IP for the Jupyter notebook with basic dummy authentication. To secure your cluster, it is *strong recommended* to replace
this with your own secure endpoints. 

For more information, please take a look at the following links:
* https://cloud.google.com/iap/docs/enabling-kubernetes-howto
* https://cloud.google.com/endpoints/docs/openapi/get-started-kubernetes-engine
* https://jupyterhub.readthedocs.io/en/stable/tutorial/getting-started/authenticators-users-basics.html


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


## Logging and Monitoring

This repository comes with out-of-the-box integrations with Google Cloud Logging
and Managed Prometheus for monitoring. To see your Ray cluster logs:

1. Open Cloud Console and open Logging
2. Note the job ID returned by the `ray job submit` API.
   Job submission: `ray job submit --working-dir /Users/imreddy/ray_working_directory  -- python script.py`
   Job submission ID: `Job 'raysubmit_kFWB6VkfyqK1CbEV' submitted successfully`
3. Get the namespace name from `user/variables.tf` or `kubectl get namespaces`
4. Use the following query to search for the job logs:

```
resource.labels.namespace_name=%NAMESPACE_NAME%
jsonpayload.job_id=%RAY_JOB_ID%
```

To see monitoring metrics:
1. Open Cloud Console and open Metrics Explorer
2. In "Target", select "Prometheus Target" and then "Ray".
3. Select the metric you want to view, and then click "Apply".
