module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 29.0"

  kubernetes_version     = var.kubernetes_version
  project_id             = var.project_id
  name                   = var.cluster_name
  regional               = true
  region                 = var.region
  network                = module.gcp-network.network_name
  subnetwork             = module.gcp-network.subnets_names[0]
  ip_range_pods          = var.ip_range_pods_name
  ip_range_services      = var.ip_range_services_name
  create_service_account = true
  deletion_protection    = var.deletion_protection

  depends_on = [
    google_project_service.gcr,
    google_project_service.container,
    google_project_service.iam,
    google_project_service.storage,
    google_project_service.dns,
  ]
}