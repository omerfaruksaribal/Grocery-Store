struct ProductListResponseData: Codable {
    let products: [ProductModel]
    let totalProducts: Int
    let totalPages: Int
    let currentPage: Int
}
