import Foundation

struct Serial: Decodable {
    var backdrop_path: String?
    var genres: [Ganers]
    var overview: String?
    var vote_average: Double
    var first_air_date: String
    var original_name: String
//    var id: Int
}

struct Ganers: Decodable {
//    var id: Int
    var name: String
}
