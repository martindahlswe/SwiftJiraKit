import Foundation

public enum APIError: Error {
    case invalidResponse
    case decodingError
    case networkError(Error)
}

