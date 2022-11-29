import Foundation

protocol NetworkServiceMainProtocol {
    func getMovies(completion: @escaping (Result<Trends?, Error>) -> Void)
    func getSerials(completion: @escaping (Result<Populars?, Error>) -> Void)
}

final class NetworkServiceMain: NetworkServiceMainProtocol {
    
    func getMovies(completion: @escaping (Result<Trends?, Error>) -> Void) {
        URLSession.shared.dataTask(with: Section.movies.URLrequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error)
                return
            }
            
            do {
                let obj = try JSONDecoder().decode(Trends.self, from: data!)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
                print(error)
            }
        }.resume()
    }
    
    func getSerials(completion: @escaping (Result<Populars?, Error>) -> Void) {
        URLSession.shared.dataTask(with: Section.serials.URLrequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error)
                return
            }

            do {
                let obj = try JSONDecoder().decode(Populars.self, from: data!)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
                print(error)
            }
        }.resume()
    }
}



