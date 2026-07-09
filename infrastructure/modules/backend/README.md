
# Terraform Backend Module

---

## 1. Overview

### Purpose

The Backend module provisions the AWS infrastructure required for Terraform remote state management.

It creates:

- A private Amazon S3 bucket for storing the Terraform state file.
- An Amazon DynamoDB table for state locking.
- Security controls following AWS and HashiCorp best practices.

This module is intended to be deployed **once** before provisioning any application infrastructure.

---

## 2. Architecture

```text
                 Terraform CLI
                        │
                        ▼
             Amazon S3 (Remote State)
             ├── Versioning
             ├── Encryption
             ├── Private Bucket
             ├── Ownership Controls
             └── Public Access Block
                        │
                        ▼
           Amazon DynamoDB (State Locking)
```

---

## 3. Design Decisions

### Why Remote State?

Local state files:

- Cannot be shared safely.
- Are easy to lose.
- Do not support collaboration.

Remote state provides:

- Centralized storage
- Team collaboration
- CI/CD compatibility
- Improved reliability

---

### Why Amazon S3?

Amazon S3 offers:

- High durability
- Native Terraform support
- Versioning
- Encryption
- Fine-grained IAM permissions
- Cost-effective storage

---

### Why DynamoDB?

Terraform uses DynamoDB to prevent concurrent modifications to the state file.

Without state locking:

```text
Engineer A  ---> terraform apply

Engineer B  ---> terraform apply

Result:
State corruption
```

With locking:

```text
Engineer A
     │
Lock acquired
     │
Terraform Apply
     │
Lock released

Engineer B waits...
```

---

### Why Versioning?

Versioning protects against:

- Accidental overwrites
- State corruption
- Human error

Previous state versions can be restored if necessary.

---

### Why Encryption?

Terraform state may contain:

- Infrastructure metadata
- Resource identifiers
- Networking information
- Sensitive configuration

Encryption protects data at rest.

---

## 4. Inputs

| Variable | Description |
|----------|-------------|
| project_name | Project identifier |
| environment | Deployment environment |
| state_bucket_name | Name of the S3 backend bucket |
| lock_table_name | DynamoDB lock table |
| enable_versioning | Enable bucket versioning |
| enable_encryption | Enable server-side encryption |
| sse_algorithm | Encryption algorithm |
| enable_lifecycle_rules | Enable lifecycle configuration |
| noncurrent_version_expiration_days | Previous version retention |
| prevent_destroy | Protect backend resources |
| tags | Common resource tags |

---

## 5. Outputs

| Output | Description |
|---------|-------------|
| state_bucket_name | Backend bucket name |
| state_bucket_arn | Backend bucket ARN |
| state_bucket_id | Backend bucket ID |
| state_bucket_regional_domain_name | Bucket regional endpoint |
| lock_table_name | DynamoDB table name |
| lock_table_arn | DynamoDB table ARN |
| backend_region | AWS deployment region |
| versioning_enabled | Versioning status |
| encryption_algorithm | Encryption algorithm |
| backend_configuration | Backend configuration helper |

---

## 6. Dependencies

This module has no dependencies on other Terraform modules.

It is the foundational module used by all subsequent infrastructure projects.

---

## 7. Resource Graph

```text
Backend Module
│
├── S3 Bucket
│   ├── Versioning
│   ├── Encryption
│   ├── Ownership Controls
│   └── Public Access Block
│
└── DynamoDB Table
```

---

## 8. Security Considerations

- Private S3 bucket
- Public access fully blocked
- Bucket Owner Enforced ownership
- Server-side encryption enabled
- Versioning enabled
- `prevent_destroy` protects critical resources
- State locking enabled using DynamoDB

---

## 9. Validation Steps

Run:

```bash
terraform fmt
terraform validate
terraform plan
```

Verify:

- Bucket is private
- Encryption is enabled
- Versioning is enabled
- DynamoDB table exists
- Tags are applied
- No validation errors

---

## 10. Example Usage

```hcl
module "backend" {

  source = "./modules/backend"

  project_name     = var.project_name
  environment      = var.environment

  state_bucket_name = local.state_bucket_name
  lock_table_name   = local.lock_table_name

  enable_versioning                  = true
  enable_encryption                  = true
  sse_algorithm                      = "AES256"
  enable_lifecycle_rules             = true
  noncurrent_version_expiration_days = 90

  prevent_destroy = true

  tags = local.common_tags

}
```

---

## 11. Future Improvements

- Support customer-managed AWS KMS keys
- Cross-region replication
- S3 access logging
- CloudWatch monitoring
- EventBridge notifications
- IAM least-privilege policy generation

---

## 12. Change Log

| Version | Changes |
|----------|---------|
| 1.0.0 | Initial production-ready backend module |