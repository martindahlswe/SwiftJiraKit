import Foundation

public class WorklogService {
    private let networkManager: NetworkManaging

    public init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
    }

    public func getWorklogs(
        issueKey: String,
        completion: @escaping @Sendable (Result<[WorklogResponse], Error>) -> Void
    ) {
        let endpoint = "rest/api/2/issue/\(issueKey)/worklog"
        networkManager.sendRequest(endpoint: endpoint, method: "GET", body: nil, completion: completion)
    }

    public func addWorklog(
        issueKey: String,
        worklog: WorklogRequest,
        completion: @escaping @Sendable (Result<WorklogResponse, Error>) -> Void
    ) {
        let endpoint = "rest/api/2/issue/\(issueKey)/worklog"
        do {
            let body = try JSONEncoder().encode(worklog)
            networkManager.sendRequest(endpoint: endpoint, method: "POST", body: body, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    public func updateWorklog(
        issueKey: String,
        worklogId: String,
        worklog: WorklogRequest,
        completion: @escaping @Sendable (Result<WorklogResponse, Error>) -> Void
    ) {
        let endpoint = "rest/api/2/issue/\(issueKey)/worklog/\(worklogId)"
        do {
            let body = try JSONEncoder().encode(worklog)
            networkManager.sendRequest(endpoint: endpoint, method: "PUT", body: body, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    public func deleteWorklog(
        issueKey: String,
        worklogId: String,
        completion: @escaping @Sendable (Result<Void, Error>) -> Void
    ) {
        let endpoint = "rest/api/2/issue/\(issueKey)/worklog/\(worklogId)"
        networkManager.sendRequest(endpoint: endpoint, method: "DELETE", body: nil) { (result: Result<Data?, Error>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func setWorklogProperty(
        issueKey: String,
        worklogId: String,
        propertyKey: String,
        propertyValue: [String: String],
        completion: @escaping @Sendable (Result<Void, Error>) -> Void
    ) {
        let endpoint = "rest/api/2/issue/\(issueKey)/worklog/\(worklogId)/properties/\(propertyKey)"
        do {
            let body = try JSONSerialization.data(withJSONObject: propertyValue, options: [])
            networkManager.sendRequest(endpoint: endpoint, method: "PUT", body: body) { (result: Result<Data?, Error>) in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    public func deleteWorklogProperty(
        issueKey: String,
        worklogId: String,
        propertyKey: String,
        completion: @escaping @Sendable (Result<Void, Error>) -> Void
    ) {
        let endpoint = "rest/api/2/issue/\(issueKey)/worklog/\(worklogId)/properties/\(propertyKey)"
        networkManager.sendRequest(endpoint: endpoint, method: "DELETE", body: nil) { (result: Result<Data?, Error>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
