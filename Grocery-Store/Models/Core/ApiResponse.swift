import Foundation

struct ApiResponse<DataType: Codable>: Codable {
    let status: Int
    let message: String
    let data: DataType?
    let timestamp: Date                // Instant
    let errors: [ApiError]?
}
