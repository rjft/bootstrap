# Prometheus Monitoring Setup

This gives an overview of a production-ready observability setup with Prometheus for timeseries metrics collection and Loki for log aggregation.  It sets up central instances of Prometheus and Loki (on your management cluster in this case, but could go elsewhere), and promtail plus prometheus agent installs to collect and ship metrics remotely.

A quick overview of repository structure:

* `/terraform` - example terraform you can rework to set up cloud resources.  In this case it sets up the s3 bucket needed by loki to persist the service and terraform's the initial services to start the service-of-service process to provision everything else
* `/helm-values` - values files for all the charts needed, note the `.liquid` variants support templating both configuration values and other contextual information that's useful especially in global service contexts
* `/services` - the service-of-services that sets up all the main components, in order these are:
    - prometheus agent, replicated across clusters as a global service
    - prometheus itself, deployed via kube-prometheus-stack
    - loki, deployed on the mgmt cluster
    - promtail, replicated as a global service
* `/helm-repositories` - flux helm repositories crds needed to create helm repository services for the various resources

## Adopting this setup

We'd recommend copy-pasting this into a repo you own to assist customization.  There are a few points you'd need to know to customize:

* urls for your prometheus/loki domain, in the kps-* and loki-* helm values.  They will usually be in ingress configuration, but also elsewhere.  Our defaults were `loki.boot-aws.onplural.sh`, `prometheus.boot-aws.onplural.sh`, etc
* cluster names in servicedeployment.yaml files, eg in `services/kps-agent-fleet/servicedeployment.yaml`, it's wired to our default cluster name, `boot-staging`
* you currently need to manually set `basicAuthUser` and `basicAuthPassword` in your root service-of-services' secrets to configure basic auth for both loki and prometheus.

## Configure Prometheus and Loki for your Console ui

The console has the ability to take prometheus and loki connection information to begin providing log aggregation and metrics views in useful places in-ui. The configuration is nested under the deployment settings tab, at `/cd/settings/observability`.  Be sure to use the same values as for the basic auth configuration above.