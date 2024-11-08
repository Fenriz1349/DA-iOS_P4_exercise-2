import Foundation

struct UserListRepository {
    private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse)

    init(executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:)) {
        self.executeDataRequest = executeDataRequest
    }

    func fetchUsers(quantity: Int) async throws -> [User] {
        guard let url = URL(string: "https://randomuser.me/api/") else {
            throw URLError(.badURL)
        }

        // Utiliser l'extension URLRequest pour créer la requête
        let parameters: [String: Any] = ["results": quantity]
        
        let request = try URLRequest(
            url: url,
            method: .GET,
            parameters: parameters
        )

        let (data, _) = try await executeDataRequest(request)

        let response = try JSONDecoder().decode(UserListResponse.self, from: data)
               
        return response.results.map(User.init)
    }
}

