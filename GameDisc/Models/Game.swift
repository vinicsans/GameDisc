struct Game: Decodable {
    let id: Int
    let name: String
    let rating: Double?
    let screenshots: [Screenshot]?
    let genres: [Genre]?
}
