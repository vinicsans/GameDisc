struct Screenshot: Decodable {
    let id: Int
    let imageId: String
}

struct Screenshots: Decodable {
    let screenshots: [Screenshot]
}
