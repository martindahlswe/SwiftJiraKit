import Foundation

public class WorklogService {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    public func logWork(
        issueKey: String,
        timeSpentSeconds: Int,
        started: String,
        comment: String? = nil,
        completion: @escaping @Sendable (Result<WorklogResponse, Error>) -> Void
    ) {
        let endpoint = "rest/api/2/issue/\(issueKey)/worklog"
        let worklog = WorklogRequest(
            timeSpentSeconds: timeSpentSeconds,
            started: started,
            comment: comment
        )
        do {
            let body = try JSONEncoder().encode(worklog)
            networkManager.sendRequest(endpoint: endpoint, method: "POST", body: body, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}

