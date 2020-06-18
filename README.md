## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.6 |
| aws | >= 2.60.0 |
| azurerm | >= 2.0 |
| google | >= 3.21 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.60.0 |
| azurerm | >= 2.0 |
| google | >= 3.21 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud | Multi-Cloud: Cloud to deploy in (Azure, AWS or GCP) | `string` | n/a | yes |
| cloud\_location | Multi-Cloud: Mapping of cloud regions for multi-cloud. | `map` | n/a | yes |
| environment | Common: Environment name | `string` | n/a | yes |
| gcp\_project | GCP: Google Cloud Platform project name | `string` | n/a | yes |
| instance\_size | Common: HAProxy instance size | `string` | n/a | yes |
| location | Multi-Cloud: Abstract location name | `string` | n/a | yes |
| name | Common: Resources name | `string` | n/a | yes |
| resource\_group\_name | Azure: The name of an existing resource group to be imported. | `string` | n/a | yes |
| subnet\_id | Common: Subnet ID HAProxy deployment | `string` | n/a | yes |
| tags | Common: Mapping of tags being associated with the resources | `map(string)` | n/a | yes |
| vpc\_id | Common: VPC ID HAProxy deployment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| public\_ip\_address | The actual ip address allocated for the resource. |

