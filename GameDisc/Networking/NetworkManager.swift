import UIKit

class NetworkManager {
    static let shared = NetworkManager() // Instância Única
    
    private init() {}
    
    // MARK: Properties
    
    private let baseURL = URL(string: "https://api.igdb.com/v4/")!
    private let clientID = "c39jev113h8yvzp6mm93mcbm1t020o"
    private let accessToken = "73mfpf2poavgthdh4pbi2sylov667p"
    
    //private let platformsInRequest = "platforms = (6, 49, 48)" // PC, XBOX, PS
    
    // MARK: Métodos Privados
    
    // Configuração da sessão
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    // Função Principal da API (Funciona normalmente)
    
    /// Busca dados no endpoint especificado da API, decodifica usando o tipo de resposta fornecido e uma função handler.
    
    /// - Parametros:
    ///   - fromEndpoint: O endpoint da API para buscar dados
    ///   - withBody: Os dados para incluir no corpo da requisição (para requisições POST)
    ///   - responseType: O tipo para decodificar a resposta da API
    ///   - completion: Um handler a ser chamado com o resultado
    
    private func fetchData<T: Decodable>(fromEndpoint endpoint: String, withBody bodyData: Data?, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL.appendingPathComponent(endpoint)
        
        var request = URLRequest(url: url)
        request.setCommonHeaders(clientID: clientID, accessToken: accessToken)
        
        if let bodyData = bodyData {
            request.httpMethod = "POST"
            request.httpBody = bodyData
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8))
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: Métodos Publicos
    
 
    public func fetchLovedGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        let requestBody = """
        fields id,name,rating,screenshots.image_id,genres.name,age_ratings.category,age_ratings.rating,involved_companies.company.name,summary,release_dates.y;
        where screenshots != null & rating != null & genres != null & age_ratings != null & involved_companies != null & summary != null & release_dates != null & platforms = (6, 48, 49);
        sort rating_count desc;
        limit 10;
        """
        fetchData(fromEndpoint: "games", withBody: requestBody.data(using: .utf8), responseType: [Game].self, completion: completion)
    }
    
    public func fetchGenreList(genreId: Int, completion: @escaping (Result<[Game], Error>) -> Void) {
        let requestBody = """
        fields id,name,rating,screenshots.image_id,genres.name,age_ratings.category,age_ratings.rating,involved_companies.company.name,summary,release_dates.y;
        where screenshots != null & rating != null & genres != null & age_ratings != null & involved_companies != null & summary != null & release_dates != null & platforms = (6, 48, 49) & genres = (\(genreId));
        sort rating_count desc;
        limit 10;
        """
        fetchData(fromEndpoint: "games", withBody: requestBody.data(using: .utf8), responseType: [Game].self, completion: completion)
    }
}

// Definir os cabeçalhos da requisição

extension URLRequest {
    mutating func setCommonHeaders(clientID: String, accessToken: String) {
        self.setValue(clientID, forHTTPHeaderField: "Client-ID")
        self.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        self.setValue("application/json", forHTTPHeaderField: "Accept")
    }
}


