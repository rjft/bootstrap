module "externaldns" {
    source = "../../terraform/azure"
    cluster_name = module.mgmt.cluster.aks_name
    resource_group = "plural"
    dns_zone_name = "az.plural.sh"

    depends_on = [ module.mgmt.cluster, module.mgmt.db_url ]
}