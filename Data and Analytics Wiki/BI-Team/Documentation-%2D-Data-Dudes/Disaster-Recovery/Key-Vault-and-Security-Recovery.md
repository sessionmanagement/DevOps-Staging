# Key Vault and Security Recovery

**Applies to:** Azure Key Vault, service principals, managed identities, Entra ID, credentials, ransomware response
**RTO Target:** 24 hours | **RPO Target:** N/A (credentials are configuration, not data)
**Priority:** P0 — Recover FIRST. All other platform components depend on Key Vault and security.

---

## Pre-Requisites

- [ ] Azure Portal access confirmed: [https://portal.azure.com](https://portal.azure.com)
- [ ] You have **Key Vault Contributor** or **Owner** access
- [ ] Microsoft Entra ID admin access (or escalation path to IT/Global Admin)

---

## Key Vault Inventory

| Vault | Environment | Purpose | Purge Protection |
|-------|-------------|---------|-----------------|
| `kv-prod-aus-svc-syn-01` | Production | All credentials, API keys, connection strings, service principal secrets | **90 days enabled** |

### What is stored in Key Vault

| Secret Type | Examples | Used By |
|-------------|---------|---------|
| API credentials / SFTP | Business Central, EcoPortal, IntelliHR, DataPay, EmpLive, SnapHire | ADF pipelines, Synapse pipelines |
| Database connection strings | SQL connection details for ODS, EDW, Framework, Manager | Linked services |
| Service principal secrets | CI/CD deployment credentials | Azure DevOps pipelines |
| SAS tokens | Storage account access tokens (e.g., Waharoa) | Synapse Data Landing |
| MBIE credentials | Government API access | Specific pipelines |
| Other API keys | MS Graph, PowerBI, Tapui Waka, Six Degrees | Extraction pipelines |

> **CRITICAL:** If Key Vault becomes unavailable, ALL ADF and Synapse pipelines will fail because they cannot retrieve credentials.

---

## Scenario 1: Key Vault Secret Expired or Rotated

Use this for: credential rotation, expired API keys, service principal secret expiry.

<details>
<summary><b>Step 1 — Identify which secret has expired</b></summary>

1. Check pipeline failure error messages
1. Review the pipeline error to see if it's authentication error


</details>
<br/>

<details>
<summary><b>Step 2 — Obtain new credentials</b></summary>

| Credential Type | Source | Action |
|----------------|--------|--------|
| Service principal secret | Microsoft Entra ID → App registrations | Generate new client secret |
| API key (vendor system) | Vendor admin portal | Request new key from vendor |


</details>
<br/>

<details>
<summary><b>Step 3 — Update the Key Vault secret</b></summary>

1. Navigate to `kv-prod-aus-svc-syn-01` → **Secrets**
2. Click the affected secret
3. Click **+ New Version**
4. Enter the new secret value
5. Optionally set an expiration date
6. Click **Create**

</details>
<br/>

<details>
<summary><b>Step 4 — Verify dependent services</b></summary>

1. Re-run any failed pipelines
1. In ADF Studio → test the linked service that uses this secret
1. In Synapse Studio → test the linked service that uses this secret


</details>
<br/>

---

## Scenario 2: Key Vault Soft-Deleted

Azure Key Vault has soft-delete enabled with 90-day purge protection.

<details>
<summary><b>Step 1 — Check for soft-deleted vault</b></summary>

1. Azure Portal → **Key vaults** → **Manage deleted vaults**
2. Filter by subscription `3ad070fe-7936-4060-a09c-338ac9352378`
3. Look for `kv-prod-aus-svc-syn-01`

</details>
<br/>

<details>
<summary><b>Step 2 — Recover the soft-deleted vault</b></summary>

1. Select the deleted vault
2. Click **Recover**
3. Wait for recovery to complete (typically 5–15 minutes)
4. Navigate to the recovered vault
5. Verify all secrets are present
6. Verify access policies are intact

</details>
<br/>

<details>
<summary><b>Step 3 — Verify all dependent services reconnect</b></summary>

1. Test ADF linked services that reference Key Vault
2. Test Synapse linked services that reference Key Vault
3. Re-run any pipelines that failed during the outage

</details>
<br/>

---

## Scenario 3: Key Vault Purged or Unrecoverable

If the Key Vault has been purged (beyond the 90-day protection window) or is otherwise unrecoverable.

<details>
<summary><b>Step 1 — Create a new Key Vault</b></summary>

1. Azure Portal → **Key vaults** → **Create**
2. Configure:
   - **Subscription:** `3ad070fe-7936-4060-a09c-338ac9352378`
   - **Resource Group:** `rg-prod-aus-svc-datareporting`
   - **Vault name:** `kv-prod-aus-svc-syn-01` (match original if possible)
   - **Region:** Australia East (mandatory — data sovereignty)
   - **Pricing tier:** Standard
3. Under **Access configuration**:
   - **Permission model:** Vault access policy
4. Under **Networking**:
   - Allow access from all networks (or match previous network rules)
5. Click **Review + Create** → **Create**

</details>
<br/>

<details>
<summary><b>Step 2 — Enable purge protection</b></summary>

1. Navigate to the new vault → **Properties**
2. Enable **Soft-delete** (90 days)
3. Enable **Purge protection**

</details>
<br/>

<details>
<summary><b>Step 3 — Set access policies</b></summary>

Add access policies for all services that need Key Vault access:

| Identity | Type | Permissions |
|----------|------|-------------|
| ADF managed identity (`adf-prod-aus-datalanding-01`) | Managed Identity | Get, List (Secrets) |
| Synapse managed identity (`synapseausprod`) | Managed Identity | Get, List (Secrets) |
| BI Engineering team members | User/Group | Get, List, Set, Delete (Secrets) |
| Azure DevOps service principal | App Registration | Get, List (Secrets) |

</details>
<br/>

<details>
<summary><b>Step 4 — Recreate all secrets</b></summary>

This is the most time-consuming step. You must obtain fresh credentials for every secret.

| Action | Source | Secrets to Create |
|--------|--------|-------------------|
| Generate new service principal secrets | Entra ID → App registrations | CI/CD deployment credentials |
| Request new API keys | Each vendor | BC, EcoPortal, IntelliHR, DataPay, EmpLive, SnapHire, Tapui Waka |
| Generate new SAS tokens | Storage account → Shared access signature | Waharoa, any other SAS-authenticated storage |
| Generate new connection strings | SQL Server admin | Database connection strings |
| Request MBIE credentials | MBIE portal (RealMe) | Government API access |
| Request Six Degrees credentials | Six Degrees admin | CRM API access |

> **WARNING:** This process requires coordination with multiple external vendors. Budget 4–8 hours for full credential recreation.

</details>
<br/>

<details>
<summary><b>Step 5 — Update all linked service references</b></summary>

If the Key Vault name changed:

1. Update ADF linked services (`ls_kv_datalnd01`, `ls_AKV_syn`) with new vault URL
2. Update Synapse linked services (`ls_AKV`, `ls_AKV_SixDegrees`) with new vault URL
3. Publish changes in both ADF and Synapse
4. Test all linked services

</details>
<br/>

---

## Scenario 4: Service Principal Compromise or Expiry

<details>
<summary><b>Step 1 — Identify the affected service principal</b></summary>

1. Azure Portal → **Microsoft Entra ID** → **App registrations**
2. Search for the affected application
3. Check **Certificates & secrets** for expired client secrets
4. Check **Sign-in logs** under **Monitoring** for suspicious activity

</details>
<br/>

<details>
<summary><b>Step 2 — If compromised: Revoke immediately</b></summary>

1. Delete ALL existing client secrets for the compromised app registration
2. In Entra ID → **Enterprise applications** → find the service principal → **Properties** → set **Enabled** to **No**
3. Review audit logs for any unauthorized actions taken
4. Notify BI Manager (Chris Negus) and security team

</details>
<br/>

<details>
<summary><b>Step 3 — Generate new credentials</b></summary>

1. In the App registration → **Certificates & secrets** → **+ New client secret**
2. Set description and expiry (recommended: 12 months)
3. Copy the new secret value immediately (it will not be shown again)
4. Store in Key Vault
5. Re-enable the service principal if it was disabled

</details>
<br/>

<details>
<summary><b>Step 4 — Update Azure DevOps service connections</b></summary>

1. Azure DevOps → Project Settings → **Service connections**
2. Edit the affected service connection
3. Update with new client secret
4. Test the connection

</details>
<br/>

---

## Scenario 5: Ransomware / Security Breach Response

<details>
<summary><b>Immediate Actions (First 30 minutes)</b></summary>

1. **STOP** all pipeline triggers in both ADF and Synapse to prevent further data movement
2. **Escalate** to BI Manager (Chris Negus) immediately
3. **Escalate** to IT security team / Global Admin
4. **Do NOT** delete or modify any resources until investigation scope is determined
5. **Document** all observed indicators of compromise (timestamps, affected resources, error messages)
6. **Revoke** service principal secrets if credentials are suspected compromised

</details>
<br/>

<details>
<summary><b>Assessment (1–4 hours)</b></summary>

1. Review Entra ID sign-in logs for unauthorized access
2. Review Azure Activity Log for resource modifications
3. Review Key Vault audit logs for secret access
4. Check SQL database audit logs for unusual queries
5. Check ADF/Synapse pipeline runs for unauthorized executions
6. Determine the blast radius — which resources are affected

</details>
<br/>

<details>
<summary><b>Recovery (4–24 hours)</b></summary>

1. Rotate ALL credentials:
   - All Key Vault secrets
   - All service principal secrets
   - All database passwords
   - All API keys
2. Restore databases from point-in-time BEFORE the breach (see [Database-Recovery-Procedures](Database-Recovery-Procedures))
3. Restore storage from soft-delete snapshots BEFORE the breach
4. Redeploy pipeline code from Git (known good state)
5. Verify no unauthorized Entra ID users or group memberships
6. Re-enable pipeline triggers only after security team confirms all-clear

</details>
<br/>

<details>
<summary><b>Post-Incident (24–72 hours)</b></summary>

1. Document timeline of events
2. Root cause analysis
3. Implement additional security controls as determined by investigation
4. Review and update access policies
5. Schedule DR test to validate recovery completeness
6. Update this DR documentation with lessons learned

</details>
<br/>

---

## Managed Identity Reference

| Resource | Identity Type | Used For |
|----------|--------------|----------|
| `adf-prod-aus-datalanding-01` | System-assigned | ADLS storage access, Key Vault access |
| `synapseausprod` | System-assigned | SQL databases, ADLS storage, Key Vault |
| Test ADF (copy-prod-to-test) | System-assigned | Cross-environment data copy |

> **Note:** If a resource is deleted and recreated, it gets a NEW managed identity. All RBAC assignments must be updated for the new identity.

---

## Post-Recovery Checklist

After any Key Vault / security recovery:

- [ ] Key Vault accessible in Azure Portal
- [ ] Purge protection and soft-delete enabled (90 days)
- [ ] All access policies restored for ADF, Synapse, team members, service principal
- [ ] All secrets present and valid (test each linked service)
- [ ] ADF linked services referencing Key Vault test successfully
- [ ] Synapse linked services referencing Key Vault test successfully
- [ ] Azure DevOps service connections updated and tested
- [ ] No unauthorized Entra ID users or app registrations
- [ ] Service principal secrets rotated (if compromise scenario)
- [ ] All pipeline triggers can start without credential errors
- [ ] Audit logging enabled on Key Vault
