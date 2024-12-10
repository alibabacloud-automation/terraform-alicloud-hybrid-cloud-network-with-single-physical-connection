
resource "alicloud_vpn_customer_gateway" "this" {
  ip_address            = var.vpn_customer_gateway.ip_address
  asn                   = var.vpn_customer_gateway.asn
  customer_gateway_name = var.vpn_customer_gateway.customer_gateway_name
}

resource "alicloud_vpn_gateway_vpn_attachment" "this" {
  customer_gateway_id = alicloud_vpn_customer_gateway.this.id
  vpn_attachment_name = var.vpn_attachment.vpn_attachment_name
  network_type        = var.vpn_attachment.network_type
  local_subnet        = var.vpn_attachment.local_subnet
  remote_subnet       = var.vpn_attachment.remote_subnet
  effect_immediately  = var.vpn_attachment.effect_immediately

  dynamic "ike_config" {
    for_each = var.vpn_attachment.ike_config
    content {
      ike_auth_alg = ike_config.value.ike_auth_alg
      ike_enc_alg  = ike_config.value.ike_enc_alg
      ike_version  = ike_config.value.ike_version
      ike_mode     = ike_config.value.ike_mode
      ike_lifetime = ike_config.value.ike_lifetime
      psk          = ike_config.value.psk
      ike_pfs      = ike_config.value.ike_pfs
    }
  }

  dynamic "ipsec_config" {
    for_each = var.vpn_attachment.ipsec_config
    content {
      ipsec_pfs      = ipsec_config.value.ipsec_pfs
      ipsec_enc_alg  = ipsec_config.value.ipsec_enc_alg
      ipsec_auth_alg = ipsec_config.value.ipsec_auth_alg
      ipsec_lifetime = ipsec_config.value.ipsec_lifetime
    }
  }

  dynamic "bgp_config" {
    for_each = var.vpn_attachment.bgp_config
    content {
      enable       = bgp_config.value.enable
      local_asn    = bgp_config.value.local_asn
      tunnel_cidr  = bgp_config.value.tunnel_cidr
      local_bgp_ip = bgp_config.value.local_bgp_ip
    }
  }
}

resource "alicloud_cen_transit_router_cidr" "this" {
  transit_router_id  = var.cen_transit_router_id
  cidr               = var.tr_vpn_attachment.tr_cidr
  publish_cidr_route = var.tr_vpn_attachment.publish_cidr_route
}

resource "alicloud_cen_transit_router_vpn_attachment" "this" {
  cen_id                     = var.cen_instance_id
  transit_router_id          = alicloud_cen_transit_router_cidr.this.transit_router_id
  vpn_id                     = alicloud_vpn_gateway_vpn_attachment.this.id
  auto_publish_route_enabled = var.tr_vpn_attachment.auto_publish_route_enabled
  zone {
    zone_id = var.tr_vpn_attachment.zone_id
  }
}

data "alicloud_cen_transit_router_route_tables" "this" {
  transit_router_id               = var.cen_transit_router_id
  transit_router_route_table_type = "System"
}

resource "alicloud_cen_transit_router_route_table_association" "this" {
  count = var.tr_vpn_attachment.route_table_association_enabled ? 1 : 0

  transit_router_route_table_id = data.alicloud_cen_transit_router_route_tables.this.tables[0].transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_vpn_attachment.this.id
}

resource "alicloud_cen_transit_router_route_table_propagation" "this" {
  count = var.tr_vpn_attachment.route_table_propagation_enabled ? 1 : 0

  transit_router_route_table_id = data.alicloud_cen_transit_router_route_tables.this.tables[0].transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_vpn_attachment.this.id
}


