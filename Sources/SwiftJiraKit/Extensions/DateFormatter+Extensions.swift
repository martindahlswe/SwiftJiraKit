import Foundation

/// Extension providing common date formats used in Jira API operations.
extension DateFormatter {
    /// ISO 8601 date formatter.
    /// - Format: `"yyyy-MM-dd'T'HH:mm:ss.SSSZ"`
    public static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    /// Simplified date formatter for Jira operations.
    /// - Format: `"yyyy-MM-dd"`
    public static let jiraDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
