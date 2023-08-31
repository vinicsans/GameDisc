struct ReleaseDate: Decodable {
    let id: Int
    let y: Int?
}

struct ReleaseDates: Decodable {
    let ReleaseDates: [ReleaseDate]
}
