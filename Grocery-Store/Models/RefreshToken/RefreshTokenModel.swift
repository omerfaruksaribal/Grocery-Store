import Foundation

struct RefreshTokenModel: Codable {
    var id: String
    var token: String
    var userId: String
    var expiryDate: Date
}
