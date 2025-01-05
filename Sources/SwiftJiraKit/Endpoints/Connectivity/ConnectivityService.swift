import Foundation
import Logging

/// Service for validating connectivity to the Jira instance.
public class ConnectivityService {
    private let networkManager: NetworkManaging
    private let logger = Logger(label: "com.swiftjirakit.connectivityservice")

    /// Initializes the service with a network manager.
    /// - Parameter networkManager: An instance conforming to `NetworkManaging`.
    public init(networkManager: NetworkManaging) {
        self.networkManager = networkManager
        logger.info("ConnectivityService initialized")
    }

    /// Validates connectivity to the Jira instance by hitting a lightweight endpoint.
    /// - Returns: `true` if connectivity is validated, otherwise `false`.
    /// - Throws: An `APIError` if the operation fails.
    public func validateConnectivity() async throws -> Bool {
        logger.info("Validating connectivity to Jira instance")
        let endpoint = "rest/api/2/myself"

        do {
            let data = try await networkManager.getData(from: endpoint)
            _ = try JSONDecoder().decode(MyselfResponse.self, from: data)
            logger.info("Connectivity successfully validated")
            return true
        } catch let error as DecodingError {
            logger.error("Failed to decode response: \(error.localizedDescription)")
            throw APIError.decodingError
        } catch let error as APIError {
            logger.error("APIError occurred: \(error.localizedDescription)")
            throw error
        } catch {
            logger.error("Unexpected error occurred: \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
    }
}

/// A lightweight response model for the `/myself` endpoint.
public struct MyselfResponse: Decodable {
    public let name: String
    public let emailAddress: String
    public let displayName: String
}
