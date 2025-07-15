import Foundation

struct App: Codable {
    let id: Int
    let name: String
    let version: String
    let description: String
    let iconURL: String
    let screens: [String]
    let website: String?
    let rating: Double?
    let reviews: [Review]?
    
    struct Review: Codable {
        let author: String
        let rating: Int
        let comment: String
        let date: String
    }
} 