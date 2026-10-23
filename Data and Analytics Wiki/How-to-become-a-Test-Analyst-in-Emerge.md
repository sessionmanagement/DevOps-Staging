       
**1. Bug Ticket Title Naming Convention**
A clear naming convention helps organize bug tickets and makes them easier to scan. Since most tools can sort tickets by title, a consistent pattern is very useful.
**Simple format example:**  
[App Name] – [Module/Feature] – [Problem]
This is just a starting point—feel free to adapt the format to suit your project. The main goal is to keep tickets consistent and easy to find.

* * *

**2. Test Case Grouping Convention**
Group test cases by **features or modules**. This makes test runs more structured and reusable. For example, when running regression tests, you can select an entire module and include all its related test cases in one run.
Just like with naming conventions, there’s no single best way for every project. Start by grouping by feature, then refine as you learn what works best.

* * *

**3. Reproduction Steps for Reporting Bugs**
If a bug can’t be reproduced, it won’t be fixed, it will be swept under the carpet. Always include **clear, step-by-step instructions** for how to trigger the issue. At a minimum, add reproduction steps and screenshots (or recordings) in the ticket’s comments or attachments.
Use the comment section to track updates, findings, and progress as you continue investigating.

* * *

**4. Severity (To go the extra mile, if your tool provides this option)**
Mark each bug with an appropriate severity level. To keep it simple, start with two categories:
*   **Critical** – A core function is broken. If it fails, users cannot perform essential tasks (deal-breaker). Especially the day-to-day tasks.
*   **Non-Critical** – The issue affects less frequently used features. It doesn’t block users from completing their work, so it can be fixed later.
This helps the team prioritize effectively.

* * *

**5. Other Testing Practices**
*   **Record environment details** (app version, browser, OS) in the ticket.
*   **Attach screenshots or recordings** to support your findings. Better than solely rely on text descriptions.
*   **Test beyond the “happy path”**—always include at least one edge case (Unhappy paths the developers don’t think of).
*   **Re-test fixed bugs** to confirm they’re resolved and haven’t broken anything else. MUST!
*   **Try exploratory testing** in addition to scripted test cases—it often uncovers surprises. (Optional, you might find surprises.)
*   **Communicate factually and neutrally.** Avoid blame or personal language like “you/your.” Stick to what happened, not who caused it. Using “you/your” might trigger the developers’ ego, which put them in self-defensive mode.
*   **Define “done.”** Agree on what must pass before testing can be considered complete - The level you are happy to sign off.