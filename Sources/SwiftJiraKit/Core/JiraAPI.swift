//
//  JiraAPI.swift
//  SwiftJiraKit
//

import Foundation
import Logging

/// Provides methods for interacting with Jira's REST API.
public class JiraAPI {
    private let networkManager: NetworkManaging
    private let logger = Logger(label: "com.swiftjirakit.jiraapi")

    /// Initializes the JiraAPI with a network manager.
    /// - Parameters:
    ///   - baseURL: The base URL of the Jira server.
    ///   - token: The Bearer token for authentication.
    ///   - networkManager: A custom `NetworkManaging` instance for testing or default functionality.
    public init(baseURL: URL, token: String, networkManager: NetworkManaging? = nil) {
        self.networkManager = networkManager ?? NetworkManager(baseURL: baseURL, token: token)
        logger.info("JiraAPI initialized with base URL: \(baseURL)")
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
    /// - Returns: The user's details as a dictionary.
    /// - Throws: An `APIError` if the operation fails.
    public func getAuthenticatedUserDetails() async throws -> [String: Any] {
        logger.info("Fetching authenticated user details")
        do {
            let data = try await networkManager.getData(from: "rest/api/2/myself")
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            logger.info("Successfully fetched authenticated user details")
            return json ?? [:]
        } catch let error as APIError {
            logger.error("APIError occurred during user details fetch: \(error.localizedDescription)")
            throw error
        } catch {
            logger.error("Unexpected error during user details fetch: \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
    }
}
