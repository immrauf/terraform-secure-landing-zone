## Secure VPC foundation

### Business requirement

The organization needs a repeatable and isolated AWS network foundation for hosting future application and database resources.

### Decision

A dedicated VPC was created using Terraform with a `10.0.0.0/16` private CIDR range. DNS support and DNS hostnames were enabled to support internal service discovery and AWS-managed workloads.

### Business value

- Reduces configuration inconsistencies caused by manual provisioning.
- Establishes network isolation for future workloads.
- Provides sufficient address capacity for segmented public, application, and database subnets.
- Enables repeatable deployments across development, testing, and production environments.

## Public subnet internet routing

### Business requirement

The landing zone must support future internet-facing resources such as load balancers while preventing private application workloads from being directly exposed to the internet.

### Decision

An Internet Gateway was attached to the VPC. A dedicated public route table was created with a default IPv4 route of `0.0.0.0/0` pointing to the Internet Gateway.

Only the two public subnets were explicitly associated with the public route table. Private application subnets were not given a direct Internet Gateway route.

### Business value

- Supports future internet-facing services in controlled public network segments.
- Prevents private application subnets from receiving direct internet routing.
- Reduces accidental exposure caused by sharing route tables between public and private tiers.
- Provides repeatable and auditable network routing through Terraform.

## Private application outbound connectivity

### Business requirement

Private application workloads may need outbound access to retrieve operating-system updates, install software packages, and communicate with approved external services. They must not accept unsolicited inbound connections directly from the internet.

### Decision

A public NAT Gateway was deployed in public subnet A with a dedicated Elastic IP address. A private application route table sends internet-bound IPv4 traffic through the NAT Gateway.

Both private application subnets are associated with the private application route table.

A single NAT Gateway is used in the development environment to control portfolio-lab costs.

### Security value

- Application resources can remain in private subnets without public IPv4 addresses.
- Outbound traffic follows a controlled network path.
- Private application resources do not receive direct routes to the Internet Gateway.
- Public and private routing remain separated.

### Availability and cost tradeoff

A single NAT Gateway reduces development cost but creates an Availability Zone dependency. A production environment would normally evaluate deploying one NAT Gateway per Availability Zone.

NAT Gateway hourly and data-processing charges must be considered when selecting the production architecture.

## Isolated private database tier

### Business requirement

Sensitive database workloads must not be directly accessible from the internet and should not have unnecessary outbound internet connectivity.

The design must also support future highly available Amazon RDS deployments.

### Decision

Two private database subnets were deployed across two Availability Zones:

- `10.0.21.0/24`
- `10.0.22.0/24`

Automatic public IPv4 assignment is disabled.

A dedicated database route table was created with no default route to either the Internet Gateway or NAT Gateway. Only the VPC-local route is present.

An Amazon RDS DB subnet group was created using both database subnets.

### Security value

- Prevents direct internet routing for database workloads.
- Reduces the attack surface of the data tier.
- Separates application and database routing policies.
- Supports future database security-group rules that permit access only from the application tier.
- Provides a foundation for Multi-AZ RDS deployment.

### Business value

- Improves resilience by distributing database subnet capacity across two Availability Zones.
- Creates a repeatable and auditable database-network foundation.
- Reduces configuration errors associated with manually selecting database subnets.

## Layered security-group architecture

### Business requirement

Internet-facing, application, and database workloads must be separated so that compromise of one layer does not automatically provide unrestricted access to the remaining environment.

### Decision

Three security groups were created:

- Public load-balancer security group
- Private application security group
- Private database security group

The permitted traffic flow is:

1. The internet may reach the load-balancer tier only on TCP port 443.
2. The load-balancer tier may reach the application tier only on TCP port 8080.
3. The application tier may reach the PostgreSQL database tier only on TCP port 5432.
4. The application tier may initiate outbound HTTPS connections for updates and approved external services.
5. The database security group has no broad outbound rule.

Security-group references are used between tiers instead of broad VPC or subnet CIDR rules.

### Security value

- Prevents direct internet access to application and database workloads.
- Restricts lateral movement between architecture tiers.
- Prevents public exposure of the application and database ports.
- Provides stateful, resource-level network controls.
- Uses explicit security-group identity instead of broad network ranges.
- Avoids opening SSH or RDP access from the internet.

### Business value

- Creates a reusable least-privilege network-access pattern.
- Reduces the risk of accidental public exposure.
- Makes approved traffic paths auditable through Terraform.
- Supports future deployment of an Application Load Balancer, private compute resources, and Amazon RDS.

## Subnet-level Network ACL guardrails

### Business requirement

The landing zone needs an additional subnet-level control that can provide coarse traffic filtering and explicit deny-by-default behavior.

### Decision

Separate custom Network ACLs were created for:

- Public subnets
- Private application subnets
- Private database subnets

Security groups remain the primary resource-level traffic control. Network ACLs provide an additional stateless subnet-level guardrail.

The public tier permits HTTPS and required ephemeral return traffic. The application tier permits traffic from the public tier on the application port, outbound HTTPS, database access, and necessary return traffic. The database tier permits PostgreSQL traffic only from the application subnet ranges and response traffic back to application clients.

### Security value

- Adds subnet-level defense in depth.
- Prevents database subnets from receiving general internet access.
- Separates traffic policies by architecture tier.
- Provides explicit allow rules and implicit denial of unmatched traffic.
- Demonstrates the distinction between stateful security groups and stateless Network ACLs.

### Operational consideration

Network ACL rules require explicit inbound and outbound return paths. Incorrect ephemeral-port rules can interrupt valid application, database, load-balancer, or NAT Gateway traffic.

## VPC network-traffic logging

### Business requirement

Security and operations teams need visibility into network activity for troubleshooting, incident investigation, auditing, and detection of potentially unauthorized traffic.

### Decision

VPC Flow Logs were enabled at the VPC level and configured to capture both accepted and rejected traffic.

Flow-log records are delivered to a dedicated Amazon CloudWatch Logs log group with a 30-day retention period.

A dedicated IAM role and least-privilege permissions policy allow the VPC Flow Logs service to create log streams and publish log events only to the designated log group.

The IAM trust policy restricts role assumption using the AWS account ID and VPC Flow Log source ARN pattern.

### Security value

- Captures accepted and rejected network-traffic metadata.
- Supports investigation of blocked connections.
- Helps validate security-group and Network ACL behavior.
- Provides visibility into source addresses, destination addresses, ports, protocols, and traffic outcomes.
- Establishes a central location for future metric filters and alarms.
- Uses a dedicated service role rather than broad shared permissions.

### Business value

- Reduces time required to diagnose network-connectivity problems.
- Improves auditability of cloud-network activity.
- Supports incident-response investigations.
- Automatically removes older development logs after 30 days to control storage cost.

### Encryption

CloudWatch Logs encrypts log data at rest by default. A customer-managed AWS KMS key will be added during the dedicated encryption phase for greater administrative control.

## Centralized AWS API audit logging

### Business requirement

The organization needs a durable and searchable audit record of actions performed through the AWS Console, CLI, SDKs, APIs, IAM identities, and AWS services.

### Decision

A multi-Region CloudTrail trail was enabled to record read and write management events, including global AWS service events.

CloudTrail delivers records to:

- A dedicated private Amazon S3 bucket for durable retention
- A CloudWatch Logs log group for searches, monitoring, metric filters, and alerts

The S3 bucket uses:

- Public-access blocking
- Bucket-owner-enforced object ownership
- Versioning
- Default server-side encryption
- TLS-only access enforcement
- Lifecycle-based retention

CloudTrail log-file validation is enabled to support integrity verification.

A dedicated IAM role and least-privilege policy permit CloudTrail to publish events only to the designated CloudWatch log group.

### Security value

- Records administrative and API activity across enabled AWS Regions.
- Supports incident investigations and forensic review.
- Helps identify unauthorized or unexpected configuration changes.
- Provides digitally signed digest files for integrity checking.
- Prevents public access to retained audit logs.
- Creates the foundation for CloudWatch alarms on sensitive activity.

### Business value

- Improves accountability for cloud changes.
- Supports governance and compliance evidence collection.
- Reduces investigation time by centralizing account activity.
- Creates searchable near-real-time records and durable long-term archives.

### Future improvement

The S3 bucket and CloudWatch log group currently use AWS-managed encryption. A customer-managed KMS key will be introduced during the encryption phase.

## Customer-managed encryption for security logs

### Business requirement

Security and audit logs require controlled encryption at rest, auditable key usage, and centralized management of cryptographic permissions.

### Decision

A customer-managed symmetric AWS KMS key was created for security-log encryption.

The key protects:

- CloudTrail log files delivered to Amazon S3
- CloudTrail events delivered to CloudWatch Logs
- VPC Flow Logs delivered to CloudWatch Logs

Automatic key rotation is enabled. The key has a 30-day deletion window and a descriptive alias.

The KMS key policy:

- Grants key administration to the owning AWS account.
- Permits CloudTrail to generate data keys only for the designated trail.
- Restricts CloudTrail through the trail ARN and encryption context.
- Permits the regional CloudWatch Logs service to encrypt and decrypt log data.
- Restricts CloudWatch Logs through log-group encryption context.

### Security value

- Provides centralized control over security-log encryption.
- Produces CloudTrail records for KMS administrative and cryptographic operations.
- Restricts AWS service use of the key through service principals and encryption context.
- Enables key rotation without rebuilding the protected logging resources.
- Reduces reliance on service-managed encryption keys.

### Operational consideration

The KMS key must remain enabled and accessible for as long as encrypted logs are retained. Disabling or deleting the key can make historical log data unreadable.

Customer-managed KMS keys and cryptographic requests may incur AWS charges.

## Managed threat detection with Amazon GuardDuty

### Business requirement

The organization needs continuous detection of suspicious account activity, compromised credentials, malicious network behavior, and anomalous access to supported AWS data services.

### Decision

Amazon GuardDuty was enabled in the landing-zone Region through Terraform.

The following protection capabilities are explicitly enabled:

- S3 data-event monitoring
- RDS login-event monitoring

GuardDuty finding updates are published at fifteen-minute intervals.

Runtime Monitoring and Malware Protection for EC2 are not enabled yet because the landing zone does not currently contain EC2, ECS, or EKS workloads. These capabilities will be evaluated when compute resources are introduced.

### Security value

- Provides managed detection of suspicious AWS activity.
- Uses AWS threat intelligence and behavioral analysis.
- Adds visibility into supported S3 access and RDS login activity.
- Produces centralized findings for investigation and future automation.
- Avoids deploying and maintaining a custom threat-analysis platform.

### Business value

- Reduces the operational burden of building threat detection from scratch.
- Improves visibility into potential account or workload compromise.
- Creates findings that can feed Security Hub, EventBridge, SNS, ticketing, and incident-response workflows.
- Provides a scalable foundation for additional workload-protection capabilities.

### Cost consideration

GuardDuty is usage-based and may include trial periods for newly enabled protection plans. Runtime and malware protection capabilities will be enabled only when relevant workloads exist.

## Centralized security posture management

### Business requirement

Security teams need a centralized mechanism to evaluate AWS resources against recognized security practices, prioritize weaknesses, and aggregate findings from AWS security services.

### Decision

AWS Security Hub CSPM was enabled through Terraform.

The following security standards were explicitly subscribed:

- AWS Foundational Security Best Practices v1.0.0
- CIS AWS Foundations Benchmark v5.0.0

Automatic default-standard selection was disabled so that Terraform explicitly controls the enabled standards and versions.

Security Hub provides a centralized location for GuardDuty findings and security-control results.

### Security value

- Continuously evaluates the AWS account against security controls.
- Centralizes findings from AWS security services.
- Identifies configuration weaknesses and control failures.
- Provides standardized severity and compliance information.
- Creates a prioritized backlog for remediation.
- Supports future EventBridge, SNS, ticketing, and SIEM integrations.

### Business value

- Reduces the need to review findings separately in multiple service consoles.
- Improves visibility into cloud-security posture.
- Provides measurable security and standards-compliance scores.
- Helps security teams prioritize remediation work.
- Produces evidence useful for governance and audit activities.

### Operational consideration

Security scores and control results are not immediate. Many resource-level controls depend on AWS Config and will become more complete after AWS Config is enabled.

## Continuous AWS resource configuration recording

### Business requirement

Security, compliance, and operations teams need a historical record of AWS resource configurations and configuration changes.

Security Hub CSPM also requires AWS Config resource recording for most resource-level security controls.

### Decision

AWS Config was enabled with a customer-managed configuration recorder using the AWS Config service-linked role.

The recorder continuously records all supported resource types in the primary Region and includes supported global resource types.

Configuration history and snapshots are delivered to a dedicated private S3 bucket with:

- Public-access blocking
- Bucket-owner-enforced object ownership
- Versioning
- Default server-side encryption
- TLS-only access
- Lifecycle-based retention

Configuration snapshots are delivered every 24 hours. AWS Config historical information is retained for 90 days in the development environment.

### Security value

- Preserves a history of resource configuration changes.
- Supports investigation of unauthorized or unexpected modifications.
- Supplies resource data required by Security Hub controls.
- Provides configuration timelines for audit and incident response.
- Uses an AWS Config service-linked role rather than a manually overprivileged role.
- Protects delivered configuration data from public access.

### Business value

- Reduces time required to determine when infrastructure changed.
- Supports governance, compliance, and audit evidence.
- Improves Security Hub control coverage.
- Creates a searchable inventory of supported AWS resources.
- Helps teams identify configuration drift and policy violations.

### Cost consideration

AWS Config charges are based partly on configuration items and rule evaluations. Continuous recording provides stronger visibility but may cost more than daily recording in environments with frequent changes.

## AWS Config managed compliance baseline

### Requirement

The landing zone requires continuous evaluation of important AWS security configurations, not only historical configuration recording.

### Decision

AWS Config managed rules were deployed with Terraform to evaluate:

- S3 public read and write access
- S3 server-side encryption
- S3 encrypted transport
- EBS volume encryption
- EC2 public IP exposure
- Unrestricted inbound SSH
- Default security group configuration
- CloudTrail availability
- Customer-managed KMS key rotation

The rules are defined through a Terraform map and created with `for_each`. This makes the compliance baseline consistent, scalable, and easy to extend.

### Security value

- Detects publicly accessible storage.
- Identifies unencrypted storage resources.
- Detects exposed EC2 instances and unrestricted SSH access.
- Ensures CloudTrail remains available.
- Evaluates customer-managed KMS key rotation.
- Provides resource-level compliance evidence.
- Establishes a baseline for automated remediation.

### Operational value

The centralized rule map reduces duplicated Terraform code and permits new controls to be added through a single standardized structure.

### Expected results

Some rules may initially return `NON_COMPLIANT` or `INSUFFICIENT_DATA`. A noncompliant result confirms that the detective control is functioning and identifies work for the remediation phase.