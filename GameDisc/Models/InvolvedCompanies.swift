struct InvolvedCompany: Decodable {
    let id: Int
    let company: Company
}

struct Company: Decodable {
    let id: Int
    let name: String
}
