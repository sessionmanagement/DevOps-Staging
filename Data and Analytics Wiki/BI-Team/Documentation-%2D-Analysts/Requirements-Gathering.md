
**Introduction**
Requirements gathering is the process where the developer and key stakeholders of a new data product agree on functionality, design, audience and other acceptance criteria. Depending on the size of the project these can be captured in a more formal format or captured in the feature or user story in DevOps. For examples of how to write features and user stories please see the [BI Team Azure DevOps Wiki v2](/BI-Team/Documentation-%2D-Analysts/BI-Team-Azure-DevOps).

**Purpose**
The purpose of gathering the requirements for a new data product is to ensure the end product delivers the expected value to the customer. Defining what the customer needs and aligning this with what is possible from a technical perspective ensures development effort matches the added value. 

**How**
Requirements are gathered and refined through regular meetings with stakeholders. The following steps are recommended when gathering requirements: 
1.	Initial meeting to discuss needs, pain points and understand added value of the new product. Here is a [list of possible questions to ask](https://emergeaotearoaltd.sharepoint.com/:w:/r/sites/OPS_ITServices/Shared%20Documents/Data%20and%20Analytics/_New%20Structure/Documentation/Requirements/Ideas%20for%20requirements%20gathering.docx?d=w5a3a60d5c9f64924beb68c5153622996&csf=1&web=1&e=eBdHAd).
2.	Explore options. What can we deliver? What data is available? Summarise findings in an initial requirements document
3.	Follow-up meeting to discuss possibilities. Make sure all limitations are clearly communicated to set expectations and allow the customer to decide whether the proposed product will meet requirements.  
4.	If the customer is happy with the expected outcome, write a more detailed requirements document. Here is a link to [the requirements template](https://emergeaotearoaltd.sharepoint.com/:w:/r/sites/OPS_ITServices/Shared%20Documents/Data%20and%20Analytics/_New%20Structure/Documentation/Requirements/Requirements%20Template.docx?d=w5e178c0e270e46678851ccfdfadf7d2c&csf=1&web=1&e=rODS5p). 
Detailed requirement documents can be saved in the following folder: 
<i> OneDrive - Emerge Aotearoa\General - Data & Reporting Collaboration\Business Intelligence\Requirements Gathering </i>
5.	Final requirements meeting to discuss the requirements document and get sign-off. 
As part of the Agile way of working, requirements are allowed to change if reasonable. What reasonable is depends on the impact and added value of the change requested. Regular releases of the product should be provided to the customer to allow user testing and feedback during the development of the end product. 

**When**
Requirements should be gathered at that start of the development process. The initial requirements meeting should be held before any development has taken place. If necessary, a draft or demo version can be taken to a follow-up meeting to show the customer what is possible. 
# 

<details>
<summary><b>Process Overview</b></summary>

Here's a high-level overview of our requirements gathering process:

::: mermaid
graph TD
 classDef meet fill:#ADD8E6,stroke:#000000,stroke-width:2px;
 classDef write fill:#FFFFE0,stroke:#000000,stroke-width:2px;
 classDef Dev fill:#D8BFD8,stroke:#000000,stroke-width:2px;
 classDef Delivery fill:#90EE90,stroke:#000000,stroke-width:2px;
 
subgraph Legend
    direction LR
    style Legend fill:none, stroke:none
        A1[<b>Meeting</b>]:::meet
        A2[<b>Write Requirements</b>]:::write
        A3[<b>Data Request</b>]:::Dev
        A4[<b>Delivery</b>]:::Delivery
    end
:::

::: mermaid
graph TD
    style A fill:#FCD299;,stroke:#000000,stroke-width:2px
    style B fill:#ADD8E6,stroke:#000000,stroke-width:2px
    style C fill:#FFFFE0,stroke:#000000,stroke-width:2px
    style D fill:#ADD8E6,stroke:#000000,stroke-width:2px
    style E fill:#FFFFE0,stroke:#000000,stroke-width:2px
    style F fill:#ADD8E6,stroke:#000000,stroke-width:2px
    style G fill:#90EE90,stroke:#000000,stroke-width:2px
    style H fill:#D8BFD8,stroke:#000000,stroke-width:2px

A(Analyst is assigned to develop data product) -->|Identifies key stakeholders and users| B[Analyst has initial requirements <br> meeting  with key stakeholders]
B -->|Explore options| C[gap analysis and <br> write initial requirements document]
C -->|Required data is available| D[Analyst has follow-up meeting <br> with key stakeholders]
C -->|Additional data is required| H(Log data request with BI devs)
H -->|Additional data is provided| C
D -->|Limitations and possibilities are clearly defined| E[Analyst writes detailed requirements document]
E --> | | F(Analyst meets with stakeholders <br> to discuss details and get sign-off)
F -->|No sign off| E[Analyst writes detailed requirements document]
F -->|Sign off| G(Requirements are agreed on and signed off)


:::

</details>