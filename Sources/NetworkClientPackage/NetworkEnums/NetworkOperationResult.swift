import Foundation

public enum NetworkOperationResult {
    case json(_ : HTTPURLResponse?, data: Data?)
    case file(_ : URL?, _ : HTTPURLResponse?)
    case error(_ : Error?, _ : HTTPURLResponse?)
    case noInterNet(_ : NetworkMessages?)
}
