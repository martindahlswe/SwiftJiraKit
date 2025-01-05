import Foundation

/// Represents a request to create or update a worklog in Jira.
public struct WorklogRequest: Encodable {
    public let timeSpent: String
    public let started: String
    public let comment: String
    public let visibility: Visibility?

    /// Represents the visibility settings for a worklog.
    public struct Visibility: Encodable {
        public let type: String
        public let value: String
    }

    /// Initializes a new worklog request.
    /// - Parameters:
    ///   - timeSpent: The time spent (e.g., "1h 30m").
    ///   - started: The start time in ISO 8601 format.
    ///   - comment: A comment for the worklog.
    ///   - visibility: Optional visibility settings.
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

    /// Convenience initializer using `Date` for the start time.
    /// - Parameters:
    ///   - timeSpent: The time spent (e.g., "1h 30m").
    ///   - started: The start time as a `Date`.
    ///   - comment: A comment for the worklog.
    ///   - visibility: Optional visibility settings.
    public init(
        timeSpent: String,
        started: Date,
        comment: String,
        visibility: Visibility? = nil
    ) {
        let dateFormatter = ISO8601DateFormatter()
        self.started = dateFormatter.string(from: started)
        self.timeSpent = timeSpent
        self.comment = comment
        self.visibility = visibility
    }
}
