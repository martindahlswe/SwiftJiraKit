import Foundation

extension URLSession {
    // Use async/await with URLSession's data(for:) method
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(for: request)
    }
}
