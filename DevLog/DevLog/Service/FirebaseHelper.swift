import Foundation

enum NetworkError: String, Error {
    case authError
    case authResultError
    case decodingError
    case dataError
    case snapshotError
    case decodeError
}
