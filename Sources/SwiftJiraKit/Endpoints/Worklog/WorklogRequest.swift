import Foundation

public struct WorklogRequest: Codable {
    public let timeSpent: String        // e.g., "1h 30m"
    public let comment: String
    public let started: String         // e.g., "2023-10-14T09:00:00.000+0000"
    
    public init(timeSpent: String, comment: String, started: String) {
        self.timeSpent = timeSpent
        self.comment = comment
        self.started = started
    }
}
