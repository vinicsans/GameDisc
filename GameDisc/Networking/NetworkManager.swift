import UIKit
 
class NetworkManager {
    static let shared = NetworkManager() // Instância Única
 
    private init() {}
 
    // MARK: Properties
 
    private let baseURL = URL(string: "https://api.igdb.com/v4/")!
    private let clientID = "c39jev113h8yvzp6mm93mcbm1t020o"
    private let accessToken = "73mfpf2poavgthdh4pbi2sylov667p"
 
    private let fieldsInRequest = "fields name, genres, screenshots, rating_count"
    private let platformsInRequest = "platforms = (6, 49, 48)" // PC, XBOX, PS
    
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
 
    private func fetchData<T: Decodable>(fromEndpoint endpoint: String, withBody bodyData: Data?, responseType: T.Type, completion: @escaping (Result<[Game], Error>) -> Void) {
        let url = URL(string: "https://api.igdb.com/v4/\(endpoint)")
 
        var request = URLRequest(url: url!)
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
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedData = try decoder.decode([Game].self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
 
        task.resume()
    }
 
    // MARK: Métodos Publicos
 
    // Busca jogos de um gênero específico.
 
    // - Parametros:
    //   - amount: O número de jogos a buscar
    //   - genreId: O ID do gênero para filtrar
    //   - completion: um handler a ser chamado com os dados recebidos
 
    public func fetchGamesByGenre(amount: Int, genreId: Int, completion: @escaping (Result<[Game], Error>) -> Void) {
        let requestBody = """
            \(fieldsInRequest);
            where genres = (\(genreId)) & \(platformsInRequest);
            limit \(amount);
        """
        fetchData(fromEndpoint: "games", withBody: requestBody.data(using: .utf8), responseType: [Game].self, completion: completion)
    }
 
    // Busca jogos com alta avaliação
 
    // - Parametros:
    //   - amount: O número de jogos a buscar
    //   - completion: um handler a ser chamado com os dados recebidos
 
    public func fetchGamesLoved(amount: Int, completion: @escaping (Result<[Game], Error>) -> Void) {
        let requestBody = """
            sort rating_count desc;
            where \(platformsInRequest) & rating > 0;
        """
        fetchData(fromEndpoint: "games/?limit=10&&fields=id,genres,name,rating,screenshots.image_id,genres.name%3B", withBody: requestBody.data(using: .utf8), responseType: [Game].self, completion: completion)
    }
 
    // Busca o nome de um gênero pelo seu ID
 
    // - Parametros:
    //   - genreId: o ID do genero
    //   - completion: um handler a ser chamado com os dados recebidos

}
 
// Definir os cabeçalhos da requisição
 
extension URLRequest {
    mutating func setCommonHeaders(clientID: String, accessToken: String) {
        self.setValue(clientID, forHTTPHeaderField: "Client-ID")
        self.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        self.setValue("application/json", forHTTPHeaderField: "Accept")
    }
}

 
