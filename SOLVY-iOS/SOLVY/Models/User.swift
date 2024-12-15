import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let username: String
    var balance: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case balance
    }
}
