# VBR
output "vbr_id" {
  value       = alicloud_express_connect_virtual_border_router.this.id
  description = "The id of VBR."
}

output "vbr_route_table_id" {
  value       = alicloud_express_connect_virtual_border_router.this.route_table_id
  description = "The route table id of VBR."
}

output "ecr_vbr_child_instance_id" {
  value       = alicloud_express_connect_router_vbr_child_instance.this.id
  description = "The id of ECR VBR child instance."
}

# bgp_group
output "bgp_group_id" {
  value       = alicloud_vpc_bgp_group.this.id
  description = "The id of BGP group."
}

# bgp_peer
output "bgp_peer_id" {
  value       = alicloud_vpc_bgp_peer.this.id
  description = "The id of BGP peer."
}
