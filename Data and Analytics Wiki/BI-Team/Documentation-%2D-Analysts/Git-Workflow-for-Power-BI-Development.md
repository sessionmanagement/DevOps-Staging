
## Table of Contents

- [Introduction to Git](#introduction-to-git)
- [Understanding Git: The Basics](#understanding-git-the-basics)
- [Git Folders: A Different Approach](#git-folders-a-different-approach)
- [Git Workflow: Step by Step](#git-workflow-step-by-step)
- [Review for Pull Request](#review-for-pull-request)
- [Creating a Pull Request](#creating-a-pull-request)
- [Resolving Merge Conflicts](#resolving-merge-conflicts)
- [Git Workflow Checklist](#git-workflow-checklist)
- [Git Workflow Process Flow](#git-workflow-process-flow)
- [Glossary of Git Terms](#glossary-of-git-terms)

## Introduction to Git

Before adopting Git, our team faced challenges when collaborating on Power BI reports and semantic models:

- Multiple versions of reports (e.g., "Report v1.pbix", "Report v2.pbix")
- Difficulty tracking the most up-to-date version
- Inability for multiple analysts to work simultaneously without overwriting changes

To address these issues and improve our collaboration, we've implemented Git, a version control system that solves these problems and enhances our workflow.

Using Git integration with Power BI offers several benefits:

- **Version control**: Track changes to your reports and datasets over time, allowing you to revert to previous versions if needed.
- **Collaboration**: Work together with your team on the same project, merging changes and resolving conflicts as needed.
- **Traceability**: Link your commits to user stories in Azure DevOps, making it easy to track the progress of your work.

## Understanding Git: The Basics

Git is a powerful tool that enables multiple analysts to work on the same project simultaneously without risking overwritten changes. It maintains a complete history of all changes made to project files.

### Repositories: The Central Hub

- A repository (or "repo") is the central storage location for project files and their entire version history.
- It serves as a hub where team members can access and contribute to the project.

### Branches: Independent Workspaces

- Branches are independent workspaces for managing different versions of your project.
- They allow multiple analysts to work on the same Power BI report or semantic model concurrently without interference.

### Commits: Saving Your Changes

- Commits are snapshots of your project at specific points in time.
- Each commit has a unique identifier and a message describing the changes made.
- Commits help track project progress and understand its evolution.

## Git Folders: A Different Approach

Git manages project files differently than traditional Windows folders:

- Your working directory contains project files where you can make changes.
- Git tracks all changes made to files within the folder.
- Committing changes creates new versions without overwriting originals.
- You can view the full history of changes and revert to previous versions.
- Switching branches updates files to match the version associated with that branch.
- You can only work on one branch at a time in a single folder.

**Note**: When checking out a specific commit, you enter a "detached HEAD" state. Create a new branch if you want to make changes from this state to avoid losing your work.

## Git Workflow: Step by Step

Follow these steps to effectively use Git in your Power BI development process:

### Prerequisites

Before starting, ensure you have:

1. An Azure DevOps Account
   a. Go to the Emerge Aotearoa Azure DevOps website: https://dev.azure.com/EmergeAotearoa
   b. Sign in with your credentials.
   c. Check if you have access to the Reporting Analytical Data project.
   
2. GitHub Desktop installed on your local machine.

### Getting Started: Cloning the Repository

1. Open your web browser and navigate to your [Azure DevOps project](https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics).
2. Go to the [Repos section of your project](https://dev.azure.com/EmergeAotearoa/_git/Data%20and%20Analytics).
3. Click on the "Clone" button in the upper right corner of the page.
4. In the "Clone Repository" dialog, select "URL" and copy the provided URL.
5. Open GitHub Desktop on your local machine.
6. Click on "File" in the top menu, then select "Clone Repository".
7. In the "Clone a Repository" dialog, switch to the "URL" tab.
8. Paste the copied Azure DevOps repository URL into the "URL" field.
9. Choose the local path where you want to create the repository clone.
10. Click "Clone" to start the process.
11. If prompted, enter your Azure DevOps credentials.
12. Wait for the cloning process to complete. You'll see progress information in GitHub Desktop.
13. Once finished, you'll have a new folder with the repository name containing all project files.
14. The repository will now appear in your GitHub Desktop list of local repositories.

### Creating a Branch and Linking to a User Story

1. Open GitHub Desktop and ensure you're on the main branch.
2. Click "Current Branch" > "New Branch".
3. Name the branch using the convention:
   - [Folder]/[User-Story-Number]-[User-Story-Description]
   - Example: feature/12345-AddNewDataModel or bugfix/12346-FixReportLoadingIssue
4. Click "Create Branch" and "Publish branch" to push it to the remote repository.
5. Open your Azure DevOps project in a web browser.
6. Go to Boards > Find your user story > Click "+" next to "Development".
7. Choose "Link branch".
8. Select your repository and the branch you just created.
9. Click "Link" to connect the branch to the user story.
10. Begin working on your bugfix or feature in GitHub Desktop using this new branch.

### Making Changes: Your Local Workspace

- Open your Power BI file (.pbix) from the cloned repository folder.
- Make necessary changes to your reports or data models.
- Save the file in the same location.

> **NOTE**  
> COMMIT REGULARLY as it replaces the save button. Each commit can be reverted to, providing a safety net for your work. Think of commits as save points in your project's history.

### Committing and Pushing Changes

1. Open GitHub Desktop and review your changes.
2. In the bottom left, enter a summary of your changes (e.g., "Updated sales dashboard").
3. Optionally, add a more detailed description.
4. Click "Commit to [your-branch-name]".
5. Click "Push origin" to send your changes to the remote repository.

Remember to commit and push your changes regularly to keep your work updated and visible to your team.

## Review for Pull Request

When your feature or bugfix is complete and ready for review:

- At least one other team member reviews the code
- Reviewers check for:
  - Code quality and adherence to coding standards
  - Potential bugs or errors
  - Performance considerations
  - Security implications
- Feedback is provided and addressed before merging
- Developers submit pull requests for completed work

## Creating a Pull Request

1. Go to your Azure DevOps project in a web browser.
2. Navigate to Repos > Pull requests.
3. Click "New pull request".
4. Select your branch as the source and 'main' as the target.
5. Give your pull request a title and description.
6. Add reviewers if necessary.
7. Click "Create" to submit the pull request.

## Resolving Merge Conflicts

If Git can't automatically merge your changes:

1. In GitHub Desktop, click on "Resolve conflicts" next to the conflicting file.
2. Open the file in your text editor.
3. Look for conflict markers (<<<<<<, =======, >>>>>>).
4. Edit the file to resolve the conflict, removing the conflict markers.
5. Save the file and return to GitHub Desktop.
6. Click "Mark as resolved" for each resolved file.
7. Commit the changes and push to your branch.

<details>
<summary><b>Git Workflow Checklist</b></summary>

- [ ] Clone the repository to your local machine
- [ ] Create a new branch for your work
- [ ] Make changes to Power BI reports or semantic models
- [ ] Commit your changes with clear, descriptive messages
- [ ] Push your changes to the remote repository
- [ ] Pull changes from other team members regularly
- [ ] Create a pull request when your feature is complete
- [ ] Review and address any feedback on your pull request
- [ ] Merge your branch into the main branch once approved
</details>
<br>
<details>
 <summary><b>Git Workflow Process Flow</b></summary>

::: mermaid
graph TD
A{Start New Feature/Clone Repository} --> B[Create New Branch]
B --> C[Make Changes]
C --> D[Commit Changes]
D --> E[Push Changes]
E --> F[Pull Latest Changes]
F --> G[Create Pull Request]
G --> H[Review and Feedback]
H --> I[Merge to Main Branch]

%% Feedback Loops
H -->|Changes Requested| C
F -->|Conflicts| C

%% Colors
style A fill:#32CD32,stroke:#000,stroke-width:1px
style I fill:#1E90FF,stroke:#000,stroke-width:1px
style B fill:#FFFAE3,stroke:#000,stroke-width:1px
style C fill:#FFFACD,stroke:#000,stroke-width:1px
style D fill:#FAFAD2,stroke:#000,stroke-width:1px
style E fill:#FFEFD5,stroke:#000,stroke-width:1px
style F fill:#FFDAB9,stroke:#000,stroke-width:1px
style G fill:#FFDEAD,stroke:#000,stroke-width:1px
style H fill:#FFB6C1,stroke:#000,stroke-width:1px
:::

### Explanation of Workflow Steps:

1. **Start New Feature/Clone Repository**: Begin by cloning the repository to your local machine.
2. **Create New Branch**: Create a new branch for your specific feature or bugfix.
3. **Make Changes**: Modify your Power BI reports or data models.
4. **Commit Changes**: Save your changes with a descriptive commit message.
5. **Push Changes**: Upload your commits to the remote repository.
6. **Pull Latest Changes**: Incorporate any changes made by other team members.
7. **Create Pull Request**: Submit your changes for review.
8. **Review and Feedback**: Address any comments or suggestions from reviewers.
9. **Merge to Main Branch**: Once approved, your changes are incorporated into the main project.

## Glossary of Git Terms

- **Repository (Repo)**: The central location where your project's files are stored.
- **Branch**: An independent line of development.
- **Commit**: A saved point in the project's history.
- **Push**: Uploading local repository content to a remote repository.
- **Pull**: Fetching and merging changes from the remote repository to your local repository.
- **Merge**: The process of integrating changes from one branch into another.
- **Pull Request**: A method of submitting contributions to a project.
- **Clone**: Creating a local copy of a repository.
- **Fork**: A personal copy of another user's repository.