import Foundation

public struct JQLBuilder {
    private var conditions: [String]

    public init() {
        self.conditions = []
    }

    public func addCondition(field: String, comparisonOperator: String, value: String) -> JQLBuilder {
        let escapedValue = value.replacingOccurrences(of: "\"", with: "\\\"")
        let condition = "\(field) \(comparisonOperator) \"\(escapedValue)\""
        var newBuilder = self
        newBuilder.conditions.append(condition)
        return newBuilder
    }

    public func addCondition(field: String, comparisonOperator: String, value: String, isFunction: Bool = false) -> JQLBuilder {
        let condition: String
        if isFunction {
            condition = "\(field) \(comparisonOperator) \(value)"
        } else {
            let escapedValue = value.replacingOccurrences(of: "\"", with: "\\\"")
            condition = "\(field) \(comparisonOperator) \"\(escapedValue)\""
        }
        var newBuilder = self
        newBuilder.conditions.append(condition)
        return newBuilder
    }

    public func build() -> String {
        return conditions.joined(separator: " AND ")
    }

    public func buildURLQuery() -> String {
        let jql = build()
        return "jql=\(jql.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
    }
}
