import Foundation

/// Represents a response from the Jira API for a worklog.
public struct WorklogResponse: Decodable, Sendable { // Added Sendable conformance
    public let id: String?
    public let issueId: String?
    public let author: User?
    public let updateAuthor: User?
    public let comment: String?
    public let started: String?
    public let timeSpent: String?
    public let timeSpentSeconds: Int?

    /// Represents a user associated with a worklog.
    public struct User: Decodable, Sendable { // Added Sendable conformance
        public let accountId: String?
        public let displayName: String?
        public let active: Bool?
    }
}
