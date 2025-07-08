import Foundation

private enum ProductEndpoint {
    case list(page: Int)                  
    case detail(id: String)

    var value: Endpoint {
        switch self {

        case .list(let page):
            return Endpoint(
                path: "/products?page=\(page)",
                method: .GET
            )

        case .detail(let id):
            return Endpoint(
                path: "/products/\(id)",
                method: .GET
            )
        }
    }
}

final class ProductService {
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol = NetworkManager()) {
        self.network = network
    }

    //  MARK: - Public API

    /// /products?page= → ApiResponse<ProductListResponseData>
    @MainActor
    func getProducts(page: Int = 0) async throws -> ApiResponse<ProductListResponseData> {

        let endpoint = ProductEndpoint.list(page: page).value

        return try await network.request(endpoint, decodeTo: ApiResponse<ProductListResponseData>.self)
    }

    /// /products/{id} → ApiResponse<ProductModel>
    @MainActor
    func getProduct(id: String) async throws -> ApiResponse<ProductModel> {

        let endpoint = ProductEndpoint.detail(id: id).value

        return try await network.request(endpoint, decodeTo: ApiResponse<ProductModel>.self)
    }

}
