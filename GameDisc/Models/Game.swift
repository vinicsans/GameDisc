struct Game: Decodable {
    let id: Int
    let name: String
    let ratingCount: Int?
    let screenshots: [Int]
    let genres: [Int]
}
