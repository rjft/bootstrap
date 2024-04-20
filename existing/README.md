## Bootstrapping an empty existing cluster

This will guide teams new to kubernetes how to setup a fresh cluster with what's needed to install your instance of the Plural console. There are three main things we're going to try to get into this cluster:

* cert-manager - this is used to issue certificates with the ACME protocol
* external-dns - this is used to wire DNS records against common cloud DNS providers to k8s load balancer resources
* ingress-nginx - a well-supported ingress controller to handle complex load balancing and routing setups

## General Flow

You'll need to do a few things to get set up:

* Install cloud prereqs via terraform
* install cert-manager and our runtime chart via helm
* install console via helm
* set up a bootstrapping Plural service to subscribe to future updates

To do all this, you'll want to create your own git repo to copy code into and keep a record of what's been done.  None of the code will require committing any secrets.

## Installing Cloud Prereqs

Within the `terraform/{cloud}` folders here, there are simple terraform stacks to set up the needed cloud resources.  These are usually IAM bindings.  You can reference `test/{cloud}` to see how they're used, and if you want you can use our terraform to set up our cluster as well.  You'll want to first copy the relevant terraform code into a working folder in your git repo, we'd recommend just naming it `/terraform`, then run:

```sh
terraform init -upgrade
terraform plan
terraform apply
terraform output -json
```

The outputs will be needed later

## Install Helm Charts

Next you'll want to copy our helm values files `helm/certmanager.yaml` and `helm/runtime.yaml` to a folder in your git repo, in our setup the folder will be `/helm-values`, and make the minor modifications the comments specify w/ the outputs from terraform.  For instance, on Azure, it'll want you to set workload identity annotations like:

```yaml
external-dns:
  serviceAccount:
    annotations:
      azure.workload.identity/client-id: <YOUR_CLIENT_ID>
```

Before running any helm commands, you'll need to be able to kubectl on your cluster.  For azure, this would be running the command:

```sh
az aks get-credentials -n {cluster-name} -g {resource-group}
kubectl get pods -A # to confirm
```

(AWS, GCP, etc have their own kubectl commands to navigate).

The helm commands to run once those files have been copied and modified and you have kubectl to your cluster are:

```sh
helm repo add jetstack https://charts.jetstack.io || helm repo update
helm repo add plrl-bootstrap https://pluralsh.github.io/bootstrap || helm repo update
helm upgrade --install --create-namespace cert-manager jetstack/cert-manager -f helm-values/certmanager.yaml -n cert-manager
helm upgrade --install --create-namespace plrl-runtime plrl-bootstrap/runtime -f helm-values/runtime.yaml
```

## Install the Plural Console

From here you can use the BYOK install process described at https://docs.plural.sh/deployments/existing-cluster.  As a tldr, you'll run the following commands:

```sh
plural login
plural cd control-plane
```

You might need to install the plural cli, which is available on homebrew via: `brew install pluralsh/plural/plural`

The `plural cd control-plane` command generates the helm values you need to install the plural console, which will then be applied with:

```sh
helm repo add plrl-console https://pluralsh.github.io/console
helm upgrade --install --create-namespace -f values.secret.yaml console plrl-console/console -n plrl-console
```

## Setup Continuous Updates

From there, you'll want to copy the `existing/setup` folder to your working git repository, add that git repository to the plural console by navigating to the ui at `https://{your-console-url}/cd/repos`.  From there, you'll want to first save your values file as a k8s secret:

```sh
kubectl create secret generic console-values --from-file=values.yaml=values.secret.yaml -n infra
```

Then you should be able to create the initial bootstrapping service by creating a Plural service at `https://{your-console-url}/cd/services` with the attributes:

```
Namespace:  infra
Name:       setup
Cluster:    <management-cluster>
Repository: <your-repository-url>
Branch:     main
Folder:     existing/setup
```

These can all be entered in our UI for simplicity, and from there, you can use your git repository to GitOps freely.
