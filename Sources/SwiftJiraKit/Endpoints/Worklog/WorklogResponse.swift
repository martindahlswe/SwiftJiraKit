import Foundation

public struct WorklogResponse: Codable {
    public let id: String
    public let author: User
    public let timeSpent: String
    public let comment: String
    public let started: String
    public let timeSpentSeconds: Int
    
    public struct User: Codable {
        public let displayName: String
        public let username: String
    }
}
