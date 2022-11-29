import Foundation

struct Trends: Decodable {
    let results: [Trend]
}
    
struct Trend: Decodable {
    let poster_path: String?
    let release_date: String
    let id: Int
    let original_title: String
}

struct Populars: Decodable {
    let results: [Popular]
}
    
struct Popular: Decodable {
    let poster_path: String?
    let first_air_date: String
    let id: Int
    let name: String
}


