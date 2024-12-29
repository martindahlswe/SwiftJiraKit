import XCTest
@testable import SwiftJiraKit

final class ConnectivityServiceTests: XCTestCase {
    @MainActor
    func testValidateConnectivity() {
        // Mock `NetworkManager` and setup test responses
        let mockNetworkManager = MockNetworkManager(baseURL: URL(string: "https://example.atlassian.net")!, token: "mockToken")
        let connectivityService = ConnectivityService(networkManager: mockNetworkManager)

        let expectation = self.expectation(description: "Connectivity validation completes")

        connectivityService.validateConnectivity { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Connectivity check passed.")
            case .failure(let error):
                XCTFail("Connectivity check failed: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}

// Mock `NetworkManager` to simulate API responses.
final class MockNetworkManager: NetworkManager {
    override func sendRequest<T: Decodable>(
        endpoint: String,
        method: String,
        body: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if endpoint == "rest/api/2/myself" {
            // Simulate a successful response
            let response = MyselfResponse(selfURL: "https://example.atlassian.net/rest/api/2/myself", accountId: "12345")
            completion(.success(response as! T))
        } else {
            completion(.failure(NSError(domain: "Mock error", code: 401, userInfo: nil)))
        }
    }
}
