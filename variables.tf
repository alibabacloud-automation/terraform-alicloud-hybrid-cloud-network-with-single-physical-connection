
# CEN
variable "create_cen_instance" {
  description = "Whether to create cen instance. If false, you can specify an existing cen instance by setting 'cen_instance_id'. Default to 'true'"
  type        = bool
  default     = true
}

variable "cen_instance_id" {
  description = "The id of an exsiting cen instance."
  type        = string
  default     = null
}

variable "cen_instance_config" {
  description = "The parameters of cen instance."
  type = object({
    cen_instance_name = optional(string, null)
    protection_level  = optional(string, "REDUCED")
    description       = optional(string, null)
    tags              = optional(map(string), {})
  })
  default = {}
}


# TR
variable "create_cen_transit_router" {
  description = "Whether to create transit router. If false, you can specify an existing transit router by setting 'cen_transit_router_id'. Default to 'true'"
  type        = bool
  default     = true
}

variable "cen_transit_router_id" {
  description = "The transit router id of an existing transit router."
  type        = string
  default     = null
}

variable "tr_config" {
  description = "The parameters of transit router."
  type = object({
    transit_router_name        = optional(string, null)
    transit_router_description = optional(string, null)
    support_multicast          = optional(string, null)
    tags                       = optional(map(string), {})
  })
  default = {}
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
  default = []
}


# VBR
variable "create_vbr_resources" {
  description = "Whether to create vbr resources. Default to 'true'"
  type        = bool
  default     = true
}

variable "vbr_config" {
  description = "The list parameters of vbr resources. The attributes 'ecr_config', 'vbrs' are required."
  type = object({
    ecr_config = object({
      alibaba_side_asn = number
      ecr_name         = optional(string, null)
      ecr_description  = optional(string, null)
    })
    tr_ecr_attachment = optional(object({
      transit_router_ecr_attachment_name        = optional(string, null)
      transit_router_ecr_attachment_description = optional(string, null)
      route_table_propagation_enabled           = optional(bool, true)
      route_table_association_enabled           = optional(bool, true)
    }), {})
    vbrs = list(object({
      vbr = object({
        physical_connection_id            = string
        vlan_id                           = number
        local_gateway_ip                  = string
        peer_gateway_ip                   = string
        peering_subnet_mask               = string
        virtual_border_router_name        = optional(string, null)
        virtual_border_router_description = optional(string, null)
      })
      vbr_bgp_group = object({
        peer_asn       = string
        auth_key       = optional(string, null)
        bgp_group_name = optional(string, null)
        description    = optional(string, null)
        is_fake_asn    = optional(bool, false)
      })
      vbr_bgp_peer = optional(object({
        bfd_multi_hop   = optional(number, 255)
        enable_bfd      = optional(bool, "false")
        ip_version      = optional(string, "IPV4")
        peer_ip_address = optional(string, null)
      }), {})
    }))
  })
  default = {
    ecr_config = {
      alibaba_side_asn = null
    }
    vbrs = []
  }
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

  default = []
}
