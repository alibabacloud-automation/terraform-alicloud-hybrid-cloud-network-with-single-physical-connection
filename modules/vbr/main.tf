
/*
 * vbr
 */
resource "alicloud_express_connect_virtual_border_router" "this" {
  physical_connection_id     = var.vbr.physical_connection_id
  vlan_id                    = var.vbr.vlan_id
  local_gateway_ip           = var.vbr.local_gateway_ip
  peer_gateway_ip            = var.vbr.peer_gateway_ip
  peering_subnet_mask        = var.vbr.peering_subnet_mask
  virtual_border_router_name = var.vbr.virtual_border_router_name
  description                = var.vbr.description
}

/*
 * Attachment to ECR
 */
data "alicloud_regions" "this" {
  current = true
}
resource "alicloud_express_connect_router_vbr_child_instance" "this" {
  child_instance_id        = alicloud_express_connect_virtual_border_router.this.id
  child_instance_region_id = data.alicloud_regions.this.regions[0].id
  ecr_id                   = var.ecr_id
  child_instance_type      = "VBR"
}

/*
 * bgp_group & bgp_peer
 */
resource "alicloud_vpc_bgp_group" "this" {
  router_id      = alicloud_express_connect_virtual_border_router.this.id
  auth_key       = var.vbr_bgp_group.auth_key
  bgp_group_name = var.vbr_bgp_group.bgp_group_name
  peer_asn       = var.vbr_bgp_group.peer_asn
  is_fake_asn    = var.vbr_bgp_group.is_fake_asn
  description    = var.vbr_bgp_group.description

  depends_on = [alicloud_express_connect_router_vbr_child_instance.this]
}

resource "alicloud_vpc_bgp_peer" "this" {
  bgp_group_id    = alicloud_vpc_bgp_group.this.id
  bfd_multi_hop   = var.vbr_bgp_peer.bfd_multi_hop
  enable_bfd      = var.vbr_bgp_peer.enable_bfd
  ip_version      = var.vbr_bgp_peer.ip_version
  peer_ip_address = var.vbr_bgp_peer.peer_ip_address
}
