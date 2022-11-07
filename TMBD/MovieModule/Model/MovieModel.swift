import Foundation

struct Movie: Decodable {
    var backdrop_path: String?
    var poster_path: String?
    var genres: [Geners]
    var overview: String?
    var vote_average: Double
    var runtime: Int
    var title: String
    var release_date: String
    var original_title: String
//    var id: Int
}

struct Geners: Decodable {
//    var id: Int
    var name: String
}

struct Casts: Decodable {
    var cast: [Cast]
}

struct Cast: Decodable {
    var profile_path: String?
    var character: String
    var name: String
}
