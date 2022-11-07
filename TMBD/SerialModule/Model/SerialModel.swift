import Foundation

struct Serial: Decodable {
    var backdrop_path: String?
    var genres: [Ganers]
    var overview: String?
    var vote_average: Double
    var first_air_date: String
    var original_name: String
}

struct Ganers: Decodable {
    var name: String
}

struct Caststv: Decodable {
    var cast: [Casttv]
}

struct Casttv: Decodable {
    var profile_path: String?
    var character: String
    var name: String
}
