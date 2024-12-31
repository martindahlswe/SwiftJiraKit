import Foundation
@testable import SwiftJiraKit

final class MockNetworkManager: NetworkManaging {
    var requestedEndpoint: String?
    var requestedMethod: String?
    var requestedBody: Data?
    var mockResponse: Result<Data, Error>?

    func sendRequest<T: Decodable>(
        endpoint: String,
        method: String,
        body: Data? = nil,
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    ) {
        requestedEndpoint = endpoint
        requestedMethod = method
        requestedBody = body

        if let response = mockResponse {
            switch response {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        } else {
            completion(.failure(APIError.invalidResponse))
        }
    }
}

struct MockSearchResponse: Decodable, Encodable {
    let issues: [IssueResponse]
}
