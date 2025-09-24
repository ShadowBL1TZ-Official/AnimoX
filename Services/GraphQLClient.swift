import Foundation

struct GraphQLRequestBody: Encodable {
    let query: String
    let variables: [String: AnyEncodable]
}

struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void
    init<T: Encodable>(_ value: T) { self.encodeFunc = value.encode }
    func encode(to encoder: Encoder) throws { try encodeFunc(encoder) }
}

final class GraphQLClient {
    let endpoint: URL
    init(endpoint: URL) { self.endpoint = endpoint }

    func query(_ query: String, variables: [String: AnyEncodable] = [:]) async throws -> Data {
        let body = GraphQLRequestBody(query: query, variables: variables)
        let (data, _) = try await HTTPClient.shared.postJSON(url: endpoint, body: body)
        return data
    }
}
