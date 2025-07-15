import Foundation

struct Setting: Codable {
    var isDarkMode: Bool
    var fontSize: Float
    var cacheDays: Int
    var username: String
    var birthday: Date
    var theme: String
    
    static let defaultSettings = Setting(
        isDarkMode: false,
        fontSize: 16.0,
        cacheDays: 7,
        username: "",
        birthday: Date(),
        theme: "Light"
    )
}

struct Favorite: Codable {
    let id: Int
    let name: String
    let iconURL: String
    let addedDate: Date
} 