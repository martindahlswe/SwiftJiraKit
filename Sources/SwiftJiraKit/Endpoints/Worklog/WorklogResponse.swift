import Foundation

public struct WorklogResponse: Decodable, Encodable, Sendable { // Added Sendable conformance
    public let id: String
    public let issueId: String
    public let author: User
    public let updateAuthor: User
    public let comment: String?
    public let started: String
    public let timeSpent: String?
    public let timeSpentSeconds: Int?

    public struct User: Decodable, Encodable, Sendable { // Added Sendable conformance
        public let accountId: String
        public let displayName: String
        public let active: Bool
    }
}
