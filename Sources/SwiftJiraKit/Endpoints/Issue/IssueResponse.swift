import Foundation

/// Represents a response from the Jira API for a specific issue.
public struct IssueResponse: Codable {
    public let id: String
    public let key: String
    public let fields: Fields

    /// Represents the fields of a Jira issue.
    public struct Fields: Codable {
        public let summary: String
        public let description: String?
        public let status: Status

        /// Represents the status of a Jira issue.
        public struct Status: Codable {
            public let name: String
        }
    }
}
