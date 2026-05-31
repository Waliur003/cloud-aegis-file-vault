## Cloud Engineering Project 01: The Secure File Vault (Enterprise Data Protection & Zero-Trust Architecture)

---

### Overview

I have architected and deployed a highly resilient, enterprise-grade data protection storage architecture on AWS using Infrastructure as Code (IaC) primitives. This project demonstrates a production-hardened, compliance-ready cloud infrastructure that achieves absolute data insulation at rest and in transit. The architecture integrates symmetric cryptographic key management, federated user identity control with mandatory multi-factor enforcement, isolated web hosting execution environments, and a tamper-proof continuous audit trailing loop. By enforcing rigid least-privilege boundaries and programmatic data lifecycle policies, the system completely mitigates data exfiltration risks and unauthorized multi-tenant access vectors while maintaining optimal storage cost-efficiency.

---

### The Problem

Modern enterprise storage platforms are targeted relentlessly by sophisticated attack vectors, where a single misconfiguration can lead to catastrophic data breaches, regulatory penalties, and loss of client trust. Traditional cloud storage implementations consistently fail due to three architectural vulnerabilities:

* **Public Exposure and Unencrypted Repositories:** Default or improperly audited cloud storage containers frequently allow public read/write access or store sensitive files in plain text. If peripheral application perimeters fail, data at rest is exposed directly to malicious interception.
* **Weak Identity Controls and Privilege Creep:** Monolithic credential schemes lacking multi-factor enforcement allow compromised administrative or user accounts to access high-value assets. Furthermore, granting broad, wildcard actions to application identities violates core security principles.
* **Operational Blind Spots and Compliance Failures:** Without complete, immutable visibility into who accessed, modified, or downloaded specific corporate assets, security operations centers (SOC) cannot detect active data exfiltration patterns or verify regulatory alignment during mandatory external compliance audits.

---

### The Solution

* **Symmetric Cryptographic Isolation:** Engineered a zero-trust storage layer using Amazon S3 wrapped inside an automated, customer-managed AWS KMS cryptographic key container, ensuring all data assets are converted to encrypted strings prior to hitting physical disks.
* **Mandatory Multi-Factor Gatekeeper:** Deployed an enterprise identity provider using Amazon Cognito configured for strict user verification and mandatory Time-Based One-Time Password (TOTP) Authenticator authentication, issuing short-lived, scoped cryptographic tokens for authorized access.
* **Tamper-Proof Ledger and Monitoring:** Implemented an independent, continuous auditing framework via AWS CloudTrail with log-file validation enabled, executing real-time object-level data tracking to capture detailed API call metrics in an unalterable log archive.
* **Programmatic Data Lifecycle Pruning:** Structured automated lifecycle policy engines to transition aging documents through cheaper storage tiers before executing absolute cryptographic destruction, reducing both storage overhead and the corporate data liability footprint.

---

### Tech Stack

* **Data Storage Infrastructure:** Amazon S3 (Secure Storage Vault and Isolated Audit Logging Tiers)
* **Cryptographic Key Management:** AWS KMS (Key Management Service / Customer Managed Keys)
* **Identity & Access Governance:** Amazon Cognito (User Pools, App Clients, TOTP MFA Enforcement)
* **Continuous Security Auditing:** AWS CloudTrail (Object-Level Data Event Trailing)
* **Identity Governance Control:** AWS IAM (Least-Privilege Scoped Policy Documents and Federated Roles)
* **IaC Engine:** Terraform (v1.0+ / Modularized Declarative Configurations)

---

### Architecture Diagram

---

### Project Procedure

#### 1. Cryptographic Envelope Generation & Key Hardening

I engineered a dedicated symmetric cryptographic key management layer to isolate asset encryption from standard AWS managed keys.

* **Key Provisioning:** Deployed a Customer Managed Key (CMK) within AWS KMS configured exclusively for symmetric encryption and decryption actions.
* **Automated Security Rotation:** Enforced programmatic annual key rotation parameters to systematically replace underlying cryptographic material without breaking historical file access chains.
* **Administrative Separation:** Structured explicit key policy definitions that cleanly separate key administration privileges from key usage roles, preventing single-point-of-compromise administrative abuses.

#### 2. Hardened Perimeter Storage Vault Engineering

I constructed a multi-layered, private storage vault using Amazon S3 to act as the core repository for restricted corporate assets.

* **Perimeter Access Insulation:** Configured a global Public Access Block on the storage container, enabling all four isolation flags to fully override any accidental ACL or bucket policy exposures.
* **Object Versioning Architecture:** Activated bucket versioning states to preserve historical iterations of objects, establishing a strong defense loop against malicious ransomware encryption or accidental data overrides.
* **Cryptographic Boundary Integration:** Attached an explicit bucket-wide enforcement policy requiring all inbound `PutObject` transactions to use headers matching the custom KMS key ARN, dropping unencrypted payload attempts at the API gateway level.

#### 3. Identity Federation & MFA Governance Deployment

I built an enterprise identity provider using Amazon Cognito to control directory access boundaries before users reach the data layer.

* **Directory Infrastructure:** Provisioned a Cognito User Pool enforcing strict password complexity matrices and email verification workflows.
* **MFA Mandate Configuration:** Configured the authentication engine to enforce a hard conditional status requiring Multi-Factor Authentication via Software Token TOTP applications during user sign-in.
* **Client Abstraction Gateway:** Established a Cognito User Pool Client container to securely facilitate client-side integration and handle cryptographic token handshakes cleanly.

#### 4. Object-Level Security Auditing Framework

To eliminate operational blind spots, I deployed an independent compliance-tracking engine using AWS CloudTrail.

* **Isolated Audit Repository:** Provisioned a separate, heavily restricted S3 logging bucket to isolate audit data from application data stores.
* **Data Event Scoping:** Configured a localized CloudTrail instance targeting object-level data events specifically scoped to the File Vault S3 container paths, capturing all read, write, and deletion metrics.
* **Integrity Assurance Validation:** Activated log-file validation configurations to continuously sign log files, ensuring that any malicious attempt to alter or delete historical access records triggers immediate verification failure alerts.

---

### Infrastructure as Code (IaC) Architecture

To enforce the core cloud engineering principles of repeatability, drift detection, and immutable infrastructure, the entire environment is provisioned using declarative Terraform configurations. The codebase is decoupled into modular component files to separate storage, identity, auditing, and cryptographic logic domains.

#### Directory Layout & Modular Structure

```text
secure-file-vault-infrastructure/
├── provider.tf
├── variables.tf
├── kms.tf
├── s3.tf
├── cognito.tf
├── cloudtrail.tf
└── outputs.tf
```

#### Detailed File-by-File Technical Breakdown

##### 1. System Provider Scoping (`provider.tf`)

* **Dependency Management:** Restricts the execution context to lock securely against the modern AWS Provider plugin ecosystem (v5.0+) to utilize advanced resource schema controls.
* **Regional Target Scoping:** Anchors the provider parameters down to standard geographic input variables to maintain consistency across continuous deployment pipelines.

##### 2. Variable Abstractions & Metadata Outputs (`variables.tf` & `outputs.tf`)

* **Environment Portability Mapping:** Parameterizes target system parameters, environment prefixes, and naming conventions via strongly typed variables, keeping code entirely environment-agnostic.
* **Audit-Ready Outputs:** Exposes critical deployment parameters (such as the storage bucket ARN, KMS Key ID, and Cognito Client ID) to streamline automated verification testing.

##### 3. Cryptographic Key Definer (`kms.tf`)

* **Symmetric Key Logic:** Deployed the `aws_kms_key` resource enabling cryptographic key rotation policies by default.
* **Alias Abstraction:** Binds an `aws_kms_alias` resource to the underlying key container, shielding system code from explicit key ID shifts during redeployments.

##### 4. Hardened Vault Storage Engine (`s3.tf`)

* **Container Allocation:** Provisions the primary storage container, attaching independent public access block resources to lock down edge security.
* **Encryption and Key Binding:** Embeds the `aws_s3_bucket_server_side_encryption_configuration` resource block, pointing data protection parameters directly to the custom customer-managed KMS key.

##### 5. Identity Provider Structure (`cognito.tf`)

* **Identity Core Configuration:** Outlines the user pool container framework, embedding specific configuration arrays to mandate MFA enrollment and secure client transport logic.

##### 6. Compliance Auditor Mapping (`cloudtrail.tf`)

* **Audit Trail Orchestrator:** Allocates an immutable logging trail linked to a separate, private S3 container.
* **Granular Selector Logic:** Maps explicit data resource filters directly to object actions inside the storage vault, ensuring every read/write action records user and token telemetry.

---

### Verification and Results

#### Verified Cryptographic Ingestion Performance

Uploaded a sample object to the secure S3 vault via terminal interfaces. Review of the target object configuration properties verified that the asset was rejected until the transmission included headers matching the custom Customer Managed Key. The file was successfully encrypted at rest using the designated AES-256 KMS scheme.

#### Validated Public Access Isolation

Attempted an anonymous HTTP direct download request against the object URL from outside the corporate cloud perimeter. The storage gateway successfully blocked the transaction, returning a hard `HTTP 403 Forbidden` error response, proving the public access blocks are operating correctly.

#### Confirmed Multi-Factor Identity Gateways

Executed a CLI authentication sequence against the user pool client. The identity engine successfully intercepted the request, halting the authorization loop and demanding a valid TOTP application confirmation token before provisioning short-lived AWS IAM temporary credentials.

#### Verified Immutable Trail Logs

Reviewed the audit tracking logs stored within the dedicated CloudTrail S3 bucket. The ledger accurately compiled a structured log event tracking the exact user identification string, source IP address, target timestamp, and the specific `GetObject` API transaction parameters.

---

### Verification Screenshots

#### S3 Bucket Encryption Profile

* **Console View:** Screenshot of the Amazon S3 Properties interface for the storage vault, displaying Default Encryption set to SSE-KMS using the explicit custom Customer Managed Key ARN.

#### Public Access Block Enforcement

* **Console View:** Screenshot of the Amazon S3 Permissions tab showing "Block *all* public access" turned ON with all four sub-checkboxes checked, indicating complete exposure mitigation.

#### Cognito MFA Security Configuration

* **Console View:** Screenshot of the Amazon Cognito Sign-in Security interface, verifying that Multi-Factor Authentication is set to "Required" with Time-Based One-Time Password (TOTP) as the active method.

#### CloudTrail Object-Level Tracking Status

* **Console View:** Screenshot of the AWS CloudTrail configuration dashboard, demonstrating an active trail with Data Events configured specifically to intercept all read/write S3 operations within the file vault bucket.

---

### Future Improvements

* **Asynchronous Malicious Access Alerts:** Integrate an Amazon EventBridge rule pattern to scan CloudTrail logs in real time, automatically dispatching high-severity SNS alerts if unauthorized cross-region access attempts are initiated.
* **Automated Malware Cleansing Integration:** Introduce an alternate Lambda-driven security layer to scan newly uploaded assets for malware signatures prior to finalizing decryption clearance inside the vault.
* **Cross-Region Read Replica Storage:** Configure an automated, cross-region replication layer utilizing isolated KMS key environments to ensure absolute disaster recovery resilience across separate geographical fault domains.

---

### Notes

This project showcases specialized cloud security engineering competencies in constructing private storage frameworks, customer-managed cryptographic structures, robust identity boundaries, and automated compliance auditing loops using reusable Infrastructure as Code configurations.

