##############################################################################
# Create IKS on VPC Cluster
##############################################################################

resource ibm_container_vpc_cluster cluster {

  name              = "${var.prefix}-roks-cluster"
  vpc_id            = var.vpc_id
  resource_group_id = var.resource_group_id
  flavor            = var.machine_type
  worker_count      = var.workers_per_zone
  kube_version      = var.kube_version != "" ? var.kube_version : null
  tags              = var.tags
  wait_till         = var.wait_till
  entitlement       = var.entitlement
  cos_instance_crn  = var.cos_id

  dynamic zones {
    for_each = var.subnets
    content {
      subnet_id = zones.value.id
      name      = zones.value.zone
    }
  }

  disable_public_service_endpoint = var.disable_public_service_endpoint

}

##############################################################################


##############################################################################
# Worker Pools
##############################################################################

module worker_pools {
  source            = "./worker_pools"
  region            = var.region
  worker_pools      = var.worker_pools
  entitlement       = var.entitlement
  vpc_id            = var.vpc_id
  resource_group_id = var.resource_group_id
  cluster_name_id   = ibm_container_vpc_cluster.cluster.id
  subnets           = var.subnets
}

##############################################################################
