import Foundation

public enum APIError: Error, Equatable {
    case invalidResponse
    case decodingError
    case networkError(Error)
    case invalidRequestBody

    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidResponse, .invalidResponse),
             (.decodingError, .decodingError),
             (.invalidRequestBody, .invalidRequestBody):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
