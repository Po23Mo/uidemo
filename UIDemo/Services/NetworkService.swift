import Foundation

class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "http://localhost:8000"
    
    private init() {}
    
    func fetchAppDetail(completion: @escaping (Result<App, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/app.json") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let app = try JSONDecoder().decode(App.self, from: data)
                completion(.success(app))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func searchApps(query: String, completion: @escaping (Result<[App], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let apps = try JSONDecoder().decode([App].self, from: data)
                completion(.success(apps))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func collectApp(id: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/collect") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["id": id]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(true))
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
} 