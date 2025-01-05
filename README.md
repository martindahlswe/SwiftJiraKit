# SwiftJiraKit

SwiftJiraKit is a lightweight and modular Swift library for interacting with Jira's REST API (version 2). It simplifies common Jira operations like logging work time, managing worklogs, and fetching issues, making it ideal for developers integrating Jira into their Swift projects.

## Features

- **Worklogs**:
  - Log, retrieve, update, and delete worklogs for Jira issues.
- **Issues**:
  - Fetch details of individual or multiple Jira issues based on JQL queries.
- **Connectivity**:
  - Validate connectivity to your Jira instance, including URL reachability and token authentication.
- **JQL Builder**:
  - Construct JQL queries programmatically for advanced filtering.
- **Date Handling**:
  - Utilities for ISO8601 and Jira-specific date formats.
- **Modular Design**:
  - Clean, extensible, and testable API interface.

## Installation

### Swift Package Manager (SPM)
Add the following dependency to your `Package.swift` file:
```swift
dependencies: [
    .package(url: "https://github.com/martindahlswe/SwiftJiraKit.git", from: "1.0.0")
]
```

Then, include `SwiftJiraKit` in your target dependencies:
```swift
targets: [
    .target(
        name: "YourApp",
        dependencies: ["SwiftJiraKit"]
    )
]
```

## Documentation

For detailed usage examples, refer to the [GitHub Wiki](https://github.com/martindahlswe/SwiftJiraKit/wiki).

## License

This project is licensed under the [MIT License](LICENSE).
