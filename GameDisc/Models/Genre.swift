struct Genre: Decodable {
    let id: Int
    let name: String
}

struct Genres: Decodable {
    let genres: [Genre]
}
