import Foundation

public class Issue {
    private let api: SwiftJiraKit
    
    public init(api: SwiftJiraKit) {
        self.api = api
    }
    
    public func fetchAssignedIssues(status: String?) async throws -> [[String: Any]] {
        var parameters: [String: String] = ["assignee": "currentUser()"]
        if let status = status {
            parameters["status"] = status
        }
        
        let endpoint = "search"
        let data = try await api.makeRequest(endpoint: endpoint, parameters: parameters)
        
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let issues = json["issues"] as? [[String: Any]] {
            return issues
        } else {
            throw NSError(domain: "SwiftJiraKit", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch issues"])
        }
    }
}
