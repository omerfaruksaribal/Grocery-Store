import Foundation

struct ReviewModel: Codable {
    let username: String
    let rating: Int
    let comment: String
    let date: Date
}
