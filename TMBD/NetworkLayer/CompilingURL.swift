import Foundation


//MARK: - Generate URL(RandomPhoto module)
enum Section {
    case movies
    case serials
    case movie (id: Int)
    case cast (id: Int)
    case serial (id: Int)
    case castv (id: Int)
    
    private var urlComponents: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
       
        switch self {
        case .movies:
            components.path = "/3/trending/movie/day"
//            components.queryItems = [URLQueryItem(name: "api_key", value: "a75972c63240b96a3ed54d0b53aad854")]
            
        case .serials:
            components.path = "/3/trending/tv/day"
            
        case .movie(id: let id):
            components.path = "/3/movie/" + String(id)
            
        case .cast(id: let id):
            components.path = "/3/movie/" + String(id) + "/credits"
            
        case .serial(id: let id):
            components.path = "/3/tv/" + String(id)
            
        case .castv(id: let id):
            components.path = "/3/tv/" + String(id) + "/credits"
        }
        return components.url!
    }
    
    //MARK: - Generate URL(RandomPhoto module)
    
    var URLrequest: URLRequest {
        var request = URLRequest(url: urlComponents)
        request.httpMethod = "GET"
        var header = [String: String]()
        header["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNzU5NzJjNjMyNDBiOTZhM2VkNTRkMGI1M2FhZDg1NCIsInN1YiI6IjYzNjE5ZDRmYmU1NWI3MDA5ODE4ZDc3YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.gxWPnJQG2iiryVYNAePMR389UH6LqDvKAtd-93isjyw"
        request.allHTTPHeaderFields = header
        return request
    }
}

