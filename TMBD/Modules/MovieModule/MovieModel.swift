import Foundation

struct Movie: Decodable {
    let poster_path: String?
    let genres: [Geners]
    let overview: String?
    let vote_average: Double
    let runtime: Int
    let title: String
    let release_date: String
    let original_title: String
}

struct Geners: Decodable {
    let name: String
}

struct Casts: Decodable {
    let cast: [Cast]
}

struct Cast: Decodable {
    let profile_path: String?
    let character: String
    let name: String
}
