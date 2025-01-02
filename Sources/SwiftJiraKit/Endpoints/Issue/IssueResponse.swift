import Foundation

public struct IssueResponse: Codable {
    public let id: String // Changed to public
    public let key: String // Changed to public
    public let fields: Fields // Changed to public

    public struct Fields: Codable {
        public let summary: String // Changed to public
        public let description: String? // Changed to public
        public let status: Status // Changed to public

        public struct Status: Codable {
            public let name: String // Changed to public
        }
    }
}
