import Foundation

public class JiraAPI {
    private let baseURL: URL
    private let token: String
    private let networkManager: NetworkManager

    public init(baseURL: String, token: String) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid URL string.")
        }
        self.baseURL = url
        self.token = token
        self.networkManager = NetworkManager(baseURL: url, token: token)
    }

    public var worklogService: WorklogService {
        return WorklogService(networkManager: networkManager)
    }

    public var issueService: IssueService {
        return IssueService(networkManager: networkManager)
    }

    public var connectivityService: ConnectivityService {
        return ConnectivityService(networkManager: networkManager)
    }

    /// Validates connectivity by checking the provided URL and token.
    /// - Parameter completion: A closure with the result of the validation.
    public func validateConnectivity(completion: @escaping @Sendable (Result<Void, Error>) -> Void) {
        connectivityService.validateConnectivity(completion: completion)
    }
}
