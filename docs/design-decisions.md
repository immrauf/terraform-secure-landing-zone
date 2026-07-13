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