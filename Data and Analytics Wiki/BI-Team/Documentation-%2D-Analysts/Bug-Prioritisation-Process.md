**Introduction**

Effectively managing Bugs within a sprint is crucial to ensuring the overall quality of any product. 
This document outlines a systematic approach to handling bugs based on their priority levels: Urgent, High, Medium, and Low. It provides guidance on how to address each type during a sprint and offers best practices for maintaining productivity and meeting sprint goals.

 **Understanding Bug Prioritisation**
- Always prioritize bugs based on their impact on the product and the users. Urgency and priority should dictate the order in which bugs are addressed.
- Clear and continuous communication with the team and stakeholders regarding bug status and progress is essential.
- Include a discussion on bug management in sprint retrospectives. Review what went well, what could be improved, and how the team can better handle bugs in future sprints.

**Prioritisation**

1.	Urgent: Bugs that must be addressed immediately due to their critical impact on the system or product.  Urgent Bugs relate to any report in the Production Platform (Te Pataka)
2.	High Priority: Bugs that have a significant impact but do not require immediate action. They are crucial to the product's operation or user experience but can be fixed within the sprint without causing major disruptions.  
3.	Medium Priority: Bugs that have a moderate impact on the product but are not critical. They can be deferred to the next sprint without severe consequences.
4.	Low Priority: Bugs with minimal impact, often cosmetic or minor usability issues. These bugs can be logged in the backlog and addressed in future sprints as time allows.

**Handling Urgent Bugs**
1. Immediate action is required. This involves quickly assessing the impact, scope, and root cause of the bug.
1. Reassign team members or adjust current sprint tasks to focus on fixing the urgent bug. The goal is to resolve the issue as quickly as possible to minimise disruption.
1. Ensure that the team understands the urgency and prioritises this task above all else.
1. Keep the team and stakeholders informed about progress.   
1. Once the fix is implemented, conduct thorough testing to ensure the bug is resolved and no new issues have been introduced.
1. After the bug is fixed, perform a root cause analysis to understand how the bug occurred and how similar issues can be prevented in the future.  
1. Document the bug, the fix, and the steps taken to resolve it. This helps in building a knowledge base for the team and avoiding future occurrences.

**Handling High Priority Bugs**

1. High priority bugs should be included in the current sprint if possible.  (Communication between Bug Master and Scrum Master is essential).  They should be prioritised after any urgent bugs and other work.  If high priority bug is scheduled for the next sprint, it should be prioritised over other work.  

1. Collaborate with the team to fix the bug efficiently. If the bug affects multiple areas, involve team members with relevant expertise.  
1. See steps 4 to 7 from Handling Urgent Bugs.

**Handling Medium Priority Bugs**
1. Deferred to Next Sprint. Consultation between Bug Master and Scrum Master is essential.  These bugs should be prioritised during sprint planning.

1. Use steps 3 to 7 from Handling Urgent Bugs.

 **Handling Low Priority Bugs**
- Low priority bugs should be documented in the backlog. 
- Ensure they are clearly categorised and include all necessary details for future reference.  Again consultation between Bug Master and Scrum Master is essential.  The Scrum Master is responsible for managing low priority bugs. 
- The Scrum Master should periodically review low priority bugs to determine if any need to be reprioritised or if they can be bundled with other tasks.

::: mermaid
graph TD
    A[Email BI Tasks] --> D{Is the bug Related to Databases}
    B[Pae Awhina] --> D
    C[Email Personal] --> D
    E[Hui conversations] --> D
    F[BI Team] --> D
    
    D -->|Yes| G{          Is <br>it <br> Published?         }
    D -->|No| H{     Is the bug            Related to       Reports}
    
    H -->|Yes| G
    H -->|No| I{Is it <br> Urgent or High Priority}
    
    G -->|Yes| J[Create User Story <br> for current sprint <br> alert Scrum master]
    G -->|No| I
    
    I -->|Yes| J
    I -->|No| K{Is it <br> Medium or low Priority}
    
    K -->|Yes| L[Create User Story <br> for next sprint <br> alert Scrum master to prioritise]
    K -->|No| M[Create User Story <br> for backlog sprint <br> alert Scrum master to prioritise]

    %% Apply colors
    style A fill:#88ccee,stroke:#000,stroke-width:2px
    style B fill:#88ccee,stroke:#000,stroke-width:2px
    style C fill:#88ccee,stroke:#000,stroke-width:2px
    style E fill:#88ccee,stroke:#000,stroke-width:2px
    style F fill:#88ccee,stroke:#000,stroke-width:2px
    
    style D fill:#ddcc77,stroke:#000,stroke-width:2px
    style H fill:#ddcc77,stroke:#000,stroke-width:2px
    style I fill:#ddcc77,stroke:#000,stroke-width:2px
    style K fill:#ddcc77,stroke:#000,stroke-width:2px
    
    style G fill:#d55e00,stroke:#000,stroke-width:2px
    style J fill:#cc66b4cc,stroke:#000,stroke-width:2px
    style L fill:#cc66b4cc,stroke:#000,stroke-width:2px
    style M fill:#cc66b4cc,stroke:#000,stroke-width:2px
:::

