import Foundation
import Logging

/// Provides methods for interacting with Jira's REST API.
public class JiraAPI {
    private let networkManager: NetworkManaging
    private let logger = Logger(label: "com.swiftjirakit.jiraapi")

    /// Initializes the JiraAPI with a network manager.
    /// - Parameter networkManager: A `NetworkManaging` instance for handling requests.
    public init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
        logger.info("JiraAPI initialized")
    }

    /// Validates connectivity to the Jira instance.
    /// - Returns: `true` if connectivity is validated, otherwise `false`.
    /// - Throws: An `APIError` if the operation fails.
    public func validateConnectivity() async throws -> Bool {
        logger.info("Validating connectivity to Jira instance")
        do {
            let _ = try await networkManager.getData(from: "rest/api/2/myself")
            logger.info("Connectivity validated successfully")
            return true
        } catch let error as APIError {
            logger.error("APIError occurred during connectivity validation: \(error.localizedDescription)")
            throw error
        } catch {
            logger.error("Unexpected error during connectivity validation: \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
    }

    /// Fetches user details for the authenticated user.
    /// - Returns: The user's details as raw data.
    /// - Throws: An `APIError` if the operation fails.
    public func getAuthenticatedUserDetails() async throws -> Data {
        logger.info("Fetching authenticated user details")
        do {
            let data = try await networkManager.getData(from: "rest/api/2/myself")
            logger.info("Successfully fetched authenticated user details")
            return data
        } catch let error as APIError {
            logger.error("APIError occurred during user details fetch: \(error.localizedDescription)")
            throw error
        } catch {
            logger.error("Unexpected error during user details fetch: \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
    }
}
