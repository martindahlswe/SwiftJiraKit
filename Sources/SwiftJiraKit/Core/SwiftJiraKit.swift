import Foundation

public class SwiftJiraKit {
    public let baseURL: String
    public let auth: Authentication
    private let networkManager: NetworkManager
    
    // Initialize with dynamic baseURL and token
    public init(baseURL: String, auth: Authentication, networkManager: NetworkManager) {
        self.baseURL = baseURL
        self.auth = auth
        self.networkManager = networkManager
    }
    
    // Helper method to perform GET requests
    public func makeRequest(endpoint: String, method: String = "GET", parameters: [String: String]? = nil) async throws -> Data {
        return try await networkManager.makeRequest(baseURL: baseURL, endpoint: endpoint, method: method, parameters: parameters, auth: auth)
    }
}
