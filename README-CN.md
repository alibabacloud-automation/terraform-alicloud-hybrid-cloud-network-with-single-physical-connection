Terraform module use Dedicated line & VPN to build hybrid cloud/multi-cloud network for Alibaba Cloud

terraform-alicloud-hybrid-cloud-network-with-single-physical-connection
======================================

[English](https://github.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network-with-single-physical-connection/blob/main/README.md) | 简体中文

本模块重点介绍当存在云上云下业务协同或多云协同场景，且业务为非核心业务或预算有限时，可以考虑使用VPN（IPsec隧道）作为物理专线的备份线路。整体方案如下：  
- 物理专线+VPN主备：物理专线为主用，当专线故障后切换到备用的VPN，节省混合云/多云互通成本。
- ECR网关：基于全动态路由和底层分布式设计，可以提升路由管理效率、缩短专线到可用区AZ的时延和提升Region接入TR专线的总带宽能力。
- TR实现ECR/VPN和VPC间的有效隔离和按需互通。
- IDC/三方云和阿里云间采用BGP+BFD互联。

架构图:

![diagram](https://raw.githubusercontent.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network/main/scripts/diagram.png)


## 用法


```hcl
provider "alicloud" {
  region = "cn-hangzhou"
}

data "alicloud_express_connect_physical_connections" "example" {
  name_regex = "^preserved-NODELETING"
}

module "complete" {
  source = "alibabacloud-automation/hybrid-cloud-network-with-single-physical-connection/alicloud"

  # CEN Instance
  create_cen_instance = true

  # TR
  create_cen_transit_router = true

  # VBR
  create_vbr_resources = true
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
  create_vpn_resources = true
  vpn_config = [{
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


  # VPC
  create_vpc_resources = true
  vpc_config = [{
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
```


## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-hybrid-cloud-network-with-single-physical-connection/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vbr"></a> [vbr](#module\_vbr) | ./modules/vbr | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | ./modules/vpn | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_cen_instance.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_instance) | resource |
| [alicloud_cen_transit_router.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router) | resource |
| [alicloud_cen_transit_router_ecr_attachment.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_ecr_attachment) | resource |
| [alicloud_cen_transit_router_route_table_association.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_express_connect_router_express_connect_router.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/express_connect_router_express_connect_router) | resource |
| [alicloud_express_connect_router_tr_association.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/express_connect_router_tr_association) | resource |
| [alicloud_account.current](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/account) | data source |
| [alicloud_cen_transit_router_route_tables.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/cen_transit_router_route_tables) | data source |
| [alicloud_regions.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cen_instance_config"></a> [cen\_instance\_config](#input\_cen\_instance\_config) | The parameters of cen instance. | <pre>object({<br>    cen_instance_name = optional(string, null)<br>    protection_level  = optional(string, "REDUCED")<br>    description       = optional(string, null)<br>    tags              = optional(map(string), {})<br>  })</pre> | `{}` | no |
| <a name="input_cen_instance_id"></a> [cen\_instance\_id](#input\_cen\_instance\_id) | The id of an exsiting cen instance. | `string` | `null` | no |
| <a name="input_cen_transit_router_id"></a> [cen\_transit\_router\_id](#input\_cen\_transit\_router\_id) | The transit router id of an existing transit router. | `string` | `null` | no |
| <a name="input_create_cen_instance"></a> [create\_cen\_instance](#input\_create\_cen\_instance) | Whether to create cen instance. If false, you can specify an existing cen instance by setting 'cen\_instance\_id'. Default to 'true' | `bool` | `true` | no |
| <a name="input_create_cen_transit_router"></a> [create\_cen\_transit\_router](#input\_create\_cen\_transit\_router) | Whether to create transit router. If false, you can specify an existing transit router by setting 'cen\_transit\_router\_id'. Default to 'true' | `bool` | `true` | no |
| <a name="input_create_vbr_resources"></a> [create\_vbr\_resources](#input\_create\_vbr\_resources) | Whether to create vbr resources. Default to 'true' | `bool` | `true` | no |
| <a name="input_create_vpc_resources"></a> [create\_vpc\_resources](#input\_create\_vpc\_resources) | Whether to create vpc resources. Default to 'true' | `bool` | `true` | no |
| <a name="input_create_vpn_resources"></a> [create\_vpn\_resources](#input\_create\_vpn\_resources) | Whether to create VPN resources. Default to 'true' | `bool` | `true` | no |
| <a name="input_tr_config"></a> [tr\_config](#input\_tr\_config) | The parameters of transit router. | <pre>object({<br>    transit_router_name        = optional(string, null)<br>    transit_router_description = optional(string, null)<br>    support_multicast          = optional(string, null)<br>    tags                       = optional(map(string), {})<br>  })</pre> | `{}` | no |
| <a name="input_vbr_config"></a> [vbr\_config](#input\_vbr\_config) | The list parameters of vbr resources. The attributes 'ecr\_config', 'vbrs' are required. | <pre>object({<br>    ecr_config = object({<br>      alibaba_side_asn = number<br>      ecr_name         = optional(string, null)<br>      ecr_description  = optional(string, null)<br>    })<br>    tr_ecr_attachment = optional(object({<br>      transit_router_ecr_attachment_name        = optional(string, null)<br>      transit_router_ecr_attachment_description = optional(string, null)<br>      route_table_propagation_enabled           = optional(bool, true)<br>      route_table_association_enabled           = optional(bool, true)<br>    }), {})<br>    vbrs = list(object({<br>      vbr = object({<br>        physical_connection_id            = string<br>        vlan_id                           = number<br>        local_gateway_ip                  = string<br>        peer_gateway_ip                   = string<br>        peering_subnet_mask               = string<br>        virtual_border_router_name        = optional(string, null)<br>        virtual_border_router_description = optional(string, null)<br>      })<br>      vbr_bgp_group = object({<br>        peer_asn       = string<br>        auth_key       = optional(string, null)<br>        bgp_group_name = optional(string, null)<br>        description    = optional(string, null)<br>        is_fake_asn    = optional(bool, false)<br>      })<br>      vbr_bgp_peer = optional(object({<br>        bfd_multi_hop   = optional(number, 255)<br>        enable_bfd      = optional(bool, "false")<br>        ip_version      = optional(string, "IPV4")<br>        peer_ip_address = optional(string, null)<br>      }), {})<br>    }))<br>  })</pre> | <pre>{<br>  "ecr_config": {<br>    "alibaba_side_asn": null<br>  },<br>  "vbrs": []<br>}</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | The parameters of vpc resources. The attributes 'vpc', 'vswitches' are required. | <pre>list(object({<br>    vpc = map(string)<br>    vswitches = list(object({<br>      zone_id      = string<br>      cidr_block   = string<br>      vswitch_name = optional(string, null)<br>    }))<br>    tr_vpc_attachment = optional(object({<br>      transit_router_attachment_name  = optional(string, null)<br>      auto_publish_route_enabled      = optional(bool, true)<br>      route_table_propagation_enabled = optional(bool, true)<br>      route_table_association_enabled = optional(bool, true)<br>    }), {})<br>  }))</pre> | `[]` | no |
| <a name="input_vpn_config"></a> [vpn\_config](#input\_vpn\_config) | The parameters of VPN resources. | <pre>list(object({<br>    vpn_customer_gateway = object({<br>      ip_address            = string<br>      customer_gateway_name = optional(string, null)<br>      asn                   = optional(string, null)<br>    })<br>    vpn_attachment = object({<br>      local_subnet        = string<br>      remote_subnet       = string<br>      vpn_attachment_name = optional(string, null)<br>      network_type        = optional(string, "public")<br>      effect_immediately  = optional(bool, false)<br>      ike_config = optional(list(object({<br>        ike_auth_alg = optional(string, "sha1")<br>        ike_enc_alg  = optional(string, "aes")<br>        ike_version  = optional(string, "ikev2")<br>        ike_mode     = optional(string, "main")<br>        ike_lifetime = optional(number, 86400)<br>        psk          = optional(string, null)<br>        ike_pfs      = optional(string, "group2")<br>      })), [{}])<br>      ipsec_config = optional(list(object({<br>        ipsec_pfs      = optional(string, "group2")<br>        ipsec_enc_alg  = optional(string, "aes")<br>        ipsec_auth_alg = optional(string, "sha1")<br>        ipsec_lifetime = optional(number, 86400)<br>      })), [{}])<br>      bgp_config = optional(list(object({<br>        enable       = optional(bool, true)<br>        local_asn    = optional(number, 45104)<br>        tunnel_cidr  = optional(string, "169.254.10.0/30")<br>        local_bgp_ip = optional(string, "169.254.10.1")<br>      })), [{}])<br>    })<br>    tr_vpn_attachment = object({<br>      tr_cidr                         = string<br>      publish_cidr_route              = optional(bool, true)<br>      zone_id                         = string<br>      transit_router_attachment_name  = optional(string, null)<br>      auto_publish_route_enabled      = optional(bool, true)<br>      route_table_propagation_enabled = optional(bool, true)<br>      route_table_association_enabled = optional(bool, true)<br>    })<br>  }))</pre> | `[]` | no |

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

## 提交问题

如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

## 作者

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## 许可

MIT Licensed. See LICENSE for full details.

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
