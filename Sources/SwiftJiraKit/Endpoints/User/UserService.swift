import Foundation

public class UserService {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    public func getUser(
        accountId: String,
        completion: @escaping @Sendable (Result<UserResponse, Error>) -> Void
    ) {
        let endpoint = "rest/api/2/user"
        let user = UserRequest(
            accountId: accountId
        )
        do {
            let body = try JSONEncoder().encode(user)
            networkManager.sendRequest(endpoint: endpoint, method: "GET", body: body, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}
