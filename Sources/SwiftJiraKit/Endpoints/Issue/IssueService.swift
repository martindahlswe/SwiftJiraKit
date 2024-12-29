import Foundation

public class IssueService {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    // Fetch issue details
    public func getIssue(
        issueKey: String,
        completion: @escaping @Sendable (Result<IssueResponse, Error>) -> Void
    ) {
        let endpoint = "rest/api/2/issue/\(issueKey)"
        networkManager.sendRequest(endpoint: endpoint, method: "GET", completion: completion)
    }
}
