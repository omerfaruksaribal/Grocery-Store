import Foundation

private enum OrderEndpoint {
    case place(PlaceOrderRequest)
    case list
    case detail(id: String)

    var value: Endpoint {
        switch self {
        case .place(let payload):
            let body = try? JSONEncoder().encode(payload)
            return Endpoint(
                path: "/orders",
                method: .POST,
                body: body
            )
        case .list:
            return Endpoint(path: "/orders", method: .GET)
        case .detail(let id):
            return Endpoint(path: "/orders/\(id)", method: .GET)
        }
    }
}

final class OrderService {
    private let network: NetworkServiceProtocol
    init(network: NetworkServiceProtocol = NetworkManager()) {
        self.network = network
    }

    // MARK: – Public API

    // POST /orders
    @MainActor
    func placeOrder(_ req: PlaceOrderRequest) async throws -> ApiResponse<OrderModel> {
        
        let endpoint = OrderEndpoint.place(req).value

        return try await network.request( endpoint, decodeTo: ApiResponse<OrderModel>.self )
    }

    @MainActor
    func getMyOrders() async throws -> ApiResponse<OrderListResponseData> {

        let endpoint = OrderEndpoint.list.value

        return try await network.request( endpoint, decodeTo: ApiResponse<OrderListResponseData>.self )
    }

    @MainActor
    func getOrder(id: String) async throws -> ApiResponse<OrderModel> {

        let endpoint = OrderEndpoint.detail(id: id).value

        return try await network.request( endpoint, decodeTo: ApiResponse<OrderModel>.self )
    }
}
