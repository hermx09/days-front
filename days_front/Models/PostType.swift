enum PostType: String, Codable, CaseIterable {
    case myPosts = "myPosts"
    case commented = "commented"
    case saved = "saved"
    case popular = "popular"
    case favorite = "favorite"
    case all = "all"
}
