# Plural Bootstrap

This repo defines the core terraform code needed to bootstrap a Plural management cluster.  It is intended to be cloned in a users infra repo and then owned by their DevOps team from there.  We do our best to adhere to the standard terraform setup for k8s within the respective cloud, while also installing necessary add-ons as needed (eg load balancer controller and autoscaler for AWS).

## General Architecture

There are three main resources created by these templates:

* VPC Network to house all resources in the respective cloud
* K8s Control Plane + minimal worker node set
* Postgres DB (will be used for your Plural Console instance)

Our defaults are meant to be tweaked, feel free to reference the documentation of the underlying modules if you want to make a cluster private, or modify our CIDR range defaults if you want to VPC peer.

When used in a plural installation repo, the process is basically:

* create a git submodule in the installation repo pointing to the https://github.com/pluralsh/bootstrap.git repository
* template and copy base terraform files into their respective folders (`/clusters` for cluster infra and `/apps` for app setup)
* execute the terraform in sequence from there

THis follows a generate-once approach, as in we'll generate the working defaults and any customizations from there are left to the user.  This makes it much easier to reimplement our setup for a company's security or scalability preferences rather than worrying about an upstream change.  If you ever want to sync from upstream, you can simply `cd bootstrap && git pull` to fetch the most recent changes.

## Installation repo folder structure

A plural installation repo will have a folder structure like this:

```
bootstrap/ -> git submodule pointing to https://github.com/pluralsh/bootstrap.git
clusters/ - the base setup to get a management cluster going
- mgmt.tf
- provider.tf
- ...
helm-values/ - git crypted helm values to be used for app installs
- ${app}.yaml - value overrides
- ${app}-defaults.yaml - default values we generate on install
apps/ - setup for apps within your cluster fleet
- repositories/ - contains all helm repositories you want to register for deployments
- services/ - contains specification for all services you want to create w/in your cluster fleet
- terraform/
  - ${app}.tf - entrypoint for a given app
  - ${app}/ - submodule for individual app terraform
```

You're free to extend this as you'd like, although if you use the plural marketplace that structure will be expected.  You can also deploy services w/ manifests in other repos, this is meant to serve as a base to define the core infrastructure and get you started in a sane way.