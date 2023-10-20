# K8s Locust Terraform Module

## Overview

This module installs the [Opencost](https://www.opencost.io/) [Helm chart](https://github.com/opencost/opencost-helm-chart) onto a _Kubernetes_ cluster that has been created by the [AWS-EKS terraform module](https://github.com/LexisNexis-RBA/rsg-terraform-aws-eks) or the [AKS terraform module](https://github.com/LexisNexis-RBA/terraform-azurerm-aks)

### Example

#### AWS

```terraform
module "opencost" {
  source = "git::https://gitlab.b2b.regn.net/terraform/modules/kubernetes/terraform-lnrs-helm-opencost.git?ref=v1.0.0-rc.1"
  
  release_name                = "opencost"
  namespace                   = "opencost"

  cloud                       = "aws"
  cluster_name                = "iob-eks-1"

  enable_ui                   = true
  ingress_hostname            = "opencost-eks-1.iob.eu-west-1.dsg.lnrsg.io"
  thanos_enabled              = true
}
```

#### Azure

```terraform
module "opencost" {
  source = "git::https://gitlab.b2b.regn.net/terraform/modules/kubernetes/terraform-lnrs-helm-opencost.git?ref=v1.0.0-rc.1"
  
  release_name                = "opencost"
  namespace                   = "opencost"

  cloud                       = "azure"
  cluster_name                = "iob-eks-1"

  enable_ui                   = true
  ingress_hostname            = "opencost-aks-1.test.iob.azure.lnrsg.io"
  thanos_enabled              = true
}
```

## Requirements

This module requires the following versions to be configured in the workspace `terraform {}` block.

### Terraform

| **Version** |
| :---------- |
| `>= 1.3.3, != 1.3.4` |

### Providers

| **Name**                                                                                | **Version** |
| :-------------------------------------------------------------------------------------- | :---------- |
| [Helm](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/)             | `>= 2.9.0`  |
| [kubectl](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/)     | `>= 1.14.0` |
| [kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/) | `>= 2.23.0`  |

## Variables

This module exposes the following variables.

| Name | Variable | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | The account ID. | `string` | n/a | yes |
| <a name="input_cloud"></a> [cloud](#input\_cloud) | Cloud that this will be run on. AWS and Azure are currently supported. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster that has been created. | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | The OIDC issuer url for the cluster. | `string` | n/a | yes |
| <a name="input_enable_ui"></a> [enable\_ui](#input\_enable\_ui) | Enable UI. | `bool` | `true` | no |
| <a name="input_ingress_annotations"></a> [ingress\_annotations](#input\_ingress\_annotations) | The annotations for ingress resources. | `map(string)` | `{}` | no |
| <a name="input_ingress_hostname"></a> [ingress\_hostname](#input\_ingress\_hostname) | Ingress hostname. | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace to create and install into. | `string` | n/a | yes |
| <a name="input_partition"></a> [partition](#input\_partition) | AWS partition. | `string` | `"aws"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Name of the release. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_thanos_enabled"></a> [thanos\_enabled](#input\_thanos\_enabled) | Thanos enabled. | `bool` | `true` | no |

## Outputs

| **Variable** | **Description** | **Type** |
| :----------- | :-------------- | :------- |
