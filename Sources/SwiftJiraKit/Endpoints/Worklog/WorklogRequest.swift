import Foundation

/// Represents a request to create or update a worklog in Jira.
public struct WorklogRequest: Encodable {
    public let timeSpent: String
    public let started: String
    public let comment: String?
    public let visibility: Visibility?

    /// Represents the visibility settings for a worklog.
    public struct Visibility: Encodable {
        public let type: String
        public let value: String

        /// Initializes visibility settings for the worklog.
        /// - Parameters:
        ///   - type: The type of visibility (e.g., "group").
        ///   - value: The value of the visibility setting (e.g., "jira-users").
        public init(type: String, value: String) {
            self.type = type
            self.value = value
        }
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
        comment: String? = nil,
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
        comment: String? = nil,
        visibility: Visibility? = nil
    ) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self.started = dateFormatter.string(from: started)
        self.timeSpent = timeSpent
        self.comment = comment
        self.visibility = visibility
    }
}
