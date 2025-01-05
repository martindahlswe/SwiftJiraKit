import Foundation
import Logging

/// Service for managing Jira issues.
public class IssueService: @unchecked Sendable { // Mark IssueService as Sendable
    private let networkManager: NetworkManaging
    private let logger: Logger // Logger is immutable
    
    /// Initializes the service with a network manager.
    /// - Parameter networkManager: A `NetworkManaging` instance for network operations.
    public init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
        self.logger = Logger(label: "com.swiftjirakit.issueservice") // Ensure immutability
        logger.info("IssueService initialized")
    }

    /// Fetches the details of a Jira issue by its key.
    /// - Parameter issueKey: The key of the Jira issue.
    /// - Returns: An `IssueResponse` object containing issue details.
    /// - Throws: An `APIError` if the operation fails.
    public func getIssue(issueKey: String) async throws -> IssueResponse {
        let endpoint = "rest/api/2/issue/\(issueKey)"
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
    /// - Parameter jql: The JQL query string.
    /// - Returns: An array of `IssueResponse` objects.
    /// - Throws: An `APIError` if the operation fails.
    public func searchIssues(jql: String) async throws -> [IssueResponse] {
        let encodedJQL = jql.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let endpoint = "rest/api/2/search?jql=\(encodedJQL)"
        logger.info("Searching for issues with JQL: \(jql)")

        do {
            let data = try await networkManager.getData(from: endpoint)
            let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
            logger.info("Successfully fetched \(searchResponse.issues.count) issues for JQL: \(jql)")
            return searchResponse.issues
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

    /// Fetches open tickets for a given server.
    /// - Parameter serverName: The name of the server.
    /// - Returns: An array of `Ticket` objects.
    /// - Throws: An `APIError` if the operation fails.
    public func fetchOpenTickets(for serverName: String) async throws -> [Ticket] {
        let jql = "status = 'Open'"
        logger.info("Fetching open tickets for server: \(serverName) with JQL: \(jql)")

        do {
            let issues = try await searchIssues(jql: jql)
            return issues.map { issue in
                Ticket(
                    id: UUID(),
                    ticketKey: issue.key,
                    summary: issue.fields.summary,
                    isFavorite: false,
                    serverName: serverName,
                    createdDate: issue.fields.created,
                    modifiedDate: issue.fields.updated
                )
            }
        } catch {
            logger.error("Failed to fetch open tickets for server \(serverName): \(error.localizedDescription)")
            throw error
        }
    }
}

/// Represents the response for a search query.
struct SearchResponse: Codable {
    let startAt: Int
    let maxResults: Int
    let total: Int
    let issues: [IssueResponse]
}

public struct Ticket: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let ticketKey: String
    public let summary: String
    public var isFavorite: Bool
    public let serverName: String
    public let createdDate: Date
    public let modifiedDate: Date

    public init(
        id: UUID = UUID(),
        ticketKey: String,
        summary: String,
        isFavorite: Bool = false,
        serverName: String,
        createdDate: Date = Date(),
        modifiedDate: Date = Date()
    ) {
        self.id = id
        self.ticketKey = ticketKey
        self.summary = summary
        self.isFavorite = isFavorite
        self.serverName = serverName
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}

extension IssueService {
    /// Fetches all IssueService instances for the provided servers.
    /// - Parameter servers: An array of `ServerInfo` instances.
    /// - Returns: An array of tuples containing `IssueService` and the corresponding server name.
    /// - Throws: An error if a server's URL is invalid.
    public static func fetchAll(servers: [ServerInfo]) throws -> [(IssueService, String)] {
        try servers.map { server in
            guard let url = URL(string: server.url) else {
                throw APIError.invalidServerURL(server.url)
            }
            let networkManager = NetworkManager(baseURL: url, token: server.token)
            return (IssueService(networkManager: networkManager), server.name)
        }
    }
}

public struct ServerInfo {
    public let name: String
    public let url: String
    public let token: String

    public init(name: String, url: String, token: String) {
        self.name = name
        self.url = url
        self.token = token
    }
}
