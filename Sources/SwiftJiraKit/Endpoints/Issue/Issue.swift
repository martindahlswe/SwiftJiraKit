import Foundation

public struct JiraIssue: Codable, Sendable {  // Add Sendable conformance
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

    public func fetchAssignedIssues(maxResults: Int = 50) async throws -> [JiraIssue] {
        // JQL query
        let jql = "assignee=currentUser() AND statusCategory!=done"
        let parameters: [String: String] = [
            "jql": jql,
            "maxResults": "\(maxResults)",
            "fields": "key,summary"
        ]

        let endpoint = "search"

        // Make the API request
        let data = try await api.makeRequest(endpoint: endpoint, parameters: parameters)

        // Parse JSON response
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let issuesArray = json["issues"] as? [[String: Any]] else {
            throw NSError(domain: "SwiftJiraKit", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to parse issues"])
        }

        // Map response to JiraIssue objects
        return issuesArray.compactMap { issueDict in
            guard let key = issueDict["key"] as? String,
                  let fields = issueDict["fields"] as? [String: Any],
                  let summary = fields["summary"] as? String else {
                return nil
            }
            return JiraIssue(key: key, summary: summary)
        }
    }
}
