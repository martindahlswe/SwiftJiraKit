import Foundation

/// Protocol defining required methods for network operations.
public protocol NetworkManaging {
    /// Performs a GET request to the specified endpoint.
    /// - Parameter endpoint: The endpoint URL to fetch data from.
    /// - Returns: The fetched data.
    /// - Throws: An `APIError` if the request fails.
    func getData(from endpoint: String) async throws -> Data

    /// Performs a POST request to the specified endpoint.
    /// - Parameters:
    ///   - endpoint: The endpoint URL to send data to.
    ///   - body: The data to include in the request body.
    /// - Returns: The response data.
    /// - Throws: An `APIError` if the request fails.
    func postData(to endpoint: String, body: Data) async throws -> Data

    /// Performs a DELETE request to the specified endpoint.
    /// - Parameter endpoint: The endpoint URL to delete data from.
    /// - Throws: An `APIError` if the request fails.
    func deleteData(at endpoint: String) async throws

    /// Performs a PUT request to the specified endpoint.
    /// - Parameters:
    ///   - endpoint: The endpoint URL to send data to.
    ///   - body: The data to include in the request body.
    /// - Returns: The response data.
    /// - Throws: An `APIError` if the request fails.
    func putData(to endpoint: String, body: Data) async throws -> Data

    /// Performs a PATCH request to the specified endpoint.
    /// - Parameters:
    ///   - endpoint: The endpoint URL to send partial updates to.
    ///   - body: The data to include in the request body.
    /// - Returns: The response data.
    /// - Throws: An `APIError` if the request fails.
    func patchData(to endpoint: String, body: Data) async throws -> Data
}

/// Default implementations for optional methods.
extension NetworkManaging {
    public func putData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.invalidRequestBody
    }

    public func patchData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.invalidRequestBody
    }
}
