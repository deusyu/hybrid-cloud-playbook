# GCP ‑ Simple VM Example

使用 Terraform 在 Google Cloud 上创建最基础的 Compute Engine 虚拟机实例。

## 先决条件

1. 已安装 [Terraform](https://www.terraform.io/downloads.html) ≥ 1.0
2. 已安装 [gcloud CLI](https://cloud.google.com/sdk/docs/install)
3. 已使用 `gcloud auth application-default login` 完成认证
4. 已设置缺省项目：`gcloud config set project <PROJECT_ID>`

## 使用方法

```bash
cd terraform/examples/gcp/simple-vm
terraform init
terraform plan -var="project=<PROJECT_ID>"
terraform apply -var="project=<PROJECT_ID>"
```

## 输出

- `instance_name` – 实例名称
- `instance_self_link` – 实例 Self-Link URL

> **注意** 部署完毕后请执行 `terraform destroy` 以避免产生额外成本。