import Foundation

public struct WorklogRequest: Encodable {
    let timeSpentSeconds: Int
    let started: String
    let comment: String?
}

