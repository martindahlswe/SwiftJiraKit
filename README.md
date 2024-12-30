# SwiftJiraKit

SwiftJiraKit is a lightweight and modular Swift library for interacting with Jira's REST API (version 2). It simplifies tasks like logging work time, managing worklogs, and validating connectivity, making it ideal for developers who want an easy-to-use solution for Jira API integration in their Swift projects.

## Features

- Log, retrieve, update, and delete worklogs for Jira issues.
- Manage worklog properties, including setting and deleting them.
- Validate connectivity to your Jira instance, including URL reachability and token authentication.
- Modular design for future extensions (e.g., fetching issues, comments, etc.).
- Built-in support for Bearer token authentication.
- Clean and extensible API interface.

## Installation

SwiftJiraKit is distributed as a Swift Package Manager (SPM) package. Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/martindahlswe/SwiftJiraKit.git", from: "1.1.0")
]
```

Then import it into your project:

```swift
import SwiftJiraKit
```

## Usage

### 1. Initialize JiraAPI

Start by creating an instance of `JiraAPI` with your Jira instance's base URL and your personal access token (PAT):

```swift
let jiraAPI = JiraAPI(baseURL: "https://your-jira-instance.atlassian.net", token: "your-personal-access-token")
```

### 2. Worklog Management

#### Add a Worklog
```swift
let worklogRequest = WorklogRequest(
    timeSpent: "1h",
    timeSpentSeconds: 3600,
    started: "2024-01-01T12:00:00.000+0000",
    comment: "Worked on feature X",
    visibility: nil
)

jiraAPI.worklogService.addWorklog(issueKey: "PROJECT-123", worklog: worklogRequest) { result in
    switch result {
    case .success(let response):
        print("Worklog added with ID: \(response.id)")
    case .failure(let error):
        print("Failed to add worklog: \(error)")
    }
}
```

#### Retrieve Worklogs
```swift
jiraAPI.worklogService.getWorklogs(issueKey: "PROJECT-123") { result in
    switch result {
    case .success(let worklogs):
        print("Retrieved \(worklogs.count) worklogs")
    case .failure(let error):
        print("Failed to retrieve worklogs: \(error)")
    }
}
```

#### Update a Worklog
```swift
jiraAPI.worklogService.updateWorklog(issueKey: "PROJECT-123", worklogId: "1", worklog: worklogRequest) { result in
    switch result {
    case .success(let response):
        print("Worklog updated with ID: \(response.id)")
    case .failure(let error):
        print("Failed to update worklog: \(error)")
    }
}
```

#### Delete a Worklog
```swift
jiraAPI.worklogService.deleteWorklog(issueKey: "PROJECT-123", worklogId: "1") { result in
    switch result {
    case .success:
        print("Worklog deleted successfully")
    case .failure(let error):
        print("Failed to delete worklog: \(error)")
    }
}
```

### 3. Validate Connectivity

Before performing any operations, you can validate your connectivity to the Jira server. This checks both the URL and token authentication:

```swift
jiraAPI.validateConnectivity { result in
    switch result {
    case .success:
        print("Connectivity check passed! URL and token are valid.")
    case .failure(let error):
        print("Connectivity check failed: \(error.localizedDescription)")
    }
}
```

## Testing

The library includes comprehensive tests for all core functionality. Run tests using Xcode (`Command + U`) or the `swift test` command.

## Contributing

Contributions are welcome! If you have an idea or find a bug, feel free to open an issue or submit a pull request.

1. Fork the repository.
2. Create a new branch: `git checkout -b feature/your-feature`.
3. Commit your changes: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature/your-feature`.
5. Open a pull request.

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute this software for any purpose. Attribution is appreciated but not required.

## Acknowledgements

- Thanks to the Jira REST API team for providing comprehensive documentation.
- Built with ❤️  by Martin Dahl.

