import Foundation

struct UserModel: Codable {
    var id: String
    var username: String
    var email: String
    var password: String                 // only used for register / login
    var activationCode: String
    var resetPasswordCode: String
    var activationCodeExpiryDate: Date?
    var resetPasswordCodeExpiryDate: Date?
    var enabled: Bool
    var cart: [CartItemModel]
    var orders: [OrderModel]
    var wishlist: [String]               // productId list
    var createdAt: Date
    var lastModifiedAt: Date
}
