locals {
  cen_instance_id       = var.create_cen_instance ? alicloud_cen_instance.this[0].id : var.cen_instance_id
  cen_transit_router_id = var.create_cen_transit_router ? alicloud_cen_transit_router.this[0].transit_router_id : var.cen_transit_router_id
}

/*
 * CEN
 */
resource "alicloud_cen_instance" "this" {
  count = var.create_cen_instance ? 1 : 0

  cen_instance_name = var.cen_instance_config.cen_instance_name
  protection_level  = var.cen_instance_config.protection_level
  description       = var.cen_instance_config.description
  tags              = var.cen_instance_config.tags
}

/*
 * TR
 */
resource "alicloud_cen_transit_router" "this" {
  count = var.create_cen_transit_router ? 1 : 0

  cen_id                     = local.cen_instance_id
  transit_router_name        = var.tr_config.transit_router_name
  transit_router_description = var.tr_config.transit_router_description
  support_multicast          = var.tr_config.support_multicast
  tags                       = var.tr_config.tags
}

/*
 * VPC
 */
module "vpc" {
  source = "./modules/vpc"
  count  = var.create_vpc_resources ? length(var.vpc_config) : 0

  cen_instance_id       = local.cen_instance_id
  cen_transit_router_id = local.cen_transit_router_id

  vpc               = var.vpc_config[count.index].vpc
  vswitches         = var.vpc_config[count.index].vswitches
  tr_vpc_attachment = var.vpc_config[count.index].tr_vpc_attachment
}

/*
 * VBR
 */
resource "alicloud_express_connect_router_express_connect_router" "this" {
  alibaba_side_asn = var.vbr_config.ecr_config.alibaba_side_asn
  ecr_name         = var.vbr_config.ecr_config.ecr_name
  description      = var.vbr_config.ecr_config.ecr_description
}

module "vbr" {
  source = "./modules/vbr"

  count = var.create_vbr_resources ? length(var.vbr_config.vbrs) : 0

  ecr_id = alicloud_express_connect_router_express_connect_router.this.id

  vbr           = var.vbr_config.vbrs[count.index].vbr
  vbr_bgp_group = var.vbr_config.vbrs[count.index].vbr_bgp_group
  vbr_bgp_peer  = var.vbr_config.vbrs[count.index].vbr_bgp_peer
}

data "alicloud_regions" "this" {
  current = true
}

data "alicloud_account" "current" {}

resource "alicloud_express_connect_router_tr_association" "this" {
  association_region_id   = data.alicloud_regions.this.regions[0].id
  ecr_id                  = alicloud_express_connect_router_express_connect_router.this.id
  cen_id                  = local.cen_instance_id
  transit_router_id       = local.cen_transit_router_id
  transit_router_owner_id = data.alicloud_account.current.id

  depends_on = [module.vbr]
}

resource "alicloud_cen_transit_router_ecr_attachment" "this" {
  ecr_id                                = alicloud_express_connect_router_express_connect_router.this.id
  cen_id                                = local.cen_instance_id
  transit_router_ecr_attachment_name    = var.vbr_config.tr_ecr_attachment.transit_router_ecr_attachment_name
  transit_router_attachment_description = var.vbr_config.tr_ecr_attachment.transit_router_ecr_attachment_description
  transit_router_id                     = local.cen_transit_router_id
  ecr_owner_id                          = data.alicloud_account.current.id

  depends_on = [alicloud_express_connect_router_tr_association.this]
}

data "alicloud_cen_transit_router_route_tables" "this" {
  transit_router_id               = local.cen_transit_router_id
  transit_router_route_table_type = "System"
}

resource "alicloud_cen_transit_router_route_table_propagation" "this" {
  count = var.vbr_config.tr_ecr_attachment.route_table_propagation_enabled ? 1 : 0

  transit_router_route_table_id = data.alicloud_cen_transit_router_route_tables.this.tables[0].transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_ecr_attachment.this.id
}

resource "alicloud_cen_transit_router_route_table_association" "this" {
  count = var.vbr_config.tr_ecr_attachment.route_table_association_enabled ? 1 : 0

  transit_router_route_table_id = data.alicloud_cen_transit_router_route_tables.this.tables[0].transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_ecr_attachment.this.id
}


/*
 * VPN
 */

module "vpn" {
  source = "./modules/vpn"

  count = var.create_vpn_resources ? length(var.vpn_config) : 0

  cen_instance_id       = local.cen_instance_id
  cen_transit_router_id = local.cen_transit_router_id

  vpn_customer_gateway = var.vpn_config[count.index].vpn_customer_gateway
  vpn_attachment       = var.vpn_config[count.index].vpn_attachment
  tr_vpn_attachment    = var.vpn_config[count.index].tr_vpn_attachment
}

