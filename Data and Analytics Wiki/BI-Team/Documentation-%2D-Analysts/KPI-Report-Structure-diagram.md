

::: mermaid
graph LR
    subgraph Report
        HOME[Key Measure Home Page]
    end

    subgraph Dashboards - SFA Level
        SL[Service Leaders Dashboard]
        ML[Manager of Leaders Dashboard]
        MM[Manager of Managers Dashboard]
        EX[Exec & Senior Leaders Dashboard]
    end

    subgraph Drivers_SL["Drivers - SL"]
        SL_D1[SL Driver 1]
        SL_D2[SL Driver 2]
        SL_D3[SL Driver 3]
    end

    subgraph Drivers_ML["Drivers - ML"]
        ML_D1[ML Driver 1]
        ML_D2[ML Driver 2]
        ML_D3[ML Driver 3]
    end

    subgraph Drivers_MM["Drivers - MM"]
        MM_D1[MM Driver 1]
        MM_D2[MM Driver 2]
        MM_D3[MM Driver 3]
    end

    subgraph Drivers_EX["Drivers - EX"]
        EX_D1[EX Driver 1]
        EX_D2[EX Driver 2]
        EX_D3[EX Driver 3]
    end

    subgraph DetailPages["Detail Pages per Persona per Entity"]
        SL_K[SL - Kaimahi]
        SL_S[SL - Service]
        SL_R[SL - Referral]
        SL_P[SL - Property]
        SL_T[SL - Tenancy]

        ML_K[ML - Kaimahi]
        ML_S[ML - Service]
        ML_R[ML - Referral]
        ML_P[ML - Property]
        ML_T[ML - Tenancy]

        MM_K[MM - Kaimahi]
        MM_S[MM - Service]
        MM_R[MM - Referral]
        MM_P[MM - Property]
        MM_T[MM - Tenancy]

        EX_K[EX - Kaimahi]
        EX_S[EX - Service]
        EX_R[EX - Referral]
        EX_P[EX - Property]
        EX_T[EX - Tenancy]
    end

    HOME --> SL & ML & MM & EX

    SL --> SL_D1 --> SL_K & SL_S & SL_R & SL_P & SL_T
    SL --> SL_D2 --> SL_K & SL_S & SL_R & SL_P & SL_T
    SL --> SL_D3 --> SL_K & SL_S & SL_R & SL_P & SL_T

    ML --> ML_D1 --> ML_K & ML_S & ML_R & ML_P & ML_T
    ML --> ML_D2 --> ML_K & ML_S & ML_R & ML_P & ML_T
    ML --> ML_D3 --> ML_K & ML_S & ML_R & ML_P & ML_T

    MM --> MM_D1 --> MM_K & MM_S & MM_R & MM_P & MM_T
    MM --> MM_D2 --> MM_K & MM_S & MM_R & MM_P & MM_T
    MM --> MM_D3 --> MM_K & MM_S & MM_R & MM_P & MM_T

    EX --> EX_D1 --> EX_K & EX_S & EX_R & EX_P & EX_T
    EX --> EX_D2 --> EX_K & EX_S & EX_R & EX_P & EX_T
    EX --> EX_D3 --> EX_K & EX_S & EX_R & EX_P & EX_T
:::