import XCTest
@testable import SwiftJiraKit

final class IssueServiceTests: XCTestCase {
    
    @MainActor
    func testGetIssue_Success() {
        // Arrange
        let mockNetworkManager = MockNetworkManager()
        let issueService = IssueService(networkManager: mockNetworkManager)

        let expectedResponse = IssueResponse(
            id: "1",
            key: "TEST-1",
            fields: .init(
                summary: "Test Issue",
                description: "This is a test issue",
                status: .init(name: "Open")
            )
        )

        let responseData = try! JSONEncoder().encode(expectedResponse)
        mockNetworkManager.mockResponse = .success(responseData)

        let expectation = self.expectation(description: "Completion handler invoked")

        // Act
        issueService.getIssue(issueKey: "TEST-1") { result in
            // Assert
            switch result {
            case .success(let issue):
                XCTAssertEqual(issue.key, "TEST-1")
                XCTAssertEqual(issue.fields.summary, "Test Issue")
                XCTAssertEqual(issue.fields.status.name, "Open")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    @MainActor
    func testSearchIssues_Success() {
        // Arrange
        let mockNetworkManager = MockNetworkManager()
        let issueService = IssueService(networkManager: mockNetworkManager)

        let expectedIssues = [
            IssueResponse(
                id: "1",
                key: "TEST-1",
                fields: .init(
                    summary: "First Issue",
                    description: nil,
                    status: .init(name: "In Progress")
                )
            ),
            IssueResponse(
                id: "2",
                key: "TEST-2",
                fields: .init(
                    summary: "Second Issue",
                    description: "Another issue",
                    status: .init(name: "Done")
                )
            )
        ]

        let expectedResponse = MockSearchResponse(issues: expectedIssues)
        let responseData = try! JSONEncoder().encode(expectedResponse)
        mockNetworkManager.mockResponse = .success(responseData)

        let expectation = self.expectation(description: "Completion handler invoked")

        // Act
        issueService.searchIssues(jql: "project = TEST") { result in
            // Assert
            switch result {
            case .success(let issues):
                XCTAssertEqual(issues.count, 2)
                XCTAssertEqual(issues[0].key, "TEST-1")
                XCTAssertEqual(issues[1].fields.status.name, "Done")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(mockNetworkManager.requestedEndpoint, "rest/api/2/search")
        XCTAssertEqual(mockNetworkManager.requestedMethod, "POST")
    }

    @MainActor
    func testGetIssue_Failure() {
        // Arrange
        let mockNetworkManager = MockNetworkManager()
        let issueService = IssueService(networkManager: mockNetworkManager)

        mockNetworkManager.mockResponse = .failure(APIError.invalidResponse)

        let expectation = self.expectation(description: "Completion handler invoked")

        // Act
        issueService.getIssue(issueKey: "TEST-1") { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertTrue(error is APIError)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    @MainActor
    func testSearchIssues_Failure() {
        // Arrange
        let mockNetworkManager = MockNetworkManager()
        let issueService = IssueService(networkManager: mockNetworkManager)

        mockNetworkManager.mockResponse = .failure(APIError.invalidResponse)

        let expectation = self.expectation(description: "Completion handler invoked")

        // Act
        issueService.searchIssues(jql: "project = TEST") { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertTrue(error is APIError)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
