import Foundation
import Logging

/// Service for managing Jira worklogs.
public class WorklogService {
    private let networkManager: NetworkManaging
    private let logger = Logger(label: "com.swiftjirakit.worklogservice")

    /// Initializes the service with a network manager.
    /// - Parameter networkManager: A `NetworkManaging` instance.
    public init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
        logger.info("WorklogService initialized")
    }

    /// Fetches worklogs for a specific issue.
    /// - Parameter issueKey: The key of the Jira issue.
    /// - Returns: An array of `WorklogResponse` objects.
    /// - Throws: An `APIError` if the operation fails.
    public func getWorklogs(for issueKey: String) async throws -> [WorklogResponse] {
        let endpoint = "rest/api/2/issue/\(issueKey)/worklog"
        logger.info("Fetching worklogs for issue: \(issueKey)")

        do {
            let data = try await networkManager.getData(from: endpoint)
            let worklogs = try JSONDecoder().decode([WorklogResponse].self, from: data)
            logger.info("Successfully fetched \(worklogs.count) worklogs for issue: \(issueKey)")
            return worklogs
        } catch let error as DecodingError {
            logger.error("Failed to decode worklog response: \(error.localizedDescription)")
            throw APIError.decodingError
        } catch let error as APIError {
            logger.error("APIError occurred while fetching worklogs: \(error.localizedDescription)")
            throw error
        } catch {
            logger.error("Unexpected error occurred while fetching worklogs: \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
    }

    /// Creates a new worklog for a specific issue.
    /// - Parameters:
    ///   - issueKey: The key of the Jira issue.
    ///   - worklog: The worklog request data.
    /// - Returns: The created `WorklogResponse`.
    /// - Throws: An `APIError` if the operation fails.
    public func addWorklog(to issueKey: String, worklog: WorklogRequest) async throws -> WorklogResponse {
        let endpoint = "rest/api/2/issue/\(issueKey)/worklog"
        let payload = try JSONEncoder().encode(worklog)
        logger.info("Creating new worklog for issue: \(issueKey)")

        do {
            let data = try await networkManager.postData(to: endpoint, body: payload)
            let createdWorklog = try JSONDecoder().decode(WorklogResponse.self, from: data)
            logger.info("Successfully created worklog with ID: \(createdWorklog.id ?? "Unknown") for issue: \(issueKey)")
            return createdWorklog
        } catch let error as DecodingError {
            logger.error("Failed to decode worklog creation response: \(error.localizedDescription)")
            throw APIError.decodingError
        } catch let error as APIError {
            logger.error("APIError occurred while creating worklog: \(error.localizedDescription)")
            throw error
        } catch {
            logger.error("Unexpected error occurred while creating worklog: \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
    }
}
