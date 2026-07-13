## Networking Module

Today I learned:

- What a VPC is
- Why cloud resources need a private network
- How Terraform resources are structured
- Why modules improve organization and reusability
- How CIDR blocks define IP address ranges

## VPC deployment milestone

I successfully deployed the first AWS resource in the secure landing zone.

### Resource created

- VPC name: `secure-landing-zone-dev-vpc`
- CIDR range: `10.0.0.0/16`
- Managed through the reusable networking Terraform module

### Commands used

- `terraform plan -out=tfplan`
- `terraform apply tfplan`
- `terraform state list`
- `terraform output`
- `aws ec2 describe-vpcs`

### What I learned

- A Terraform plan previews infrastructure changes before deployment.
- Terraform state records which AWS resources Terraform manages.
- Terraform outputs expose important resource information such as the VPC ID.
- AWS resources should be verified through both Terraform and AWS.