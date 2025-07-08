import Foundation

private enum WishlistEndpoint {

    case list
    case add
    case remove(productId: String)
    case clear

    var value: Endpoint {
        switch self {
        case .list:
            return Endpoint(path: "/wishlist", method: .GET)
        case .add:
            return Endpoint(path: "/wishlist", method: .POST)
        case .remove(let id):
            return Endpoint(path: "/wishlist/\(id)", method: .DELETE)
        case .clear:
            return Endpoint(path: "/wishlist", method: .DELETE)
        }
    }
}

final class WishlistService {
    private let network: NetworkServiceProtocol
    init(network: NetworkServiceProtocol = NetworkManager()) {
        self.network = network
    }

    let decodeTo = ApiResponse<WishlistResponseData>.self

    // GET /wishlist
    func getMyWishlist()
    async throws -> ApiResponse<WishlistResponseData> {

        let endpoint = WishlistEndpoint.list.value

        return try await network.request( endpoint, decodeTo: decodeTo )
    }

    // POST /wishlist
    func addToWishlist(_ req: AddToWishlistRequest)
    async throws -> ApiResponse<WishlistResponseData> {

        let endpoint = Endpoint(
            path: WishlistEndpoint.add.value.path,
            method: .POST,
            body: try? JSONEncoder().encode(req)
        )

        return try await network.request( endpoint, decodeTo: decodeTo )
    }

    // DELETE /wishlist/{id}
    func removeFromWishlist(productId: String)
    async throws -> ApiResponse<WishlistResponseData> {
        let endpoint = WishlistEndpoint.remove(productId: productId).value

        return try await network.request( endpoint, decodeTo: decodeTo )
    }

    // DELETE /wishlist
    func clearWishlist()
    async throws -> ApiResponse<WishlistResponseData> {

        let endpoint = WishlistEndpoint.clear.value

        return try await network.request( endpoint, decodeTo: decodeTo )
    }
}

