import XCTest
@testable import SwiftJiraKit

final class WorklogServiceTests: XCTestCase {
    var mockNetworkManager: MockNetworkManager!
    var service: WorklogService!

    override func setUp() {
        mockNetworkManager = MockNetworkManager()
        service = WorklogService(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        mockNetworkManager = nil
        service = nil
    }

    func testGetWorklogsSuccess() throws {
        let expectation = self.expectation(description: "Get Worklogs Success")
        let issueKey = "TEST-123"
        let mockResponse = [
            WorklogResponse(
                id: "1",
                issueId: issueKey,
                author: WorklogResponse.User(accountId: "123", displayName: "John Doe", active: true),
                updateAuthor: WorklogResponse.User(accountId: "123", displayName: "John Doe", active: true),
                comment: "This is a test comment",
                started: "2023-01-01T12:00:00.000Z",
                timeSpent: "1h",
                timeSpentSeconds: 3600
            )
        ]
        mockNetworkManager.mockResponse = .success(try JSONEncoder().encode(mockResponse))

        service.getWorklogs(issueKey: issueKey) { result in
            switch result {
            case .success(let worklogs):
                XCTAssertEqual(worklogs.count, 1)
                XCTAssertEqual(worklogs.first?.id, "1")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testGetWorklogsEmptyResponse() throws {
        let expectation = self.expectation(description: "Get Worklogs Empty Response")
        let issueKey = "TEST-123"
        let mockResponse: [WorklogResponse] = []
        mockNetworkManager.mockResponse = .success(try JSONEncoder().encode(mockResponse))

        service.getWorklogs(issueKey: issueKey) { result in
            switch result {
            case .success(let worklogs):
                XCTAssertEqual(worklogs.count, 0)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testGetWorklogsFailure() throws {
        let expectation = self.expectation(description: "Get Worklogs Failure")
        let issueKey = "TEST-123"
        mockNetworkManager.mockResponse = .failure(APIError.invalidResponse)

        service.getWorklogs(issueKey: issueKey) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error as? APIError, APIError.invalidResponse)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testAddWorklogSuccess() throws {
        let expectation = self.expectation(description: "Add Worklog Success")
        let issueKey = "TEST-123"
        let worklogRequest = WorklogRequest(
            timeSpent: "1h",
            timeSpentSeconds: 3600,
            started: "2023-01-01T12:00:00.000Z",
            comment: "This is a test worklog",
            visibility: nil
        )
        let mockResponse = WorklogResponse(
            id: "1",
            issueId: issueKey,
            author: WorklogResponse.User(accountId: "123", displayName: "John Doe", active: true),
            updateAuthor: WorklogResponse.User(accountId: "123", displayName: "John Doe", active: true),
            comment: "This is a test worklog",
            started: "2023-01-01T12:00:00.000Z",
            timeSpent: "1h",
            timeSpentSeconds: 3600
        )
        mockNetworkManager.mockResponse = .success(try JSONEncoder().encode(mockResponse))

        service.addWorklog(issueKey: issueKey, worklog: worklogRequest) { result in
            switch result {
            case .success(let worklog):
                XCTAssertEqual(worklog.id, "1")
                XCTAssertEqual(worklog.comment, "This is a test worklog")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testAddWorklogFailure() throws {
        let expectation = self.expectation(description: "Add Worklog Failure")
        let issueKey = "TEST-123"
        let worklogRequest = WorklogRequest(
            timeSpent: "1h",
            timeSpentSeconds: 3600,
            started: "2023-01-01T12:00:00.000Z",
            comment: "This is a test worklog",
            visibility: nil
        )
        mockNetworkManager.mockResponse = .failure(APIError.invalidResponse)

        service.addWorklog(issueKey: issueKey, worklog: worklogRequest) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error as? APIError, APIError.invalidResponse)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
