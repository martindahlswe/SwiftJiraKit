import Foundation

public struct IssueResponse: Codable { // Codable includes both Encodable and Decodable
    let id: String
    let key: String
    let fields: Fields

    public struct Fields: Codable {
        let summary: String
        let description: String?
        let status: Status

        public struct Status: Codable {
            let name: String
        }
    }
}
