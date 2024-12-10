output "vpn_customer_gateway_id" {
  description = "The ID of the VPN Customer Gateway"
  value       = alicloud_vpn_customer_gateway.this.id
}

output "vpn_gateway_vpn_attachment_id" {
  description = "The ID of the VPN Gateway VPN Attachment"
  value       = alicloud_vpn_gateway_vpn_attachment.this.id
}

output "tr_cidr_id" {
  description = "The cidr id of the transit router"
  value       = alicloud_cen_transit_router_cidr.this.transit_router_cidr_id
}

output "tr_vpn_route_table_propagation_id" {
  description = "The ID of the transit router VPN attachment"
  value       = one(alicloud_cen_transit_router_route_table_propagation.this[*].id)
}

output "tr_vpn_route_table_association_id" {
  description = "The ID of the transit router VPN attachment"
  value       = one(alicloud_cen_transit_router_route_table_association.this[*].id)
}
