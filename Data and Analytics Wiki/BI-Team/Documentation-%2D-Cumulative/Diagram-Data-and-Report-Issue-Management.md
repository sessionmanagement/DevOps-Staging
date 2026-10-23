::: mermaid
graph TD
    A[Issue Identified] --> B["Post in BI Teams Chat<br/>(Team Member)"]
    B --> PA{Existing Ticket?}
    PA -->|No| PB["Create Pae Awhina Ticket<br/>(Team Member or Bug Master)"]
    PA -->|Yes| C
    PB --> C["Create Azure DevOps Bug<br/>(Team Member)"]
    
    C --> D["Review & Classify Issue<br/>(Bug Master)"]
    D --> E{Issue Type?}
    
    E -->|BI Space| F["Assign to Lead Data Analyst<br/>(Bug Master)"]
    E -->|Data Level| G["Assign to Lead Data Engineer<br/>(Bug Master)"]
    E -->|Combined| H["Joint Assignment<br/>(Bug Master)"]
    
    F --> I["BI Investigation<br/>(Lead Data Analyst)"]
    G --> J["Data Investigation<br/>(Lead Data Engineer)"]
    H --> K["Joint Investigation<br/>(Both Leads)"]
    
    I & J & K --> L{Resolved by 8:30 AM?}
    
    L -->|Yes| RESOLVED["Document Resolution<br/>(Assigned Lead)"]
    L -->|No| N["Coordinate Initial Email<br/>(Bug Master)"]
    
    N --> O{Determine Severity}
    
    O -->|Level 1<br/>Critical| P[Critical Response]
    O -->|Level 2<br/>High| Q[High Priority]
    O -->|Level 3<br/>Medium| R[Standard Response]
    
    P --> S["Immediate Escalation<br/>(Bug Master → BI Manager)"]
    
    Q --> T{2 Hours Without Resolution?}
    R --> U{1 Business Day Without Resolution?}
    
    T -->|Yes| V["Escalate Communication<br/>(Bug Master → Scrum Master)"]
    T -->|No| CONTINUE1["Continue Investigation<br/>(Assigned Lead)"]
    
    U -->|Yes| V
    U -->|No| CONTINUE2["Continue Investigation<br/>(Assigned Lead)"]
    
    V --> W{Need Further Escalation?}
    W -->|Yes| X["Escalate to BI Manager<br/>(Scrum Master → BI Manager)"]
    W -->|No| CONTINUE3["Continue Investigation<br/>(Assigned Lead)"]
    
    S & X & CONTINUE1 & CONTINUE2 & CONTINUE3 --> Y["Continue Investigation<br/>(Assigned Lead + Team)"]
    
    Y --> Z{Solution Found?}
    Z -->|Yes| AA["Implement Fix<br/>(Assigned Lead)"]
    Z -->|No| AB["Deep Investigation<br/>(Lead + Team)"]
    
    AA & AB --> AC["Testing & Validation<br/>(Assigned Lead)"]
    AC --> AD["Update Pae Awhina<br/>(Bug Master or Assigned Lead)"]
    AD --> AE["Coordinate Resolution Email<br/>(Bug Master)"]
    AE --> AF["Document in DevOps<br/>(Assigned Lead)"]
    AF --> AG["Close Pae Awhina Ticket<br/>(Bug Master or Assigned Lead)"]
    AG --> AH["Post-Incident Review<br/>(Team + Manager)"]
    
    RESOLVED --> AD
    
    %% Style definitions
    style A fill:#ffcccc,stroke:#333,stroke-width:2px
    style N fill:#ffffcc,stroke:#333,stroke-width:2px
    style AE fill:#ccffcc,stroke:#333,stroke-width:2px
    style P fill:#ffb3b3,stroke:#333,stroke-width:2px
    style S fill:#ff6666,stroke:#333,stroke-width:2px
    style V fill:#ffe4b5,stroke:#333,stroke-width:2px
    style X fill:#ffb6c1,stroke:#333,stroke-width:2px
    style AA fill:#90ee90,stroke:#333,stroke-width:2px
    style AC fill:#90ee90,stroke:#333,stroke-width:2px
    style RESOLVED fill:#90ee90,stroke:#333,stroke-width:2px
    style AH fill:#ccccff,stroke:#333,stroke-width:2px
    
    %% Communication Chain Annotation
    N -.->|Comm Owner| CM1["Bug Master<br/>(coordinates)"]
    V -.->|Comm Owner| CM2["Scrum Master<br/>(takes over)"]
    X -.->|Comm Owner| CM3["BI Manager<br/>(final owner)"]
:::