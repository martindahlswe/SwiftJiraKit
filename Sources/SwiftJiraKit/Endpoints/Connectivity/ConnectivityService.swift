import Foundation

public class ConnectivityService {
    private let networkManager: NetworkManaging  // Use the protocol

    /// Make the initializer public
    public init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    /// Validates connectivity by checking the provided URL and token.
    /// - Parameter completion: A closure with the result of the validation.
    public func validateConnectivity(completion: @escaping @Sendable (Result<Void, Error>) -> Void) {
        let endpoint = "rest/api/2/myself" // A lightweight endpoint to check authentication.
        networkManager.sendRequest(endpoint: endpoint, method: "GET", body: nil) { (result: Result<MyselfResponse, Error>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

public struct MyselfResponse: Decodable, Encodable { // Add Encodable conformance
    let selfURL: String // URL of the authenticated user's profile
    let accountId: String // Account ID of the user

    private enum CodingKeys: String, CodingKey {
        case selfURL = "self"
        case accountId
    }
}
