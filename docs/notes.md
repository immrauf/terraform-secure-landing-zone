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

## KMS encryption milestone

I created a customer-managed AWS KMS key and connected it to the landing zone's security logging services.

### Resources protected

- CloudTrail S3 bucket
- CloudTrail CloudWatch log group
- VPC Flow Logs CloudWatch log group

### Key lessons

- A KMS key policy controls which identities and AWS services may use a key.
- CloudTrail requires permission to generate data keys for log encryption.
- CloudWatch Logs requires encryption and decryption permissions.
- Encryption-context conditions reduce the risk of the key being used by unintended resources.
- Historical encrypted data continues to depend on the KMS key.

## GuardDuty milestone

I enabled Amazon GuardDuty using a reusable Terraform module.

### Features enabled

- Core GuardDuty detector
- S3 Protection
- RDS Protection
- Fifteen-minute finding update publishing

### Key lessons

- GuardDuty is enabled per AWS account and Region.
- A Region can have only one GuardDuty detector for an account.
- GuardDuty creates findings but does not automatically remediate every threat.
- Sample findings can safely test alerting workflows.
- Additional protection features should be enabled when relevant workloads exist.

## Security Hub milestone

I enabled AWS Security Hub CSPM and explicitly subscribed to two security standards.

### Standards enabled

- AWS Foundational Security Best Practices v1.0.0
- CIS AWS Foundations Benchmark v5.0.0

### Key lessons

- Security Hub centralizes findings and security-control results.
- Security standards consist of multiple security controls.
- Security scores require time and completed control evaluations.
- Many controls depend on AWS Config.
- Terraform can explicitly manage standards and versions instead of relying on default subscriptions.