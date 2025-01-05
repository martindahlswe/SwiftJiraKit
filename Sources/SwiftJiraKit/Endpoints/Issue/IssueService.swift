import Foundation
import Logging

/// Service for managing Jira issues.
public class IssueService {
    private let networkManager: NetworkManaging
    private let logger = Logger(label: "com.swiftjirakit.issueservice")
    public let serverName: String

    /// Initializes the service with a network manager and server name.
    /// - Parameters:
    ///   - networkManager: A `NetworkManaging` instance for network operations.
    ///   - serverName: The Jira server name or base URL.
    public init(networkManager: NetworkManaging, serverName: String) {
        self.networkManager = networkManager
        self.serverName = serverName
        logger.info("IssueService initialized with server: \(serverName)")
    }

    /// Fetches the details of a Jira issue by its key.
    /// - Parameter issueKey: The key of the Jira issue.
    /// - Returns: An `IssueResponse` object containing issue details.
    /// - Throws: An `APIError` if the operation fails.
    public func getIssue(issueKey: String) async throws -> IssueResponse {
        let endpoint = "\(serverName)/rest/api/2/issue/\(issueKey)"
        logger.info("Fetching issue details for key: \(issueKey)")

        do {
            let data = try await networkManager.getData(from: endpoint)
            let issue = try JSONDecoder().decode(IssueResponse.self, from: data)
            logger.info("Successfully fetched issue details for key: \(issueKey)")
            return issue
        } catch let error as DecodingError {
            logger.error("Failed to decode issue response: \(error.localizedDescription)")
            throw APIError.decodingError
        } catch let error as APIError {
            logger.error("APIError occurred while fetching issue: \(error.localizedDescription)")
            throw error
        } catch {
            logger.error("Unexpected error occurred while fetching issue: \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
    }

    /// Searches for Jira issues using a JQL query.
    /// - Parameter jql: The Jira Query Language (JQL) query string.
    /// - Returns: An array of `IssueResponse` objects matching the query.
    /// - Throws: An `APIError` if the operation fails.
    public func searchIssues(jql: String) async throws -> [IssueResponse] {
        let endpoint = "\(serverName)/rest/api/2/search?jql=\(jql.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        logger.info("Searching for issues with JQL: \(jql)")

        do {
            let data = try await networkManager.getData(from: endpoint)
            let searchResponse = try JSONDecoder().decode([IssueResponse].self, from: data)
            logger.info("Successfully fetched \(searchResponse.count) issues for JQL: \(jql)")
            return searchResponse
        } catch let error as DecodingError {
            logger.error("Failed to decode issue search response: \(error.localizedDescription)")
            throw APIError.decodingError
        } catch let error as APIError {
            logger.error("APIError occurred while searching issues: \(error.localizedDescription)")
            throw error
        } catch {
            logger.error("Unexpected error occurred while searching issues: \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
    }
}
