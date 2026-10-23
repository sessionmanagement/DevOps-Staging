# Data Governance Group - Minutes

## Thursday, 12 March 2026

---

### Opening Karakia

*Kia hora te marino* (May the calm be widespread)
*Kia whakapapa pounamu i te moana* (May the ocean be as smooth as pounamu)
*Kia tere te kārohirohi i mua i tou huarahi* (May the light ever dance across your pathway)

---

### Welcome

- **Quorum:** 1+ chair, 4+ voting members – Achieved
- **Chair:** Chris Negus
- **Voting Members Present:** Nathan Barthow, Anna Nelson, Moana Keiper, Moana Williams, Faye Logan, Callum Ellwood
- **Non-Voting Members Present:** None
- **Also Present:** Catherine Lim-Starling (Property team, CoE pilot user)
- **Minutes written by:** the AI Agent: DGG Minutes Writer (from meeting recording and further instruction from Chris who interacted with the agent)
- **Apologies:** Reuben Grace, Mike Gencic

---

## 1. Previous Minutes and Actions

### 1.1 Review of Previous Minutes

**Key Points:**
- November 2025 and January 2026 DGG meeting minutes were presented for confirmation
- Nathan confirmed the January minutes made sense and asked about the status of items deferred from that meeting

**Decision:**
- November 2025 minutes: **APPROVED**
- January 2026 minutes: **APPROVED**

### 1.2 Outstanding Actions from January

#### 1.2.1 Removing Masking of Non-Production Data in HumanForce**
- Chris noted that Stefen has not progressed the updated paper due to other programme work and has missed the window for the March meeting
- The paper will need to come back at the next meeting

**Action:**
- Stefen to return to DGG with the updated HumanForce masking paper at the May meeting

#### 1.2.2 Tāngata Whaiora Names in Key Measures Report**
- Chris confirmed the hover functionality has been implemented in the KPI report — tāngata whaiora names are now visible on hover for users within their cone of control, but are not displayed in the table itself    
- However on review after the meeting, it looks like this has not been enabled outside of the BI team.  Chris to follow up with Thijs upon his return.
- Julie to update her paper, as actioned in January

**Action:**
- Chris to follow up with Julie to get the paper updated

#### 1.2.3 Sharing Facility with the Social Investment Agency (SIA)**
- Chris reported that data sharing with the SIA is now active
- Emerge is sending NHI numbers for tāngata whaiora in two ESD services (Christchurch and Hamilton) via Wild Bamboo (the company that delivers the RecordBase CRM)
- The SIA moved the first submission date from March to late January/February to align with the IDI's three annual update cycles
- Two tāngata whaiora did not have NHI numbers in RecordBase at the time of the first submission — a separate file with name, date of birth, and gender was sent for the IDI to match
- Moana Keiper asked whether this had been reviewed from a privacy perspective and whether clients are being notified
  - Faye confirmed that data sharing is covered on the consent form that tāngata whaiora complete when they join the service
  - Chris noted that Patrick reviewed the sharing agreement before it commenced

---

## 2. Data Management Framework

## 3. Define Data Ownership

---

## 4. Define Security Measures

### 4.1 Additional Access Review

**Presenter:** Chris Negus

**Key Points:**
- Current active additional access: 70 requests (as of March 2026)
- New access granted since January meeting: 16 requests
- Access revoked/expired: 15 requests
- 7 of 16 new requests are for the KPI Dataset, many related to the release of the executive-level Key Measures report
- Average access duration: 13 months
- Access is time-limited — it does not continue permanently
- Work is underway to move partner roles (finance, quality, PX) to role-based access rather than individual additional access requests

No concerns were raised.

### 4.2 Personal Information in Self-Service Semantic Models

**Paper:** Personal Information in Self-Service Semantic Models

- This paper was discussed alongside the CoE paper (see 6.1)
- The PII-related decisions (controlled access, user accountability, baseline controls, audit trail) were not resolved individually — all decisions are deferred into the updated CoE paper

**Decision:**
- All decisions: **DEFERRED** — to be addressed in the updated CoE paper (see 6.1)

---

## 5. Ensure Privacy and Compliance

---

## 6. Facilitate Secure Data Sharing

### 6.1 Self-Service Analytics Strategy – BI Centre of Excellence

**Presenter:** Chris Negus, with support from Catherine Lim-Starling (guest)

**Papers:**
- Self Service Analytics CoE DGG Paper
- Personal Information in Self-Service Semantic Models

**Context:**
- The BI team assessed Emerge's analytics maturity against the Gartner model in 2024 and identified a BI Competency Centre (now called a Centre of Excellence) as a key gap in reaching the next level of maturity
- The goal is to enable business domain experts to create their own operational reports using data foundations built and maintained by BI, rather than all reporting going through the BI team
- The Property domain has been used as a pilot, with Catherine Lim-Starling as the first CoE member
- Catherine had no Power BI background — she learned with support from Mike Gencic and ChatGPT
- The paper proposed a Bronze / Silver / Gold reporting tier framework and sought endorsement to expand the CoE to other domains

**Catherine's Presentation:**
- Catherine walked through the Property dashboard she has built using the property semantic model
- The dashboard covers property, tenancy, occupancy, and vacancy data — designed to compare against the HUD funder dashboard
- Catherine explained that about a year ago, HUD started sharing their own dashboard with Emerge. The housing team needed a way to compare HUD's figures against Emerge's data, which was previously done through time-consuming manual pivot tables
- The dashboard also includes an audit page comparing dates between RecordBase and Waharoa to identify gaps and data quality issues — for example, missing RecordBase IDs in Waharoa, or mismatched tenancy start and end dates
- Catherine noted that the data is drawn from Waharoa and the users of the dashboard have the same access as they do in Waharoa — no additional personal information is exposed
- Anna asked whether the permissions mirror Waharoa access. Catherine and Moana Williams confirmed they do. Moana Williams gave the example of Gemma, who was unable to access the dashboard because she does not have Waharoa access
- Moana Williams explained the background: HUD had been sending wildly inaccurate data, and Catherine's manual reporting was being used to counter this. The dashboard now enables the team to push back on HUD monthly, and HUD's data is starting to align — which is helpful for the wider housing sector

**Discussion:**
- Nathan asked Catherine about her experience learning Power BI. Catherine said the knowledge gap was significant — she only understood about 40% of what Mike initially explained, but persistence and ChatGPT helped bridge the gap. She said without Mike's support she would not have been able to create the dashboard
- Nathan said the dashboard will be powerful for Kirimana phase two (contract management) when it gets to the reporting stage. He asked about where Emerge stands with validating data from other funders beyond HUD
- Anna said this highlighted the need for Qlik licences to access PRIMHD data — Te Whatu Ora's reporting does not always align with what Emerge sees in Te Pātaka. Simon Hughes has a Qlik licence, and the team has identified who else needs them. The licences are free
- Nathan asked about the criteria for CoE membership, what training and support would be provided, and what oversight exists. He noted that someone like Bala Sakthi (Senior Financial Analyst, Housing Trust) already has BI skills, while others may not
- Chris explained the three-tier workspace structure:
  - **Bronze** — where CoE members build and experiment; only visible to CoE members in that domain
  - **Silver** — shared with a targeted business audience after a review stage-gate
  - **Gold** — official Te Pātaka reports built and maintained by the BI team
- Chris noted the BI team is structured with domain-aligned analysts: Mike Gencic for property, Greg Hubbard for PX, Timi for clients, and Thijs for finance. These analysts would provide one-on-one support to CoE members in their domain
- Callum said he supports the initiative and sees it as a key step in Emerge becoming a data-driven organisation, but wants more detail on: how the BI team will support CoE members, the skill requirements for CoE roles, and how report releases from bronze to silver will be governed. He noted that AI tools like Copilot are lowering the skill barriers for Power BI, which is encouraging
- Moana Keiper praised Catherine's work and the collaboration between teams. She said she had sent an email with detailed feedback. Her concerns were around access governance, enablement, and the Privacy Act changes coming into effect in May 2026. She felt the paper needed more underlying structure before she would be comfortable endorsing expansion beyond the pilot — but said it was not far off
- Faye asked about the bronze/silver/gold tier definitions — specifically whether Catherine's report is bronze and what happens when it is shared wider. Chris confirmed Catherine is building in the bronze space and explained that a review is required before a report can move into the silver layer
- Anna agreed in principle but raised concerns about both capability and capacity — the time Catherine invested would not be available to many staff. She said the criteria for CoE membership, privacy due diligence, and confidentiality safeguards all need to be worked through
- Moana Williams noted that Catherine was not given adequate management support during the pilot and that the effort should not be treated as additional work on top of someone's normal role. She suggested the organisation needs to think about how to recognise and support CoE members properly
- Moana Keiper asked whether the organisation currently has the right capability in place, or whether specialised roles need to be created
- Anna said it is a gap in both capability and capacity
- Callum said these need to be dedicated business-embedded insight roles, not an add-on to existing work. He questioned the value of having a centre of excellence without making this business change
- Nathan said he is keen to progress in principle — comfortable with the bronze tier for key roles and wants governance built around the silver tier. He noted the capacity argument cuts both ways: people like Catherine are already spending time creating manual reports, and this approach converts that effort into something replicable. He suggested casting the net wide to include others with existing analytical skills
- Callum suggested a practical path forward: continue supporting Catherine's pilot, start the process with Vasa (PX domain) and Bala (finance), then come back to DGG with a demonstrated support model and recommendations
- Nathan agreed and said he is not concerned with making the net wider for those with appropriate skills
- Chris agreed. He acknowledged that the support structure from the business side was not something he had fully considered and said he would capture lessons learned from the Property pilot with Moana Williams. He confirmed that row-level security is baked into the data models and that the existing additional access process would be used to govern and record access to the CoE workspaces
- Chris asked whether the group endorses the CoE model. Anna suggested reframing: the group endorses the concept in principle, but the detail is needed — support model, governance stage-gates, privacy due diligence, and membership criteria
- Callum and Nathan agreed. Callum said having a framework and recommendations behind it would help the leadership team make decisions about roles and capability
- Chris said he would build this all into a single paper and bring it back

**Decision:**
- CoE model: **ENDORSED IN PRINCIPLE** — the group supports the concept and the Property pilot but requires the paper to return with:
  - BI and management support structure
  - Privacy due diligence (including May 2026 Privacy Act changes)
  - Governance stage-gates and criteria for bronze-to-silver report promotion
  - Criteria for CoE membership and access
  - Consideration of position description (PD) changes for CoE-type roles
- Bronze / Silver / Gold tier framework: **DEFERRED** — pending the updated paper
- Expansion to other domains: **DEFERRED** — pending the updated paper, but the group agreed to continuing the pilot with Catherine and beginning pilots with Vasa and Bala in the interim
- Personal information decisions (from Paper 2.2): **DEFERRED** — to be addressed in the updated paper

**Actions:**
- Chris to update the CoE paper incorporating DGG feedback (support model, governance framework, privacy due diligence, membership criteria, Moana Keiper's email feedback) and bring it back to DGG — potentially out of cycle within three weeks, or at the May meeting
- Chris to continue the Property pilot with Catherine and begin pilots with Vasa (PX domain) and Bala (Finance / Housing Trust)
- Chris to capture lessons learned from the Property pilot with Moana Williams

---

## 7. Data Validation

## 8. Enforce Data Policies

---

## 9. Updates and Any Other Business

### 9.1 Usage Metrics Update

**Presenter:** Chris Negus

**Te Pātaka Platform Usage:**
- Active users: 183 unique users in February, down 7.5% from a peak of 198 in January
- Most accessed reports:
  - Key Measures Report — 111 unique users (January: 150, down 26%)
  - Service Managers Dashboard — 65 unique users (January: 65)
  - Housing / Tenancy Dashboard — 50 unique users (January: 71, down 30%)
- New reports launched since January:
  - Key Measures Usage Report (including executive view)
  - Affordable Housing Management Statements (AHM) — Nathan clarified this report supports tenancy management reconciliation for the Housing Trust, where Emerge manages tenancies on behalf of affordable housing providers
- Upcoming reports:
  - Annual Impact Report
  - Updated Service Information
  - Referral Report
  - Fire Incident Consolidated Report
  - Automating WebExpenses and credit card fraud reports
- Highest user since January: Verity with 496 page clicks
- Anna asked whether EcoPortal data is in the data warehouse — Chris confirmed it has been partially loaded as part of the Fire Incident report. Callum noted that not all EcoPortal data (e.g., products) has been brought in yet

### 9.2 Other Items

- Chris noted he would like to bring more external guests to future DGG meetings, following the positive experience of having Catherine present at this meeting

---

## 10. Next Meeting

- Thursday, 14 May 2026 (1:05 PM – 2:20 PM)

---

---

### Actions Summary

| # | Owner | Action | Target |
|---|-------|--------|--------|
| 1 | Chris Negus | Update the CoE paper incorporating DGG feedback (support model, governance framework, privacy due diligence, membership criteria, Moana Keiper's email feedback) and bring back to DGG | Within 3 weeks or May meeting |
| 2 | Chris Negus | Continue the Property pilot with Catherine and begin pilots with Vasa (PX) and Bala (Finance / Housing Trust) | Ongoing |
| 3 | Chris Negus | Capture lessons learned from the Property pilot with Moana Williams | Before updated paper |
| 4 | Chris Negus | Follow up with Julie to get the tāngata whaiora names paper updated | Before May meeting |
| 5 | Chris Negus | Follow up with Thijs, about the hover being enabled to show the client names for approved people. | Before May meeting |
| 6 | Stefen Hasselberg | Return to DGG with the updated HumanForce masking paper | May meeting |

---

### Closing Karakia

*Kua mutu ā mātou mahi* (Our work has finished)
*Mō tēnei wā* (for this time)
*Manaakitia mai mātou katoa* (Bless/Care for us all)
*O mātou hoa* (our colleagues)
*O mātou whanau* (our families)
*Aio ki te Aorangi* (Peace be the universe)
