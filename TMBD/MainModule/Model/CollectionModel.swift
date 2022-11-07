import Foundation


struct Trends: Decodable {
    var results: [Trend]
}
    
struct Trend: Decodable {
    var poster_path: String?
    var adult: Bool
    var overview: String
    var release_date: String
    var genre_ids: [Int]
    var id: Int
    var original_title: String
    var original_language: String
    var title: String
    var backdrop_path: String?
    var popularity: Float
    var vote_count: Int
    var video: Bool
    var vote_average: Float
}

struct Populars: Decodable {
    var results: [Popular]
}
    
struct Popular: Decodable {
    var poster_path: String?
    var adult: Bool
    var overview: String
    var first_air_date: String
    var genre_ids: [Int]
    var id: Int
    var name: String
    var original_language: String
    var title: String?
    var backdrop_path: String?
    var popularity: Float
    var vote_count: Int
    var vote_average: Float
}


