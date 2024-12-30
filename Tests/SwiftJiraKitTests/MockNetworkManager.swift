import Foundation
@testable import SwiftJiraKit

final class MockNetworkManager: NetworkManaging {
    // Store the mock response for the next request
    var mockResponse: Result<Data, Error>?

    func sendRequest<T: Decodable>(
        endpoint: String,
        method: String,
        body: Data?,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    ) {
        guard let response = mockResponse else {
            // If no response is set, return a failure
            completion(.failure(APIError.invalidResponse))
            return
        }

        switch response {
        case .success(let data):
            do {
                // Decode data into the expected type
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
