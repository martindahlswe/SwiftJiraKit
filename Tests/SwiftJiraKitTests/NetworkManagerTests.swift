//
//  NetworkManagerTests.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2024-12-30.
//


import XCTest
@testable import SwiftJiraKit

final class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!

    override func setUp() {
        let baseURL = URL(string: "https://example.com")!
        networkManager = NetworkManager(baseURL: baseURL, token: "test-token")
    }

    func testSendRequest() async throws {
        // Use URLProtocol or Mocks for integration tests with NetworkManager
    }
}
