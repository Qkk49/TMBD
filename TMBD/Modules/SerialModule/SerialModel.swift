import Foundation

struct Serial: Decodable {
    let backdrop_path: String?
    let genres: [Ganers]
    let overview: String?
    let vote_average: Double
    let first_air_date: String
    let original_name: String
}

struct Ganers: Decodable {
    let name: String
}
