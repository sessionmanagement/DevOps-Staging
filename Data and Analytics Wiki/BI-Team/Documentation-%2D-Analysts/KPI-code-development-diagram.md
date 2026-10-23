:::mermaid
flowchart TD
    WIP[1. Work in Progress]
    PreTest[2. Ready for Pre Testing]
    EDWReady[3. Ready for EDW Load]
    EDWLoaded[4. Loaded to EDW]
    Update[5. Updating after EDW Load]

    WIP --> PreTest
    PreTest --> EDWReady
    EDWReady --> EDWLoaded
    EDWLoaded --> Update
    Update --> EDWReady

:::