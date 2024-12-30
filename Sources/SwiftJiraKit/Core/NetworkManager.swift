// NetworkManager.swift

import Foundation

public class NetworkManager: NetworkManaging {
    private let baseURL: URL
    private let token: String

    public init(baseURL: URL, token: String) {
        self.baseURL = baseURL
        self.token = token
    }

    public func sendRequest<T: Decodable>(
        endpoint: String,
        method: String,
        body: Data? = nil,  // Keep this optional
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    ) {
        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint))
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = body
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if T.self == Void.self {
                completion(.success(() as! T))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
