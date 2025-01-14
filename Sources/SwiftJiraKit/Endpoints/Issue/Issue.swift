import Foundation

public struct JiraIssue: Codable, Sendable {
    public let key: String
    public let summary: String

    public init(key: String, summary: String) {
        self.key = key
        self.summary = summary
    }
}

public class Issue {
    private let api: SwiftJiraKit
    
    public init(api: SwiftJiraKit) {
        self.api = api
    }
    
    public func fetchAssignedIssues(status: String?) async throws -> [JiraIssue] {
        var parameters: [String: String] = ["assignee": "currentUser()"]
        if let status = status {
            parameters["status"] = status
        }

        let endpoint = "search"
        let data = try await api.makeRequest(endpoint: endpoint, parameters: parameters)

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let issues = json["issues"] as? [[String: Any]] {
            return issues.compactMap { raw in
                guard let key = raw["key"] as? String, let fields = raw["fields"] as? [String: Any],
                      let summary = fields["summary"] as? String else {
                    return nil
                }
                return JiraIssue(key: key, summary: summary)
            }
        } else {
            throw NSError(domain: "SwiftJiraKit", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch issues"])
        }
    }
}
