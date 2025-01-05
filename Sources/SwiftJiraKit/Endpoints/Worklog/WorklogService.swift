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

    /// Creates a new worklog for a specific issue.
    /// - Parameters:
    ///   - issueKey: The key or ID of the Jira issue.
    ///   - worklog: The worklog request data.
    /// - Returns: The created `WorklogResponse`.
    /// - Throws: An `APIError` if the operation fails.
    public func addWorklog(
        to issueKey: String,
        worklog: WorklogRequest
    ) async throws -> WorklogResponse {
        let endpoint = "rest/api/2/issue/\(issueKey)/worklog"
        logger.info("Preparing to send worklog to \(endpoint)")

        // Encode the worklog payload
        let payload = try JSONEncoder().encode(worklog)
        logger.info("[SwiftJiraKit] Worklog payload: \(String(data: payload, encoding: .utf8) ?? "Invalid UTF8")")

        // Send the POST request
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
