import Foundation

public class NetworkManager {
    // Make the initializer public
    public init() {}

    // Perform network request with async/await
    public func makeRequest(baseURL: String, endpoint: String, method: String = "GET", parameters: [String: String]? = nil, auth: Authentication) async throws -> Data {
        var urlComponents = URLComponents(string: baseURL + "/rest/api/2/" + endpoint)!
        
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method
        request.allHTTPHeaderFields = auth.getAuthorizationHeader()
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }

    // Check server connectivity and validate the token
    public func checkConnectivity(baseURL: String, auth: Authentication) async throws -> Bool {
        let endpoint = "myself" // This endpoint checks the validity of the token and server connectivity
        
        do {
            let _ = try await makeRequest(baseURL: baseURL, endpoint: endpoint, auth: auth)
            return true // The server is reachable and the token is valid
        } catch {
            throw ConnectivityError.serverOrTokenInvalid
        }
    }
}

public enum ConnectivityError: Error {
    case serverOrTokenInvalid
}
