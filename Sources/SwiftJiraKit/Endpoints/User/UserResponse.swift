import Foundation

public struct UserResponse: Codable, Sendable {
    let accountID: String
    let accountType: String
    let active: Bool
    let displayName: String
    let email: String
    let name: String
    let timeZone: String
}
