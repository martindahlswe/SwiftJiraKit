import Foundation

public class WorklogService {
    private let api: SwiftJiraKit
    
    public init(api: SwiftJiraKit) {
        self.api = api
    }

    // Fetch all worklogs for a specific issue
    public func fetchWorklogs(issueKey: String) async throws -> [WorklogResponse] {
        let endpoint = "issue/\(issueKey)/worklog"
        let data = try await api.makeRequest(endpoint: endpoint)
        
        let decoder = JSONDecoder()
        let worklogs = try decoder.decode([WorklogResponse].self, from: data)
        return worklogs
    }

    // Fetch a specific worklog by ID
    public func fetchWorklog(issueKey: String, worklogId: String) async throws -> WorklogResponse {
        let endpoint = "issue/\(issueKey)/worklog/\(worklogId)"
        let data = try await api.makeRequest(endpoint: endpoint)
        
        let decoder = JSONDecoder()
        let worklog = try decoder.decode(WorklogResponse.self, from: data)
        return worklog
    }

    // Add a new worklog to an issue
    public func addWorklog(issueKey: String, request: WorklogRequest) async throws {
        let endpoint = "issue/\(issueKey)/worklog"
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(request)
        
        var request = URLRequest(url: URL(string: api.baseURL + endpoint)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = api.auth.getAuthorizationHeader()
        request.httpBody = jsonData
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }

    // Delete a specific worklog entry
    public func deleteWorklog(issueKey: String, worklogId: String) async throws {
        let endpoint = "issue/\(issueKey)/worklog/\(worklogId)"
        
        var request = URLRequest(url: URL(string: api.baseURL + endpoint)!)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = api.auth.getAuthorizationHeader()
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }

    // Edit an existing worklog entry
    public func editWorklog(issueKey: String, worklogId: String, request: WorklogRequest) async throws {
        let endpoint = "issue/\(issueKey)/worklog/\(worklogId)"
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(request)
        
        var request = URLRequest(url: URL(string: api.baseURL + endpoint)!)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = api.auth.getAuthorizationHeader()
        request.httpBody = jsonData
        
        let (_, _) = try await URLSession.shared.data(for: request)
    }
}
