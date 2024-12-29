import XCTest
@testable import SwiftJiraKit

final class WorklogServiceTests: XCTestCase {
    func testLogWork() {
        let mockNetworkManager = NetworkManager(baseURL: URL(string: "https://mock-url.com")!, token: "mockToken")
        let service = WorklogService(networkManager: mockNetworkManager)

        // Simulate logging work (mock the response for testing).
    }
}
