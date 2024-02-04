module "mgmt" {
    source              = "../../terraform/clouds/aws"
    cluster_name        = "mjg-test"
    vpc_name            = "mjg-test" 
    deletion_protection = false
}