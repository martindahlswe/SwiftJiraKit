//
//  JQLBuilder.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2024-12-31.
//


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

    public func addCondition(field: String, comparisonOperator: String, values: [String]) -> JQLBuilder {
        let escapedValues = values.map { "\"\($0.replacingOccurrences(of: "\"", with: "\\\""))\"" }
        let condition = "\(field) \(comparisonOperator) (\(escapedValues.joined(separator: ", ")))"
        var newBuilder = self
        newBuilder.conditions.append(condition)
        return newBuilder
    }

    public func build() -> String {
        return conditions.joined(separator: " AND ")
    }
}
