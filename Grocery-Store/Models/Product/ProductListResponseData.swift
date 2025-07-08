import Foundation

/// `GET /products` response
struct ProductListResponseData: Codable {
    let products:    [ProductModel]
    let currentPage: Int
    let totalPages:  Int
}
