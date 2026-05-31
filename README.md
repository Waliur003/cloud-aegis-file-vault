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

Uploaded a sample object (`test-file.txt`) to the secure `sun-secure-vault-2026` S3 vault via terminal interfaces. Review of the target object configuration properties verified that the asset was rejected until the transmission included headers matching the custom Customer Managed Key. The file was successfully encrypted at rest using the designated AES-256 KMS scheme.

#### Validated Public Access Isolation (Zero-Trust Access Control)

Attempted an anonymous, unauthenticated HTTP direct download request via an Incognito browser session targeting the explicit object URL: `[https://sun-secure-vault-2026.s3.us-east-1.amazonaws.com/test-file.txt](https://sun-secure-vault-2026.s3.us-east-1.amazonaws.com/test-file.txt)`. The storage perimeter successfully intercepted and blocked the unauthorized external request at the API gateway layer. The storage vault returned a strict `<Code>AccessDenied</Code>` and `HTTP 403 Forbidden` payload, confirming that the Public Access Blocks are fully insulating internal assets from open internet vulnerabilities.

#### Confirmed Multi-Factor Identity Gateways

Executed a CLI authentication sequence against the user pool client. The identity engine successfully intercepted the request, halting the authorization loop and demanding a valid TOTP application confirmation token before provisioning short-lived AWS IAM temporary credentials.

#### Verified Immutable Trail Logs

Reviewed the audit tracking logs stored within the dedicated CloudTrail S3 bucket. The ledger accurately compiled a structured log event tracking the exact user identification string, source IP address, target timestamp, and the specific `GetObject` API transaction parameters.

---

### Verification Screenshots

#### S3 Bucket Encryption Profile

* **Console View:** Screenshot of the Amazon S3 Properties interface for the storage vault, displaying Default Encryption set to SSE-KMS using the explicit custom Customer Managed Key ARN.

<img width="1919" height="910" alt="Screenshot 1" src="https://github.com/user-attachments/assets/c7512d29-731d-48c1-a99a-3bf78f49ee34" />


#### Public Access Block Enforcement

* **Console View:** Screenshot of the Amazon S3 Permissions tab showing "Block *all* public access" turned ON with all four sub-checkboxes checked, indicating complete exposure mitigation.
  
<img width="1919" height="874" alt="Screenshot 2" src="https://github.com/user-attachments/assets/e8428aae-27fb-4ee8-bd33-93ceb6196b3b" />


#### Cognito MFA Security Configuration

* **Console View:** Screenshot of the Amazon Cognito Sign-in Security interface, verifying that Multi-Factor Authentication is set to "Required" with Time-Based One-Time Password (TOTP) as the active method.
  
<img width="1917" height="904" alt="Screenshot 3" src="https://github.com/user-attachments/assets/9147b22b-e6a2-4bc6-b3c6-42b044d6391e" />


#### CloudTrail Object-Level Tracking Status

* **Console View:** Screenshot of the AWS CloudTrail configuration dashboard, demonstrating an active trail with Data Events configured specifically to intercept all read/write S3 operations within the file vault bucket.

<img width="1919" height="910" alt="Screenshot 4" src="https://github.com/user-attachments/assets/9c7e303b-9072-4b44-b267-5ec406145d47" />

<img width="1919" height="910" alt="Screenshot 6" src="https://github.com/user-attachments/assets/bc91d943-831b-4e70-97a0-897a2634f604" />

<img width="1919" height="895" alt="Screenshot 5" src="https://github.com/user-attachments/assets/506446ba-1d63-47b1-aaaf-d095c72006bd" />


#### Public Access Block Enforcement & Access Denied Output

Refer to the verification image named **image_7a93a3.png**. This screenshot documents an active, unauthenticated attempt to extract `test-file.txt` from `sun-secure-vault-2026.s3.us-east-1.amazonaws.com` via an Incognito browsing frame. The system completely insulates the data asset by actively executing an `AccessDenied` exception block, confirming that the global public access constraints are perfectly implemented.

<img width="1919" height="517" alt="Screenshot 7" src="https://github.com/user-attachments/assets/e0b73fb6-7b8a-42f1-ad5f-bbb7963139f9" />


---

### Future Improvements

* **Asynchronous Malicious Access Alerts:** Integrate an Amazon EventBridge rule pattern to scan CloudTrail logs in real time, automatically dispatching high-severity SNS alerts if unauthorized cross-region access attempts are initiated.
* **Automated Malware Cleansing Integration:** Introduce an alternate Lambda-driven security layer to scan newly uploaded assets for malware signatures prior to finalizing decryption clearance inside the vault.
* **Cross-Region Read Replica Storage:** Configure an automated, cross-region replication layer utilizing isolated KMS key environments to ensure absolute disaster recovery resilience across separate geographical fault domains.

---

### Notes

This project showcases specialized cloud security engineering competencies in constructing private storage frameworks, customer-managed cryptographic structures, robust identity boundaries, and automated compliance auditing loops using reusable Infrastructure as Code configurations.

