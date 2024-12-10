provider "alicloud" {
  region = "cn-hangzhou"
}

data "alicloud_express_connect_physical_connections" "example" {
  name_regex = "^preserved-NODELETING"
}

module "complete" {
  source = "../.."

  # CEN Instance
  create_cen_instance = var.create_cen_instance

  # TR
  create_cen_transit_router = var.create_cen_transit_router

  # VBR
  create_vbr_resources = var.create_vbr_resources
  vbr_config = {
    ecr_config = {
      alibaba_side_asn = 65534
    }
    vbrs = [
      {
        vbr = {
          physical_connection_id     = data.alicloud_express_connect_physical_connections.example.connections[0].id
          vlan_id                    = 108
          local_gateway_ip           = "192.168.0.1"
          peer_gateway_ip            = "192.168.0.2"
          peering_subnet_mask        = "255.255.255.252"
          virtual_border_router_name = "vbr_1_name"
          description                = "vbr_1_description"
        },
        vbr_bgp_group = {
          bgp_group_name = "bgp_1"
          description    = "VPC-idc"
          peer_asn       = 45000
          is_fake_asn    = false
        },
        vbr_bgp_peer = {
          bfd_multi_hop   = "10"
          enable_bfd      = true
          ip_version      = "IPV4"
          peer_ip_address = "1.1.1.1"
        }
    }]
  }

  # VPN
  create_vpn_resources = var.create_vpn_resources
  vpn_config           = var.vpn_config


  # VPC
  create_vpc_resources = var.create_vpc_resources
  vpc_config           = var.vpc_config

}
