struct ProductModel: Codable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let quantity: Int
    let imageUrl: String
    let category: String
    let brand: String
    let weight: String
    let reviews: [ReviewModel]?
    let averageRating: Double?
}
