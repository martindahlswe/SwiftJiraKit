import Foundation

public class Authentication {
    public let token: String
    
    // Initialize with the Bearer token
    public init(token: String) {
        self.token = token
    }
    
    public func getAuthorizationHeader() -> [String: String] {
        return ["Authorization": "Bearer \(token)"]
    }
    
    public func validateToken() throws {
        if token.isEmpty {
            throw AuthenticationError.invalidToken
        }
    }
}

public enum AuthenticationError: Error {
    case invalidToken
}
