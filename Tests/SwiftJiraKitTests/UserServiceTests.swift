// Mocking and testing UserService
import XCTest
@testable import SwiftJiraKit

class UserServiceTests: XCTestCase {
    var mockNetworkManager: MockNetworkManager!
    var userService: UserService!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager(baseURL: URL(string: "https://example.com")!, token: "dummyToken")
        userService = UserService(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        mockNetworkManager = nil
        userService = nil
        super.tearDown()
    }

    func testGetUserSuccess() {
        let expectedAccountId = "12345"
        let expectedResponse = UserResponse(
            accountID: "12345",
            accountType: "atlassian",
            active: true,
            displayName: "Test User",
            email: "testuser@example.com",
            name: "testuser",
            timeZone: "UTC"
        )
        let responseData = try! JSONEncoder().encode(expectedResponse)
        mockNetworkManager.completionResult = .success(responseData)

        let expectation = XCTestExpectation(description: "Completion handler called")

        userService.getUser(accountId: expectedAccountId) { [expectedResponse] result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.accountID, expectedResponse.accountID)
                XCTAssertEqual(response.accountType, expectedResponse.accountType)
                XCTAssertEqual(response.active, expectedResponse.active)
                XCTAssertEqual(response.displayName, expectedResponse.displayName)
                XCTAssertEqual(response.email, expectedResponse.email)
                XCTAssertEqual(response.name, expectedResponse.name)
                XCTAssertEqual(response.timeZone, expectedResponse.timeZone)

            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(mockNetworkManager.lastRequest?.endpoint, "rest/api/2/user")
        XCTAssertEqual(mockNetworkManager.lastRequest?.method, "GET")
        guard let lastRequestBody = mockNetworkManager.lastRequest?.body else {
            XCTFail("Expected request body but found nil")
            return
        }
        let requestBody = try! JSONDecoder().decode(UserRequest.self, from: lastRequestBody)
        XCTAssertEqual(requestBody.accountId, expectedAccountId)
    }


    func testGetUserFailure() {
        mockNetworkManager.completionResult = .failure(NSError(domain: "TestError", code: 1, userInfo: nil))

        let expectation = XCTestExpectation(description: "Completion handler called")

        userService.getUser(accountId: "123456") { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure but got success")

            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "TestError")
                XCTAssertEqual((error as NSError).code, 1)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
