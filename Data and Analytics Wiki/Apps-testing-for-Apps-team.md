# Problems
Vendors are delivering unstable software to Emerge. The Apps team currently has no structured testing process to prevent these unreliable releases from reaching end users (support workers, property managers, etc.).

# Tooling
- Fresh Service Project - Test Repo
- Pae Awhina - Ticketing

# Proposed Resources
**Who runs the tests?**
- Apps team  
- Functional analysts  

**Who manages the test repository?**
- Testers  

The **Apps team** and **functional analysts** know the applications well, but they are not professional testers.  
**Testers** know testing best practices, but not the applications in depth.  

To bridge this gap, testers should work with the apps team and functional analysts to build a **test case repository**. This repository will contain organized sets of test cases that the apps team and analysts can run—either manually or through automation.

# Proposed Processes
### Testing Workflow
Vendor → Tester → Apps Team → Functional Analysts → End Users  

1. **Vendor** provides a release note outlining new features and changes.  
2. **Tester** updates the test repository if required and advises the apps team on which test cases to run (targeted or full regression).  
3. **Apps team** runs the test cases:  
   - If all pass → approve and move forward.  
   - If bugs are found → fail, report issues, and follow the bug reporting workflow.  
4. **Functional analysts** perform UAT (user acceptance testing) or run a full regression test:  
   - If all pass → approve and deploy to end users.  
   - If bugs are found → fail, report issues, and follow the bug reporting workflow.  
5. **End users** receive a stable and tested deployment.

### Bug Reporting Workflow
Vendor ← Tester / Apps Team ← Functional Analysts / End Users  

1. **Functional analysts or end users** are often the first to notice bugs. They report these issues to the tester or apps team.  
2. **Tester** ensures high-quality bug reports (screenshots, recordings, reproduction steps, severity, etc.) and creates tickets in Fresh Work (Pae Awhina). Testers should also mentor the apps team in good ticketing practices. Over time, the tester moves into more of an advisory role while maintaining the test repository.  
3. **Apps team** gradually adopts best practices and manages bug tickets in Pae Awhina.  
4. **Vendor** receives the tickets in their own system (e.g., Azure DevOps, ZenDesk), fixes the bugs, and issues a hotfix or new release, which then goes back through the testing workflow.

# Ticketing System
All bug tickets should be tracked, internally, in **Pae Awhina**, which acts as the single source of truth across all applications (e.g., Recordbase, Waharoa, Human Force).  

This will create some duplication, since vendors use their own systems (Azure DevOps, ZenDesk, etc.). However, Pae Awhina ensures all issues are captured and tracked consistently in one place. (Open to exploring ways to reduce duplication.)

# New Features
When end users or functional analysts suggest new features, the request can follow the same workflow as bug reporting.  
- The end users or functional analysts logs the request in Pae Awhina.
- The tester or apps team amend technical detail in the request in Pae Awhina for better technical conversation.  
- Later, these can be raised with the vendor for consideration.  
