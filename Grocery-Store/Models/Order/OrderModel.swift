import Foundation

struct OrderModel: Codable {
    let orderId: String
    let address: String
    let date: Date              // LocalDate
    let totalAmount: Double
    let items: [OrderItemModel]
}
