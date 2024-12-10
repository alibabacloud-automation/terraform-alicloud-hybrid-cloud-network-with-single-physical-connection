
# CEN
variable "create_cen_instance" {
  description = "Whether to create cen instance. If false, you can specify an existing cen instance by setting 'cen_instance_id'. Default to 'true'"
  type        = bool
  default     = true
}



# TR
variable "create_cen_transit_router" {
  description = "Whether to create transit router. If false, you can specify an existing transit router by setting 'cen_transit_router_id'. Default to 'true'"
  type        = bool
  default     = true
}

# VPC
variable "create_vpc_resources" {
  description = "Whether to create vpc resources. Default to 'true'"
  type        = bool
  default     = true
}

variable "vpc_config" {
  description = "The parameters of vpc resources. The attributes 'vpc', 'vswitches' are required."
  type = list(object({
    vpc = map(string)
    vswitches = list(object({
      zone_id      = string
      cidr_block   = string
      vswitch_name = optional(string, null)
    }))
    tr_vpc_attachment = optional(object({
      transit_router_attachment_name  = optional(string, null)
      auto_publish_route_enabled      = optional(bool, true)
      route_table_propagation_enabled = optional(bool, true)
      route_table_association_enabled = optional(bool, true)
    }), {})
  }))
  default = [{
    vpc = {
      cidr_block = "10.0.0.0/16"
    },
    vswitches = [
      {
        zone_id      = "cn-hangzhou-i"
        cidr_block   = "10.0.1.0/24"
        vswitch_name = "vswitch_1"
      },
      {
        zone_id      = "cn-hangzhou-j"
        cidr_block   = "10.0.2.0/24"
        vswitch_name = "vswitch_2"
      }
    ],
    tr_vpc_attachment = {
      transit_router_attachment_name = "tr_attachment_name"
    },
  }]
}


# VBR
variable "create_vbr_resources" {
  description = "Whether to create vbr resources. Default to 'true'"
  type        = bool
  default     = true
}


# VPN
variable "create_vpn_resources" {
  description = "Whether to create VPN resources. Default to 'true'"
  type        = bool
  default     = true
}

variable "vpn_config" {
  description = "The parameters of VPN resources."
  type = list(object({
    vpn_customer_gateway = object({
      ip_address            = string
      customer_gateway_name = optional(string, null)
      asn                   = optional(string, null)
    })
    vpn_attachment = object({
      local_subnet        = string
      remote_subnet       = string
      vpn_attachment_name = optional(string, null)
      network_type        = optional(string, "public")
      effect_immediately  = optional(bool, false)
      ike_config = optional(list(object({
        ike_auth_alg = optional(string, "sha1")
        ike_enc_alg  = optional(string, "aes")
        ike_version  = optional(string, "ikev2")
        ike_mode     = optional(string, "main")
        ike_lifetime = optional(number, 86400)
        psk          = optional(string, null)
        ike_pfs      = optional(string, "group2")
      })), [{}])
      ipsec_config = optional(list(object({
        ipsec_pfs      = optional(string, "group2")
        ipsec_enc_alg  = optional(string, "aes")
        ipsec_auth_alg = optional(string, "sha1")
        ipsec_lifetime = optional(number, 86400)
      })), [{}])
      bgp_config = optional(list(object({
        enable       = optional(bool, true)
        local_asn    = optional(number, 45104)
        tunnel_cidr  = optional(string, "169.254.10.0/30")
        local_bgp_ip = optional(string, "169.254.10.1")
      })), [{}])
    })
    tr_vpn_attachment = object({
      tr_cidr                         = string
      publish_cidr_route              = optional(bool, true)
      zone_id                         = string
      transit_router_attachment_name  = optional(string, null)
      auto_publish_route_enabled      = optional(bool, true)
      route_table_propagation_enabled = optional(bool, true)
      route_table_association_enabled = optional(bool, true)
    })
  }))

  default = [{
    vpn_customer_gateway = {
      ip_address = "42.104.22.210"
      asn        = "45014"
    }
    vpn_attachment = {
      local_subnet  = "0.0.0.0/0"
      remote_subnet = "0.0.0.0/0"
    }
    tr_vpn_attachment = {
      tr_cidr = "192.168.0.0/16"
      zone_id = "cn-hangzhou-i"
    }
  }]
}
