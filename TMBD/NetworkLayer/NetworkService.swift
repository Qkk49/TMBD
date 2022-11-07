import Foundation

protocol NetworkServiceProtocol {
    func getMovies(completion: @escaping (Result<Trends?, Error>) -> Void)
    func getSerials(completion: @escaping (Result<Populars?, Error>) -> Void)
    func getMovie(id: Int, completion: @escaping (Result<Movie?, Error>) -> Void)
    func getCast(id: Int, completion: @escaping (Result<Casts?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func getMovies(completion: @escaping (Result<Trends?, Error>) -> Void) {
        URLSession.shared.dataTask(with: Section.movies.URLrequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let obj = try JSONDecoder().decode(Trends.self, from: data!)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getSerials(completion: @escaping (Result<Populars?, Error>) -> Void) {
        URLSession.shared.dataTask(with: Section.serials.URLrequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let obj = try JSONDecoder().decode(Populars.self, from: data!)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getMovie(id: Int, completion: @escaping (Result<Movie?, Error>) -> Void) {
        URLSession.shared.dataTask(with: Section.movie(id: id).URLrequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                //print("Fetch failed: \(error.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let obj = try JSONDecoder().decode(Movie.self, from: data!)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
                print("aaaa")
            }
        }.resume()
    }
    
    func getCast(id: Int, completion: @escaping (Result<Casts?, Error>) -> Void) {
        URLSession.shared.dataTask(with: Section.cast(id: id).URLrequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                //print("Fetch failed: \(error.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let obj = try JSONDecoder().decode(Casts.self, from: data!)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
                print("aaaa")
            }
        }.resume()
    }
}



