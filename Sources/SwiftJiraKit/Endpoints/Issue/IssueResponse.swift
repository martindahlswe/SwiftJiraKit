import Foundation

public struct IssueResponse: Codable, Sendable {
    public let id: String
    public let key: String
    public let fields: Fields

    public struct Fields: Codable, Sendable {
        public let summary: String
        public let description: String?
        public let status: Status
        public let created: Date
        public let updated: Date

        public struct Status: Codable, Sendable {
            public let name: String
        }
    }
}

func decodeIssueResponse(from jsonData: Data) throws -> [IssueResponse] {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom { decoder -> Date in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = formatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
        }
        return date
    }

    return try decoder.decode([IssueResponse].self, from: jsonData)
}
