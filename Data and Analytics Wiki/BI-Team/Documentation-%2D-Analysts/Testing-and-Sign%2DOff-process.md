###Business Intelligence Testing and Sign-off process for data and reports

To ensure high quality data products with minimal issues, regularly testing both our datasets and reports is crucial.


## Testing  datasets
Testing PowerBI datasets is crucial to ensure they perform reliably and deliver accurate data. We focus on four types of testing for our datasets.
<b>1.</b> Data Integrity Testing: Verify that the data is clean, consistent, and accurate.
<b>2.</b> Functional Testing: Ensure all dataset features work as expected.
<b>3.</b> Integration Testing: Check that the dataset interacts smoothly with other data sources and systems.
<b>4.</b> Performance Testing: Confirm that the dataset can handle the required load and responds quickly. These testing steps are essential to make sure the dataset supports the PowerBI report effectively and meets users' expectations.



<details>
<summary><b>Flow chart</b></summary>

::: mermaid
graph TD
 classDef testing fill:#ADD8E6,stroke:#000000,stroke-width:2px;
 classDef development fill:#D8BFD8,stroke:#000000,stroke-width:2px;
 classDef decision fill:#FFFFE0,stroke:#000000,stroke-width:2px;
 classDef delivery fill:#90EE90,stroke:#000000,stroke-width:2px;
 

subgraph Legend
    direction LR
    style Legend fill:none, stroke:none
        A1[<b>Testing</b>]:::testing
        A2[<b>Development</b>]:::development
        A3{<b>Decision</b>}:::decision
        A4[<b>Delivery</b>]:::delivery
    end
:::


::: mermaid
graph TD
    style A fill:#D8BFD8,stroke:#000000,stroke-width:2px
    style I fill:#ADD8E6,stroke:#000000,stroke-width:2px
    style K fill:#FFFFE0,stroke:#000000,stroke-width:2px
    style B fill:#ADD8E6,stroke:#000000,stroke-width:2px
    style G fill:#FFFFE0,stroke:#000000,stroke-width:2px
    style H fill:#90EE90,stroke:#000000,stroke-width:2px

    A[Build Dataset] --> I[Functional Testing]
    I -- Feedback --> A
    I --> K{Has functional testing passed <br> and <br> is dataset ready for final testing?}
    K -- No --> A
    K -- Yes --> B[Final Testing Checklist]
    B --> G{All Tests Passed?}
    G -- Yes --> H[Deliver Dataset]
    G -- No --> A
::: 


</details>




  
<details>
<summary><b>Final Dataset Testing Checklist</b></summary>

1. **Data Integrity Testing**
   - **Data Accuracy:**
     - [ ] Compare key metrics and figures from the semantic model against a trusted source to ensure accuracy.
     - [ ] Verify that no data is missing, duplicated, or incorrectly aggregated during the import process.
     - [ ] Compare aggregated data at different levels (e.g., daily, monthly, yearly) between the source system, Operational Data Store (ODS), and Enterprise Data Warehouse (EDW) to ensure consistency.
   - **OPTIONAL - Fact and Dimension Table Comparison:**
     - [ ] Compare Fact tables with Dimension tables to ensure all foreign keys/IDs in the Fact table have corresponding entries in the Dimension table.

2. **Functional Testing**
   - **Dataset Validation:**
     - [ ] Test the dataset to ensure all fields, tables, and relationships function as specified in the requirements.
   - **Hierarchies and Grouping:**
     - [ ] Test hierarchies and grouping structures to ensure they allow for correct drill-down and roll-up functionality.

3. **Integration Testing**
   - **Table Relationships:**
     - [ ] Verify that relationships between tables in the data model are correctly defined and functioning.
     - [ ] Test one-to-many and many-to-many relationships to ensure they behave as expected.
   - **Joins:**
     - [ ] Test join conditions between tables to ensure they return correct and complete data.
   - **Data Model Integrity:**
     - [ ] Ensure that the overall data model structure supports the intended reporting and analytics use cases.

4. **Performance Testing**
   - **Dataset Refresh Performance:**
     - [ ] Make sure the time taken to refresh the dataset is acceptable.
     - [ ] Test the dataset with data refreshes to confirm that it accurately reflects the most current data.
     - [ ] Ensure that any scheduled refreshes function as expected without errors.
   - **Responsiveness:**
     - [ ] Evaluate the responsiveness of the dataset when used to create visuals in PowerBI.

</details>




## Testing reports
Testing our PowerBI reports is key to delivering a quality product that meets the customer's needs. Our testing can be divided in three parts.
<b>1.</b> By following an agile approach, we involve stakeholders in regular testing sessions throughout the development process. This helps us identify issues early and allows for continuous feedback. As we aim to regularly share different iterations of the report with key stakeholder we ensure features work as intended and the user is able to double-check that the data is accurate. 
<b>2.</b> In most instances, regular peer reviews on specific visuals or calculations from other analysts also helps us to stay on track and deliver a quality product. 
<b>3.</b> Finally, comprehensive testing is required before release to make sure everything is correct and ready to go.

Below you can find a flow chart of the testing process and a checklist to use when performing the final review before release. 

<details>
<summary><b>Flow chart</b></summary>

::: mermaid
graph TD
 classDef testing fill:#ADD8E6,stroke:#000000,stroke-width:2px;
 classDef development fill:#D8BFD8,stroke:#000000,stroke-width:2px;
 classDef decision fill:#FFFFE0,stroke:#000000,stroke-width:2px;
 classDef delivery fill:#90EE90,stroke:#000000,stroke-width:2px;
 

subgraph Legend
    direction LR
    style Legend fill:none, stroke:none
        A1[<b>Testing</b>]:::testing
        A2[<b>Development</b>]:::development
        A3{<b>Decision</b>}:::decision
        A4[<b>Delivery</b>]:::delivery
    end
:::


::: mermaid
graph TD
    style A fill:#D8BFD8,stroke:#000000,stroke-width:2px
    style I fill:#ADD8E6,stroke:#000000,stroke-width:2px
    style J fill:#ADD8E6,stroke:#000000,stroke-width:2px
    style K fill:#FFFFE0,stroke:#000000,stroke-width:2px
    style B fill:#ADD8E6,stroke:#000000,stroke-width:2px
    style G fill:#FFFFE0,stroke:#000000,stroke-width:2px
    style H fill:#90EE90,stroke:#000000,stroke-width:2px

    A[Build Report] --> I[User Acceptance Testing]
    I -- Feedback --> A
    J -- Feedback --> A
    A --> J[Peer Review]
    I --> K{Has UAT testing passed <br> and <br> is report ready for final testing?}
    K -- No --> A
    K -- Yes --> B[Final Testing Checklist]
    B --> G{All Tests Passed?}
    G -- Yes --> H[Deliver Report]
    G -- No --> A
::: 


</details>



<details>
<summary><b>Final Report Testing Checklist</b></summary>

1. **Data Integrity Testing**
   - **Data Accuracy:**
     - [ ] Validate that all figures, calculations, and summaries in the report match the source data.
     - [ ] Cross-check totals, averages, percentages, and other metrics against known values or manual calculations.
   - **Data Consistency:**
     - [ ] Ensure consistency in data presentation across different report pages, visuals, and filters.
     - [ ] Verify that aggregated data matches detailed data when drilling down into reports.
     - [ ] Ensure data consistency across different reports. Check any reports that report on the same dataset to ensure numbers match between reports.
   - **Data Refresh and Updates:**
     - [ ] Test the report with data refreshes to ensure the latest data is correctly displayed.
     - [ ] Validate that scheduled refreshes run as expected and reflect accurate data.

2. **Functional Testing**
   - **Report Functionality:**
     - [ ] Verify that all report features (e.g., drill-throughs, cross-highlighting) work as intended.
     - [ ] Test user interactions with visuals, ensuring that they respond correctly to selections and changes.
   - **Filter and Slicer Functionality:**
     - [ ] Check that all filters and slicers work correctly, updating the visuals and data as expected.
     - [ ] Ensure that default filter selections are appropriate and meaningful for the report’s purpose.
   - **Security:**
     - [ ] Test the report’s Row-Level Security (RLS) to ensure it is working correctly.
     - [ ] Validate that the report is shared with the right audience and that permissions are set correctly.

3. **Integration Testing**
   - **Data Source Integration:**
     - [ ] Ensure that the report is correctly connected to data sources published to ‘Production’.
   - **Cross-Report Interactions:**
     - [ ] If applicable, test interactions between pinned dashboard visuals to ensure smooth navigation.

4. **Performance Testing**
   - **Report Load Time:**
     - [ ] Make sure the time taken for the report to load fully is acceptable.
   - **Visual and Query Performance:**
     - [ ] Evaluate the performance of individual visuals and ensure they render quickly without delays.

5. **User Interface Testing**
   - **UI Consistency and Design:**
     - [ ] Ensure that the report’s design is consistent with the branding guidelines.
     - [ ] Validate the alignment, size, and positioning of all visuals, text, and elements.
   - **User Experience (UX):**
     - [ ] Test the ease of navigation and the intuitiveness of the report’s layout.
     - [ ] Gather user feedback on the report’s usability and make necessary adjustments.
   - **Cross-Platform Testing:**
     - [ ] Verify that the report displays correctly on different devices (e.g., desktop, tablet, mobile).
     - [ ] Ensure the report is compatible with different screen sizes and resolutions.

</details>

