# CEN
variable "cen_instance_id" {
  description = "The id of cen instance."
  type        = string
  default     = null
}


# TR
variable "cen_transit_router_id" {
  description = "The id of cen transit router."
  type        = string
  default     = null
}


# VPN
variable "vpn_customer_gateway" {
  description = "The parameters of the VPN customer gateway."
  type = object({
    ip_address            = string
    customer_gateway_name = optional(string, null)
    asn                   = optional(string, null)
  })
  default = {
    ip_address = null
  }
}

variable "vpn_attachment" {
  description = "The parameters of the VPN attachment"
  type = object({
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
      psk          = optional(string, "tfvpnattachment")
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
  default = {
    local_subnet  = null
    remote_subnet = null
  }

  validation {
    condition     = length(var.vpn_attachment.ike_config) <= 1 && length(var.vpn_attachment.ipsec_config) <= 1 && length(var.vpn_attachment.bgp_config) <= 1
    error_message = "The number of ike_config, ipsec_config and bgp_config must be less than or equal to 1."
  }
}

variable "tr_vpn_attachment" {
  description = "The parameters of the attachment between TR and VPN."
  type = object({
    tr_cidr                         = string
    publish_cidr_route              = optional(bool, true)
    zone_id                         = string
    transit_router_attachment_name  = optional(string, null)
    auto_publish_route_enabled      = optional(bool, true)
    route_table_propagation_enabled = optional(bool, true)
    route_table_association_enabled = optional(bool, true)
  })
  default = {
    tr_cidr = null
    zone_id = null
  }
}
