import Foundation

/// Represents errors that can occur while interacting with the Jira API.
public enum APIError: Error, LocalizedError, Equatable {
    case invalidResponse
    case decodingError
    case networkError(Error)
    case invalidRequestBody
    case unauthorized
    case notFound
    case unknown(String)

    /// A user-friendly description of the error.
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The response from the server was invalid."
        case .decodingError:
            return "Failed to decode the response from the server."
        case .networkError(let error):
            return "A network error occurred: \(error.localizedDescription)"
        case .invalidRequestBody:
            return "The request body is invalid."
        case .unauthorized:
            return "The request is unauthorized. Please check your credentials."
        case .notFound:
            return "The requested resource was not found."
        case .unknown(let message):
            return "An unknown error occurred: \(message)"
        }
    }

    /// Provides a detailed debug description for developers.
    public var debugDescription: String {
        switch self {
        case .networkError(let error):
            return "NetworkError(debug): \(error)"
        default:
            return errorDescription ?? "No description available."
        }
    }

    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidResponse, .invalidResponse),
             (.decodingError, .decodingError),
             (.invalidRequestBody, .invalidRequestBody),
             (.unauthorized, .unauthorized),
             (.notFound, .notFound):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.unknown(let lhsMessage), .unknown(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
