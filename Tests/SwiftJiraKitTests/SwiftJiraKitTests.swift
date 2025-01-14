import XCTest
@testable import SwiftJiraKit

final class SwiftJiraKitTests: XCTestCase {
    
    var api: SwiftJiraKit!
    var auth: JiraAuth!
    var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        auth = JiraAuth(token: "test-bearer-token")
        networkManager = NetworkManager()
        api = SwiftJiraKit(auth: auth, networkManager: networkManager)
    }
    
    func testAuthorization() {
        XCTAssertEqual(auth.getAuthorizationHeader()["Authorization"], "Bearer test-bearer-token")
    }
    
    func testFetchAssignedIssues() async throws {
        let issueManager = Issue(api: api)
        let issues = try await issueManager.fetchAssignedIssues(status: "Open")
        XCTAssertNotNil(issues)
    }
    
    func testFetchWorklogs() async throws {
        let worklogManager = Worklog(api: api)
        let worklogs = try await worklogManager.fetchWorklogs(issueKey: "TEST-1")
        XCTAssertNotNil(worklogs)
    }
    
    func testAddWorklog() async throws {
        let worklogManager = Worklog(api: api)
        try await worklogManager.addWorklog(issueKey: "TEST-1", timeSpent: "2h", comment: "Worked on the task")
    }
}
