struct ApiError: Codable {
    let field: String?
    let errorMessage: String
    let rejectedValue: String?
}
