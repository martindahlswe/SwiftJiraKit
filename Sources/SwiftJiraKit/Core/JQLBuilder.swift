import Foundation

/// Builder for constructing Jira Query Language (JQL) queries.
public class JQLBuilder {
    private var components: [String] = []

    /// Adds a condition to filter by assignee.
    /// - Parameter assignee: The assignee's username.
    /// - Returns: The updated `JQLBuilder`.
    public func assignedTo(_ assignee: String) -> JQLBuilder {
        components.append("assignee = \"\(assignee)\"")
        return self
    }

    /// Adds a condition to filter by status.
    /// - Parameter status: The status to filter by.
    /// - Returns: The updated `JQLBuilder`.
    public func withStatus(_ status: String) -> JQLBuilder {
        components.append("status = \"\(status)\"")
        return self
    }

    /// Adds a condition to filter by issue type.
    /// - Parameter type: The issue type (e.g., "Bug", "Task").
    /// - Returns: The updated `JQLBuilder`.
    public func withIssueType(_ type: String) -> JQLBuilder {
        components.append("issuetype = \"\(type)\"")
        return self
    }

    /// Adds a condition to filter by creation date.
    /// - Parameter date: The creation date to filter by.
    /// - Returns: The updated `JQLBuilder`.
    public func createdOnOrAfter(_ date: Date) -> JQLBuilder {
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: date)
        components.append("created >= \"\(dateString)\"")
        return self
    }

    /// Resets the builder, clearing all previously added conditions.
    public func reset() {
        components.removeAll()
    }

    /// Builds the final JQL query string.
    /// - Returns: The constructed JQL query.
    public func build() -> String {
        guard !components.isEmpty else {
            return "" // Return an empty string if no conditions were added.
        }
        return components.joined(separator: " AND ")
    }

    /// Provides a preview of the current JQL query without finalizing it.
    /// - Returns: The current state of the query.
    public func preview() -> String {
        return build()
    }
}
