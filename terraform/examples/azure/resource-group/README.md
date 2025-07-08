# Azure ‑ Resource Group Example

本示例展示如何使用 Terraform 在 Azure 中创建最基本的 `Resource Group`。

## 先决条件

1. 已安装 [Terraform](https://www.terraform.io/downloads.html) ≥ 1.0
2. 已安装 [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
3. 已使用 `az login` 登录并选择订阅

## 使用方法

```bash
cd terraform/examples/azure/resource-group
terraform init
terraform plan
terraform apply
```

## 输出

- `resource_group_name` – 创建完成的资源组名称

> **提醒** 使用完毕后请执行 `terraform destroy` 以避免产生不必要的云费用。