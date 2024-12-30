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
    var lastRequest: (endpoint: String, method: String, body: Data?)?
    var completionResult: Result<Data, Error>?

    override func sendRequest<T: Decodable>(
        endpoint: String,
        method: String,
        body: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        lastRequest = (endpoint, method, body)

        if let result = completionResult {
            // Use the explicitly set completion result for testing
            switch result {
            case .success(let data):
                if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(decodedResponse))
                } else {
                    completion(.failure(NSError(domain: "DecodingError", code: 1, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            return
        }

        // Default behaviors for specific endpoints
        if endpoint == "rest/api/2/myself" {
            let response = MyselfResponse(selfURL: "https://example.atlassian.net/rest/api/2/myself", accountId: "12345")
            if let typedResponse = response as? T {
                completion(.success(typedResponse))
            } else {
                completion(.failure(NSError(domain: "TypeMismatch", code: 1, userInfo: nil)))
            }
        } else if endpoint == "rest/api/2/user" {
            let response = UserResponse(
                accountID: "12345",
                accountType: "atlassian",
                active: true,
                displayName: "Test User",
                email: "testuser@example.com",
                name: "testuser",
                timeZone: "UTC"
            )
            if let typedResponse = response as? T {
                completion(.success(typedResponse))
            } else {
                completion(.failure(NSError(domain: "TypeMismatch", code: 1, userInfo: nil)))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 401, userInfo: nil)))
        }
    }
}

