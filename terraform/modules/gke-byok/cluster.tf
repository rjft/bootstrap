data "google_client_config" "default" {}

data "google_container_cluster" "cluster" {
  name = var.cluster_name
  location = var.location
  project = var.project
}

resource "plural_cluster" "this" {
    handle   = var.cluster_handle
    name     = var.cluster_name
    tags     = var.tags
    protect  = var.protect
    # bindings = var.bindings
    cloud    = "byok"
    cloud_settings = {
        byok = {
            host = "https://${data.google_container_cluster.cluster.endpoint}"
            cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
            token = data.google_client_config.default.access_token
        }
    }
}