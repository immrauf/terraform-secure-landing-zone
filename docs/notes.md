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

## Security-group milestone

I created a reusable Terraform security module containing separate security groups for the load-balancer, application, and database tiers.

### Traffic paths

- Internet to load balancer: HTTPS 443
- Load balancer to application: TCP 8080
- Application to database: PostgreSQL 5432
- Application outbound: HTTPS 443

### Key lesson

Security groups are stateful and operate at the resource level. Referencing another security group provides a more targeted access rule than allowing an entire subnet or VPC CIDR range.

## VPC Flow Logs milestone

I enabled VPC-level network-traffic logging using Terraform.

### Components created

- CloudWatch Logs log group
- Dedicated IAM service role
- Least-privilege CloudWatch Logs publishing policy
- VPC Flow Log capturing accepted and rejected traffic
- Thirty-day log retention

### Key lessons

- VPC Flow Logs record traffic metadata rather than packet contents.
- A service role allows VPC Flow Logs to publish records to CloudWatch.
- ACCEPT records show permitted traffic.
- REJECT records can help identify blocked or suspicious traffic.
- Flow-log delivery can take time, and traffic must occur before records appear.