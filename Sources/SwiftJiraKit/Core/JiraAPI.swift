import Foundation

/// Declaring JiraAPI as `@unchecked Sendable` because it is up to the developer
/// to ensure thread safety within this class.
public class JiraAPI: @unchecked Sendable {
    private let baseURL: URL
    private let token: String
    private let privateNetworkManager: NetworkManager

    public var networkManager: NetworkManager {
        return privateNetworkManager
    }

    public init(baseURL: String, token: String) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid URL string.")
        }
        self.baseURL = url
        self.token = token
        self.privateNetworkManager = NetworkManager(baseURL: url, token: token)
    }

    public var connectivityService: ConnectivityService {
        return ConnectivityService(networkManager: networkManager)
    }

    /// Original `validateConnectivity` function (unchanged for backwards compatibility)
    public func validateConnectivity(completion: @escaping @Sendable (Result<Void, Error>) -> Void) {
        connectivityService.validateConnectivity(completion: completion)
    }

    /// New `async` version of `validateConnectivity`
    public func validateConnectivity() async throws {
        try await withCheckedThrowingContinuation { continuation in
            validateConnectivity { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
