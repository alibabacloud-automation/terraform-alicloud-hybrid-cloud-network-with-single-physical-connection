# CEN
output "cen_instance_id" {
  description = "The id of CEN instance."
  value       = module.complete.cen_instance_id
}

# TR
output "cen_transit_router_id" {
  description = "The id of CEN transit router."
  value       = module.complete.cen_transit_router_id
}

# VPC
output "vpc_id" {
  value       = module.complete.vpc_id
  description = "The ids of vpc."
}

output "vpc_route_table_id" {
  value       = module.complete.vpc_route_table_id
  description = "The route table id of vpc."
}

output "vswitch_ids" {
  value       = module.complete.vswitch_ids
  description = "The ids of vswitches."
}

output "tr_vpc_attachment_id" {
  value       = module.complete.tr_vpc_attachment_id
  description = "The id of attachment between TR and VPC."
}

output "tr_vpc_route_table_propagation_id" {
  value       = module.complete.tr_vpc_route_table_propagation_id
  description = "The id of route table propagation bewteen TR and VPC."
}

output "tr_vpc_route_table_association_id" {
  value       = module.complete.tr_vpc_route_table_association_id
  description = "The id of route table association bewteen TR and VPC."
}

# VBR
output "express_connect_router_id" {
  description = "The id of Express Connect Router."
  value       = module.complete.express_connect_router_id
}

output "vbr_id" {
  value       = module.complete.vbr_id
  description = "The ids of VBR."
}

output "vbr_route_table_id" {
  value       = module.complete.vbr_route_table_id
  description = "The route table id of VBR."
}

output "ecr_vbr_child_instance_id" {
  value       = module.complete.ecr_vbr_child_instance_id
  description = "The id of ECR VBR child instance."
}

output "bgp_group_id" {
  value       = module.complete.bgp_group_id
  description = "The id of BGP group."
}

output "bgp_peer_id" {
  value       = module.complete.bgp_peer_id
  description = "The id of BGP peer."
}

output "tr_ecr_attachment_id" {
  description = "The attachment id between TR and ECR."
  value       = module.complete.tr_ecr_attachment_id
}

output "tr_vbr_route_table_propagation_id" {
  value       = module.complete.tr_vbr_route_table_propagation_id
  description = "The id of route table propagation bewteen TR and VBR."
}

output "tr_vbr_route_table_association_id" {
  value       = module.complete.tr_vbr_route_table_association_id
  description = "The id of route table association bewteen TR and VBR."
}

# VPN
output "vpn_customer_gateway_id" {
  description = "The ID of the VPN Customer Gateway"
  value       = module.complete.vpn_customer_gateway_id
}

output "vpn_gateway_vpn_attachment_id" {
  description = "The ID of the VPN Gateway VPN Attachment"
  value       = module.complete.vpn_gateway_vpn_attachment_id
}

output "tr_cidr_id" {
  description = "The cidr id of the transit router"
  value       = module.complete.tr_cidr_id
}

output "tr_vpn_route_table_propagation_id" {
  description = "The ID of the transit router VPN attachment"
  value       = module.complete.tr_vpn_route_table_propagation_id
}

output "tr_vpn_route_table_association_id" {
  description = "The ID of the transit router VPN attachment"
  value       = module.complete.tr_vpn_route_table_association_id
}
