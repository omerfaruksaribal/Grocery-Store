import Foundation

private enum CartEndpoint {
    case list
    case add
    case updateQty(productId: String)
    case remove(productId: String)

    var value: Endpoint {
        switch self {
        case .list:
            return Endpoint(path: "/cart", method: .GET)
        case .add:
            return Endpoint(path: "/cart", method: .POST)
        case .updateQty(let id):
            return Endpoint(path: "/cart/\(id)", method: .PATCH)
        case .remove(let id):
            return Endpoint(path: "/cart/\(id)", method: .DELETE)
        }
    }
}

final class CartService {
    private let network: NetworkServiceProtocol
    init(network: NetworkServiceProtocol = NetworkManager()) {
        self.network = network
    }

    let decodeTo = ApiResponse<CartData>.self

    /// GET /cart
    func getMyCart() async throws -> ApiResponse<CartData> {
        let endpoint = CartEndpoint.list.value

        return try await network.request( endpoint, decodeTo: decodeTo )
    }

    /// POST /cart
    func addItem(_ req: AddItemRequest) async throws -> ApiResponse<CartData> {

        let endpoint = Endpoint(
            path: CartEndpoint.add.value.path,
            method: .POST,
            body: try? JSONEncoder().encode(req)
        )

        return try await network.request( endpoint, decodeTo: decodeTo )
    }

    /// PATCH /cart/{productId}
    func updateQuantity(productId: String, to qty: Int) async throws -> ApiResponse<CartData> {

        let body = try? JSONEncoder().encode(UpdateQuantityRequest(quantity: qty))

        let endpoint = Endpoint(
            path: CartEndpoint.updateQty(productId: productId).value.path,
            method: .PATCH,
            body: body
        )

        return try await network.request( endpoint, decodeTo: decodeTo )
    }

    /// DELETE /cart/{productId}
    func removeItem(productId: String) async throws -> ApiResponse<CartData> {

        let endpoint = CartEndpoint.remove(productId: productId).value

        return try await network.request( endpoint, decodeTo: decodeTo )
    }
}
