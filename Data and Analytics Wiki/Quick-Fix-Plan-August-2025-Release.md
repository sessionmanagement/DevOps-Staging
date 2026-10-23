       
1. **Preparation (Before Starting):**
    *   Check the update log or ask Theta directly to identify what has been changed. Note the areas of Business Central (BC) affected by the update that require extra attention during testing.
    *   Review the test sheets (test scripts) provided by Datacom. Update the test sheets and test steps, if necessary, to reflect changes to existing workflows. Add any new workflows introduced by the update.
2.  **Prioritize Tests in Two Levels (Before Starting):**
    *   Critical: The most frequently used workflows, areas, or modules that are essential to daily operations. (You _do not_ want these areas of BC to fail!)
    *   Non-Critical: Workflows, areas, or modules that are used less frequently—perhaps only once or twice a month.
3.  **Explore Unexpected Inputs (During Testing):**
    *   Test text fields with unexpected inputs to ensure errors are handled gracefully (e.g., long text, numbers in a name field, etc.).
    *   Explore other workflows, areas, or modules outside your regular tasks. View these from a fresh perspective—you might uncover issues that someone familiar with the workflow might overlook.
4.  **Log All Bugs in Azure DevOps Consistently (During Testing):**
    *   For **every bug**, include:  
        a) A screenshot or video that clearly shows the issue.  
        b) Step-by-step instructions to replicate the problem.  
        c) A tag or note specifying the version number of the release. If possible, include the specific extension name.
    *   Bugs that **cannot be** **reproduced** are unlikely to get attention.
    *   Avoid reporting bugs via email. All bugs should be logged in Azure DevOps. If a bug is urgent, mark it clearly in the title (e.g., “URGENT”).
5.  **Quick Meeting (After Testing):**
    *   Hold a brief session to share findings with the team. Discuss:
        *   Issues identified in others' workflows, areas, or modules.
        *   Any missing test scenarios or areas requiring retesting.
        *   Points of confusion, unexpected results, and successful outcomes.
    *   Use this time to create Azure DevOps tickets collectively, if it simplifies the process.
    *   Arrange standups with Theta.  
        

**Glossary**
_Workflow_ - A workflow is a step-by-step process or series of tasks that a person or team follows to complete a specific job or activity. It shows how work moves from one stage to the next, ensuring that tasks are done in the right order and by the right people.
_Standups_ - Standups are short, daily meetings where team members quickly share updates on what they’re working on, any barriers they’re facing, and what they plan to do next. These meetings are meant to keep everyone aligned and are usually less than 15 minutes long.
_Update log_ - An update log is a document or list that records details about changes or improvements made to a system, software, or process. It includes information like what was changed, when it was changed, and why, helping users focus on areas impacted by the updates.
**Azure DevOps - bug ticket example**  
![==image_0==.png](/.attachments/==image_0==-1d02754c-d0b0-4818-8be6-62620197c99a.png) 