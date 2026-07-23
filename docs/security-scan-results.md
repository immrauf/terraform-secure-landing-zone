# Infrastructure Security Scan Results

## Overview

This project uses multiple static-analysis tools to evaluate Terraform configuration before deployment.

## Security Tools

- Terraform fmt
- Terraform validate
- Checkov
- Trivy

## Checkov Review

Checkov identified a combination of:

- Remediation candidates
- Intentional architectural decisions
- Cross-module false positives
- Enterprise controls outside the scope of this portfolio environment

## Trivy Review

Document the Trivy scan summary here after reviewing the generated report.

## Remediation Strategy

Findings are classified as:

1. Remediate
2. Accept with justification
3. False positive
4. Future enhancement

## Current Remediation Priorities

- Abort incomplete S3 multipart uploads
- Retain security logs for at least 365 days
- Review Secrets Manager rotation requirements
- Document the break-glass administrator exception
- Document cross-module scanner limitations

## Accepted Design Decisions

- Public subnets are intentionally defined for public-facing infrastructure.
- Workload security groups are prepared for future ALB, application, and database resources.
- GuardDuty organization administration is outside the scope of this single-account deployment.
- Cross-region S3 replication is treated as a future production enhancement.

## Continuous Improvement

These checks will be automated through GitHub Actions so that Terraform formatting, validation, Checkov, and Trivy execute on every pull request.