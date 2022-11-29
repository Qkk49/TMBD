import Foundation

protocol NetworkServiceDetailProtocol {
    func getMovie(id: Int, completion: @escaping (Result<Movie?, Error>) -> Void)
    func getSerial(id: Int, completion: @escaping (Result<Serial?, Error>) -> Void)
    
    func getCast(type: String, id: Int, completion: @escaping (Result<Casts?, Error>) -> Void)
}

final class NetworkServiceDetail: NetworkServiceDetailProtocol {
    
    func getMovie(id: Int, completion: @escaping (Result<Movie?, Error>) -> Void) {
        URLSession.shared.dataTask(with: Section.movie(id: id).URLrequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error)
                return
            }

            do {
                let obj = try JSONDecoder().decode(Movie.self, from: data!)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
                print(error)
            }
        }.resume()
    }
    
    func getSerial(id: Int, completion: @escaping (Result<Serial?, Error>) -> Void) {
        URLSession.shared.dataTask(with: Section.serial(id: id).URLrequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error)
                return
            }

            do {
                let obj = try JSONDecoder().decode(Serial.self, from: data!)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
                print(error)
            }
        }.resume()
    }
    
    func getCast(type: String, id: Int, completion: @escaping (Result<Casts?, Error>) -> Void) {
        URLSession.shared.dataTask(with: Section.cast(type: type, id: id).URLrequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print(error)
                return
            }
            
            do {
                let obj = try JSONDecoder().decode(Casts.self, from: data!)
                completion(.success(obj))
            } catch {
                completion(.failure(error))
                print(error)
            }
        }.resume()
    }
}
