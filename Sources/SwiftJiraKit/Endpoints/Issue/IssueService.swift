import Foundation

public class IssueService {
    private let networkManager: NetworkManaging

    public init(networkManager: NetworkManaging) { // Use protocol type
        self.networkManager = networkManager
    }

    // Fetch issue details
    public func getIssue(
        issueKey: String,
        completion: @escaping @Sendable (Result<IssueResponse, Error>) -> Void
    ) {
        let endpoint = "rest/api/2/issue/\(issueKey)"
        networkManager.sendRequest(
            endpoint: endpoint,
            method: "GET",
            body: nil, // Explicitly provide nil for the body
            completion: completion
        )
    }

    // Search for issues
    public func searchIssues(
        jql: String,
        fields: [String] = ["summary", "status", "assignee"],
        maxResults: Int = 50,
        startAt: Int = 0,
        completion: @escaping @Sendable (Result<[IssueResponse], Error>) -> Void
    ) {
        let endpoint = "rest/api/2/search"
        let body: [String: Any] = [
            "jql": jql,
            "fields": fields,
            "maxResults": maxResults,
            "startAt": startAt
        ]

        guard let requestData = serializeJSON(body) else {
            completion(.failure(APIError.invalidRequestBody))
            return
        }

        networkManager.sendRequest(
            endpoint: endpoint,
            method: "POST",
            body: requestData
        ) { (result: Result<SearchResponse, Error>) in
            switch result {
            case .success(let searchResponse):
                completion(.success(searchResponse.issues))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Utility function to serialize JSON
    private func serializeJSON(_ dictionary: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: dictionary, options: [])
    }
}

// Response structure for search results
private struct SearchResponse: Decodable {
    let issues: [IssueResponse]
}
