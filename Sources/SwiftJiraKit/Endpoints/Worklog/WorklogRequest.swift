import Foundation

public struct WorklogRequest: Encodable {
    public let timeSpent: String
    public let started: String
    public let comment: String
    public let visibility: Visibility?

    public struct Visibility: Encodable {
        public let type: String
        public let value: String
    }

    public init(
        timeSpent: String,
        started: String,
        comment: String,
        visibility: Visibility? = nil
    ) {
        self.timeSpent = timeSpent
        self.started = started
        self.comment = comment
        self.visibility = visibility
    }
}
