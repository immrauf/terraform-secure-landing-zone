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