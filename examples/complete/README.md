
# Complete

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | 1.236.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_complete"></a> [complete](#module\_complete) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_express_connect_physical_connections.example](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/express_connect_physical_connections) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_cen_instance"></a> [create\_cen\_instance](#input\_create\_cen\_instance) | Whether to create cen instance. If false, you can specify an existing cen instance by setting 'cen\_instance\_id'. Default to 'true' | `bool` | `true` | no |
| <a name="input_create_cen_transit_router"></a> [create\_cen\_transit\_router](#input\_create\_cen\_transit\_router) | Whether to create transit router. If false, you can specify an existing transit router by setting 'cen\_transit\_router\_id'. Default to 'true' | `bool` | `true` | no |
| <a name="input_create_vbr_resources"></a> [create\_vbr\_resources](#input\_create\_vbr\_resources) | Whether to create vbr resources. Default to 'true' | `bool` | `true` | no |
| <a name="input_create_vpc_resources"></a> [create\_vpc\_resources](#input\_create\_vpc\_resources) | Whether to create vpc resources. Default to 'true' | `bool` | `true` | no |
| <a name="input_create_vpn_resources"></a> [create\_vpn\_resources](#input\_create\_vpn\_resources) | Whether to create VPN resources. Default to 'true' | `bool` | `true` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | The parameters of vpc resources. The attributes 'vpc', 'vswitches' are required. | <pre>list(object({<br>    vpc = map(string)<br>    vswitches = list(object({<br>      zone_id      = string<br>      cidr_block   = string<br>      vswitch_name = optional(string, null)<br>    }))<br>    tr_vpc_attachment = optional(object({<br>      transit_router_attachment_name  = optional(string, null)<br>      auto_publish_route_enabled      = optional(bool, true)<br>      route_table_propagation_enabled = optional(bool, true)<br>      route_table_association_enabled = optional(bool, true)<br>    }), {})<br>  }))</pre> | <pre>[<br>  {<br>    "tr_vpc_attachment": {<br>      "transit_router_attachment_name": "tr_attachment_name"<br>    },<br>    "vpc": {<br>      "cidr_block": "10.0.0.0/16"<br>    },<br>    "vswitches": [<br>      {<br>        "cidr_block": "10.0.1.0/24",<br>        "vswitch_name": "vswitch_1",<br>        "zone_id": "cn-hangzhou-i"<br>      },<br>      {<br>        "cidr_block": "10.0.2.0/24",<br>        "vswitch_name": "vswitch_2",<br>        "zone_id": "cn-hangzhou-j"<br>      }<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_vpn_config"></a> [vpn\_config](#input\_vpn\_config) | The parameters of VPN resources. | <pre>list(object({<br>    vpn_customer_gateway = object({<br>      ip_address            = string<br>      customer_gateway_name = optional(string, null)<br>      asn                   = optional(string, null)<br>    })<br>    vpn_attachment = object({<br>      local_subnet        = string<br>      remote_subnet       = string<br>      vpn_attachment_name = optional(string, null)<br>      network_type        = optional(string, "public")<br>      effect_immediately  = optional(bool, false)<br>      ike_config = optional(list(object({<br>        ike_auth_alg = optional(string, "sha1")<br>        ike_enc_alg  = optional(string, "aes")<br>        ike_version  = optional(string, "ikev2")<br>        ike_mode     = optional(string, "main")<br>        ike_lifetime = optional(number, 86400)<br>        psk          = optional(string, null)<br>        ike_pfs      = optional(string, "group2")<br>      })), [{}])<br>      ipsec_config = optional(list(object({<br>        ipsec_pfs      = optional(string, "group2")<br>        ipsec_enc_alg  = optional(string, "aes")<br>        ipsec_auth_alg = optional(string, "sha1")<br>        ipsec_lifetime = optional(number, 86400)<br>      })), [{}])<br>      bgp_config = optional(list(object({<br>        enable       = optional(bool, true)<br>        local_asn    = optional(number, 45104)<br>        tunnel_cidr  = optional(string, "169.254.10.0/30")<br>        local_bgp_ip = optional(string, "169.254.10.1")<br>      })), [{}])<br>    })<br>    tr_vpn_attachment = object({<br>      tr_cidr                         = string<br>      publish_cidr_route              = optional(bool, true)<br>      zone_id                         = string<br>      transit_router_attachment_name  = optional(string, null)<br>      auto_publish_route_enabled      = optional(bool, true)<br>      route_table_propagation_enabled = optional(bool, true)<br>      route_table_association_enabled = optional(bool, true)<br>    })<br>  }))</pre> | <pre>[<br>  {<br>    "tr_vpn_attachment": {<br>      "tr_cidr": "192.168.0.0/16",<br>      "zone_id": "cn-hangzhou-i"<br>    },<br>    "vpn_attachment": {<br>      "local_subnet": "0.0.0.0/0",<br>      "remote_subnet": "0.0.0.0/0"<br>    },<br>    "vpn_customer_gateway": {<br>      "asn": "45014",<br>      "ip_address": "42.104.22.210"<br>    }<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bgp_group_id"></a> [bgp\_group\_id](#output\_bgp\_group\_id) | The id of BGP group. |
| <a name="output_bgp_peer_id"></a> [bgp\_peer\_id](#output\_bgp\_peer\_id) | The id of BGP peer. |
| <a name="output_cen_instance_id"></a> [cen\_instance\_id](#output\_cen\_instance\_id) | The id of CEN instance. |
| <a name="output_cen_transit_router_id"></a> [cen\_transit\_router\_id](#output\_cen\_transit\_router\_id) | The id of CEN transit router. |
| <a name="output_ecr_vbr_child_instance_id"></a> [ecr\_vbr\_child\_instance\_id](#output\_ecr\_vbr\_child\_instance\_id) | The id of ECR VBR child instance. |
| <a name="output_express_connect_router_id"></a> [express\_connect\_router\_id](#output\_express\_connect\_router\_id) | The id of Express Connect Router. |
| <a name="output_tr_cidr_id"></a> [tr\_cidr\_id](#output\_tr\_cidr\_id) | The cidr id of the transit router |
| <a name="output_tr_ecr_attachment_id"></a> [tr\_ecr\_attachment\_id](#output\_tr\_ecr\_attachment\_id) | The attachment id between TR and ECR. |
| <a name="output_tr_vbr_route_table_association_id"></a> [tr\_vbr\_route\_table\_association\_id](#output\_tr\_vbr\_route\_table\_association\_id) | The id of route table association bewteen TR and VBR. |
| <a name="output_tr_vbr_route_table_propagation_id"></a> [tr\_vbr\_route\_table\_propagation\_id](#output\_tr\_vbr\_route\_table\_propagation\_id) | The id of route table propagation bewteen TR and VBR. |
| <a name="output_tr_vpc_attachment_id"></a> [tr\_vpc\_attachment\_id](#output\_tr\_vpc\_attachment\_id) | The id of attachment between TR and VPC. |
| <a name="output_tr_vpc_route_table_association_id"></a> [tr\_vpc\_route\_table\_association\_id](#output\_tr\_vpc\_route\_table\_association\_id) | The id of route table association bewteen TR and VPC. |
| <a name="output_tr_vpc_route_table_propagation_id"></a> [tr\_vpc\_route\_table\_propagation\_id](#output\_tr\_vpc\_route\_table\_propagation\_id) | The id of route table propagation bewteen TR and VPC. |
| <a name="output_tr_vpn_route_table_association_id"></a> [tr\_vpn\_route\_table\_association\_id](#output\_tr\_vpn\_route\_table\_association\_id) | The ID of the transit router VPN attachment |
| <a name="output_tr_vpn_route_table_propagation_id"></a> [tr\_vpn\_route\_table\_propagation\_id](#output\_tr\_vpn\_route\_table\_propagation\_id) | The ID of the transit router VPN attachment |
| <a name="output_vbr_id"></a> [vbr\_id](#output\_vbr\_id) | The ids of VBR. |
| <a name="output_vbr_route_table_id"></a> [vbr\_route\_table\_id](#output\_vbr\_route\_table\_id) | The route table id of VBR. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ids of vpc. |
| <a name="output_vpc_route_table_id"></a> [vpc\_route\_table\_id](#output\_vpc\_route\_table\_id) | The route table id of vpc. |
| <a name="output_vpn_customer_gateway_id"></a> [vpn\_customer\_gateway\_id](#output\_vpn\_customer\_gateway\_id) | The ID of the VPN Customer Gateway |
| <a name="output_vpn_gateway_vpn_attachment_id"></a> [vpn\_gateway\_vpn\_attachment\_id](#output\_vpn\_gateway\_vpn\_attachment\_id) | The ID of the VPN Gateway VPN Attachment |
| <a name="output_vswitch_ids"></a> [vswitch\_ids](#output\_vswitch\_ids) | The ids of vswitches. |
<!-- END_TF_DOCS -->