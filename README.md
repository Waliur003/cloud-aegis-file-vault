## Cloud Security Project 01: Secure File Vault (Zero-Trust Enterprise Storage Portal)

### Overview

I have architected and deployed a highly secure, enterprise-grade storage portal on AWS using Infrastructure as Code (IaC) primitives. This project demonstrates a production-ready, zero-trust cloud architecture designed to eliminate data exposure risks through multi-layered cryptographic isolation, mandatory multi-factor authentication (MFA), and tamper-proof audit trails. The architecture guarantees absolute data encryption at rest and in transit, restricts access dynamically via fine-grained identity boundaries, and continuously tracks data-plane operations to ensure regulatory compliance and comprehensive threat visibility. By stripping out default public configurations and replacing them with explicit security guardrails, the vault achieves absolute data insulation.

### The Problem

Traditional cloud storage deployments are frequently plagued by architectural misconfigurations and inadequate access controls, making them prime targets for data breaches. Legacy file-sharing methods typically display three critical security flaws:

* **Overly Permissive Access Boundaries and Public Exposure:** Relying on default storage configurations or poorly managed Access Control Lists (ACLs) frequently results in the accidental public exposure of sensitive corporate assets to the internet.
* **Weak Authentication Paths and Credential Vulnerabilities:** Allowing users to access internal files via single-factor passwords without mandatory cryptographic verification leaves the storage layer vulnerable to credential stuffing, brute-force attacks, and compromised identity profiles.
* **Auditing Blind Spots at the Data Plane:** While standard infrastructure logs track administrative changes, they often ignore object-level actions (e.g., reading or downloading a file). Without immutable data-plane auditing, security operations teams remain blind to unauthorized data exfiltration or internal abuse.

### The Solution

* **Customer-Managed Cryptographic Isolation:** Utilized a dedicated AWS KMS Customer Managed Key (CMK) with automated annual rotation enforced, moving away from AWS-managed keys to ensure sole cryptographic ownership and explicit access control over data-at-rest.
* **Hardened Zero-Trust Storage Perimeter:** Engineered an absolute S3 perimeter policy by enabling total Public Access Blocks, disabling legacy ACLs, and enforcing bucket versioning to mitigate ransomware risks and unauthorized data manipulation.
* **Mandatory Multi-Factor Identity Gatekeeper:** Integrated an Amazon Cognito Identity and User Pool framework configured to strictly mandate Time-Based One-Time Password (TOTP) Authenticator app MFA before issuing short-lived, low-privilege cryptographic tokens.
* **Tamper-Proof Continuous Data Auditing:** Deployed an isolated AWS CloudTrail engine configured with Log File Validation enabled to record immutable, object-level S3 data events, generating a cryptographically sealed audit trail of all file interactions.

---

### Tech Stack

* **Data Storage Core:** Amazon S3 (Hardened Enterprise Vault Tier)
* **Cryptographic Key Management:** AWS KMS (Symmetric Customer Managed Keys)
* **Identity & Access Federation:** Amazon Cognito (User Pools / Short-Lived Token Brokerage)
* **Continuous Compliance Auditing:** AWS CloudTrail (Data-Plane Event Tracing & Log Validation)
* **Identity Governance Engine:** AWS IAM (Least-Privilege Scoped Resource Policies)
* **Infrastructure as Code Engine:** Terraform (v1.0+ / Version-Locked Declarative Architecture)

---

### Architecture Diagram

*(Placeholder for your architecture diagram showing Cognito federating identity, mapping users to temporary IAM roles, and allowing access to an S3 bucket encrypted via KMS while CloudTrail logs all actions to an isolated logging bucket.)*

---

### Project Procedure

#### 1. Customer-Managed Cryptographic Key Engineering

I provisioned a dedicated symmetric cryptographic boundary using AWS KMS to ensure total ownership over data encryption.

* **Cryptographic Policy Enforcement:** Configured the key with automated annual key rotation enabled, fulfilling key compliance framework criteria (such as SOC 2 and ISO 27001).
* **Administrative Separation:** Defined a highly restrictive key policy that separates key administrative actions (managing the key) from key usage actions (encrypting/decrypting data), ensuring that no single identity possesses unmonitored control.

#### 2. Hardened S3 Object Store Provisioning

I engineered a secure, zero-trust storage repository using Amazon S3, deliberately stripping out all legacy access methods.

* **Perimeter Hardening:** Deployed a strict `aws_s3_bucket_public_access_block` configuration, forcing all public access indicators to `true` to block accidental bucket exposure.
* **Cryptographic Lockout:** Configured default server-side encryption to strictly utilize the custom KMS key (`SSE-KMS`) and enabled **S3 Bucket Keys** to reduce cryptographic API call costs by up to 99%.
* **Ransomware Mitigation:** Enforced S3 Bucket Versioning to maintain an immutable history of object states, protecting the organization against destructive data overwrites or encryption-based extortion attacks.

#### 3. MFA-Enforced Identity Federation Setup

I constructed a secure authentication gateway using Amazon Cognito to serve as the user access controller.

* **Mandatory MFA Policy:** Configured the User Pool security rules to require `ON` state Multi-Factor Authentication, specifically limiting validation methods to **Software Token TOTP** (Authenticator apps) while banning weak SMS channels.
* **Token Hardening:** Configured a Public App Client to handle user pool handshakes, issuing short-lived, cryptographically signed JSON Web Tokens (JWTs) that automatically expire to reduce the token hijack window.

#### 4. Immutable Data-Plane Audit Trail Deployment

To ensure complete corporate visibility and non-repudiation, I deployed a dedicated security auditing layer using AWS CloudTrail.

* **Isolated Log Storage:** Provisioned a completely separate, dedicated S3 bucket to act as the central log repository, completely isolated from the primary file vault.
* **Data-Plane Monitoring:** Tailored the trail event selector to exclusively capture **S3 Data Events** (`Read` and `Write` API actions) targeting the file vault bucket.
* **Tamper Eviction:** Enabled Log File Validation. This instructs CloudTrail to generate digital signatures for log files every hour, allowing security analysts to programmatically verify that audit records have not been altered or deleted by an insider threat.

#### 5. Least-Privilege Identity Boundaries Formulation

To securely link the Cognito identity gateway with the hardened storage repository, I formulated a strict access role architecture within AWS IAM.

* **Short-Lived Credential Mapping:** Configured an IAM Role embedded with an explicit assume-role trust policy restricting identity generation solely to the Cognito Federated Identity provider principal.
* **Zero-Wildcard Scope:** Authored a highly targeted permission document that explicitly defines permissible resource destinations by mapping individual ARNs. The policy limits actions strictly to `s3:GetObject` and `s3:PutObject` on the exact file vault bucket path, while simultaneously restricting `kms:Decrypt` and `kms:GenerateDataKey` strictly to the file vault KMS key ARN.

---

### Infrastructure as Code (IaC) Architecture

To enforce the core cloud security principles of auditability, configuration consistency, and drift prevention, the entire environment is provisioned using declarative Terraform configurations.

#### Directory Layout & Modular Structure

```text
cloud-aegis-file-vault/
├── provider.tf      # System Provider & Version Lock Scoping
├── variables.tf     # Environment Portability Parameter Definitions
├── kms.tf           # Cryptographic Key Core & Policy Logic
├── s3.tf            # Hardened S3 Vault & Isolated Log Storage
├── cognito.tf       # MFA-Enforced User Pool Identity Gateway
├── cloudtrail.tf    # Data-Plane Audit Trail Configuration
└── outputs.tf       # Programmatic Resource Identifiers for Audits
```

#### Detailed File-by-File Technical Breakdown

##### 1. System Provider Scoping (`provider.tf`)

* **Dependency Locking:** Restricts the deployment environment to lock securely against the modern AWS Provider `v5.0+` plugin ecosystem, ensuring compatibility with advanced security schemas.
* **Region Isolation:** Binds the cloud provider footprint directly to standard geographic input parameters to prevent accidental multi-region resource sprawl.

##### 2. Variable Abstractions & Metadata Outputs (`variables.tf` & `outputs.tf`)

* **Environment Portability:** Parameterizes resource names, compliance tags, and environment tiers, ensuring the entire secure perimeter can be cloned from staging to production flawlessly.
* **Audit Transparency:** Outputs vital structural indicators (`vault_bucket_arn`, `kms_key_arn`, `cognito_user_pool_id`) to simplify third-party compliance reviews.

##### 3. Cryptographic Key Core (`kms.tf`)

* **Compliance Enforcer:** Provisions the symmetric `aws_kms_key` resource with `enable_key_rotation = true` to satisfy automated compliance mandates.
* **Alias Abstractor:** Binds a clean, user-friendly identifier (`alias/file-vault-key`) to the underlying cryptographic container string to eliminate resource mapping confusion.

##### 4. Hardened Storage Perimeter (`s3.tf`)

* **Absolute Perimeter Isolation:** Groups the creation of the primary vault bucket, versioning configurations, and the explicit four-flag public access block into a highly structured resource collection.
* **Cryptographic Attunement:** Hooks the `aws_s3_bucket_server_side_encryption_configuration` directly to the outputs of the KMS module, preventing unencrypted data ingestions.

##### 5. Multi-Factor Identity Gateway (`cognito.tf`)

* **Identity Fortification:** Controls user registration, password strength frameworks, and mandates software token token configurations directly through the `aws_cognito_user_pool` primitive.
* **Token Distribution Interface:** Configures the client parameters to safely pass temporary execution tokens downstream without exposing high-level system secrets.

##### 6. Data-Plane Audit Trail (`cloudtrail.tf`)

* **Continuous Logging Router:** Provisions the `aws_cloudtrail` engine, maps it to an isolated storage container, and establishes advanced filtering blocks to focus logs strictly on object-plane read/write events.

---

### Verification and Results

#### Verified Absolute Data Encryption at Rest

Uploaded a test corporate file into the secure storage perimeter via the command line interface. Reviewing the object configuration details within the AWS environment verified that the file was immediately locked using `SSE-KMS` encryption, mapping perfectly to the specific Customer Managed Key ID.

#### Validated Public Access Defenses and Isolation

Attempted to access the uploaded file directly over the public internet using an unauthenticated browser request. The boundary controls functioned perfectly, returning a strict **HTTP 403 Access Denied** error, confirming the efficacy of the absolute Public Access Block.

#### Verified Mandatory Software Token MFA Enforcement

Initiated a programmatic registration script against the Cognito User Pool identity layer. The identity engine successfully intercepted the login pattern, blocked direct access, and refused to distribute credentials until a valid **TOTP token handshake** was established via an Authenticator application interface.

#### Confirmed Cryptographic Audit Trail Tracking

Inspected the isolated logging bucket following file upload and download test iterations. The security logs confirmed complete auditing visibility, recording precise, cryptographically signed event packets tracking the exact identity user name, source IP address, execution timestamp, and targeted file path.

---

### Future Improvements

* **S3 Object Lock (WORM Compliance):** Integrate strict write-once-read-many (WORM) configurations on compliance-sensitive paths to completely protect financial or regulatory records from tampering or insider deletion attempts.
* **Automated Data Classification (Amazon Macie):** Attach an alternate automated data classification scanning routine using Amazon Macie to continuously inspect the file vault for accidental uploads of personally identifiable information (PII) or protected health information (PHI).
* **Anomalous Key Usage Detection:** Engineer an automated alert hook connecting AWS CloudWatch and SNS to flag and broadcast instantaneous warnings if an identity outside the authorized role attempts to call the KMS cryptographic key APIs.

---

### Notes

This architecture showcases an optimized, production-ready implementation of a secure cloud storage perimeter. It validates specialized core competencies in structuring multi-layered data encryption frameworks, zero-trust boundary isolation controls, strict multi-factor identity federation, and automated infrastructure compliance tracking.

> **Bottom Line:** The Cloud Aegis File Vault completely eliminates common cloud storage exposures. By wrapping unvalidated files in dedicated cryptographic keys, mandating multi-factor token verification at the identity gate, and sealing data-plane interactions into a cryptographically validated log trail, this architecture transforms generic storage into a resilient, production-hardened cloud vault.
