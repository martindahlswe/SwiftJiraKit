// NetworkManaging.swift

import Foundation

public protocol NetworkManaging {
    func sendRequest<T: Decodable>(
        endpoint: String,
        method: String,
        body: Data?, // Keep this optional
        completion: @escaping @Sendable (Result<T, Error>) -> Void
    )
}
