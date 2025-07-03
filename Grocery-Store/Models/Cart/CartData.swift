struct CartData: Codable {
    let cartItems: [CartItemModel]
    let totalPrice: Double
}
