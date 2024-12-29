import Foundation

public struct IssueResponse: Decodable {
    let id: String
    let key: String
    let fields: Fields

    public struct Fields: Decodable {
        let summary: String
        let description: String?
        let status: Status

        public struct Status: Decodable {
            let name: String
        }
    }
}
