import Foundation

public class NetworkManager {
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
}
