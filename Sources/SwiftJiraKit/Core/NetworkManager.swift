import Foundation
import Logging

/// Protocol for URLSession to allow mocking in tests.
public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

/// Extend URLSession to conform to URLSessionProtocol.
extension URLSession: URLSessionProtocol {}

/// Implementation of the `NetworkManaging` protocol for performing HTTP requests.
public class NetworkManager: NetworkManaging {
    private let logger = Logger(label: "com.swiftjirakit.networkmanager")
    private let baseURL: URL
    private let urlSession: URLSessionProtocol

    /// Initializes the NetworkManager with a base URL and URLSessionProtocol.
    /// - Parameters:
    ///   - baseURL: The base URL for API requests.
    ///   - urlSession: A custom `URLSessionProtocol` for networking.
    public init(baseURL: URL, urlSession: URLSessionProtocol = URLSession.shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        logger.info("NetworkManager initialized with base URL: \(baseURL)")
    }

    /// Performs a GET request to the specified endpoint.
    public func getData(from endpoint: String) async throws -> Data {
        let request = buildRequest(endpoint: endpoint, method: "GET")
        return try await performRequest(request)
    }

    /// Performs a POST request to the specified endpoint with a body.
    public func postData(to endpoint: String, body: Data) async throws -> Data {
        var request = buildRequest(endpoint: endpoint, method: "POST")
        request.httpBody = body
        return try await performRequest(request)
    }

    /// Performs a DELETE request to the specified endpoint.
    public func deleteData(at endpoint: String) async throws {
        let request = buildRequest(endpoint: endpoint, method: "DELETE")
        _ = try await performRequest(request)
    }

    /// Builds a URLRequest for the given endpoint and HTTP method.
    private func buildRequest(endpoint: String, method: String) -> URLRequest {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            fatalError("Invalid URL for endpoint: \(endpoint)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        logger.debug("Built \(method) request for URL: \(url)")
        return request
    }

    /// Executes the URLRequest and handles the response.
    private func performRequest(_ request: URLRequest) async throws -> Data {
        logger.info("Starting request to: \(request.url?.absoluteString ?? "Unknown URL")")
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                logger.error("Request failed with status code: \(httpResponse.statusCode)")
                throw APIError.unknown("HTTP \(httpResponse.statusCode)")
            }

            logger.info("Request succeeded for URL: \(request.url?.absoluteString ?? "Unknown URL")")
            return data
        } catch {
            logger.error("Request failed: \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
    }
}
